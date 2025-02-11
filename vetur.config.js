// vetur.config.js
/** @type {import('vls').VeturConfig} */
module.exports = {
  settings: {
    "vetur.useWorkspaceDependencies": true,
    "vetur.experimental.templateInterpolationService": true,
  },
  projects: [
    {
      // 🏠 Frontend project root
      root: "./frontend",
      package: "./package.json",
      snippetFolder: "./.vscode/vetur/snippets",
      globalComponents: ["./src/components/**/*.vue"],
    },
    {
      // 🏠 Backend project (if needed, though Vetur is mainly for Vue frontend)
      root: "./backend",
      package: "./package.json",
      snippetFolder: "./.vscode/vetur/snippets",
      globalComponents: [],
    },
  ],
};
