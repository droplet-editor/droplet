# grunt-docco

Grunt Docco plugin.

## Getting Started
Install this grunt plugin next to your project's [grunt.js gruntfile][getting_started] with: `npm install grunt-docco --save-dev`

Then add this line to your project's `grunt.js` gruntfile:

```javascript
grunt.loadNpmTasks('grunt-docco');
```

[grunt]: https://github.com/cowboy/grunt
[getting_started]: https://github.com/cowboy/grunt/blob/master/docs/getting_started.md

## Documentation

Add the task config to the grunt initConfig block.

```
docco: {
  debug: {
    src: ['test/**/*.js'],
    options: {
      output: 'docs/'
    }
  }
}

```

## Contributing
In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality. Lint and test your code using [grunt][grunt].

## Release History
0.3.1: Update to use #development docco - fixes several issues with multiple runs.
0.3.0: Removed dependency on python's pygments. Use latest libraries.
0.2.0: Early release, depended on python's pygments.

## License
Copyright (c) 2012 David Souther  
Licensed under the MIT license.
