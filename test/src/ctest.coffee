C = require '../../src/languages/c.coffee'
droplet = require '../../dist/droplet-full.js'

`
// Mouse event simluation function
function simulate(type, target, options) {
  if ('string' == typeof(target)) {
    target = $(target).get(0)
  }
  options = options || {}
  var pageX = pageY = clientX = clientY = dx = dy = 0
  var location = options.location || target
  if (location) {
    if ('string' == typeof(location)) {
      location = $(location).get(0)
    }
    var gbcr = location.getBoundingClientRect()
    clientX = gbcr.left,
    clientY = gbcr.top,
    pageX = clientX + window.pageXOffset
    pageY = clientY + window.pageYOffset
    dx = Math.floor((gbcr.right - gbcr.left) / 2)
    dy = Math.floor((gbcr.bottom - gbcr.top) / 2)
  }
  if ('dx' in options) dx = options.dx
  if ('dy' in options) dy = options.dy
  pageX = (options.pageX == null ? pageX : options.pageX) + dx
  pageY = (options.pageY == null ? pageY : options.pageY) + dy
  clientX = pageX - window.pageXOffset
  clientY = pageY - window.pageYOffset
  var opts = {
      bubbles: options.bubbles || true,
      cancelable: options.cancelable || true,
      view: options.view || target.ownerDocument.defaultView,
      detail: options.detail || 1,
      pageX: pageX,
      pageY: pageY,
      clientX: clientX,
      clientY: clientY,
      screenX: clientX + window.screenLeft,
      screenY: clientY + window.screenTop,
      ctrlKey: options.ctrlKey || false,
      altKey: options.altKey || false,
      shiftKey: options.shiftKey || false,
      metaKey: options.metaKey || false,
      button: options.button || 0,
      which: options.which || 1,
      relatedTarget: options.relatedTarget || null,
  }
  var evt
  try {
    // Modern API supported by IE9+
    evt = new MouseEvent(type, opts)
  } catch (e) {
    // Old API still required by PhantomJS.
    evt = target.ownerDocument.createEvent('MouseEvents')
    evt.initMouseEvent(type, opts.bubbles, opts.cancelable, opts.view,
      opts.detail, opts.screenX, opts.screenY, opts.clientX, opts.clientY,
      opts.ctrlKey, opts.altKey, opts.shiftKey, opts.metaKey, opts.button,
      opts.relatedTarget)
  }
  target.dispatchEvent(evt)
}
function sequence(delay) {
  var seq = [],
      chain = { then: function(fn) { seq.push(fn); return chain; } }
  function advance() {
    setTimeout(function() {
      if (seq.length) {
        (seq.shift())()
        advance()
      }
    }, delay)
  }
  advance()
  return chain
}
`

asyncTest 'Parser: parser freeze test for C mode', ->
  c = new C({
    knownFunctions: {
      puts: {color: 'blue'}
      printf: {color: 'blue'}
      scanf: {color: 'blue'}
    }
  })

  result = c.parse '''
    #include <stdio.h>
    #include <stdlib.h>
    #define MAXLEN 100

    // Linked list
    struct List {
        long long data;
        struct List *next;
        struct List *prev;
    };
    typedef struct List List;

    // Memoryless swap
    void swap(long long *a, long long *b) {
        *a ^= *b;
        *b ^= *a;
        *a ^= *b;
    }

    // Test if sorted
    int sorted(List *head, int (*fn)(long long, long long)) {
        for (List *cursor = head; cursor && cursor->next; cursor = cursor->next) {
            if (!fn(cursor->data, cursor->next->data)) {
                return 0;
            }
        }
        return 1;
    }

    // Bubble sort
    void sort(List *head, int (*fn)(long long, long long)) {
        while (!sorted(head, fn)) {
            for (List *cursor = head; cursor && cursor->next; cursor = cursor->next) {
                if (!fn(cursor->data, cursor->next->data))
                    swap(&cursor->data, &cursor->next->data);
            }
        }
    }

    // Comparator
    int comparator(long long a, long long b) {
       return (a > b);
    }

    // Main
    int main(int n, char *args[]) {
        // Arbitrary array initializer just o test that syntax
        int arbitraryArray[] = {1, 2, 3, 4, 5};
        int length;
        scanf("%d", &length);
        if (length > MAXLEN) {
            puts("Error: list is too large");
            return 1;
        }
        List *head = (List*)malloc(sizeof(List));
        scanf("%d", &head->data);
        head->prev = NULL;
        List *cursor = head;
        int temp;
        for (int i = 0; i < length - 1; i++) {
            cursor->next = (List*)malloc(sizeof(List));
            cursor = cursor->next;
            scanf("%d", &temp);
            cursor->data = (long long)temp;
        }
        sort(head, comparator);
        for (cursor = head; cursor; cursor = cursor->next) {
            printf("%d ", cursor->data);
        }
        puts("\\n");
        return 0;
    }
  '''

  deepEqual result.serialize(), FREEZE_DATA.freezeTest, 'Match C parser freeze file as of 2016-07-08'

  start()

