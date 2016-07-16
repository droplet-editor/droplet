// Generated from ECMAScript.g4 by ANTLR 4.5
// jshint ignore: start
var antlr4 = require('antlr4/index');
var ECMAScriptListener = require('./ECMAScriptListener').ECMAScriptListener;
var grammarFileName = "ECMAScript.g4";

var serializedATN = ["\3\u0430\ud6d1\u8206\uad2d\u4417\uaef1\u8d80\uaadd",
    "\3i\u026a\4\2\t\2\4\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4",
    "\t\t\t\4\n\t\n\4\13\t\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t",
    "\20\4\21\t\21\4\22\t\22\4\23\t\23\4\24\t\24\4\25\t\25\4\26\t\26\4\27",
    "\t\27\4\30\t\30\4\31\t\31\4\32\t\32\4\33\t\33\4\34\t\34\4\35\t\35\4",
    "\36\t\36\4\37\t\37\4 \t \4!\t!\4\"\t\"\4#\t#\4$\t$\4%\t%\4&\t&\4\'\t",
    "\'\4(\t(\4)\t)\4*\t*\4+\t+\4,\t,\4-\t-\4.\t.\4/\t/\4\60\t\60\4\61\t",
    "\61\4\62\t\62\4\63\t\63\4\64\t\64\4\65\t\65\4\66\t\66\4\67\t\67\48\t",
    "8\3\2\5\2r\n\2\3\2\3\2\3\3\6\3w\n\3\r\3\16\3x\3\4\3\4\5\4}\n\4\3\5\3",
    "\5\3\5\3\5\3\5\3\5\3\5\3\5\3\5\3\5\3\5\3\5\3\5\3\5\3\5\5\5\u008e\n\5",
    "\3\6\3\6\5\6\u0092\n\6\3\6\3\6\3\7\6\7\u0097\n\7\r\7\16\7\u0098\3\b",
    "\3\b\3\b\3\b\3\t\3\t\3\t\7\t\u00a2\n\t\f\t\16\t\u00a5\13\t\3\n\3\n\5",
    "\n\u00a9\n\n\3\13\3\13\3\13\3\f\3\f\3\r\3\r\3\16\3\16\3\16\3\16\3\16",
    "\3\16\3\16\5\16\u00b9\n\16\3\17\3\17\3\17\3\17\3\17\3\17\3\17\3\17\3",
    "\17\3\17\3\17\3\17\3\17\3\17\3\17\3\17\3\17\5\17\u00cc\n\17\3\17\3\17",
    "\5\17\u00d0\n\17\3\17\3\17\5\17\u00d4\n\17\3\17\3\17\3\17\3\17\3\17",
    "\3\17\3\17\3\17\5\17\u00de\n\17\3\17\3\17\5\17\u00e2\n\17\3\17\3\17",
    "\3\17\3\17\3\17\3\17\3\17\3\17\3\17\3\17\3\17\3\17\3\17\3\17\3\17\3",
    "\17\3\17\3\17\3\17\3\17\5\17\u00f8\n\17\3\20\3\20\5\20\u00fc\n\20\3",
    "\20\3\20\3\21\3\21\5\21\u0102\n\21\3\21\3\21\3\22\3\22\5\22\u0108\n",
    "\22\3\22\3\22\3\23\3\23\3\23\3\23\3\23\3\23\3\24\3\24\3\24\3\24\3\24",
    "\3\24\3\25\3\25\5\25\u011a\n\25\3\25\3\25\5\25\u011e\n\25\5\25\u0120",
    "\n\25\3\25\3\25\3\26\6\26\u0125\n\26\r\26\16\26\u0126\3\27\3\27\3\27",
    "\3\27\5\27\u012d\n\27\3\30\3\30\3\30\5\30\u0132\n\30\3\31\3\31\3\31",
    "\3\31\3\32\3\32\3\32\3\32\3\33\3\33\3\33\3\33\3\33\3\33\3\33\3\33\3",
    "\33\3\33\3\33\3\33\3\33\5\33\u0149\n\33\3\34\3\34\3\34\3\34\3\34\3\34",
    "\3\35\3\35\3\35\3\36\3\36\3\36\3\37\3\37\3\37\3\37\5\37\u015b\n\37\3",
    "\37\3\37\3\37\3\37\3\37\3 \3 \3 \7 \u0165\n \f \16 \u0168\13 \3!\5!",
    "\u016b\n!\3\"\3\"\5\"\u016f\n\"\3\"\5\"\u0172\n\"\3\"\5\"\u0175\n\"",
    "\3\"\3\"\3#\5#\u017a\n#\3#\3#\3#\5#\u017f\n#\3#\7#\u0182\n#\f#\16#\u0185",
    "\13#\3$\6$\u0188\n$\r$\16$\u0189\3%\3%\5%\u018e\n%\3%\5%\u0191\n%\3",
    "%\3%\3&\3&\3&\7&\u0198\n&\f&\16&\u019b\13&\3\'\3\'\3\'\3\'\3\'\3\'\3",
    "\'\3\'\3\'\3\'\3\'\3\'\3\'\3\'\3\'\3\'\3\'\3\'\3\'\5\'\u01b0\n\'\3(",
    "\3(\3(\5(\u01b5\n(\3)\3)\3*\3*\5*\u01bb\n*\3*\3*\3+\3+\3+\7+\u01c2\n",
    "+\f+\16+\u01c5\13+\3,\3,\3,\7,\u01ca\n,\f,\16,\u01cd\13,\3-\3-\3-\3",
    "-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\5-\u01e4\n-\3-",
    "\3-\5-\u01e8\n-\3-\3-\3-\3-\3-\3-\3-\3-\5-\u01f2\n-\3-\3-\3-\3-\3-\3",
    "-\3-\3-\3-\5-\u01fd\n-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-",
    "\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3",
    "-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-",
    "\3-\3-\3-\3-\3-\7-\u0240\n-\f-\16-\u0243\13-\3.\3.\3/\3/\5/\u0249\n",
    "/\3\60\3\60\3\61\3\61\5\61\u024f\n\61\3\62\3\62\3\62\5\62\u0254\n\62",
    "\3\63\3\63\3\64\3\64\3\65\3\65\3\65\3\65\3\66\3\66\3\66\3\66\3\67\3",
    "\67\3\67\3\67\5\67\u0266\n\67\38\38\38\2\3X9\2\4\6\b\n\f\16\20\22\24",
    "\26\30\32\34\36 \"$&(*,.\60\62\64\668:<>@BDFHJLNPRTVXZ\\^`bdfhjln\2",
    "\r\3\2\27\31\3\2\23\24\3\2\32\34\3\2\35 \3\2!$\3\2*\64\5\2\3\3\65\66",
    "ee\3\2\679\3\2\65\66\3\2:S\3\2Tc\u029f\2q\3\2\2\2\4v\3\2\2\2\6|\3\2",
    "\2\2\b\u008d\3\2\2\2\n\u008f\3\2\2\2\f\u0096\3\2\2\2\16\u009a\3\2\2",
    "\2\20\u009e\3\2\2\2\22\u00a6\3\2\2\2\24\u00aa\3\2\2\2\26\u00ad\3\2\2",
    "\2\30\u00af\3\2\2\2\32\u00b1\3\2\2\2\34\u00f7\3\2\2\2\36\u00f9\3\2\2",
    "\2 \u00ff\3\2\2\2\"\u0105\3\2\2\2$\u010b\3\2\2\2&\u0111\3\2\2\2(\u0117",
    "\3\2\2\2*\u0124\3\2\2\2,\u0128\3\2\2\2.\u012e\3\2\2\2\60\u0133\3\2\2",
    "\2\62\u0137\3\2\2\2\64\u0148\3\2\2\2\66\u014a\3\2\2\28\u0150\3\2\2\2",
    ":\u0153\3\2\2\2<\u0156\3\2\2\2>\u0161\3\2\2\2@\u016a\3\2\2\2B\u016c",
    "\3\2\2\2D\u0179\3\2\2\2F\u0187\3\2\2\2H\u018b\3\2\2\2J\u0194\3\2\2\2",
    "L\u01af\3\2\2\2N\u01b4\3\2\2\2P\u01b6\3\2\2\2R\u01b8\3\2\2\2T\u01be",
    "\3\2\2\2V\u01c6\3\2\2\2X\u01fc\3\2\2\2Z\u0244\3\2\2\2\\\u0248\3\2\2",
    "\2^\u024a\3\2\2\2`\u024e\3\2\2\2b\u0253\3\2\2\2d\u0255\3\2\2\2f\u0257",
    "\3\2\2\2h\u0259\3\2\2\2j\u025d\3\2\2\2l\u0265\3\2\2\2n\u0267\3\2\2\2",
    "pr\5\4\3\2qp\3\2\2\2qr\3\2\2\2rs\3\2\2\2st\7\2\2\3t\3\3\2\2\2uw\5\6",
    "\4\2vu\3\2\2\2wx\3\2\2\2xv\3\2\2\2xy\3\2\2\2y\5\3\2\2\2z}\5\b\5\2{}",
    "\5<\37\2|z\3\2\2\2|{\3\2\2\2}\7\3\2\2\2~\u008e\5\n\6\2\177\u008e\5\16",
    "\b\2\u0080\u008e\5\26\f\2\u0081\u008e\5\30\r\2\u0082\u008e\5\32\16\2",
    "\u0083\u008e\5\34\17\2\u0084\u008e\5\36\20\2\u0085\u008e\5 \21\2\u0086",
    "\u008e\5\"\22\2\u0087\u008e\5$\23\2\u0088\u008e\5\60\31\2\u0089\u008e",
    "\5&\24\2\u008a\u008e\5\62\32\2\u008b\u008e\5\64\33\2\u008c\u008e\5:",
    "\36\2\u008d~\3\2\2\2\u008d\177\3\2\2\2\u008d\u0080\3\2\2\2\u008d\u0081",
    "\3\2\2\2\u008d\u0082\3\2\2\2\u008d\u0083\3\2\2\2\u008d\u0084\3\2\2\2",
    "\u008d\u0085\3\2\2\2\u008d\u0086\3\2\2\2\u008d\u0087\3\2\2\2\u008d\u0088",
    "\3\2\2\2\u008d\u0089\3\2\2\2\u008d\u008a\3\2\2\2\u008d\u008b\3\2\2\2",
    "\u008d\u008c\3\2\2\2\u008e\t\3\2\2\2\u008f\u0091\7\t\2\2\u0090\u0092",
    "\5\f\7\2\u0091\u0090\3\2\2\2\u0091\u0092\3\2\2\2\u0092\u0093\3\2\2\2",
    "\u0093\u0094\7\n\2\2\u0094\13\3\2\2\2\u0095\u0097\5\b\5\2\u0096\u0095",
    "\3\2\2\2\u0097\u0098\3\2\2\2\u0098\u0096\3\2\2\2\u0098\u0099\3\2\2\2",
    "\u0099\r\3\2\2\2\u009a\u009b\7A\2\2\u009b\u009c\5\20\t\2\u009c\u009d",
    "\5l\67\2\u009d\17\3\2\2\2\u009e\u00a3\5\22\n\2\u009f\u00a0\7\f\2\2\u00a0",
    "\u00a2\5\22\n\2\u00a1\u009f\3\2\2\2\u00a2\u00a5\3\2\2\2\u00a3\u00a1",
    "\3\2\2\2\u00a3\u00a4\3\2\2\2\u00a4\21\3\2\2\2\u00a5\u00a3\3\2\2\2\u00a6",
    "\u00a8\7d\2\2\u00a7\u00a9\5\24\13\2\u00a8\u00a7\3\2\2\2\u00a8\u00a9",
    "\3\2\2\2\u00a9\23\3\2\2\2\u00aa\u00ab\7\r\2\2\u00ab\u00ac\5X-\2\u00ac",
    "\25\3\2\2\2\u00ad\u00ae\7\13\2\2\u00ae\27\3\2\2\2\u00af\u00b0\5V,\2",
    "\u00b0\31\3\2\2\2\u00b1\u00b2\7O\2\2\u00b2\u00b3\7\7\2\2\u00b3\u00b4",
    "\5V,\2\u00b4\u00b5\7\b\2\2\u00b5\u00b8\5\b\5\2\u00b6\u00b7\7?\2\2\u00b7",
    "\u00b9\5\b\5\2\u00b8\u00b6\3\2\2\2\u00b8\u00b9\3\2\2\2\u00b9\33\3\2",
    "\2\2\u00ba\u00bb\7;\2\2\u00bb\u00bc\5\b\5\2\u00bc\u00bd\7I\2\2\u00bd",
    "\u00be\7\7\2\2\u00be\u00bf\5V,\2\u00bf\u00c0\7\b\2\2\u00c0\u00c1\5l",
    "\67\2\u00c1\u00f8\3\2\2\2\u00c2\u00c3\7I\2\2\u00c3\u00c4\7\7\2\2\u00c4",
    "\u00c5\5V,\2\u00c5\u00c6\7\b\2\2\u00c6\u00c7\5\b\5\2\u00c7\u00f8\3\2",
    "\2\2\u00c8\u00c9\7G\2\2\u00c9\u00cb\7\7\2\2\u00ca\u00cc\5V,\2\u00cb",
    "\u00ca\3\2\2\2\u00cb\u00cc\3\2\2\2\u00cc\u00cd\3\2\2\2\u00cd\u00cf\7",
    "\13\2\2\u00ce\u00d0\5V,\2\u00cf\u00ce\3\2\2\2\u00cf\u00d0\3\2\2\2\u00d0",
    "\u00d1\3\2\2\2\u00d1\u00d3\7\13\2\2\u00d2\u00d4\5V,\2\u00d3\u00d2\3",
    "\2\2\2\u00d3\u00d4\3\2\2\2\u00d4\u00d5\3\2\2\2\u00d5\u00d6\7\b\2\2\u00d6",
    "\u00f8\5\b\5\2\u00d7\u00d8\7G\2\2\u00d8\u00d9\7\7\2\2\u00d9\u00da\7",
    "A\2\2\u00da\u00db\5\20\t\2\u00db\u00dd\7\13\2\2\u00dc\u00de\5V,\2\u00dd",
    "\u00dc\3\2\2\2\u00dd\u00de\3\2\2\2\u00de\u00df\3\2\2\2\u00df\u00e1\7",
    "\13\2\2\u00e0\u00e2\5V,\2\u00e1\u00e0\3\2\2\2\u00e1\u00e2\3\2\2\2\u00e2",
    "\u00e3\3\2\2\2\u00e3\u00e4\7\b\2\2\u00e4\u00e5\5\b\5\2\u00e5\u00f8\3",
    "\2\2\2\u00e6\u00e7\7G\2\2\u00e7\u00e8\7\7\2\2\u00e8\u00e9\5X-\2\u00e9",
    "\u00ea\7R\2\2\u00ea\u00eb\5V,\2\u00eb\u00ec\7\b\2\2\u00ec\u00ed\5\b",
    "\5\2\u00ed\u00f8\3\2\2\2\u00ee\u00ef\7G\2\2\u00ef\u00f0\7\7\2\2\u00f0",
    "\u00f1\7A\2\2\u00f1\u00f2\5\22\n\2\u00f2\u00f3\7R\2\2\u00f3\u00f4\5",
    "V,\2\u00f4\u00f5\7\b\2\2\u00f5\u00f6\5\b\5\2\u00f6\u00f8\3\2\2\2\u00f7",
    "\u00ba\3\2\2\2\u00f7\u00c2\3\2\2\2\u00f7\u00c8\3\2\2\2\u00f7\u00d7\3",
    "\2\2\2\u00f7\u00e6\3\2\2\2\u00f7\u00ee\3\2\2\2\u00f8\35\3\2\2\2\u00f9",
    "\u00fb\7F\2\2\u00fa\u00fc\7d\2\2\u00fb\u00fa\3\2\2\2\u00fb\u00fc\3\2",
    "\2\2\u00fc\u00fd\3\2\2\2\u00fd\u00fe\5l\67\2\u00fe\37\3\2\2\2\u00ff",
    "\u0101\7:\2\2\u0100\u0102\7d\2\2\u0101\u0100\3\2\2\2\u0101\u0102\3\2",
    "\2\2\u0102\u0103\3\2\2\2\u0103\u0104\5l\67\2\u0104!\3\2\2\2\u0105\u0107",
    "\7D\2\2\u0106\u0108\5V,\2\u0107\u0106\3\2\2\2\u0107\u0108\3\2\2\2\u0108",
    "\u0109\3\2\2\2\u0109\u010a\5l\67\2\u010a#\3\2\2\2\u010b\u010c\7M\2\2",
    "\u010c\u010d\7\7\2\2\u010d\u010e\5V,\2\u010e\u010f\7\b\2\2\u010f\u0110",
    "\5\b\5\2\u0110%\3\2\2\2\u0111\u0112\7H\2\2\u0112\u0113\7\7\2\2\u0113",
    "\u0114\5V,\2\u0114\u0115\7\b\2\2\u0115\u0116\5(\25\2\u0116\'\3\2\2\2",
    "\u0117\u0119\7\t\2\2\u0118\u011a\5*\26\2\u0119\u0118\3\2\2\2\u0119\u011a",
    "\3\2\2\2\u011a\u011f\3\2\2\2\u011b\u011d\5.\30\2\u011c\u011e\5*\26\2",
    "\u011d\u011c\3\2\2\2\u011d\u011e\3\2\2\2\u011e\u0120\3\2\2\2\u011f\u011b",
    "\3\2\2\2\u011f\u0120\3\2\2\2\u0120\u0121\3\2\2\2\u0121\u0122\7\n\2\2",
    "\u0122)\3\2\2\2\u0123\u0125\5,\27\2\u0124\u0123\3\2\2\2\u0125\u0126",
    "\3\2\2\2\u0126\u0124\3\2\2\2\u0126\u0127\3\2\2\2\u0127+\3\2\2\2\u0128",
    "\u0129\7>\2\2\u0129\u012a\5V,\2\u012a\u012c\7\17\2\2\u012b\u012d\5\f",
    "\7\2\u012c\u012b\3\2\2\2\u012c\u012d\3\2\2\2\u012d-\3\2\2\2\u012e\u012f",
    "\7N\2\2\u012f\u0131\7\17\2\2\u0130\u0132\5\f\7\2\u0131\u0130\3\2\2\2",
    "\u0131\u0132\3\2\2\2\u0132/\3\2\2\2\u0133\u0134\7d\2\2\u0134\u0135\7",
    "\17\2\2\u0135\u0136\5\b\5\2\u0136\61\3\2\2\2\u0137\u0138\7P\2\2\u0138",
    "\u0139\5V,\2\u0139\u013a\5l\67\2\u013a\63\3\2\2\2\u013b\u013c\7S\2\2",
    "\u013c\u013d\5\n\6\2\u013d\u013e\5\66\34\2\u013e\u0149\3\2\2\2\u013f",
    "\u0140\7S\2\2\u0140\u0141\5\n\6\2\u0141\u0142\58\35\2\u0142\u0149\3",
    "\2\2\2\u0143\u0144\7S\2\2\u0144\u0145\5\n\6\2\u0145\u0146\5\66\34\2",
    "\u0146\u0147\58\35\2\u0147\u0149\3\2\2\2\u0148\u013b\3\2\2\2\u0148\u013f",
    "\3\2\2\2\u0148\u0143\3\2\2\2\u0149\65\3\2\2\2\u014a\u014b\7B\2\2\u014b",
    "\u014c\7\7\2\2\u014c\u014d\7d\2\2\u014d\u014e\7\b\2\2\u014e\u014f\5",
    "\n\6\2\u014f\67\3\2\2\2\u0150\u0151\7C\2\2\u0151\u0152\5\n\6\2\u0152",
    "9\3\2\2\2\u0153\u0154\7J\2\2\u0154\u0155\5l\67\2\u0155;\3\2\2\2\u0156",
    "\u0157\7K\2\2\u0157\u0158\7d\2\2\u0158\u015a\7\7\2\2\u0159\u015b\5>",
    " \2\u015a\u0159\3\2\2\2\u015a\u015b\3\2\2\2\u015b\u015c\3\2\2\2\u015c",
    "\u015d\7\b\2\2\u015d\u015e\7\t\2\2\u015e\u015f\5@!\2\u015f\u0160\7\n",
    "\2\2\u0160=\3\2\2\2\u0161\u0166\7d\2\2\u0162\u0163\7\f\2\2\u0163\u0165",
    "\7d\2\2\u0164\u0162\3\2\2\2\u0165\u0168\3\2\2\2\u0166\u0164\3\2\2\2",
    "\u0166\u0167\3\2\2\2\u0167?\3\2\2\2\u0168\u0166\3\2\2\2\u0169\u016b",
    "\5\4\3\2\u016a\u0169\3\2\2\2\u016a\u016b\3\2\2\2\u016bA\3\2\2\2\u016c",
    "\u016e\7\5\2\2\u016d\u016f\5D#\2\u016e\u016d\3\2\2\2\u016e\u016f\3\2",
    "\2\2\u016f\u0171\3\2\2\2\u0170\u0172\7\f\2\2\u0171\u0170\3\2\2\2\u0171",
    "\u0172\3\2\2\2\u0172\u0174\3\2\2\2\u0173\u0175\5F$\2\u0174\u0173\3\2",
    "\2\2\u0174\u0175\3\2\2\2\u0175\u0176\3\2\2\2\u0176\u0177\7\6\2\2\u0177",
    "C\3\2\2\2\u0178\u017a\5F$\2\u0179\u0178\3\2\2\2\u0179\u017a\3\2\2\2",
    "\u017a\u017b\3\2\2\2\u017b\u0183\5X-\2\u017c\u017e\7\f\2\2\u017d\u017f",
    "\5F$\2\u017e\u017d\3\2\2\2\u017e\u017f\3\2\2\2\u017f\u0180\3\2\2\2\u0180",
    "\u0182\5X-\2\u0181\u017c\3\2\2\2\u0182\u0185\3\2\2\2\u0183\u0181\3\2",
    "\2\2\u0183\u0184\3\2\2\2\u0184E\3\2\2\2\u0185\u0183\3\2\2\2\u0186\u0188",
    "\7\f\2\2\u0187\u0186\3\2\2\2\u0188\u0189\3\2\2\2\u0189\u0187\3\2\2\2",
    "\u0189\u018a\3\2\2\2\u018aG\3\2\2\2\u018b\u018d\7\t\2\2\u018c\u018e",
    "\5J&\2\u018d\u018c\3\2\2\2\u018d\u018e\3\2\2\2\u018e\u0190\3\2\2\2\u018f",
    "\u0191\7\f\2\2\u0190\u018f\3\2\2\2\u0190\u0191\3\2\2\2\u0191\u0192\3",
    "\2\2\2\u0192\u0193\7\n\2\2\u0193I\3\2\2\2\u0194\u0199\5L\'\2\u0195\u0196",
    "\7\f\2\2\u0196\u0198\5L\'\2\u0197\u0195\3\2\2\2\u0198\u019b\3\2\2\2",
    "\u0199\u0197\3\2\2\2\u0199\u019a\3\2\2\2\u019aK\3\2\2\2\u019b\u0199",
    "\3\2\2\2\u019c\u019d\5N(\2\u019d\u019e\7\17\2\2\u019e\u019f\5X-\2\u019f",
    "\u01b0\3\2\2\2\u01a0\u01a1\5h\65\2\u01a1\u01a2\7\7\2\2\u01a2\u01a3\7",
    "\b\2\2\u01a3\u01a4\7\t\2\2\u01a4\u01a5\5@!\2\u01a5\u01a6\7\n\2\2\u01a6",
    "\u01b0\3\2\2\2\u01a7\u01a8\5j\66\2\u01a8\u01a9\7\7\2\2\u01a9\u01aa\5",
    "P)\2\u01aa\u01ab\7\b\2\2\u01ab\u01ac\7\t\2\2\u01ac\u01ad\5@!\2\u01ad",
    "\u01ae\7\n\2\2\u01ae\u01b0\3\2\2\2\u01af\u019c\3\2\2\2\u01af\u01a0\3",
    "\2\2\2\u01af\u01a7\3\2\2\2\u01b0M\3\2\2\2\u01b1\u01b5\5`\61\2\u01b2",
    "\u01b5\7e\2\2\u01b3\u01b5\5^\60\2\u01b4\u01b1\3\2\2\2\u01b4\u01b2\3",
    "\2\2\2\u01b4\u01b3\3\2\2\2\u01b5O\3\2\2\2\u01b6\u01b7\7d\2\2\u01b7Q",
    "\3\2\2\2\u01b8\u01ba\7\7\2\2\u01b9\u01bb\5T+\2\u01ba\u01b9\3\2\2\2\u01ba",
    "\u01bb\3\2\2\2\u01bb\u01bc\3\2\2\2\u01bc\u01bd\7\b\2\2\u01bdS\3\2\2",
    "\2\u01be\u01c3\5X-\2\u01bf\u01c0\7\f\2\2\u01c0\u01c2\5X-\2\u01c1\u01bf",
    "\3\2\2\2\u01c2\u01c5\3\2\2\2\u01c3\u01c1\3\2\2\2\u01c3\u01c4\3\2\2\2",
    "\u01c4U\3\2\2\2\u01c5\u01c3\3\2\2\2\u01c6\u01cb\5X-\2\u01c7\u01c8\7",
    "\f\2\2\u01c8\u01ca\5X-\2\u01c9\u01c7\3\2\2\2\u01ca\u01cd\3\2\2\2\u01cb",
    "\u01c9\3\2\2\2\u01cb\u01cc\3\2\2\2\u01ccW\3\2\2\2\u01cd\u01cb\3\2\2",
    "\2\u01ce\u01cf\b-\1\2\u01cf\u01d0\7Q\2\2\u01d0\u01fd\5X- \u01d1\u01d2",
    "\7E\2\2\u01d2\u01fd\5X-\37\u01d3\u01d4\7=\2\2\u01d4\u01fd\5X-\36\u01d5",
    "\u01d6\7\21\2\2\u01d6\u01fd\5X-\35\u01d7\u01d8\7\22\2\2\u01d8\u01fd",
    "\5X-\34\u01d9\u01da\7\23\2\2\u01da\u01fd\5X-\33\u01db\u01dc\7\24\2\2",
    "\u01dc\u01fd\5X-\32\u01dd\u01de\7\25\2\2\u01de\u01fd\5X-\31\u01df\u01e0",
    "\7\26\2\2\u01e0\u01fd\5X-\30\u01e1\u01e3\7K\2\2\u01e2\u01e4\7d\2\2\u01e3",
    "\u01e2\3\2\2\2\u01e3\u01e4\3\2\2\2\u01e4\u01e5\3\2\2\2\u01e5\u01e7\7",
    "\7\2\2\u01e6\u01e8\5> \2\u01e7\u01e6\3\2\2\2\u01e7\u01e8\3\2\2\2\u01e8",
    "\u01e9\3\2\2\2\u01e9\u01ea\7\b\2\2\u01ea\u01eb\7\t\2\2\u01eb\u01ec\5",
    "@!\2\u01ec\u01ed\7\n\2\2\u01ed\u01fd\3\2\2\2\u01ee\u01ef\7@\2\2\u01ef",
    "\u01f1\5X-\2\u01f0\u01f2\5R*\2\u01f1\u01f0\3\2\2\2\u01f1\u01f2\3\2\2",
    "\2\u01f2\u01fd\3\2\2\2\u01f3\u01fd\7L\2\2\u01f4\u01fd\7d\2\2\u01f5\u01fd",
    "\5\\/\2\u01f6\u01fd\5B\"\2\u01f7\u01fd\5H%\2\u01f8\u01f9\7\7\2\2\u01f9",
    "\u01fa\5V,\2\u01fa\u01fb\7\b\2\2\u01fb\u01fd\3\2\2\2\u01fc\u01ce\3\2",
    "\2\2\u01fc\u01d1\3\2\2\2\u01fc\u01d3\3\2\2\2\u01fc\u01d5\3\2\2\2\u01fc",
    "\u01d7\3\2\2\2\u01fc\u01d9\3\2\2\2\u01fc\u01db\3\2\2\2\u01fc\u01dd\3",
    "\2\2\2\u01fc\u01df\3\2\2\2\u01fc\u01e1\3\2\2\2\u01fc\u01ee\3\2\2\2\u01fc",
    "\u01f3\3\2\2\2\u01fc\u01f4\3\2\2\2\u01fc\u01f5\3\2\2\2\u01fc\u01f6\3",
    "\2\2\2\u01fc\u01f7\3\2\2\2\u01fc\u01f8\3\2\2\2\u01fd\u0241\3\2\2\2\u01fe",
    "\u01ff\f\27\2\2\u01ff\u0200\t\2\2\2\u0200\u0240\5X-\30\u0201\u0202\f",
    "\26\2\2\u0202\u0203\t\3\2\2\u0203\u0240\5X-\27\u0204\u0205\f\25\2\2",
    "\u0205\u0206\t\4\2\2\u0206\u0240\5X-\26\u0207\u0208\f\24\2\2\u0208\u0209",
    "\t\5\2\2\u0209\u0240\5X-\25\u020a\u020b\f\23\2\2\u020b\u020c\7<\2\2",
    "\u020c\u0240\5X-\24\u020d\u020e\f\22\2\2\u020e\u020f\7R\2\2\u020f\u0240",
    "\5X-\23\u0210\u0211\f\21\2\2\u0211\u0212\t\6\2\2\u0212\u0240\5X-\22",
    "\u0213\u0214\f\20\2\2\u0214\u0215\7%\2\2\u0215\u0240\5X-\21\u0216\u0217",
    "\f\17\2\2\u0217\u0218\7&\2\2\u0218\u0240\5X-\20\u0219\u021a\f\16\2\2",
    "\u021a\u021b\7\'\2\2\u021b\u0240\5X-\17\u021c\u021d\f\r\2\2\u021d\u021e",
    "\7(\2\2\u021e\u0240\5X-\16\u021f\u0220\f\f\2\2\u0220\u0221\7)\2\2\u0221",
    "\u0240\5X-\r\u0222\u0223\f\13\2\2\u0223\u0224\7\16\2\2\u0224\u0225\5",
    "X-\2\u0225\u0226\7\17\2\2\u0226\u0227\5X-\f\u0227\u0240\3\2\2\2\u0228",
    "\u0229\f&\2\2\u0229\u022a\7\5\2\2\u022a\u022b\5V,\2\u022b\u022c\7\6",
    "\2\2\u022c\u0240\3\2\2\2\u022d\u022e\f%\2\2\u022e\u022f\7\20\2\2\u022f",
    "\u0240\5`\61\2\u0230\u0231\f$\2\2\u0231\u0240\5R*\2\u0232\u0233\f\"",
    "\2\2\u0233\u0234\6-\23\2\u0234\u0240\7\21\2\2\u0235\u0236\f!\2\2\u0236",
    "\u0237\6-\25\2\u0237\u0240\7\22\2\2\u0238\u0239\f\n\2\2\u0239\u023a",
    "\7\r\2\2\u023a\u0240\5V,\2\u023b\u023c\f\t\2\2\u023c\u023d\5Z.\2\u023d",
    "\u023e\5V,\2\u023e\u0240\3\2\2\2\u023f\u01fe\3\2\2\2\u023f\u0201\3\2",
    "\2\2\u023f\u0204\3\2\2\2\u023f\u0207\3\2\2\2\u023f\u020a\3\2\2\2\u023f",
    "\u020d\3\2\2\2\u023f\u0210\3\2\2\2\u023f\u0213\3\2\2\2\u023f\u0216\3",
    "\2\2\2\u023f\u0219\3\2\2\2\u023f\u021c\3\2\2\2\u023f\u021f\3\2\2\2\u023f",
    "\u0222\3\2\2\2\u023f\u0228\3\2\2\2\u023f\u022d\3\2\2\2\u023f\u0230\3",
    "\2\2\2\u023f\u0232\3\2\2\2\u023f\u0235\3\2\2\2\u023f\u0238\3\2\2\2\u023f",
    "\u023b\3\2\2\2\u0240\u0243\3\2\2\2\u0241\u023f\3\2\2\2\u0241\u0242\3",
    "\2\2\2\u0242Y\3\2\2\2\u0243\u0241\3\2\2\2\u0244\u0245\t\7\2\2\u0245",
    "[\3\2\2\2\u0246\u0249\t\b\2\2\u0247\u0249\5^\60\2\u0248\u0246\3\2\2",
    "\2\u0248\u0247\3\2\2\2\u0249]\3\2\2\2\u024a\u024b\t\t\2\2\u024b_\3\2",
    "\2\2\u024c\u024f\7d\2\2\u024d\u024f\5b\62\2\u024e\u024c\3\2\2\2\u024e",
    "\u024d\3\2\2\2\u024fa\3\2\2\2\u0250\u0254\5d\63\2\u0251\u0254\5f\64",
    "\2\u0252\u0254\t\n\2\2\u0253\u0250\3\2\2\2\u0253\u0251\3\2\2\2\u0253",
    "\u0252\3\2\2\2\u0254c\3\2\2\2\u0255\u0256\t\13\2\2\u0256e\3\2\2\2\u0257",
    "\u0258\t\f\2\2\u0258g\3\2\2\2\u0259\u025a\6\65\30\2\u025a\u025b\7d\2",
    "\2\u025b\u025c\5N(\2\u025ci\3\2\2\2\u025d\u025e\6\66\31\2\u025e\u025f",
    "\7d\2\2\u025f\u0260\5N(\2\u0260k\3\2\2\2\u0261\u0266\7\13\2\2\u0262",
    "\u0266\7\2\2\3\u0263\u0266\6\67\32\2\u0264\u0266\6\67\33\2\u0265\u0261",
    "\3\2\2\2\u0265\u0262\3\2\2\2\u0265\u0263\3\2\2\2\u0265\u0264\3\2\2\2",
    "\u0266m\3\2\2\2\u0267\u0268\7\2\2\3\u0268o\3\2\2\2\67qx|\u008d\u0091",
    "\u0098\u00a3\u00a8\u00b8\u00cb\u00cf\u00d3\u00dd\u00e1\u00f7\u00fb\u0101",
    "\u0107\u0119\u011d\u011f\u0126\u012c\u0131\u0148\u015a\u0166\u016a\u016e",
    "\u0171\u0174\u0179\u017e\u0183\u0189\u018d\u0190\u0199\u01af\u01b4\u01ba",
    "\u01c3\u01cb\u01e3\u01e7\u01f1\u01fc\u023f\u0241\u0248\u024e\u0253\u0265"].join("");


