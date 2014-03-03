'use strict';

var grunt = require('grunt');

/*
  ======== A Handy Little Nodeunit Reference ========
  https://github.com/caolan/nodeunit

  Test methods:
    test.expect(numAssertions)
    test.done()
  Test assertions:
    test.ok(value, [message])
    test.equal(actual, expected, [message])
    test.notEqual(actual, expected, [message])
    test.deepEqual(actual, expected, [message])
    test.notDeepEqual(actual, expected, [message])
    test.strictEqual(actual, expected, [message])
    test.notStrictEqual(actual, expected, [message])
    test.throws(block, [error], [message])
    test.doesNotThrow(block, [error], [message])
    test.ifError(value)
    */

exports.banner = {
    bannerTop: function( test ) {
        test.expect( 1 );

        var actual = grunt.file.read( 'test/tmp/some.js' );
        var expected = grunt.file.read( 'test/expected/some-banner.js' );

        test.equal( actual, expected, 'should add a banner to the top of a file' );

        test.done();
    },

    bannerBottom: function( test ) {
        test.expect( 1 );

        var actual = grunt.file.read( 'test/tmp/someBottom.js' );
        var expected = grunt.file.read( 'test/expected/some-bottom.js' );

        test.equal( actual, expected, 'should add a banner to the bottom of a file' );

        test.done();
    },

    bannerNoLineBreak: function ( test ) {
        test.expect( 1 );

        var actual = grunt.file.read( 'test/tmp/someNoLineBreak.js' );
        var expected = grunt.file.read( 'test/expected/someNoLineBreak.js' );

        test.equal( actual, expected, 'should add a banner without a linebreak' );

        test.done();
    }
};