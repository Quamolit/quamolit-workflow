# Quamolit Workflow

Quamolit 的 Calcit 项目模板 / A Calcit starter for Quamolit.

模板保留原来的灰色斜线，并提供三个错峰进入的图表条形组件。点击「切换数据」会从当前中间帧开始渐变，允许在动画尚未结束时再次切换；暂停后调整窗口尺寸仍会更新画面。

## 开始使用

需要 Node.js 24、Calcit CLI 0.28.0 和 `caps`。Calcit JavaScript runtime 同步使用 0.28.0，Yarn 使用 `node-modules` linker。

```bash
corepack enable
yarn install --immutable
yarn compile
yarn dev --port 5195 --strictPort
```

打开 http://127.0.0.1:5195/。默认自动播放；`/?t=0.35` 可暂停在确定的中间帧。

## 组件和动画

`calcit.cirru` 是源码，主要定义集中在 `app.main` entry：

- `initial`、`values-at`、`toggle` 定义不可变模型和纯函数时间采样。每个条形错开 0.1 秒，渐变持续 0.5 秒。
- `declare` 返回公开的 Scene 与 Motion 声明，`start`、`update-plan` 使用 Quamolit 的组件计划 API；仅时间变化时复用声明，模型或视口版本变化时重建。
- `draw!` 通过类型化 Canvas API 处理 DPR 和绘制。`main!` 用作编译入口及声明检查。
- `main.mjs` 只负责 DOM 按钮、RAF、窗口尺寸和卸载，不需要手动引用 Quamolit 内部 JavaScript 文件。

当前组件计划 API 仍属实验接口。依赖固定到已发布 Quamolit `0.0.18-alpha.4`，包含公共 tween 精确终帧修复，不引用未发布 main 或提交 hash。这个最小模板不代表完整的组件卸载/出场动画示例。

## 验证

```bash
yarn playwright install chromium
yarn test
yarn format:check
```

四项回归覆盖纯函数中间帧、动画连续打断、1000 帧声明复用、暂停后视口更新、默认 RAF 播放、卸载，以及生产构建 DPR 1/2 的独立矩形像素参考。计数检查不是性能基准。截图和编译结果留在忽略目录，不入库。

CI 配置见 `.github/workflows/upload.yaml`。修改 Calcit snapshot 请使用 CLI 的 `edit`/`tree`/`cursor`/`config` 接口，不要将其当成生成文件或手工批量改写。

## 前端部署

COS 只上传 `dist/`，使用正式 `cos-upload-action@v1.2.0` 的内置
`public-base-url` 逐文件校验，不增加上传验证脚本。PR CDN 前缀为
`Quamolit/quamolit-workflow/pr/<PR编号>/<run>/<attempt>/`，原
`https://repo.tiye.me/Quamolit/quamolit-workflow/pr/<PR编号>/` 预览入口不变。
原生产构建先通过浏览器回归，再从同一源码构建 CDN 资源，校验成功后上传 HTML。
仅同仓库 PR 和原手动部署事件上传；fork PR 只测试 / 构建，main push 不部署。
生产 COS 前缀 `Quamolit/quamolit-workflow/`、web-assets 路径和手动部署条件不变，
队列不取消执行中的上传。需要仓库或组织提供 `COS_BUCKET`、`COS_SECRET_ID`、`COS_SECRET_KEY`。

## English

A runnable Calcit 0.28.0 starter using Quamolit's public typed component declarations, motion sampling and retained plans. It preserves the original line and adds three staggered chart bars with interruptible data transitions. Browser JavaScript handles lifecycle only. Run `yarn compile`, then `yarn dev`; `yarn test` checks production rendering and deterministic frames. The component-plan API is experimental and pinned to published Quamolit `0.0.18-alpha.4`, including the tween endpoint fix.

## License

MIT
