import { defineConfig } from 'vite';
import reactRefresh from '@vitejs/plugin-react';
import createReScriptPlugin from '@jihchi/vite-plugin-rescript';

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [reactRefresh(), createReScriptPlugin()],
  test: {
    include: ['__tests__/**/*.test.bs.js'],
    globals: true,
    environment: 'jsdom'
  },
});