module.exports = {
  ident: "postcss",
  sourceMap: true,
  plugins: [
    /* eslint-disable import/no-extraneous-dependencies, global-require */
    require("postcss-flexbugs-fixes"),
    require("autoprefixer")
    /* eslint-enable import/no-extraneous-dependencies, global-require */
  ]
};
