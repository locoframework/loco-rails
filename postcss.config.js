/* eslint-env node */

module.exports = {
  ident: "postcss",
  sourceMap: true,
  plugins: [
    require("autoprefixer"),
    require("cssnano"),
    require("postcss-nested")
  ]
};
