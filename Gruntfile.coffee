module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
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

          'test/tests.js': ['src/tests.coffee']
          'example/example.js': ['example/example.coffee']

    uglify:
      options:
        banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
        mangle: false
      build:
        files:
          'js/tests.min.js': 'js/tests.js'
          'js/draw.min.js':'js/draw.js'

    concat:
      options:
        separator: ';'
      build:
        files:
          'dist/ice.min.js': ['vendor/underscore-min.js', 'vendor/coffee-script.js', 'js/draw.min.js', 'js/ice.min.js']
          'dist/tests.min.js': ['vendor/qunit.min.js', 'js/tests.min.js']

    qunit:
      all: ['test/*.html']

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
            'ice-view': 'view'
            'ice-controller': 'controller'
            'ice-model': 'model'
            'ice-draw': 'draw'
            'ice-coffee': 'coffee'
            'ice-parser': 'parser'
            'ice': 'main'
          name: 'ice'
          optimize: 'none'
          out: 'dist/ice.js'
  
  grunt.loadNpmTasks 'grunt-banner'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-qunit'
  grunt.loadNpmTasks 'grunt-docco'
  grunt.loadNpmTasks 'grunt-contrib-requirejs'

  grunt.registerTask 'default', ['coffee', 'docco', 'requirejs']
  grunt.registerTask 'all', ['coffee', 'uglify', 'concat', 'qunit']
  grunt.registerTask 'test', ['qunit']
