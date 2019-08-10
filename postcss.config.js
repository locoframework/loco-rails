/* eslint-env node */

module.exports = {
  ident: "postcss",
  sourceMap: true,
  plugins: [
    require("postcss-flexbugs-fixes"),
    require("autoprefixer"),
    require("cssnano")()
  ]
};
