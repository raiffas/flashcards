import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

export default defineConfig({
  plugins: [react()],
  server: {
    // Forward /api calls to Flask so the frontend needs no CORS setup
    proxy: { "/api": "http://localhost:5000" },
  },
});
