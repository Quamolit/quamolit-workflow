
Quamolit Workflow
----

> project template for [quamolit.calcit](https://github.com/Quamolit/quamolit).

### Usages

Install Node.js 24 and [Calcit](https://github.com/calcit-lang/calcit) 0.18.1 first. Dependencies are declared in `deps.cirru` and fetched by `caps`:

```bash
corepack enable
yarn install --immutable
caps --ci
calcit calcit.cirru js
yarn vite
```

Also check out `.github/workflows/upload.yaml` for an example.

This Calcit 0.18.1 migration pins Quamolit `0.0.18-alpha.1`. The current entry
is a compile-only bootstrap; the original Canvas application remains in
`app.main` and still needs strict-type migration before it can be restored.

### Workflow

https://github.com/Quamolit/quamolit-workflow

### License

MIT
