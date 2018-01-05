const path = require('path');
const express = require('express');
const webpack = require('webpack');
const webpackDevMiddleware = require('webpack-dev-middleware');

const rootPath = '..';

const app = express();
const config = require(`${rootPath}/webpack.config.js`);
const compiler = webpack(config);

app.use(webpackDevMiddleware(compiler, {
  publicPath: config.output.publicPath
}));

app.get('/', function(req, res) {
  res.sendFile(path.join(__dirname, `${rootPath}/dev/`));
});

app.listen(3000, function () {
  console.log('Example app listening on port 3000!\n');
});
