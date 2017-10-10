const environment = require('./environment')

environment.plugins.set(
  'UglifyJs',
  new webpack.optimize.UglifyJsPlugin({
    compress: {
      warnings: false
    }
  })
)

module.exports = environment.toWebpackConfig()