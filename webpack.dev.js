/* eslint-disable import/no-extraneous-dependencies */
const merge = require("webpack-merge");
/* eslint-enable import/no-extraneous-dependencies */
const common = require("./webpack.common.js");

module.exports = merge(common, {
  mode: "development",
  devtool: "inline-source-map"
});