var atn = new antlr4.atn.ATNDeserializer().deserialize(serializedATN);

var decisionsToDFA = atn.decisionToState.map( function(ds, index) { return new antlr4.dfa.DFA(ds, index); });

var sharedContextCache = new antlr4.PredictionContextCache();

var literalNames = [ 'null', 'null', 'null', "'['", "']'", "'('", "')'", 
                     "'{'", "'}'", "';'", "','", "'='", "'?'", "':'", "'.'", 
                     "'++'", "'--'", "'+'", "'-'", "'~'", "'!'", "'*'", 
                     "'/'", "'%'", "'>>'", "'<<'", "'>>>'", "'<'", "'>'", 
                     "'<='", "'>='", "'=='", "'!='", "'==='", "'!=='", "'&'", 
                     "'^'", "'|'", "'&&'", "'||'", "'*='", "'/='", "'%='", 
                     "'+='", "'-='", "'<<='", "'>>='", "'>>>='", "'&='", 
                     "'^='", "'|='", "'null'", 'null', 'null', 'null', 'null', 
                     "'break'", "'do'", "'instanceof'", "'typeof'", "'case'", 
                     "'else'", "'new'", "'var'", "'catch'", "'finally'", 
                     "'return'", "'void'", "'continue'", "'for'", "'switch'", 
                     "'while'", "'debugger'", "'function'", "'this'", "'with'", 
                     "'default'", "'if'", "'throw'", "'delete'", "'in'", 
                     "'try'", "'class'", "'enum'", "'extends'", "'super'", 
                     "'const'", "'export'", "'import'" ];

var symbolicNames = [ 'null', "RegularExpressionLiteral", "LineTerminator", 
                      "OpenBracket", "CloseBracket", "OpenParen", "CloseParen", 
                      "OpenBrace", "CloseBrace", "SemiColon", "Comma", "Assign", 
                      "QuestionMark", "Colon", "Dot", "PlusPlus", "MinusMinus", 
                      "Plus", "Minus", "BitNot", "Not", "Multiply", "Divide", 
                      "Modulus", "RightShiftArithmetic", "LeftShiftArithmetic", 
                      "RightShiftLogical", "LessThan", "MoreThan", "LessThanEquals", 
                      "GreaterThanEquals", "Equals", "NotEquals", "IdentityEquals", 
                      "IdentityNotEquals", "BitAnd", "BitXOr", "BitOr", 
                      "And", "Or", "MultiplyAssign", "DivideAssign", "ModulusAssign", 
                      "PlusAssign", "MinusAssign", "LeftShiftArithmeticAssign", 
                      "RightShiftArithmeticAssign", "RightShiftLogicalAssign", 
                      "BitAndAssign", "BitXorAssign", "BitOrAssign", "NullLiteral", 
                      "BooleanLiteral", "DecimalLiteral", "HexIntegerLiteral", 
                      "OctalIntegerLiteral", "Break", "Do", "Instanceof", 
                      "Typeof", "Case", "Else", "New", "Var", "Catch", "Finally", 
                      "Return", "Void", "Continue", "For", "Switch", "While", 
                      "Debugger", "Function", "This", "With", "Default", 
                      "If", "Throw", "Delete", "In", "Try", "Class", "Enum", 
                      "Extends", "Super", "Const", "Export", "Import", "Implements", 
                      "Let", "Private", "Public", "Interface", "Package", 
                      "Protected", "Static", "Yield", "Identifier", "StringLiteral", 
                      "WhiteSpaces", "MultiLineComment", "SingleLineComment", 
                      "UnexpectedCharacter" ];

var ruleNames =  [ "program", "sourceElements", "sourceElement", "statement", 
                   "block", "statementList", "variableStatement", "variableDeclarationList", 
                   "variableDeclaration", "initialiser", "emptyStatement", 
                   "expressionStatement", "ifStatement", "iterationStatement", 
                   "continueStatement", "breakStatement", "returnStatement", 
                   "withStatement", "switchStatement", "caseBlock", "caseClauses", 
                   "caseClause", "defaultClause", "labelledStatement", "throwStatement", 
                   "tryStatement", "catchProduction", "finallyProduction", 
                   "debuggerStatement", "functionDeclaration", "formalParameterList", 
                   "functionBody", "arrayLiteral", "elementList", "elision", 
                   "objectLiteral", "propertyNameAndValueList", "propertyAssignment", 
                   "propertyName", "propertySetParameterList", "arguments", 
                   "argumentList", "expressionSequence", "singleExpression", 
                   "assignmentOperator", "literal", "numericLiteral", "identifierName", 
                   "reservedWord", "keyword", "futureReservedWord", "getter", 
                   "setter", "eos", "eof" ];

function ECMAScriptParser (input) {
	antlr4.Parser.call(this, input);
    this._interp = new antlr4.atn.ParserATNSimulator(this, atn, decisionsToDFA, sharedContextCache);
    this.ruleNames = ruleNames;
    this.literalNames = literalNames;
    this.symbolicNames = symbolicNames;

	/**
	 * Returns true if, on the current index of the parser's token stream,
	 * a token of the given type exists on the HIDDEN channel.
	 * @param type {Number} The type of the token on the HIDDEN channel to check.
	 * @returns {Boolean}
	 */
	ECMAScriptParser.prototype.here = function(type) {
	    var possibleIndexEosToken = antlr4.Parser.prototype.getCurrentToken.call(this).tokenIndex - 1;
	    var ahead = this._input.get(possibleIndexEosToken);
	    return (ahead.channel == antlr4.Lexer.HIDDEN) && (ahead.type == type);
	};

	/**
	 * Returns true if, on the current index of the parser's
	 * token stream, a token exists on the HIDDEN channel which
	 * either is a line terminator, or is a multi line comment that
	 * contains a line terminator.
	 * @returns {Boolean}
	 */
	ECMAScriptParser.prototype.lineTerminatorAhead = function() {
	    var possibleIndexEosToken = antlr4.Parser.prototype.getCurrentToken.call(this).tokenIndex - 1;
	    var ahead = this._input.get(possibleIndexEosToken);

	    if (ahead.channel != antlr4.Lexer.HIDDEN)
	        return false;

	    var text = ahead.text;
	    var type = ahead.type;

	    return (type == ECMAScriptParser.MultiLineComment && text.indexOf("\r") !== -1 || text.indexOf("\n") !== -1) ||
	            (type == ECMAScriptParser.LineTerminator);
	};

    return this;
}

ECMAScriptParser.prototype = Object.create(antlr4.Parser.prototype);
ECMAScriptParser.prototype.constructor = ECMAScriptParser;

Object.defineProperty(ECMAScriptParser.prototype, "atn", {
	get : function() {
		return atn;
	}
});

ECMAScriptParser.EOF = antlr4.Token.EOF;
ECMAScriptParser.RegularExpressionLiteral = 1;
ECMAScriptParser.LineTerminator = 2;
ECMAScriptParser.OpenBracket = 3;
ECMAScriptParser.CloseBracket = 4;
ECMAScriptParser.OpenParen = 5;
ECMAScriptParser.CloseParen = 6;
ECMAScriptParser.OpenBrace = 7;
ECMAScriptParser.CloseBrace = 8;
ECMAScriptParser.SemiColon = 9;
ECMAScriptParser.Comma = 10;
ECMAScriptParser.Assign = 11;
ECMAScriptParser.QuestionMark = 12;
ECMAScriptParser.Colon = 13;
ECMAScriptParser.Dot = 14;
ECMAScriptParser.PlusPlus = 15;
ECMAScriptParser.MinusMinus = 16;
ECMAScriptParser.Plus = 17;
ECMAScriptParser.Minus = 18;
ECMAScriptParser.BitNot = 19;
ECMAScriptParser.Not = 20;
ECMAScriptParser.Multiply = 21;
ECMAScriptParser.Divide = 22;
ECMAScriptParser.Modulus = 23;
ECMAScriptParser.RightShiftArithmetic = 24;
ECMAScriptParser.LeftShiftArithmetic = 25;
ECMAScriptParser.RightShiftLogical = 26;
ECMAScriptParser.LessThan = 27;
ECMAScriptParser.MoreThan = 28;
ECMAScriptParser.LessThanEquals = 29;
ECMAScriptParser.GreaterThanEquals = 30;
ECMAScriptParser.Equals = 31;
ECMAScriptParser.NotEquals = 32;
ECMAScriptParser.IdentityEquals = 33;
ECMAScriptParser.IdentityNotEquals = 34;
ECMAScriptParser.BitAnd = 35;
ECMAScriptParser.BitXOr = 36;
ECMAScriptParser.BitOr = 37;
ECMAScriptParser.And = 38;
ECMAScriptParser.Or = 39;
ECMAScriptParser.MultiplyAssign = 40;
ECMAScriptParser.DivideAssign = 41;
ECMAScriptParser.ModulusAssign = 42;
ECMAScriptParser.PlusAssign = 43;
ECMAScriptParser.MinusAssign = 44;
ECMAScriptParser.LeftShiftArithmeticAssign = 45;
ECMAScriptParser.RightShiftArithmeticAssign = 46;
ECMAScriptParser.RightShiftLogicalAssign = 47;
ECMAScriptParser.BitAndAssign = 48;
ECMAScriptParser.BitXorAssign = 49;
ECMAScriptParser.BitOrAssign = 50;
ECMAScriptParser.NullLiteral = 51;
ECMAScriptParser.BooleanLiteral = 52;
ECMAScriptParser.DecimalLiteral = 53;
ECMAScriptParser.HexIntegerLiteral = 54;
ECMAScriptParser.OctalIntegerLiteral = 55;
ECMAScriptParser.Break = 56;
ECMAScriptParser.Do = 57;
ECMAScriptParser.Instanceof = 58;
ECMAScriptParser.Typeof = 59;
ECMAScriptParser.Case = 60;
ECMAScriptParser.Else = 61;
ECMAScriptParser.New = 62;
ECMAScriptParser.Var = 63;
ECMAScriptParser.Catch = 64;
ECMAScriptParser.Finally = 65;
ECMAScriptParser.Return = 66;
ECMAScriptParser.Void = 67;
ECMAScriptParser.Continue = 68;
ECMAScriptParser.For = 69;
ECMAScriptParser.Switch = 70;
ECMAScriptParser.While = 71;
ECMAScriptParser.Debugger = 72;
ECMAScriptParser.Function = 73;
ECMAScriptParser.This = 74;
ECMAScriptParser.With = 75;
ECMAScriptParser.Default = 76;
ECMAScriptParser.If = 77;
ECMAScriptParser.Throw = 78;
ECMAScriptParser.Delete = 79;
ECMAScriptParser.In = 80;
ECMAScriptParser.Try = 81;
ECMAScriptParser.Class = 82;
ECMAScriptParser.Enum = 83;
ECMAScriptParser.Extends = 84;
ECMAScriptParser.Super = 85;
ECMAScriptParser.Const = 86;
ECMAScriptParser.Export = 87;
ECMAScriptParser.Import = 88;
ECMAScriptParser.Implements = 89;
ECMAScriptParser.Let = 90;
ECMAScriptParser.Private = 91;
ECMAScriptParser.Public = 92;
ECMAScriptParser.Interface = 93;
ECMAScriptParser.Package = 94;
ECMAScriptParser.Protected = 95;
ECMAScriptParser.Static = 96;
ECMAScriptParser.Yield = 97;
ECMAScriptParser.Identifier = 98;
ECMAScriptParser.StringLiteral = 99;
ECMAScriptParser.WhiteSpaces = 100;
ECMAScriptParser.MultiLineComment = 101;
ECMAScriptParser.SingleLineComment = 102;
ECMAScriptParser.UnexpectedCharacter = 103;

ECMAScriptParser.RULE_program = 0;
ECMAScriptParser.RULE_sourceElements = 1;
ECMAScriptParser.RULE_sourceElement = 2;
ECMAScriptParser.RULE_statement = 3;
ECMAScriptParser.RULE_block = 4;
ECMAScriptParser.RULE_statementList = 5;
ECMAScriptParser.RULE_variableStatement = 6;
ECMAScriptParser.RULE_variableDeclarationList = 7;
ECMAScriptParser.RULE_variableDeclaration = 8;
ECMAScriptParser.RULE_initialiser = 9;
ECMAScriptParser.RULE_emptyStatement = 10;
ECMAScriptParser.RULE_expressionStatement = 11;
ECMAScriptParser.RULE_ifStatement = 12;
ECMAScriptParser.RULE_iterationStatement = 13;
ECMAScriptParser.RULE_continueStatement = 14;
ECMAScriptParser.RULE_breakStatement = 15;
ECMAScriptParser.RULE_returnStatement = 16;
ECMAScriptParser.RULE_withStatement = 17;
ECMAScriptParser.RULE_switchStatement = 18;
ECMAScriptParser.RULE_caseBlock = 19;
ECMAScriptParser.RULE_caseClauses = 20;
ECMAScriptParser.RULE_caseClause = 21;
ECMAScriptParser.RULE_defaultClause = 22;
ECMAScriptParser.RULE_labelledStatement = 23;
ECMAScriptParser.RULE_throwStatement = 24;
ECMAScriptParser.RULE_tryStatement = 25;
ECMAScriptParser.RULE_catchProduction = 26;
ECMAScriptParser.RULE_finallyProduction = 27;
ECMAScriptParser.RULE_debuggerStatement = 28;
ECMAScriptParser.RULE_functionDeclaration = 29;
ECMAScriptParser.RULE_formalParameterList = 30;
ECMAScriptParser.RULE_functionBody = 31;
ECMAScriptParser.RULE_arrayLiteral = 32;
ECMAScriptParser.RULE_elementList = 33;
ECMAScriptParser.RULE_elision = 34;
ECMAScriptParser.RULE_objectLiteral = 35;
ECMAScriptParser.RULE_propertyNameAndValueList = 36;
ECMAScriptParser.RULE_propertyAssignment = 37;
ECMAScriptParser.RULE_propertyName = 38;
ECMAScriptParser.RULE_propertySetParameterList = 39;
ECMAScriptParser.RULE_arguments = 40;
ECMAScriptParser.RULE_argumentList = 41;
ECMAScriptParser.RULE_expressionSequence = 42;
ECMAScriptParser.RULE_singleExpression = 43;
ECMAScriptParser.RULE_assignmentOperator = 44;
ECMAScriptParser.RULE_literal = 45;
ECMAScriptParser.RULE_numericLiteral = 46;
ECMAScriptParser.RULE_identifierName = 47;
ECMAScriptParser.RULE_reservedWord = 48;
ECMAScriptParser.RULE_keyword = 49;
ECMAScriptParser.RULE_futureReservedWord = 50;
ECMAScriptParser.RULE_getter = 51;
ECMAScriptParser.RULE_setter = 52;
ECMAScriptParser.RULE_eos = 53;
ECMAScriptParser.RULE_eof = 54;

function ProgramContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_program;
    return this;
}

ProgramContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
ProgramContext.prototype.constructor = ProgramContext;

ProgramContext.prototype.EOF = function() {
    return this.getToken(ECMAScriptParser.EOF, 0);
};

ProgramContext.prototype.sourceElements = function() {
    return this.getTypedRuleContext(SourceElementsContext,0);
};

ProgramContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterProgram(this);
	}
};

ProgramContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitProgram(this);
	}
};




ECMAScriptParser.ProgramContext = ProgramContext;

ECMAScriptParser.prototype.program = function() {

    var localctx = new ProgramContext(this, this._ctx, this.state);
    this.enterRule(localctx, 0, ECMAScriptParser.RULE_program);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 111;
        _la = this._input.LA(1);
        if((((_la) & ~0x1f) == 0 && ((1 << _la) & ((1 << ECMAScriptParser.RegularExpressionLiteral) | (1 << ECMAScriptParser.OpenBracket) | (1 << ECMAScriptParser.OpenParen) | (1 << ECMAScriptParser.OpenBrace) | (1 << ECMAScriptParser.SemiColon) | (1 << ECMAScriptParser.PlusPlus) | (1 << ECMAScriptParser.MinusMinus) | (1 << ECMAScriptParser.Plus) | (1 << ECMAScriptParser.Minus) | (1 << ECMAScriptParser.BitNot) | (1 << ECMAScriptParser.Not))) !== 0) || ((((_la - 51)) & ~0x1f) == 0 && ((1 << (_la - 51)) & ((1 << (ECMAScriptParser.NullLiteral - 51)) | (1 << (ECMAScriptParser.BooleanLiteral - 51)) | (1 << (ECMAScriptParser.DecimalLiteral - 51)) | (1 << (ECMAScriptParser.HexIntegerLiteral - 51)) | (1 << (ECMAScriptParser.OctalIntegerLiteral - 51)) | (1 << (ECMAScriptParser.Break - 51)) | (1 << (ECMAScriptParser.Do - 51)) | (1 << (ECMAScriptParser.Typeof - 51)) | (1 << (ECMAScriptParser.New - 51)) | (1 << (ECMAScriptParser.Var - 51)) | (1 << (ECMAScriptParser.Return - 51)) | (1 << (ECMAScriptParser.Void - 51)) | (1 << (ECMAScriptParser.Continue - 51)) | (1 << (ECMAScriptParser.For - 51)) | (1 << (ECMAScriptParser.Switch - 51)) | (1 << (ECMAScriptParser.While - 51)) | (1 << (ECMAScriptParser.Debugger - 51)) | (1 << (ECMAScriptParser.Function - 51)) | (1 << (ECMAScriptParser.This - 51)) | (1 << (ECMAScriptParser.With - 51)) | (1 << (ECMAScriptParser.If - 51)) | (1 << (ECMAScriptParser.Throw - 51)) | (1 << (ECMAScriptParser.Delete - 51)) | (1 << (ECMAScriptParser.Try - 51)))) !== 0) || _la===ECMAScriptParser.Identifier || _la===ECMAScriptParser.StringLiteral) {
            this.state = 110;
            this.sourceElements();
        }

        this.state = 113;
        this.match(ECMAScriptParser.EOF);
    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function SourceElementsContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_sourceElements;
    return this;
}

SourceElementsContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
SourceElementsContext.prototype.constructor = SourceElementsContext;

SourceElementsContext.prototype.sourceElement = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(SourceElementContext);
    } else {
        return this.getTypedRuleContext(SourceElementContext,i);
    }
};

SourceElementsContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterSourceElements(this);
	}
};

SourceElementsContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitSourceElements(this);
	}
};




ECMAScriptParser.SourceElementsContext = SourceElementsContext;

ECMAScriptParser.prototype.sourceElements = function() {

    var localctx = new SourceElementsContext(this, this._ctx, this.state);
    this.enterRule(localctx, 2, ECMAScriptParser.RULE_sourceElements);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 116; 
        this._errHandler.sync(this);
        _la = this._input.LA(1);
        do {
            this.state = 115;
            this.sourceElement();
            this.state = 118; 
            this._errHandler.sync(this);
            _la = this._input.LA(1);
        } while((((_la) & ~0x1f) == 0 && ((1 << _la) & ((1 << ECMAScriptParser.RegularExpressionLiteral) | (1 << ECMAScriptParser.OpenBracket) | (1 << ECMAScriptParser.OpenParen) | (1 << ECMAScriptParser.OpenBrace) | (1 << ECMAScriptParser.SemiColon) | (1 << ECMAScriptParser.PlusPlus) | (1 << ECMAScriptParser.MinusMinus) | (1 << ECMAScriptParser.Plus) | (1 << ECMAScriptParser.Minus) | (1 << ECMAScriptParser.BitNot) | (1 << ECMAScriptParser.Not))) !== 0) || ((((_la - 51)) & ~0x1f) == 0 && ((1 << (_la - 51)) & ((1 << (ECMAScriptParser.NullLiteral - 51)) | (1 << (ECMAScriptParser.BooleanLiteral - 51)) | (1 << (ECMAScriptParser.DecimalLiteral - 51)) | (1 << (ECMAScriptParser.HexIntegerLiteral - 51)) | (1 << (ECMAScriptParser.OctalIntegerLiteral - 51)) | (1 << (ECMAScriptParser.Break - 51)) | (1 << (ECMAScriptParser.Do - 51)) | (1 << (ECMAScriptParser.Typeof - 51)) | (1 << (ECMAScriptParser.New - 51)) | (1 << (ECMAScriptParser.Var - 51)) | (1 << (ECMAScriptParser.Return - 51)) | (1 << (ECMAScriptParser.Void - 51)) | (1 << (ECMAScriptParser.Continue - 51)) | (1 << (ECMAScriptParser.For - 51)) | (1 << (ECMAScriptParser.Switch - 51)) | (1 << (ECMAScriptParser.While - 51)) | (1 << (ECMAScriptParser.Debugger - 51)) | (1 << (ECMAScriptParser.Function - 51)) | (1 << (ECMAScriptParser.This - 51)) | (1 << (ECMAScriptParser.With - 51)) | (1 << (ECMAScriptParser.If - 51)) | (1 << (ECMAScriptParser.Throw - 51)) | (1 << (ECMAScriptParser.Delete - 51)) | (1 << (ECMAScriptParser.Try - 51)))) !== 0) || _la===ECMAScriptParser.Identifier || _la===ECMAScriptParser.StringLiteral);
    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function SourceElementContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_sourceElement;
    return this;
}

SourceElementContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
SourceElementContext.prototype.constructor = SourceElementContext;

SourceElementContext.prototype.statement = function() {
    return this.getTypedRuleContext(StatementContext,0);
};

SourceElementContext.prototype.functionDeclaration = function() {
    return this.getTypedRuleContext(FunctionDeclarationContext,0);
};

SourceElementContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterSourceElement(this);
	}
};

SourceElementContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitSourceElement(this);
	}
};




ECMAScriptParser.SourceElementContext = SourceElementContext;

ECMAScriptParser.prototype.sourceElement = function() {

    var localctx = new SourceElementContext(this, this._ctx, this.state);
    this.enterRule(localctx, 4, ECMAScriptParser.RULE_sourceElement);
    try {
        this.state = 122;
        var la_ = this._interp.adaptivePredict(this._input,2,this._ctx);
        switch(la_) {
        case 1:
            this.enterOuterAlt(localctx, 1);
            this.state = 120;
            this.statement();
            break;

        case 2:
            this.enterOuterAlt(localctx, 2);
            this.state = 121;
            this.functionDeclaration();
            break;

        }
    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function StatementContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_statement;
    return this;
}

StatementContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
StatementContext.prototype.constructor = StatementContext;

StatementContext.prototype.block = function() {
    return this.getTypedRuleContext(BlockContext,0);
};

StatementContext.prototype.variableStatement = function() {
    return this.getTypedRuleContext(VariableStatementContext,0);
};

StatementContext.prototype.emptyStatement = function() {
    return this.getTypedRuleContext(EmptyStatementContext,0);
};

StatementContext.prototype.expressionStatement = function() {
    return this.getTypedRuleContext(ExpressionStatementContext,0);
};

StatementContext.prototype.ifStatement = function() {
    return this.getTypedRuleContext(IfStatementContext,0);
};

StatementContext.prototype.iterationStatement = function() {
    return this.getTypedRuleContext(IterationStatementContext,0);
};

StatementContext.prototype.continueStatement = function() {
    return this.getTypedRuleContext(ContinueStatementContext,0);
};

StatementContext.prototype.breakStatement = function() {
    return this.getTypedRuleContext(BreakStatementContext,0);
};

StatementContext.prototype.returnStatement = function() {
    return this.getTypedRuleContext(ReturnStatementContext,0);
};

StatementContext.prototype.withStatement = function() {
    return this.getTypedRuleContext(WithStatementContext,0);
};

StatementContext.prototype.labelledStatement = function() {
    return this.getTypedRuleContext(LabelledStatementContext,0);
};

StatementContext.prototype.switchStatement = function() {
    return this.getTypedRuleContext(SwitchStatementContext,0);
};

StatementContext.prototype.throwStatement = function() {
    return this.getTypedRuleContext(ThrowStatementContext,0);
};

StatementContext.prototype.tryStatement = function() {
    return this.getTypedRuleContext(TryStatementContext,0);
};

StatementContext.prototype.debuggerStatement = function() {
    return this.getTypedRuleContext(DebuggerStatementContext,0);
};

StatementContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterStatement(this);
	}
};

StatementContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitStatement(this);
	}
};




ECMAScriptParser.StatementContext = StatementContext;

ECMAScriptParser.prototype.statement = function() {

    var localctx = new StatementContext(this, this._ctx, this.state);
    this.enterRule(localctx, 6, ECMAScriptParser.RULE_statement);
    try {
        this.state = 139;
        var la_ = this._interp.adaptivePredict(this._input,3,this._ctx);
        switch(la_) {
        case 1:
            this.enterOuterAlt(localctx, 1);
            this.state = 124;
            this.block();
            break;

        case 2:
            this.enterOuterAlt(localctx, 2);
            this.state = 125;
            this.variableStatement();
            break;

        case 3:
            this.enterOuterAlt(localctx, 3);
            this.state = 126;
            this.emptyStatement();
            break;

        case 4:
            this.enterOuterAlt(localctx, 4);
            this.state = 127;
            this.expressionStatement();
            break;

        case 5:
            this.enterOuterAlt(localctx, 5);
            this.state = 128;
            this.ifStatement();
            break;

        case 6:
            this.enterOuterAlt(localctx, 6);
            this.state = 129;
            this.iterationStatement();
            break;

        case 7:
            this.enterOuterAlt(localctx, 7);
            this.state = 130;
            this.continueStatement();
            break;

        case 8:
            this.enterOuterAlt(localctx, 8);
            this.state = 131;
            this.breakStatement();
            break;

        case 9:
            this.enterOuterAlt(localctx, 9);
            this.state = 132;
            this.returnStatement();
            break;

        case 10:
            this.enterOuterAlt(localctx, 10);
            this.state = 133;
            this.withStatement();
            break;

        case 11:
            this.enterOuterAlt(localctx, 11);
            this.state = 134;
            this.labelledStatement();
            break;

        case 12:
            this.enterOuterAlt(localctx, 12);
            this.state = 135;
            this.switchStatement();
            break;

        case 13:
            this.enterOuterAlt(localctx, 13);
            this.state = 136;
            this.throwStatement();
            break;

        case 14:
            this.enterOuterAlt(localctx, 14);
            this.state = 137;
            this.tryStatement();
            break;

        case 15:
            this.enterOuterAlt(localctx, 15);
            this.state = 138;
            this.debuggerStatement();
            break;

        }
    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function BlockContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_block;
    return this;
}

BlockContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
BlockContext.prototype.constructor = BlockContext;

BlockContext.prototype.statementList = function() {
    return this.getTypedRuleContext(StatementListContext,0);
};

BlockContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterBlock(this);
	}
};

BlockContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitBlock(this);
	}
};




ECMAScriptParser.BlockContext = BlockContext;

ECMAScriptParser.prototype.block = function() {

    var localctx = new BlockContext(this, this._ctx, this.state);
    this.enterRule(localctx, 8, ECMAScriptParser.RULE_block);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 141;
        this.match(ECMAScriptParser.OpenBrace);
        this.state = 143;
        _la = this._input.LA(1);
        if((((_la) & ~0x1f) == 0 && ((1 << _la) & ((1 << ECMAScriptParser.RegularExpressionLiteral) | (1 << ECMAScriptParser.OpenBracket) | (1 << ECMAScriptParser.OpenParen) | (1 << ECMAScriptParser.OpenBrace) | (1 << ECMAScriptParser.SemiColon) | (1 << ECMAScriptParser.PlusPlus) | (1 << ECMAScriptParser.MinusMinus) | (1 << ECMAScriptParser.Plus) | (1 << ECMAScriptParser.Minus) | (1 << ECMAScriptParser.BitNot) | (1 << ECMAScriptParser.Not))) !== 0) || ((((_la - 51)) & ~0x1f) == 0 && ((1 << (_la - 51)) & ((1 << (ECMAScriptParser.NullLiteral - 51)) | (1 << (ECMAScriptParser.BooleanLiteral - 51)) | (1 << (ECMAScriptParser.DecimalLiteral - 51)) | (1 << (ECMAScriptParser.HexIntegerLiteral - 51)) | (1 << (ECMAScriptParser.OctalIntegerLiteral - 51)) | (1 << (ECMAScriptParser.Break - 51)) | (1 << (ECMAScriptParser.Do - 51)) | (1 << (ECMAScriptParser.Typeof - 51)) | (1 << (ECMAScriptParser.New - 51)) | (1 << (ECMAScriptParser.Var - 51)) | (1 << (ECMAScriptParser.Return - 51)) | (1 << (ECMAScriptParser.Void - 51)) | (1 << (ECMAScriptParser.Continue - 51)) | (1 << (ECMAScriptParser.For - 51)) | (1 << (ECMAScriptParser.Switch - 51)) | (1 << (ECMAScriptParser.While - 51)) | (1 << (ECMAScriptParser.Debugger - 51)) | (1 << (ECMAScriptParser.Function - 51)) | (1 << (ECMAScriptParser.This - 51)) | (1 << (ECMAScriptParser.With - 51)) | (1 << (ECMAScriptParser.If - 51)) | (1 << (ECMAScriptParser.Throw - 51)) | (1 << (ECMAScriptParser.Delete - 51)) | (1 << (ECMAScriptParser.Try - 51)))) !== 0) || _la===ECMAScriptParser.Identifier || _la===ECMAScriptParser.StringLiteral) {
            this.state = 142;
            this.statementList();
        }

        this.state = 145;
        this.match(ECMAScriptParser.CloseBrace);
    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function StatementListContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_statementList;
    return this;
}

StatementListContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
StatementListContext.prototype.constructor = StatementListContext;

StatementListContext.prototype.statement = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(StatementContext);
    } else {
        return this.getTypedRuleContext(StatementContext,i);
    }
};

StatementListContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterStatementList(this);
	}
};

StatementListContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitStatementList(this);
	}
};




ECMAScriptParser.StatementListContext = StatementListContext;

ECMAScriptParser.prototype.statementList = function() {

    var localctx = new StatementListContext(this, this._ctx, this.state);
    this.enterRule(localctx, 10, ECMAScriptParser.RULE_statementList);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 148; 
        this._errHandler.sync(this);
        _la = this._input.LA(1);
        do {
            this.state = 147;
            this.statement();
            this.state = 150; 
            this._errHandler.sync(this);
            _la = this._input.LA(1);
        } while((((_la) & ~0x1f) == 0 && ((1 << _la) & ((1 << ECMAScriptParser.RegularExpressionLiteral) | (1 << ECMAScriptParser.OpenBracket) | (1 << ECMAScriptParser.OpenParen) | (1 << ECMAScriptParser.OpenBrace) | (1 << ECMAScriptParser.SemiColon) | (1 << ECMAScriptParser.PlusPlus) | (1 << ECMAScriptParser.MinusMinus) | (1 << ECMAScriptParser.Plus) | (1 << ECMAScriptParser.Minus) | (1 << ECMAScriptParser.BitNot) | (1 << ECMAScriptParser.Not))) !== 0) || ((((_la - 51)) & ~0x1f) == 0 && ((1 << (_la - 51)) & ((1 << (ECMAScriptParser.NullLiteral - 51)) | (1 << (ECMAScriptParser.BooleanLiteral - 51)) | (1 << (ECMAScriptParser.DecimalLiteral - 51)) | (1 << (ECMAScriptParser.HexIntegerLiteral - 51)) | (1 << (ECMAScriptParser.OctalIntegerLiteral - 51)) | (1 << (ECMAScriptParser.Break - 51)) | (1 << (ECMAScriptParser.Do - 51)) | (1 << (ECMAScriptParser.Typeof - 51)) | (1 << (ECMAScriptParser.New - 51)) | (1 << (ECMAScriptParser.Var - 51)) | (1 << (ECMAScriptParser.Return - 51)) | (1 << (ECMAScriptParser.Void - 51)) | (1 << (ECMAScriptParser.Continue - 51)) | (1 << (ECMAScriptParser.For - 51)) | (1 << (ECMAScriptParser.Switch - 51)) | (1 << (ECMAScriptParser.While - 51)) | (1 << (ECMAScriptParser.Debugger - 51)) | (1 << (ECMAScriptParser.Function - 51)) | (1 << (ECMAScriptParser.This - 51)) | (1 << (ECMAScriptParser.With - 51)) | (1 << (ECMAScriptParser.If - 51)) | (1 << (ECMAScriptParser.Throw - 51)) | (1 << (ECMAScriptParser.Delete - 51)) | (1 << (ECMAScriptParser.Try - 51)))) !== 0) || _la===ECMAScriptParser.Identifier || _la===ECMAScriptParser.StringLiteral);
    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function VariableStatementContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_variableStatement;
    return this;
}

VariableStatementContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
VariableStatementContext.prototype.constructor = VariableStatementContext;

VariableStatementContext.prototype.Var = function() {
    return this.getToken(ECMAScriptParser.Var, 0);
};

VariableStatementContext.prototype.variableDeclarationList = function() {
    return this.getTypedRuleContext(VariableDeclarationListContext,0);
};

VariableStatementContext.prototype.eos = function() {
    return this.getTypedRuleContext(EosContext,0);
};

VariableStatementContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterVariableStatement(this);
	}
};

VariableStatementContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitVariableStatement(this);
	}
};




ECMAScriptParser.VariableStatementContext = VariableStatementContext;

ECMAScriptParser.prototype.variableStatement = function() {

    var localctx = new VariableStatementContext(this, this._ctx, this.state);
    this.enterRule(localctx, 12, ECMAScriptParser.RULE_variableStatement);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 152;
        this.match(ECMAScriptParser.Var);
        this.state = 153;
        this.variableDeclarationList();
        this.state = 154;
        this.eos();
    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function VariableDeclarationListContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_variableDeclarationList;
    return this;
}

VariableDeclarationListContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
VariableDeclarationListContext.prototype.constructor = VariableDeclarationListContext;

VariableDeclarationListContext.prototype.variableDeclaration = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(VariableDeclarationContext);
    } else {
        return this.getTypedRuleContext(VariableDeclarationContext,i);
    }
};

VariableDeclarationListContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterVariableDeclarationList(this);
	}
};

VariableDeclarationListContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitVariableDeclarationList(this);
	}
};




ECMAScriptParser.VariableDeclarationListContext = VariableDeclarationListContext;

ECMAScriptParser.prototype.variableDeclarationList = function() {

    var localctx = new VariableDeclarationListContext(this, this._ctx, this.state);
    this.enterRule(localctx, 14, ECMAScriptParser.RULE_variableDeclarationList);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 156;
        this.variableDeclaration();
        this.state = 161;
        this._errHandler.sync(this);
        var _alt = this._interp.adaptivePredict(this._input,6,this._ctx)
        while(_alt!=2 && _alt!=antlr4.atn.ATN.INVALID_ALT_NUMBER) {
            if(_alt===1) {
                this.state = 157;
                this.match(ECMAScriptParser.Comma);
                this.state = 158;
                this.variableDeclaration(); 
            }
            this.state = 163;
            this._errHandler.sync(this);
            _alt = this._interp.adaptivePredict(this._input,6,this._ctx);
        }

    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function VariableDeclarationContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_variableDeclaration;
    return this;
}

VariableDeclarationContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
VariableDeclarationContext.prototype.constructor = VariableDeclarationContext;

VariableDeclarationContext.prototype.Identifier = function() {
    return this.getToken(ECMAScriptParser.Identifier, 0);
};

VariableDeclarationContext.prototype.initialiser = function() {
    return this.getTypedRuleContext(InitialiserContext,0);
};

VariableDeclarationContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterVariableDeclaration(this);
	}
};

VariableDeclarationContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitVariableDeclaration(this);
	}
};




ECMAScriptParser.VariableDeclarationContext = VariableDeclarationContext;

ECMAScriptParser.prototype.variableDeclaration = function() {

    var localctx = new VariableDeclarationContext(this, this._ctx, this.state);
    this.enterRule(localctx, 16, ECMAScriptParser.RULE_variableDeclaration);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 164;
        this.match(ECMAScriptParser.Identifier);
        this.state = 166;
        var la_ = this._interp.adaptivePredict(this._input,7,this._ctx);
        if(la_===1) {
            this.state = 165;
            this.initialiser();

        }
    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function InitialiserContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_initialiser;
    return this;
}

InitialiserContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
InitialiserContext.prototype.constructor = InitialiserContext;

InitialiserContext.prototype.singleExpression = function() {
    return this.getTypedRuleContext(SingleExpressionContext,0);
};

InitialiserContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterInitialiser(this);
	}
};

InitialiserContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitInitialiser(this);
	}
};




ECMAScriptParser.InitialiserContext = InitialiserContext;

ECMAScriptParser.prototype.initialiser = function() {

    var localctx = new InitialiserContext(this, this._ctx, this.state);
    this.enterRule(localctx, 18, ECMAScriptParser.RULE_initialiser);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 168;
        this.match(ECMAScriptParser.Assign);
        this.state = 169;
        this.singleExpression(0);
    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function EmptyStatementContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_emptyStatement;
    return this;
}

EmptyStatementContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
EmptyStatementContext.prototype.constructor = EmptyStatementContext;

EmptyStatementContext.prototype.SemiColon = function() {
    return this.getToken(ECMAScriptParser.SemiColon, 0);
};

EmptyStatementContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterEmptyStatement(this);
	}
};

EmptyStatementContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitEmptyStatement(this);
	}
};




ECMAScriptParser.EmptyStatementContext = EmptyStatementContext;

ECMAScriptParser.prototype.emptyStatement = function() {

    var localctx = new EmptyStatementContext(this, this._ctx, this.state);
    this.enterRule(localctx, 20, ECMAScriptParser.RULE_emptyStatement);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 171;
        this.match(ECMAScriptParser.SemiColon);
    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function ExpressionStatementContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_expressionStatement;
    return this;
}

ExpressionStatementContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
ExpressionStatementContext.prototype.constructor = ExpressionStatementContext;

ExpressionStatementContext.prototype.expressionSequence = function() {
    return this.getTypedRuleContext(ExpressionSequenceContext,0);
};

ExpressionStatementContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterExpressionStatement(this);
	}
};

ExpressionStatementContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitExpressionStatement(this);
	}
};




ECMAScriptParser.ExpressionStatementContext = ExpressionStatementContext;

ECMAScriptParser.prototype.expressionStatement = function() {

    var localctx = new ExpressionStatementContext(this, this._ctx, this.state);
    this.enterRule(localctx, 22, ECMAScriptParser.RULE_expressionStatement);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 173;
        this.expressionSequence();
    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function IfStatementContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_ifStatement;
    return this;
}

IfStatementContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
IfStatementContext.prototype.constructor = IfStatementContext;

IfStatementContext.prototype.If = function() {
    return this.getToken(ECMAScriptParser.If, 0);
};

IfStatementContext.prototype.expressionSequence = function() {
    return this.getTypedRuleContext(ExpressionSequenceContext,0);
};

IfStatementContext.prototype.statement = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(StatementContext);
    } else {
        return this.getTypedRuleContext(StatementContext,i);
    }
};

IfStatementContext.prototype.Else = function() {
    return this.getToken(ECMAScriptParser.Else, 0);
};

IfStatementContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterIfStatement(this);
	}
};

IfStatementContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitIfStatement(this);
	}
};




ECMAScriptParser.IfStatementContext = IfStatementContext;

ECMAScriptParser.prototype.ifStatement = function() {

    var localctx = new IfStatementContext(this, this._ctx, this.state);
    this.enterRule(localctx, 24, ECMAScriptParser.RULE_ifStatement);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 175;
        this.match(ECMAScriptParser.If);
        this.state = 176;
        this.match(ECMAScriptParser.OpenParen);
        this.state = 177;
        this.expressionSequence();
        this.state = 178;
        this.match(ECMAScriptParser.CloseParen);
        this.state = 179;
        this.statement();
        this.state = 182;
        var la_ = this._interp.adaptivePredict(this._input,8,this._ctx);
        if(la_===1) {
            this.state = 180;
            this.match(ECMAScriptParser.Else);
            this.state = 181;
            this.statement();

        }
    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function IterationStatementContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_iterationStatement;
    return this;
}

IterationStatementContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
IterationStatementContext.prototype.constructor = IterationStatementContext;


 
IterationStatementContext.prototype.copyFrom = function(ctx) {
    antlr4.ParserRuleContext.prototype.copyFrom.call(this, ctx);
};


function DoStatementContext(parser, ctx) {
	IterationStatementContext.call(this, parser);
    IterationStatementContext.prototype.copyFrom.call(this, ctx);
    return this;
}

DoStatementContext.prototype = Object.create(IterationStatementContext.prototype);
DoStatementContext.prototype.constructor = DoStatementContext;

ECMAScriptParser.DoStatementContext = DoStatementContext;

DoStatementContext.prototype.Do = function() {
    return this.getToken(ECMAScriptParser.Do, 0);
};

DoStatementContext.prototype.statement = function() {
    return this.getTypedRuleContext(StatementContext,0);
};

DoStatementContext.prototype.While = function() {
    return this.getToken(ECMAScriptParser.While, 0);
};

DoStatementContext.prototype.expressionSequence = function() {
    return this.getTypedRuleContext(ExpressionSequenceContext,0);
};

DoStatementContext.prototype.eos = function() {
    return this.getTypedRuleContext(EosContext,0);
};
DoStatementContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterDoStatement(this);
	}
};

DoStatementContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitDoStatement(this);
	}
};


function ForVarInStatementContext(parser, ctx) {
	IterationStatementContext.call(this, parser);
    IterationStatementContext.prototype.copyFrom.call(this, ctx);
    return this;
}

ForVarInStatementContext.prototype = Object.create(IterationStatementContext.prototype);
ForVarInStatementContext.prototype.constructor = ForVarInStatementContext;

ECMAScriptParser.ForVarInStatementContext = ForVarInStatementContext;

ForVarInStatementContext.prototype.For = function() {
    return this.getToken(ECMAScriptParser.For, 0);
};

ForVarInStatementContext.prototype.Var = function() {
    return this.getToken(ECMAScriptParser.Var, 0);
};

ForVarInStatementContext.prototype.variableDeclaration = function() {
    return this.getTypedRuleContext(VariableDeclarationContext,0);
};

ForVarInStatementContext.prototype.In = function() {
    return this.getToken(ECMAScriptParser.In, 0);
};

ForVarInStatementContext.prototype.expressionSequence = function() {
    return this.getTypedRuleContext(ExpressionSequenceContext,0);
};

ForVarInStatementContext.prototype.statement = function() {
    return this.getTypedRuleContext(StatementContext,0);
};
ForVarInStatementContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterForVarInStatement(this);
	}
};

ForVarInStatementContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitForVarInStatement(this);
	}
};


function ForStatementContext(parser, ctx) {
	IterationStatementContext.call(this, parser);
    IterationStatementContext.prototype.copyFrom.call(this, ctx);
    return this;
}

ForStatementContext.prototype = Object.create(IterationStatementContext.prototype);
ForStatementContext.prototype.constructor = ForStatementContext;

ECMAScriptParser.ForStatementContext = ForStatementContext;

ForStatementContext.prototype.For = function() {
    return this.getToken(ECMAScriptParser.For, 0);
};

ForStatementContext.prototype.statement = function() {
    return this.getTypedRuleContext(StatementContext,0);
};

ForStatementContext.prototype.expressionSequence = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(ExpressionSequenceContext);
    } else {
        return this.getTypedRuleContext(ExpressionSequenceContext,i);
    }
};
ForStatementContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterForStatement(this);
	}
};

ForStatementContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitForStatement(this);
	}
};


function WhileStatementContext(parser, ctx) {
	IterationStatementContext.call(this, parser);
    IterationStatementContext.prototype.copyFrom.call(this, ctx);
    return this;
}

WhileStatementContext.prototype = Object.create(IterationStatementContext.prototype);
WhileStatementContext.prototype.constructor = WhileStatementContext;

ECMAScriptParser.WhileStatementContext = WhileStatementContext;

WhileStatementContext.prototype.While = function() {
    return this.getToken(ECMAScriptParser.While, 0);
};

WhileStatementContext.prototype.expressionSequence = function() {
    return this.getTypedRuleContext(ExpressionSequenceContext,0);
};

WhileStatementContext.prototype.statement = function() {
    return this.getTypedRuleContext(StatementContext,0);
};
WhileStatementContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterWhileStatement(this);
	}
};

WhileStatementContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitWhileStatement(this);
	}
};


function ForInStatementContext(parser, ctx) {
	IterationStatementContext.call(this, parser);
    IterationStatementContext.prototype.copyFrom.call(this, ctx);
    return this;
}

ForInStatementContext.prototype = Object.create(IterationStatementContext.prototype);
ForInStatementContext.prototype.constructor = ForInStatementContext;

ECMAScriptParser.ForInStatementContext = ForInStatementContext;

ForInStatementContext.prototype.For = function() {
    return this.getToken(ECMAScriptParser.For, 0);
};

ForInStatementContext.prototype.singleExpression = function() {
    return this.getTypedRuleContext(SingleExpressionContext,0);
};

ForInStatementContext.prototype.In = function() {
    return this.getToken(ECMAScriptParser.In, 0);
};

ForInStatementContext.prototype.expressionSequence = function() {
    return this.getTypedRuleContext(ExpressionSequenceContext,0);
};

ForInStatementContext.prototype.statement = function() {
    return this.getTypedRuleContext(StatementContext,0);
};
ForInStatementContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterForInStatement(this);
	}
};

ForInStatementContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitForInStatement(this);
	}
};


function ForVarStatementContext(parser, ctx) {
	IterationStatementContext.call(this, parser);
    IterationStatementContext.prototype.copyFrom.call(this, ctx);
    return this;
}

ForVarStatementContext.prototype = Object.create(IterationStatementContext.prototype);
ForVarStatementContext.prototype.constructor = ForVarStatementContext;

ECMAScriptParser.ForVarStatementContext = ForVarStatementContext;

ForVarStatementContext.prototype.For = function() {
    return this.getToken(ECMAScriptParser.For, 0);
};

ForVarStatementContext.prototype.Var = function() {
    return this.getToken(ECMAScriptParser.Var, 0);
};

ForVarStatementContext.prototype.variableDeclarationList = function() {
    return this.getTypedRuleContext(VariableDeclarationListContext,0);
};

ForVarStatementContext.prototype.statement = function() {
    return this.getTypedRuleContext(StatementContext,0);
};

ForVarStatementContext.prototype.expressionSequence = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(ExpressionSequenceContext);
    } else {
        return this.getTypedRuleContext(ExpressionSequenceContext,i);
    }
};
ForVarStatementContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterForVarStatement(this);
	}
};

ForVarStatementContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitForVarStatement(this);
	}
};



ECMAScriptParser.IterationStatementContext = IterationStatementContext;

