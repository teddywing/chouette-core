const { environment } = require('@rails/webpacker')
const webpack = require('webpack')
const UglifyJsPlugin = require('uglify-js')
const CleanWebpackPlugin = require('clean-webpack-plugin')

let pathsToClean = [
  'public/packs'
];

// the clean options to use
let cleanOptions = {
  root: __dirname + '/../../',
  verbose: true,
  dry: false,
  watch: true
};


environment.plugins.set(
  'CleanWebpack',
  new CleanWebpackPlugin(pathsToClean, cleanOptions)
)

environment.plugins.set(
  'UglifyJs',
  new webpack.optimize.UglifyJsPlugin({
    compress: {
      warnings: false
    }
  })
)
// environment.plugins.set('Provide', new webpack.ProvidePlugin({
//     $: 'jquery',
//     jQuery: 'jquery',
//     jquery: 'jquery'
//   })
// )

// const config = environment.toWebpackConfig()

// config.resolve.alias = {
//   jquery: "jquery/src/jquery",
// }

module.exports = environment