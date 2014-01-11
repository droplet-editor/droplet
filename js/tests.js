(function() {
  test('Lisp unity', function() {
    var testString;
    testString = function(string) {
      return equal(ICE.lispParse(string).toString({
        indent: ''
      }), string, "Unity test");
    };
    testString('(a b)');
    testString('(a b (c d (e)))');
    testString('(a b) (c d e (f g) h (i j k) (l m n) (((o) p)))');
    testString('(def Y (lambda (g)\n  ((lambda (f) (g f f)) (lambda (f) (g f f)))))');
    return testString('To be thus is nothing,\nBut to be safely thus. Our fears in Banquo\nStick deep, and in his royalty of nature\nReigns that which would be feared. \'Tis much he\ndares,');
  });

  test('Indent unity', function() {
    var testString;
    testString = function(string) {
      return equal(ICE.indentParse(string).toString({
        indent: ''
      }), string, "Unity test");
    };
    testString('hello');
    testString('if a is b\n  b c');
    return testString('Stars\n  In your multitudes\n  Scarce to be\n    Counted\n  Filling the \n    Darkness\n  With\n    Order and light\n  You are the\n    Sentinels\n    Silent and sure\n      Keeping watch in the night\n      Keeping watch in the night\nYou know your place in the sky');
  });

  test('Lisp find', function() {
    var testString;
    testString = function(string, fn, expected) {
      return equal(ICE.lispParse(string).next.next.next.block.find(fn).toString({
        indent: ''
      }), expected, "Find test on " + expected);
    };
    testString('(a b)', (function() {
      return true;
    }), '(a b)');
    testString('(a (b c))', (function() {
      return true;
    }), '(b c)');
    testString('(a (b (c (d))) e)', (function() {
      return true;
    }), '(d)');
    testString('(a (b c) (d e))', (function() {
      return true;
    }), '(b c)');
    testString('(a (b c) (d e))', (function(block) {
      return block.start.next.next.value === 'd';
    }), '(d e)');
    testString('(def Y (lambda (g)\n  ((lambda (f) (g f f)) (lambda (f) (g f f)))))', (function(block) {
      return block.start.next.next.value === 'f';
    }), '(f)');
    testString('(def Y (lambda (g)\n  ((lambda (f) (totally-unique f f)) (lambda (f) (g f f)))))', (function(block) {
      return block.start.next.next.value === 'totally-unique';
    }), '(totally-unique f f)');
    return testString('(def Y (lambda (g)\n  ((lambda (f) (totally-unique f f)) (lambda (f) (g f f)))))', (function() {
      return false;
    }), '(def Y (lambda (g)\n  ((lambda (f) (totally-unique f f)) (lambda (f) (g f f)))))');
  });

  test('Lisp tree manipulation', function() {
    var block, lambda, start;
    start = ICE.lispParse('(def Y (lambda (g)\n  ((lambda (f) (g f f)) (lambda (f) (g f f)))))');
    block = start.next.next.next.block;
    lambda = block.find(function(x) {
      return x.start.next.next.value === 'lambda';
    });
    lambda._moveTo(block.start.next);
    return equal(block.toString({
      indent: ''
    }), '((lambda (f) (g f f))def Y (lambda (g)\n  ( (lambda (f) (g f f)))))', 'Y-combinator tree move');
  });

}).call(this);

/*
//@ sourceMappingURL=tests.js.map
*/