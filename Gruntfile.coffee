path = require 'path'

notify = (message) ->
  grunt.util.spawn (
    cmd: 'notify-send'
    args: [message, '--urgency=low']
    fallback: 0
  ), ->

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
          'require.js' : 'requirejs/require.js'
          'acorn.js' : 'acorn/acorn.js'
          'sax.js': 'sax/lib/sax.js'

      ,
    coffee:
      options:
        sourceMap: true
      build:
        files: [
          {
            expand: true
            cwd: 'src/'
            src: ['*.coffee']
            dest: 'js/'
            ext: '.js'
          }

          {dest: 'test/js/parserTests.js', src: 'test/coffee/parserTests.coffee'}
          {dest: 'test/js/tests.js', src: 'test/coffee/tests.coffee'}

          {dest: 'example/example.js', src: 'example/example.coffee'}
          {dest: 'example/csv.js', src: 'example/csv.coffee'}
          {dest: 'example/example-js.js', src: 'example/example-js.coffee'}
          {dest: 'example/test.js', src: 'example/test.coffee'}
          {dest: 'example/html.js', src: 'example/html.coffee'}
        ]

    qunit:
      all:
        options:
          urls:
            (for x in grunt.file.expand('test/*.html')
              'http://localhost:8942/' + x)

    mocha_spawn:
      test:
        src: ['test/js/parserTests.js']
        options:
          reporter: 'list'

    docco:
      debug:
        src: ['src/*.coffee']
        options:
          output: 'docs/'
          layout: 'parallel'

    requirejs:
      compile:
        options:
          baseUrl: 'js'
          paths: require('./requirejs-paths.json')
          name: 'droplet'
          optimize: 'none'
          out: 'dist/droplet.js'

    cssmin:
      options:
        banner: '''
           /* Droplet stylesheet.
           Copyright (c) 2014 Anthony Bau.
           MIT License.
           */'''
      minify:
        src: ['css/droplet.css']
        dest: 'dist/droplet.min.css'
        ext: '.min.css'

    concat:
      options:
        banner: '''
           /* Droplet.
           Copyright (c) 2014 Anthony Bau.
           MIT License.
           */
           (function() {'''
        separator: ';'
        footer: '}).call(this);'
      build:
        files:
          'dist/droplet-full.js': [
            'vendor/sax.js'
            'vendor/quadtree.js'
            'dist/droplet.js'
          ]

    uglify:
      options:
        banner: '''
          /* Droplet.
          Copyright (c) 2014 Anthony Bau.
          MIT License.
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
      qunitserver:
        options:
          hostname: '0.0.0.0'
          port: 8942

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
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-cssmin'
  grunt.loadNpmTasks 'grunt-contrib-requirejs'
  grunt.loadNpmTasks 'grunt-contrib-qunit'
  grunt.loadNpmTasks 'grunt-mocha-spawn'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-docco'

  grunt.registerTask 'default',
    ['quickbuild']
  grunt.registerTask 'quickbuild',
    ['coffee']
  grunt.registerTask 'all',
    ['coffee', 'docco', 'requirejs', 'uglify', 'concat', 'cssmin', 'test']

  grunt.registerTask 'notify-done', ->
    notify 'Compilation complete.'

  grunt.task.registerTask 'test',
    'Run unit tests, or just one test.',
    (testname) ->
      if testname
        grunt.config 'qunit.all', ['test/' + testname + '.html']
      grunt.task.run 'connect:qunitserver'
      grunt.task.run 'qunit:all'
      grunt.task.run 'mocha_spawn'
  grunt.registerTask 'testserver', ['connect:testserver', 'watch']
  grunt.registerTask 'notify-done', ->
  grunt.util.spawn (
    cmd: 'notify-send'
    args: ['Recompiled.', '--urgency=low']
    fallback: 0), ->

  grunt.event.on 'watch', (action, filepath) ->
    if grunt.file.isMatch(grunt.config('watch.sources.files'), filepath)
      d = path.dirname filepath
      if /src|coffee$/.test(d) then d = path.dirname(d) + '/js'
      destination = d + '/' + path.basename(filepath).replace('.coffee', '.js')
      coffeeFiles = {}; coffeeFiles[destination] = [filepath]
      grunt.config 'coffee.build.files', coffeeFiles
