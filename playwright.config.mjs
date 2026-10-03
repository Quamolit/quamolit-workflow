import { defineConfig } from "@playwright/test";
export default defineConfig({
  testDir: "./test",
  use: {
    baseURL: "http://127.0.0.1:5196",
    viewport: { width: 1000, height: 700 },
  },
  webServer: {
    command: "yarn vite preview --host 127.0.0.1 --port 5196 --strictPort",
    url: "http://127.0.0.1:5196",
    reuseExistingServer: false,
  },
});
