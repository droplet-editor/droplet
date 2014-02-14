module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    coffee:
      options:
        sourceMap: true
      build:
        files:
          'js/draw.js': ['src/draw.coffee']
          'js/ice.js': ['src/model.coffee', 'src/view.coffee', 'src/controller.coffee']
          'js/tests.js': ['test/tests.coffee']
          'js/coffee.js': ['src/coffee.coffee']

    uglify:
      options:
        banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
        mangle: false
      build:
        files:
          'js/ice.min.js': 'js/ice.js'
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
  
  grunt.loadNpmTasks 'grunt-banner'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-qunit'
  grunt.loadNpmTasks 'grunt-docco'

  grunt.registerTask 'default', ['coffee', 'uglify', 'concat', 'docco']
  grunt.registerTask 'all', ['coffee', 'uglify', 'concat', 'qunit']
  grunt.registerTask 'test', ['qunit']