ECMAScriptParser.prototype.iterationStatement = function() {

    var localctx = new IterationStatementContext(this, this._ctx, this.state);
    this.enterRule(localctx, 26, ECMAScriptParser.RULE_iterationStatement);
    var _la = 0; // Token type
    try {
        this.state = 245;
        var la_ = this._interp.adaptivePredict(this._input,14,this._ctx);
        switch(la_) {
        case 1:
            localctx = new DoStatementContext(this, localctx);
            this.enterOuterAlt(localctx, 1);
            this.state = 184;
            this.match(ECMAScriptParser.Do);
            this.state = 185;
            this.statement();
            this.state = 186;
            this.match(ECMAScriptParser.While);
            this.state = 187;
            this.match(ECMAScriptParser.OpenParen);
            this.state = 188;
            this.expressionSequence();
            this.state = 189;
            this.match(ECMAScriptParser.CloseParen);
            this.state = 190;
            this.eos();
            break;

        case 2:
            localctx = new WhileStatementContext(this, localctx);
            this.enterOuterAlt(localctx, 2);
            this.state = 192;
            this.match(ECMAScriptParser.While);
            this.state = 193;
            this.match(ECMAScriptParser.OpenParen);
            this.state = 194;
            this.expressionSequence();
            this.state = 195;
            this.match(ECMAScriptParser.CloseParen);
            this.state = 196;
            this.statement();
            break;

        case 3:
            localctx = new ForStatementContext(this, localctx);
            this.enterOuterAlt(localctx, 3);
            this.state = 198;
            this.match(ECMAScriptParser.For);
            this.state = 199;
            this.match(ECMAScriptParser.OpenParen);
            this.state = 201;
            _la = this._input.LA(1);
            if((((_la) & ~0x1f) == 0 && ((1 << _la) & ((1 << ECMAScriptParser.RegularExpressionLiteral) | (1 << ECMAScriptParser.OpenBracket) | (1 << ECMAScriptParser.OpenParen) | (1 << ECMAScriptParser.OpenBrace) | (1 << ECMAScriptParser.PlusPlus) | (1 << ECMAScriptParser.MinusMinus) | (1 << ECMAScriptParser.Plus) | (1 << ECMAScriptParser.Minus) | (1 << ECMAScriptParser.BitNot) | (1 << ECMAScriptParser.Not))) !== 0) || ((((_la - 51)) & ~0x1f) == 0 && ((1 << (_la - 51)) & ((1 << (ECMAScriptParser.NullLiteral - 51)) | (1 << (ECMAScriptParser.BooleanLiteral - 51)) | (1 << (ECMAScriptParser.DecimalLiteral - 51)) | (1 << (ECMAScriptParser.HexIntegerLiteral - 51)) | (1 << (ECMAScriptParser.OctalIntegerLiteral - 51)) | (1 << (ECMAScriptParser.Typeof - 51)) | (1 << (ECMAScriptParser.New - 51)) | (1 << (ECMAScriptParser.Void - 51)) | (1 << (ECMAScriptParser.Function - 51)) | (1 << (ECMAScriptParser.This - 51)) | (1 << (ECMAScriptParser.Delete - 51)))) !== 0) || _la===ECMAScriptParser.Identifier || _la===ECMAScriptParser.StringLiteral) {
                this.state = 200;
                this.expressionSequence();
            }

            this.state = 203;
            this.match(ECMAScriptParser.SemiColon);
            this.state = 205;
            _la = this._input.LA(1);
            if((((_la) & ~0x1f) == 0 && ((1 << _la) & ((1 << ECMAScriptParser.RegularExpressionLiteral) | (1 << ECMAScriptParser.OpenBracket) | (1 << ECMAScriptParser.OpenParen) | (1 << ECMAScriptParser.OpenBrace) | (1 << ECMAScriptParser.PlusPlus) | (1 << ECMAScriptParser.MinusMinus) | (1 << ECMAScriptParser.Plus) | (1 << ECMAScriptParser.Minus) | (1 << ECMAScriptParser.BitNot) | (1 << ECMAScriptParser.Not))) !== 0) || ((((_la - 51)) & ~0x1f) == 0 && ((1 << (_la - 51)) & ((1 << (ECMAScriptParser.NullLiteral - 51)) | (1 << (ECMAScriptParser.BooleanLiteral - 51)) | (1 << (ECMAScriptParser.DecimalLiteral - 51)) | (1 << (ECMAScriptParser.HexIntegerLiteral - 51)) | (1 << (ECMAScriptParser.OctalIntegerLiteral - 51)) | (1 << (ECMAScriptParser.Typeof - 51)) | (1 << (ECMAScriptParser.New - 51)) | (1 << (ECMAScriptParser.Void - 51)) | (1 << (ECMAScriptParser.Function - 51)) | (1 << (ECMAScriptParser.This - 51)) | (1 << (ECMAScriptParser.Delete - 51)))) !== 0) || _la===ECMAScriptParser.Identifier || _la===ECMAScriptParser.StringLiteral) {
                this.state = 204;
                this.expressionSequence();
            }

            this.state = 207;
            this.match(ECMAScriptParser.SemiColon);
            this.state = 209;
            _la = this._input.LA(1);
            if((((_la) & ~0x1f) == 0 && ((1 << _la) & ((1 << ECMAScriptParser.RegularExpressionLiteral) | (1 << ECMAScriptParser.OpenBracket) | (1 << ECMAScriptParser.OpenParen) | (1 << ECMAScriptParser.OpenBrace) | (1 << ECMAScriptParser.PlusPlus) | (1 << ECMAScriptParser.MinusMinus) | (1 << ECMAScriptParser.Plus) | (1 << ECMAScriptParser.Minus) | (1 << ECMAScriptParser.BitNot) | (1 << ECMAScriptParser.Not))) !== 0) || ((((_la - 51)) & ~0x1f) == 0 && ((1 << (_la - 51)) & ((1 << (ECMAScriptParser.NullLiteral - 51)) | (1 << (ECMAScriptParser.BooleanLiteral - 51)) | (1 << (ECMAScriptParser.DecimalLiteral - 51)) | (1 << (ECMAScriptParser.HexIntegerLiteral - 51)) | (1 << (ECMAScriptParser.OctalIntegerLiteral - 51)) | (1 << (ECMAScriptParser.Typeof - 51)) | (1 << (ECMAScriptParser.New - 51)) | (1 << (ECMAScriptParser.Void - 51)) | (1 << (ECMAScriptParser.Function - 51)) | (1 << (ECMAScriptParser.This - 51)) | (1 << (ECMAScriptParser.Delete - 51)))) !== 0) || _la===ECMAScriptParser.Identifier || _la===ECMAScriptParser.StringLiteral) {
                this.state = 208;
                this.expressionSequence();
            }

            this.state = 211;
            this.match(ECMAScriptParser.CloseParen);
            this.state = 212;
            this.statement();
            break;

        case 4:
            localctx = new ForVarStatementContext(this, localctx);
            this.enterOuterAlt(localctx, 4);
            this.state = 213;
            this.match(ECMAScriptParser.For);
            this.state = 214;
            this.match(ECMAScriptParser.OpenParen);
            this.state = 215;
            this.match(ECMAScriptParser.Var);
            this.state = 216;
            this.variableDeclarationList();
            this.state = 217;
            this.match(ECMAScriptParser.SemiColon);
            this.state = 219;
            _la = this._input.LA(1);
            if((((_la) & ~0x1f) == 0 && ((1 << _la) & ((1 << ECMAScriptParser.RegularExpressionLiteral) | (1 << ECMAScriptParser.OpenBracket) | (1 << ECMAScriptParser.OpenParen) | (1 << ECMAScriptParser.OpenBrace) | (1 << ECMAScriptParser.PlusPlus) | (1 << ECMAScriptParser.MinusMinus) | (1 << ECMAScriptParser.Plus) | (1 << ECMAScriptParser.Minus) | (1 << ECMAScriptParser.BitNot) | (1 << ECMAScriptParser.Not))) !== 0) || ((((_la - 51)) & ~0x1f) == 0 && ((1 << (_la - 51)) & ((1 << (ECMAScriptParser.NullLiteral - 51)) | (1 << (ECMAScriptParser.BooleanLiteral - 51)) | (1 << (ECMAScriptParser.DecimalLiteral - 51)) | (1 << (ECMAScriptParser.HexIntegerLiteral - 51)) | (1 << (ECMAScriptParser.OctalIntegerLiteral - 51)) | (1 << (ECMAScriptParser.Typeof - 51)) | (1 << (ECMAScriptParser.New - 51)) | (1 << (ECMAScriptParser.Void - 51)) | (1 << (ECMAScriptParser.Function - 51)) | (1 << (ECMAScriptParser.This - 51)) | (1 << (ECMAScriptParser.Delete - 51)))) !== 0) || _la===ECMAScriptParser.Identifier || _la===ECMAScriptParser.StringLiteral) {
                this.state = 218;
                this.expressionSequence();
            }

            this.state = 221;
            this.match(ECMAScriptParser.SemiColon);
            this.state = 223;
            _la = this._input.LA(1);
            if((((_la) & ~0x1f) == 0 && ((1 << _la) & ((1 << ECMAScriptParser.RegularExpressionLiteral) | (1 << ECMAScriptParser.OpenBracket) | (1 << ECMAScriptParser.OpenParen) | (1 << ECMAScriptParser.OpenBrace) | (1 << ECMAScriptParser.PlusPlus) | (1 << ECMAScriptParser.MinusMinus) | (1 << ECMAScriptParser.Plus) | (1 << ECMAScriptParser.Minus) | (1 << ECMAScriptParser.BitNot) | (1 << ECMAScriptParser.Not))) !== 0) || ((((_la - 51)) & ~0x1f) == 0 && ((1 << (_la - 51)) & ((1 << (ECMAScriptParser.NullLiteral - 51)) | (1 << (ECMAScriptParser.BooleanLiteral - 51)) | (1 << (ECMAScriptParser.DecimalLiteral - 51)) | (1 << (ECMAScriptParser.HexIntegerLiteral - 51)) | (1 << (ECMAScriptParser.OctalIntegerLiteral - 51)) | (1 << (ECMAScriptParser.Typeof - 51)) | (1 << (ECMAScriptParser.New - 51)) | (1 << (ECMAScriptParser.Void - 51)) | (1 << (ECMAScriptParser.Function - 51)) | (1 << (ECMAScriptParser.This - 51)) | (1 << (ECMAScriptParser.Delete - 51)))) !== 0) || _la===ECMAScriptParser.Identifier || _la===ECMAScriptParser.StringLiteral) {
                this.state = 222;
                this.expressionSequence();
            }

            this.state = 225;
            this.match(ECMAScriptParser.CloseParen);
            this.state = 226;
            this.statement();
            break;

        case 5:
            localctx = new ForInStatementContext(this, localctx);
            this.enterOuterAlt(localctx, 5);
            this.state = 228;
            this.match(ECMAScriptParser.For);
            this.state = 229;
            this.match(ECMAScriptParser.OpenParen);
            this.state = 230;
            this.singleExpression(0);
            this.state = 231;
            this.match(ECMAScriptParser.In);
            this.state = 232;
            this.expressionSequence();
            this.state = 233;
            this.match(ECMAScriptParser.CloseParen);
            this.state = 234;
            this.statement();
            break;

        case 6:
            localctx = new ForVarInStatementContext(this, localctx);
            this.enterOuterAlt(localctx, 6);
            this.state = 236;
            this.match(ECMAScriptParser.For);
            this.state = 237;
            this.match(ECMAScriptParser.OpenParen);
            this.state = 238;
            this.match(ECMAScriptParser.Var);
            this.state = 239;
            this.variableDeclaration();
            this.state = 240;
            this.match(ECMAScriptParser.In);
            this.state = 241;
            this.expressionSequence();
            this.state = 242;
            this.match(ECMAScriptParser.CloseParen);
            this.state = 243;
            this.statement();
            break;

        }
    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function ContinueStatementContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_continueStatement;
    return this;
}

ContinueStatementContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
ContinueStatementContext.prototype.constructor = ContinueStatementContext;

ContinueStatementContext.prototype.Continue = function() {
    return this.getToken(ECMAScriptParser.Continue, 0);
};

ContinueStatementContext.prototype.eos = function() {
    return this.getTypedRuleContext(EosContext,0);
};

ContinueStatementContext.prototype.Identifier = function() {
    return this.getToken(ECMAScriptParser.Identifier, 0);
};

ContinueStatementContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterContinueStatement(this);
	}
};

ContinueStatementContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitContinueStatement(this);
	}
};




ECMAScriptParser.ContinueStatementContext = ContinueStatementContext;

ECMAScriptParser.prototype.continueStatement = function() {

    var localctx = new ContinueStatementContext(this, this._ctx, this.state);
    this.enterRule(localctx, 28, ECMAScriptParser.RULE_continueStatement);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 247;
        this.match(ECMAScriptParser.Continue);
        this.state = 249;
        var la_ = this._interp.adaptivePredict(this._input,15,this._ctx);
        if(la_===1) {
            this.state = 248;
            this.match(ECMAScriptParser.Identifier);

        }
        this.state = 251;
        this.eos();
    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function BreakStatementContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_breakStatement;
    return this;
}

BreakStatementContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
BreakStatementContext.prototype.constructor = BreakStatementContext;

BreakStatementContext.prototype.Break = function() {
    return this.getToken(ECMAScriptParser.Break, 0);
};

BreakStatementContext.prototype.eos = function() {
    return this.getTypedRuleContext(EosContext,0);
};

BreakStatementContext.prototype.Identifier = function() {
    return this.getToken(ECMAScriptParser.Identifier, 0);
};

BreakStatementContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterBreakStatement(this);
	}
};

BreakStatementContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitBreakStatement(this);
	}
};




ECMAScriptParser.BreakStatementContext = BreakStatementContext;

ECMAScriptParser.prototype.breakStatement = function() {

    var localctx = new BreakStatementContext(this, this._ctx, this.state);
    this.enterRule(localctx, 30, ECMAScriptParser.RULE_breakStatement);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 253;
        this.match(ECMAScriptParser.Break);
        this.state = 255;
        var la_ = this._interp.adaptivePredict(this._input,16,this._ctx);
        if(la_===1) {
            this.state = 254;
            this.match(ECMAScriptParser.Identifier);

        }
        this.state = 257;
        this.eos();
    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function ReturnStatementContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_returnStatement;
    return this;
}

ReturnStatementContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
ReturnStatementContext.prototype.constructor = ReturnStatementContext;

ReturnStatementContext.prototype.Return = function() {
    return this.getToken(ECMAScriptParser.Return, 0);
};

ReturnStatementContext.prototype.eos = function() {
    return this.getTypedRuleContext(EosContext,0);
};

ReturnStatementContext.prototype.expressionSequence = function() {
    return this.getTypedRuleContext(ExpressionSequenceContext,0);
};

ReturnStatementContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterReturnStatement(this);
	}
};

ReturnStatementContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitReturnStatement(this);
	}
};




ECMAScriptParser.ReturnStatementContext = ReturnStatementContext;

ECMAScriptParser.prototype.returnStatement = function() {

    var localctx = new ReturnStatementContext(this, this._ctx, this.state);
    this.enterRule(localctx, 32, ECMAScriptParser.RULE_returnStatement);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 259;
        this.match(ECMAScriptParser.Return);
        this.state = 261;
        var la_ = this._interp.adaptivePredict(this._input,17,this._ctx);
        if(la_===1) {
            this.state = 260;
            this.expressionSequence();

        }
        this.state = 263;
        this.eos();
    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function WithStatementContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_withStatement;
    return this;
}

WithStatementContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
WithStatementContext.prototype.constructor = WithStatementContext;

WithStatementContext.prototype.With = function() {
    return this.getToken(ECMAScriptParser.With, 0);
};

WithStatementContext.prototype.expressionSequence = function() {
    return this.getTypedRuleContext(ExpressionSequenceContext,0);
};

WithStatementContext.prototype.statement = function() {
    return this.getTypedRuleContext(StatementContext,0);
};

WithStatementContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterWithStatement(this);
	}
};

WithStatementContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitWithStatement(this);
	}
};




ECMAScriptParser.WithStatementContext = WithStatementContext;

ECMAScriptParser.prototype.withStatement = function() {

    var localctx = new WithStatementContext(this, this._ctx, this.state);
    this.enterRule(localctx, 34, ECMAScriptParser.RULE_withStatement);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 265;
        this.match(ECMAScriptParser.With);
        this.state = 266;
        this.match(ECMAScriptParser.OpenParen);
        this.state = 267;
        this.expressionSequence();
        this.state = 268;
        this.match(ECMAScriptParser.CloseParen);
        this.state = 269;
        this.statement();
    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function SwitchStatementContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_switchStatement;
    return this;
}

SwitchStatementContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
SwitchStatementContext.prototype.constructor = SwitchStatementContext;

SwitchStatementContext.prototype.Switch = function() {
    return this.getToken(ECMAScriptParser.Switch, 0);
};

SwitchStatementContext.prototype.expressionSequence = function() {
    return this.getTypedRuleContext(ExpressionSequenceContext,0);
};

SwitchStatementContext.prototype.caseBlock = function() {
    return this.getTypedRuleContext(CaseBlockContext,0);
};

SwitchStatementContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterSwitchStatement(this);
	}
};

SwitchStatementContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitSwitchStatement(this);
	}
};




ECMAScriptParser.SwitchStatementContext = SwitchStatementContext;

ECMAScriptParser.prototype.switchStatement = function() {

    var localctx = new SwitchStatementContext(this, this._ctx, this.state);
    this.enterRule(localctx, 36, ECMAScriptParser.RULE_switchStatement);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 271;
        this.match(ECMAScriptParser.Switch);
        this.state = 272;
        this.match(ECMAScriptParser.OpenParen);
        this.state = 273;
        this.expressionSequence();
        this.state = 274;
        this.match(ECMAScriptParser.CloseParen);
        this.state = 275;
        this.caseBlock();
    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function CaseBlockContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_caseBlock;
    return this;
}

CaseBlockContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
CaseBlockContext.prototype.constructor = CaseBlockContext;

CaseBlockContext.prototype.caseClauses = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(CaseClausesContext);
    } else {
        return this.getTypedRuleContext(CaseClausesContext,i);
    }
};

CaseBlockContext.prototype.defaultClause = function() {
    return this.getTypedRuleContext(DefaultClauseContext,0);
};

CaseBlockContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterCaseBlock(this);
	}
};

CaseBlockContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitCaseBlock(this);
	}
};




ECMAScriptParser.CaseBlockContext = CaseBlockContext;

ECMAScriptParser.prototype.caseBlock = function() {

    var localctx = new CaseBlockContext(this, this._ctx, this.state);
    this.enterRule(localctx, 38, ECMAScriptParser.RULE_caseBlock);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 277;
        this.match(ECMAScriptParser.OpenBrace);
        this.state = 279;
        _la = this._input.LA(1);
        if(_la===ECMAScriptParser.Case) {
            this.state = 278;
            this.caseClauses();
        }

        this.state = 285;
        _la = this._input.LA(1);
        if(_la===ECMAScriptParser.Default) {
            this.state = 281;
            this.defaultClause();
            this.state = 283;
            _la = this._input.LA(1);
            if(_la===ECMAScriptParser.Case) {
                this.state = 282;
                this.caseClauses();
            }

        }

        this.state = 287;
        this.match(ECMAScriptParser.CloseBrace);
    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function CaseClausesContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_caseClauses;
    return this;
}

CaseClausesContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
CaseClausesContext.prototype.constructor = CaseClausesContext;

CaseClausesContext.prototype.caseClause = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(CaseClauseContext);
    } else {
        return this.getTypedRuleContext(CaseClauseContext,i);
    }
};

CaseClausesContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterCaseClauses(this);
	}
};

CaseClausesContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitCaseClauses(this);
	}
};




ECMAScriptParser.CaseClausesContext = CaseClausesContext;

ECMAScriptParser.prototype.caseClauses = function() {

    var localctx = new CaseClausesContext(this, this._ctx, this.state);
    this.enterRule(localctx, 40, ECMAScriptParser.RULE_caseClauses);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 290; 
        this._errHandler.sync(this);
        _la = this._input.LA(1);
        do {
            this.state = 289;
            this.caseClause();
            this.state = 292; 
            this._errHandler.sync(this);
            _la = this._input.LA(1);
        } while(_la===ECMAScriptParser.Case);
    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function CaseClauseContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_caseClause;
    return this;
}

CaseClauseContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
CaseClauseContext.prototype.constructor = CaseClauseContext;

CaseClauseContext.prototype.Case = function() {
    return this.getToken(ECMAScriptParser.Case, 0);
};

CaseClauseContext.prototype.expressionSequence = function() {
    return this.getTypedRuleContext(ExpressionSequenceContext,0);
};

CaseClauseContext.prototype.statementList = function() {
    return this.getTypedRuleContext(StatementListContext,0);
};

CaseClauseContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterCaseClause(this);
	}
};

CaseClauseContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitCaseClause(this);
	}
};




ECMAScriptParser.CaseClauseContext = CaseClauseContext;

ECMAScriptParser.prototype.caseClause = function() {

    var localctx = new CaseClauseContext(this, this._ctx, this.state);
    this.enterRule(localctx, 42, ECMAScriptParser.RULE_caseClause);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 294;
        this.match(ECMAScriptParser.Case);
        this.state = 295;
        this.expressionSequence();
        this.state = 296;
        this.match(ECMAScriptParser.Colon);
        this.state = 298;
        _la = this._input.LA(1);
        if((((_la) & ~0x1f) == 0 && ((1 << _la) & ((1 << ECMAScriptParser.RegularExpressionLiteral) | (1 << ECMAScriptParser.OpenBracket) | (1 << ECMAScriptParser.OpenParen) | (1 << ECMAScriptParser.OpenBrace) | (1 << ECMAScriptParser.SemiColon) | (1 << ECMAScriptParser.PlusPlus) | (1 << ECMAScriptParser.MinusMinus) | (1 << ECMAScriptParser.Plus) | (1 << ECMAScriptParser.Minus) | (1 << ECMAScriptParser.BitNot) | (1 << ECMAScriptParser.Not))) !== 0) || ((((_la - 51)) & ~0x1f) == 0 && ((1 << (_la - 51)) & ((1 << (ECMAScriptParser.NullLiteral - 51)) | (1 << (ECMAScriptParser.BooleanLiteral - 51)) | (1 << (ECMAScriptParser.DecimalLiteral - 51)) | (1 << (ECMAScriptParser.HexIntegerLiteral - 51)) | (1 << (ECMAScriptParser.OctalIntegerLiteral - 51)) | (1 << (ECMAScriptParser.Break - 51)) | (1 << (ECMAScriptParser.Do - 51)) | (1 << (ECMAScriptParser.Typeof - 51)) | (1 << (ECMAScriptParser.New - 51)) | (1 << (ECMAScriptParser.Var - 51)) | (1 << (ECMAScriptParser.Return - 51)) | (1 << (ECMAScriptParser.Void - 51)) | (1 << (ECMAScriptParser.Continue - 51)) | (1 << (ECMAScriptParser.For - 51)) | (1 << (ECMAScriptParser.Switch - 51)) | (1 << (ECMAScriptParser.While - 51)) | (1 << (ECMAScriptParser.Debugger - 51)) | (1 << (ECMAScriptParser.Function - 51)) | (1 << (ECMAScriptParser.This - 51)) | (1 << (ECMAScriptParser.With - 51)) | (1 << (ECMAScriptParser.If - 51)) | (1 << (ECMAScriptParser.Throw - 51)) | (1 << (ECMAScriptParser.Delete - 51)) | (1 << (ECMAScriptParser.Try - 51)))) !== 0) || _la===ECMAScriptParser.Identifier || _la===ECMAScriptParser.StringLiteral) {
            this.state = 297;
            this.statementList();
        }

    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function DefaultClauseContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_defaultClause;
    return this;
}

DefaultClauseContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
DefaultClauseContext.prototype.constructor = DefaultClauseContext;

DefaultClauseContext.prototype.Default = function() {
    return this.getToken(ECMAScriptParser.Default, 0);
};

DefaultClauseContext.prototype.statementList = function() {
    return this.getTypedRuleContext(StatementListContext,0);
};

DefaultClauseContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterDefaultClause(this);
	}
};

DefaultClauseContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitDefaultClause(this);
	}
};




ECMAScriptParser.DefaultClauseContext = DefaultClauseContext;

ECMAScriptParser.prototype.defaultClause = function() {

    var localctx = new DefaultClauseContext(this, this._ctx, this.state);
    this.enterRule(localctx, 44, ECMAScriptParser.RULE_defaultClause);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 300;
        this.match(ECMAScriptParser.Default);
        this.state = 301;
        this.match(ECMAScriptParser.Colon);
        this.state = 303;
        _la = this._input.LA(1);
        if((((_la) & ~0x1f) == 0 && ((1 << _la) & ((1 << ECMAScriptParser.RegularExpressionLiteral) | (1 << ECMAScriptParser.OpenBracket) | (1 << ECMAScriptParser.OpenParen) | (1 << ECMAScriptParser.OpenBrace) | (1 << ECMAScriptParser.SemiColon) | (1 << ECMAScriptParser.PlusPlus) | (1 << ECMAScriptParser.MinusMinus) | (1 << ECMAScriptParser.Plus) | (1 << ECMAScriptParser.Minus) | (1 << ECMAScriptParser.BitNot) | (1 << ECMAScriptParser.Not))) !== 0) || ((((_la - 51)) & ~0x1f) == 0 && ((1 << (_la - 51)) & ((1 << (ECMAScriptParser.NullLiteral - 51)) | (1 << (ECMAScriptParser.BooleanLiteral - 51)) | (1 << (ECMAScriptParser.DecimalLiteral - 51)) | (1 << (ECMAScriptParser.HexIntegerLiteral - 51)) | (1 << (ECMAScriptParser.OctalIntegerLiteral - 51)) | (1 << (ECMAScriptParser.Break - 51)) | (1 << (ECMAScriptParser.Do - 51)) | (1 << (ECMAScriptParser.Typeof - 51)) | (1 << (ECMAScriptParser.New - 51)) | (1 << (ECMAScriptParser.Var - 51)) | (1 << (ECMAScriptParser.Return - 51)) | (1 << (ECMAScriptParser.Void - 51)) | (1 << (ECMAScriptParser.Continue - 51)) | (1 << (ECMAScriptParser.For - 51)) | (1 << (ECMAScriptParser.Switch - 51)) | (1 << (ECMAScriptParser.While - 51)) | (1 << (ECMAScriptParser.Debugger - 51)) | (1 << (ECMAScriptParser.Function - 51)) | (1 << (ECMAScriptParser.This - 51)) | (1 << (ECMAScriptParser.With - 51)) | (1 << (ECMAScriptParser.If - 51)) | (1 << (ECMAScriptParser.Throw - 51)) | (1 << (ECMAScriptParser.Delete - 51)) | (1 << (ECMAScriptParser.Try - 51)))) !== 0) || _la===ECMAScriptParser.Identifier || _la===ECMAScriptParser.StringLiteral) {
            this.state = 302;
            this.statementList();
        }

    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function LabelledStatementContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_labelledStatement;
    return this;
}

LabelledStatementContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
LabelledStatementContext.prototype.constructor = LabelledStatementContext;

LabelledStatementContext.prototype.Identifier = function() {
    return this.getToken(ECMAScriptParser.Identifier, 0);
};

LabelledStatementContext.prototype.statement = function() {
    return this.getTypedRuleContext(StatementContext,0);
};

LabelledStatementContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterLabelledStatement(this);
	}
};

LabelledStatementContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitLabelledStatement(this);
	}
};




ECMAScriptParser.LabelledStatementContext = LabelledStatementContext;

ECMAScriptParser.prototype.labelledStatement = function() {

    var localctx = new LabelledStatementContext(this, this._ctx, this.state);
    this.enterRule(localctx, 46, ECMAScriptParser.RULE_labelledStatement);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 305;
        this.match(ECMAScriptParser.Identifier);
        this.state = 306;
        this.match(ECMAScriptParser.Colon);
        this.state = 307;
        this.statement();
    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function ThrowStatementContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_throwStatement;
    return this;
}

ThrowStatementContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
ThrowStatementContext.prototype.constructor = ThrowStatementContext;

ThrowStatementContext.prototype.Throw = function() {
    return this.getToken(ECMAScriptParser.Throw, 0);
};

ThrowStatementContext.prototype.expressionSequence = function() {
    return this.getTypedRuleContext(ExpressionSequenceContext,0);
};

ThrowStatementContext.prototype.eos = function() {
    return this.getTypedRuleContext(EosContext,0);
};

ThrowStatementContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterThrowStatement(this);
	}
};

ThrowStatementContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitThrowStatement(this);
	}
};




ECMAScriptParser.ThrowStatementContext = ThrowStatementContext;

ECMAScriptParser.prototype.throwStatement = function() {

    var localctx = new ThrowStatementContext(this, this._ctx, this.state);
    this.enterRule(localctx, 48, ECMAScriptParser.RULE_throwStatement);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 309;
        this.match(ECMAScriptParser.Throw);
        this.state = 310;
        this.expressionSequence();
        this.state = 311;
        this.eos();
    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function TryStatementContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_tryStatement;
    return this;
}

TryStatementContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
TryStatementContext.prototype.constructor = TryStatementContext;

TryStatementContext.prototype.Try = function() {
    return this.getToken(ECMAScriptParser.Try, 0);
};

TryStatementContext.prototype.block = function() {
    return this.getTypedRuleContext(BlockContext,0);
};

