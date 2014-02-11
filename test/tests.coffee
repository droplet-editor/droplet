test 'Lisp unity', ->
  testString = (string) ->
    equal ICE.lispParse(string).toString({indent:''}), string, "Unity test"

  testString '(a b)'
  testString '(a b (c d (e)))'
  testString '(a b) (c d e (f g) h (i j k) (l m n) (((o) p)))'
  testString '''
    (def Y (lambda (g)
      ((lambda (f) (g f f)) (lambda (f) (g f f)))))
  '''
  testString '''
    To be thus is nothing,
    But to be safely thus. Our fears in Banquo
    Stick deep, and in his royalty of nature
    Reigns that which would be feared. 'Tis much he
    dares,
  '''

test 'Indent unity', ->
  testString = (string) ->
    equal ICE.indentParse(string).toString({indent:''}), string, "Unity test"
  
  testString 'hello'
  testString '''
    if a is b
      b c
  '''
  testString '''
    Stars
      In your multitudes
      Scarce to be
        Counted
      Filling the 
        Darkness
      With
        Order and light
      You are the
        Sentinels
        Silent and sure
          Keeping watch in the night
          Keeping watch in the night
    You know your place in the sky
  '''

test 'Lisp find', ->
  testString = (string, fn, expected) ->
    equal ICE.lispParse(string).next.next.next.block.find(fn).toString({indent:''}), expected, "Find test on #{expected}"

  testString '(a b)', (-> true), '(a b)'
  testString '(a (b c))', (-> true), '(b c)'
  testString '(a (b (c (d))) e)', (-> true), '(d)'
  testString '(a (b c) (d e))', (-> true), '(b c)'
  testString '(a (b c) (d e))', ((block) -> block.start.next.next.value is 'd'), '(d e)'
  testString '''
    (def Y (lambda (g)
      ((lambda (f) (g f f)) (lambda (f) (g f f)))))
  ''', ((block) -> block.start.next.next.value is 'f'), '(f)'
  testString '''
    (def Y (lambda (g)
      ((lambda (f) (totally-unique f f)) (lambda (f) (g f f)))))
  ''', ((block) -> block.start.next.next.value is 'totally-unique'), '(totally-unique f f)'
  testString '''
    (def Y (lambda (g)
      ((lambda (f) (totally-unique f f)) (lambda (f) (g f f)))))
  ''', (-> false), '''
    (def Y (lambda (g)
      ((lambda (f) (totally-unique f f)) (lambda (f) (g f f)))))
  '''

test 'Lisp tree manipulation', ->
  start = ICE.lispParse '''
    (def Y (lambda (g)
      ((lambda (f) (g f f)) (lambda (f) (g f f)))))
  '''

  block = start.next.next.next.block
  lambda = block.find (x) -> x.start.next.next.value is 'lambda'

  lambda._moveTo(block.start.next)

  equal block.toString({indent:''}), '''
    ((lambda (f) (g f f))def Y (lambda (g)
      ( (lambda (f) (g f f)))))
  ''', 'Y-combinator tree move'

