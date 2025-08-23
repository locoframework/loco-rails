import js from "@eslint/js";
import configPrettier from "eslint-config-prettier";
import pluginPrettier from "eslint-plugin-prettier";
import pluginReact from "eslint-plugin-react";
import reactRecommended from "eslint-plugin-react/configs/recommended.js";
import globals from "globals";

export default [
  { ignores: ["test/dummy/app/assets/bundles/"] },
  js.configs.recommended,
  reactRecommended,
  {
    languageOptions: {
      ecmaVersion: "latest",
      sourceType: "module",
      parserOptions: {
        ecmaFeatures: { jsx: true },
      },
      globals: {
        ...globals.browser,
        ...globals.node,
      },
    },
    plugins: {
      prettier: pluginPrettier,
      react: pluginReact,
    },
    settings: {
      react: { version: "detect" },
      "import/resolver": {
        webpack: {
          config: {
            resolve: {
              modules: ["css", "js", "node_modules"],
            },
          },
        },
      },
    },
    rules: {
      "prettier/prettier": "error",
    },
  },
  configPrettier,
];