TryStatementContext.prototype.catchProduction = function() {
    return this.getTypedRuleContext(CatchProductionContext,0);
};

TryStatementContext.prototype.finallyProduction = function() {
    return this.getTypedRuleContext(FinallyProductionContext,0);
};

TryStatementContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterTryStatement(this);
	}
};

TryStatementContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitTryStatement(this);
	}
};




ECMAScriptParser.TryStatementContext = TryStatementContext;

ECMAScriptParser.prototype.tryStatement = function() {

    var localctx = new TryStatementContext(this, this._ctx, this.state);
    this.enterRule(localctx, 50, ECMAScriptParser.RULE_tryStatement);
    try {
        this.state = 326;
        var la_ = this._interp.adaptivePredict(this._input,24,this._ctx);
        switch(la_) {
        case 1:
            this.enterOuterAlt(localctx, 1);
            this.state = 313;
            this.match(ECMAScriptParser.Try);
            this.state = 314;
            this.block();
            this.state = 315;
            this.catchProduction();
            break;

        case 2:
            this.enterOuterAlt(localctx, 2);
            this.state = 317;
            this.match(ECMAScriptParser.Try);
            this.state = 318;
            this.block();
            this.state = 319;
            this.finallyProduction();
            break;

        case 3:
            this.enterOuterAlt(localctx, 3);
            this.state = 321;
            this.match(ECMAScriptParser.Try);
            this.state = 322;
            this.block();
            this.state = 323;
            this.catchProduction();
            this.state = 324;
            this.finallyProduction();
            break;

        }
    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function CatchProductionContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_catchProduction;
    return this;
}

CatchProductionContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
CatchProductionContext.prototype.constructor = CatchProductionContext;

CatchProductionContext.prototype.Catch = function() {
    return this.getToken(ECMAScriptParser.Catch, 0);
};

CatchProductionContext.prototype.Identifier = function() {
    return this.getToken(ECMAScriptParser.Identifier, 0);
};

CatchProductionContext.prototype.block = function() {
    return this.getTypedRuleContext(BlockContext,0);
};

CatchProductionContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterCatchProduction(this);
	}
};

CatchProductionContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitCatchProduction(this);
	}
};




ECMAScriptParser.CatchProductionContext = CatchProductionContext;

ECMAScriptParser.prototype.catchProduction = function() {

    var localctx = new CatchProductionContext(this, this._ctx, this.state);
    this.enterRule(localctx, 52, ECMAScriptParser.RULE_catchProduction);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 328;
        this.match(ECMAScriptParser.Catch);
        this.state = 329;
        this.match(ECMAScriptParser.OpenParen);
        this.state = 330;
        this.match(ECMAScriptParser.Identifier);
        this.state = 331;
        this.match(ECMAScriptParser.CloseParen);
        this.state = 332;
        this.block();
    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function FinallyProductionContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_finallyProduction;
    return this;
}

FinallyProductionContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
FinallyProductionContext.prototype.constructor = FinallyProductionContext;

FinallyProductionContext.prototype.Finally = function() {
    return this.getToken(ECMAScriptParser.Finally, 0);
};

FinallyProductionContext.prototype.block = function() {
    return this.getTypedRuleContext(BlockContext,0);
};

FinallyProductionContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterFinallyProduction(this);
	}
};

FinallyProductionContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitFinallyProduction(this);
	}
};




ECMAScriptParser.FinallyProductionContext = FinallyProductionContext;

ECMAScriptParser.prototype.finallyProduction = function() {

    var localctx = new FinallyProductionContext(this, this._ctx, this.state);
    this.enterRule(localctx, 54, ECMAScriptParser.RULE_finallyProduction);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 334;
        this.match(ECMAScriptParser.Finally);
        this.state = 335;
        this.block();
    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function DebuggerStatementContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_debuggerStatement;
    return this;
}

DebuggerStatementContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
DebuggerStatementContext.prototype.constructor = DebuggerStatementContext;

DebuggerStatementContext.prototype.Debugger = function() {
    return this.getToken(ECMAScriptParser.Debugger, 0);
};

DebuggerStatementContext.prototype.eos = function() {
    return this.getTypedRuleContext(EosContext,0);
};

DebuggerStatementContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterDebuggerStatement(this);
	}
};

DebuggerStatementContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitDebuggerStatement(this);
	}
};




ECMAScriptParser.DebuggerStatementContext = DebuggerStatementContext;

ECMAScriptParser.prototype.debuggerStatement = function() {

    var localctx = new DebuggerStatementContext(this, this._ctx, this.state);
    this.enterRule(localctx, 56, ECMAScriptParser.RULE_debuggerStatement);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 337;
        this.match(ECMAScriptParser.Debugger);
        this.state = 338;
        this.eos();
    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function FunctionDeclarationContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_functionDeclaration;
    return this;
}

FunctionDeclarationContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
FunctionDeclarationContext.prototype.constructor = FunctionDeclarationContext;

FunctionDeclarationContext.prototype.Function = function() {
    return this.getToken(ECMAScriptParser.Function, 0);
};

FunctionDeclarationContext.prototype.Identifier = function() {
    return this.getToken(ECMAScriptParser.Identifier, 0);
};

FunctionDeclarationContext.prototype.functionBody = function() {
    return this.getTypedRuleContext(FunctionBodyContext,0);
};

FunctionDeclarationContext.prototype.formalParameterList = function() {
    return this.getTypedRuleContext(FormalParameterListContext,0);
};

FunctionDeclarationContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterFunctionDeclaration(this);
	}
};

FunctionDeclarationContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitFunctionDeclaration(this);
	}
};




ECMAScriptParser.FunctionDeclarationContext = FunctionDeclarationContext;

ECMAScriptParser.prototype.functionDeclaration = function() {

    var localctx = new FunctionDeclarationContext(this, this._ctx, this.state);
    this.enterRule(localctx, 58, ECMAScriptParser.RULE_functionDeclaration);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 340;
        this.match(ECMAScriptParser.Function);
        this.state = 341;
        this.match(ECMAScriptParser.Identifier);
        this.state = 342;
        this.match(ECMAScriptParser.OpenParen);
        this.state = 344;
        _la = this._input.LA(1);
        if(_la===ECMAScriptParser.Identifier) {
            this.state = 343;
            this.formalParameterList();
        }

        this.state = 346;
        this.match(ECMAScriptParser.CloseParen);
        this.state = 347;
        this.match(ECMAScriptParser.OpenBrace);
        this.state = 348;
        this.functionBody();
        this.state = 349;
        this.match(ECMAScriptParser.CloseBrace);
    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function FormalParameterListContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_formalParameterList;
    return this;
}

FormalParameterListContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
FormalParameterListContext.prototype.constructor = FormalParameterListContext;

FormalParameterListContext.prototype.Identifier = function(i) {
	if(i===undefined) {
		i = null;
	}
    if(i===null) {
        return this.getTokens(ECMAScriptParser.Identifier);
    } else {
        return this.getToken(ECMAScriptParser.Identifier, i);
    }
};


FormalParameterListContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterFormalParameterList(this);
	}
};

FormalParameterListContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitFormalParameterList(this);
	}
};




ECMAScriptParser.FormalParameterListContext = FormalParameterListContext;

ECMAScriptParser.prototype.formalParameterList = function() {

    var localctx = new FormalParameterListContext(this, this._ctx, this.state);
    this.enterRule(localctx, 60, ECMAScriptParser.RULE_formalParameterList);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 351;
        this.match(ECMAScriptParser.Identifier);
        this.state = 356;
        this._errHandler.sync(this);
        _la = this._input.LA(1);
        while(_la===ECMAScriptParser.Comma) {
            this.state = 352;
            this.match(ECMAScriptParser.Comma);
            this.state = 353;
            this.match(ECMAScriptParser.Identifier);
            this.state = 358;
            this._errHandler.sync(this);
            _la = this._input.LA(1);
        }
    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function FunctionBodyContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_functionBody;
    return this;
}

FunctionBodyContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
FunctionBodyContext.prototype.constructor = FunctionBodyContext;

FunctionBodyContext.prototype.sourceElements = function() {
    return this.getTypedRuleContext(SourceElementsContext,0);
};

FunctionBodyContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterFunctionBody(this);
	}
};

FunctionBodyContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitFunctionBody(this);
	}
};




ECMAScriptParser.FunctionBodyContext = FunctionBodyContext;

ECMAScriptParser.prototype.functionBody = function() {

    var localctx = new FunctionBodyContext(this, this._ctx, this.state);
    this.enterRule(localctx, 62, ECMAScriptParser.RULE_functionBody);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 360;
        _la = this._input.LA(1);
        if((((_la) & ~0x1f) == 0 && ((1 << _la) & ((1 << ECMAScriptParser.RegularExpressionLiteral) | (1 << ECMAScriptParser.OpenBracket) | (1 << ECMAScriptParser.OpenParen) | (1 << ECMAScriptParser.OpenBrace) | (1 << ECMAScriptParser.SemiColon) | (1 << ECMAScriptParser.PlusPlus) | (1 << ECMAScriptParser.MinusMinus) | (1 << ECMAScriptParser.Plus) | (1 << ECMAScriptParser.Minus) | (1 << ECMAScriptParser.BitNot) | (1 << ECMAScriptParser.Not))) !== 0) || ((((_la - 51)) & ~0x1f) == 0 && ((1 << (_la - 51)) & ((1 << (ECMAScriptParser.NullLiteral - 51)) | (1 << (ECMAScriptParser.BooleanLiteral - 51)) | (1 << (ECMAScriptParser.DecimalLiteral - 51)) | (1 << (ECMAScriptParser.HexIntegerLiteral - 51)) | (1 << (ECMAScriptParser.OctalIntegerLiteral - 51)) | (1 << (ECMAScriptParser.Break - 51)) | (1 << (ECMAScriptParser.Do - 51)) | (1 << (ECMAScriptParser.Typeof - 51)) | (1 << (ECMAScriptParser.New - 51)) | (1 << (ECMAScriptParser.Var - 51)) | (1 << (ECMAScriptParser.Return - 51)) | (1 << (ECMAScriptParser.Void - 51)) | (1 << (ECMAScriptParser.Continue - 51)) | (1 << (ECMAScriptParser.For - 51)) | (1 << (ECMAScriptParser.Switch - 51)) | (1 << (ECMAScriptParser.While - 51)) | (1 << (ECMAScriptParser.Debugger - 51)) | (1 << (ECMAScriptParser.Function - 51)) | (1 << (ECMAScriptParser.This - 51)) | (1 << (ECMAScriptParser.With - 51)) | (1 << (ECMAScriptParser.If - 51)) | (1 << (ECMAScriptParser.Throw - 51)) | (1 << (ECMAScriptParser.Delete - 51)) | (1 << (ECMAScriptParser.Try - 51)))) !== 0) || _la===ECMAScriptParser.Identifier || _la===ECMAScriptParser.StringLiteral) {
            this.state = 359;
            this.sourceElements();
        }

    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function ArrayLiteralContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_arrayLiteral;
    return this;
}

ArrayLiteralContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
ArrayLiteralContext.prototype.constructor = ArrayLiteralContext;

ArrayLiteralContext.prototype.elementList = function() {
    return this.getTypedRuleContext(ElementListContext,0);
};

ArrayLiteralContext.prototype.elision = function() {
    return this.getTypedRuleContext(ElisionContext,0);
};

ArrayLiteralContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterArrayLiteral(this);
	}
};

ArrayLiteralContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitArrayLiteral(this);
	}
};




ECMAScriptParser.ArrayLiteralContext = ArrayLiteralContext;

ECMAScriptParser.prototype.arrayLiteral = function() {

    var localctx = new ArrayLiteralContext(this, this._ctx, this.state);
    this.enterRule(localctx, 64, ECMAScriptParser.RULE_arrayLiteral);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 362;
        this.match(ECMAScriptParser.OpenBracket);
        this.state = 364;
        var la_ = this._interp.adaptivePredict(this._input,28,this._ctx);
        if(la_===1) {
            this.state = 363;
            this.elementList();

        }
        this.state = 367;
        var la_ = this._interp.adaptivePredict(this._input,29,this._ctx);
        if(la_===1) {
            this.state = 366;
            this.match(ECMAScriptParser.Comma);

        }
        this.state = 370;
        _la = this._input.LA(1);
        if(_la===ECMAScriptParser.Comma) {
            this.state = 369;
            this.elision();
        }

        this.state = 372;
        this.match(ECMAScriptParser.CloseBracket);
    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function ElementListContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_elementList;
    return this;
}

ElementListContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
ElementListContext.prototype.constructor = ElementListContext;

ElementListContext.prototype.singleExpression = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(SingleExpressionContext);
    } else {
        return this.getTypedRuleContext(SingleExpressionContext,i);
    }
};

ElementListContext.prototype.elision = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(ElisionContext);
    } else {
        return this.getTypedRuleContext(ElisionContext,i);
    }
};

ElementListContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterElementList(this);
	}
};

ElementListContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitElementList(this);
	}
};




ECMAScriptParser.ElementListContext = ElementListContext;

ECMAScriptParser.prototype.elementList = function() {

    var localctx = new ElementListContext(this, this._ctx, this.state);
    this.enterRule(localctx, 66, ECMAScriptParser.RULE_elementList);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 375;
        _la = this._input.LA(1);
        if(_la===ECMAScriptParser.Comma) {
            this.state = 374;
            this.elision();
        }

        this.state = 377;
        this.singleExpression(0);
        this.state = 385;
        this._errHandler.sync(this);
        var _alt = this._interp.adaptivePredict(this._input,33,this._ctx)
        while(_alt!=2 && _alt!=antlr4.atn.ATN.INVALID_ALT_NUMBER) {
            if(_alt===1) {
                this.state = 378;
                this.match(ECMAScriptParser.Comma);
                this.state = 380;
                _la = this._input.LA(1);
                if(_la===ECMAScriptParser.Comma) {
                    this.state = 379;
                    this.elision();
                }

                this.state = 382;
                this.singleExpression(0); 
            }
            this.state = 387;
            this._errHandler.sync(this);
            _alt = this._interp.adaptivePredict(this._input,33,this._ctx);
        }

    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function ElisionContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_elision;
    return this;
}

ElisionContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
ElisionContext.prototype.constructor = ElisionContext;


ElisionContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterElision(this);
	}
};

ElisionContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitElision(this);
	}
};




ECMAScriptParser.ElisionContext = ElisionContext;

ECMAScriptParser.prototype.elision = function() {

    var localctx = new ElisionContext(this, this._ctx, this.state);
    this.enterRule(localctx, 68, ECMAScriptParser.RULE_elision);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 389; 
        this._errHandler.sync(this);
        _la = this._input.LA(1);
        do {
            this.state = 388;
            this.match(ECMAScriptParser.Comma);
            this.state = 391; 
            this._errHandler.sync(this);
            _la = this._input.LA(1);
        } while(_la===ECMAScriptParser.Comma);
    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function ObjectLiteralContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_objectLiteral;
    return this;
}

ObjectLiteralContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
ObjectLiteralContext.prototype.constructor = ObjectLiteralContext;

ObjectLiteralContext.prototype.propertyNameAndValueList = function() {
    return this.getTypedRuleContext(PropertyNameAndValueListContext,0);
};

ObjectLiteralContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterObjectLiteral(this);
	}
};

ObjectLiteralContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitObjectLiteral(this);
	}
};




ECMAScriptParser.ObjectLiteralContext = ObjectLiteralContext;

ECMAScriptParser.prototype.objectLiteral = function() {

    var localctx = new ObjectLiteralContext(this, this._ctx, this.state);
    this.enterRule(localctx, 70, ECMAScriptParser.RULE_objectLiteral);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 393;
        this.match(ECMAScriptParser.OpenBrace);
        this.state = 395;
        var la_ = this._interp.adaptivePredict(this._input,35,this._ctx);
        if(la_===1) {
            this.state = 394;
            this.propertyNameAndValueList();

        }
        this.state = 398;
        _la = this._input.LA(1);
        if(_la===ECMAScriptParser.Comma) {
            this.state = 397;
            this.match(ECMAScriptParser.Comma);
        }

        this.state = 400;
        this.match(ECMAScriptParser.CloseBrace);
    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function PropertyNameAndValueListContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_propertyNameAndValueList;
    return this;
}

PropertyNameAndValueListContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
PropertyNameAndValueListContext.prototype.constructor = PropertyNameAndValueListContext;

PropertyNameAndValueListContext.prototype.propertyAssignment = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(PropertyAssignmentContext);
    } else {
        return this.getTypedRuleContext(PropertyAssignmentContext,i);
    }
};

PropertyNameAndValueListContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterPropertyNameAndValueList(this);
	}
};

PropertyNameAndValueListContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitPropertyNameAndValueList(this);
	}
};




ECMAScriptParser.PropertyNameAndValueListContext = PropertyNameAndValueListContext;

ECMAScriptParser.prototype.propertyNameAndValueList = function() {

    var localctx = new PropertyNameAndValueListContext(this, this._ctx, this.state);
    this.enterRule(localctx, 72, ECMAScriptParser.RULE_propertyNameAndValueList);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 402;
        this.propertyAssignment();
        this.state = 407;
        this._errHandler.sync(this);
        var _alt = this._interp.adaptivePredict(this._input,37,this._ctx)
        while(_alt!=2 && _alt!=antlr4.atn.ATN.INVALID_ALT_NUMBER) {
            if(_alt===1) {
                this.state = 403;
                this.match(ECMAScriptParser.Comma);
                this.state = 404;
                this.propertyAssignment(); 
            }
            this.state = 409;
            this._errHandler.sync(this);
            _alt = this._interp.adaptivePredict(this._input,37,this._ctx);
        }

    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function PropertyAssignmentContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_propertyAssignment;
    return this;
}

PropertyAssignmentContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
PropertyAssignmentContext.prototype.constructor = PropertyAssignmentContext;


 
PropertyAssignmentContext.prototype.copyFrom = function(ctx) {
    antlr4.ParserRuleContext.prototype.copyFrom.call(this, ctx);
};


function PropertyGetterContext(parser, ctx) {
	PropertyAssignmentContext.call(this, parser);
    PropertyAssignmentContext.prototype.copyFrom.call(this, ctx);
    return this;
}

PropertyGetterContext.prototype = Object.create(PropertyAssignmentContext.prototype);
PropertyGetterContext.prototype.constructor = PropertyGetterContext;

ECMAScriptParser.PropertyGetterContext = PropertyGetterContext;

PropertyGetterContext.prototype.getter = function() {
    return this.getTypedRuleContext(GetterContext,0);
};

PropertyGetterContext.prototype.functionBody = function() {
    return this.getTypedRuleContext(FunctionBodyContext,0);
};
PropertyGetterContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterPropertyGetter(this);
	}
};

PropertyGetterContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitPropertyGetter(this);
	}
};


function PropertyExpressionAssignmentContext(parser, ctx) {
	PropertyAssignmentContext.call(this, parser);
    PropertyAssignmentContext.prototype.copyFrom.call(this, ctx);
    return this;
}

PropertyExpressionAssignmentContext.prototype = Object.create(PropertyAssignmentContext.prototype);
PropertyExpressionAssignmentContext.prototype.constructor = PropertyExpressionAssignmentContext;

ECMAScriptParser.PropertyExpressionAssignmentContext = PropertyExpressionAssignmentContext;

PropertyExpressionAssignmentContext.prototype.propertyName = function() {
    return this.getTypedRuleContext(PropertyNameContext,0);
};

PropertyExpressionAssignmentContext.prototype.singleExpression = function() {
    return this.getTypedRuleContext(SingleExpressionContext,0);
};
PropertyExpressionAssignmentContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterPropertyExpressionAssignment(this);
	}
};

PropertyExpressionAssignmentContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitPropertyExpressionAssignment(this);
	}
};


function PropertySetterContext(parser, ctx) {
	PropertyAssignmentContext.call(this, parser);
    PropertyAssignmentContext.prototype.copyFrom.call(this, ctx);
    return this;
}

PropertySetterContext.prototype = Object.create(PropertyAssignmentContext.prototype);
PropertySetterContext.prototype.constructor = PropertySetterContext;

ECMAScriptParser.PropertySetterContext = PropertySetterContext;

PropertySetterContext.prototype.setter = function() {
    return this.getTypedRuleContext(SetterContext,0);
};

PropertySetterContext.prototype.propertySetParameterList = function() {
    return this.getTypedRuleContext(PropertySetParameterListContext,0);
};

PropertySetterContext.prototype.functionBody = function() {
    return this.getTypedRuleContext(FunctionBodyContext,0);
};
PropertySetterContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterPropertySetter(this);
	}
};

PropertySetterContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitPropertySetter(this);
	}
};



ECMAScriptParser.PropertyAssignmentContext = PropertyAssignmentContext;

ECMAScriptParser.prototype.propertyAssignment = function() {

    var localctx = new PropertyAssignmentContext(this, this._ctx, this.state);
    this.enterRule(localctx, 74, ECMAScriptParser.RULE_propertyAssignment);
    try {
        this.state = 429;
        var la_ = this._interp.adaptivePredict(this._input,38,this._ctx);
        switch(la_) {
        case 1:
            localctx = new PropertyExpressionAssignmentContext(this, localctx);
            this.enterOuterAlt(localctx, 1);
            this.state = 410;
            this.propertyName();
            this.state = 411;
            this.match(ECMAScriptParser.Colon);
            this.state = 412;
            this.singleExpression(0);
            break;

        case 2:
            localctx = new PropertyGetterContext(this, localctx);
            this.enterOuterAlt(localctx, 2);
            this.state = 414;
            this.getter();
            this.state = 415;
            this.match(ECMAScriptParser.OpenParen);
            this.state = 416;
            this.match(ECMAScriptParser.CloseParen);
            this.state = 417;
            this.match(ECMAScriptParser.OpenBrace);
            this.state = 418;
            this.functionBody();
            this.state = 419;
            this.match(ECMAScriptParser.CloseBrace);
            break;

        case 3:
            localctx = new PropertySetterContext(this, localctx);
            this.enterOuterAlt(localctx, 3);
            this.state = 421;
            this.setter();
            this.state = 422;
            this.match(ECMAScriptParser.OpenParen);
            this.state = 423;
            this.propertySetParameterList();
            this.state = 424;
            this.match(ECMAScriptParser.CloseParen);
            this.state = 425;
            this.match(ECMAScriptParser.OpenBrace);
            this.state = 426;
            this.functionBody();
            this.state = 427;
            this.match(ECMAScriptParser.CloseBrace);
            break;

        }
    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function PropertyNameContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_propertyName;
    return this;
}

PropertyNameContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
PropertyNameContext.prototype.constructor = PropertyNameContext;

PropertyNameContext.prototype.identifierName = function() {
    return this.getTypedRuleContext(IdentifierNameContext,0);
};

PropertyNameContext.prototype.StringLiteral = function() {
    return this.getToken(ECMAScriptParser.StringLiteral, 0);
};

PropertyNameContext.prototype.numericLiteral = function() {
    return this.getTypedRuleContext(NumericLiteralContext,0);
};

PropertyNameContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterPropertyName(this);
	}
};

PropertyNameContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitPropertyName(this);
	}
};




ECMAScriptParser.PropertyNameContext = PropertyNameContext;

ECMAScriptParser.prototype.propertyName = function() {

    var localctx = new PropertyNameContext(this, this._ctx, this.state);
    this.enterRule(localctx, 76, ECMAScriptParser.RULE_propertyName);
    try {
        this.state = 434;
        switch(this._input.LA(1)) {
        case ECMAScriptParser.NullLiteral:
        case ECMAScriptParser.BooleanLiteral:
        case ECMAScriptParser.Break:
        case ECMAScriptParser.Do:
        case ECMAScriptParser.Instanceof:
        case ECMAScriptParser.Typeof:
        case ECMAScriptParser.Case:
        case ECMAScriptParser.Else:
        case ECMAScriptParser.New:
        case ECMAScriptParser.Var:
        case ECMAScriptParser.Catch:
        case ECMAScriptParser.Finally:
        case ECMAScriptParser.Return:
        case ECMAScriptParser.Void:
        case ECMAScriptParser.Continue:
        case ECMAScriptParser.For:
        case ECMAScriptParser.Switch:
        case ECMAScriptParser.While:
        case ECMAScriptParser.Debugger:
        case ECMAScriptParser.Function:
        case ECMAScriptParser.This:
        case ECMAScriptParser.With:
        case ECMAScriptParser.Default:
        case ECMAScriptParser.If:
        case ECMAScriptParser.Throw:
        case ECMAScriptParser.Delete:
        case ECMAScriptParser.In:
        case ECMAScriptParser.Try:
        case ECMAScriptParser.Class:
        case ECMAScriptParser.Enum:
        case ECMAScriptParser.Extends:
        case ECMAScriptParser.Super:
        case ECMAScriptParser.Const:
        case ECMAScriptParser.Export:
        case ECMAScriptParser.Import:
        case ECMAScriptParser.Implements:
        case ECMAScriptParser.Let:
        case ECMAScriptParser.Private:
        case ECMAScriptParser.Public:
        case ECMAScriptParser.Interface:
        case ECMAScriptParser.Package:
        case ECMAScriptParser.Protected:
        case ECMAScriptParser.Static:
        case ECMAScriptParser.Yield:
        case ECMAScriptParser.Identifier:
            this.enterOuterAlt(localctx, 1);
            this.state = 431;
            this.identifierName();
            break;
        case ECMAScriptParser.StringLiteral:
            this.enterOuterAlt(localctx, 2);
            this.state = 432;
            this.match(ECMAScriptParser.StringLiteral);
            break;
        case ECMAScriptParser.DecimalLiteral:
        case ECMAScriptParser.HexIntegerLiteral:
        case ECMAScriptParser.OctalIntegerLiteral:
            this.enterOuterAlt(localctx, 3);
            this.state = 433;
            this.numericLiteral();
            break;
        default:
            throw new antlr4.error.NoViableAltException(this);
        }
    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function PropertySetParameterListContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_propertySetParameterList;
    return this;
}

PropertySetParameterListContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
PropertySetParameterListContext.prototype.constructor = PropertySetParameterListContext;

PropertySetParameterListContext.prototype.Identifier = function() {
    return this.getToken(ECMAScriptParser.Identifier, 0);
};

PropertySetParameterListContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterPropertySetParameterList(this);
	}
};

PropertySetParameterListContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitPropertySetParameterList(this);
	}
};




ECMAScriptParser.PropertySetParameterListContext = PropertySetParameterListContext;

ECMAScriptParser.prototype.propertySetParameterList = function() {

    var localctx = new PropertySetParameterListContext(this, this._ctx, this.state);
    this.enterRule(localctx, 78, ECMAScriptParser.RULE_propertySetParameterList);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 436;
        this.match(ECMAScriptParser.Identifier);
    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function ArgumentsContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_arguments;
    return this;
}

ArgumentsContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
ArgumentsContext.prototype.constructor = ArgumentsContext;

ArgumentsContext.prototype.argumentList = function() {
    return this.getTypedRuleContext(ArgumentListContext,0);
};

ArgumentsContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterArguments(this);
	}
};

ArgumentsContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitArguments(this);
	}
};




ECMAScriptParser.ArgumentsContext = ArgumentsContext;