asyncTest 'Parser: parser freeze test comment consolidation', ->
  c = new C({
    knownFunctions: {
      puts: {color: 'blue'}
      printf: {color: 'blue'}
      scanf: {color: 'blue'}
    }
  })

  result = c.parse '''
    int main() {
      puts("Hello"); /* start
      middle
      end */ puts("Hi"); /* interrupt */ /* start
      end */ puts("Goodbye"); /* interrupt */ // end of line
      /* start again
      end again */ /* interrupt */ /* start
      end */
      /* interrupt */ // end of line
      return 0;
    }
  '''

  deepEqual result.serialize(), FREEZE_DATA.commentConsolidation, 'C comment consolidation'

  start()

pickUpLocation = (editor, document, location) ->
  block = editor.getDocument(document).getFromTextLocation(location)
  bound = editor.session.view.getViewNodeFor(block).bounds[0]
  simulate('mousedown', editor.mainCanvas, {
    dx: bound.x + 5,
    dy: bound.y + 5
  })
  simulate('mousemove', editor.dragCover, {
    location: editor.mainCanvas
    dx: bound.x + 10,
    dy: bound.y + 10
  })

dropLocation = (editor, document, location) ->
  block = editor.getDocument(document).getFromTextLocation(location)
  blockView = editor.session.view.getViewNodeFor block
  simulate('mousemove', editor.dragCover, {
    location: editor.mainCanvas
    dx: blockView.dropPoint.x + 5,
    dy: blockView.dropPoint.y + 5
  })
  simulate('mouseup', editor.mainCanvas, {
    dx: blockView.dropPoint.x + 5
    dy: blockView.dropPoint.y + 5
  })

executeAsyncSequence = (sequence, i = 0) ->
  if i < sequence.length
    sequence[i]()
    setTimeout (->
      executeAsyncSequence sequence, i + 1
    ), 0

asyncTest 'Controller: ANTLR paren wrap rules', ->
  window.editor = editor = new droplet.Editor(document.getElementById('test-main'), {
    mode: 'c',
    palette: []
  })

  editor.setValue '''
    int main() {
      int y = 1 * 2;
      int x = 1 + 2;
      int a = 1 + 2 * 3;
      printf("Hello");
    }
  '''

  executeAsyncSequence [
    (->
      pickUpLocation editor, 0, {
        row: 2
        col: 10
        type: 'block'
      }
      dropLocation editor, 0, {
        row: 1
        col: 14
        type: 'socket'
      }
    ), (->
      equal editor.getValue(), '''
      int main() {
        int y = 1 * (1 + 2);
        int x = __0_droplet__;
        int a = 1 + 2 * 3;
        printf("Hello");
      }\n
      ''', 'Paren-wrapped + block dropping into * block'

      equal editor.session.tree.getFromTextLocation({
        row: 1, col: 14, type: 'block'
      }).parseContext, 'primaryExpression', 'Changed parse context when adding parens'
    ), (->
      pickUpLocation editor, 0, {
        row: 1
        col: 10
        type: 'block'
      }
      dropLocation editor, 0, {
        row: 3
        col: 10
        type: 'socket'
        length: 1
      }
    ), (->
      equal editor.getValue(), '''
      int main() {
        int y = __0_droplet__;
        int x = __0_droplet__;
        int a = 1 * (1 + 2) + 2 * 3;
        printf("Hello");
      }\n
      ''', 'Did not paren-wrap * block dropping into + block'
    ), (->
      pickUpLocation editor, 0, {
        row: 3
        col: 14
        type: 'block'
      }
      dropLocation editor, 0, {
        row: 2
        col: 10
        type: 'socket'
      }
    ), (->
      equal editor.getValue(), '''
      int main() {
        int y = __0_droplet__;
        int x = 1 + 2;
        int a = 1 * 2 + 2 * 3;
        printf("Hello");
      }\n
      ''', 'Un-paren-wrapped when dropping into place where parens are unnecessary'

      equal editor.session.tree.getFromTextLocation({
        row: 2, col: 10, type: 'block'
      }).parseContext, 'additiveExpression', 'Changed parse context when removing parens'
    ), (->
      pickUpLocation editor, 0, {
        row: 4
        col: 2
        type: 'block'
      }
      dropLocation editor, 0, {
        row: 1
        col: 10
        type: 'socket'
      }
    ), (->
      equal editor.getValue(), '''
      int main() {
        int y = printf("Hello");
        int x = 1 + 2;
        int a = 1 * 2 + 2 * 3;
      }\n
      ''', 'Removed semicolon'

      equal editor.session.tree.getFromTextLocation({
        row: 1, col: 10, type: 'block'
      }).parseContext, 'postfixExpression', 'Changed parse context when removing semicolon'
    ), (->
      pickUpLocation editor, 0, {
        row: 1
        col: 10
        type: 'block'
      }
      dropLocation editor, 0, {
        row: 3
        col: 2
        type: 'block'
      }
    ), (->
      equal editor.getValue(), '''
      int main() {
        int y = __0_droplet__;
        int x = 1 + 2;
        int a = 1 * 2 + 2 * 3;
        printf("Hello");
      }\n
      ''', 'Added semicolon back'

      equal editor.session.tree.getFromTextLocation({
        row: 4, col: 2, type: 'block'
      }).parseContext, 'expressionStatement', 'Changed parse context when adding semicolon'

      start()
    )
  ]

