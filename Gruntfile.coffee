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
          'uglifyjs.js' : 'uglifyjs/browser/uglifyjs.js'

      ,
    coffee:
      options:
        sourceMap: true
      build:
        files:
          'js/draw.js': ['src/draw.coffee']
          'js/model.js': ['src/model.coffee']
          'js/view.js': ['src/view.coffee']
          'js/controller.js': ['src/controller.coffee']
          'js/coffee.js': ['src/coffee.coffee']
          'js/parser.js': ['src/parser.coffee']
          'js/main.js': ['src/main.coffee']
          'js/helper.js': ['src/helper.coffee']
          'test/js/parserTests.js': ['test/coffee/parserTests.coffee']

          'test/js/tests.js': ['test/coffee/tests.coffee']
          'example/example.js': ['example/example.coffee']
          'example/test.js': ['example/test.coffee']

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
          paths:
            'coffee-script': '../vendor/coffee-script'
            'ice-view': 'view'
            'ice-controller': 'controller'
            'ice-model': 'model'
            'ice-draw': 'draw'
            'ice-coffee': 'coffee'
            'ice-parser': 'parser'
            'ice-helper': 'helper'
            'ice': 'main'
          name: 'ice'
          optimize: 'none'
          out: 'dist/ice.js'

    cssmin:
      options:
        banner: '''
           /* ICE Editor stylesheet.
           Copyright (c) 2014 Anthony Bau.
           MIT License.
           */'''
      minify:
        src: ['css/ice.css']
        dest: 'dist/ice.min.css'
        ext: '.min.css'

    concat:
      options:
        banner: '''
           /* ICE Editor.
           Copyright (c) 2014 Anthony Bau.
           MIT License.
           */
           (function() {'''
        separator: ';'
        footer: '}).call(this);'
      build:
        files:
          'dist/ice-full.js': [
            'vendor/quadtree.js'
            'dist/ice.js'
          ]

    uglify:
      options:
        banner: '/*! <%= pkg.name %> ' +
                '<%= grunt.template.today("yyyy-mm-dd") %> */\n'
        sourceMap: true

      build:
        files:
          'dist/ice-full.min.js': [
            'vendor/quadtree.js'
            'dist/ice.js'
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
