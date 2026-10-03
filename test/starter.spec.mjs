import { test, expect } from "@playwright/test";
import * as app from "../target/js/app/app.main.mjs";
import { to_js_data } from "../target/js/app/calcit.core.mjs";

test("组件纯采样、连续打断、1000帧计划复用与暂停视口失效", () => {
  const model = app.initial();
  const viewport = app.viewport(1000, 700);
  let plan = app.start(model, 0, viewport);
  expect(to_js_data(plan).scene.nodes).toHaveLength(4);
  expect(to_js_data(plan).scene.nodes[0].content[1].points).toEqual([
    { x: 480, y: 480 },
    { x: 520, y: 520 },
  ]);
  app
    .values_at(model, 0.35)
    .toArray()
    .forEach((value, index) => {
      expect(value).toBeCloseTo([0.3136, 0.35, 0.216][index], 12);
    });
  const changed = app.toggle(model, 0.35);
  expect(to_js_data(changed).from).toEqual(
    to_js_data(app.values_at(model, 0.35)),
  );
  expect(to_js_data(app.values_at(changed, 0.35))).toEqual(
    to_js_data(app.values_at(model, 0.35)),
  );
  for (let index = 0; index < 1000; index++)
    plan = app.update_plan(plan, model, index / 1000, viewport);
  expect(to_js_data(plan).declarations).toBe(1);
  expect(to_js_data(plan)["plan-builds"]).toBe(1);
  const at = (time) =>
    to_js_data(app.update_plan(plan, model, time, viewport)).scene;
  expect(at(0.35)).toEqual(at(0.35));
  at(4);
  expect(at(0.35)).toEqual(to_js_data(app.start(model, 0.35, viewport)).scene);
  const resized = to_js_data(
    app.update_plan(plan, model, 0.999, app.viewport(390, 700)),
  );
  expect(resized.declarations).toBe(2);
  expect(resized.time).toBe(0.999);
  expect(to_js_data(model).revision).toBe(0);
});

test("默认播放支持过期RAF首帧，切换/暂停/resize/卸载", async ({
  page,
}, testInfo) => {
  const errors = [];
  page.on("pageerror", (error) => errors.push(error.message));
  await page.addInitScript(() => {
    const raf = requestAnimationFrame.bind(window);
    let stale = true;
    window.requestAnimationFrame = (callback) =>
      raf((time) => {
        callback(stale ? time - 10000 : time);
        stale = false;
      });
  });
  await page.goto("/");
  await expect
    .poll(() => page.evaluate(() => window.starter?.snapshot().time ?? -1))
    .toBeGreaterThan(0.1);
  await page.getByRole("button", { name: "暂停", exact: true }).click();
  await page.getByRole("button", { name: "切换数据" }).click();
  expect(
    (await page.evaluate(() => window.starter.snapshot())).model.revision,
  ).toBe(1);
  const paused = (await page.evaluate(() => window.starter.snapshot())).time;
  await page.setViewportSize({ width: 390, height: 700 });
  expect((await page.evaluate(() => window.starter.snapshot())).time).toBe(
    paused,
  );
  await expect(page.locator("canvas")).toHaveCSS("width", "390px");
  await page.screenshot({ path: testInfo.outputPath("starter-resize.png") });
  await page.evaluate(() => window.starter.dispose());
  expect(await page.evaluate(() => window.starter)).toBeUndefined();
  expect(errors).toEqual([]);
});

for (const dpr of [1, 2])
  test(`生产构建中间帧与独立矩形像素参考 DPR${dpr}`, async ({
    browser,
  }, testInfo) => {
    const context = await browser.newContext({
      viewport: { width: 1000, height: 700 },
      deviceScaleFactor: dpr,
    });
    const page = await context.newPage();
    const errors = [];
    page.on("pageerror", (error) => errors.push(error.message));
    await page.goto("/?t=0.35");
    const got = await page.evaluate(() => {
      const canvas = document.querySelector("canvas");
      const context = canvas.getContext("2d");
      const target = [0.4, 0.7, 1];
      const widths = target.map((end, index) => {
        const phase = Math.max(0, Math.min(1, (0.35 - index * 0.1) / 0.5));
        return 480 * end * phase * phase * (3 - 2 * phase);
      });
      const samples = widths.map((width, index) => {
        const y = 280 + index * 52 + 16;
        const inside = [
          ...context.getImageData(
            Math.floor((260 + width / 2) * devicePixelRatio),
            y * devicePixelRatio,
            1,
            1,
          ).data,
        ];
        const outside = [
          ...context.getImageData(
            Math.ceil((260 + width + 5) * devicePixelRatio),
            y * devicePixelRatio,
            1,
            1,
          ).data,
        ];
        return { inside, outside };
      });
      return {
        widths: window.starter
          .snapshot()
          .plan.scene.nodes.slice(1)
          .map((node) => node.content[1].width),
        samples,
        width: canvas.width,
      };
    });
    expect(got.width).toBe(1000 * dpr);
    for (let index = 0; index < 3; index++) {
      expect(got.widths[index]).toBeCloseTo([150.528, 168, 103.68][index], 9);
      expect(got.samples[index].inside).toEqual([
        Math.round(255 * (0.2 + index * 0.2)),
        179,
        217,
        255,
      ]);
      expect(got.samples[index].outside).toEqual([17, 23, 37, 255]);
    }
    await page.screenshot({
      path: testInfo.outputPath(`starter-mid-dpr${dpr}.png`),
    });
    expect(errors).toEqual([]);
    await context.close();
  });
