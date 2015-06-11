path = require 'path'

serveNoDottedFiles = (connect, options, middlewares) ->
  # Avoid leaking .git/.svn or other dotted files from test servers.
  middlewares.unshift (req, res, next) ->
    if req.url.indexOf('/.') < 0 then return next()
    res.statusCode = 404
    res.setHeader('Content-Type', 'text/html')
    res.end "Cannot GET #{req.url}"
  return middlewares

module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    bowercopy:
      options:
        clean: true
      vendor:
        options:
          destPrefix: 'vendor'
        files:
          'ace' : 'ace-builds/src-noconflict'
          'coffee-script.js' : 'coffee-script/extras/coffee-script.js'
          'quadtree.js' : 'quadtree/quadtree.js'
          'qunit.js' : 'qunit/qunit/qunit.js'
          'qunit.css' : 'qunit/qunit/qunit.css'
          'acorn.js' : 'acorn/acorn.js'
          'sax.js': 'sax/lib/sax.js'

    qunit:
      all:
        options:
          timeout: 30000
          urls:
            (for x in grunt.file.expand('test/*.html')
              'http://localhost:8942/' + x)

    mocha_spawn:
      test:
        src: ['test/js/parserTests.js']
        options:
          reporter: 'list'

    coffee:
      quickbuild_prep:
        files: [{
          expand: true
          cwd: 'src/'
          src: ['*.coffee']
          dest: 'js/'
          ext: '.js'
        }]

    browserify:
      build:
        files:
          'dist/droplet-full.js': ['src/main.coffee']
        options:
          transform: ['coffeeify']
          browserifyOptions:
            standalone: 'droplet'
            noParse: [
              require.resolve('./vendor/coffee-script')
              require.resolve('./vendor/acorn')
            ]
          banner: '''
          /* Droplet.
           * Copyright (c) <%=grunt.template.today('yyyy')%> Anthony Bau.
           * MIT License.
           *
           * Date: <%=grunt.template.today('yyyy-mm-dd')%>
           */
          '''
      test:
        files:
          'test/js/tests.js': ['test/src/tests.coffee']
          'test/js/uitest.js': ['test/src/uitest.coffee']
          'test/js/jstest.js': ['test/src/jstest.coffee']
          'test/js/cstest.js': ['test/src/cstest.coffee']
        options:
          transform: ['coffeeify']
          browserifyOptions:
            noParse: [
              require.resolve('./vendor/coffee-script')
              require.resolve('./vendor/acorn')
              require.resolve('./dist/droplet-full')
            ]

    cssmin:
      options:
        banner: '''
          /* Droplet. | (c) <%=grunt.template.today('yyyy')%> Anthony Bau. | MIT License.
           */
          '''
      minify:
        src: ['css/droplet.css']
        dest: 'dist/droplet.min.css'
        ext: '.min.css'

    uglify:
      options:
        banner: '''
          /* Droplet. | (c) <%=grunt.template.today('yyyy')%> Anthony Bau. | MIT License.
           */
        '''
        sourceMap: true

      build:
        files:
          'dist/droplet-full.min.js': [
            'vendor/sax.js'
            'vendor/quadtree.js'
            'dist/droplet.js'
          ]

    connect:
      testserver:
        options:
          hostname: '0.0.0.0'
          middleware: serveNoDottedFiles
      qunitserver:
        options:
          hostname: '0.0.0.0'
          port: 8942
          middleware: serveNoDottedFiles

    watch:
      options:
        nospawn: true
        livereload: true
      sources:
        files: ['src/*.coffee', 'example/*.coffee']
        tasks: ['quickbuild', 'notify-done']

  grunt.loadNpmTasks 'grunt-bowercopy'
  grunt.loadNpmTasks 'grunt-banner'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-cssmin'
  grunt.loadNpmTasks 'grunt-contrib-qunit'
  grunt.loadNpmTasks 'grunt-mocha-spawn'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-browserify'

  grunt.registerTask 'default',
    ['quickbuild']

  grunt.registerTask 'build',
    ['browserify:build']

  grunt.registerTask 'dist',
    ['build', 'uglify', 'cssmin']

  grunt.registerTask 'buildtests',
    ['browserify:test']

  grunt.registerTask 'all',
    ['dist', 'buildtests', 'test']

  grunt.task.registerTask 'test',
    'Run unit tests, or just one test.',
    (testname) ->
      if testname
        grunt.config 'qunit.all', ['test/' + testname + '.html']
      else
        grunt.config 'qunit.all', (x for x in grunt.file.expand('test/*.html'))
      grunt.task.run 'connect:qunitserver'
      grunt.task.run 'qunit:all'
      grunt.task.run 'mocha_spawn'

  grunt.registerTask 'testserver', ['coffee:quickbuild_prep', 'connect:testserver', 'watch']

  grunt.event.on 'watch', (action, filepath) ->
    if grunt.file.isMatch(grunt.config('watch.sources.files'), filepath)
      d = path.dirname filepath
      if /src|coffee$/.test(d) then d = path.dirname(d) + '/js'
      destination = d + '/' + path.basename(filepath).replace('.coffee', '.js')
      coffeeFiles = {}; coffeeFiles[destination] = [filepath]
      grunt.config 'coffee.build.files', coffeeFiles