ECMAScriptParser.prototype.arguments = function() {

    var localctx = new ArgumentsContext(this, this._ctx, this.state);
    this.enterRule(localctx, 80, ECMAScriptParser.RULE_arguments);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 438;
        this.match(ECMAScriptParser.OpenParen);
        this.state = 440;
        _la = this._input.LA(1);
        if((((_la) & ~0x1f) == 0 && ((1 << _la) & ((1 << ECMAScriptParser.RegularExpressionLiteral) | (1 << ECMAScriptParser.OpenBracket) | (1 << ECMAScriptParser.OpenParen) | (1 << ECMAScriptParser.OpenBrace) | (1 << ECMAScriptParser.PlusPlus) | (1 << ECMAScriptParser.MinusMinus) | (1 << ECMAScriptParser.Plus) | (1 << ECMAScriptParser.Minus) | (1 << ECMAScriptParser.BitNot) | (1 << ECMAScriptParser.Not))) !== 0) || ((((_la - 51)) & ~0x1f) == 0 && ((1 << (_la - 51)) & ((1 << (ECMAScriptParser.NullLiteral - 51)) | (1 << (ECMAScriptParser.BooleanLiteral - 51)) | (1 << (ECMAScriptParser.DecimalLiteral - 51)) | (1 << (ECMAScriptParser.HexIntegerLiteral - 51)) | (1 << (ECMAScriptParser.OctalIntegerLiteral - 51)) | (1 << (ECMAScriptParser.Typeof - 51)) | (1 << (ECMAScriptParser.New - 51)) | (1 << (ECMAScriptParser.Void - 51)) | (1 << (ECMAScriptParser.Function - 51)) | (1 << (ECMAScriptParser.This - 51)) | (1 << (ECMAScriptParser.Delete - 51)))) !== 0) || _la===ECMAScriptParser.Identifier || _la===ECMAScriptParser.StringLiteral) {
            this.state = 439;
            this.argumentList();
        }

        this.state = 442;
        this.match(ECMAScriptParser.CloseParen);
    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function ArgumentListContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_argumentList;
    return this;
}

ArgumentListContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
ArgumentListContext.prototype.constructor = ArgumentListContext;

ArgumentListContext.prototype.singleExpression = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(SingleExpressionContext);
    } else {
        return this.getTypedRuleContext(SingleExpressionContext,i);
    }
};

ArgumentListContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterArgumentList(this);
	}
};

ArgumentListContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitArgumentList(this);
	}
};




ECMAScriptParser.ArgumentListContext = ArgumentListContext;

ECMAScriptParser.prototype.argumentList = function() {

    var localctx = new ArgumentListContext(this, this._ctx, this.state);
    this.enterRule(localctx, 82, ECMAScriptParser.RULE_argumentList);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 444;
        this.singleExpression(0);
        this.state = 449;
        this._errHandler.sync(this);
        _la = this._input.LA(1);
        while(_la===ECMAScriptParser.Comma) {
            this.state = 445;
            this.match(ECMAScriptParser.Comma);
            this.state = 446;
            this.singleExpression(0);
            this.state = 451;
            this._errHandler.sync(this);
            _la = this._input.LA(1);
        }
    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function ExpressionSequenceContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_expressionSequence;
    return this;
}

ExpressionSequenceContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
ExpressionSequenceContext.prototype.constructor = ExpressionSequenceContext;

ExpressionSequenceContext.prototype.singleExpression = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(SingleExpressionContext);
    } else {
        return this.getTypedRuleContext(SingleExpressionContext,i);
    }
};

ExpressionSequenceContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterExpressionSequence(this);
	}
};

ExpressionSequenceContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitExpressionSequence(this);
	}
};




ECMAScriptParser.ExpressionSequenceContext = ExpressionSequenceContext;

ECMAScriptParser.prototype.expressionSequence = function() {

    var localctx = new ExpressionSequenceContext(this, this._ctx, this.state);
    this.enterRule(localctx, 84, ECMAScriptParser.RULE_expressionSequence);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 452;
        this.singleExpression(0);
        this.state = 457;
        this._errHandler.sync(this);
        var _alt = this._interp.adaptivePredict(this._input,42,this._ctx)
        while(_alt!=2 && _alt!=antlr4.atn.ATN.INVALID_ALT_NUMBER) {
            if(_alt===1) {
                this.state = 453;
                this.match(ECMAScriptParser.Comma);
                this.state = 454;
                this.singleExpression(0); 
            }
            this.state = 459;
            this._errHandler.sync(this);
            _alt = this._interp.adaptivePredict(this._input,42,this._ctx);
        }

    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function SingleExpressionContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_singleExpression;
    return this;
}

SingleExpressionContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
SingleExpressionContext.prototype.constructor = SingleExpressionContext;


 
SingleExpressionContext.prototype.copyFrom = function(ctx) {
    antlr4.ParserRuleContext.prototype.copyFrom.call(this, ctx);
};

function TernaryExpressionContext(parser, ctx) {
	SingleExpressionContext.call(this, parser);
    SingleExpressionContext.prototype.copyFrom.call(this, ctx);
    return this;
}

TernaryExpressionContext.prototype = Object.create(SingleExpressionContext.prototype);
TernaryExpressionContext.prototype.constructor = TernaryExpressionContext;

ECMAScriptParser.TernaryExpressionContext = TernaryExpressionContext;

TernaryExpressionContext.prototype.singleExpression = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(SingleExpressionContext);
    } else {
        return this.getTypedRuleContext(SingleExpressionContext,i);
    }
};
TernaryExpressionContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterTernaryExpression(this);
	}
};

TernaryExpressionContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitTernaryExpression(this);
	}
};


function BitOrExpressionContext(parser, ctx) {
	SingleExpressionContext.call(this, parser);
    SingleExpressionContext.prototype.copyFrom.call(this, ctx);
    return this;
}

BitOrExpressionContext.prototype = Object.create(SingleExpressionContext.prototype);
BitOrExpressionContext.prototype.constructor = BitOrExpressionContext;

ECMAScriptParser.BitOrExpressionContext = BitOrExpressionContext;

BitOrExpressionContext.prototype.singleExpression = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(SingleExpressionContext);
    } else {
        return this.getTypedRuleContext(SingleExpressionContext,i);
    }
};
BitOrExpressionContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterBitOrExpression(this);
	}
};

BitOrExpressionContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitBitOrExpression(this);
	}
};


function AssignmentExpressionContext(parser, ctx) {
	SingleExpressionContext.call(this, parser);
    SingleExpressionContext.prototype.copyFrom.call(this, ctx);
    return this;
}

AssignmentExpressionContext.prototype = Object.create(SingleExpressionContext.prototype);
AssignmentExpressionContext.prototype.constructor = AssignmentExpressionContext;

ECMAScriptParser.AssignmentExpressionContext = AssignmentExpressionContext;

AssignmentExpressionContext.prototype.singleExpression = function() {
    return this.getTypedRuleContext(SingleExpressionContext,0);
};

AssignmentExpressionContext.prototype.expressionSequence = function() {
    return this.getTypedRuleContext(ExpressionSequenceContext,0);
};
AssignmentExpressionContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterAssignmentExpression(this);
	}
};

AssignmentExpressionContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitAssignmentExpression(this);
	}
};


function LogicalAndExpressionContext(parser, ctx) {
	SingleExpressionContext.call(this, parser);
    SingleExpressionContext.prototype.copyFrom.call(this, ctx);
    return this;
}

LogicalAndExpressionContext.prototype = Object.create(SingleExpressionContext.prototype);
LogicalAndExpressionContext.prototype.constructor = LogicalAndExpressionContext;

ECMAScriptParser.LogicalAndExpressionContext = LogicalAndExpressionContext;

LogicalAndExpressionContext.prototype.singleExpression = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(SingleExpressionContext);
    } else {
        return this.getTypedRuleContext(SingleExpressionContext,i);
    }
};
LogicalAndExpressionContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterLogicalAndExpression(this);
	}
};

LogicalAndExpressionContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitLogicalAndExpression(this);
	}
};


function InstanceofExpressionContext(parser, ctx) {
	SingleExpressionContext.call(this, parser);
    SingleExpressionContext.prototype.copyFrom.call(this, ctx);
    return this;
}

InstanceofExpressionContext.prototype = Object.create(SingleExpressionContext.prototype);
InstanceofExpressionContext.prototype.constructor = InstanceofExpressionContext;

ECMAScriptParser.InstanceofExpressionContext = InstanceofExpressionContext;

InstanceofExpressionContext.prototype.singleExpression = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(SingleExpressionContext);
    } else {
        return this.getTypedRuleContext(SingleExpressionContext,i);
    }
};

InstanceofExpressionContext.prototype.Instanceof = function() {
    return this.getToken(ECMAScriptParser.Instanceof, 0);
};
InstanceofExpressionContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterInstanceofExpression(this);
	}
};

InstanceofExpressionContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitInstanceofExpression(this);
	}
};


function ObjectLiteralExpressionContext(parser, ctx) {
	SingleExpressionContext.call(this, parser);
    SingleExpressionContext.prototype.copyFrom.call(this, ctx);
    return this;
}

ObjectLiteralExpressionContext.prototype = Object.create(SingleExpressionContext.prototype);
ObjectLiteralExpressionContext.prototype.constructor = ObjectLiteralExpressionContext;

ECMAScriptParser.ObjectLiteralExpressionContext = ObjectLiteralExpressionContext;

ObjectLiteralExpressionContext.prototype.objectLiteral = function() {
    return this.getTypedRuleContext(ObjectLiteralContext,0);
};
ObjectLiteralExpressionContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterObjectLiteralExpression(this);
	}
};

ObjectLiteralExpressionContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitObjectLiteralExpression(this);
	}
};


function PreDecreaseExpressionContext(parser, ctx) {
	SingleExpressionContext.call(this, parser);
    SingleExpressionContext.prototype.copyFrom.call(this, ctx);
    return this;
}

PreDecreaseExpressionContext.prototype = Object.create(SingleExpressionContext.prototype);
PreDecreaseExpressionContext.prototype.constructor = PreDecreaseExpressionContext;

ECMAScriptParser.PreDecreaseExpressionContext = PreDecreaseExpressionContext;

PreDecreaseExpressionContext.prototype.singleExpression = function() {
    return this.getTypedRuleContext(SingleExpressionContext,0);
};
PreDecreaseExpressionContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterPreDecreaseExpression(this);
	}
};

PreDecreaseExpressionContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitPreDecreaseExpression(this);
	}
};


function InExpressionContext(parser, ctx) {
	SingleExpressionContext.call(this, parser);
    SingleExpressionContext.prototype.copyFrom.call(this, ctx);
    return this;
}

InExpressionContext.prototype = Object.create(SingleExpressionContext.prototype);
InExpressionContext.prototype.constructor = InExpressionContext;

ECMAScriptParser.InExpressionContext = InExpressionContext;

InExpressionContext.prototype.singleExpression = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(SingleExpressionContext);
    } else {
        return this.getTypedRuleContext(SingleExpressionContext,i);
    }
};

InExpressionContext.prototype.In = function() {
    return this.getToken(ECMAScriptParser.In, 0);
};
InExpressionContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterInExpression(this);
	}
};

InExpressionContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitInExpression(this);
	}
};


function ArrayLiteralExpressionContext(parser, ctx) {
	SingleExpressionContext.call(this, parser);
    SingleExpressionContext.prototype.copyFrom.call(this, ctx);
    return this;
}

ArrayLiteralExpressionContext.prototype = Object.create(SingleExpressionContext.prototype);
ArrayLiteralExpressionContext.prototype.constructor = ArrayLiteralExpressionContext;

ECMAScriptParser.ArrayLiteralExpressionContext = ArrayLiteralExpressionContext;

ArrayLiteralExpressionContext.prototype.arrayLiteral = function() {
    return this.getTypedRuleContext(ArrayLiteralContext,0);
};
ArrayLiteralExpressionContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterArrayLiteralExpression(this);
	}
};

ArrayLiteralExpressionContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitArrayLiteralExpression(this);
	}
};


function ArgumentsExpressionContext(parser, ctx) {
	SingleExpressionContext.call(this, parser);
    SingleExpressionContext.prototype.copyFrom.call(this, ctx);
    return this;
}

ArgumentsExpressionContext.prototype = Object.create(SingleExpressionContext.prototype);
ArgumentsExpressionContext.prototype.constructor = ArgumentsExpressionContext;

ECMAScriptParser.ArgumentsExpressionContext = ArgumentsExpressionContext;

ArgumentsExpressionContext.prototype.singleExpression = function() {
    return this.getTypedRuleContext(SingleExpressionContext,0);
};

ArgumentsExpressionContext.prototype.arguments = function() {
    return this.getTypedRuleContext(ArgumentsContext,0);
};
ArgumentsExpressionContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterArgumentsExpression(this);
	}
};

ArgumentsExpressionContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitArgumentsExpression(this);
	}
};


function MemberDotExpressionContext(parser, ctx) {
	SingleExpressionContext.call(this, parser);
    SingleExpressionContext.prototype.copyFrom.call(this, ctx);
    return this;
}

MemberDotExpressionContext.prototype = Object.create(SingleExpressionContext.prototype);
MemberDotExpressionContext.prototype.constructor = MemberDotExpressionContext;

ECMAScriptParser.MemberDotExpressionContext = MemberDotExpressionContext;

MemberDotExpressionContext.prototype.singleExpression = function() {
    return this.getTypedRuleContext(SingleExpressionContext,0);
};

MemberDotExpressionContext.prototype.identifierName = function() {
    return this.getTypedRuleContext(IdentifierNameContext,0);
};
MemberDotExpressionContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterMemberDotExpression(this);
	}
};

MemberDotExpressionContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitMemberDotExpression(this);
	}
};


function NotExpressionContext(parser, ctx) {
	SingleExpressionContext.call(this, parser);
    SingleExpressionContext.prototype.copyFrom.call(this, ctx);
    return this;
}

NotExpressionContext.prototype = Object.create(SingleExpressionContext.prototype);
NotExpressionContext.prototype.constructor = NotExpressionContext;

ECMAScriptParser.NotExpressionContext = NotExpressionContext;

NotExpressionContext.prototype.singleExpression = function() {
    return this.getTypedRuleContext(SingleExpressionContext,0);
};
NotExpressionContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterNotExpression(this);
	}
};

NotExpressionContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitNotExpression(this);
	}
};


function DeleteExpressionContext(parser, ctx) {
	SingleExpressionContext.call(this, parser);
    SingleExpressionContext.prototype.copyFrom.call(this, ctx);
    return this;
}

DeleteExpressionContext.prototype = Object.create(SingleExpressionContext.prototype);
DeleteExpressionContext.prototype.constructor = DeleteExpressionContext;

ECMAScriptParser.DeleteExpressionContext = DeleteExpressionContext;

DeleteExpressionContext.prototype.Delete = function() {
    return this.getToken(ECMAScriptParser.Delete, 0);
};

DeleteExpressionContext.prototype.singleExpression = function() {
    return this.getTypedRuleContext(SingleExpressionContext,0);
};
DeleteExpressionContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterDeleteExpression(this);
	}
};

DeleteExpressionContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitDeleteExpression(this);
	}
};


function IdentifierExpressionContext(parser, ctx) {
	SingleExpressionContext.call(this, parser);
    SingleExpressionContext.prototype.copyFrom.call(this, ctx);
    return this;
}

IdentifierExpressionContext.prototype = Object.create(SingleExpressionContext.prototype);
IdentifierExpressionContext.prototype.constructor = IdentifierExpressionContext;

ECMAScriptParser.IdentifierExpressionContext = IdentifierExpressionContext;

IdentifierExpressionContext.prototype.Identifier = function() {
    return this.getToken(ECMAScriptParser.Identifier, 0);
};
IdentifierExpressionContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterIdentifierExpression(this);
	}
};

IdentifierExpressionContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitIdentifierExpression(this);
	}
};


function BitAndExpressionContext(parser, ctx) {
	SingleExpressionContext.call(this, parser);
    SingleExpressionContext.prototype.copyFrom.call(this, ctx);
    return this;
}

BitAndExpressionContext.prototype = Object.create(SingleExpressionContext.prototype);
BitAndExpressionContext.prototype.constructor = BitAndExpressionContext;

ECMAScriptParser.BitAndExpressionContext = BitAndExpressionContext;

BitAndExpressionContext.prototype.singleExpression = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(SingleExpressionContext);
    } else {
        return this.getTypedRuleContext(SingleExpressionContext,i);
    }
};
BitAndExpressionContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterBitAndExpression(this);
	}
};

BitAndExpressionContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitBitAndExpression(this);
	}
};


function UnaryMinusExpressionContext(parser, ctx) {
	SingleExpressionContext.call(this, parser);
    SingleExpressionContext.prototype.copyFrom.call(this, ctx);
    return this;
}

UnaryMinusExpressionContext.prototype = Object.create(SingleExpressionContext.prototype);
UnaryMinusExpressionContext.prototype.constructor = UnaryMinusExpressionContext;

ECMAScriptParser.UnaryMinusExpressionContext = UnaryMinusExpressionContext;

UnaryMinusExpressionContext.prototype.singleExpression = function() {
    return this.getTypedRuleContext(SingleExpressionContext,0);
};
UnaryMinusExpressionContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterUnaryMinusExpression(this);
	}
};

UnaryMinusExpressionContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitUnaryMinusExpression(this);
	}
};


function PreIncrementExpressionContext(parser, ctx) {
	SingleExpressionContext.call(this, parser);
    SingleExpressionContext.prototype.copyFrom.call(this, ctx);
    return this;
}

PreIncrementExpressionContext.prototype = Object.create(SingleExpressionContext.prototype);
PreIncrementExpressionContext.prototype.constructor = PreIncrementExpressionContext;

ECMAScriptParser.PreIncrementExpressionContext = PreIncrementExpressionContext;

PreIncrementExpressionContext.prototype.singleExpression = function() {
    return this.getTypedRuleContext(SingleExpressionContext,0);
};
PreIncrementExpressionContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterPreIncrementExpression(this);
	}
};

PreIncrementExpressionContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitPreIncrementExpression(this);
	}
};


function FunctionExpressionContext(parser, ctx) {
	SingleExpressionContext.call(this, parser);
    SingleExpressionContext.prototype.copyFrom.call(this, ctx);
    return this;
}

FunctionExpressionContext.prototype = Object.create(SingleExpressionContext.prototype);
FunctionExpressionContext.prototype.constructor = FunctionExpressionContext;

ECMAScriptParser.FunctionExpressionContext = FunctionExpressionContext;

FunctionExpressionContext.prototype.Function = function() {
    return this.getToken(ECMAScriptParser.Function, 0);
};

FunctionExpressionContext.prototype.functionBody = function() {
    return this.getTypedRuleContext(FunctionBodyContext,0);
};

FunctionExpressionContext.prototype.Identifier = function() {
    return this.getToken(ECMAScriptParser.Identifier, 0);
};

FunctionExpressionContext.prototype.formalParameterList = function() {
    return this.getTypedRuleContext(FormalParameterListContext,0);
};
FunctionExpressionContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterFunctionExpression(this);
	}
};

FunctionExpressionContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitFunctionExpression(this);
	}
};


function BitShiftExpressionContext(parser, ctx) {
	SingleExpressionContext.call(this, parser);
    SingleExpressionContext.prototype.copyFrom.call(this, ctx);
    return this;
}

BitShiftExpressionContext.prototype = Object.create(SingleExpressionContext.prototype);
BitShiftExpressionContext.prototype.constructor = BitShiftExpressionContext;

ECMAScriptParser.BitShiftExpressionContext = BitShiftExpressionContext;

BitShiftExpressionContext.prototype.singleExpression = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(SingleExpressionContext);
    } else {
        return this.getTypedRuleContext(SingleExpressionContext,i);
    }
};
BitShiftExpressionContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterBitShiftExpression(this);
	}
};

BitShiftExpressionContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitBitShiftExpression(this);
	}
};


function LogicalOrExpressionContext(parser, ctx) {
	SingleExpressionContext.call(this, parser);
    SingleExpressionContext.prototype.copyFrom.call(this, ctx);
    return this;
}

LogicalOrExpressionContext.prototype = Object.create(SingleExpressionContext.prototype);
LogicalOrExpressionContext.prototype.constructor = LogicalOrExpressionContext;

ECMAScriptParser.LogicalOrExpressionContext = LogicalOrExpressionContext;

LogicalOrExpressionContext.prototype.singleExpression = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(SingleExpressionContext);
    } else {
        return this.getTypedRuleContext(SingleExpressionContext,i);
    }
};
LogicalOrExpressionContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterLogicalOrExpression(this);
	}
};

LogicalOrExpressionContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitLogicalOrExpression(this);
	}
};


function VoidExpressionContext(parser, ctx) {
	SingleExpressionContext.call(this, parser);
    SingleExpressionContext.prototype.copyFrom.call(this, ctx);
    return this;
}

VoidExpressionContext.prototype = Object.create(SingleExpressionContext.prototype);
VoidExpressionContext.prototype.constructor = VoidExpressionContext;

ECMAScriptParser.VoidExpressionContext = VoidExpressionContext;

VoidExpressionContext.prototype.Void = function() {
    return this.getToken(ECMAScriptParser.Void, 0);
};

VoidExpressionContext.prototype.singleExpression = function() {
    return this.getTypedRuleContext(SingleExpressionContext,0);
};
VoidExpressionContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterVoidExpression(this);
	}
};

VoidExpressionContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitVoidExpression(this);
	}
};


function ParenthesizedExpressionContext(parser, ctx) {
	SingleExpressionContext.call(this, parser);
    SingleExpressionContext.prototype.copyFrom.call(this, ctx);
    return this;
}

ParenthesizedExpressionContext.prototype = Object.create(SingleExpressionContext.prototype);
ParenthesizedExpressionContext.prototype.constructor = ParenthesizedExpressionContext;

ECMAScriptParser.ParenthesizedExpressionContext = ParenthesizedExpressionContext;

ParenthesizedExpressionContext.prototype.expressionSequence = function() {
    return this.getTypedRuleContext(ExpressionSequenceContext,0);
};
ParenthesizedExpressionContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterParenthesizedExpression(this);
	}
};

ParenthesizedExpressionContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitParenthesizedExpression(this);
	}
};


function UnaryPlusExpressionContext(parser, ctx) {
	SingleExpressionContext.call(this, parser);
    SingleExpressionContext.prototype.copyFrom.call(this, ctx);
    return this;
}

UnaryPlusExpressionContext.prototype = Object.create(SingleExpressionContext.prototype);
UnaryPlusExpressionContext.prototype.constructor = UnaryPlusExpressionContext;

ECMAScriptParser.UnaryPlusExpressionContext = UnaryPlusExpressionContext;

UnaryPlusExpressionContext.prototype.singleExpression = function() {
    return this.getTypedRuleContext(SingleExpressionContext,0);
};
UnaryPlusExpressionContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterUnaryPlusExpression(this);
	}
};

UnaryPlusExpressionContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitUnaryPlusExpression(this);
	}
};


function LiteralExpressionContext(parser, ctx) {
	SingleExpressionContext.call(this, parser);
    SingleExpressionContext.prototype.copyFrom.call(this, ctx);
    return this;
}

LiteralExpressionContext.prototype = Object.create(SingleExpressionContext.prototype);
LiteralExpressionContext.prototype.constructor = LiteralExpressionContext;

ECMAScriptParser.LiteralExpressionContext = LiteralExpressionContext;

LiteralExpressionContext.prototype.literal = function() {
    return this.getTypedRuleContext(LiteralContext,0);
};
LiteralExpressionContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterLiteralExpression(this);
	}
};

LiteralExpressionContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitLiteralExpression(this);
	}
};


function BitNotExpressionContext(parser, ctx) {
	SingleExpressionContext.call(this, parser);
    SingleExpressionContext.prototype.copyFrom.call(this, ctx);
    return this;
}

BitNotExpressionContext.prototype = Object.create(SingleExpressionContext.prototype);
BitNotExpressionContext.prototype.constructor = BitNotExpressionContext;

ECMAScriptParser.BitNotExpressionContext = BitNotExpressionContext;

BitNotExpressionContext.prototype.singleExpression = function() {
    return this.getTypedRuleContext(SingleExpressionContext,0);
};
BitNotExpressionContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterBitNotExpression(this);
	}
};

BitNotExpressionContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitBitNotExpression(this);
	}
};


function PostIncrementExpressionContext(parser, ctx) {
	SingleExpressionContext.call(this, parser);
    SingleExpressionContext.prototype.copyFrom.call(this, ctx);
    return this;
}

PostIncrementExpressionContext.prototype = Object.create(SingleExpressionContext.prototype);
PostIncrementExpressionContext.prototype.constructor = PostIncrementExpressionContext;

ECMAScriptParser.PostIncrementExpressionContext = PostIncrementExpressionContext;

PostIncrementExpressionContext.prototype.singleExpression = function() {
    return this.getTypedRuleContext(SingleExpressionContext,0);
};
PostIncrementExpressionContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterPostIncrementExpression(this);
	}
};

PostIncrementExpressionContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitPostIncrementExpression(this);
	}
};


function TypeofExpressionContext(parser, ctx) {
	SingleExpressionContext.call(this, parser);
    SingleExpressionContext.prototype.copyFrom.call(this, ctx);
    return this;
}

TypeofExpressionContext.prototype = Object.create(SingleExpressionContext.prototype);
TypeofExpressionContext.prototype.constructor = TypeofExpressionContext;

ECMAScriptParser.TypeofExpressionContext = TypeofExpressionContext;

TypeofExpressionContext.prototype.Typeof = function() {
    return this.getToken(ECMAScriptParser.Typeof, 0);
};

TypeofExpressionContext.prototype.singleExpression = function() {
    return this.getTypedRuleContext(SingleExpressionContext,0);
};
TypeofExpressionContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterTypeofExpression(this);
	}
};

TypeofExpressionContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitTypeofExpression(this);
	}
};


function AssignmentOperatorExpressionContext(parser, ctx) {
	SingleExpressionContext.call(this, parser);
    SingleExpressionContext.prototype.copyFrom.call(this, ctx);
    return this;
}

AssignmentOperatorExpressionContext.prototype = Object.create(SingleExpressionContext.prototype);
AssignmentOperatorExpressionContext.prototype.constructor = AssignmentOperatorExpressionContext;

ECMAScriptParser.AssignmentOperatorExpressionContext = AssignmentOperatorExpressionContext;

AssignmentOperatorExpressionContext.prototype.singleExpression = function() {
    return this.getTypedRuleContext(SingleExpressionContext,0);
};

AssignmentOperatorExpressionContext.prototype.assignmentOperator = function() {
    return this.getTypedRuleContext(AssignmentOperatorContext,0);
};

AssignmentOperatorExpressionContext.prototype.expressionSequence = function() {
    return this.getTypedRuleContext(ExpressionSequenceContext,0);
};
AssignmentOperatorExpressionContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterAssignmentOperatorExpression(this);
	}
};

AssignmentOperatorExpressionContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitAssignmentOperatorExpression(this);
	}
};


function NewExpressionContext(parser, ctx) {
	SingleExpressionContext.call(this, parser);
    SingleExpressionContext.prototype.copyFrom.call(this, ctx);
    return this;
}

NewExpressionContext.prototype = Object.create(SingleExpressionContext.prototype);
NewExpressionContext.prototype.constructor = NewExpressionContext;

ECMAScriptParser.NewExpressionContext = NewExpressionContext;

NewExpressionContext.prototype.New = function() {
    return this.getToken(ECMAScriptParser.New, 0);
};

NewExpressionContext.prototype.singleExpression = function() {
    return this.getTypedRuleContext(SingleExpressionContext,0);
};

NewExpressionContext.prototype.arguments = function() {
    return this.getTypedRuleContext(ArgumentsContext,0);
};
NewExpressionContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterNewExpression(this);
	}
};

NewExpressionContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitNewExpression(this);
	}
};


function PostDecreaseExpressionContext(parser, ctx) {
	SingleExpressionContext.call(this, parser);
    SingleExpressionContext.prototype.copyFrom.call(this, ctx);
    return this;
}

