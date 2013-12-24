module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    coffee:
      options:
        sourceMap: true
      build:
        files:
          'js/ice.js': ['src/ice.coffee']
    uglify:
      options:
        banner: '/*~ <%= pkg.name %=> <%= grunt.template.today("yyyy-mm-dd") %=> */\n'
        mangle: false
      build:
        files:
          'js/ice.min.js': 'js/ice.js'

    concat:
      options:
        separator: ';'
      build:
        src: ['vendor/*.js', 'js/ice.min.js']
        dest: 'dist/ice.min.js'

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-concat'

  grunt.registerTask 'default', ['coffee', 'uglify', 'concat']
