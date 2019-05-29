const path = require("path");
/* eslint-disable import/no-extraneous-dependencies */
const CleanWebpackPlugin = require("clean-webpack-plugin");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
/* eslint-enable import/no-extraneous-dependencies */

const postCssOptions = require("./postcss.config.js");

module.exports = {
  resolve: {
    modules: [
      path.join(__dirname, "test/dummy/frontend/css"),
      path.join(__dirname, "test/dummy/frontend/js"),
      "node_modules"
    ]
  },
  entry: {
    application: "./test/dummy/frontend/index"
  },
  module: {
    rules: [
      { test: /\.js$/, exclude: /node_modules/, loader: "babel-loader" },
      {
        test: /\.coffee$/,
        use: [
          {
            loader: "coffee-loader",
            options: {
              transpile: {
                presets: ["env"]
              }
            }
          }
        ]
      },
      {
        test: /\.css$/,
        use: [
          MiniCssExtractPlugin.loader,
          "css-loader",
          { loader: "postcss-loader", options: postCssOptions }
        ]
      },
      {
        test: /\.(sass|scss)$/,
        use: [
          MiniCssExtractPlugin.loader,
          "css-loader",
          { loader: "postcss-loader", options: postCssOptions },
          { loader: "sass-loader" }
        ]
      }
    ]
  },
  plugins: [
    new CleanWebpackPlugin(),
    new MiniCssExtractPlugin({
      filename: "[name].css"
    })
  ],
  optimization: {
    splitChunks: {
      cacheGroups: {
        commons: {
          chunks: "initial",
          minChunks: 2,
          maxInitialRequests: 5, // The default limit is too small to showcase the effect
          minSize: 0 // This is example is too small to create commons chunks
        },
        vendor: {
          test: /node_modules/,
          chunks: "initial",
          name: "vendor",
          priority: 10,
          enforce: true
        }
      }
    }
  },
  output: {
    filename: "[name].js",
    path: path.resolve(__dirname, "test/dummy/app/assets/bundles")
  }
};
