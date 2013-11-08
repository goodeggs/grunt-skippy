require 'should'
grunt = require 'grunt'
exec = require('child_process').exec

execGrunt = (target, cb) ->
  exec './node_modules/.bin/grunt --no-color '+target, (error, stdout, stderr) ->
    cb(error or stderr or null, stdout)

describe 'skippy:uglifyjs', ->
  out = null
  beforeEach (done) ->
    execGrunt 'skippy:uglify:test', (err, stdout) ->
      out = stdout
      done(err)

  describe 'the first run', ->
    it 'runs uglify', ->
      out.should.contain 'Running "uglify:test"'

  describe 'the second run', ->
    it 'skips uglify', (done) ->
      execGrunt 'skippy:uglify:test', (err, stdout) ->
        stdout.should.contain 'Matches cache'
        stdout.should.not.contain 'Running "uglify:test"'
        done(err)

  describe 'rerun after changing source files', ->
    beforeEach ->
      grunt.file.copy 'test/fixtures/butter.js', 'test/fixtures/other_butter.js',
        process: (contents) ->
          contents.replace 'peanut', 'almond'

    it 'runs uglify', (done) ->
      execGrunt 'skippy:uglify:test', (err, stdout) ->
        stdout.should.contain 'Source files changed'
        stdout.should.contain 'Running "uglify:test"'
        done(err)

  describe 'rerun after removing a destination file', ->
    beforeEach ->
      grunt.file.delete 'tmp/sandwich.js'

    it 'runs uglify', (done) ->
      execGrunt 'skippy:uglify:test', (err, stdout) ->
        stdout.should.contain 'Missing dest file'
        stdout.should.contain 'Running "uglify:test"'
        done(err)
