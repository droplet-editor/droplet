window.parserSuccessData = [
  {
    "message": "Function call",
    "str": "alert 10",
    "expected": "<document><block\n precedence=\"0\"\n color=\"blue\"\n socketLevel=\"0\"\n classes=\"Call works-as-method-call mostly-block\">alert <socket\n precedence=\"-1\"\n handwritten=\"false\"\n classes=\"Value\">10<\/socket><\/block><\/document>"
  },
  {
    "message": "Variable assignment",
    "str": "a = b",
    "expected": "<document><block\n precedence=\"0\"\n color=\"blue\"\n socketLevel=\"0\"\n classes=\"Assign mostly-block\"><socket\n precedence=\"0\"\n handwritten=\"false\"\n classes=\"Value lvalue\">a<\/socket> = <socket\n precedence=\"0\"\n handwritten=\"false\"\n classes=\"Value\">b<\/socket><\/block><\/document>"
  },
  {
    "message": "If statement, normal form",
    "str": "if true\n alert 10",
    "expected": "<document><block\n precedence=\"0\"\n color=\"orange\"\n socketLevel=\"0\"\n classes=\"If mostly-block\">if <socket\n precedence=\"0\"\n handwritten=\"false\"\n classes=\"Value\">true<\/socket><indent\n prefix=\" \"\n classes=\"\">\n<block\n precedence=\"0\"\n color=\"blue\"\n socketLevel=\"0\"\n classes=\"Call works-as-method-call mostly-block\">alert <socket\n precedence=\"-1\"\n handwritten=\"false\"\n classes=\"Value\">10<\/socket><\/block><\/indent><\/block><\/document>"
  },
  {
    "message": "Unless statement, normal form",
    "str": "unless true\n alert 10",
    "expected": "<document><block\n precedence=\"0\"\n color=\"orange\"\n socketLevel=\"0\"\n classes=\"If mostly-block\">unless <socket\n precedence=\"0\"\n handwritten=\"false\"\n classes=\"Value\">true<\/socket><indent\n prefix=\" \"\n classes=\"\">\n<block\n precedence=\"0\"\n color=\"blue\"\n socketLevel=\"0\"\n classes=\"Call works-as-method-call mostly-block\">alert <socket\n precedence=\"-1\"\n handwritten=\"false\"\n classes=\"Value\">10<\/socket><\/block><\/indent><\/block><\/document>"
  },
  {
    "message": "One-line if statement",
    "str": "if a then b",
    "expected": "<document><block\n precedence=\"0\"\n color=\"orange\"\n socketLevel=\"0\"\n classes=\"If mostly-block\">if <socket\n precedence=\"0\"\n handwritten=\"false\"\n classes=\"Value\">a<\/socket> then <socket\n precedence=\"0\"\n handwritten=\"false\"\n classes=\"Block\">b<\/socket><\/block><\/document>"
  },
  {
    "message": "If-else statement, normal form",
    "str": "if true\n alert 10\nelse\n alert 10",
    "expected": "<document><block\n precedence=\"0\"\n color=\"orange\"\n socketLevel=\"0\"\n classes=\"If mostly-block\">if <socket\n precedence=\"0\"\n handwritten=\"false\"\n classes=\"Value\">true<\/socket><indent\n prefix=\" \"\n classes=\"\">\n<block\n precedence=\"0\"\n color=\"blue\"\n socketLevel=\"0\"\n classes=\"Call works-as-method-call mostly-block\">alert <socket\n precedence=\"-1\"\n handwritten=\"false\"\n classes=\"Value\">10<\/socket><\/block><\/indent>\nelse<indent\n prefix=\" \"\n classes=\"\">\n<block\n precedence=\"0\"\n color=\"blue\"\n socketLevel=\"0\"\n classes=\"Call works-as-method-call mostly-block\">alert <socket\n precedence=\"-1\"\n handwritten=\"false\"\n classes=\"Value\">10<\/socket><\/block><\/indent><\/block><\/document>"
  },
  {
    "message": "One-line if-else statement",
    "str": "if a then b else c",
    "expected": "<document><block\n precedence=\"0\"\n color=\"orange\"\n socketLevel=\"0\"\n classes=\"If mostly-block\">if <socket\n precedence=\"0\"\n handwritten=\"false\"\n classes=\"Value\">a<\/socket> then <socket\n precedence=\"0\"\n handwritten=\"false\"\n classes=\"Block\">b<\/socket> else <socket\n precedence=\"0\"\n handwritten=\"false\"\n classes=\"Block\">c<\/socket><\/block><\/document>"
  },
  {
    "message": "While statement, normal form",
    "str": "while a\n alert 10",
    "expected": "<document><block\n precedence=\"-3\"\n color=\"orange\"\n socketLevel=\"0\"\n classes=\"While mostly-block\">while <socket\n precedence=\"0\"\n handwritten=\"false\"\n classes=\"Value\">a<\/socket><indent\n prefix=\" \"\n classes=\"\">\n<block\n precedence=\"0\"\n color=\"blue\"\n socketLevel=\"0\"\n classes=\"Call works-as-method-call mostly-block\">alert <socket\n precedence=\"-1\"\n handwritten=\"false\"\n classes=\"Value\">10<\/socket><\/block><\/indent><\/block><\/document>"
  },
  {
    "message": "One-line while statement",
    "str": "while a then alert 10",
    "expected": "<document><block\n precedence=\"-3\"\n color=\"orange\"\n socketLevel=\"0\"\n classes=\"While mostly-block\">while <socket\n precedence=\"0\"\n handwritten=\"false\"\n classes=\"Value\">a<\/socket> then <socket\n precedence=\"0\"\n handwritten=\"false\"\n classes=\"Block\"><block\n precedence=\"0\"\n color=\"blue\"\n socketLevel=\"0\"\n classes=\"Call works-as-method-call mostly-block\">alert <socket\n precedence=\"-1\"\n handwritten=\"false\"\n classes=\"Value\">10<\/socket><\/block><\/socket><\/block><\/document>"
  },
  {
    "message": "For-in, normal form",
    "str": "for i in list\n alert 10",
    "expected": "<document><block\n precedence=\"-3\"\n color=\"orange\"\n socketLevel=\"0\"\n classes=\"For mostly-block\">for <socket\n precedence=\"0\"\n handwritten=\"false\"\n classes=\"Literal forbid-all\">i<\/socket> in <socket\n precedence=\"0\"\n handwritten=\"false\"\n classes=\"Value\">list<\/socket><indent\n prefix=\" \"\n classes=\"\">\n<block\n precedence=\"0\"\n color=\"blue\"\n socketLevel=\"0\"\n classes=\"Call works-as-method-call mostly-block\">alert <socket\n precedence=\"-1\"\n handwritten=\"false\"\n classes=\"Value\">10<\/socket><\/block><\/indent><\/block><\/document>"
  },
  {
    "message": "One-line for-in",
    "str": "for i in list then alert 10",
    "expected": "<document><block\n precedence=\"-3\"\n color=\"orange\"\n socketLevel=\"0\"\n classes=\"For mostly-block\">for <socket\n precedence=\"0\"\n handwritten=\"false\"\n classes=\"Literal forbid-all\">i<\/socket> in <socket\n precedence=\"0\"\n handwritten=\"false\"\n classes=\"Value\">list<\/socket> then <socket\n precedence=\"0\"\n handwritten=\"false\"\n classes=\"Block\"><block\n precedence=\"0\"\n color=\"blue\"\n socketLevel=\"0\"\n classes=\"Call works-as-method-call mostly-block\">alert <socket\n precedence=\"-1\"\n handwritten=\"false\"\n classes=\"Value\">10<\/socket><\/block><\/socket><\/block><\/document>"
  },
  {
    "message": "Inverted one-line for-in",
    "str": "alert 10 for i in list",
    "expected": "<document><block\n precedence=\"-3\"\n color=\"orange\"\n socketLevel=\"0\"\n classes=\"For mostly-block\"><socket\n precedence=\"0\"\n handwritten=\"false\"\n classes=\"Block\"><block\n precedence=\"0\"\n color=\"blue\"\n socketLevel=\"0\"\n classes=\"Call works-as-method-call mostly-block\">alert <socket\n precedence=\"-1\"\n handwritten=\"false\"\n classes=\"Value\">10<\/socket><\/block><\/socket> for <socket\n precedence=\"0\"\n handwritten=\"false\"\n classes=\"Literal forbid-all\">i<\/socket> in <socket\n precedence=\"0\"\n handwritten=\"false\"\n classes=\"Value\">list<\/socket><\/block><\/document>"
  },
  {
    "message": "Semicolons at the root",
    "str": "alert 10; prompt 10",
    "expected": "<document><block\n precedence=\"-2\"\n color=\"blue\"\n socketLevel=\"any-drop\"\n classes=\"semicolon\"><socket\n precedence=\"-2\"\n handwritten=\"false\"\n classes=\"Call works-as-method-call\"><block\n precedence=\"0\"\n color=\"blue\"\n socketLevel=\"0\"\n classes=\"Call works-as-method-call mostly-block\">alert <socket\n precedence=\"-1\"\n handwritten=\"false\"\n classes=\"Value\">10<\/socket><\/block><\/socket>; <socket\n precedence=\"-2\"\n handwritten=\"false\"\n classes=\"Call works-as-method-call\"><block\n precedence=\"0\"\n color=\"blue\"\n socketLevel=\"0\"\n classes=\"Call works-as-method-call mostly-block\">prompt <socket\n precedence=\"-1\"\n handwritten=\"false\"\n classes=\"Value\">10<\/socket><\/block><\/socket><\/block><\/document>"
  },
  {
    "message": "Semicolons with one-line block",
    "str": "if a then b; c else d",
    "expected": "<document><block\n precedence=\"0\"\n color=\"orange\"\n socketLevel=\"0\"\n classes=\"If mostly-block\">if <socket\n precedence=\"0\"\n handwritten=\"false\"\n classes=\"Value\">a<\/socket> then <socket\n precedence=\"0\"\n handwritten=\"false\"\n classes=\"Block\"><block\n precedence=\"-2\"\n color=\"blue\"\n socketLevel=\"any-drop\"\n classes=\"semicolon\"><socket\n precedence=\"-2\"\n handwritten=\"false\"\n classes=\"Value\">b<\/socket>; <socket\n precedence=\"-2\"\n handwritten=\"false\"\n classes=\"Value\">c<\/socket><\/block><\/socket> else <socket\n precedence=\"0\"\n handwritten=\"false\"\n classes=\"Block\">d<\/socket><\/block><\/document>"
  },
  {
    "message": "Semicolons in sequence",
    "str": "while a\n console.log hi\n alert 10; prompt 10\n console.log bye",
    "expected": "<document><block\n precedence=\"-3\"\n color=\"orange\"\n socketLevel=\"0\"\n classes=\"While mostly-block\">while <socket\n precedence=\"0\"\n handwritten=\"false\"\n classes=\"Value\">a<\/socket><indent\n prefix=\" \"\n classes=\"\">\n<block\n precedence=\"0\"\n color=\"blue\"\n socketLevel=\"0\"\n classes=\"Call works-as-method-call mostly-block\">console.log <socket\n precedence=\"-1\"\n handwritten=\"false\"\n classes=\"Value\">hi<\/socket><\/block>\n<block\n precedence=\"-2\"\n color=\"blue\"\n socketLevel=\"any-drop\"\n classes=\"semicolon\"><socket\n precedence=\"-2\"\n handwritten=\"false\"\n classes=\"Call works-as-method-call\"><block\n precedence=\"0\"\n color=\"blue\"\n socketLevel=\"0\"\n classes=\"Call works-as-method-call mostly-block\">alert <socket\n precedence=\"-1\"\n handwritten=\"false\"\n classes=\"Value\">10<\/socket><\/block><\/socket>; <socket\n precedence=\"-2\"\n handwritten=\"false\"\n classes=\"Call works-as-method-call\"><block\n precedence=\"0\"\n color=\"blue\"\n socketLevel=\"0\"\n classes=\"Call works-as-method-call mostly-block\">prompt <socket\n precedence=\"-1\"\n handwritten=\"false\"\n classes=\"Value\">10<\/socket><\/block><\/socket><\/block>\n<block\n precedence=\"0\"\n color=\"blue\"\n socketLevel=\"0\"\n classes=\"Call works-as-method-call mostly-block\">console.log <socket\n precedence=\"-1\"\n handwritten=\"false\"\n classes=\"Value\">bye<\/socket><\/block><\/indent><\/block><\/document>"
  },
  {
    "message": "Object literal, normal form",
    "str": "foo {\n a: b,\n c: d\n}",
    "expected": "<document><block\n precedence=\"0\"\n color=\"blue\"\n socketLevel=\"0\"\n classes=\"Call works-as-method-call any-drop\"><socket\n precedence=\"0\"\n handwritten=\"false\"\n classes=\"Value\">foo<\/socket> <socket\n precedence=\"-1\"\n handwritten=\"false\"\n classes=\"Value\"><block\n precedence=\"0\"\n color=\"teal\"\n socketLevel=\"0\"\n classes=\"Obj value-only\">{\n <socket\n precedence=\"0\"\n handwritten=\"false\"\n classes=\"Value forbid-all\">a<\/socket>: <socket\n precedence=\"0\"\n handwritten=\"false\"\n classes=\"Value\">b<\/socket>,\n <socket\n precedence=\"0\"\n handwritten=\"false\"\n classes=\"Value forbid-all\">c<\/socket>: <socket\n precedence=\"0\"\n handwritten=\"false\"\n classes=\"Value\">d<\/socket>\n}<\/block><\/socket><\/block><\/document>"
  },
  {
    "message": "Object literal, no braces or commas",
    "str": "foo\n a: b\n c: d",
    "expected": "<document><block\n precedence=\"0\"\n color=\"blue\"\n socketLevel=\"0\"\n classes=\"Call works-as-method-call any-drop\"><socket\n precedence=\"0\"\n handwritten=\"false\"\n classes=\"Value\">foo<\/socket>\n <socket\n precedence=\"-1\"\n handwritten=\"false\"\n classes=\"Value\"><block\n precedence=\"0\"\n color=\"teal\"\n socketLevel=\"0\"\n classes=\"Obj value-only\"><socket\n precedence=\"0\"\n handwritten=\"false\"\n classes=\"Value forbid-all\">a<\/socket>: <socket\n precedence=\"0\"\n handwritten=\"false\"\n classes=\"Value\">b<\/socket>\n <socket\n precedence=\"0\"\n handwritten=\"false\"\n classes=\"Value forbid-all\">c<\/socket>: <socket\n precedence=\"0\"\n handwritten=\"false\"\n classes=\"Value\">d<\/socket><\/block><\/socket><\/block><\/document>"
  },
  {
    "message": "String interpolation",
    "str": "foo \"#{a}\"",
    "expected": "<document><block\n precedence=\"0\"\n color=\"blue\"\n socketLevel=\"0\"\n classes=\"Call works-as-method-call any-drop\"><socket\n precedence=\"0\"\n handwritten=\"false\"\n classes=\"Value\">foo<\/socket> <socket\n precedence=\"-1\"\n handwritten=\"false\"\n classes=\"Value\">&quot;#{a}&quot;<\/socket><\/block><\/document>"
  },
  {
    "message": "Range",
    "str": "[1..10]",
    "expected": "<document><block\n precedence=\"100\"\n color=\"teal\"\n socketLevel=\"0\"\n classes=\"Range value-only\">[<socket\n precedence=\"0\"\n handwritten=\"false\"\n classes=\"Value\">1<\/socket>..<socket\n precedence=\"0\"\n handwritten=\"false\"\n classes=\"Value\">10<\/socket>]<\/block><\/document>"
  },
  {
    "message": "Array",
    "str": "[0, 1]",
    "expected": "<document><block\n precedence=\"100\"\n color=\"teal\"\n socketLevel=\"0\"\n classes=\"Arr value-only\">[<indent\n prefix=\"  \"\n classes=\"\"><block\n precedence=\"100\"\n color=\"green\"\n socketLevel=\"0\"\n classes=\"Value value-only\">0, <\/block><block\n precedence=\"100\"\n color=\"green\"\n socketLevel=\"0\"\n classes=\"Value value-only\">1<\/block><\/indent>]<\/block><\/document>"
  }
]
