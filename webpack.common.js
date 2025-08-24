const path = require("path");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");

const postcssOptions = require("./postcss.config.js");

module.exports = {
  cache: {
    type: "filesystem",
  },
  resolve: {
    extensions: [".js", ".jsx", ".json"],
    modules: [
      path.join(__dirname, "test/dummy/frontend/css"),
      path.join(__dirname, "test/dummy/frontend/js"),
      "node_modules",
    ],
  },
  entry: {
    application: "./test/dummy/frontend/index",
  },
  module: {
    rules: [
      {
        test: /\.jsx?$/,
        exclude: /node_modules/,
        use: {
          loader: "babel-loader",
          options: { cacheDirectory: true },
        },
      },
      {
        test: /\.css$/,
        use: [
          MiniCssExtractPlugin.loader,
          {
            loader: "css-loader",
            options: { importLoaders: 1 },
          },
          {
            loader: "postcss-loader",
            options: { postcssOptions: postcssOptions },
          },
        ],
      },
    ],
  },
  plugins: [
    new MiniCssExtractPlugin({
      filename: "[name].css",
    }),
  ],
  optimization: {
    splitChunks: {
      cacheGroups: {
        commons: {
          chunks: "initial",
          name: "commons",
          minChunks: 2,
          minSize: 5000, // The default is too small to create commons chunks
        },
        vendor: {
          test: /node_modules/,
          chunks: "all",
          name: "vendor",
        },
      },
    },
  },
  output: {
    path: path.resolve(__dirname, "test/dummy/app/assets/bundles"),
    publicPath: "/assets/",
    clean: true,
  },
  performance: { hints: false },
};
