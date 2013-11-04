# grunt-skippy
[![Build Status](https://travis-ci.org/goodeggs/grunt-skippy.png)](https://travis-ci.org/goodeggs/grunt-skippy)

Skip multitask target if source files haven't changed.

```shell
> grunt skippy:uglify:thirdparty // The first time will run uglify:thirdparty as usual.
> grunt skippy:uglify:thirdparty // The second time it'll skip uglify since
                                 // the source files haven't changed.
```

## Getting Started
Grunt `~0.4.1`

You should be comfy with the [grunt basics](http://gruntjs.com/getting-started) and [npm](https://npmjs.org/doc/README.html) so you can install this in your project

```shell
> npm install grunt-skippy --save-dev
```

Add something like this to your Gruntfile: (uglify is just an example, use skippy with any task that transforms source files to dest files)

```js
grunt.loadNpmTasks('grunt-skippy');
grunt.loadNpmTasks('grunt-contrib-uglify');

grunt.initConfig({
  uglify: {
    thirdparty: {
      dest: 'public/build/js/thirdparty/index.js'
      src: [
        'es5-shim.js',
        'jquery-1.9.1.js',
        'underscore.js',
        'backbone.js',
        'Backbone.ModelBinder.js',
        'Backbone.CollectionBinder.js'
      ]
    }
});
```
