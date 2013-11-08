module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)
  grunt.loadTasks 'tasks'

  grunt.initConfig
    jshint:
      all: 'tasks/*.js'
      options:
          curly: true
          eqeqeq: true
          immed: true
          latedef: true
          newcap: true
          noarg: true
          sub: true
          undef: true
          boss: true
          eqnull: true
          node: true

    clean:
      tests: [
        'tmp'
        'test/fixtures/other_butter.js'
      ]

    relativeRoot: {

      simple: {
        src: 'test/fixtures/stylish.css',
        dest: 'tmp/simple/stylish.css'
      },

      fancy: {
        options: {
          root: 'test/fixtures/'
        },
        files: [{
          expand: true,
          cwd: '<%= relativeRoot.fancy.options.root %>',
          src: ['*.css', '*.html'],
          dest: 'tmp/fancy/'
        }]
      }
    }

    simplemocha:
      all: 'test/*.test.coffee'

    uglify:
      options:
        compress: false

      test:
        src: 'test/fixtures/*.js'
        dest: 'tmp/sandwich.js'

  grunt.registerTask 'test', ['clean', 'jshint', 'simplemocha']

  grunt.registerTask 'default', ['test']
