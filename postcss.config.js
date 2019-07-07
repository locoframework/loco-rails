/* global module require */

module.exports = {
  ident: "postcss",
  sourceMap: true,
  plugins: [require("postcss-flexbugs-fixes"), require("autoprefixer")]
};
