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
            'coffee-script': '../vendor/coffee-script'
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

    uglify:
      options:
        banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
      build:
        files:
          'dist/ice.min.js': ['dist/ice.js']

    cssmin:
      options:
        banner: '/* ICE Editor stylesheet.\nCopyright (c) 2014 Anthony Bau.\nMIT License.\n*/'
      minify:
        src: ['css/ice.css']
        dest: 'dist/ice.min.css'
        ext: '.min.css'

    concat:
      options:
        banner: '/*! ICE Editor.\n Copyright (c) 2014 Anthony Bau\n MIT License\n*/\n(function() {'
        separator: ';'
        footer: "}).call(this);;"
      build:
        files:
          'dist/ice-full.min.js': ['vendor/keypress-2.0.1.min.js', 'dist/ice.min.js']
          'dist/ice-full.js': ['vendor/keypress-2.0.1.min.js', 'dist/ice.js']
  
  grunt.loadNpmTasks 'grunt-banner'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-qunit'
  grunt.loadNpmTasks 'grunt-docco'
  grunt.loadNpmTasks 'grunt-contrib-requirejs'
  grunt.loadNpmTasks 'grunt-contrib-cssmin'

  grunt.registerTask 'default', ['coffee', 'docco', 'requirejs', 'concat']
  grunt.registerTask 'all', ['coffee', 'docco', 'requirejs', 'uglify', 'concat']
  grunt.registerTask 'test', ['qunit']
