
// Generated from Java.g4 by ANTLR 4.7.1

#pragma once


#include "antlr4-runtime.h"




class  JavaLexer : public antlr4::Lexer {
public:
  enum {
    T__0 = 1, T__1 = 2, T__2 = 3, T__3 = 4, T__4 = 5, T__5 = 6, T__6 = 7, 
    T__7 = 8, T__8 = 9, T__9 = 10, ABSTRACT = 11, ASSERT = 12, BOOLEAN = 13, 
    BREAK = 14, BYTE = 15, CASE = 16, CATCH = 17, CHAR = 18, CLASS = 19, 
    CONST = 20, CONTINUE = 21, DEFAULT = 22, DO = 23, DOUBLE = 24, ELSE = 25, 
    ENUM = 26, EXTENDS = 27, FINAL = 28, FINALLY = 29, FLOAT = 30, FOR = 31, 
    IF = 32, GOTO = 33, IMPLEMENTS = 34, IMPORT = 35, INSTANCEOF = 36, INT = 37, 
    INTERFACE = 38, LONG = 39, NATIVE = 40, NEW = 41, PACKAGE = 42, PRIVATE = 43, 
    PROTECTED = 44, PUBLIC = 45, RETURN = 46, SHORT = 47, STATIC = 48, STRICTFP = 49, 
    SUPER = 50, SWITCH = 51, SYNCHRONIZED = 52, THIS = 53, THROW = 54, THROWS = 55, 
    TRANSIENT = 56, TRY = 57, VOID = 58, VOLATILE = 59, WHILE = 60, UNDER_SCORE = 61, 
    IntegerLiteral = 62, FloatingPointLiteral = 63, BooleanLiteral = 64, 
    CharacterLiteral = 65, StringLiteral = 66, NullLiteral = 67, LPAREN = 68, 
    RPAREN = 69, LBRACE = 70, RBRACE = 71, LBRACK = 72, RBRACK = 73, SEMI = 74, 
    COMMA = 75, DOT = 76, ELLIPSIS = 77, AT = 78, COLONCOLON = 79, ASSIGN = 80, 
    GT = 81, LT = 82, BANG = 83, TILDE = 84, QUESTION = 85, COLON = 86, 
    ARROW = 87, EQUAL = 88, LE = 89, GE = 90, NOTEQUAL = 91, AND = 92, OR = 93, 
    INC = 94, DEC = 95, ADD = 96, SUB = 97, MUL = 98, DIV = 99, BITAND = 100, 
    BITOR = 101, CARET = 102, MOD = 103, ADD_ASSIGN = 104, SUB_ASSIGN = 105, 
    MUL_ASSIGN = 106, DIV_ASSIGN = 107, AND_ASSIGN = 108, OR_ASSIGN = 109, 
    XOR_ASSIGN = 110, MOD_ASSIGN = 111, LSHIFT_ASSIGN = 112, RSHIFT_ASSIGN = 113, 
    URSHIFT_ASSIGN = 114, Identifier = 115, WS = 116, COMMENT = 117, LINE_COMMENT = 118
  };

  JavaLexer(antlr4::CharStream *input);
  ~JavaLexer();

  virtual std::string getGrammarFileName() const override;
  virtual const std::vector<std::string>& getRuleNames() const override;

  virtual const std::vector<std::string>& getChannelNames() const override;
  virtual const std::vector<std::string>& getModeNames() const override;
  virtual const std::vector<std::string>& getTokenNames() const override; // deprecated, use vocabulary instead
  virtual antlr4::dfa::Vocabulary& getVocabulary() const override;

  virtual const std::vector<uint16_t> getSerializedATN() const override;
  virtual const antlr4::atn::ATN& getATN() const override;

private:
  static std::vector<antlr4::dfa::DFA> _decisionToDFA;
  static antlr4::atn::PredictionContextCache _sharedContextCache;
  static std::vector<std::string> _ruleNames;
  static std::vector<std::string> _tokenNames;
  static std::vector<std::string> _channelNames;
  static std::vector<std::string> _modeNames;

  static std::vector<std::string> _literalNames;
  static std::vector<std::string> _symbolicNames;
  static antlr4::dfa::Vocabulary _vocabulary;
  static antlr4::atn::ATN _atn;
  static std::vector<uint16_t> _serializedATN;


  // Individual action functions triggered by action() above.

  // Individual semantic predicate functions triggered by sempred() above.

  struct Initializer {
    Initializer();
  };
  static Initializer _init;
};

