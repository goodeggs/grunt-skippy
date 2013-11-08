/*
 * grunt-skippy
 *
 * Licensed under the MIT license.
 */

'use strict';

var pkg = require('../package.json');

module.exports = function(grunt) {

  grunt.registerTask('skippy', pkg.description, function(task, target) {
    var crypto = require('crypto'),
        _ = require('underscore'),

        cacheFilePath = 'tmp/skippy.json',
        cachedDigests = {};

    if(grunt.file.exists(cacheFilePath)) {
      cachedDigests = grunt.file.readJSON(cacheFilePath);
    }

    // read
    var nameArgs = [task, target].join(':'),
        data = grunt.config.get([task, target].join('.')),
        files = grunt.task.normalizeMultiTaskFiles(data, target),
        filesSrc = _(files).chain().pluck('src').flatten().sort().uniq(true).value(),
        filesDest = _(files).chain().pluck('dest').uniq().value(),

        missingDest = null;

    filesDest.forEach(function(filePath) {
      if(!grunt.file.exists(filePath)) {
        missingDest = filePath;
      }
    });

    var hash = crypto.createHash('md5');
    filesSrc.forEach(function(filePath) {
      hash.update(grunt.file.read(filePath));
    });

    var digest = hash.digest('hex');
    grunt.log.writeln('Source files: '+digest);

    var cached = cachedDigests[nameArgs];
    if(digest === cached && !missingDest) {
      grunt.log.ok('Matches cache.  Skipping '+nameArgs);
      return;
    } else if(!cached) {
      grunt.log.writeln('>>'.yellow + ' No cached results');
    } else if(missingDest) {
      grunt.log.writeln('>>'.yellow + ' Missing dest file');
    } else {
      grunt.log.writeln('>>'.yellow + ' Source files changed');
    }

    grunt.task.run(nameArgs);

    // TODO: write after command succeeds
    cachedDigests[nameArgs] = digest;
    grunt.file.write(cacheFilePath, JSON.stringify(cachedDigests, null, '  '));
  });
};
