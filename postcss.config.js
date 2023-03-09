module.exports = {
  ident: "postcss",
  sourceMap: true,
  plugins: [
    require("postcss-import"),
    require("postcss-nested"),
    require("autoprefixer"),
  ],
};
