const { environment } = require('@rails/webpacker')
const coffee =  require('./loaders/coffee')
const CleanWebpackPlugin = require('clean-webpack-plugin')

let pathsToClean = [
  'public/packs'
];

// the clean options to use
let cleanOptions = {
  root: __dirname + '/../../',
  verbose: true,
  dry: false
};


environment.plugins.set(
  'CleanWebpack',
  new CleanWebpackPlugin(pathsToClean, cleanOptions)
)

// const config = environment.toWebpackConfig()

// config.resolve.alias = {
//   jquery: "jquery/src/jquery",
// }

environment.loaders.append('coffee', coffee)
module.exports = environment
