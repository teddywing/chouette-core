module.exports = (grunt) =>
  javascriptSpecPath = (path) ->
    grunt.log.debug "IN: " + path
    path = path.replace 'app/javascript', 'spec/javascript'
    if path.match /actions/
      path = path.replace /actions.*/, 'actions_spec.js'
    if path.match /reducers/
      path = path.replace '.js', '_spec.js'
    grunt.log.debug "OUT: " + path
    path

  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    watch:
      javascripts:
        files: ['app/javascript/**/*', 'spec/javascript/**/*']
        tasks: []
        options:
          spawn: false

    watchchange:
      javascript:
        match: ['app/javascript/**/*', 'spec/javascript/**/*']
        setConfig: ['jest.run.src']
        preprocess: javascriptSpecPath
        tasks: ['jest:run']

    jest:
      run:
        files: []

  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-watch-change')

  # Default task(s).
  grunt.registerMultiTask 'jest', 'run javascript specs', () ->
    files = []
    this.files.forEach (file) ->
      files.push file.src
    grunt.log.debug files
    grunt.util.spawn
      cmd: 'node_modules/.bin/jest'
      args: files
      opts: {stdio: 'inherit'}
    , -> {}

  grunt.registerTask 'default', ['watchchange', 'watch']