PostDecreaseExpressionContext.prototype = Object.create(SingleExpressionContext.prototype);
PostDecreaseExpressionContext.prototype.constructor = PostDecreaseExpressionContext;

ECMAScriptParser.PostDecreaseExpressionContext = PostDecreaseExpressionContext;

PostDecreaseExpressionContext.prototype.singleExpression = function() {
    return this.getTypedRuleContext(SingleExpressionContext,0);
};
PostDecreaseExpressionContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterPostDecreaseExpression(this);
	}
};

PostDecreaseExpressionContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitPostDecreaseExpression(this);
	}
};


function RelationalExpressionContext(parser, ctx) {
	SingleExpressionContext.call(this, parser);
    SingleExpressionContext.prototype.copyFrom.call(this, ctx);
    return this;
}

RelationalExpressionContext.prototype = Object.create(SingleExpressionContext.prototype);
RelationalExpressionContext.prototype.constructor = RelationalExpressionContext;

ECMAScriptParser.RelationalExpressionContext = RelationalExpressionContext;

RelationalExpressionContext.prototype.singleExpression = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(SingleExpressionContext);
    } else {
        return this.getTypedRuleContext(SingleExpressionContext,i);
    }
};
RelationalExpressionContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterRelationalExpression(this);
	}
};

RelationalExpressionContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitRelationalExpression(this);
	}
};


function EqualityExpressionContext(parser, ctx) {
	SingleExpressionContext.call(this, parser);
    SingleExpressionContext.prototype.copyFrom.call(this, ctx);
    return this;
}

EqualityExpressionContext.prototype = Object.create(SingleExpressionContext.prototype);
EqualityExpressionContext.prototype.constructor = EqualityExpressionContext;

ECMAScriptParser.EqualityExpressionContext = EqualityExpressionContext;

EqualityExpressionContext.prototype.singleExpression = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(SingleExpressionContext);
    } else {
        return this.getTypedRuleContext(SingleExpressionContext,i);
    }
};
EqualityExpressionContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterEqualityExpression(this);
	}
};

EqualityExpressionContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitEqualityExpression(this);
	}
};


function BitXOrExpressionContext(parser, ctx) {
	SingleExpressionContext.call(this, parser);
    SingleExpressionContext.prototype.copyFrom.call(this, ctx);
    return this;
}

BitXOrExpressionContext.prototype = Object.create(SingleExpressionContext.prototype);
BitXOrExpressionContext.prototype.constructor = BitXOrExpressionContext;

ECMAScriptParser.BitXOrExpressionContext = BitXOrExpressionContext;

BitXOrExpressionContext.prototype.singleExpression = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(SingleExpressionContext);
    } else {
        return this.getTypedRuleContext(SingleExpressionContext,i);
    }
};
BitXOrExpressionContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterBitXOrExpression(this);
	}
};

BitXOrExpressionContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitBitXOrExpression(this);
	}
};


function AdditiveExpressionContext(parser, ctx) {
	SingleExpressionContext.call(this, parser);
    SingleExpressionContext.prototype.copyFrom.call(this, ctx);
    return this;
}

AdditiveExpressionContext.prototype = Object.create(SingleExpressionContext.prototype);
AdditiveExpressionContext.prototype.constructor = AdditiveExpressionContext;

ECMAScriptParser.AdditiveExpressionContext = AdditiveExpressionContext;

AdditiveExpressionContext.prototype.singleExpression = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(SingleExpressionContext);
    } else {
        return this.getTypedRuleContext(SingleExpressionContext,i);
    }
};
AdditiveExpressionContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterAdditiveExpression(this);
	}
};

AdditiveExpressionContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitAdditiveExpression(this);
	}
};


function ThisExpressionContext(parser, ctx) {
	SingleExpressionContext.call(this, parser);
    SingleExpressionContext.prototype.copyFrom.call(this, ctx);
    return this;
}

ThisExpressionContext.prototype = Object.create(SingleExpressionContext.prototype);
ThisExpressionContext.prototype.constructor = ThisExpressionContext;

ECMAScriptParser.ThisExpressionContext = ThisExpressionContext;

ThisExpressionContext.prototype.This = function() {
    return this.getToken(ECMAScriptParser.This, 0);
};
ThisExpressionContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterThisExpression(this);
	}
};

ThisExpressionContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitThisExpression(this);
	}
};


function MemberIndexExpressionContext(parser, ctx) {
	SingleExpressionContext.call(this, parser);
    SingleExpressionContext.prototype.copyFrom.call(this, ctx);
    return this;
}

MemberIndexExpressionContext.prototype = Object.create(SingleExpressionContext.prototype);
MemberIndexExpressionContext.prototype.constructor = MemberIndexExpressionContext;

ECMAScriptParser.MemberIndexExpressionContext = MemberIndexExpressionContext;

MemberIndexExpressionContext.prototype.singleExpression = function() {
    return this.getTypedRuleContext(SingleExpressionContext,0);
};

MemberIndexExpressionContext.prototype.expressionSequence = function() {
    return this.getTypedRuleContext(ExpressionSequenceContext,0);
};
MemberIndexExpressionContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterMemberIndexExpression(this);
	}
};

MemberIndexExpressionContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitMemberIndexExpression(this);
	}
};


function MultiplicativeExpressionContext(parser, ctx) {
	SingleExpressionContext.call(this, parser);
    SingleExpressionContext.prototype.copyFrom.call(this, ctx);
    return this;
}

MultiplicativeExpressionContext.prototype = Object.create(SingleExpressionContext.prototype);
MultiplicativeExpressionContext.prototype.constructor = MultiplicativeExpressionContext;

ECMAScriptParser.MultiplicativeExpressionContext = MultiplicativeExpressionContext;

MultiplicativeExpressionContext.prototype.singleExpression = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(SingleExpressionContext);
    } else {
        return this.getTypedRuleContext(SingleExpressionContext,i);
    }
};
MultiplicativeExpressionContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterMultiplicativeExpression(this);
	}
};

MultiplicativeExpressionContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitMultiplicativeExpression(this);
	}
};



ECMAScriptParser.prototype.singleExpression = function(_p) {
	if(_p===undefined) {
	    _p = 0;
	}
    var _parentctx = this._ctx;
    var _parentState = this.state;
    var localctx = new SingleExpressionContext(this, this._ctx, _parentState);
    var _prevctx = localctx;
    var _startState = 86;
    this.enterRecursionRule(localctx, 86, ECMAScriptParser.RULE_singleExpression, _p);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 506;
        switch(this._input.LA(1)) {
        case ECMAScriptParser.Delete:
            localctx = new DeleteExpressionContext(this, localctx);
            this._ctx = localctx;
            _prevctx = localctx;

            this.state = 461;
            this.match(ECMAScriptParser.Delete);
            this.state = 462;
            this.singleExpression(30);
            break;
        case ECMAScriptParser.Void:
            localctx = new VoidExpressionContext(this, localctx);
            this._ctx = localctx;
            _prevctx = localctx;
            this.state = 463;
            this.match(ECMAScriptParser.Void);
            this.state = 464;
            this.singleExpression(29);
            break;
        case ECMAScriptParser.Typeof:
            localctx = new TypeofExpressionContext(this, localctx);
            this._ctx = localctx;
            _prevctx = localctx;
            this.state = 465;
            this.match(ECMAScriptParser.Typeof);
            this.state = 466;
            this.singleExpression(28);
            break;
        case ECMAScriptParser.PlusPlus:
            localctx = new PreIncrementExpressionContext(this, localctx);
            this._ctx = localctx;
            _prevctx = localctx;
            this.state = 467;
            this.match(ECMAScriptParser.PlusPlus);
            this.state = 468;
            this.singleExpression(27);
            break;
        case ECMAScriptParser.MinusMinus:
            localctx = new PreDecreaseExpressionContext(this, localctx);
            this._ctx = localctx;
            _prevctx = localctx;
            this.state = 469;
            this.match(ECMAScriptParser.MinusMinus);
            this.state = 470;
            this.singleExpression(26);
            break;
        case ECMAScriptParser.Plus:
            localctx = new UnaryPlusExpressionContext(this, localctx);
            this._ctx = localctx;
            _prevctx = localctx;
            this.state = 471;
            this.match(ECMAScriptParser.Plus);
            this.state = 472;
            this.singleExpression(25);
            break;
        case ECMAScriptParser.Minus:
            localctx = new UnaryMinusExpressionContext(this, localctx);
            this._ctx = localctx;
            _prevctx = localctx;
            this.state = 473;
            this.match(ECMAScriptParser.Minus);
            this.state = 474;
            this.singleExpression(24);
            break;
        case ECMAScriptParser.BitNot:
            localctx = new BitNotExpressionContext(this, localctx);
            this._ctx = localctx;
            _prevctx = localctx;
            this.state = 475;
            this.match(ECMAScriptParser.BitNot);
            this.state = 476;
            this.singleExpression(23);
            break;
        case ECMAScriptParser.Not:
            localctx = new NotExpressionContext(this, localctx);
            this._ctx = localctx;
            _prevctx = localctx;
            this.state = 477;
            this.match(ECMAScriptParser.Not);
            this.state = 478;
            this.singleExpression(22);
            break;
        case ECMAScriptParser.Function:
            localctx = new FunctionExpressionContext(this, localctx);
            this._ctx = localctx;
            _prevctx = localctx;
            this.state = 479;
            this.match(ECMAScriptParser.Function);
            this.state = 481;
            _la = this._input.LA(1);
            if(_la===ECMAScriptParser.Identifier) {
                this.state = 480;
                this.match(ECMAScriptParser.Identifier);
            }

            this.state = 483;
            this.match(ECMAScriptParser.OpenParen);
            this.state = 485;
            _la = this._input.LA(1);
            if(_la===ECMAScriptParser.Identifier) {
                this.state = 484;
                this.formalParameterList();
            }

            this.state = 487;
            this.match(ECMAScriptParser.CloseParen);
            this.state = 488;
            this.match(ECMAScriptParser.OpenBrace);
            this.state = 489;
            this.functionBody();
            this.state = 490;
            this.match(ECMAScriptParser.CloseBrace);
            break;
        case ECMAScriptParser.New:
            localctx = new NewExpressionContext(this, localctx);
            this._ctx = localctx;
            _prevctx = localctx;
            this.state = 492;
            this.match(ECMAScriptParser.New);
            this.state = 493;
            this.singleExpression(0);
            this.state = 495;
            var la_ = this._interp.adaptivePredict(this._input,45,this._ctx);
            if(la_===1) {
                this.state = 494;
                this.arguments();

            }
            break;
        case ECMAScriptParser.This:
            localctx = new ThisExpressionContext(this, localctx);
            this._ctx = localctx;
            _prevctx = localctx;
            this.state = 497;
            this.match(ECMAScriptParser.This);
            break;
        case ECMAScriptParser.Identifier:
            localctx = new IdentifierExpressionContext(this, localctx);
            this._ctx = localctx;
            _prevctx = localctx;
            this.state = 498;
            this.match(ECMAScriptParser.Identifier);
            break;
        case ECMAScriptParser.RegularExpressionLiteral:
        case ECMAScriptParser.NullLiteral:
        case ECMAScriptParser.BooleanLiteral:
        case ECMAScriptParser.DecimalLiteral:
        case ECMAScriptParser.HexIntegerLiteral:
        case ECMAScriptParser.OctalIntegerLiteral:
        case ECMAScriptParser.StringLiteral:
            localctx = new LiteralExpressionContext(this, localctx);
            this._ctx = localctx;
            _prevctx = localctx;
            this.state = 499;
            this.literal();
            break;
        case ECMAScriptParser.OpenBracket:
            localctx = new ArrayLiteralExpressionContext(this, localctx);
            this._ctx = localctx;
            _prevctx = localctx;
            this.state = 500;
            this.arrayLiteral();
            break;
        case ECMAScriptParser.OpenBrace:
            localctx = new ObjectLiteralExpressionContext(this, localctx);
            this._ctx = localctx;
            _prevctx = localctx;
            this.state = 501;
            this.objectLiteral();
            break;
        case ECMAScriptParser.OpenParen:
            localctx = new ParenthesizedExpressionContext(this, localctx);
            this._ctx = localctx;
            _prevctx = localctx;
            this.state = 502;
            this.match(ECMAScriptParser.OpenParen);
            this.state = 503;
            this.expressionSequence();
            this.state = 504;
            this.match(ECMAScriptParser.CloseParen);
            break;
        default:
            throw new antlr4.error.NoViableAltException(this);
        }
        this._ctx.stop = this._input.LT(-1);
        this.state = 575;
        this._errHandler.sync(this);
        var _alt = this._interp.adaptivePredict(this._input,48,this._ctx)
        while(_alt!=2 && _alt!=antlr4.atn.ATN.INVALID_ALT_NUMBER) {
            if(_alt===1) {
                if(this._parseListeners!==null) {
                    this.triggerExitRuleEvent();
                }
                _prevctx = localctx;
                this.state = 573;
                var la_ = this._interp.adaptivePredict(this._input,47,this._ctx);
                switch(la_) {
                case 1:
                    localctx = new MultiplicativeExpressionContext(this, new SingleExpressionContext(this, _parentctx, _parentState));
                    this.pushNewRecursionContext(localctx, _startState, ECMAScriptParser.RULE_singleExpression);
                    this.state = 508;
                    if (!( this.precpred(this._ctx, 21))) {
                        throw new antlr4.error.FailedPredicateException(this, "this.precpred(this._ctx, 21)");
                    }
                    this.state = 509;
                    _la = this._input.LA(1);
                    if(!((((_la) & ~0x1f) == 0 && ((1 << _la) & ((1 << ECMAScriptParser.Multiply) | (1 << ECMAScriptParser.Divide) | (1 << ECMAScriptParser.Modulus))) !== 0))) {
                    this._errHandler.recoverInline(this);
                    }
                    else {
                        this.consume();
                    }
                    this.state = 510;
                    this.singleExpression(22);
                    break;

                case 2:
                    localctx = new AdditiveExpressionContext(this, new SingleExpressionContext(this, _parentctx, _parentState));
                    this.pushNewRecursionContext(localctx, _startState, ECMAScriptParser.RULE_singleExpression);
                    this.state = 511;
                    if (!( this.precpred(this._ctx, 20))) {
                        throw new antlr4.error.FailedPredicateException(this, "this.precpred(this._ctx, 20)");
                    }
                    this.state = 512;
                    _la = this._input.LA(1);
                    if(!(_la===ECMAScriptParser.Plus || _la===ECMAScriptParser.Minus)) {
                    this._errHandler.recoverInline(this);
                    }
                    else {
                        this.consume();
                    }
                    this.state = 513;
                    this.singleExpression(21);
                    break;

                case 3:
                    localctx = new BitShiftExpressionContext(this, new SingleExpressionContext(this, _parentctx, _parentState));
                    this.pushNewRecursionContext(localctx, _startState, ECMAScriptParser.RULE_singleExpression);
                    this.state = 514;
                    if (!( this.precpred(this._ctx, 19))) {
                        throw new antlr4.error.FailedPredicateException(this, "this.precpred(this._ctx, 19)");
                    }
                    this.state = 515;
                    _la = this._input.LA(1);
                    if(!((((_la) & ~0x1f) == 0 && ((1 << _la) & ((1 << ECMAScriptParser.RightShiftArithmetic) | (1 << ECMAScriptParser.LeftShiftArithmetic) | (1 << ECMAScriptParser.RightShiftLogical))) !== 0))) {
                    this._errHandler.recoverInline(this);
                    }
                    else {
                        this.consume();
                    }
                    this.state = 516;
                    this.singleExpression(20);
                    break;

                case 4:
                    localctx = new RelationalExpressionContext(this, new SingleExpressionContext(this, _parentctx, _parentState));
                    this.pushNewRecursionContext(localctx, _startState, ECMAScriptParser.RULE_singleExpression);
                    this.state = 517;
                    if (!( this.precpred(this._ctx, 18))) {
                        throw new antlr4.error.FailedPredicateException(this, "this.precpred(this._ctx, 18)");
                    }
                    this.state = 518;
                    _la = this._input.LA(1);
                    if(!((((_la) & ~0x1f) == 0 && ((1 << _la) & ((1 << ECMAScriptParser.LessThan) | (1 << ECMAScriptParser.MoreThan) | (1 << ECMAScriptParser.LessThanEquals) | (1 << ECMAScriptParser.GreaterThanEquals))) !== 0))) {
                    this._errHandler.recoverInline(this);
                    }
                    else {
                        this.consume();
                    }
                    this.state = 519;
                    this.singleExpression(19);
                    break;

                case 5:
                    localctx = new InstanceofExpressionContext(this, new SingleExpressionContext(this, _parentctx, _parentState));
                    this.pushNewRecursionContext(localctx, _startState, ECMAScriptParser.RULE_singleExpression);
                    this.state = 520;
                    if (!( this.precpred(this._ctx, 17))) {
                        throw new antlr4.error.FailedPredicateException(this, "this.precpred(this._ctx, 17)");
                    }
                    this.state = 521;
                    this.match(ECMAScriptParser.Instanceof);
                    this.state = 522;
                    this.singleExpression(18);
                    break;

                case 6:
                    localctx = new InExpressionContext(this, new SingleExpressionContext(this, _parentctx, _parentState));
                    this.pushNewRecursionContext(localctx, _startState, ECMAScriptParser.RULE_singleExpression);
                    this.state = 523;
                    if (!( this.precpred(this._ctx, 16))) {
                        throw new antlr4.error.FailedPredicateException(this, "this.precpred(this._ctx, 16)");
                    }
                    this.state = 524;
                    this.match(ECMAScriptParser.In);
                    this.state = 525;
                    this.singleExpression(17);
                    break;

                case 7:
                    localctx = new EqualityExpressionContext(this, new SingleExpressionContext(this, _parentctx, _parentState));
                    this.pushNewRecursionContext(localctx, _startState, ECMAScriptParser.RULE_singleExpression);
                    this.state = 526;
                    if (!( this.precpred(this._ctx, 15))) {
                        throw new antlr4.error.FailedPredicateException(this, "this.precpred(this._ctx, 15)");
                    }
                    this.state = 527;
                    _la = this._input.LA(1);
                    if(!(((((_la - 31)) & ~0x1f) == 0 && ((1 << (_la - 31)) & ((1 << (ECMAScriptParser.Equals - 31)) | (1 << (ECMAScriptParser.NotEquals - 31)) | (1 << (ECMAScriptParser.IdentityEquals - 31)) | (1 << (ECMAScriptParser.IdentityNotEquals - 31)))) !== 0))) {
                    this._errHandler.recoverInline(this);
                    }
                    else {
                        this.consume();
                    }
                    this.state = 528;
                    this.singleExpression(16);
                    break;

                case 8:
                    localctx = new BitAndExpressionContext(this, new SingleExpressionContext(this, _parentctx, _parentState));
                    this.pushNewRecursionContext(localctx, _startState, ECMAScriptParser.RULE_singleExpression);
                    this.state = 529;
                    if (!( this.precpred(this._ctx, 14))) {
                        throw new antlr4.error.FailedPredicateException(this, "this.precpred(this._ctx, 14)");
                    }
                    this.state = 530;
                    this.match(ECMAScriptParser.BitAnd);
                    this.state = 531;
                    this.singleExpression(15);
                    break;

                case 9:
                    localctx = new BitXOrExpressionContext(this, new SingleExpressionContext(this, _parentctx, _parentState));
                    this.pushNewRecursionContext(localctx, _startState, ECMAScriptParser.RULE_singleExpression);
                    this.state = 532;
                    if (!( this.precpred(this._ctx, 13))) {
                        throw new antlr4.error.FailedPredicateException(this, "this.precpred(this._ctx, 13)");
                    }
                    this.state = 533;
                    this.match(ECMAScriptParser.BitXOr);
                    this.state = 534;
                    this.singleExpression(14);
                    break;

                case 10:
                    localctx = new BitOrExpressionContext(this, new SingleExpressionContext(this, _parentctx, _parentState));
                    this.pushNewRecursionContext(localctx, _startState, ECMAScriptParser.RULE_singleExpression);
                    this.state = 535;
                    if (!( this.precpred(this._ctx, 12))) {
                        throw new antlr4.error.FailedPredicateException(this, "this.precpred(this._ctx, 12)");
                    }
                    this.state = 536;
                    this.match(ECMAScriptParser.BitOr);
                    this.state = 537;
                    this.singleExpression(13);
                    break;

                case 11:
                    localctx = new LogicalAndExpressionContext(this, new SingleExpressionContext(this, _parentctx, _parentState));
                    this.pushNewRecursionContext(localctx, _startState, ECMAScriptParser.RULE_singleExpression);
                    this.state = 538;
                    if (!( this.precpred(this._ctx, 11))) {
                        throw new antlr4.error.FailedPredicateException(this, "this.precpred(this._ctx, 11)");
                    }
                    this.state = 539;
                    this.match(ECMAScriptParser.And);
                    this.state = 540;
                    this.singleExpression(12);
                    break;

                case 12:
                    localctx = new LogicalOrExpressionContext(this, new SingleExpressionContext(this, _parentctx, _parentState));
                    this.pushNewRecursionContext(localctx, _startState, ECMAScriptParser.RULE_singleExpression);
                    this.state = 541;
                    if (!( this.precpred(this._ctx, 10))) {
                        throw new antlr4.error.FailedPredicateException(this, "this.precpred(this._ctx, 10)");
                    }
                    this.state = 542;
                    this.match(ECMAScriptParser.Or);
                    this.state = 543;
                    this.singleExpression(11);
                    break;

                case 13:
                    localctx = new TernaryExpressionContext(this, new SingleExpressionContext(this, _parentctx, _parentState));
                    this.pushNewRecursionContext(localctx, _startState, ECMAScriptParser.RULE_singleExpression);
                    this.state = 544;
                    if (!( this.precpred(this._ctx, 9))) {
                        throw new antlr4.error.FailedPredicateException(this, "this.precpred(this._ctx, 9)");
                    }
                    this.state = 545;
                    this.match(ECMAScriptParser.QuestionMark);
                    this.state = 546;
                    this.singleExpression(0);
                    this.state = 547;
                    this.match(ECMAScriptParser.Colon);
                    this.state = 548;
                    this.singleExpression(10);
                    break;

                case 14:
                    localctx = new MemberIndexExpressionContext(this, new SingleExpressionContext(this, _parentctx, _parentState));
                    this.pushNewRecursionContext(localctx, _startState, ECMAScriptParser.RULE_singleExpression);
                    this.state = 550;
                    if (!( this.precpred(this._ctx, 36))) {
                        throw new antlr4.error.FailedPredicateException(this, "this.precpred(this._ctx, 36)");
                    }
                    this.state = 551;
                    this.match(ECMAScriptParser.OpenBracket);
                    this.state = 552;
                    this.expressionSequence();
                    this.state = 553;
                    this.match(ECMAScriptParser.CloseBracket);
                    break;

                case 15:
                    localctx = new MemberDotExpressionContext(this, new SingleExpressionContext(this, _parentctx, _parentState));
                    this.pushNewRecursionContext(localctx, _startState, ECMAScriptParser.RULE_singleExpression);
                    this.state = 555;
                    if (!( this.precpred(this._ctx, 35))) {
                        throw new antlr4.error.FailedPredicateException(this, "this.precpred(this._ctx, 35)");
                    }
                    this.state = 556;
                    this.match(ECMAScriptParser.Dot);
                    this.state = 557;
                    this.identifierName();
                    break;

                case 16:
                    localctx = new ArgumentsExpressionContext(this, new SingleExpressionContext(this, _parentctx, _parentState));
                    this.pushNewRecursionContext(localctx, _startState, ECMAScriptParser.RULE_singleExpression);
                    this.state = 558;
                    if (!( this.precpred(this._ctx, 34))) {
                        throw new antlr4.error.FailedPredicateException(this, "this.precpred(this._ctx, 34)");
                    }
                    this.state = 559;
                    this.arguments();
                    break;

                case 17:
                    localctx = new PostIncrementExpressionContext(this, new SingleExpressionContext(this, _parentctx, _parentState));
                    this.pushNewRecursionContext(localctx, _startState, ECMAScriptParser.RULE_singleExpression);
                    this.state = 560;
                    if (!( this.precpred(this._ctx, 32))) {
                        throw new antlr4.error.FailedPredicateException(this, "this.precpred(this._ctx, 32)");
                    }
                    this.state = 561;
                    if (!( !this.here(ECMAScriptParser.LineTerminator))) {
                        throw new antlr4.error.FailedPredicateException(this, "!this.here(ECMAScriptParser.LineTerminator)");
                    }
                    this.state = 562;
                    this.match(ECMAScriptParser.PlusPlus);
                    break;

                case 18:
                    localctx = new PostDecreaseExpressionContext(this, new SingleExpressionContext(this, _parentctx, _parentState));
                    this.pushNewRecursionContext(localctx, _startState, ECMAScriptParser.RULE_singleExpression);
                    this.state = 563;
                    if (!( this.precpred(this._ctx, 31))) {
                        throw new antlr4.error.FailedPredicateException(this, "this.precpred(this._ctx, 31)");
                    }
                    this.state = 564;
                    if (!( !this.here(ECMAScriptParser.LineTerminator))) {
                        throw new antlr4.error.FailedPredicateException(this, "!this.here(ECMAScriptParser.LineTerminator)");
                    }
                    this.state = 565;
                    this.match(ECMAScriptParser.MinusMinus);
                    break;

                case 19:
                    localctx = new AssignmentExpressionContext(this, new SingleExpressionContext(this, _parentctx, _parentState));
                    this.pushNewRecursionContext(localctx, _startState, ECMAScriptParser.RULE_singleExpression);
                    this.state = 566;
                    if (!( this.precpred(this._ctx, 8))) {
                        throw new antlr4.error.FailedPredicateException(this, "this.precpred(this._ctx, 8)");
                    }
                    this.state = 567;
                    this.match(ECMAScriptParser.Assign);
                    this.state = 568;
                    this.expressionSequence();
                    break;

                case 20:
                    localctx = new AssignmentOperatorExpressionContext(this, new SingleExpressionContext(this, _parentctx, _parentState));
                    this.pushNewRecursionContext(localctx, _startState, ECMAScriptParser.RULE_singleExpression);
                    this.state = 569;
                    if (!( this.precpred(this._ctx, 7))) {
                        throw new antlr4.error.FailedPredicateException(this, "this.precpred(this._ctx, 7)");
                    }
                    this.state = 570;
                    this.assignmentOperator();
                    this.state = 571;
                    this.expressionSequence();
                    break;

                } 
            }
            this.state = 577;
            this._errHandler.sync(this);
            _alt = this._interp.adaptivePredict(this._input,48,this._ctx);
        }

    } catch( error) {
        if(error instanceof antlr4.error.RecognitionException) {
	        localctx.exception = error;
	        this._errHandler.reportError(this, error);
	        this._errHandler.recover(this, error);
	    } else {
	    	throw error;
	    }
    } finally {
        this.unrollRecursionContexts(_parentctx)
    }
    return localctx;
};

function AssignmentOperatorContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_assignmentOperator;
    return this;
}

AssignmentOperatorContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
AssignmentOperatorContext.prototype.constructor = AssignmentOperatorContext;


AssignmentOperatorContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterAssignmentOperator(this);
	}
};

AssignmentOperatorContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitAssignmentOperator(this);
	}
};




ECMAScriptParser.AssignmentOperatorContext = AssignmentOperatorContext;

