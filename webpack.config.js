var webpack = require('webpack')
var path = require('path')

module.exports = {
  entry: './src/index.js',
  output: {
    path: './build',
    filename: 'index.js'
  },
  module: {
    loaders: [
      {
        test: /\.elm/,
        loader: 'elm-simple-loader',
        include: path.join(__dirname, 'src'),
        exclude: /node_modules/
      }, {
        test: /\.(html)/,
        include: path.join(__dirname, 'src'),
        loader: 'file?name=[name].[ext]'
      }
    ]
  }
}
