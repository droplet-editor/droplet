C = require '../../src/languages/c.coffee'
droplet = require '../../dist/droplet-full.js'

load = (file) ->
  q = new XMLHttpRequest()
  q.open 'GET', file, false
  q.send()
  return q.responseText

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

  equal result.serialize(), FREEZE_DATA, 'Match C parser freeze file as of 2016-06-23'

  start()

asyncTest 'Controller: palette block expansion', ->
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

  loopblock = (head) ->
    if head is editor.session.tree.end
      start()
      return

    if head.type is 'blockStart' and head.container.stringify().length > 0
      before = head.prev

      oldLocalSerialize = head.container.serialize()
      oldSerialize = editor.session.tree.serialize()
      editor.reparse head.container
      newSerialize = editor.session.tree.serialize()
      newLocalSerialize = before.next.container.serialize()

      notEqual before.next.id, head.id, "Reparsing did indeed replace the block ('#{head.container.stringify()}', #{head.container.parseContext})."
      equal oldLocalSerialize, newLocalSerialize, "Reparsing did not change the local structure ('#{head.container.stringify()}, #{head.container.parseContext}')."
      equal oldSerialize, newSerialize, "Reparsing did not change the tree structure ('#{head.container.stringify()}, #{head.container.parseContext}')."

      head = before.next

    setTimeout (-> loopblock(head.next)), 0
   loopblock editor.session.tree.start