ECMAScriptParser.prototype.assignmentOperator = function() {

    var localctx = new AssignmentOperatorContext(this, this._ctx, this.state);
    this.enterRule(localctx, 88, ECMAScriptParser.RULE_assignmentOperator);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 578;
        _la = this._input.LA(1);
        if(!(((((_la - 40)) & ~0x1f) == 0 && ((1 << (_la - 40)) & ((1 << (ECMAScriptParser.MultiplyAssign - 40)) | (1 << (ECMAScriptParser.DivideAssign - 40)) | (1 << (ECMAScriptParser.ModulusAssign - 40)) | (1 << (ECMAScriptParser.PlusAssign - 40)) | (1 << (ECMAScriptParser.MinusAssign - 40)) | (1 << (ECMAScriptParser.LeftShiftArithmeticAssign - 40)) | (1 << (ECMAScriptParser.RightShiftArithmeticAssign - 40)) | (1 << (ECMAScriptParser.RightShiftLogicalAssign - 40)) | (1 << (ECMAScriptParser.BitAndAssign - 40)) | (1 << (ECMAScriptParser.BitXorAssign - 40)) | (1 << (ECMAScriptParser.BitOrAssign - 40)))) !== 0))) {
        this._errHandler.recoverInline(this);
        }
        else {
            this.consume();
        }
    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function LiteralContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_literal;
    return this;
}

LiteralContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
LiteralContext.prototype.constructor = LiteralContext;

LiteralContext.prototype.NullLiteral = function() {
    return this.getToken(ECMAScriptParser.NullLiteral, 0);
};

LiteralContext.prototype.BooleanLiteral = function() {
    return this.getToken(ECMAScriptParser.BooleanLiteral, 0);
};

LiteralContext.prototype.StringLiteral = function() {
    return this.getToken(ECMAScriptParser.StringLiteral, 0);
};

LiteralContext.prototype.RegularExpressionLiteral = function() {
    return this.getToken(ECMAScriptParser.RegularExpressionLiteral, 0);
};

LiteralContext.prototype.numericLiteral = function() {
    return this.getTypedRuleContext(NumericLiteralContext,0);
};

LiteralContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterLiteral(this);
	}
};

LiteralContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitLiteral(this);
	}
};




ECMAScriptParser.LiteralContext = LiteralContext;

ECMAScriptParser.prototype.literal = function() {

    var localctx = new LiteralContext(this, this._ctx, this.state);
    this.enterRule(localctx, 90, ECMAScriptParser.RULE_literal);
    var _la = 0; // Token type
    try {
        this.state = 582;
        switch(this._input.LA(1)) {
        case ECMAScriptParser.RegularExpressionLiteral:
        case ECMAScriptParser.NullLiteral:
        case ECMAScriptParser.BooleanLiteral:
        case ECMAScriptParser.StringLiteral:
            this.enterOuterAlt(localctx, 1);
            this.state = 580;
            _la = this._input.LA(1);
            if(!(_la===ECMAScriptParser.RegularExpressionLiteral || _la===ECMAScriptParser.NullLiteral || _la===ECMAScriptParser.BooleanLiteral || _la===ECMAScriptParser.StringLiteral)) {
            this._errHandler.recoverInline(this);
            }
            else {
                this.consume();
            }
            break;
        case ECMAScriptParser.DecimalLiteral:
        case ECMAScriptParser.HexIntegerLiteral:
        case ECMAScriptParser.OctalIntegerLiteral:
            this.enterOuterAlt(localctx, 2);
            this.state = 581;
            this.numericLiteral();
            break;
        default:
            throw new antlr4.error.NoViableAltException(this);
        }
    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function NumericLiteralContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_numericLiteral;
    return this;
}

NumericLiteralContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
NumericLiteralContext.prototype.constructor = NumericLiteralContext;

NumericLiteralContext.prototype.DecimalLiteral = function() {
    return this.getToken(ECMAScriptParser.DecimalLiteral, 0);
};

NumericLiteralContext.prototype.HexIntegerLiteral = function() {
    return this.getToken(ECMAScriptParser.HexIntegerLiteral, 0);
};

NumericLiteralContext.prototype.OctalIntegerLiteral = function() {
    return this.getToken(ECMAScriptParser.OctalIntegerLiteral, 0);
};

NumericLiteralContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterNumericLiteral(this);
	}
};

NumericLiteralContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitNumericLiteral(this);
	}
};




ECMAScriptParser.NumericLiteralContext = NumericLiteralContext;

ECMAScriptParser.prototype.numericLiteral = function() {

    var localctx = new NumericLiteralContext(this, this._ctx, this.state);
    this.enterRule(localctx, 92, ECMAScriptParser.RULE_numericLiteral);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 584;
        _la = this._input.LA(1);
        if(!(((((_la - 53)) & ~0x1f) == 0 && ((1 << (_la - 53)) & ((1 << (ECMAScriptParser.DecimalLiteral - 53)) | (1 << (ECMAScriptParser.HexIntegerLiteral - 53)) | (1 << (ECMAScriptParser.OctalIntegerLiteral - 53)))) !== 0))) {
        this._errHandler.recoverInline(this);
        }
        else {
            this.consume();
        }
    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function IdentifierNameContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_identifierName;
    return this;
}

IdentifierNameContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
IdentifierNameContext.prototype.constructor = IdentifierNameContext;

IdentifierNameContext.prototype.Identifier = function() {
    return this.getToken(ECMAScriptParser.Identifier, 0);
};

IdentifierNameContext.prototype.reservedWord = function() {
    return this.getTypedRuleContext(ReservedWordContext,0);
};

IdentifierNameContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterIdentifierName(this);
	}
};

IdentifierNameContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitIdentifierName(this);
	}
};




ECMAScriptParser.IdentifierNameContext = IdentifierNameContext;

ECMAScriptParser.prototype.identifierName = function() {

    var localctx = new IdentifierNameContext(this, this._ctx, this.state);
    this.enterRule(localctx, 94, ECMAScriptParser.RULE_identifierName);
    try {
        this.state = 588;
        switch(this._input.LA(1)) {
        case ECMAScriptParser.Identifier:
            this.enterOuterAlt(localctx, 1);
            this.state = 586;
            this.match(ECMAScriptParser.Identifier);
            break;
        case ECMAScriptParser.NullLiteral:
        case ECMAScriptParser.BooleanLiteral:
        case ECMAScriptParser.Break:
        case ECMAScriptParser.Do:
        case ECMAScriptParser.Instanceof:
        case ECMAScriptParser.Typeof:
        case ECMAScriptParser.Case:
        case ECMAScriptParser.Else:
        case ECMAScriptParser.New:
        case ECMAScriptParser.Var:
        case ECMAScriptParser.Catch:
        case ECMAScriptParser.Finally:
        case ECMAScriptParser.Return:
        case ECMAScriptParser.Void:
        case ECMAScriptParser.Continue:
        case ECMAScriptParser.For:
        case ECMAScriptParser.Switch:
        case ECMAScriptParser.While:
        case ECMAScriptParser.Debugger:
        case ECMAScriptParser.Function:
        case ECMAScriptParser.This:
        case ECMAScriptParser.With:
        case ECMAScriptParser.Default:
        case ECMAScriptParser.If:
        case ECMAScriptParser.Throw:
        case ECMAScriptParser.Delete:
        case ECMAScriptParser.In:
        case ECMAScriptParser.Try:
        case ECMAScriptParser.Class:
        case ECMAScriptParser.Enum:
        case ECMAScriptParser.Extends:
        case ECMAScriptParser.Super:
        case ECMAScriptParser.Const:
        case ECMAScriptParser.Export:
        case ECMAScriptParser.Import:
        case ECMAScriptParser.Implements:
        case ECMAScriptParser.Let:
        case ECMAScriptParser.Private:
        case ECMAScriptParser.Public:
        case ECMAScriptParser.Interface:
        case ECMAScriptParser.Package:
        case ECMAScriptParser.Protected:
        case ECMAScriptParser.Static:
        case ECMAScriptParser.Yield:
            this.enterOuterAlt(localctx, 2);
            this.state = 587;
            this.reservedWord();
            break;
        default:
            throw new antlr4.error.NoViableAltException(this);
        }
    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function ReservedWordContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_reservedWord;
    return this;
}

ReservedWordContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
ReservedWordContext.prototype.constructor = ReservedWordContext;

ReservedWordContext.prototype.keyword = function() {
    return this.getTypedRuleContext(KeywordContext,0);
};

ReservedWordContext.prototype.futureReservedWord = function() {
    return this.getTypedRuleContext(FutureReservedWordContext,0);
};

ReservedWordContext.prototype.NullLiteral = function() {
    return this.getToken(ECMAScriptParser.NullLiteral, 0);
};

ReservedWordContext.prototype.BooleanLiteral = function() {
    return this.getToken(ECMAScriptParser.BooleanLiteral, 0);
};

ReservedWordContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterReservedWord(this);
	}
};

ReservedWordContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitReservedWord(this);
	}
};




ECMAScriptParser.ReservedWordContext = ReservedWordContext;

ECMAScriptParser.prototype.reservedWord = function() {

    var localctx = new ReservedWordContext(this, this._ctx, this.state);
    this.enterRule(localctx, 96, ECMAScriptParser.RULE_reservedWord);
    var _la = 0; // Token type
    try {
        this.state = 593;
        switch(this._input.LA(1)) {
        case ECMAScriptParser.Break:
        case ECMAScriptParser.Do:
        case ECMAScriptParser.Instanceof:
        case ECMAScriptParser.Typeof:
        case ECMAScriptParser.Case:
        case ECMAScriptParser.Else:
        case ECMAScriptParser.New:
        case ECMAScriptParser.Var:
        case ECMAScriptParser.Catch:
        case ECMAScriptParser.Finally:
        case ECMAScriptParser.Return:
        case ECMAScriptParser.Void:
        case ECMAScriptParser.Continue:
        case ECMAScriptParser.For:
        case ECMAScriptParser.Switch:
        case ECMAScriptParser.While:
        case ECMAScriptParser.Debugger:
        case ECMAScriptParser.Function:
        case ECMAScriptParser.This:
        case ECMAScriptParser.With:
        case ECMAScriptParser.Default:
        case ECMAScriptParser.If:
        case ECMAScriptParser.Throw:
        case ECMAScriptParser.Delete:
        case ECMAScriptParser.In:
        case ECMAScriptParser.Try:
            this.enterOuterAlt(localctx, 1);
            this.state = 590;
            this.keyword();
            break;
        case ECMAScriptParser.Class:
        case ECMAScriptParser.Enum:
        case ECMAScriptParser.Extends:
        case ECMAScriptParser.Super:
        case ECMAScriptParser.Const:
        case ECMAScriptParser.Export:
        case ECMAScriptParser.Import:
        case ECMAScriptParser.Implements:
        case ECMAScriptParser.Let:
        case ECMAScriptParser.Private:
        case ECMAScriptParser.Public:
        case ECMAScriptParser.Interface:
        case ECMAScriptParser.Package:
        case ECMAScriptParser.Protected:
        case ECMAScriptParser.Static:
        case ECMAScriptParser.Yield:
            this.enterOuterAlt(localctx, 2);
            this.state = 591;
            this.futureReservedWord();
            break;
        case ECMAScriptParser.NullLiteral:
        case ECMAScriptParser.BooleanLiteral:
            this.enterOuterAlt(localctx, 3);
            this.state = 592;
            _la = this._input.LA(1);
            if(!(_la===ECMAScriptParser.NullLiteral || _la===ECMAScriptParser.BooleanLiteral)) {
            this._errHandler.recoverInline(this);
            }
            else {
                this.consume();
            }
            break;
        default:
            throw new antlr4.error.NoViableAltException(this);
        }
    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function KeywordContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_keyword;
    return this;
}

KeywordContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
KeywordContext.prototype.constructor = KeywordContext;

KeywordContext.prototype.Break = function() {
    return this.getToken(ECMAScriptParser.Break, 0);
};

KeywordContext.prototype.Do = function() {
    return this.getToken(ECMAScriptParser.Do, 0);
};

KeywordContext.prototype.Instanceof = function() {
    return this.getToken(ECMAScriptParser.Instanceof, 0);
};

KeywordContext.prototype.Typeof = function() {
    return this.getToken(ECMAScriptParser.Typeof, 0);
};

KeywordContext.prototype.Case = function() {
    return this.getToken(ECMAScriptParser.Case, 0);
};

KeywordContext.prototype.Else = function() {
    return this.getToken(ECMAScriptParser.Else, 0);
};

KeywordContext.prototype.New = function() {
    return this.getToken(ECMAScriptParser.New, 0);
};

KeywordContext.prototype.Var = function() {
    return this.getToken(ECMAScriptParser.Var, 0);
};

KeywordContext.prototype.Catch = function() {
    return this.getToken(ECMAScriptParser.Catch, 0);
};

KeywordContext.prototype.Finally = function() {
    return this.getToken(ECMAScriptParser.Finally, 0);
};

KeywordContext.prototype.Return = function() {
    return this.getToken(ECMAScriptParser.Return, 0);
};

KeywordContext.prototype.Void = function() {
    return this.getToken(ECMAScriptParser.Void, 0);
};

KeywordContext.prototype.Continue = function() {
    return this.getToken(ECMAScriptParser.Continue, 0);
};

KeywordContext.prototype.For = function() {
    return this.getToken(ECMAScriptParser.For, 0);
};

KeywordContext.prototype.Switch = function() {
    return this.getToken(ECMAScriptParser.Switch, 0);
};

KeywordContext.prototype.While = function() {
    return this.getToken(ECMAScriptParser.While, 0);
};

KeywordContext.prototype.Debugger = function() {
    return this.getToken(ECMAScriptParser.Debugger, 0);
};

KeywordContext.prototype.Function = function() {
    return this.getToken(ECMAScriptParser.Function, 0);
};

KeywordContext.prototype.This = function() {
    return this.getToken(ECMAScriptParser.This, 0);
};

KeywordContext.prototype.With = function() {
    return this.getToken(ECMAScriptParser.With, 0);
};

KeywordContext.prototype.Default = function() {
    return this.getToken(ECMAScriptParser.Default, 0);
};

KeywordContext.prototype.If = function() {
    return this.getToken(ECMAScriptParser.If, 0);
};

KeywordContext.prototype.Throw = function() {
    return this.getToken(ECMAScriptParser.Throw, 0);
};

KeywordContext.prototype.Delete = function() {
    return this.getToken(ECMAScriptParser.Delete, 0);
};

KeywordContext.prototype.In = function() {
    return this.getToken(ECMAScriptParser.In, 0);
};

KeywordContext.prototype.Try = function() {
    return this.getToken(ECMAScriptParser.Try, 0);
};

KeywordContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterKeyword(this);
	}
};

KeywordContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitKeyword(this);
	}
};




ECMAScriptParser.KeywordContext = KeywordContext;

ECMAScriptParser.prototype.keyword = function() {

    var localctx = new KeywordContext(this, this._ctx, this.state);
    this.enterRule(localctx, 98, ECMAScriptParser.RULE_keyword);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 595;
        _la = this._input.LA(1);
        if(!(((((_la - 56)) & ~0x1f) == 0 && ((1 << (_la - 56)) & ((1 << (ECMAScriptParser.Break - 56)) | (1 << (ECMAScriptParser.Do - 56)) | (1 << (ECMAScriptParser.Instanceof - 56)) | (1 << (ECMAScriptParser.Typeof - 56)) | (1 << (ECMAScriptParser.Case - 56)) | (1 << (ECMAScriptParser.Else - 56)) | (1 << (ECMAScriptParser.New - 56)) | (1 << (ECMAScriptParser.Var - 56)) | (1 << (ECMAScriptParser.Catch - 56)) | (1 << (ECMAScriptParser.Finally - 56)) | (1 << (ECMAScriptParser.Return - 56)) | (1 << (ECMAScriptParser.Void - 56)) | (1 << (ECMAScriptParser.Continue - 56)) | (1 << (ECMAScriptParser.For - 56)) | (1 << (ECMAScriptParser.Switch - 56)) | (1 << (ECMAScriptParser.While - 56)) | (1 << (ECMAScriptParser.Debugger - 56)) | (1 << (ECMAScriptParser.Function - 56)) | (1 << (ECMAScriptParser.This - 56)) | (1 << (ECMAScriptParser.With - 56)) | (1 << (ECMAScriptParser.Default - 56)) | (1 << (ECMAScriptParser.If - 56)) | (1 << (ECMAScriptParser.Throw - 56)) | (1 << (ECMAScriptParser.Delete - 56)) | (1 << (ECMAScriptParser.In - 56)) | (1 << (ECMAScriptParser.Try - 56)))) !== 0))) {
        this._errHandler.recoverInline(this);
        }
        else {
            this.consume();
        }
    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function FutureReservedWordContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_futureReservedWord;
    return this;
}

FutureReservedWordContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
FutureReservedWordContext.prototype.constructor = FutureReservedWordContext;

FutureReservedWordContext.prototype.Class = function() {
    return this.getToken(ECMAScriptParser.Class, 0);
};

FutureReservedWordContext.prototype.Enum = function() {
    return this.getToken(ECMAScriptParser.Enum, 0);
};

FutureReservedWordContext.prototype.Extends = function() {
    return this.getToken(ECMAScriptParser.Extends, 0);
};

FutureReservedWordContext.prototype.Super = function() {
    return this.getToken(ECMAScriptParser.Super, 0);
};

FutureReservedWordContext.prototype.Const = function() {
    return this.getToken(ECMAScriptParser.Const, 0);
};

FutureReservedWordContext.prototype.Export = function() {
    return this.getToken(ECMAScriptParser.Export, 0);
};

FutureReservedWordContext.prototype.Import = function() {
    return this.getToken(ECMAScriptParser.Import, 0);
};

FutureReservedWordContext.prototype.Implements = function() {
    return this.getToken(ECMAScriptParser.Implements, 0);
};

FutureReservedWordContext.prototype.Let = function() {
    return this.getToken(ECMAScriptParser.Let, 0);
};

FutureReservedWordContext.prototype.Private = function() {
    return this.getToken(ECMAScriptParser.Private, 0);
};

FutureReservedWordContext.prototype.Public = function() {
    return this.getToken(ECMAScriptParser.Public, 0);
};

FutureReservedWordContext.prototype.Interface = function() {
    return this.getToken(ECMAScriptParser.Interface, 0);
};

FutureReservedWordContext.prototype.Package = function() {
    return this.getToken(ECMAScriptParser.Package, 0);
};

FutureReservedWordContext.prototype.Protected = function() {
    return this.getToken(ECMAScriptParser.Protected, 0);
};

FutureReservedWordContext.prototype.Static = function() {
    return this.getToken(ECMAScriptParser.Static, 0);
};

FutureReservedWordContext.prototype.Yield = function() {
    return this.getToken(ECMAScriptParser.Yield, 0);
};

FutureReservedWordContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterFutureReservedWord(this);
	}
};

FutureReservedWordContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitFutureReservedWord(this);
	}
};




ECMAScriptParser.FutureReservedWordContext = FutureReservedWordContext;

ECMAScriptParser.prototype.futureReservedWord = function() {

    var localctx = new FutureReservedWordContext(this, this._ctx, this.state);
    this.enterRule(localctx, 100, ECMAScriptParser.RULE_futureReservedWord);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 597;
        _la = this._input.LA(1);
        if(!(((((_la - 82)) & ~0x1f) == 0 && ((1 << (_la - 82)) & ((1 << (ECMAScriptParser.Class - 82)) | (1 << (ECMAScriptParser.Enum - 82)) | (1 << (ECMAScriptParser.Extends - 82)) | (1 << (ECMAScriptParser.Super - 82)) | (1 << (ECMAScriptParser.Const - 82)) | (1 << (ECMAScriptParser.Export - 82)) | (1 << (ECMAScriptParser.Import - 82)) | (1 << (ECMAScriptParser.Implements - 82)) | (1 << (ECMAScriptParser.Let - 82)) | (1 << (ECMAScriptParser.Private - 82)) | (1 << (ECMAScriptParser.Public - 82)) | (1 << (ECMAScriptParser.Interface - 82)) | (1 << (ECMAScriptParser.Package - 82)) | (1 << (ECMAScriptParser.Protected - 82)) | (1 << (ECMAScriptParser.Static - 82)) | (1 << (ECMAScriptParser.Yield - 82)))) !== 0))) {
        this._errHandler.recoverInline(this);
        }
        else {
            this.consume();
        }
    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function GetterContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_getter;
    return this;
}

GetterContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
GetterContext.prototype.constructor = GetterContext;

GetterContext.prototype.Identifier = function() {
    return this.getToken(ECMAScriptParser.Identifier, 0);
};

GetterContext.prototype.propertyName = function() {
    return this.getTypedRuleContext(PropertyNameContext,0);
};

GetterContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterGetter(this);
	}
};

GetterContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitGetter(this);
	}
};




ECMAScriptParser.GetterContext = GetterContext;

ECMAScriptParser.prototype.getter = function() {

    var localctx = new GetterContext(this, this._ctx, this.state);
    this.enterRule(localctx, 102, ECMAScriptParser.RULE_getter);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 599;
        if (!( this._input.LT(1).text.startsWith("get"))) {
            throw new antlr4.error.FailedPredicateException(this, "this._input.LT(1).text.startsWith(\"get\")");
        }
        this.state = 600;
        this.match(ECMAScriptParser.Identifier);
        this.state = 601;
        this.propertyName();
    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function SetterContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_setter;
    return this;
}

SetterContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
SetterContext.prototype.constructor = SetterContext;

SetterContext.prototype.Identifier = function() {
    return this.getToken(ECMAScriptParser.Identifier, 0);
};

SetterContext.prototype.propertyName = function() {
    return this.getTypedRuleContext(PropertyNameContext,0);
};

SetterContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterSetter(this);
	}
};

SetterContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitSetter(this);
	}
};




ECMAScriptParser.SetterContext = SetterContext;

ECMAScriptParser.prototype.setter = function() {

    var localctx = new SetterContext(this, this._ctx, this.state);
    this.enterRule(localctx, 104, ECMAScriptParser.RULE_setter);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 603;
        if (!( this._input.LT(1).text.startsWith("set"))) {
            throw new antlr4.error.FailedPredicateException(this, "this._input.LT(1).text.startsWith(\"set\")");
        }
        this.state = 604;
        this.match(ECMAScriptParser.Identifier);
        this.state = 605;
        this.propertyName();
    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function EosContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_eos;
    return this;
}

EosContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
EosContext.prototype.constructor = EosContext;

EosContext.prototype.SemiColon = function() {
    return this.getToken(ECMAScriptParser.SemiColon, 0);
};

EosContext.prototype.EOF = function() {
    return this.getToken(ECMAScriptParser.EOF, 0);
};

EosContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterEos(this);
	}
};

EosContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitEos(this);
	}
};




ECMAScriptParser.EosContext = EosContext;

ECMAScriptParser.prototype.eos = function() {

    var localctx = new EosContext(this, this._ctx, this.state);
    this.enterRule(localctx, 106, ECMAScriptParser.RULE_eos);
    try {
        this.state = 611;
        var la_ = this._interp.adaptivePredict(this._input,52,this._ctx);
        switch(la_) {
        case 1:
            this.enterOuterAlt(localctx, 1);
            this.state = 607;
            this.match(ECMAScriptParser.SemiColon);
            break;

        case 2:
            this.enterOuterAlt(localctx, 2);
            this.state = 608;
            this.match(ECMAScriptParser.EOF);
            break;

        case 3:
            this.enterOuterAlt(localctx, 3);
            this.state = 609;
            if (!( this.lineTerminatorAhead())) {
                throw new antlr4.error.FailedPredicateException(this, "this.lineTerminatorAhead()");
            }
            break;

        case 4:
            this.enterOuterAlt(localctx, 4);
            this.state = 610;
            if (!( this._input.LT(1).type == ECMAScriptParser.CloseBrace)) {
                throw new antlr4.error.FailedPredicateException(this, "this._input.LT(1).type == ECMAScriptParser.CloseBrace");
            }
            break;

        }
    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};

function EofContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = ECMAScriptParser.RULE_eof;
    return this;
}

EofContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
EofContext.prototype.constructor = EofContext;

EofContext.prototype.EOF = function() {
    return this.getToken(ECMAScriptParser.EOF, 0);
};

EofContext.prototype.enterRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.enterEof(this);
	}
};

EofContext.prototype.exitRule = function(listener) {
    if(listener instanceof ECMAScriptListener ) {
        listener.exitEof(this);
	}
};




ECMAScriptParser.EofContext = EofContext;

ECMAScriptParser.prototype.eof = function() {

    var localctx = new EofContext(this, this._ctx, this.state);
    this.enterRule(localctx, 108, ECMAScriptParser.RULE_eof);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 613;
        this.match(ECMAScriptParser.EOF);
    } catch (re) {
    	if(re instanceof antlr4.error.RecognitionException) {
	        localctx.exception = re;
	        this._errHandler.reportError(this, re);
	        this._errHandler.recover(this, re);
	    } else {
	    	throw re;
	    }
    } finally {
        this.exitRule();
    }
    return localctx;
};


ECMAScriptParser.prototype.sempred = function(localctx, ruleIndex, predIndex) {
	switch(ruleIndex) {
	case 43:
			return this.singleExpression_sempred(localctx, predIndex);
	case 51:
			return this.getter_sempred(localctx, predIndex);
	case 52:
			return this.setter_sempred(localctx, predIndex);
	case 53:
			return this.eos_sempred(localctx, predIndex);
    default:
        throw "No predicate with index:" + ruleIndex;
   }
};

ECMAScriptParser.prototype.singleExpression_sempred = function(localctx, predIndex) {
	switch(predIndex) {
		case 0:
			return this.precpred(this._ctx, 21);
		case 1:
			return this.precpred(this._ctx, 20);
		case 2:
			return this.precpred(this._ctx, 19);
		case 3:
			return this.precpred(this._ctx, 18);
		case 4:
			return this.precpred(this._ctx, 17);
		case 5:
			return this.precpred(this._ctx, 16);
		case 6:
			return this.precpred(this._ctx, 15);
		case 7:
			return this.precpred(this._ctx, 14);
		case 8:
			return this.precpred(this._ctx, 13);
		case 9:
			return this.precpred(this._ctx, 12);
		case 10:
			return this.precpred(this._ctx, 11);
		case 11:
			return this.precpred(this._ctx, 10);
		case 12:
			return this.precpred(this._ctx, 9);
		case 13:
			return this.precpred(this._ctx, 36);
		case 14:
			return this.precpred(this._ctx, 35);
		case 15:
			return this.precpred(this._ctx, 34);
		case 16:
			return this.precpred(this._ctx, 32);
		case 17:
			return !this.here(ECMAScriptParser.LineTerminator);
		case 18:
			return this.precpred(this._ctx, 31);
		case 19:
			return !this.here(ECMAScriptParser.LineTerminator);
		case 20:
			return this.precpred(this._ctx, 8);
		case 21:
			return this.precpred(this._ctx, 7);
		default:
			throw "No predicate with index:" + predIndex;
	}
};

ECMAScriptParser.prototype.getter_sempred = function(localctx, predIndex) {
	switch(predIndex) {
		case 22:
			return this._input.LT(1).text.startsWith("get");
		default:
			throw "No predicate with index:" + predIndex;
	}
};

ECMAScriptParser.prototype.setter_sempred = function(localctx, predIndex) {
	switch(predIndex) {
		case 23:
			return this._input.LT(1).text.startsWith("set");
		default:
			throw "No predicate with index:" + predIndex;
	}
};

ECMAScriptParser.prototype.eos_sempred = function(localctx, predIndex) {
	switch(predIndex) {
		case 24:
			return this.lineTerminatorAhead();
		case 25:
			return this._input.LT(1).type == ECMAScriptParser.CloseBrace;
		default:
			throw "No predicate with index:" + predIndex;
	}
};


exports.ECMAScriptParser = ECMAScriptParser;