asyncTest 'Controller: ANTLR paren wrap rules for C semicolons', ->
  window.editor = editor = new droplet.Editor(document.getElementById('test-main'), {
    mode: 'c',
    palette: []
  })

  editor.setValue '''
    int main() {
      puts("Hello");
      puts("World");
    }
  '''

  executeAsyncSequence [
    (->
      pickUpLocation editor, 0, {
        row: 1
        col: 2
        type: 'block'
      }
      dropLocation editor, 0, {
        row: 2
        col: 7
        type: 'socket'
      }
    ), (->
      equal editor.getValue(), '''
      int main() {
        puts(puts("Hello"));
      }\n
      ''', 'Removed semicolon dropping function into other function'
    ), (->
      pickUpLocation editor, 0, {
        row: 1
        col: 7
        type: 'block'
      }
      dropLocation editor, 0, {
        row: 1
        col: 2
        type: 'block'
      }
    ), (->
      equal editor.getValue(), '''
      int main() {
        puts("World");
        puts("Hello");
      }\n
      ''', 'Added semicolon dropping function into block'

      start()
    )
  ]

asyncTest 'Controller: ANTLR reparse rules', ->
  document.getElementById('test-main').innerHTML = ''
  window.editor = editor = new droplet.Editor(document.getElementById('test-main'), {
    mode: 'c',
    palette: []
  })

  editor.setValue '''
    #include <stdio.h>
    #include <stdlib.h>
    #define MAXLEN 100

    // Linked list
    struct List {
        long long data;
        struct List *next;
        struct List *prev;
    };
    typedef struct List List;

    // Memoryless swap
    void swap(long long *a, long long *b) {
        *a ^= *b;
        *b ^= *a;
        *a ^= *b;
    }

    // Test if sorted
    int sorted(List *head, int (*fn)(long long, long long)) {
        for (List *cursor = head; cursor && cursor->next; cursor = cursor->next) {
            if (!fn(cursor->data, cursor->next->data)) {
                return 0;
            }
        }
        return 1;
    }

    // Bubble sort
    void sort(List *head, int (*fn)(long long, long long)) {
        while (!sorted(head, fn)) {
            for (List *cursor = head; cursor && cursor->next; cursor = cursor->next) {
                if (!fn(cursor->data, cursor->next->data))
                    swap(&cursor->data, &cursor->next->data);
            }
        }
    }

    // Comparator
    int comparator(long long a, long long b) {
       return (a > b);
    }

    // Main
    int main(int n, char *args[]) {
        // Arbitrary array initializer just to test that syntax
        int arbitraryArray[] = {1, 2, 3, 4, 5};
        int length;
        scanf("%d", &length);
        if (length > MAXLEN) {
            puts("Error: list is too large");
            return 1;
        }
        List *head = (List*)malloc(sizeof(List));
        scanf("%d", &head->data);
        head->prev = NULL;
        List *cursor = head;
        int temp;
        for (int i = 0; i < length - 1; i++) {
            cursor->next = (List*)malloc(sizeof(List));
            cursor = cursor->next;
            scanf("%d", &temp);
            cursor->data = (long long)temp;
        }
        sort(head, comparator);
        for (cursor = head; cursor; cursor = cursor->next) {
            printf("%d ", cursor->data);
        }
        puts("\\n");
        return 0;
    }
  '''

  loopblock = (head) ->
    if head is editor.session.tree.end
      start()
      return

    if head.type is 'blockStart' and head.container.parseContext isnt '__comment__' and head.container.stringify().length > 0
      before = head.prev

      oldLocalSerialize = head.container.serialize()
      oldSerialize = editor.session.tree.serialize()
      editor.reparse head.container
      newSerialize = editor.session.tree.serialize()
      newLocalSerialize = before.next.container.serialize()

      notEqual before.next.id, head.id, "Reparsing did indeed replace the block ('#{head.container.stringify()}', #{head.container.parseContext})."
      deepEqual oldLocalSerialize, newLocalSerialize, "Reparsing did not change the local structure ('#{head.container.stringify()}, #{head.container.parseContext}')."
      deepEqual oldSerialize, newSerialize, "Reparsing did not change the tree structure ('#{head.container.stringify()}, #{head.container.parseContext}')."

      head = before.next

    setTimeout (-> loopblock(head.next)), 0
   loopblock editor.session.tree.start
