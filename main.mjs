// 浏览器接线仅导入应用自己的编译产物；组件/动画/执行计划由 Calcit 声明。
import * as app from "./target/js/app/app.main.mjs";
import { init_tags, to_js_data } from "./target/js/app/calcit.core.mjs";

app.main_$x_();
const tags = init_tags(["declarations", "plan-builds"]);
const canvas = document.querySelector("canvas");
const context = canvas.getContext("2d");
const params = new URLSearchParams(location.search);
let time = Number(params.get("t") ?? 0);
if (!Number.isFinite(time) || time < 0) time = 0;
let model = app.initial();
let plan = app.start(model, time, app.viewport(innerWidth, innerHeight));
let playing = !params.has("t");
let last = performance.now();
let frame;
let closed = false;
const play = document.querySelector("#play");
const output = document.querySelector("output");

function paint() {
  const dpr = devicePixelRatio || 1;
  const width = Math.round(innerWidth * dpr);
  const height = Math.round(innerHeight * dpr);
  if (canvas.width !== width || canvas.height !== height) {
    canvas.width = width;
    canvas.height = height;
  }
  plan = app.update_plan(
    plan,
    model,
    time,
    app.viewport(innerWidth, innerHeight),
  );
  app.draw_$x_(context, plan, innerWidth, innerHeight, dpr);
  play.textContent = playing ? "暂停" : "播放";
  output.textContent = `${time.toFixed(2)} s · 声明 ${plan.get(tags.declarations)} 次 · 计划 ${plan.get(tags["plan-builds"])} 次`;
}

function tick(now) {
  if (closed) return;
  if (playing && !document.hidden) {
    time += Math.max(0, Math.min((now - last) / 1000, 0.1));
    paint();
  }
  last = now;
  frame = requestAnimationFrame(tick);
}
function switchData() {
  model = app.toggle(model, time);
  paint();
}
function toggle() {
  playing = !playing;
  last = performance.now();
  paint();
}
const listeners = [];
function listen(target, type, callback) {
  target.addEventListener(type, callback);
  listeners.push(() => target.removeEventListener(type, callback));
}
listen(play, "click", toggle);
listen(document.querySelector("#switch"), "click", switchData);
listen(window, "resize", paint);
listen(document, "visibilitychange", () => {
  last = performance.now();
});
function dispose() {
  if (closed) return;
  closed = true;
  cancelAnimationFrame(frame);
  listeners.forEach((remove) => remove());
  delete window.starter;
}
window.starter = {
  seek(seconds) {
    if (!Number.isFinite(seconds) || seconds < 0)
      throw new Error("invalid time");
    time = seconds;
    playing = false;
    paint();
  },
  snapshot: () => ({
    time,
    playing,
    model: to_js_data(model),
    plan: to_js_data(plan),
  }),
  dispose,
};
paint();
frame = requestAnimationFrame(tick);
listen(window, "pagehide", dispose);
if (import.meta.hot) {
  import.meta.hot.accept();
  import.meta.hot.dispose(dispose);
}
