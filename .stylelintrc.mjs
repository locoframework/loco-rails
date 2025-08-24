export default {
  extends: ["stylelint-config-standard"],
  ignoreFiles: ["node_modules/**", "test/dummy/app/assets/bundles/**"],
  overrides: [
    {
      files: ["test/dummy/frontend/css/scaffold.css"],
      rules: {
        "selector-class-pattern": null,
      },
    },
  ],
};
