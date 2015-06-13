// Generated from jvmBasic.g4 by ANTLR 4.5
// jshint ignore: start
var antlr4 = require('antlr4/index');
var jvmBasicListener = require('./jvmBasicListener').jvmBasicListener;
var grammarFileName = "jvmBasic.g4";

var serializedATN = ["\3\u0430\ud6d1\u8206\uad2d\u4417\uaef1\u8d80\uaadd",
    "\3}\u035c\4\2\t\2\4\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4",
    "\t\t\t\4\n\t\n\4\13\t\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t",
    "\20\4\21\t\21\4\22\t\22\4\23\t\23\4\24\t\24\4\25\t\25\4\26\t\26\4\27",
    "\t\27\4\30\t\30\4\31\t\31\4\32\t\32\4\33\t\33\4\34\t\34\4\35\t\35\4",
    "\36\t\36\4\37\t\37\4 \t \4!\t!\4\"\t\"\4#\t#\4$\t$\4%\t%\4&\t&\4\'\t",
    "\'\4(\t(\4)\t)\4*\t*\4+\t+\4,\t,\4-\t-\4.\t.\4/\t/\4\60\t\60\4\61\t",
    "\61\4\62\t\62\4\63\t\63\4\64\t\64\4\65\t\65\4\66\t\66\4\67\t\67\48\t",
    "8\49\t9\4:\t:\4;\t;\4<\t<\4=\t=\4>\t>\4?\t?\4@\t@\4A\tA\4B\tB\4C\tC",
    "\4D\tD\4E\tE\4F\tF\4G\tG\4H\tH\4I\tI\4J\tJ\4K\tK\4L\tL\4M\tM\4N\tN\4",
    "O\tO\4P\tP\4Q\tQ\4R\tR\4S\tS\4T\tT\4U\tU\4V\tV\4W\tW\4X\tX\4Y\tY\4Z",
    "\tZ\4[\t[\4\\\t\\\4]\t]\4^\t^\4_\t_\4`\t`\4a\ta\4b\tb\4c\tc\4d\td\3",
    "\2\6\2\u00ca\n\2\r\2\16\2\u00cb\3\3\3\3\3\3\3\3\5\3\u00d2\n\3\7\3\u00d4",
    "\n\3\f\3\16\3\u00d7\13\3\3\3\5\3\u00da\n\3\3\3\3\3\3\3\5\3\u00df\n\3",
    "\3\4\3\4\3\5\3\5\3\6\5\6\u00e6\n\6\3\6\3\6\5\6\u00ea\n\6\3\7\3\7\3\7",
    "\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7",
    "\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7",
    "\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\5\7\u011b\n\7\3\b\3\b\3\b\3",
    "\b\3\b\7\b\u0122\n\b\f\b\16\b\u0125\13\b\3\t\3\t\5\t\u0129\n\t\3\n\3",
    "\n\5\n\u012d\n\n\3\n\7\n\u0130\n\n\f\n\16\n\u0133\13\n\3\13\3\13\3\13",
    "\3\f\5\f\u0139\n\f\3\f\3\f\3\r\3\r\3\r\3\r\3\16\3\16\3\16\3\16\5\16",
    "\u0145\n\16\3\17\3\17\3\17\3\17\3\17\5\17\u014c\n\17\3\20\3\20\3\20",
    "\3\20\3\20\5\20\u0153\n\20\3\21\3\21\3\22\3\22\3\22\5\22\u015a\n\22",
    "\3\22\3\22\5\22\u015e\n\22\3\23\3\23\3\23\3\23\3\23\3\23\3\23\3\23\5",
    "\23\u0168\n\23\3\23\3\23\3\23\5\23\u016d\n\23\3\24\3\24\3\24\5\24\u0172",
    "\n\24\3\24\3\24\3\25\3\25\3\25\3\26\3\26\3\26\3\27\3\27\3\27\3\30\3",
    "\30\3\30\3\31\3\31\3\31\3\31\3\31\3\32\3\32\3\32\3\33\3\33\3\33\3\33",
    "\3\33\5\33\u018f\n\33\3\33\3\33\3\33\3\33\3\33\7\33\u0196\n\33\f\33",
    "\16\33\u0199\13\33\3\34\3\34\3\34\3\34\3\34\5\34\u01a0\n\34\3\34\3\34",
    "\3\34\3\34\3\34\7\34\u01a7\n\34\f\34\16\34\u01aa\13\34\3\35\3\35\3\35",
    "\3\35\3\35\3\36\3\36\3\36\3\36\3\36\3\36\7\36\u01b7\n\36\f\36\16\36",
    "\u01ba\13\36\3\37\3\37\3\37\3\37\3\37\3\37\7\37\u01c2\n\37\f\37\16\37",
    "\u01c5\13\37\3 \3 \3 \3!\3!\3!\3\"\3\"\3\"\3\"\3#\3#\3#\3#\3$\3$\3$",
    "\3$\5$\u01d9\n$\7$\u01db\n$\f$\16$\u01de\13$\3%\3%\3&\3&\3&\3&\3&\3",
    "&\5&\u01e8\n&\3\'\3\'\3\'\3\'\3\'\3\'\3\'\5\'\u01f1\n\'\3(\3(\3(\3(",
    "\3(\3(\3(\5(\u01fa\n(\3)\3)\3)\3)\3)\3)\3)\3)\3)\3*\3*\3*\3*\3*\3+\3",
    "+\3+\3+\3,\3,\3,\3,\3-\3-\3-\3-\3.\3.\3.\3.\3/\3/\3/\3/\3\60\3\60\3",
    "\60\3\60\3\60\3\60\3\60\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\62\3\62",
    "\3\62\3\62\3\63\3\63\3\63\3\64\3\64\3\64\3\65\3\65\3\65\3\66\3\66\3",
    "\66\3\67\3\67\5\67\u023e\n\67\38\38\38\38\38\58\u0245\n8\39\39\39\3",
    ":\3:\3:\3;\3;\3<\3<\3=\3=\3>\3>\3>\3>\3>\3>\3>\3>\3>\3>\3>\3>\3>\3>",
    "\3>\3>\3>\3>\3>\3>\3>\3>\3>\3>\3>\3>\3>\3>\3>\3>\3>\3>\3>\5>\u0274\n",
    ">\3?\5?\u0277\n?\3?\7?\u027a\n?\f?\16?\u027d\13?\3?\3?\3@\3@\3@\7@\u0284",
    "\n@\f@\16@\u0287\13@\3A\3A\3A\7A\u028c\nA\fA\16A\u028f\13A\3B\3B\3B",
    "\7B\u0294\nB\fB\16B\u0297\13B\3C\3C\3C\3C\7C\u029d\nC\fC\16C\u02a0\13",
    "C\3D\3D\3D\3D\7D\u02a6\nD\fD\16D\u02a9\13D\5D\u02ab\nD\3E\3E\5E\u02af",
    "\nE\3F\3F\7F\u02b3\nF\fF\16F\u02b6\13F\3G\3G\3H\3H\3H\7H\u02bd\nH\f",
    "H\16H\u02c0\13H\3I\3I\3I\7I\u02c5\nI\fI\16I\u02c8\13I\3J\3J\3J\3J\3",
    "J\3K\3K\3K\3K\3K\3L\3L\3L\3L\3L\3M\3M\3M\3M\3M\3N\3N\3N\3N\3N\3N\3N",
    "\3N\3N\3O\3O\3O\3O\3O\3P\3P\3P\3P\3P\3Q\3Q\3Q\3Q\3Q\3R\3R\3R\3R\3R\3",
    "S\3S\3S\3S\3S\3T\3T\3T\3T\3T\3U\3U\3U\3U\3U\3V\3V\3V\3V\3V\3V\3V\3W",
    "\3W\3W\3W\3W\3W\3W\3X\3X\3X\3X\3X\3Y\3Y\3Y\3Y\3Y\3Y\3Z\3Z\3Z\3Z\3Z\3",
    "[\3[\3[\3[\3[\3[\3[\3\\\3\\\3\\\3\\\3\\\3]\3]\3]\3]\3]\3^\3^\3^\3^\3",
    "^\3_\3_\3_\3_\3_\3`\3`\3`\3`\3`\3a\3a\3a\3a\3a\3b\3b\3b\3b\3b\3c\3c",
    "\3c\3c\3c\3d\3d\3d\3d\3d\3d\2\2e\2\4\6\b\n\f\16\20\22\24\26\30\32\34",
    "\36 \"$&(*,.\60\62\64\668:<>@BDFHJLNPRTVXZ\\^`bdfhjlnprtvxz|~\u0080",
    "\u0082\u0084\u0086\u0088\u008a\u008c\u008e\u0090\u0092\u0094\u0096\u0098",
    "\u009a\u009c\u009e\u00a0\u00a2\u00a4\u00a6\u00a8\u00aa\u00ac\u00ae\u00b0",
    "\u00b2\u00b4\u00b6\u00b8\u00ba\u00bc\u00be\u00c0\u00c2\u00c4\u00c6\2",
    "\16\4\2\f\fww\3\3||\f\2\30\30  ,.88??BDJKaappst\4\2\6\6uu\4\2\36\36",
    "((\4\2\33\34##\4\2xxz{\3\2\24\25\3\2\26\27\3\2LM\3\2yz\3\2\3\4\u0374",
    "\2\u00c9\3\2\2\2\4\u00de\3\2\2\2\6\u00e0\3\2\2\2\b\u00e2\3\2\2\2\n\u00e9",
    "\3\2\2\2\f\u011a\3\2\2\2\16\u011c\3\2\2\2\20\u0126\3\2\2\2\22\u012a",
    "\3\2\2\2\24\u0134\3\2\2\2\26\u0138\3\2\2\2\30\u013c\3\2\2\2\32\u0144",
    "\3\2\2\2\34\u014b\3\2\2\2\36\u0152\3\2\2\2 \u0154\3\2\2\2\"\u0156\3",
    "\2\2\2$\u015f\3\2\2\2&\u016e\3\2\2\2(\u0175\3\2\2\2*\u0178\3\2\2\2,",
    "\u017b\3\2\2\2.\u017e\3\2\2\2\60\u0181\3\2\2\2\62\u0186\3\2\2\2\64\u0189",
    "\3\2\2\2\66\u019a\3\2\2\28\u01ab\3\2\2\2:\u01b0\3\2\2\2<\u01bb\3\2\2",
    "\2>\u01c6\3\2\2\2@\u01c9\3\2\2\2B\u01cc\3\2\2\2D\u01d0\3\2\2\2F\u01d4",
    "\3\2\2\2H\u01df\3\2\2\2J\u01e1\3\2\2\2L\u01e9\3\2\2\2N\u01f2\3\2\2\2",
    "P\u01fb\3\2\2\2R\u0204\3\2\2\2T\u0209\3\2\2\2V\u020d\3\2\2\2X\u0211",
    "\3\2\2\2Z\u0215\3\2\2\2\\\u0219\3\2\2\2^\u021d\3\2\2\2`\u0224\3\2\2",
    "\2b\u022b\3\2\2\2d\u022f\3\2\2\2f\u0232\3\2\2\2h\u0235\3\2\2\2j\u0238",
    "\3\2\2\2l\u023b\3\2\2\2n\u023f\3\2\2\2p\u0246\3\2\2\2r\u0249\3\2\2\2",
    "t\u024c\3\2\2\2v\u024e\3\2\2\2x\u0250\3\2\2\2z\u0273\3\2\2\2|\u0276",
    "\3\2\2\2~\u0280\3\2\2\2\u0080\u0288\3\2\2\2\u0082\u0290\3\2\2\2\u0084",
    "\u0298\3\2\2\2\u0086\u02aa\3\2\2\2\u0088\u02ac\3\2\2\2\u008a\u02b0\3",
    "\2\2\2\u008c\u02b7\3\2\2\2\u008e\u02b9\3\2\2\2\u0090\u02c1\3\2\2\2\u0092",
    "\u02c9\3\2\2\2\u0094\u02ce\3\2\2\2\u0096\u02d3\3\2\2\2\u0098\u02d8\3",
    "\2\2\2\u009a\u02dd\3\2\2\2\u009c\u02e6\3\2\2\2\u009e\u02eb\3\2\2\2\u00a0",
    "\u02f0\3\2\2\2\u00a2\u02f5\3\2\2\2\u00a4\u02fa\3\2\2\2\u00a6\u02ff\3",
    "\2\2\2\u00a8\u0304\3\2\2\2\u00aa\u0309\3\2\2\2\u00ac\u0310\3\2\2\2\u00ae",
    "\u0317\3\2\2\2\u00b0\u031c\3\2\2\2\u00b2\u0322\3\2\2\2\u00b4\u0327\3",
    "\2\2\2\u00b6\u032e\3\2\2\2\u00b8\u0333\3\2\2\2\u00ba\u0338\3\2\2\2\u00bc",
    "\u033d\3\2\2\2\u00be\u0342\3\2\2\2\u00c0\u0347\3\2\2\2\u00c2\u034c\3",
    "\2\2\2\u00c4\u0351\3\2\2\2\u00c6\u0356\3\2\2\2\u00c8\u00ca\5\4\3\2\u00c9",
    "\u00c8\3\2\2\2\u00ca\u00cb\3\2\2\2\u00cb\u00c9\3\2\2\2\u00cb\u00cc\3",
    "\2\2\2\u00cc\3\3\2\2\2\u00cd\u00d9\5\b\5\2\u00ce\u00d5\5\n\6\2\u00cf",
    "\u00d1\7+\2\2\u00d0\u00d2\5\n\6\2\u00d1\u00d0\3\2\2\2\u00d1\u00d2\3",
    "\2\2\2\u00d2\u00d4\3\2\2\2\u00d3\u00cf\3\2\2\2\u00d4\u00d7\3\2\2\2\u00d5",
    "\u00d3\3\2\2\2\u00d5\u00d6\3\2\2\2\u00d6\u00da\3\2\2\2\u00d7\u00d5\3",
    "\2\2\2\u00d8\u00da\t\2\2\2\u00d9\u00ce\3\2\2\2\u00d9\u00d8\3\2\2\2\u00da",
    "\u00db\3\2\2\2\u00db\u00dc\t\3\2\2\u00dc\u00df\3\2\2\2\u00dd\u00df\7",
    "|\2\2\u00de\u00cd\3\2\2\2\u00de\u00dd\3\2\2\2\u00df\5\3\2\2\2\u00e0",
    "\u00e1\7o\2\2\u00e1\7\3\2\2\2\u00e2\u00e3\7z\2\2\u00e3\t\3\2\2\2\u00e4",
    "\u00e6\5\6\4\2\u00e5\u00e4\3\2\2\2\u00e5\u00e6\3\2\2\2\u00e6\u00e7\3",
    "\2\2\2\u00e7\u00ea\5\f\7\2\u00e8\u00ea\t\2\2\2\u00e9\u00e5\3\2\2\2\u00e9",
    "\u00e8\3\2\2\2\u00ea\13\3\2\2\2\u00eb\u011b\t\4\2\2\u00ec\u011b\5t;",
    "\2\u00ed\u011b\5v<\2\u00ee\u011b\5x=\2\u00ef\u011b\5p9\2\u00f0\u011b",
    "\5n8\2\u00f1\u011b\5l\67\2\u00f2\u011b\5h\65\2\u00f3\u011b\5\24\13\2",
    "\u00f4\u011b\5j\66\2\u00f5\u011b\5f\64\2\u00f6\u011b\5d\63\2\u00f7\u011b",
    "\5b\62\2\u00f8\u011b\5^\60\2\u00f9\u011b\5`\61\2\u00fa\u011b\5Z.\2\u00fb",
    "\u011b\5T+\2\u00fc\u011b\5X-\2\u00fd\u011b\5V,\2\u00fe\u011b\5\\/\2",
    "\u00ff\u011b\5B\"\2\u0100\u011b\5D#\2\u0101\u011b\5\20\t\2\u0102\u011b",
    "\5\60\31\2\u0103\u011b\58\35\2\u0104\u011b\5:\36\2\u0105\u011b\5<\37",
    "\2\u0106\u011b\5\"\22\2\u0107\u011b\5$\23\2\u0108\u011b\5&\24\2\u0109",
    "\u011b\5R*\2\u010a\u011b\5*\26\2\u010b\u011b\5,\27\2\u010c\u011b\5.",
    "\30\2\u010d\u011b\5\62\32\2\u010e\u011b\5(\25\2\u010f\u011b\5\64\33",
    "\2\u0110\u011b\5\66\34\2\u0111\u011b\5> \2\u0112\u011b\5@!\2\u0113\u011b",
    "\5J&\2\u0114\u011b\5F$\2\u0115\u011b\5L\'\2\u0116\u011b\5N(\2\u0117",
    "\u011b\5P)\2\u0118\u011b\5\26\f\2\u0119\u011b\5r:\2\u011a\u00eb\3\2",
    "\2\2\u011a\u00ec\3\2\2\2\u011a\u00ed\3\2\2\2\u011a\u00ee\3\2\2\2\u011a",
    "\u00ef\3\2\2\2\u011a\u00f0\3\2\2\2\u011a\u00f1\3\2\2\2\u011a\u00f2\3",
    "\2\2\2\u011a\u00f3\3\2\2\2\u011a\u00f4\3\2\2\2\u011a\u00f5\3\2\2\2\u011a",
    "\u00f6\3\2\2\2\u011a\u00f7\3\2\2\2\u011a\u00f8\3\2\2\2\u011a\u00f9\3",
    "\2\2\2\u011a\u00fa\3\2\2\2\u011a\u00fb\3\2\2\2\u011a\u00fc\3\2\2\2\u011a",
    "\u00fd\3\2\2\2\u011a\u00fe\3\2\2\2\u011a\u00ff\3\2\2\2\u011a\u0100\3",
    "\2\2\2\u011a\u0101\3\2\2\2\u011a\u0102\3\2\2\2\u011a\u0103\3\2\2\2\u011a",
    "\u0104\3\2\2\2\u011a\u0105\3\2\2\2\u011a\u0106\3\2\2\2\u011a\u0107\3",
    "\2\2\2\u011a\u0108\3\2\2\2\u011a\u0109\3\2\2\2\u011a\u010a\3\2\2\2\u011a",
    "\u010b\3\2\2\2\u011a\u010c\3\2\2\2\u011a\u010d\3\2\2\2\u011a\u010e\3",
    "\2\2\2\u011a\u010f\3\2\2\2\u011a\u0110\3\2\2\2\u011a\u0111\3\2\2\2\u011a",
    "\u0112\3\2\2\2\u011a\u0113\3\2\2\2\u011a\u0114\3\2\2\2\u011a\u0115\3",
    "\2\2\2\u011a\u0116\3\2\2\2\u011a\u0117\3\2\2\2\u011a\u0118\3\2\2\2\u011a",
    "\u0119\3\2\2\2\u011b\r\3\2\2\2\u011c\u0123\5\u0088E\2\u011d\u011e\7",
    "\22\2\2\u011e\u011f\5\u0090I\2\u011f\u0120\7\23\2\2\u0120\u0122\3\2",
    "\2\2\u0121\u011d\3\2\2\2\u0122\u0125\3\2\2\2\u0123\u0121\3\2\2\2\u0123",
    "\u0124\3\2\2\2\u0124\17\3\2\2\2\u0125\u0123\3\2\2\2\u0126\u0128\t\5",
    "\2\2\u0127\u0129\5\22\n\2\u0128\u0127\3\2\2\2\u0128\u0129\3\2\2\2\u0129",
    "\21\3\2\2\2\u012a\u012c\5\u0086D\2\u012b\u012d\t\6\2\2\u012c\u012b\3",
    "\2\2\2\u012c\u012d\3\2\2\2\u012d\u0131\3\2\2\2\u012e\u0130\5\22\n\2",
    "\u012f\u012e\3\2\2\2\u0130\u0133\3\2\2\2\u0131\u012f\3\2\2\2\u0131\u0132",
    "\3\2\2\2\u0132\23\3\2\2\2\u0133\u0131\3\2\2\2\u0134\u0135\7m\2\2\u0135",
    "\u0136\5\u0090I\2\u0136\25\3\2\2\2\u0137\u0139\7\"\2\2\u0138\u0137\3",
    "\2\2\2\u0138\u0139\3\2\2\2\u0139\u013a\3\2\2\2\u013a\u013b\5\30\r\2",
    "\u013b\27\3\2\2\2\u013c\u013d\5\16\b\2\u013d\u013e\7#\2\2\u013e\u013f",
    "\5\u0090I\2\u013f\31\3\2\2\2\u0140\u0145\5\36\20\2\u0141\u0145\5\34",
    "\17\2\u0142\u0145\5 \21\2\u0143\u0145\t\7\2\2\u0144\u0140\3\2\2\2\u0144",
    "\u0141\3\2\2\2\u0144\u0142\3\2\2\2\u0144\u0143\3\2\2\2\u0145\33\3\2",
    "\2\2\u0146\u014c\7\31\2\2\u0147\u0148\7\33\2\2\u0148\u014c\7#\2\2\u0149",
    "\u014a\7#\2\2\u014a\u014c\7\33\2\2\u014b\u0146\3\2\2\2\u014b\u0147\3",
    "\2\2\2\u014b\u0149\3\2\2\2\u014c\35\3\2\2\2\u014d\u0153\7\32\2\2\u014e",
    "\u014f\7\34\2\2\u014f\u0153\7#\2\2\u0150\u0151\7#\2\2\u0151\u0153\7",
    "\34\2\2\u0152\u014d\3\2\2\2\u0152\u014e\3\2\2\2\u0152\u0150\3\2\2\2",
    "\u0153\37\3\2\2\2\u0154\u0155\7\35\2\2\u0155!\3\2\2\2\u0156\u0157\7",
    "\t\2\2\u0157\u0159\5\u0086D\2\u0158\u015a\7\13\2\2\u0159\u0158\3\2\2",
    "\2\u0159\u015a\3\2\2\2\u015a\u015d\3\2\2\2\u015b\u015e\5\f\7\2\u015c",
    "\u015e\5\b\5\2\u015d\u015b\3\2\2\2\u015d\u015c\3\2\2\2\u015e#\3\2\2",
    "\2\u015f\u0160\7$\2\2\u0160\u0161\5\16\b\2\u0161\u0162\7#\2\2\u0162",
    "\u0163\5\u0086D\2\u0163\u0164\7%\2\2\u0164\u0167\5\u0086D\2\u0165\u0166",
    "\7&\2\2\u0166\u0168\5\u0086D\2\u0167\u0165\3\2\2\2\u0167\u0168\3\2\2",
    "\2\u0168\u0169\3\2\2\2\u0169\u016a\5\f\7\2\u016a\u016c\7\n\2\2\u016b",
    "\u016d\5\16\b\2\u016c\u016b\3\2\2\2\u016c\u016d\3\2\2\2\u016d%\3\2\2",
    "\2\u016e\u0171\7\'\2\2\u016f\u0170\7x\2\2\u0170\u0172\t\6\2\2\u0171",
    "\u016f\3\2\2\2\u0171\u0172\3\2\2\2\u0172\u0173\3\2\2\2\u0173\u0174\5",
    "\u008eH\2\u0174\'\3\2\2\2\u0175\u0176\7P\2\2\u0176\u0177\5\u008eH\2",
    "\u0177)\3\2\2\2\u0178\u0179\7)\2\2\u0179\u017a\5\u008eH\2\u017a+\3\2",
    "\2\2\u017b\u017c\7\7\2\2\u017c\u017d\5\b\5\2\u017d-\3\2\2\2\u017e\u017f",
    "\7\b\2\2\u017f\u0180\5\b\5\2\u0180/\3\2\2\2\u0181\u0182\7=\2\2\u0182",
    "\u0183\5\u0086D\2\u0183\u0184\7\36\2\2\u0184\u0185\5\u0086D\2\u0185",
    "\61\3\2\2\2\u0186\u0187\7\60\2\2\u0187\u0188\5\u0090I\2\u0188\63\3\2",
    "\2\2\u0189\u018e\7\62\2\2\u018a\u018b\5\u0086D\2\u018b\u018c\7\36\2",
    "\2\u018c\u018d\5\u0086D\2\u018d\u018f\3\2\2\2\u018e\u018a\3\2\2\2\u018e",
    "\u018f\3\2\2\2\u018f\u0197\3\2\2\2\u0190\u0191\7%\2\2\u0191\u0192\5",
    "\u0086D\2\u0192\u0193\7\36\2\2\u0193\u0194\5\u0086D\2\u0194\u0196\3",
    "\2\2\2\u0195\u0190\3\2\2\2\u0196\u0199\3\2\2\2\u0197\u0195\3\2\2\2\u0197",
    "\u0198\3\2\2\2\u0198\65\3\2\2\2\u0199\u0197\3\2\2\2\u019a\u019f\7\63",
    "\2\2\u019b\u019c\5\u0086D\2\u019c\u019d\7\36\2\2\u019d\u019e\5\u0086",
    "D\2\u019e\u01a0\3\2\2\2\u019f\u019b\3\2\2\2\u019f\u01a0\3\2\2\2\u01a0",
    "\u01a8\3\2\2\2\u01a1\u01a2\7%\2\2\u01a2\u01a3\5\u0086D\2\u01a3\u01a4",
    "\7\36\2\2\u01a4\u01a5\5\u0086D\2\u01a5\u01a7\3\2\2\2\u01a6\u01a1\3\2",
    "\2\2\u01a7\u01aa\3\2\2\2\u01a8\u01a6\3\2\2\2\u01a8\u01a9\3\2\2\2\u01a9",
    "\67\3\2\2\2\u01aa\u01a8\3\2\2\2\u01ab\u01ac\7;\2\2\u01ac\u01ad\5\u0086",
    "D\2\u01ad\u01ae\7\36\2\2\u01ae\u01af\5\u0086D\2\u01af9\3\2\2\2\u01b0",
    "\u01b1\79\2\2\u01b1\u01b2\5\u0086D\2\u01b2\u01b3\7\7\2\2\u01b3\u01b8",
    "\5\b\5\2\u01b4\u01b5\7\36\2\2\u01b5\u01b7\5\b\5\2\u01b6\u01b4\3\2\2",
    "\2\u01b7\u01ba\3\2\2\2\u01b8\u01b6\3\2\2\2\u01b8\u01b9\3\2\2\2\u01b9",
    ";\3\2\2\2\u01ba\u01b8\3\2\2\2\u01bb\u01bc\79\2\2\u01bc\u01bd\5\u0086",
    "D\2\u01bd\u01be\7\b\2\2\u01be\u01c3\5\b\5\2\u01bf\u01c0\7\36\2\2\u01c0",
    "\u01c2\5\b\5\2\u01c1\u01bf\3\2\2\2\u01c2\u01c5\3\2\2\2\u01c3\u01c1\3",
    "\2\2\2\u01c3\u01c4\3\2\2\2\u01c4=\3\2\2\2\u01c5\u01c3\3\2\2\2\u01c6",
    "\u01c7\7\66\2\2\u01c7\u01c8\5\u0086D\2\u01c8?\3\2\2\2\u01c9\u01ca\7",
    "\67\2\2\u01ca\u01cb\5\u0086D\2\u01cbA\3\2\2\2\u01cc\u01cd\7@\2\2\u01cd",
    "\u01ce\7+\2\2\u01ce\u01cf\5\u0086D\2\u01cfC\3\2\2\2\u01d0\u01d1\7A\2",
    "\2\u01d1\u01d2\7+\2\2\u01d2\u01d3\5\u0086D\2\u01d3E\3\2\2\2\u01d4\u01d5",
    "\7N\2\2\u01d5\u01dc\5H%\2\u01d6\u01d8\7\36\2\2\u01d7\u01d9\5H%\2\u01d8",
    "\u01d7\3\2\2\2\u01d8\u01d9\3\2\2\2\u01d9\u01db\3\2\2\2\u01da\u01d6\3",
    "\2\2\2\u01db\u01de\3\2\2\2\u01dc\u01da\3\2\2\2\u01dc\u01dd\3\2\2\2\u01dd",
    "G\3\2\2\2\u01de\u01dc\3\2\2\2\u01df\u01e0\t\b\2\2\u01e0I\3\2\2\2\u01e1",
    "\u01e2\7O\2\2\u01e2\u01e3\5\u0086D\2\u01e3\u01e4\7\36\2\2\u01e4\u01e7",
    "\5\u0086D\2\u01e5\u01e6\7\36\2\2\u01e6\u01e8\5\u0086D\2\u01e7\u01e5",
    "\3\2\2\2\u01e7\u01e8\3\2\2\2\u01e8K\3\2\2\2\u01e9\u01ea\7Q\2\2\u01ea",
    "\u01f0\5\u0086D\2\u01eb\u01ec\7S\2\2\u01ec\u01ed\5\u0086D\2\u01ed\u01ee",
    "\7\36\2\2\u01ee\u01ef\5\u0086D\2\u01ef\u01f1\3\2\2\2\u01f0\u01eb\3\2",
    "\2\2\u01f0\u01f1\3\2\2\2\u01f1M\3\2\2\2\u01f2\u01f3\7R\2\2\u01f3\u01f9",
    "\5\u0086D\2\u01f4\u01f5\7S\2\2\u01f5\u01f6\5\u0086D\2\u01f6\u01f7\7",
    "\36\2\2\u01f7\u01f8\5\u0086D\2\u01f8\u01fa\3\2\2\2\u01f9\u01f4\3\2\2",
    "\2\u01f9\u01fa\3\2\2\2\u01faO\3\2\2\2\u01fb\u01fc\7T\2\2\u01fc\u01fd",
    "\7U\2\2\u01fd\u01fe\5\u0088E\2\u01fe\u01ff\7\22\2\2\u01ff\u0200\5\u0088",
    "E\2\u0200\u0201\7\23\2\2\u0201\u0202\7#\2\2\u0202\u0203\5\u0086D\2\u0203",
    "Q\3\2\2\2\u0204\u0205\7W\2\2\u0205\u0206\7\22\2\2\u0206\u0207\5\u0086",
    "D\2\u0207\u0208\7\23\2\2\u0208S\3\2\2\2\u0209\u020a\7X\2\2\u020a\u020b",
    "\7#\2\2\u020b\u020c\5\u0086D\2\u020cU\3\2\2\2\u020d\u020e\7Y\2\2\u020e",
    "\u020f\7#\2\2\u020f\u0210\5\u0086D\2\u0210W\3\2\2\2\u0211\u0212\7Z\2",
    "\2\u0212\u0213\7#\2\2\u0213\u0214\5\u0086D\2\u0214Y\3\2\2\2\u0215\u0216",
    "\7[\2\2\u0216\u0217\7#\2\2\u0217\u0218\5\u0086D\2\u0218[\3\2\2\2\u0219",
    "\u021a\7\\\2\2\u021a\u021b\7#\2\2\u021b\u021c\5\u0086D\2\u021c]\3\2",
    "\2\2\u021d\u021e\7]\2\2\u021e\u021f\5\u0086D\2\u021f\u0220\7\36\2\2",
    "\u0220\u0221\5\u0086D\2\u0221\u0222\7S\2\2\u0222\u0223\5\u0086D\2\u0223",
    "_\3\2\2\2\u0224\u0225\7^\2\2\u0225\u0226\5\u0086D\2\u0226\u0227\7\36",
    "\2\2\u0227\u0228\5\u0086D\2\u0228\u0229\7S\2\2\u0229\u022a\5\u0086D",
    "\2\u022aa\3\2\2\2\u022b\u022c\7E\2\2\u022c\u022d\7\7\2\2\u022d\u022e",
    "\5\b\5\2\u022ec\3\2\2\2\u022f\u0230\7\64\2\2\u0230\u0231\7z\2\2\u0231",
    "e\3\2\2\2\u0232\u0233\7\65\2\2\u0233\u0234\7z\2\2\u0234g\3\2\2\2\u0235",
    "\u0236\7k\2\2\u0236\u0237\5\16\b\2\u0237i\3\2\2\2\u0238\u0239\7l\2\2",
    "\u0239\u023a\5\16\b\2\u023ak\3\2\2\2\u023b\u023d\7\37\2\2\u023c\u023e",
    "\5\u0086D\2\u023d\u023c\3\2\2\2\u023d\u023e\3\2\2\2\u023em\3\2\2\2\u023f",
    "\u0244\7`\2\2\u0240\u0241\5\u0086D\2\u0241\u0242\7\36\2\2\u0242\u0243",
    "\5\u0086D\2\u0243\u0245\3\2\2\2\u0244\u0240\3\2\2\2\u0244\u0245\3\2",
    "\2\2\u0245o\3\2\2\2\u0246\u0247\7o\2\2\u0247\u0248\5\u0086D\2\u0248",
    "q\3\2\2\2\u0249\u024a\7v\2\2\u024a\u024b\5\u0086D\2\u024bs\3\2\2\2\u024c",
    "\u024d\7!\2\2\u024du\3\2\2\2\u024e\u024f\7\5\2\2\u024fw\3\2\2\2\u0250",
    "\u0251\7r\2\2\u0251y\3\2\2\2\u0252\u0274\t\b\2\2\u0253\u0274\5\16\b",
    "\2\u0254\u0274\5\u0094K\2\u0255\u0274\5\u0092J\2\u0256\u0274\5\u0096",
    "L\2\u0257\u0274\5\u00aeX\2\u0258\u0274\5\u0098M\2\u0259\u0274\5\u00b4",
    "[\2\u025a\u0274\5\u009aN\2\u025b\u0274\5\u009cO\2\u025c\u0274\5\u009e",
    "P\2\u025d\u0274\5\u00a0Q\2\u025e\u0274\5\u00a2R\2\u025f\u0274\5\u00a4",
    "S\2\u0260\u0274\5\u00a6T\2\u0261\u0274\5\u00a8U\2\u0262\u0274\5\u00aa",
    "V\2\u0263\u0274\5\u00b2Z\2\u0264\u0274\5\u00acW\2\u0265\u0274\5\u00b0",
    "Y\2\u0266\u0274\5\u00b6\\\2\u0267\u0274\5\u00b8]\2\u0268\u0274\5\u00ba",
    "^\2\u0269\u0274\5\u00bc_\2\u026a\u0274\5\u00be`\2\u026b\u0274\5\u00c0",
    "a\2\u026c\u0274\5\u00c2b\2\u026d\u0274\5\u00c4c\2\u026e\u0274\5\u00c6",
    "d\2\u026f\u0270\7\22\2\2\u0270\u0271\5\u0086D\2\u0271\u0272\7\23\2\2",
    "\u0272\u0274\3\2\2\2\u0273\u0252\3\2\2\2\u0273\u0253\3\2\2\2\u0273\u0254",
    "\3\2\2\2\u0273\u0255\3\2\2\2\u0273\u0256\3\2\2\2\u0273\u0257\3\2\2\2",
    "\u0273\u0258\3\2\2\2\u0273\u0259\3\2\2\2\u0273\u025a\3\2\2\2\u0273\u025b",
    "\3\2\2\2\u0273\u025c\3\2\2\2\u0273\u025d\3\2\2\2\u0273\u025e\3\2\2\2",
    "\u0273\u025f\3\2\2\2\u0273\u0260\3\2\2\2\u0273\u0261\3\2\2\2\u0273\u0262",
    "\3\2\2\2\u0273\u0263\3\2\2\2\u0273\u0264\3\2\2\2\u0273\u0265\3\2\2\2",
    "\u0273\u0266\3\2\2\2\u0273\u0267\3\2\2\2\u0273\u0268\3\2\2\2\u0273\u0269",
    "\3\2\2\2\u0273\u026a\3\2\2\2\u0273\u026b\3\2\2\2\u0273\u026c\3\2\2\2",
    "\u0273\u026d\3\2\2\2\u0273\u026e\3\2\2\2\u0273\u026f\3\2\2\2\u0274{",
    "\3\2\2\2\u0275\u0277\7q\2\2\u0276\u0275\3\2\2\2\u0276\u0277\3\2\2\2",
    "\u0277\u027b\3\2\2\2\u0278\u027a\t\t\2\2\u0279\u0278\3\2\2\2\u027a\u027d",
    "\3\2\2\2\u027b\u0279\3\2\2\2\u027b\u027c\3\2\2\2\u027c\u027e\3\2\2\2",
    "\u027d\u027b\3\2\2\2\u027e\u027f\5z>\2\u027f}\3\2\2\2\u0280\u0285\5",
    "|?\2\u0281\u0282\7n\2\2\u0282\u0284\5|?\2\u0283\u0281\3\2\2\2\u0284",
    "\u0287\3\2\2\2\u0285\u0283\3\2\2\2\u0285\u0286\3\2\2\2\u0286\177\3\2",
    "\2\2\u0287\u0285\3\2\2\2\u0288\u028d\5~@\2\u0289\u028a\t\n\2\2\u028a",
    "\u028c\5~@\2\u028b\u0289\3\2\2\2\u028c\u028f\3\2\2\2\u028d\u028b\3\2",
    "\2\2\u028d\u028e\3\2\2\2\u028e\u0081\3\2\2\2\u028f\u028d\3\2\2\2\u0290",
    "\u0295\5\u0080A\2\u0291\u0292\t\t\2\2\u0292\u0294\5\u0080A\2\u0293\u0291",
    "\3\2\2\2\u0294\u0297\3\2\2\2\u0295\u0293\3\2\2\2\u0295\u0296\3\2\2\2",
    "\u0296\u0083\3\2\2\2\u0297\u0295\3\2\2\2\u0298\u029e\5\u0082B\2\u0299",
    "\u029a\5\32\16\2\u029a\u029b\5\u0082B\2\u029b\u029d\3\2\2\2\u029c\u0299",
    "\3\2\2\2\u029d\u02a0\3\2\2\2\u029e\u029c\3\2\2\2\u029e\u029f\3\2\2\2",
    "\u029f\u0085\3\2\2\2\u02a0\u029e\3\2\2\2\u02a1\u02ab\5z>\2\u02a2\u02a7",
    "\5\u0084C\2\u02a3\u02a4\t\13\2\2\u02a4\u02a6\5\u0084C\2\u02a5\u02a3",
    "\3\2\2\2\u02a6\u02a9\3\2\2\2\u02a7\u02a5\3\2\2\2\u02a7\u02a8\3\2\2\2",
    "\u02a8\u02ab\3\2\2\2\u02a9\u02a7\3\2\2\2\u02aa\u02a1\3\2\2\2\u02aa\u02a2",
    "\3\2\2\2\u02ab\u0087\3\2\2\2\u02ac\u02ae\5\u008aF\2\u02ad\u02af\5\u008c",
    "G\2\u02ae\u02ad\3\2\2\2\u02ae\u02af\3\2\2\2\u02af\u0089\3\2\2\2\u02b0",
    "\u02b4\7y\2\2\u02b1\u02b3\t\f\2\2\u02b2\u02b1\3\2\2\2\u02b3\u02b6\3",
    "\2\2\2\u02b4\u02b2\3\2\2\2\u02b4\u02b5\3\2\2\2\u02b5\u008b\3\2\2\2\u02b6",
    "\u02b4\3\2\2\2\u02b7\u02b8\t\r\2\2\u02b8\u008d\3\2\2\2\u02b9\u02be\5",
    "\16\b\2\u02ba\u02bb\7\36\2\2\u02bb\u02bd\5\16\b\2\u02bc\u02ba\3\2\2",
    "\2\u02bd\u02c0\3\2\2\2\u02be\u02bc\3\2\2\2\u02be\u02bf\3\2\2\2\u02bf",
    "\u008f\3\2\2\2\u02c0\u02be\3\2\2\2\u02c1\u02c6\5\u0086D\2\u02c2\u02c3",
    "\7\36\2\2\u02c3\u02c5\5\u0086D\2\u02c4\u02c2\3\2\2\2\u02c5\u02c8\3\2",
    "\2\2\u02c6\u02c4\3\2\2\2\u02c6\u02c7\3\2\2\2\u02c7\u0091\3\2\2\2\u02c8",
    "\u02c6\3\2\2\2\u02c9\u02ca\7*\2\2\u02ca\u02cb\7\22\2\2\u02cb\u02cc\5",
    "\u0086D\2\u02cc\u02cd\7\23\2\2\u02cd\u0093\3\2\2\2\u02ce\u02cf\7\r\2",
    "\2\u02cf\u02d0\7\22\2\2\u02d0\u02d1\5\u0086D\2\u02d1\u02d2\7\23\2\2",
    "\u02d2\u0095\3\2\2\2\u02d3\u02d4\7/\2\2\u02d4\u02d5\7\22\2\2\u02d5\u02d6",
    "\5\u0086D\2\u02d6\u02d7\7\23\2\2\u02d7\u0097\3\2\2\2\u02d8\u02d9\7\61",
    "\2\2\u02d9\u02da\7\22\2\2\u02da\u02db\5\u0086D\2\u02db\u02dc\7\23\2",
    "\2\u02dc\u0099\3\2\2\2\u02dd\u02de\7\16\2\2\u02de\u02df\7\22\2\2\u02df",
    "\u02e0\5\u0086D\2\u02e0\u02e1\7\36\2\2\u02e1\u02e2\5\u0086D\2\u02e2",
    "\u02e3\7\36\2\2\u02e3\u02e4\5\u0086D\2\u02e4\u02e5\7\23\2\2\u02e5\u009b",
    "\3\2\2\2\u02e6\u02e7\7:\2\2\u02e7\u02e8\7\22\2\2\u02e8\u02e9\5\u0086",
    "D\2\u02e9\u02ea\7\23\2\2\u02ea\u009d\3\2\2\2\u02eb\u02ec\7<\2\2\u02ec",
    "\u02ed\7\22\2\2\u02ed\u02ee\5\u0086D\2\u02ee\u02ef\7\23\2\2\u02ef\u009f",
    "\3\2\2\2\u02f0\u02f1\7>\2\2\u02f1\u02f2\7\22\2\2\u02f2\u02f3\5\u0086",
    "D\2\u02f3\u02f4\7\23\2\2\u02f4\u00a1\3\2\2\2\u02f5\u02f6\7F\2\2\u02f6",
    "\u02f7\7\22\2\2\u02f7\u02f8\5\u0086D\2\u02f8\u02f9\7\23\2\2\u02f9\u00a3",
    "\3\2\2\2\u02fa\u02fb\7G\2\2\u02fb\u02fc\7\22\2\2\u02fc\u02fd\5\u0086",
    "D\2\u02fd\u02fe\7\23\2\2\u02fe\u00a5\3\2\2\2\u02ff\u0300\7H\2\2\u0300",
    "\u0301\7\22\2\2\u0301\u0302\5\u0086D\2\u0302\u0303\7\23\2\2\u0303\u00a7",
    "\3\2\2\2\u0304\u0305\7I\2\2\u0305\u0306\7\22\2\2\u0306\u0307\5\u0086",
    "D\2\u0307\u0308\7\23\2\2\u0308\u00a9\3\2\2\2\u0309\u030a\7\17\2\2\u030a",
    "\u030b\7\22\2\2\u030b\u030c\5\u0086D\2\u030c\u030d\7\36\2\2\u030d\u030e",
    "\5\u0086D\2\u030e\u030f\7\23\2\2\u030f\u00ab\3\2\2\2\u0310\u0311\7\20",
    "\2\2\u0311\u0312\7\22\2\2\u0312\u0313\5\u0086D\2\u0313\u0314\7\36\2",
    "\2\u0314\u0315\5\u0086D\2\u0315\u0316\7\23\2\2\u0316\u00ad\3\2\2\2\u0317",
    "\u0318\7\21\2\2\u0318\u0319\7\22\2\2\u0319\u031a\5\u0086D\2\u031a\u031b",
    "\7\23\2\2\u031b\u00af\3\2\2\2\u031c\u031d\7U\2\2\u031d\u031e\5\u0088",
    "E\2\u031e\u031f\7\22\2\2\u031f\u0320\5\u0086D\2\u0320\u0321\7\23\2\2",
    "\u0321\u00b1\3\2\2\2\u0322\u0323\7V\2\2\u0323\u0324\7\22\2\2\u0324\u0325",
    "\5\u0086D\2\u0325\u0326\7\23\2\2\u0326\u00b3\3\2\2\2\u0327\u0328\7_",
    "\2\2\u0328\u0329\7\22\2\2\u0329\u032a\5\u0086D\2\u032a\u032b\7\36\2",
    "\2\u032b\u032c\5\u0086D\2\u032c\u032d\7\23\2\2\u032d\u00b5\3\2\2\2\u032e",
    "\u032f\7b\2\2\u032f\u0330\7\22\2\2\u0330\u0331\5\u0086D\2\u0331\u0332",
    "\7\23\2\2\u0332\u00b7\3\2\2\2\u0333\u0334\7c\2\2\u0334\u0335\7\22\2",
    "\2\u0335\u0336\5\u0086D\2\u0336\u0337\7\23\2\2\u0337\u00b9\3\2\2\2\u0338",
    "\u0339\7d\2\2\u0339\u033a\7\22\2\2\u033a\u033b\5\u0086D\2\u033b\u033c",
    "\7\23\2\2\u033c\u00bb\3\2\2\2\u033d\u033e\7e\2\2\u033e\u033f\7\22\2",
    "\2\u033f\u0340\5\u0086D\2\u0340\u0341\7\23\2\2\u0341\u00bd\3\2\2\2\u0342",
    "\u0343\7f\2\2\u0343\u0344\7\22\2\2\u0344\u0345\5\u0086D\2\u0345\u0346",
    "\7\23\2\2\u0346\u00bf\3\2\2\2\u0347\u0348\7g\2\2\u0348\u0349\7\22\2",
    "\2\u0349\u034a\5\u0086D\2\u034a\u034b\7\23\2\2\u034b\u00c1\3\2\2\2\u034c",
    "\u034d\7h\2\2\u034d\u034e\7\22\2\2\u034e\u034f\5\u0086D\2\u034f\u0350",
    "\7\23\2\2\u0350\u00c3\3\2\2\2\u0351\u0352\7i\2\2\u0352\u0353\7\22\2",
    "\2\u0353\u0354\5\u0086D\2\u0354\u0355\7\23\2\2\u0355\u00c5\3\2\2\2\u0356",
    "\u0357\7j\2\2\u0357\u0358\7\22\2\2\u0358\u0359\5\u0086D\2\u0359\u035a",
    "\7\23\2\2\u035a\u00c7\3\2\2\2\61\u00cb\u00d1\u00d5\u00d9\u00de\u00e5",
    "\u00e9\u011a\u0123\u0128\u012c\u0131\u0138\u0144\u014b\u0152\u0159\u015d",
    "\u0167\u016c\u0171\u018e\u0197\u019f\u01a8\u01b8\u01c3\u01d8\u01dc\u01e7",
    "\u01f0\u01f9\u023d\u0244\u0273\u0276\u027b\u0285\u028d\u0295\u029e\u02a7",
    "\u02aa\u02ae\u02b4\u02be\u02c6"].join("");


var atn = new antlr4.atn.ATNDeserializer().deserialize(serializedATN);

var decisionsToDFA = atn.decisionToState.map( function(ds, index) { return new antlr4.dfa.DFA(ds, index); });

var sharedContextCache = new antlr4.PredictionContextCache();

var literalNames = [ 'null', "'$'", "'%'", "'RETURN'", "'PRINT'", "'GOTO'", 
                     "'GOSUB'", "'IF'", "'NEXT'", "'THEN'", "'REM'", "'CHR$'", 
                     "'MID$'", "'LEFT$'", "'RIGHT$'", "'STR$'", "'('", "')'", 
                     "'+'", "'-'", "'*'", "'/'", "'CLEAR'", "'>: '", "'<: '", 
                     "'>'", "'<'", "'< >'", "','", "'LIST'", "'RUN'", "'END'", 
                     "'LET'", "'='", "'FOR'", "'TO'", "'STEP'", "'INPUT'", 
                     "';'", "'DIM'", "'SQR'", "':'", "'TEXT'", "'HGR'", 
                     "'HGR2'", "'LEN'", "'CALL'", "'ASC'", "'HPLOT'", "'VPLOT'", 
                     "'PR#'", "'IN#'", "'VTAB'", "'HTAB'", "'HOME'", "'ON'", 
                     "'PDL'", "'PLOT'", "'PEEK'", "'POKE'", "'INT'", "'STOP'", 
                     "'HIMEM'", "'LOMEM'", "'FLASH'", "'INVERSE'", "'NORMAL'", 
                     "'ONERR'", "'SPC'", "'FRE'", "'POS'", "'USR'", "'TRACE'", 
                     "'NOTRACE'", "'AND'", "'OR'", "'DATA'", "'WAIT'", "'READ'", 
                     "'XDRAW'", "'DRAW'", "'AT'", "'DEF'", "'FN'", "'VAL'", 
                     "'TAB'", "'SPEED'", "'ROT'", "'SCALE'", "'COLOR'", 
                     "'HCOLOR'", "'HLIN'", "'VLIN'", "'SCRN'", "'POP'", 
                     "'SHLOAD'", "'SIN'", "'COS'", "'TAN'", "'ATN'", "'RND'", 
                     "'SGN'", "'EXP'", "'LOG'", "'ABS'", "'STORE'", "'RECALL'", 
                     "'GET'", "'^'", "'&'", "'GR'", "'NOT'", "'RESTORE'", 
                     "'SAVE'", "'LOAD'", "'?'", "'INCLUDE'" ];

var symbolicNames = [ 'null', "DOLLAR", "PERCENT", "RETURN", "PRINT", "GOTO", 
                      "GOSUB", "IF", "NEXT", "THEN", "REM", "CHR", "MID", 
                      "LEFT", "RIGHT", "STR", "LPAREN", "RPAREN", "PLUS", 
                      "MINUS", "TIMES", "DIV", "CLEAR", "GTE", "LTE", "GT", 
                      "LT", "NEQ", "COMMA", "LIST", "RUN", "END", "LET", 
                      "EQ", "FOR", "TO", "STEP", "INPUT", "SEMICOLON", "DIM", 
                      "SQR", "COLON", "TEXT", "HGR", "HGR2", "LEN", "CALL", 
                      "ASC", "HPLOT", "VPLOT", "PRNUMBER", "INNUMBER", "VTAB", 
                      "HTAB", "HOME", "ON", "PDL", "PLOT", "PEEK", "POKE", 
                      "INTF", "STOP", "HIMEM", "LOMEM", "FLASH", "INVERSE", 
                      "NORMAL", "ONERR", "SPC", "FRE", "POS", "USR", "TRACE", 
                      "NOTRACE", "AND", "OR", "DATA", "WAIT", "READ", "XDRAW", 
                      "DRAW", "AT", "DEF", "FN", "VAL", "TAB", "SPEED", 
                      "ROT", "SCALE", "COLOR", "HCOLOR", "HLIN", "VLIN", 
                      "SCRN", "POP", "SHLOAD", "SIN", "COS", "TAN", "ATAN", 
                      "RND", "SGN", "EXP", "LOG", "ABS", "STORE", "RECALL", 
                      "GET", "EXPONENT", "AMPERSAND", "GR", "NOT", "RESTORE", 
                      "SAVE", "LOAD", "QUESTION", "INCLUDE", "COMMENT", 
                      "STRINGLITERAL", "LETTERS", "NUMBER", "FLOAT", "CR", 
                      "WS" ];

var ruleNames =  [ "prog", "line", "amperoper", "linenumber", "amprstmt", 
                   "statement", "vardecl", "printstmt1", "printlist", "getstmt", 
                   "letstmt", "variableassignment", "relop", "gte", "lte", 
                   "neq", "ifstmt", "forstmt", "inputstmt", "readstmt", 
                   "dimstmt", "gotostmt", "gosubstmt", "pokestmt", "callstmt", 
                   "hplotstmt", "vplotstmt", "plotstmt", "ongotostmt", "ongosubstmt", 
                   "vtabstmnt", "htabstmnt", "himemstmt", "lomemstmt", "datastmt", 
                   "datum", "waitstmt", "xdrawstmt", "drawstmt", "defstmt", 
                   "tabstmt", "speedstmt", "rotstmt", "scalestmt", "colorstmt", 
                   "hcolorstmt", "hlinstmt", "vlinstmt", "onerrstmt", "prstmt", 
                   "instmt", "storestmt", "recallstmt", "liststmt", "popstmt", 
                   "amptstmt", "includestmt", "endstmt", "returnstmt", "restorestmt", 
                   "func", "signExpression", "exponentExpression", "multiplyingExpression", 
                   "addingExpression", "relationalExpression", "expression", 
                   "var", "varname", "varsuffix", "varlist", "exprlist", 
                   "sqrfunc", "chrfunc", "lenfunc", "ascfunc", "midfunc", 
                   "pdlfunc", "peekfunc", "intfunc", "spcfunc", "frefunc", 
                   "posfunc", "usrfunc", "leftfunc", "rightfunc", "strfunc", 
                   "fnfunc", "valfunc", "scrnfunc", "sinfunc", "cosfunc", 
                   "tanfunc", "atnfunc", "rndfunc", "sgnfunc", "expfunc", 
                   "logfunc", "absfunc" ];

function jvmBasicParser (input) {
	antlr4.Parser.call(this, input);
    this._interp = new antlr4.atn.ParserATNSimulator(this, atn, decisionsToDFA, sharedContextCache);
    this.ruleNames = ruleNames;
    this.literalNames = literalNames;
    this.symbolicNames = symbolicNames;
    return this;
}

jvmBasicParser.prototype = Object.create(antlr4.Parser.prototype);
jvmBasicParser.prototype.constructor = jvmBasicParser;

Object.defineProperty(jvmBasicParser.prototype, "atn", {
	get : function() {
		return atn;
	}
});

jvmBasicParser.EOF = antlr4.Token.EOF;
jvmBasicParser.DOLLAR = 1;
jvmBasicParser.PERCENT = 2;
jvmBasicParser.RETURN = 3;
jvmBasicParser.PRINT = 4;
jvmBasicParser.GOTO = 5;
jvmBasicParser.GOSUB = 6;
jvmBasicParser.IF = 7;
jvmBasicParser.NEXT = 8;
jvmBasicParser.THEN = 9;
jvmBasicParser.REM = 10;
jvmBasicParser.CHR = 11;
jvmBasicParser.MID = 12;
jvmBasicParser.LEFT = 13;
jvmBasicParser.RIGHT = 14;
jvmBasicParser.STR = 15;
jvmBasicParser.LPAREN = 16;
jvmBasicParser.RPAREN = 17;
jvmBasicParser.PLUS = 18;
jvmBasicParser.MINUS = 19;
jvmBasicParser.TIMES = 20;
jvmBasicParser.DIV = 21;
jvmBasicParser.CLEAR = 22;
jvmBasicParser.GTE = 23;
jvmBasicParser.LTE = 24;
jvmBasicParser.GT = 25;
jvmBasicParser.LT = 26;
jvmBasicParser.NEQ = 27;
jvmBasicParser.COMMA = 28;
jvmBasicParser.LIST = 29;
jvmBasicParser.RUN = 30;
jvmBasicParser.END = 31;
jvmBasicParser.LET = 32;
jvmBasicParser.EQ = 33;
jvmBasicParser.FOR = 34;
jvmBasicParser.TO = 35;
jvmBasicParser.STEP = 36;
jvmBasicParser.INPUT = 37;
jvmBasicParser.SEMICOLON = 38;
jvmBasicParser.DIM = 39;
jvmBasicParser.SQR = 40;
jvmBasicParser.COLON = 41;
jvmBasicParser.TEXT = 42;
jvmBasicParser.HGR = 43;
jvmBasicParser.HGR2 = 44;
jvmBasicParser.LEN = 45;
jvmBasicParser.CALL = 46;
jvmBasicParser.ASC = 47;
jvmBasicParser.HPLOT = 48;
jvmBasicParser.VPLOT = 49;
jvmBasicParser.PRNUMBER = 50;
jvmBasicParser.INNUMBER = 51;
jvmBasicParser.VTAB = 52;
jvmBasicParser.HTAB = 53;
jvmBasicParser.HOME = 54;
jvmBasicParser.ON = 55;
jvmBasicParser.PDL = 56;
jvmBasicParser.PLOT = 57;
jvmBasicParser.PEEK = 58;
jvmBasicParser.POKE = 59;
jvmBasicParser.INTF = 60;
jvmBasicParser.STOP = 61;
jvmBasicParser.HIMEM = 62;
jvmBasicParser.LOMEM = 63;
jvmBasicParser.FLASH = 64;
jvmBasicParser.INVERSE = 65;
jvmBasicParser.NORMAL = 66;
jvmBasicParser.ONERR = 67;
jvmBasicParser.SPC = 68;
jvmBasicParser.FRE = 69;
jvmBasicParser.POS = 70;
jvmBasicParser.USR = 71;
jvmBasicParser.TRACE = 72;
jvmBasicParser.NOTRACE = 73;
jvmBasicParser.AND = 74;
jvmBasicParser.OR = 75;
jvmBasicParser.DATA = 76;
jvmBasicParser.WAIT = 77;
jvmBasicParser.READ = 78;
jvmBasicParser.XDRAW = 79;
jvmBasicParser.DRAW = 80;
jvmBasicParser.AT = 81;
jvmBasicParser.DEF = 82;
jvmBasicParser.FN = 83;
jvmBasicParser.VAL = 84;
jvmBasicParser.TAB = 85;
jvmBasicParser.SPEED = 86;
jvmBasicParser.ROT = 87;
jvmBasicParser.SCALE = 88;
jvmBasicParser.COLOR = 89;
jvmBasicParser.HCOLOR = 90;
jvmBasicParser.HLIN = 91;
jvmBasicParser.VLIN = 92;
jvmBasicParser.SCRN = 93;
jvmBasicParser.POP = 94;
jvmBasicParser.SHLOAD = 95;
jvmBasicParser.SIN = 96;
jvmBasicParser.COS = 97;
jvmBasicParser.TAN = 98;
jvmBasicParser.ATAN = 99;
jvmBasicParser.RND = 100;
jvmBasicParser.SGN = 101;
jvmBasicParser.EXP = 102;
jvmBasicParser.LOG = 103;
jvmBasicParser.ABS = 104;
jvmBasicParser.STORE = 105;
jvmBasicParser.RECALL = 106;
jvmBasicParser.GET = 107;
jvmBasicParser.EXPONENT = 108;
jvmBasicParser.AMPERSAND = 109;
jvmBasicParser.GR = 110;
jvmBasicParser.NOT = 111;
jvmBasicParser.RESTORE = 112;
jvmBasicParser.SAVE = 113;
jvmBasicParser.LOAD = 114;
jvmBasicParser.QUESTION = 115;
jvmBasicParser.INCLUDE = 116;
jvmBasicParser.COMMENT = 117;
jvmBasicParser.STRINGLITERAL = 118;
jvmBasicParser.LETTERS = 119;
jvmBasicParser.NUMBER = 120;
jvmBasicParser.FLOAT = 121;
jvmBasicParser.CR = 122;
jvmBasicParser.WS = 123;

jvmBasicParser.RULE_prog = 0;
jvmBasicParser.RULE_line = 1;
jvmBasicParser.RULE_amperoper = 2;
jvmBasicParser.RULE_linenumber = 3;
jvmBasicParser.RULE_amprstmt = 4;
jvmBasicParser.RULE_statement = 5;
jvmBasicParser.RULE_vardecl = 6;
jvmBasicParser.RULE_printstmt1 = 7;
jvmBasicParser.RULE_printlist = 8;
jvmBasicParser.RULE_getstmt = 9;
jvmBasicParser.RULE_letstmt = 10;
jvmBasicParser.RULE_variableassignment = 11;
jvmBasicParser.RULE_relop = 12;
jvmBasicParser.RULE_gte = 13;
jvmBasicParser.RULE_lte = 14;
jvmBasicParser.RULE_neq = 15;
jvmBasicParser.RULE_ifstmt = 16;
jvmBasicParser.RULE_forstmt = 17;
jvmBasicParser.RULE_inputstmt = 18;
jvmBasicParser.RULE_readstmt = 19;
jvmBasicParser.RULE_dimstmt = 20;
jvmBasicParser.RULE_gotostmt = 21;
jvmBasicParser.RULE_gosubstmt = 22;
jvmBasicParser.RULE_pokestmt = 23;
jvmBasicParser.RULE_callstmt = 24;
jvmBasicParser.RULE_hplotstmt = 25;
jvmBasicParser.RULE_vplotstmt = 26;
jvmBasicParser.RULE_plotstmt = 27;
jvmBasicParser.RULE_ongotostmt = 28;
jvmBasicParser.RULE_ongosubstmt = 29;
jvmBasicParser.RULE_vtabstmnt = 30;
jvmBasicParser.RULE_htabstmnt = 31;
jvmBasicParser.RULE_himemstmt = 32;
jvmBasicParser.RULE_lomemstmt = 33;
jvmBasicParser.RULE_datastmt = 34;
jvmBasicParser.RULE_datum = 35;
jvmBasicParser.RULE_waitstmt = 36;
jvmBasicParser.RULE_xdrawstmt = 37;
jvmBasicParser.RULE_drawstmt = 38;
jvmBasicParser.RULE_defstmt = 39;
jvmBasicParser.RULE_tabstmt = 40;
jvmBasicParser.RULE_speedstmt = 41;
jvmBasicParser.RULE_rotstmt = 42;
jvmBasicParser.RULE_scalestmt = 43;
jvmBasicParser.RULE_colorstmt = 44;
jvmBasicParser.RULE_hcolorstmt = 45;
jvmBasicParser.RULE_hlinstmt = 46;
jvmBasicParser.RULE_vlinstmt = 47;
jvmBasicParser.RULE_onerrstmt = 48;
jvmBasicParser.RULE_prstmt = 49;
jvmBasicParser.RULE_instmt = 50;
jvmBasicParser.RULE_storestmt = 51;
jvmBasicParser.RULE_recallstmt = 52;
jvmBasicParser.RULE_liststmt = 53;
jvmBasicParser.RULE_popstmt = 54;
jvmBasicParser.RULE_amptstmt = 55;
jvmBasicParser.RULE_includestmt = 56;
jvmBasicParser.RULE_endstmt = 57;
jvmBasicParser.RULE_returnstmt = 58;
jvmBasicParser.RULE_restorestmt = 59;
jvmBasicParser.RULE_func = 60;
jvmBasicParser.RULE_signExpression = 61;
jvmBasicParser.RULE_exponentExpression = 62;
jvmBasicParser.RULE_multiplyingExpression = 63;
jvmBasicParser.RULE_addingExpression = 64;
jvmBasicParser.RULE_relationalExpression = 65;
jvmBasicParser.RULE_expression = 66;
jvmBasicParser.RULE_var = 67;
jvmBasicParser.RULE_varname = 68;
jvmBasicParser.RULE_varsuffix = 69;
jvmBasicParser.RULE_varlist = 70;
jvmBasicParser.RULE_exprlist = 71;
jvmBasicParser.RULE_sqrfunc = 72;
jvmBasicParser.RULE_chrfunc = 73;
jvmBasicParser.RULE_lenfunc = 74;
jvmBasicParser.RULE_ascfunc = 75;
jvmBasicParser.RULE_midfunc = 76;
jvmBasicParser.RULE_pdlfunc = 77;
jvmBasicParser.RULE_peekfunc = 78;
jvmBasicParser.RULE_intfunc = 79;
jvmBasicParser.RULE_spcfunc = 80;
jvmBasicParser.RULE_frefunc = 81;
jvmBasicParser.RULE_posfunc = 82;
jvmBasicParser.RULE_usrfunc = 83;
jvmBasicParser.RULE_leftfunc = 84;
jvmBasicParser.RULE_rightfunc = 85;
jvmBasicParser.RULE_strfunc = 86;
jvmBasicParser.RULE_fnfunc = 87;
jvmBasicParser.RULE_valfunc = 88;
jvmBasicParser.RULE_scrnfunc = 89;
jvmBasicParser.RULE_sinfunc = 90;
jvmBasicParser.RULE_cosfunc = 91;
jvmBasicParser.RULE_tanfunc = 92;
jvmBasicParser.RULE_atnfunc = 93;
jvmBasicParser.RULE_rndfunc = 94;
jvmBasicParser.RULE_sgnfunc = 95;
jvmBasicParser.RULE_expfunc = 96;
jvmBasicParser.RULE_logfunc = 97;
jvmBasicParser.RULE_absfunc = 98;

function ProgContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_prog;
    return this;
}

ProgContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
ProgContext.prototype.constructor = ProgContext;

ProgContext.prototype.line = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(LineContext);
    } else {
        return this.getTypedRuleContext(LineContext,i);
    }
};

ProgContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterProg(this);
	}
};

ProgContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitProg(this);
	}
};




jvmBasicParser.ProgContext = ProgContext;

jvmBasicParser.prototype.prog = function() {

    var localctx = new ProgContext(this, this._ctx, this.state);
    this.enterRule(localctx, 0, jvmBasicParser.RULE_prog);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 199; 
        this._errHandler.sync(this);
        _la = this._input.LA(1);
        do {
            this.state = 198;
            this.line();
            this.state = 201; 
            this._errHandler.sync(this);
            _la = this._input.LA(1);
        } while(_la===jvmBasicParser.NUMBER || _la===jvmBasicParser.CR);
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

function LineContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_line;
    return this;
}

LineContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
LineContext.prototype.constructor = LineContext;

LineContext.prototype.linenumber = function() {
    return this.getTypedRuleContext(LinenumberContext,0);
};

LineContext.prototype.CR = function() {
    return this.getToken(jvmBasicParser.CR, 0);
};

LineContext.prototype.EOF = function() {
    return this.getToken(jvmBasicParser.EOF, 0);
};

LineContext.prototype.COMMENT = function() {
    return this.getToken(jvmBasicParser.COMMENT, 0);
};

LineContext.prototype.REM = function() {
    return this.getToken(jvmBasicParser.REM, 0);
};

LineContext.prototype.amprstmt = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(AmprstmtContext);
    } else {
        return this.getTypedRuleContext(AmprstmtContext,i);
    }
};

LineContext.prototype.COLON = function(i) {
	if(i===undefined) {
		i = null;
	}
    if(i===null) {
        return this.getTokens(jvmBasicParser.COLON);
    } else {
        return this.getToken(jvmBasicParser.COLON, i);
    }
};


LineContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterLine(this);
	}
};

LineContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitLine(this);
	}
};




jvmBasicParser.LineContext = LineContext;

jvmBasicParser.prototype.line = function() {

    var localctx = new LineContext(this, this._ctx, this.state);
    this.enterRule(localctx, 2, jvmBasicParser.RULE_line);
    var _la = 0; // Token type
    try {
        this.state = 220;
        switch(this._input.LA(1)) {
        case jvmBasicParser.NUMBER:
            this.enterOuterAlt(localctx, 1);
            this.state = 203;
            this.linenumber();
            this.state = 215;
            var la_ = this._interp.adaptivePredict(this._input,3,this._ctx);
            switch(la_) {
            case 1:
                this.state = 204;
                this.amprstmt();
                this.state = 211;
                this._errHandler.sync(this);
                _la = this._input.LA(1);
                while(_la===jvmBasicParser.COLON) {
                    this.state = 205;
                    this.match(jvmBasicParser.COLON);
                    this.state = 207;
                    _la = this._input.LA(1);
                    if((((_la) & ~0x1f) == 0 && ((1 << _la) & ((1 << jvmBasicParser.RETURN) | (1 << jvmBasicParser.PRINT) | (1 << jvmBasicParser.GOTO) | (1 << jvmBasicParser.GOSUB) | (1 << jvmBasicParser.IF) | (1 << jvmBasicParser.REM) | (1 << jvmBasicParser.CLEAR) | (1 << jvmBasicParser.LIST) | (1 << jvmBasicParser.RUN) | (1 << jvmBasicParser.END))) !== 0) || ((((_la - 32)) & ~0x1f) == 0 && ((1 << (_la - 32)) & ((1 << (jvmBasicParser.LET - 32)) | (1 << (jvmBasicParser.FOR - 32)) | (1 << (jvmBasicParser.INPUT - 32)) | (1 << (jvmBasicParser.DIM - 32)) | (1 << (jvmBasicParser.TEXT - 32)) | (1 << (jvmBasicParser.HGR - 32)) | (1 << (jvmBasicParser.HGR2 - 32)) | (1 << (jvmBasicParser.CALL - 32)) | (1 << (jvmBasicParser.HPLOT - 32)) | (1 << (jvmBasicParser.VPLOT - 32)) | (1 << (jvmBasicParser.PRNUMBER - 32)) | (1 << (jvmBasicParser.INNUMBER - 32)) | (1 << (jvmBasicParser.VTAB - 32)) | (1 << (jvmBasicParser.HTAB - 32)) | (1 << (jvmBasicParser.HOME - 32)) | (1 << (jvmBasicParser.ON - 32)) | (1 << (jvmBasicParser.PLOT - 32)) | (1 << (jvmBasicParser.POKE - 32)) | (1 << (jvmBasicParser.STOP - 32)) | (1 << (jvmBasicParser.HIMEM - 32)) | (1 << (jvmBasicParser.LOMEM - 32)))) !== 0) || ((((_la - 64)) & ~0x1f) == 0 && ((1 << (_la - 64)) & ((1 << (jvmBasicParser.FLASH - 64)) | (1 << (jvmBasicParser.INVERSE - 64)) | (1 << (jvmBasicParser.NORMAL - 64)) | (1 << (jvmBasicParser.ONERR - 64)) | (1 << (jvmBasicParser.TRACE - 64)) | (1 << (jvmBasicParser.NOTRACE - 64)) | (1 << (jvmBasicParser.DATA - 64)) | (1 << (jvmBasicParser.WAIT - 64)) | (1 << (jvmBasicParser.READ - 64)) | (1 << (jvmBasicParser.XDRAW - 64)) | (1 << (jvmBasicParser.DRAW - 64)) | (1 << (jvmBasicParser.DEF - 64)) | (1 << (jvmBasicParser.TAB - 64)) | (1 << (jvmBasicParser.SPEED - 64)) | (1 << (jvmBasicParser.ROT - 64)) | (1 << (jvmBasicParser.SCALE - 64)) | (1 << (jvmBasicParser.COLOR - 64)) | (1 << (jvmBasicParser.HCOLOR - 64)) | (1 << (jvmBasicParser.HLIN - 64)) | (1 << (jvmBasicParser.VLIN - 64)) | (1 << (jvmBasicParser.POP - 64)) | (1 << (jvmBasicParser.SHLOAD - 64)))) !== 0) || ((((_la - 105)) & ~0x1f) == 0 && ((1 << (_la - 105)) & ((1 << (jvmBasicParser.STORE - 105)) | (1 << (jvmBasicParser.RECALL - 105)) | (1 << (jvmBasicParser.GET - 105)) | (1 << (jvmBasicParser.AMPERSAND - 105)) | (1 << (jvmBasicParser.GR - 105)) | (1 << (jvmBasicParser.RESTORE - 105)) | (1 << (jvmBasicParser.SAVE - 105)) | (1 << (jvmBasicParser.LOAD - 105)) | (1 << (jvmBasicParser.QUESTION - 105)) | (1 << (jvmBasicParser.INCLUDE - 105)) | (1 << (jvmBasicParser.COMMENT - 105)) | (1 << (jvmBasicParser.LETTERS - 105)))) !== 0)) {
                        this.state = 206;
                        this.amprstmt();
                    }

                    this.state = 213;
                    this._errHandler.sync(this);
                    _la = this._input.LA(1);
                }
                break;

            case 2:
                this.state = 214;
                _la = this._input.LA(1);
                if(!(_la===jvmBasicParser.REM || _la===jvmBasicParser.COMMENT)) {
                this._errHandler.recoverInline(this);
                }
                else {
                    this.consume();
                }
                break;

            }
            this.state = 217;
            _la = this._input.LA(1);
            if(!(_la===jvmBasicParser.EOF || _la===jvmBasicParser.CR)) {
            this._errHandler.recoverInline(this);
            }
            else {
                this.consume();
            }
            break;
        case jvmBasicParser.CR:
            this.enterOuterAlt(localctx, 2);
            this.state = 219;
            this.match(jvmBasicParser.CR);
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

function AmperoperContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_amperoper;
    return this;
}

AmperoperContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
AmperoperContext.prototype.constructor = AmperoperContext;

AmperoperContext.prototype.AMPERSAND = function() {
    return this.getToken(jvmBasicParser.AMPERSAND, 0);
};

AmperoperContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterAmperoper(this);
	}
};

AmperoperContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitAmperoper(this);
	}
};




jvmBasicParser.AmperoperContext = AmperoperContext;

jvmBasicParser.prototype.amperoper = function() {

    var localctx = new AmperoperContext(this, this._ctx, this.state);
    this.enterRule(localctx, 4, jvmBasicParser.RULE_amperoper);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 222;
        this.match(jvmBasicParser.AMPERSAND);
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

function LinenumberContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_linenumber;
    return this;
}

LinenumberContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
LinenumberContext.prototype.constructor = LinenumberContext;

LinenumberContext.prototype.NUMBER = function() {
    return this.getToken(jvmBasicParser.NUMBER, 0);
};

LinenumberContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterLinenumber(this);
	}
};

LinenumberContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitLinenumber(this);
	}
};




jvmBasicParser.LinenumberContext = LinenumberContext;

jvmBasicParser.prototype.linenumber = function() {

    var localctx = new LinenumberContext(this, this._ctx, this.state);
    this.enterRule(localctx, 6, jvmBasicParser.RULE_linenumber);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 224;
        this.match(jvmBasicParser.NUMBER);
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

function AmprstmtContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_amprstmt;
    return this;
}

AmprstmtContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
AmprstmtContext.prototype.constructor = AmprstmtContext;

AmprstmtContext.prototype.statement = function() {
    return this.getTypedRuleContext(StatementContext,0);
};

AmprstmtContext.prototype.amperoper = function() {
    return this.getTypedRuleContext(AmperoperContext,0);
};

AmprstmtContext.prototype.COMMENT = function() {
    return this.getToken(jvmBasicParser.COMMENT, 0);
};

AmprstmtContext.prototype.REM = function() {
    return this.getToken(jvmBasicParser.REM, 0);
};

AmprstmtContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterAmprstmt(this);
	}
};

AmprstmtContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitAmprstmt(this);
	}
};




jvmBasicParser.AmprstmtContext = AmprstmtContext;

jvmBasicParser.prototype.amprstmt = function() {

    var localctx = new AmprstmtContext(this, this._ctx, this.state);
    this.enterRule(localctx, 8, jvmBasicParser.RULE_amprstmt);
    var _la = 0; // Token type
    try {
        this.state = 231;
        switch(this._input.LA(1)) {
        case jvmBasicParser.RETURN:
        case jvmBasicParser.PRINT:
        case jvmBasicParser.GOTO:
        case jvmBasicParser.GOSUB:
        case jvmBasicParser.IF:
        case jvmBasicParser.CLEAR:
        case jvmBasicParser.LIST:
        case jvmBasicParser.RUN:
        case jvmBasicParser.END:
        case jvmBasicParser.LET:
        case jvmBasicParser.FOR:
        case jvmBasicParser.INPUT:
        case jvmBasicParser.DIM:
        case jvmBasicParser.TEXT:
        case jvmBasicParser.HGR:
        case jvmBasicParser.HGR2:
        case jvmBasicParser.CALL:
        case jvmBasicParser.HPLOT:
        case jvmBasicParser.VPLOT:
        case jvmBasicParser.PRNUMBER:
        case jvmBasicParser.INNUMBER:
        case jvmBasicParser.VTAB:
        case jvmBasicParser.HTAB:
        case jvmBasicParser.HOME:
        case jvmBasicParser.ON:
        case jvmBasicParser.PLOT:
        case jvmBasicParser.POKE:
        case jvmBasicParser.STOP:
        case jvmBasicParser.HIMEM:
        case jvmBasicParser.LOMEM:
        case jvmBasicParser.FLASH:
        case jvmBasicParser.INVERSE:
        case jvmBasicParser.NORMAL:
        case jvmBasicParser.ONERR:
        case jvmBasicParser.TRACE:
        case jvmBasicParser.NOTRACE:
        case jvmBasicParser.DATA:
        case jvmBasicParser.WAIT:
        case jvmBasicParser.READ:
        case jvmBasicParser.XDRAW:
        case jvmBasicParser.DRAW:
        case jvmBasicParser.DEF:
        case jvmBasicParser.TAB:
        case jvmBasicParser.SPEED:
        case jvmBasicParser.ROT:
        case jvmBasicParser.SCALE:
        case jvmBasicParser.COLOR:
        case jvmBasicParser.HCOLOR:
        case jvmBasicParser.HLIN:
        case jvmBasicParser.VLIN:
        case jvmBasicParser.POP:
        case jvmBasicParser.SHLOAD:
        case jvmBasicParser.STORE:
        case jvmBasicParser.RECALL:
        case jvmBasicParser.GET:
        case jvmBasicParser.AMPERSAND:
        case jvmBasicParser.GR:
        case jvmBasicParser.RESTORE:
        case jvmBasicParser.SAVE:
        case jvmBasicParser.LOAD:
        case jvmBasicParser.QUESTION:
        case jvmBasicParser.INCLUDE:
        case jvmBasicParser.LETTERS:
            this.enterOuterAlt(localctx, 1);
            this.state = 227;
            var la_ = this._interp.adaptivePredict(this._input,5,this._ctx);
            if(la_===1) {
                this.state = 226;
                this.amperoper();

            }
            this.state = 229;
            this.statement();
            break;
        case jvmBasicParser.REM:
        case jvmBasicParser.COMMENT:
            this.enterOuterAlt(localctx, 2);
            this.state = 230;
            _la = this._input.LA(1);
            if(!(_la===jvmBasicParser.REM || _la===jvmBasicParser.COMMENT)) {
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

function StatementContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_statement;
    return this;
}

StatementContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
StatementContext.prototype.constructor = StatementContext;

StatementContext.prototype.LOAD = function() {
    return this.getToken(jvmBasicParser.LOAD, 0);
};

StatementContext.prototype.SAVE = function() {
    return this.getToken(jvmBasicParser.SAVE, 0);
};

StatementContext.prototype.TRACE = function() {
    return this.getToken(jvmBasicParser.TRACE, 0);
};

StatementContext.prototype.NOTRACE = function() {
    return this.getToken(jvmBasicParser.NOTRACE, 0);
};

StatementContext.prototype.FLASH = function() {
    return this.getToken(jvmBasicParser.FLASH, 0);
};

StatementContext.prototype.INVERSE = function() {
    return this.getToken(jvmBasicParser.INVERSE, 0);
};

StatementContext.prototype.GR = function() {
    return this.getToken(jvmBasicParser.GR, 0);
};

StatementContext.prototype.NORMAL = function() {
    return this.getToken(jvmBasicParser.NORMAL, 0);
};

StatementContext.prototype.SHLOAD = function() {
    return this.getToken(jvmBasicParser.SHLOAD, 0);
};

StatementContext.prototype.CLEAR = function() {
    return this.getToken(jvmBasicParser.CLEAR, 0);
};

StatementContext.prototype.RUN = function() {
    return this.getToken(jvmBasicParser.RUN, 0);
};

StatementContext.prototype.STOP = function() {
    return this.getToken(jvmBasicParser.STOP, 0);
};

StatementContext.prototype.TEXT = function() {
    return this.getToken(jvmBasicParser.TEXT, 0);
};

StatementContext.prototype.HOME = function() {
    return this.getToken(jvmBasicParser.HOME, 0);
};

StatementContext.prototype.HGR = function() {
    return this.getToken(jvmBasicParser.HGR, 0);
};

StatementContext.prototype.HGR2 = function() {
    return this.getToken(jvmBasicParser.HGR2, 0);
};

StatementContext.prototype.endstmt = function() {
    return this.getTypedRuleContext(EndstmtContext,0);
};

StatementContext.prototype.returnstmt = function() {
    return this.getTypedRuleContext(ReturnstmtContext,0);
};

StatementContext.prototype.restorestmt = function() {
    return this.getTypedRuleContext(RestorestmtContext,0);
};

StatementContext.prototype.amptstmt = function() {
    return this.getTypedRuleContext(AmptstmtContext,0);
};

StatementContext.prototype.popstmt = function() {
    return this.getTypedRuleContext(PopstmtContext,0);
};

StatementContext.prototype.liststmt = function() {
    return this.getTypedRuleContext(ListstmtContext,0);
};

StatementContext.prototype.storestmt = function() {
    return this.getTypedRuleContext(StorestmtContext,0);
};

StatementContext.prototype.getstmt = function() {
    return this.getTypedRuleContext(GetstmtContext,0);
};

StatementContext.prototype.recallstmt = function() {
    return this.getTypedRuleContext(RecallstmtContext,0);
};

StatementContext.prototype.instmt = function() {
    return this.getTypedRuleContext(InstmtContext,0);
};

StatementContext.prototype.prstmt = function() {
    return this.getTypedRuleContext(PrstmtContext,0);
};

StatementContext.prototype.onerrstmt = function() {
    return this.getTypedRuleContext(OnerrstmtContext,0);
};

StatementContext.prototype.hlinstmt = function() {
    return this.getTypedRuleContext(HlinstmtContext,0);
};

StatementContext.prototype.vlinstmt = function() {
    return this.getTypedRuleContext(VlinstmtContext,0);
};

StatementContext.prototype.colorstmt = function() {
    return this.getTypedRuleContext(ColorstmtContext,0);
};

StatementContext.prototype.speedstmt = function() {
    return this.getTypedRuleContext(SpeedstmtContext,0);
};

StatementContext.prototype.scalestmt = function() {
    return this.getTypedRuleContext(ScalestmtContext,0);
};

StatementContext.prototype.rotstmt = function() {
    return this.getTypedRuleContext(RotstmtContext,0);
};

StatementContext.prototype.hcolorstmt = function() {
    return this.getTypedRuleContext(HcolorstmtContext,0);
};

StatementContext.prototype.himemstmt = function() {
    return this.getTypedRuleContext(HimemstmtContext,0);
};

StatementContext.prototype.lomemstmt = function() {
    return this.getTypedRuleContext(LomemstmtContext,0);
};

StatementContext.prototype.printstmt1 = function() {
    return this.getTypedRuleContext(Printstmt1Context,0);
};

StatementContext.prototype.pokestmt = function() {
    return this.getTypedRuleContext(PokestmtContext,0);
};

StatementContext.prototype.plotstmt = function() {
    return this.getTypedRuleContext(PlotstmtContext,0);
};

StatementContext.prototype.ongotostmt = function() {
    return this.getTypedRuleContext(OngotostmtContext,0);
};

StatementContext.prototype.ongosubstmt = function() {
    return this.getTypedRuleContext(OngosubstmtContext,0);
};

StatementContext.prototype.ifstmt = function() {
    return this.getTypedRuleContext(IfstmtContext,0);
};

StatementContext.prototype.forstmt = function() {
    return this.getTypedRuleContext(ForstmtContext,0);
};

StatementContext.prototype.inputstmt = function() {
    return this.getTypedRuleContext(InputstmtContext,0);
};

StatementContext.prototype.tabstmt = function() {
    return this.getTypedRuleContext(TabstmtContext,0);
};

StatementContext.prototype.dimstmt = function() {
    return this.getTypedRuleContext(DimstmtContext,0);
};

StatementContext.prototype.gotostmt = function() {
    return this.getTypedRuleContext(GotostmtContext,0);
};

StatementContext.prototype.gosubstmt = function() {
    return this.getTypedRuleContext(GosubstmtContext,0);
};

StatementContext.prototype.callstmt = function() {
    return this.getTypedRuleContext(CallstmtContext,0);
};

StatementContext.prototype.readstmt = function() {
    return this.getTypedRuleContext(ReadstmtContext,0);
};

StatementContext.prototype.hplotstmt = function() {
    return this.getTypedRuleContext(HplotstmtContext,0);
};

StatementContext.prototype.vplotstmt = function() {
    return this.getTypedRuleContext(VplotstmtContext,0);
};

StatementContext.prototype.vtabstmnt = function() {
    return this.getTypedRuleContext(VtabstmntContext,0);
};

StatementContext.prototype.htabstmnt = function() {
    return this.getTypedRuleContext(HtabstmntContext,0);
};

StatementContext.prototype.waitstmt = function() {
    return this.getTypedRuleContext(WaitstmtContext,0);
};

StatementContext.prototype.datastmt = function() {
    return this.getTypedRuleContext(DatastmtContext,0);
};

StatementContext.prototype.xdrawstmt = function() {
    return this.getTypedRuleContext(XdrawstmtContext,0);
};

StatementContext.prototype.drawstmt = function() {
    return this.getTypedRuleContext(DrawstmtContext,0);
};

StatementContext.prototype.defstmt = function() {
    return this.getTypedRuleContext(DefstmtContext,0);
};

StatementContext.prototype.letstmt = function() {
    return this.getTypedRuleContext(LetstmtContext,0);
};

StatementContext.prototype.includestmt = function() {
    return this.getTypedRuleContext(IncludestmtContext,0);
};

StatementContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterStatement(this);
	}
};

StatementContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitStatement(this);
	}
};




jvmBasicParser.StatementContext = StatementContext;

jvmBasicParser.prototype.statement = function() {

    var localctx = new StatementContext(this, this._ctx, this.state);
    this.enterRule(localctx, 10, jvmBasicParser.RULE_statement);
    var _la = 0; // Token type
    try {
        this.state = 280;
        var la_ = this._interp.adaptivePredict(this._input,7,this._ctx);
        switch(la_) {
        case 1:
            this.enterOuterAlt(localctx, 1);
            this.state = 233;
            _la = this._input.LA(1);
            if(!(_la===jvmBasicParser.CLEAR || _la===jvmBasicParser.RUN || ((((_la - 42)) & ~0x1f) == 0 && ((1 << (_la - 42)) & ((1 << (jvmBasicParser.TEXT - 42)) | (1 << (jvmBasicParser.HGR - 42)) | (1 << (jvmBasicParser.HGR2 - 42)) | (1 << (jvmBasicParser.HOME - 42)) | (1 << (jvmBasicParser.STOP - 42)) | (1 << (jvmBasicParser.FLASH - 42)) | (1 << (jvmBasicParser.INVERSE - 42)) | (1 << (jvmBasicParser.NORMAL - 42)) | (1 << (jvmBasicParser.TRACE - 42)) | (1 << (jvmBasicParser.NOTRACE - 42)))) !== 0) || ((((_la - 95)) & ~0x1f) == 0 && ((1 << (_la - 95)) & ((1 << (jvmBasicParser.SHLOAD - 95)) | (1 << (jvmBasicParser.GR - 95)) | (1 << (jvmBasicParser.SAVE - 95)) | (1 << (jvmBasicParser.LOAD - 95)))) !== 0))) {
            this._errHandler.recoverInline(this);
            }
            else {
                this.consume();
            }
            break;

        case 2:
            this.enterOuterAlt(localctx, 2);
            this.state = 234;
            this.endstmt();
            break;

        case 3:
            this.enterOuterAlt(localctx, 3);
            this.state = 235;
            this.returnstmt();
            break;

        case 4:
            this.enterOuterAlt(localctx, 4);
            this.state = 236;
            this.restorestmt();
            break;

        case 5:
            this.enterOuterAlt(localctx, 5);
            this.state = 237;
            this.amptstmt();
            break;

        case 6:
            this.enterOuterAlt(localctx, 6);
            this.state = 238;
            this.popstmt();
            break;

        case 7:
            this.enterOuterAlt(localctx, 7);
            this.state = 239;
            this.liststmt();
            break;

        case 8:
            this.enterOuterAlt(localctx, 8);
            this.state = 240;
            this.storestmt();
            break;

        case 9:
            this.enterOuterAlt(localctx, 9);
            this.state = 241;
            this.getstmt();
            break;

        case 10:
            this.enterOuterAlt(localctx, 10);
            this.state = 242;
            this.recallstmt();
            break;

        case 11:
            this.enterOuterAlt(localctx, 11);
            this.state = 243;
            this.instmt();
            break;

        case 12:
            this.enterOuterAlt(localctx, 12);
            this.state = 244;
            this.prstmt();
            break;

        case 13:
            this.enterOuterAlt(localctx, 13);
            this.state = 245;
            this.onerrstmt();
            break;

        case 14:
            this.enterOuterAlt(localctx, 14);
            this.state = 246;
            this.hlinstmt();
            break;

        case 15:
            this.enterOuterAlt(localctx, 15);
            this.state = 247;
            this.vlinstmt();
            break;

        case 16:
            this.enterOuterAlt(localctx, 16);
            this.state = 248;
            this.colorstmt();
            break;

        case 17:
            this.enterOuterAlt(localctx, 17);
            this.state = 249;
            this.speedstmt();
            break;

        case 18:
            this.enterOuterAlt(localctx, 18);
            this.state = 250;
            this.scalestmt();
            break;

        case 19:
            this.enterOuterAlt(localctx, 19);
            this.state = 251;
            this.rotstmt();
            break;

        case 20:
            this.enterOuterAlt(localctx, 20);
            this.state = 252;
            this.hcolorstmt();
            break;

        case 21:
            this.enterOuterAlt(localctx, 21);
            this.state = 253;
            this.himemstmt();
            break;

        case 22:
            this.enterOuterAlt(localctx, 22);
            this.state = 254;
            this.lomemstmt();
            break;

        case 23:
            this.enterOuterAlt(localctx, 23);
            this.state = 255;
            this.printstmt1();
            break;

        case 24:
            this.enterOuterAlt(localctx, 24);
            this.state = 256;
            this.pokestmt();
            break;

        case 25:
            this.enterOuterAlt(localctx, 25);
            this.state = 257;
            this.plotstmt();
            break;

        case 26:
            this.enterOuterAlt(localctx, 26);
            this.state = 258;
            this.ongotostmt();
            break;

        case 27:
            this.enterOuterAlt(localctx, 27);
            this.state = 259;
            this.ongosubstmt();
            break;

        case 28:
            this.enterOuterAlt(localctx, 28);
            this.state = 260;
            this.ifstmt();
            break;

        case 29:
            this.enterOuterAlt(localctx, 29);
            this.state = 261;
            this.forstmt();
            break;

        case 30:
            this.enterOuterAlt(localctx, 30);
            this.state = 262;
            this.inputstmt();
            break;

        case 31:
            this.enterOuterAlt(localctx, 31);
            this.state = 263;
            this.tabstmt();
            break;

        case 32:
            this.enterOuterAlt(localctx, 32);
            this.state = 264;
            this.dimstmt();
            break;

        case 33:
            this.enterOuterAlt(localctx, 33);
            this.state = 265;
            this.gotostmt();
            break;

        case 34:
            this.enterOuterAlt(localctx, 34);
            this.state = 266;
            this.gosubstmt();
            break;

        case 35:
            this.enterOuterAlt(localctx, 35);
            this.state = 267;
            this.callstmt();
            break;

        case 36:
            this.enterOuterAlt(localctx, 36);
            this.state = 268;
            this.readstmt();
            break;

        case 37:
            this.enterOuterAlt(localctx, 37);
            this.state = 269;
            this.hplotstmt();
            break;

        case 38:
            this.enterOuterAlt(localctx, 38);
            this.state = 270;
            this.vplotstmt();
            break;

        case 39:
            this.enterOuterAlt(localctx, 39);
            this.state = 271;
            this.vtabstmnt();
            break;

        case 40:
            this.enterOuterAlt(localctx, 40);
            this.state = 272;
            this.htabstmnt();
            break;

        case 41:
            this.enterOuterAlt(localctx, 41);
            this.state = 273;
            this.waitstmt();
            break;

        case 42:
            this.enterOuterAlt(localctx, 42);
            this.state = 274;
            this.datastmt();
            break;

        case 43:
            this.enterOuterAlt(localctx, 43);
            this.state = 275;
            this.xdrawstmt();
            break;

        case 44:
            this.enterOuterAlt(localctx, 44);
            this.state = 276;
            this.drawstmt();
            break;

        case 45:
            this.enterOuterAlt(localctx, 45);
            this.state = 277;
            this.defstmt();
            break;

        case 46:
            this.enterOuterAlt(localctx, 46);
            this.state = 278;
            this.letstmt();
            break;

        case 47:
            this.enterOuterAlt(localctx, 47);
            this.state = 279;
            this.includestmt();
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

function VardeclContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_vardecl;
    return this;
}

VardeclContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
VardeclContext.prototype.constructor = VardeclContext;

VardeclContext.prototype.var = function() {
    return this.getTypedRuleContext(VarContext,0);
};

VardeclContext.prototype.LPAREN = function(i) {
	if(i===undefined) {
		i = null;
	}
    if(i===null) {
        return this.getTokens(jvmBasicParser.LPAREN);
    } else {
        return this.getToken(jvmBasicParser.LPAREN, i);
    }
};


VardeclContext.prototype.exprlist = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(ExprlistContext);
    } else {
        return this.getTypedRuleContext(ExprlistContext,i);
    }
};

VardeclContext.prototype.RPAREN = function(i) {
	if(i===undefined) {
		i = null;
	}
    if(i===null) {
        return this.getTokens(jvmBasicParser.RPAREN);
    } else {
        return this.getToken(jvmBasicParser.RPAREN, i);
    }
};


VardeclContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterVardecl(this);
	}
};

VardeclContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitVardecl(this);
	}
};




jvmBasicParser.VardeclContext = VardeclContext;

jvmBasicParser.prototype.vardecl = function() {

    var localctx = new VardeclContext(this, this._ctx, this.state);
    this.enterRule(localctx, 12, jvmBasicParser.RULE_vardecl);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 282;
        this.var();
        this.state = 289;
        this._errHandler.sync(this);
        var _alt = this._interp.adaptivePredict(this._input,8,this._ctx)
        while(_alt!=2 && _alt!=antlr4.atn.ATN.INVALID_ALT_NUMBER) {
            if(_alt===1) {
                this.state = 283;
                this.match(jvmBasicParser.LPAREN);
                this.state = 284;
                this.exprlist();
                this.state = 285;
                this.match(jvmBasicParser.RPAREN); 
            }
            this.state = 291;
            this._errHandler.sync(this);
            _alt = this._interp.adaptivePredict(this._input,8,this._ctx);
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

function Printstmt1Context(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_printstmt1;
    return this;
}

Printstmt1Context.prototype = Object.create(antlr4.ParserRuleContext.prototype);
Printstmt1Context.prototype.constructor = Printstmt1Context;

Printstmt1Context.prototype.PRINT = function() {
    return this.getToken(jvmBasicParser.PRINT, 0);
};

Printstmt1Context.prototype.QUESTION = function() {
    return this.getToken(jvmBasicParser.QUESTION, 0);
};

Printstmt1Context.prototype.printlist = function() {
    return this.getTypedRuleContext(PrintlistContext,0);
};

Printstmt1Context.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterPrintstmt1(this);
	}
};

Printstmt1Context.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitPrintstmt1(this);
	}
};




jvmBasicParser.Printstmt1Context = Printstmt1Context;

jvmBasicParser.prototype.printstmt1 = function() {

    var localctx = new Printstmt1Context(this, this._ctx, this.state);
    this.enterRule(localctx, 14, jvmBasicParser.RULE_printstmt1);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 292;
        _la = this._input.LA(1);
        if(!(_la===jvmBasicParser.PRINT || _la===jvmBasicParser.QUESTION)) {
        this._errHandler.recoverInline(this);
        }
        else {
            this.consume();
        }
        this.state = 294;
        _la = this._input.LA(1);
        if((((_la) & ~0x1f) == 0 && ((1 << _la) & ((1 << jvmBasicParser.CHR) | (1 << jvmBasicParser.MID) | (1 << jvmBasicParser.LEFT) | (1 << jvmBasicParser.RIGHT) | (1 << jvmBasicParser.STR) | (1 << jvmBasicParser.LPAREN) | (1 << jvmBasicParser.PLUS) | (1 << jvmBasicParser.MINUS))) !== 0) || ((((_la - 40)) & ~0x1f) == 0 && ((1 << (_la - 40)) & ((1 << (jvmBasicParser.SQR - 40)) | (1 << (jvmBasicParser.LEN - 40)) | (1 << (jvmBasicParser.ASC - 40)) | (1 << (jvmBasicParser.PDL - 40)) | (1 << (jvmBasicParser.PEEK - 40)) | (1 << (jvmBasicParser.INTF - 40)) | (1 << (jvmBasicParser.SPC - 40)) | (1 << (jvmBasicParser.FRE - 40)) | (1 << (jvmBasicParser.POS - 40)) | (1 << (jvmBasicParser.USR - 40)))) !== 0) || ((((_la - 83)) & ~0x1f) == 0 && ((1 << (_la - 83)) & ((1 << (jvmBasicParser.FN - 83)) | (1 << (jvmBasicParser.VAL - 83)) | (1 << (jvmBasicParser.SCRN - 83)) | (1 << (jvmBasicParser.SIN - 83)) | (1 << (jvmBasicParser.COS - 83)) | (1 << (jvmBasicParser.TAN - 83)) | (1 << (jvmBasicParser.ATAN - 83)) | (1 << (jvmBasicParser.RND - 83)) | (1 << (jvmBasicParser.SGN - 83)) | (1 << (jvmBasicParser.EXP - 83)) | (1 << (jvmBasicParser.LOG - 83)) | (1 << (jvmBasicParser.ABS - 83)) | (1 << (jvmBasicParser.NOT - 83)))) !== 0) || ((((_la - 118)) & ~0x1f) == 0 && ((1 << (_la - 118)) & ((1 << (jvmBasicParser.STRINGLITERAL - 118)) | (1 << (jvmBasicParser.LETTERS - 118)) | (1 << (jvmBasicParser.NUMBER - 118)) | (1 << (jvmBasicParser.FLOAT - 118)))) !== 0)) {
            this.state = 293;
            this.printlist();
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

function PrintlistContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_printlist;
    return this;
}

PrintlistContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
PrintlistContext.prototype.constructor = PrintlistContext;

PrintlistContext.prototype.expression = function() {
    return this.getTypedRuleContext(ExpressionContext,0);
};

PrintlistContext.prototype.printlist = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(PrintlistContext);
    } else {
        return this.getTypedRuleContext(PrintlistContext,i);
    }
};

PrintlistContext.prototype.COMMA = function() {
    return this.getToken(jvmBasicParser.COMMA, 0);
};

PrintlistContext.prototype.SEMICOLON = function() {
    return this.getToken(jvmBasicParser.SEMICOLON, 0);
};

PrintlistContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterPrintlist(this);
	}
};

PrintlistContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitPrintlist(this);
	}
};




jvmBasicParser.PrintlistContext = PrintlistContext;

jvmBasicParser.prototype.printlist = function() {

    var localctx = new PrintlistContext(this, this._ctx, this.state);
    this.enterRule(localctx, 16, jvmBasicParser.RULE_printlist);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 296;
        this.expression();
        this.state = 298;
        _la = this._input.LA(1);
        if(_la===jvmBasicParser.COMMA || _la===jvmBasicParser.SEMICOLON) {
            this.state = 297;
            _la = this._input.LA(1);
            if(!(_la===jvmBasicParser.COMMA || _la===jvmBasicParser.SEMICOLON)) {
            this._errHandler.recoverInline(this);
            }
            else {
                this.consume();
            }
        }

        this.state = 303;
        this._errHandler.sync(this);
        var _alt = this._interp.adaptivePredict(this._input,11,this._ctx)
        while(_alt!=2 && _alt!=antlr4.atn.ATN.INVALID_ALT_NUMBER) {
            if(_alt===1) {
                this.state = 300;
                this.printlist(); 
            }
            this.state = 305;
            this._errHandler.sync(this);
            _alt = this._interp.adaptivePredict(this._input,11,this._ctx);
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

function GetstmtContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_getstmt;
    return this;
}

GetstmtContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
GetstmtContext.prototype.constructor = GetstmtContext;

GetstmtContext.prototype.GET = function() {
    return this.getToken(jvmBasicParser.GET, 0);
};

GetstmtContext.prototype.exprlist = function() {
    return this.getTypedRuleContext(ExprlistContext,0);
};

GetstmtContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterGetstmt(this);
	}
};

GetstmtContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitGetstmt(this);
	}
};




jvmBasicParser.GetstmtContext = GetstmtContext;

jvmBasicParser.prototype.getstmt = function() {

    var localctx = new GetstmtContext(this, this._ctx, this.state);
    this.enterRule(localctx, 18, jvmBasicParser.RULE_getstmt);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 306;
        this.match(jvmBasicParser.GET);
        this.state = 307;
        this.exprlist();
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

function LetstmtContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_letstmt;
    return this;
}

LetstmtContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
LetstmtContext.prototype.constructor = LetstmtContext;

LetstmtContext.prototype.variableassignment = function() {
    return this.getTypedRuleContext(VariableassignmentContext,0);
};

LetstmtContext.prototype.LET = function() {
    return this.getToken(jvmBasicParser.LET, 0);
};

LetstmtContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterLetstmt(this);
	}
};

LetstmtContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitLetstmt(this);
	}
};




jvmBasicParser.LetstmtContext = LetstmtContext;

jvmBasicParser.prototype.letstmt = function() {

    var localctx = new LetstmtContext(this, this._ctx, this.state);
    this.enterRule(localctx, 20, jvmBasicParser.RULE_letstmt);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 310;
        _la = this._input.LA(1);
        if(_la===jvmBasicParser.LET) {
            this.state = 309;
            this.match(jvmBasicParser.LET);
        }

        this.state = 312;
        this.variableassignment();
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

function VariableassignmentContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_variableassignment;
    return this;
}

VariableassignmentContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
VariableassignmentContext.prototype.constructor = VariableassignmentContext;

VariableassignmentContext.prototype.vardecl = function() {
    return this.getTypedRuleContext(VardeclContext,0);
};

VariableassignmentContext.prototype.EQ = function() {
    return this.getToken(jvmBasicParser.EQ, 0);
};

VariableassignmentContext.prototype.exprlist = function() {
    return this.getTypedRuleContext(ExprlistContext,0);
};

VariableassignmentContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterVariableassignment(this);
	}
};

VariableassignmentContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitVariableassignment(this);
	}
};




jvmBasicParser.VariableassignmentContext = VariableassignmentContext;

jvmBasicParser.prototype.variableassignment = function() {

    var localctx = new VariableassignmentContext(this, this._ctx, this.state);
    this.enterRule(localctx, 22, jvmBasicParser.RULE_variableassignment);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 314;
        this.vardecl();
        this.state = 315;
        this.match(jvmBasicParser.EQ);
        this.state = 316;
        this.exprlist();
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

function RelopContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_relop;
    return this;
}

RelopContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
RelopContext.prototype.constructor = RelopContext;

RelopContext.prototype.lte = function() {
    return this.getTypedRuleContext(LteContext,0);
};

RelopContext.prototype.gte = function() {
    return this.getTypedRuleContext(GteContext,0);
};

RelopContext.prototype.neq = function() {
    return this.getTypedRuleContext(NeqContext,0);
};

RelopContext.prototype.EQ = function() {
    return this.getToken(jvmBasicParser.EQ, 0);
};

RelopContext.prototype.GT = function() {
    return this.getToken(jvmBasicParser.GT, 0);
};

RelopContext.prototype.LT = function() {
    return this.getToken(jvmBasicParser.LT, 0);
};

RelopContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterRelop(this);
	}
};

RelopContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitRelop(this);
	}
};




jvmBasicParser.RelopContext = RelopContext;

jvmBasicParser.prototype.relop = function() {

    var localctx = new RelopContext(this, this._ctx, this.state);
    this.enterRule(localctx, 24, jvmBasicParser.RULE_relop);
    var _la = 0; // Token type
    try {
        this.state = 322;
        var la_ = this._interp.adaptivePredict(this._input,13,this._ctx);
        switch(la_) {
        case 1:
            this.enterOuterAlt(localctx, 1);
            this.state = 318;
            this.lte();
            break;

        case 2:
            this.enterOuterAlt(localctx, 2);
            this.state = 319;
            this.gte();
            break;

        case 3:
            this.enterOuterAlt(localctx, 3);
            this.state = 320;
            this.neq();
            break;

        case 4:
            this.enterOuterAlt(localctx, 4);
            this.state = 321;
            _la = this._input.LA(1);
            if(!(((((_la - 25)) & ~0x1f) == 0 && ((1 << (_la - 25)) & ((1 << (jvmBasicParser.GT - 25)) | (1 << (jvmBasicParser.LT - 25)) | (1 << (jvmBasicParser.EQ - 25)))) !== 0))) {
            this._errHandler.recoverInline(this);
            }
            else {
                this.consume();
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

function GteContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_gte;
    return this;
}

GteContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
GteContext.prototype.constructor = GteContext;

GteContext.prototype.GTE = function() {
    return this.getToken(jvmBasicParser.GTE, 0);
};

GteContext.prototype.GT = function() {
    return this.getToken(jvmBasicParser.GT, 0);
};

GteContext.prototype.EQ = function() {
    return this.getToken(jvmBasicParser.EQ, 0);
};

GteContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterGte(this);
	}
};

GteContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitGte(this);
	}
};




jvmBasicParser.GteContext = GteContext;

jvmBasicParser.prototype.gte = function() {

    var localctx = new GteContext(this, this._ctx, this.state);
    this.enterRule(localctx, 26, jvmBasicParser.RULE_gte);
    try {
        this.state = 329;
        switch(this._input.LA(1)) {
        case jvmBasicParser.GTE:
            this.enterOuterAlt(localctx, 1);
            this.state = 324;
            this.match(jvmBasicParser.GTE);
            break;
        case jvmBasicParser.GT:
            this.enterOuterAlt(localctx, 2);
            this.state = 325;
            this.match(jvmBasicParser.GT);
            this.state = 326;
            this.match(jvmBasicParser.EQ);
            break;
        case jvmBasicParser.EQ:
            this.enterOuterAlt(localctx, 3);
            this.state = 327;
            this.match(jvmBasicParser.EQ);
            this.state = 328;
            this.match(jvmBasicParser.GT);
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

function LteContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_lte;
    return this;
}

LteContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
LteContext.prototype.constructor = LteContext;

LteContext.prototype.LTE = function() {
    return this.getToken(jvmBasicParser.LTE, 0);
};

LteContext.prototype.LT = function() {
    return this.getToken(jvmBasicParser.LT, 0);
};

LteContext.prototype.EQ = function() {
    return this.getToken(jvmBasicParser.EQ, 0);
};

LteContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterLte(this);
	}
};

LteContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitLte(this);
	}
};




jvmBasicParser.LteContext = LteContext;

jvmBasicParser.prototype.lte = function() {

    var localctx = new LteContext(this, this._ctx, this.state);
    this.enterRule(localctx, 28, jvmBasicParser.RULE_lte);
    try {
        this.state = 336;
        switch(this._input.LA(1)) {
        case jvmBasicParser.LTE:
            this.enterOuterAlt(localctx, 1);
            this.state = 331;
            this.match(jvmBasicParser.LTE);
            break;
        case jvmBasicParser.LT:
            this.enterOuterAlt(localctx, 2);
            this.state = 332;
            this.match(jvmBasicParser.LT);
            this.state = 333;
            this.match(jvmBasicParser.EQ);
            break;
        case jvmBasicParser.EQ:
            this.enterOuterAlt(localctx, 3);
            this.state = 334;
            this.match(jvmBasicParser.EQ);
            this.state = 335;
            this.match(jvmBasicParser.LT);
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

function NeqContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_neq;
    return this;
}

NeqContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
NeqContext.prototype.constructor = NeqContext;

NeqContext.prototype.NEQ = function() {
    return this.getToken(jvmBasicParser.NEQ, 0);
};

NeqContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterNeq(this);
	}
};

NeqContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitNeq(this);
	}
};




jvmBasicParser.NeqContext = NeqContext;

jvmBasicParser.prototype.neq = function() {

    var localctx = new NeqContext(this, this._ctx, this.state);
    this.enterRule(localctx, 30, jvmBasicParser.RULE_neq);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 338;
        this.match(jvmBasicParser.NEQ);
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

function IfstmtContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_ifstmt;
    return this;
}

IfstmtContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
IfstmtContext.prototype.constructor = IfstmtContext;

IfstmtContext.prototype.IF = function() {
    return this.getToken(jvmBasicParser.IF, 0);
};

IfstmtContext.prototype.expression = function() {
    return this.getTypedRuleContext(ExpressionContext,0);
};

IfstmtContext.prototype.statement = function() {
    return this.getTypedRuleContext(StatementContext,0);
};

IfstmtContext.prototype.linenumber = function() {
    return this.getTypedRuleContext(LinenumberContext,0);
};

IfstmtContext.prototype.THEN = function() {
    return this.getToken(jvmBasicParser.THEN, 0);
};

IfstmtContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterIfstmt(this);
	}
};

IfstmtContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitIfstmt(this);
	}
};




jvmBasicParser.IfstmtContext = IfstmtContext;

jvmBasicParser.prototype.ifstmt = function() {

    var localctx = new IfstmtContext(this, this._ctx, this.state);
    this.enterRule(localctx, 32, jvmBasicParser.RULE_ifstmt);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 340;
        this.match(jvmBasicParser.IF);
        this.state = 341;
        this.expression();
        this.state = 343;
        _la = this._input.LA(1);
        if(_la===jvmBasicParser.THEN) {
            this.state = 342;
            this.match(jvmBasicParser.THEN);
        }

        this.state = 347;
        switch(this._input.LA(1)) {
        case jvmBasicParser.RETURN:
        case jvmBasicParser.PRINT:
        case jvmBasicParser.GOTO:
        case jvmBasicParser.GOSUB:
        case jvmBasicParser.IF:
        case jvmBasicParser.CLEAR:
        case jvmBasicParser.LIST:
        case jvmBasicParser.RUN:
        case jvmBasicParser.END:
        case jvmBasicParser.LET:
        case jvmBasicParser.FOR:
        case jvmBasicParser.INPUT:
        case jvmBasicParser.DIM:
        case jvmBasicParser.TEXT:
        case jvmBasicParser.HGR:
        case jvmBasicParser.HGR2:
        case jvmBasicParser.CALL:
        case jvmBasicParser.HPLOT:
        case jvmBasicParser.VPLOT:
        case jvmBasicParser.PRNUMBER:
        case jvmBasicParser.INNUMBER:
        case jvmBasicParser.VTAB:
        case jvmBasicParser.HTAB:
        case jvmBasicParser.HOME:
        case jvmBasicParser.ON:
        case jvmBasicParser.PLOT:
        case jvmBasicParser.POKE:
        case jvmBasicParser.STOP:
        case jvmBasicParser.HIMEM:
        case jvmBasicParser.LOMEM:
        case jvmBasicParser.FLASH:
        case jvmBasicParser.INVERSE:
        case jvmBasicParser.NORMAL:
        case jvmBasicParser.ONERR:
        case jvmBasicParser.TRACE:
        case jvmBasicParser.NOTRACE:
        case jvmBasicParser.DATA:
        case jvmBasicParser.WAIT:
        case jvmBasicParser.READ:
        case jvmBasicParser.XDRAW:
        case jvmBasicParser.DRAW:
        case jvmBasicParser.DEF:
        case jvmBasicParser.TAB:
        case jvmBasicParser.SPEED:
        case jvmBasicParser.ROT:
        case jvmBasicParser.SCALE:
        case jvmBasicParser.COLOR:
        case jvmBasicParser.HCOLOR:
        case jvmBasicParser.HLIN:
        case jvmBasicParser.VLIN:
        case jvmBasicParser.POP:
        case jvmBasicParser.SHLOAD:
        case jvmBasicParser.STORE:
        case jvmBasicParser.RECALL:
        case jvmBasicParser.GET:
        case jvmBasicParser.AMPERSAND:
        case jvmBasicParser.GR:
        case jvmBasicParser.RESTORE:
        case jvmBasicParser.SAVE:
        case jvmBasicParser.LOAD:
        case jvmBasicParser.QUESTION:
        case jvmBasicParser.INCLUDE:
        case jvmBasicParser.LETTERS:
            this.state = 345;
            this.statement();
            break;
        case jvmBasicParser.NUMBER:
            this.state = 346;
            this.linenumber();
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

function ForstmtContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_forstmt;
    return this;
}

ForstmtContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
ForstmtContext.prototype.constructor = ForstmtContext;

ForstmtContext.prototype.FOR = function() {
    return this.getToken(jvmBasicParser.FOR, 0);
};

ForstmtContext.prototype.vardecl = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(VardeclContext);
    } else {
        return this.getTypedRuleContext(VardeclContext,i);
    }
};

ForstmtContext.prototype.EQ = function() {
    return this.getToken(jvmBasicParser.EQ, 0);
};

ForstmtContext.prototype.expression = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(ExpressionContext);
    } else {
        return this.getTypedRuleContext(ExpressionContext,i);
    }
};

ForstmtContext.prototype.TO = function() {
    return this.getToken(jvmBasicParser.TO, 0);
};

ForstmtContext.prototype.statement = function() {
    return this.getTypedRuleContext(StatementContext,0);
};

ForstmtContext.prototype.NEXT = function() {
    return this.getToken(jvmBasicParser.NEXT, 0);
};

ForstmtContext.prototype.STEP = function() {
    return this.getToken(jvmBasicParser.STEP, 0);
};

ForstmtContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterForstmt(this);
	}
};

ForstmtContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitForstmt(this);
	}
};




jvmBasicParser.ForstmtContext = ForstmtContext;

jvmBasicParser.prototype.forstmt = function() {

    var localctx = new ForstmtContext(this, this._ctx, this.state);
    this.enterRule(localctx, 34, jvmBasicParser.RULE_forstmt);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 349;
        this.match(jvmBasicParser.FOR);
        this.state = 350;
        this.vardecl();
        this.state = 351;
        this.match(jvmBasicParser.EQ);
        this.state = 352;
        this.expression();
        this.state = 353;
        this.match(jvmBasicParser.TO);
        this.state = 354;
        this.expression();
        this.state = 357;
        _la = this._input.LA(1);
        if(_la===jvmBasicParser.STEP) {
            this.state = 355;
            this.match(jvmBasicParser.STEP);
            this.state = 356;
            this.expression();
        }

        this.state = 359;
        this.statement();
        this.state = 360;
        this.match(jvmBasicParser.NEXT);
        this.state = 362;
        _la = this._input.LA(1);
        if(_la===jvmBasicParser.LETTERS) {
            this.state = 361;
            this.vardecl();
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

function InputstmtContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_inputstmt;
    return this;
}

InputstmtContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
InputstmtContext.prototype.constructor = InputstmtContext;

InputstmtContext.prototype.INPUT = function() {
    return this.getToken(jvmBasicParser.INPUT, 0);
};

InputstmtContext.prototype.varlist = function() {
    return this.getTypedRuleContext(VarlistContext,0);
};

InputstmtContext.prototype.STRINGLITERAL = function() {
    return this.getToken(jvmBasicParser.STRINGLITERAL, 0);
};

InputstmtContext.prototype.COMMA = function() {
    return this.getToken(jvmBasicParser.COMMA, 0);
};

InputstmtContext.prototype.SEMICOLON = function() {
    return this.getToken(jvmBasicParser.SEMICOLON, 0);
};

InputstmtContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterInputstmt(this);
	}
};

InputstmtContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitInputstmt(this);
	}
};




jvmBasicParser.InputstmtContext = InputstmtContext;

jvmBasicParser.prototype.inputstmt = function() {

    var localctx = new InputstmtContext(this, this._ctx, this.state);
    this.enterRule(localctx, 36, jvmBasicParser.RULE_inputstmt);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 364;
        this.match(jvmBasicParser.INPUT);
        this.state = 367;
        _la = this._input.LA(1);
        if(_la===jvmBasicParser.STRINGLITERAL) {
            this.state = 365;
            this.match(jvmBasicParser.STRINGLITERAL);
            this.state = 366;
            _la = this._input.LA(1);
            if(!(_la===jvmBasicParser.COMMA || _la===jvmBasicParser.SEMICOLON)) {
            this._errHandler.recoverInline(this);
            }
            else {
                this.consume();
            }
        }

        this.state = 369;
        this.varlist();
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

function ReadstmtContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_readstmt;
    return this;
}

ReadstmtContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
ReadstmtContext.prototype.constructor = ReadstmtContext;

ReadstmtContext.prototype.READ = function() {
    return this.getToken(jvmBasicParser.READ, 0);
};

ReadstmtContext.prototype.varlist = function() {
    return this.getTypedRuleContext(VarlistContext,0);
};

ReadstmtContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterReadstmt(this);
	}
};

ReadstmtContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitReadstmt(this);
	}
};




jvmBasicParser.ReadstmtContext = ReadstmtContext;

jvmBasicParser.prototype.readstmt = function() {

    var localctx = new ReadstmtContext(this, this._ctx, this.state);
    this.enterRule(localctx, 38, jvmBasicParser.RULE_readstmt);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 371;
        this.match(jvmBasicParser.READ);
        this.state = 372;
        this.varlist();
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

function DimstmtContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_dimstmt;
    return this;
}

DimstmtContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
DimstmtContext.prototype.constructor = DimstmtContext;

DimstmtContext.prototype.DIM = function() {
    return this.getToken(jvmBasicParser.DIM, 0);
};

DimstmtContext.prototype.varlist = function() {
    return this.getTypedRuleContext(VarlistContext,0);
};

DimstmtContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterDimstmt(this);
	}
};

DimstmtContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitDimstmt(this);
	}
};




jvmBasicParser.DimstmtContext = DimstmtContext;

jvmBasicParser.prototype.dimstmt = function() {

    var localctx = new DimstmtContext(this, this._ctx, this.state);
    this.enterRule(localctx, 40, jvmBasicParser.RULE_dimstmt);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 374;
        this.match(jvmBasicParser.DIM);
        this.state = 375;
        this.varlist();
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

function GotostmtContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_gotostmt;
    return this;
}

GotostmtContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
GotostmtContext.prototype.constructor = GotostmtContext;

GotostmtContext.prototype.GOTO = function() {
    return this.getToken(jvmBasicParser.GOTO, 0);
};

GotostmtContext.prototype.linenumber = function() {
    return this.getTypedRuleContext(LinenumberContext,0);
};

GotostmtContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterGotostmt(this);
	}
};

GotostmtContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitGotostmt(this);
	}
};




jvmBasicParser.GotostmtContext = GotostmtContext;

jvmBasicParser.prototype.gotostmt = function() {

    var localctx = new GotostmtContext(this, this._ctx, this.state);
    this.enterRule(localctx, 42, jvmBasicParser.RULE_gotostmt);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 377;
        this.match(jvmBasicParser.GOTO);
        this.state = 378;
        this.linenumber();
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

function GosubstmtContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_gosubstmt;
    return this;
}

GosubstmtContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
GosubstmtContext.prototype.constructor = GosubstmtContext;

GosubstmtContext.prototype.GOSUB = function() {
    return this.getToken(jvmBasicParser.GOSUB, 0);
};

GosubstmtContext.prototype.linenumber = function() {
    return this.getTypedRuleContext(LinenumberContext,0);
};

GosubstmtContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterGosubstmt(this);
	}
};

GosubstmtContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitGosubstmt(this);
	}
};




jvmBasicParser.GosubstmtContext = GosubstmtContext;

jvmBasicParser.prototype.gosubstmt = function() {

    var localctx = new GosubstmtContext(this, this._ctx, this.state);
    this.enterRule(localctx, 44, jvmBasicParser.RULE_gosubstmt);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 380;
        this.match(jvmBasicParser.GOSUB);
        this.state = 381;
        this.linenumber();
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

function PokestmtContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_pokestmt;
    return this;
}

PokestmtContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
PokestmtContext.prototype.constructor = PokestmtContext;

PokestmtContext.prototype.POKE = function() {
    return this.getToken(jvmBasicParser.POKE, 0);
};

PokestmtContext.prototype.expression = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(ExpressionContext);
    } else {
        return this.getTypedRuleContext(ExpressionContext,i);
    }
};

PokestmtContext.prototype.COMMA = function() {
    return this.getToken(jvmBasicParser.COMMA, 0);
};

PokestmtContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterPokestmt(this);
	}
};

PokestmtContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitPokestmt(this);
	}
};




jvmBasicParser.PokestmtContext = PokestmtContext;

jvmBasicParser.prototype.pokestmt = function() {

    var localctx = new PokestmtContext(this, this._ctx, this.state);
    this.enterRule(localctx, 46, jvmBasicParser.RULE_pokestmt);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 383;
        this.match(jvmBasicParser.POKE);
        this.state = 384;
        this.expression();
        this.state = 385;
        this.match(jvmBasicParser.COMMA);
        this.state = 386;
        this.expression();
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

function CallstmtContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_callstmt;
    return this;
}

CallstmtContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
CallstmtContext.prototype.constructor = CallstmtContext;

CallstmtContext.prototype.CALL = function() {
    return this.getToken(jvmBasicParser.CALL, 0);
};

CallstmtContext.prototype.exprlist = function() {
    return this.getTypedRuleContext(ExprlistContext,0);
};

CallstmtContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterCallstmt(this);
	}
};

CallstmtContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitCallstmt(this);
	}
};




jvmBasicParser.CallstmtContext = CallstmtContext;

jvmBasicParser.prototype.callstmt = function() {

    var localctx = new CallstmtContext(this, this._ctx, this.state);
    this.enterRule(localctx, 48, jvmBasicParser.RULE_callstmt);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 388;
        this.match(jvmBasicParser.CALL);
        this.state = 389;
        this.exprlist();
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

function HplotstmtContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_hplotstmt;
    return this;
}

HplotstmtContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
HplotstmtContext.prototype.constructor = HplotstmtContext;

HplotstmtContext.prototype.HPLOT = function() {
    return this.getToken(jvmBasicParser.HPLOT, 0);
};

HplotstmtContext.prototype.expression = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(ExpressionContext);
    } else {
        return this.getTypedRuleContext(ExpressionContext,i);
    }
};

HplotstmtContext.prototype.COMMA = function(i) {
	if(i===undefined) {
		i = null;
	}
    if(i===null) {
        return this.getTokens(jvmBasicParser.COMMA);
    } else {
        return this.getToken(jvmBasicParser.COMMA, i);
    }
};


HplotstmtContext.prototype.TO = function(i) {
	if(i===undefined) {
		i = null;
	}
    if(i===null) {
        return this.getTokens(jvmBasicParser.TO);
    } else {
        return this.getToken(jvmBasicParser.TO, i);
    }
};


HplotstmtContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterHplotstmt(this);
	}
};

HplotstmtContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitHplotstmt(this);
	}
};




jvmBasicParser.HplotstmtContext = HplotstmtContext;

jvmBasicParser.prototype.hplotstmt = function() {

    var localctx = new HplotstmtContext(this, this._ctx, this.state);
    this.enterRule(localctx, 50, jvmBasicParser.RULE_hplotstmt);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 391;
        this.match(jvmBasicParser.HPLOT);
        this.state = 396;
        _la = this._input.LA(1);
        if((((_la) & ~0x1f) == 0 && ((1 << _la) & ((1 << jvmBasicParser.CHR) | (1 << jvmBasicParser.MID) | (1 << jvmBasicParser.LEFT) | (1 << jvmBasicParser.RIGHT) | (1 << jvmBasicParser.STR) | (1 << jvmBasicParser.LPAREN) | (1 << jvmBasicParser.PLUS) | (1 << jvmBasicParser.MINUS))) !== 0) || ((((_la - 40)) & ~0x1f) == 0 && ((1 << (_la - 40)) & ((1 << (jvmBasicParser.SQR - 40)) | (1 << (jvmBasicParser.LEN - 40)) | (1 << (jvmBasicParser.ASC - 40)) | (1 << (jvmBasicParser.PDL - 40)) | (1 << (jvmBasicParser.PEEK - 40)) | (1 << (jvmBasicParser.INTF - 40)) | (1 << (jvmBasicParser.SPC - 40)) | (1 << (jvmBasicParser.FRE - 40)) | (1 << (jvmBasicParser.POS - 40)) | (1 << (jvmBasicParser.USR - 40)))) !== 0) || ((((_la - 83)) & ~0x1f) == 0 && ((1 << (_la - 83)) & ((1 << (jvmBasicParser.FN - 83)) | (1 << (jvmBasicParser.VAL - 83)) | (1 << (jvmBasicParser.SCRN - 83)) | (1 << (jvmBasicParser.SIN - 83)) | (1 << (jvmBasicParser.COS - 83)) | (1 << (jvmBasicParser.TAN - 83)) | (1 << (jvmBasicParser.ATAN - 83)) | (1 << (jvmBasicParser.RND - 83)) | (1 << (jvmBasicParser.SGN - 83)) | (1 << (jvmBasicParser.EXP - 83)) | (1 << (jvmBasicParser.LOG - 83)) | (1 << (jvmBasicParser.ABS - 83)) | (1 << (jvmBasicParser.NOT - 83)))) !== 0) || ((((_la - 118)) & ~0x1f) == 0 && ((1 << (_la - 118)) & ((1 << (jvmBasicParser.STRINGLITERAL - 118)) | (1 << (jvmBasicParser.LETTERS - 118)) | (1 << (jvmBasicParser.NUMBER - 118)) | (1 << (jvmBasicParser.FLOAT - 118)))) !== 0)) {
            this.state = 392;
            this.expression();
            this.state = 393;
            this.match(jvmBasicParser.COMMA);
            this.state = 394;
            this.expression();
        }

        this.state = 405;
        this._errHandler.sync(this);
        _la = this._input.LA(1);
        while(_la===jvmBasicParser.TO) {
            this.state = 398;
            this.match(jvmBasicParser.TO);
            this.state = 399;
            this.expression();
            this.state = 400;
            this.match(jvmBasicParser.COMMA);
            this.state = 401;
            this.expression();
            this.state = 407;
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

function VplotstmtContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_vplotstmt;
    return this;
}

VplotstmtContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
VplotstmtContext.prototype.constructor = VplotstmtContext;

VplotstmtContext.prototype.VPLOT = function() {
    return this.getToken(jvmBasicParser.VPLOT, 0);
};

VplotstmtContext.prototype.expression = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(ExpressionContext);
    } else {
        return this.getTypedRuleContext(ExpressionContext,i);
    }
};

VplotstmtContext.prototype.COMMA = function(i) {
	if(i===undefined) {
		i = null;
	}
    if(i===null) {
        return this.getTokens(jvmBasicParser.COMMA);
    } else {
        return this.getToken(jvmBasicParser.COMMA, i);
    }
};


VplotstmtContext.prototype.TO = function(i) {
	if(i===undefined) {
		i = null;
	}
    if(i===null) {
        return this.getTokens(jvmBasicParser.TO);
    } else {
        return this.getToken(jvmBasicParser.TO, i);
    }
};


VplotstmtContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterVplotstmt(this);
	}
};

VplotstmtContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitVplotstmt(this);
	}
};




jvmBasicParser.VplotstmtContext = VplotstmtContext;

jvmBasicParser.prototype.vplotstmt = function() {

    var localctx = new VplotstmtContext(this, this._ctx, this.state);
    this.enterRule(localctx, 52, jvmBasicParser.RULE_vplotstmt);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 408;
        this.match(jvmBasicParser.VPLOT);
        this.state = 413;
        _la = this._input.LA(1);
        if((((_la) & ~0x1f) == 0 && ((1 << _la) & ((1 << jvmBasicParser.CHR) | (1 << jvmBasicParser.MID) | (1 << jvmBasicParser.LEFT) | (1 << jvmBasicParser.RIGHT) | (1 << jvmBasicParser.STR) | (1 << jvmBasicParser.LPAREN) | (1 << jvmBasicParser.PLUS) | (1 << jvmBasicParser.MINUS))) !== 0) || ((((_la - 40)) & ~0x1f) == 0 && ((1 << (_la - 40)) & ((1 << (jvmBasicParser.SQR - 40)) | (1 << (jvmBasicParser.LEN - 40)) | (1 << (jvmBasicParser.ASC - 40)) | (1 << (jvmBasicParser.PDL - 40)) | (1 << (jvmBasicParser.PEEK - 40)) | (1 << (jvmBasicParser.INTF - 40)) | (1 << (jvmBasicParser.SPC - 40)) | (1 << (jvmBasicParser.FRE - 40)) | (1 << (jvmBasicParser.POS - 40)) | (1 << (jvmBasicParser.USR - 40)))) !== 0) || ((((_la - 83)) & ~0x1f) == 0 && ((1 << (_la - 83)) & ((1 << (jvmBasicParser.FN - 83)) | (1 << (jvmBasicParser.VAL - 83)) | (1 << (jvmBasicParser.SCRN - 83)) | (1 << (jvmBasicParser.SIN - 83)) | (1 << (jvmBasicParser.COS - 83)) | (1 << (jvmBasicParser.TAN - 83)) | (1 << (jvmBasicParser.ATAN - 83)) | (1 << (jvmBasicParser.RND - 83)) | (1 << (jvmBasicParser.SGN - 83)) | (1 << (jvmBasicParser.EXP - 83)) | (1 << (jvmBasicParser.LOG - 83)) | (1 << (jvmBasicParser.ABS - 83)) | (1 << (jvmBasicParser.NOT - 83)))) !== 0) || ((((_la - 118)) & ~0x1f) == 0 && ((1 << (_la - 118)) & ((1 << (jvmBasicParser.STRINGLITERAL - 118)) | (1 << (jvmBasicParser.LETTERS - 118)) | (1 << (jvmBasicParser.NUMBER - 118)) | (1 << (jvmBasicParser.FLOAT - 118)))) !== 0)) {
            this.state = 409;
            this.expression();
            this.state = 410;
            this.match(jvmBasicParser.COMMA);
            this.state = 411;
            this.expression();
        }

        this.state = 422;
        this._errHandler.sync(this);
        _la = this._input.LA(1);
        while(_la===jvmBasicParser.TO) {
            this.state = 415;
            this.match(jvmBasicParser.TO);
            this.state = 416;
            this.expression();
            this.state = 417;
            this.match(jvmBasicParser.COMMA);
            this.state = 418;
            this.expression();
            this.state = 424;
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

function PlotstmtContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_plotstmt;
    return this;
}

PlotstmtContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
PlotstmtContext.prototype.constructor = PlotstmtContext;

PlotstmtContext.prototype.PLOT = function() {
    return this.getToken(jvmBasicParser.PLOT, 0);
};

PlotstmtContext.prototype.expression = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(ExpressionContext);
    } else {
        return this.getTypedRuleContext(ExpressionContext,i);
    }
};

PlotstmtContext.prototype.COMMA = function() {
    return this.getToken(jvmBasicParser.COMMA, 0);
};

PlotstmtContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterPlotstmt(this);
	}
};

PlotstmtContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitPlotstmt(this);
	}
};




jvmBasicParser.PlotstmtContext = PlotstmtContext;

jvmBasicParser.prototype.plotstmt = function() {

    var localctx = new PlotstmtContext(this, this._ctx, this.state);
    this.enterRule(localctx, 54, jvmBasicParser.RULE_plotstmt);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 425;
        this.match(jvmBasicParser.PLOT);
        this.state = 426;
        this.expression();
        this.state = 427;
        this.match(jvmBasicParser.COMMA);
        this.state = 428;
        this.expression();
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

function OngotostmtContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_ongotostmt;
    return this;
}

OngotostmtContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
OngotostmtContext.prototype.constructor = OngotostmtContext;

OngotostmtContext.prototype.ON = function() {
    return this.getToken(jvmBasicParser.ON, 0);
};

OngotostmtContext.prototype.expression = function() {
    return this.getTypedRuleContext(ExpressionContext,0);
};

OngotostmtContext.prototype.GOTO = function() {
    return this.getToken(jvmBasicParser.GOTO, 0);
};

OngotostmtContext.prototype.linenumber = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(LinenumberContext);
    } else {
        return this.getTypedRuleContext(LinenumberContext,i);
    }
};

OngotostmtContext.prototype.COMMA = function(i) {
	if(i===undefined) {
		i = null;
	}
    if(i===null) {
        return this.getTokens(jvmBasicParser.COMMA);
    } else {
        return this.getToken(jvmBasicParser.COMMA, i);
    }
};


OngotostmtContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterOngotostmt(this);
	}
};

OngotostmtContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitOngotostmt(this);
	}
};




jvmBasicParser.OngotostmtContext = OngotostmtContext;

jvmBasicParser.prototype.ongotostmt = function() {

    var localctx = new OngotostmtContext(this, this._ctx, this.state);
    this.enterRule(localctx, 56, jvmBasicParser.RULE_ongotostmt);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 430;
        this.match(jvmBasicParser.ON);
        this.state = 431;
        this.expression();
        this.state = 432;
        this.match(jvmBasicParser.GOTO);
        this.state = 433;
        this.linenumber();
        this.state = 438;
        this._errHandler.sync(this);
        _la = this._input.LA(1);
        while(_la===jvmBasicParser.COMMA) {
            this.state = 434;
            this.match(jvmBasicParser.COMMA);
            this.state = 435;
            this.linenumber();
            this.state = 440;
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

function OngosubstmtContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_ongosubstmt;
    return this;
}

OngosubstmtContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
OngosubstmtContext.prototype.constructor = OngosubstmtContext;

OngosubstmtContext.prototype.ON = function() {
    return this.getToken(jvmBasicParser.ON, 0);
};

OngosubstmtContext.prototype.expression = function() {
    return this.getTypedRuleContext(ExpressionContext,0);
};

OngosubstmtContext.prototype.GOSUB = function() {
    return this.getToken(jvmBasicParser.GOSUB, 0);
};

OngosubstmtContext.prototype.linenumber = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(LinenumberContext);
    } else {
        return this.getTypedRuleContext(LinenumberContext,i);
    }
};

OngosubstmtContext.prototype.COMMA = function(i) {
	if(i===undefined) {
		i = null;
	}
    if(i===null) {
        return this.getTokens(jvmBasicParser.COMMA);
    } else {
        return this.getToken(jvmBasicParser.COMMA, i);
    }
};


OngosubstmtContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterOngosubstmt(this);
	}
};

OngosubstmtContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitOngosubstmt(this);
	}
};




jvmBasicParser.OngosubstmtContext = OngosubstmtContext;

jvmBasicParser.prototype.ongosubstmt = function() {

    var localctx = new OngosubstmtContext(this, this._ctx, this.state);
    this.enterRule(localctx, 58, jvmBasicParser.RULE_ongosubstmt);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 441;
        this.match(jvmBasicParser.ON);
        this.state = 442;
        this.expression();
        this.state = 443;
        this.match(jvmBasicParser.GOSUB);
        this.state = 444;
        this.linenumber();
        this.state = 449;
        this._errHandler.sync(this);
        _la = this._input.LA(1);
        while(_la===jvmBasicParser.COMMA) {
            this.state = 445;
            this.match(jvmBasicParser.COMMA);
            this.state = 446;
            this.linenumber();
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

function VtabstmntContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_vtabstmnt;
    return this;
}

VtabstmntContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
VtabstmntContext.prototype.constructor = VtabstmntContext;

VtabstmntContext.prototype.VTAB = function() {
    return this.getToken(jvmBasicParser.VTAB, 0);
};

VtabstmntContext.prototype.expression = function() {
    return this.getTypedRuleContext(ExpressionContext,0);
};

VtabstmntContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterVtabstmnt(this);
	}
};

VtabstmntContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitVtabstmnt(this);
	}
};




jvmBasicParser.VtabstmntContext = VtabstmntContext;

jvmBasicParser.prototype.vtabstmnt = function() {

    var localctx = new VtabstmntContext(this, this._ctx, this.state);
    this.enterRule(localctx, 60, jvmBasicParser.RULE_vtabstmnt);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 452;
        this.match(jvmBasicParser.VTAB);
        this.state = 453;
        this.expression();
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

function HtabstmntContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_htabstmnt;
    return this;
}

HtabstmntContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
HtabstmntContext.prototype.constructor = HtabstmntContext;

HtabstmntContext.prototype.HTAB = function() {
    return this.getToken(jvmBasicParser.HTAB, 0);
};

HtabstmntContext.prototype.expression = function() {
    return this.getTypedRuleContext(ExpressionContext,0);
};

HtabstmntContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterHtabstmnt(this);
	}
};

HtabstmntContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitHtabstmnt(this);
	}
};




jvmBasicParser.HtabstmntContext = HtabstmntContext;

jvmBasicParser.prototype.htabstmnt = function() {

    var localctx = new HtabstmntContext(this, this._ctx, this.state);
    this.enterRule(localctx, 62, jvmBasicParser.RULE_htabstmnt);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 455;
        this.match(jvmBasicParser.HTAB);
        this.state = 456;
        this.expression();
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

function HimemstmtContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_himemstmt;
    return this;
}

HimemstmtContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
HimemstmtContext.prototype.constructor = HimemstmtContext;

HimemstmtContext.prototype.HIMEM = function() {
    return this.getToken(jvmBasicParser.HIMEM, 0);
};

HimemstmtContext.prototype.COLON = function() {
    return this.getToken(jvmBasicParser.COLON, 0);
};

HimemstmtContext.prototype.expression = function() {
    return this.getTypedRuleContext(ExpressionContext,0);
};

HimemstmtContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterHimemstmt(this);
	}
};

HimemstmtContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitHimemstmt(this);
	}
};




jvmBasicParser.HimemstmtContext = HimemstmtContext;

jvmBasicParser.prototype.himemstmt = function() {

    var localctx = new HimemstmtContext(this, this._ctx, this.state);
    this.enterRule(localctx, 64, jvmBasicParser.RULE_himemstmt);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 458;
        this.match(jvmBasicParser.HIMEM);
        this.state = 459;
        this.match(jvmBasicParser.COLON);
        this.state = 460;
        this.expression();
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

function LomemstmtContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_lomemstmt;
    return this;
}

LomemstmtContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
LomemstmtContext.prototype.constructor = LomemstmtContext;

LomemstmtContext.prototype.LOMEM = function() {
    return this.getToken(jvmBasicParser.LOMEM, 0);
};

LomemstmtContext.prototype.COLON = function() {
    return this.getToken(jvmBasicParser.COLON, 0);
};

LomemstmtContext.prototype.expression = function() {
    return this.getTypedRuleContext(ExpressionContext,0);
};

LomemstmtContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterLomemstmt(this);
	}
};

LomemstmtContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitLomemstmt(this);
	}
};




jvmBasicParser.LomemstmtContext = LomemstmtContext;

jvmBasicParser.prototype.lomemstmt = function() {

    var localctx = new LomemstmtContext(this, this._ctx, this.state);
    this.enterRule(localctx, 66, jvmBasicParser.RULE_lomemstmt);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 462;
        this.match(jvmBasicParser.LOMEM);
        this.state = 463;
        this.match(jvmBasicParser.COLON);
        this.state = 464;
        this.expression();
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

function DatastmtContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_datastmt;
    return this;
}

DatastmtContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
DatastmtContext.prototype.constructor = DatastmtContext;

DatastmtContext.prototype.DATA = function() {
    return this.getToken(jvmBasicParser.DATA, 0);
};

DatastmtContext.prototype.datum = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(DatumContext);
    } else {
        return this.getTypedRuleContext(DatumContext,i);
    }
};

DatastmtContext.prototype.COMMA = function(i) {
	if(i===undefined) {
		i = null;
	}
    if(i===null) {
        return this.getTokens(jvmBasicParser.COMMA);
    } else {
        return this.getToken(jvmBasicParser.COMMA, i);
    }
};


DatastmtContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterDatastmt(this);
	}
};

DatastmtContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitDatastmt(this);
	}
};




jvmBasicParser.DatastmtContext = DatastmtContext;

jvmBasicParser.prototype.datastmt = function() {

    var localctx = new DatastmtContext(this, this._ctx, this.state);
    this.enterRule(localctx, 68, jvmBasicParser.RULE_datastmt);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 466;
        this.match(jvmBasicParser.DATA);
        this.state = 467;
        this.datum();
        this.state = 474;
        this._errHandler.sync(this);
        _la = this._input.LA(1);
        while(_la===jvmBasicParser.COMMA) {
            this.state = 468;
            this.match(jvmBasicParser.COMMA);
            this.state = 470;
            _la = this._input.LA(1);
            if(((((_la - 118)) & ~0x1f) == 0 && ((1 << (_la - 118)) & ((1 << (jvmBasicParser.STRINGLITERAL - 118)) | (1 << (jvmBasicParser.NUMBER - 118)) | (1 << (jvmBasicParser.FLOAT - 118)))) !== 0)) {
                this.state = 469;
                this.datum();
            }

            this.state = 476;
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

function DatumContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_datum;
    return this;
}

DatumContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
DatumContext.prototype.constructor = DatumContext;

DatumContext.prototype.NUMBER = function() {
    return this.getToken(jvmBasicParser.NUMBER, 0);
};

DatumContext.prototype.STRINGLITERAL = function() {
    return this.getToken(jvmBasicParser.STRINGLITERAL, 0);
};

DatumContext.prototype.FLOAT = function() {
    return this.getToken(jvmBasicParser.FLOAT, 0);
};

DatumContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterDatum(this);
	}
};

DatumContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitDatum(this);
	}
};




jvmBasicParser.DatumContext = DatumContext;

jvmBasicParser.prototype.datum = function() {

    var localctx = new DatumContext(this, this._ctx, this.state);
    this.enterRule(localctx, 70, jvmBasicParser.RULE_datum);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 477;
        _la = this._input.LA(1);
        if(!(((((_la - 118)) & ~0x1f) == 0 && ((1 << (_la - 118)) & ((1 << (jvmBasicParser.STRINGLITERAL - 118)) | (1 << (jvmBasicParser.NUMBER - 118)) | (1 << (jvmBasicParser.FLOAT - 118)))) !== 0))) {
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

function WaitstmtContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_waitstmt;
    return this;
}

WaitstmtContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
WaitstmtContext.prototype.constructor = WaitstmtContext;

WaitstmtContext.prototype.WAIT = function() {
    return this.getToken(jvmBasicParser.WAIT, 0);
};

WaitstmtContext.prototype.expression = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(ExpressionContext);
    } else {
        return this.getTypedRuleContext(ExpressionContext,i);
    }
};

WaitstmtContext.prototype.COMMA = function(i) {
	if(i===undefined) {
		i = null;
	}
    if(i===null) {
        return this.getTokens(jvmBasicParser.COMMA);
    } else {
        return this.getToken(jvmBasicParser.COMMA, i);
    }
};


WaitstmtContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterWaitstmt(this);
	}
};

WaitstmtContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitWaitstmt(this);
	}
};




jvmBasicParser.WaitstmtContext = WaitstmtContext;

jvmBasicParser.prototype.waitstmt = function() {

    var localctx = new WaitstmtContext(this, this._ctx, this.state);
    this.enterRule(localctx, 72, jvmBasicParser.RULE_waitstmt);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 479;
        this.match(jvmBasicParser.WAIT);
        this.state = 480;
        this.expression();
        this.state = 481;
        this.match(jvmBasicParser.COMMA);
        this.state = 482;
        this.expression();
        this.state = 485;
        _la = this._input.LA(1);
        if(_la===jvmBasicParser.COMMA) {
            this.state = 483;
            this.match(jvmBasicParser.COMMA);
            this.state = 484;
            this.expression();
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

function XdrawstmtContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_xdrawstmt;
    return this;
}

XdrawstmtContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
XdrawstmtContext.prototype.constructor = XdrawstmtContext;

XdrawstmtContext.prototype.XDRAW = function() {
    return this.getToken(jvmBasicParser.XDRAW, 0);
};

XdrawstmtContext.prototype.expression = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(ExpressionContext);
    } else {
        return this.getTypedRuleContext(ExpressionContext,i);
    }
};

XdrawstmtContext.prototype.AT = function() {
    return this.getToken(jvmBasicParser.AT, 0);
};

XdrawstmtContext.prototype.COMMA = function() {
    return this.getToken(jvmBasicParser.COMMA, 0);
};

XdrawstmtContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterXdrawstmt(this);
	}
};

XdrawstmtContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitXdrawstmt(this);
	}
};




jvmBasicParser.XdrawstmtContext = XdrawstmtContext;

jvmBasicParser.prototype.xdrawstmt = function() {

    var localctx = new XdrawstmtContext(this, this._ctx, this.state);
    this.enterRule(localctx, 74, jvmBasicParser.RULE_xdrawstmt);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 487;
        this.match(jvmBasicParser.XDRAW);
        this.state = 488;
        this.expression();
        this.state = 494;
        _la = this._input.LA(1);
        if(_la===jvmBasicParser.AT) {
            this.state = 489;
            this.match(jvmBasicParser.AT);
            this.state = 490;
            this.expression();
            this.state = 491;
            this.match(jvmBasicParser.COMMA);
            this.state = 492;
            this.expression();
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

function DrawstmtContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_drawstmt;
    return this;
}

DrawstmtContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
DrawstmtContext.prototype.constructor = DrawstmtContext;

DrawstmtContext.prototype.DRAW = function() {
    return this.getToken(jvmBasicParser.DRAW, 0);
};

DrawstmtContext.prototype.expression = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(ExpressionContext);
    } else {
        return this.getTypedRuleContext(ExpressionContext,i);
    }
};

DrawstmtContext.prototype.AT = function() {
    return this.getToken(jvmBasicParser.AT, 0);
};

DrawstmtContext.prototype.COMMA = function() {
    return this.getToken(jvmBasicParser.COMMA, 0);
};

DrawstmtContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterDrawstmt(this);
	}
};

DrawstmtContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitDrawstmt(this);
	}
};




jvmBasicParser.DrawstmtContext = DrawstmtContext;

jvmBasicParser.prototype.drawstmt = function() {

    var localctx = new DrawstmtContext(this, this._ctx, this.state);
    this.enterRule(localctx, 76, jvmBasicParser.RULE_drawstmt);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 496;
        this.match(jvmBasicParser.DRAW);
        this.state = 497;
        this.expression();
        this.state = 503;
        _la = this._input.LA(1);
        if(_la===jvmBasicParser.AT) {
            this.state = 498;
            this.match(jvmBasicParser.AT);
            this.state = 499;
            this.expression();
            this.state = 500;
            this.match(jvmBasicParser.COMMA);
            this.state = 501;
            this.expression();
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

function DefstmtContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_defstmt;
    return this;
}

DefstmtContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
DefstmtContext.prototype.constructor = DefstmtContext;

DefstmtContext.prototype.DEF = function() {
    return this.getToken(jvmBasicParser.DEF, 0);
};

DefstmtContext.prototype.FN = function() {
    return this.getToken(jvmBasicParser.FN, 0);
};

DefstmtContext.prototype.var = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(VarContext);
    } else {
        return this.getTypedRuleContext(VarContext,i);
    }
};

DefstmtContext.prototype.LPAREN = function() {
    return this.getToken(jvmBasicParser.LPAREN, 0);
};

DefstmtContext.prototype.RPAREN = function() {
    return this.getToken(jvmBasicParser.RPAREN, 0);
};

DefstmtContext.prototype.EQ = function() {
    return this.getToken(jvmBasicParser.EQ, 0);
};

DefstmtContext.prototype.expression = function() {
    return this.getTypedRuleContext(ExpressionContext,0);
};

DefstmtContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterDefstmt(this);
	}
};

DefstmtContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitDefstmt(this);
	}
};




jvmBasicParser.DefstmtContext = DefstmtContext;

jvmBasicParser.prototype.defstmt = function() {

    var localctx = new DefstmtContext(this, this._ctx, this.state);
    this.enterRule(localctx, 78, jvmBasicParser.RULE_defstmt);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 505;
        this.match(jvmBasicParser.DEF);
        this.state = 506;
        this.match(jvmBasicParser.FN);
        this.state = 507;
        this.var();
        this.state = 508;
        this.match(jvmBasicParser.LPAREN);
        this.state = 509;
        this.var();
        this.state = 510;
        this.match(jvmBasicParser.RPAREN);
        this.state = 511;
        this.match(jvmBasicParser.EQ);
        this.state = 512;
        this.expression();
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

function TabstmtContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_tabstmt;
    return this;
}

TabstmtContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
TabstmtContext.prototype.constructor = TabstmtContext;

TabstmtContext.prototype.TAB = function() {
    return this.getToken(jvmBasicParser.TAB, 0);
};

TabstmtContext.prototype.LPAREN = function() {
    return this.getToken(jvmBasicParser.LPAREN, 0);
};

TabstmtContext.prototype.expression = function() {
    return this.getTypedRuleContext(ExpressionContext,0);
};

TabstmtContext.prototype.RPAREN = function() {
    return this.getToken(jvmBasicParser.RPAREN, 0);
};

TabstmtContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterTabstmt(this);
	}
};

TabstmtContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitTabstmt(this);
	}
};




jvmBasicParser.TabstmtContext = TabstmtContext;

jvmBasicParser.prototype.tabstmt = function() {

    var localctx = new TabstmtContext(this, this._ctx, this.state);
    this.enterRule(localctx, 80, jvmBasicParser.RULE_tabstmt);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 514;
        this.match(jvmBasicParser.TAB);
        this.state = 515;
        this.match(jvmBasicParser.LPAREN);
        this.state = 516;
        this.expression();
        this.state = 517;
        this.match(jvmBasicParser.RPAREN);
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

function SpeedstmtContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_speedstmt;
    return this;
}

SpeedstmtContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
SpeedstmtContext.prototype.constructor = SpeedstmtContext;

SpeedstmtContext.prototype.SPEED = function() {
    return this.getToken(jvmBasicParser.SPEED, 0);
};

SpeedstmtContext.prototype.EQ = function() {
    return this.getToken(jvmBasicParser.EQ, 0);
};

SpeedstmtContext.prototype.expression = function() {
    return this.getTypedRuleContext(ExpressionContext,0);
};

SpeedstmtContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterSpeedstmt(this);
	}
};

SpeedstmtContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitSpeedstmt(this);
	}
};




jvmBasicParser.SpeedstmtContext = SpeedstmtContext;

jvmBasicParser.prototype.speedstmt = function() {

    var localctx = new SpeedstmtContext(this, this._ctx, this.state);
    this.enterRule(localctx, 82, jvmBasicParser.RULE_speedstmt);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 519;
        this.match(jvmBasicParser.SPEED);
        this.state = 520;
        this.match(jvmBasicParser.EQ);
        this.state = 521;
        this.expression();
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

function RotstmtContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_rotstmt;
    return this;
}

RotstmtContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
RotstmtContext.prototype.constructor = RotstmtContext;

RotstmtContext.prototype.ROT = function() {
    return this.getToken(jvmBasicParser.ROT, 0);
};

RotstmtContext.prototype.EQ = function() {
    return this.getToken(jvmBasicParser.EQ, 0);
};

RotstmtContext.prototype.expression = function() {
    return this.getTypedRuleContext(ExpressionContext,0);
};

RotstmtContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterRotstmt(this);
	}
};

RotstmtContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitRotstmt(this);
	}
};




jvmBasicParser.RotstmtContext = RotstmtContext;

jvmBasicParser.prototype.rotstmt = function() {

    var localctx = new RotstmtContext(this, this._ctx, this.state);
    this.enterRule(localctx, 84, jvmBasicParser.RULE_rotstmt);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 523;
        this.match(jvmBasicParser.ROT);
        this.state = 524;
        this.match(jvmBasicParser.EQ);
        this.state = 525;
        this.expression();
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

function ScalestmtContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_scalestmt;
    return this;
}

ScalestmtContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
ScalestmtContext.prototype.constructor = ScalestmtContext;

ScalestmtContext.prototype.SCALE = function() {
    return this.getToken(jvmBasicParser.SCALE, 0);
};

ScalestmtContext.prototype.EQ = function() {
    return this.getToken(jvmBasicParser.EQ, 0);
};

ScalestmtContext.prototype.expression = function() {
    return this.getTypedRuleContext(ExpressionContext,0);
};

ScalestmtContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterScalestmt(this);
	}
};

ScalestmtContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitScalestmt(this);
	}
};




jvmBasicParser.ScalestmtContext = ScalestmtContext;

jvmBasicParser.prototype.scalestmt = function() {

    var localctx = new ScalestmtContext(this, this._ctx, this.state);
    this.enterRule(localctx, 86, jvmBasicParser.RULE_scalestmt);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 527;
        this.match(jvmBasicParser.SCALE);
        this.state = 528;
        this.match(jvmBasicParser.EQ);
        this.state = 529;
        this.expression();
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

function ColorstmtContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_colorstmt;
    return this;
}

ColorstmtContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
ColorstmtContext.prototype.constructor = ColorstmtContext;

ColorstmtContext.prototype.COLOR = function() {
    return this.getToken(jvmBasicParser.COLOR, 0);
};

ColorstmtContext.prototype.EQ = function() {
    return this.getToken(jvmBasicParser.EQ, 0);
};

ColorstmtContext.prototype.expression = function() {
    return this.getTypedRuleContext(ExpressionContext,0);
};

ColorstmtContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterColorstmt(this);
	}
};

ColorstmtContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitColorstmt(this);
	}
};




jvmBasicParser.ColorstmtContext = ColorstmtContext;

jvmBasicParser.prototype.colorstmt = function() {

    var localctx = new ColorstmtContext(this, this._ctx, this.state);
    this.enterRule(localctx, 88, jvmBasicParser.RULE_colorstmt);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 531;
        this.match(jvmBasicParser.COLOR);
        this.state = 532;
        this.match(jvmBasicParser.EQ);
        this.state = 533;
        this.expression();
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

function HcolorstmtContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_hcolorstmt;
    return this;
}

HcolorstmtContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
HcolorstmtContext.prototype.constructor = HcolorstmtContext;

HcolorstmtContext.prototype.HCOLOR = function() {
    return this.getToken(jvmBasicParser.HCOLOR, 0);
};

HcolorstmtContext.prototype.EQ = function() {
    return this.getToken(jvmBasicParser.EQ, 0);
};

HcolorstmtContext.prototype.expression = function() {
    return this.getTypedRuleContext(ExpressionContext,0);
};

HcolorstmtContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterHcolorstmt(this);
	}
};

HcolorstmtContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitHcolorstmt(this);
	}
};




jvmBasicParser.HcolorstmtContext = HcolorstmtContext;

jvmBasicParser.prototype.hcolorstmt = function() {

    var localctx = new HcolorstmtContext(this, this._ctx, this.state);
    this.enterRule(localctx, 90, jvmBasicParser.RULE_hcolorstmt);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 535;
        this.match(jvmBasicParser.HCOLOR);
        this.state = 536;
        this.match(jvmBasicParser.EQ);
        this.state = 537;
        this.expression();
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

function HlinstmtContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_hlinstmt;
    return this;
}

HlinstmtContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
HlinstmtContext.prototype.constructor = HlinstmtContext;

HlinstmtContext.prototype.HLIN = function() {
    return this.getToken(jvmBasicParser.HLIN, 0);
};

HlinstmtContext.prototype.expression = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(ExpressionContext);
    } else {
        return this.getTypedRuleContext(ExpressionContext,i);
    }
};

HlinstmtContext.prototype.COMMA = function() {
    return this.getToken(jvmBasicParser.COMMA, 0);
};

HlinstmtContext.prototype.AT = function() {
    return this.getToken(jvmBasicParser.AT, 0);
};

HlinstmtContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterHlinstmt(this);
	}
};

HlinstmtContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitHlinstmt(this);
	}
};




jvmBasicParser.HlinstmtContext = HlinstmtContext;

jvmBasicParser.prototype.hlinstmt = function() {

    var localctx = new HlinstmtContext(this, this._ctx, this.state);
    this.enterRule(localctx, 92, jvmBasicParser.RULE_hlinstmt);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 539;
        this.match(jvmBasicParser.HLIN);
        this.state = 540;
        this.expression();
        this.state = 541;
        this.match(jvmBasicParser.COMMA);
        this.state = 542;
        this.expression();
        this.state = 543;
        this.match(jvmBasicParser.AT);
        this.state = 544;
        this.expression();
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

function VlinstmtContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_vlinstmt;
    return this;
}

VlinstmtContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
VlinstmtContext.prototype.constructor = VlinstmtContext;

VlinstmtContext.prototype.VLIN = function() {
    return this.getToken(jvmBasicParser.VLIN, 0);
};

VlinstmtContext.prototype.expression = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(ExpressionContext);
    } else {
        return this.getTypedRuleContext(ExpressionContext,i);
    }
};

VlinstmtContext.prototype.COMMA = function() {
    return this.getToken(jvmBasicParser.COMMA, 0);
};

VlinstmtContext.prototype.AT = function() {
    return this.getToken(jvmBasicParser.AT, 0);
};

VlinstmtContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterVlinstmt(this);
	}
};

VlinstmtContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitVlinstmt(this);
	}
};




jvmBasicParser.VlinstmtContext = VlinstmtContext;

jvmBasicParser.prototype.vlinstmt = function() {

    var localctx = new VlinstmtContext(this, this._ctx, this.state);
    this.enterRule(localctx, 94, jvmBasicParser.RULE_vlinstmt);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 546;
        this.match(jvmBasicParser.VLIN);
        this.state = 547;
        this.expression();
        this.state = 548;
        this.match(jvmBasicParser.COMMA);
        this.state = 549;
        this.expression();
        this.state = 550;
        this.match(jvmBasicParser.AT);
        this.state = 551;
        this.expression();
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

function OnerrstmtContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_onerrstmt;
    return this;
}

OnerrstmtContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
OnerrstmtContext.prototype.constructor = OnerrstmtContext;

OnerrstmtContext.prototype.ONERR = function() {
    return this.getToken(jvmBasicParser.ONERR, 0);
};

OnerrstmtContext.prototype.GOTO = function() {
    return this.getToken(jvmBasicParser.GOTO, 0);
};

OnerrstmtContext.prototype.linenumber = function() {
    return this.getTypedRuleContext(LinenumberContext,0);
};

OnerrstmtContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterOnerrstmt(this);
	}
};

OnerrstmtContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitOnerrstmt(this);
	}
};




jvmBasicParser.OnerrstmtContext = OnerrstmtContext;

jvmBasicParser.prototype.onerrstmt = function() {

    var localctx = new OnerrstmtContext(this, this._ctx, this.state);
    this.enterRule(localctx, 96, jvmBasicParser.RULE_onerrstmt);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 553;
        this.match(jvmBasicParser.ONERR);
        this.state = 554;
        this.match(jvmBasicParser.GOTO);
        this.state = 555;
        this.linenumber();
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

function PrstmtContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_prstmt;
    return this;
}

PrstmtContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
PrstmtContext.prototype.constructor = PrstmtContext;

PrstmtContext.prototype.PRNUMBER = function() {
    return this.getToken(jvmBasicParser.PRNUMBER, 0);
};

PrstmtContext.prototype.NUMBER = function() {
    return this.getToken(jvmBasicParser.NUMBER, 0);
};

PrstmtContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterPrstmt(this);
	}
};

PrstmtContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitPrstmt(this);
	}
};




jvmBasicParser.PrstmtContext = PrstmtContext;

jvmBasicParser.prototype.prstmt = function() {

    var localctx = new PrstmtContext(this, this._ctx, this.state);
    this.enterRule(localctx, 98, jvmBasicParser.RULE_prstmt);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 557;
        this.match(jvmBasicParser.PRNUMBER);
        this.state = 558;
        this.match(jvmBasicParser.NUMBER);
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

function InstmtContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_instmt;
    return this;
}

InstmtContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
InstmtContext.prototype.constructor = InstmtContext;

InstmtContext.prototype.INNUMBER = function() {
    return this.getToken(jvmBasicParser.INNUMBER, 0);
};

InstmtContext.prototype.NUMBER = function() {
    return this.getToken(jvmBasicParser.NUMBER, 0);
};

InstmtContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterInstmt(this);
	}
};

InstmtContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitInstmt(this);
	}
};




jvmBasicParser.InstmtContext = InstmtContext;

jvmBasicParser.prototype.instmt = function() {

    var localctx = new InstmtContext(this, this._ctx, this.state);
    this.enterRule(localctx, 100, jvmBasicParser.RULE_instmt);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 560;
        this.match(jvmBasicParser.INNUMBER);
        this.state = 561;
        this.match(jvmBasicParser.NUMBER);
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

function StorestmtContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_storestmt;
    return this;
}

StorestmtContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
StorestmtContext.prototype.constructor = StorestmtContext;

StorestmtContext.prototype.STORE = function() {
    return this.getToken(jvmBasicParser.STORE, 0);
};

StorestmtContext.prototype.vardecl = function() {
    return this.getTypedRuleContext(VardeclContext,0);
};

StorestmtContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterStorestmt(this);
	}
};

StorestmtContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitStorestmt(this);
	}
};




jvmBasicParser.StorestmtContext = StorestmtContext;

jvmBasicParser.prototype.storestmt = function() {

    var localctx = new StorestmtContext(this, this._ctx, this.state);
    this.enterRule(localctx, 102, jvmBasicParser.RULE_storestmt);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 563;
        this.match(jvmBasicParser.STORE);
        this.state = 564;
        this.vardecl();
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

function RecallstmtContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_recallstmt;
    return this;
}

RecallstmtContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
RecallstmtContext.prototype.constructor = RecallstmtContext;

RecallstmtContext.prototype.RECALL = function() {
    return this.getToken(jvmBasicParser.RECALL, 0);
};

RecallstmtContext.prototype.vardecl = function() {
    return this.getTypedRuleContext(VardeclContext,0);
};

RecallstmtContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterRecallstmt(this);
	}
};

RecallstmtContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitRecallstmt(this);
	}
};




jvmBasicParser.RecallstmtContext = RecallstmtContext;

jvmBasicParser.prototype.recallstmt = function() {

    var localctx = new RecallstmtContext(this, this._ctx, this.state);
    this.enterRule(localctx, 104, jvmBasicParser.RULE_recallstmt);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 566;
        this.match(jvmBasicParser.RECALL);
        this.state = 567;
        this.vardecl();
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

function ListstmtContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_liststmt;
    return this;
}

ListstmtContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
ListstmtContext.prototype.constructor = ListstmtContext;

ListstmtContext.prototype.LIST = function() {
    return this.getToken(jvmBasicParser.LIST, 0);
};

ListstmtContext.prototype.expression = function() {
    return this.getTypedRuleContext(ExpressionContext,0);
};

ListstmtContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterListstmt(this);
	}
};

ListstmtContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitListstmt(this);
	}
};




jvmBasicParser.ListstmtContext = ListstmtContext;

jvmBasicParser.prototype.liststmt = function() {

    var localctx = new ListstmtContext(this, this._ctx, this.state);
    this.enterRule(localctx, 106, jvmBasicParser.RULE_liststmt);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 569;
        this.match(jvmBasicParser.LIST);
        this.state = 571;
        _la = this._input.LA(1);
        if((((_la) & ~0x1f) == 0 && ((1 << _la) & ((1 << jvmBasicParser.CHR) | (1 << jvmBasicParser.MID) | (1 << jvmBasicParser.LEFT) | (1 << jvmBasicParser.RIGHT) | (1 << jvmBasicParser.STR) | (1 << jvmBasicParser.LPAREN) | (1 << jvmBasicParser.PLUS) | (1 << jvmBasicParser.MINUS))) !== 0) || ((((_la - 40)) & ~0x1f) == 0 && ((1 << (_la - 40)) & ((1 << (jvmBasicParser.SQR - 40)) | (1 << (jvmBasicParser.LEN - 40)) | (1 << (jvmBasicParser.ASC - 40)) | (1 << (jvmBasicParser.PDL - 40)) | (1 << (jvmBasicParser.PEEK - 40)) | (1 << (jvmBasicParser.INTF - 40)) | (1 << (jvmBasicParser.SPC - 40)) | (1 << (jvmBasicParser.FRE - 40)) | (1 << (jvmBasicParser.POS - 40)) | (1 << (jvmBasicParser.USR - 40)))) !== 0) || ((((_la - 83)) & ~0x1f) == 0 && ((1 << (_la - 83)) & ((1 << (jvmBasicParser.FN - 83)) | (1 << (jvmBasicParser.VAL - 83)) | (1 << (jvmBasicParser.SCRN - 83)) | (1 << (jvmBasicParser.SIN - 83)) | (1 << (jvmBasicParser.COS - 83)) | (1 << (jvmBasicParser.TAN - 83)) | (1 << (jvmBasicParser.ATAN - 83)) | (1 << (jvmBasicParser.RND - 83)) | (1 << (jvmBasicParser.SGN - 83)) | (1 << (jvmBasicParser.EXP - 83)) | (1 << (jvmBasicParser.LOG - 83)) | (1 << (jvmBasicParser.ABS - 83)) | (1 << (jvmBasicParser.NOT - 83)))) !== 0) || ((((_la - 118)) & ~0x1f) == 0 && ((1 << (_la - 118)) & ((1 << (jvmBasicParser.STRINGLITERAL - 118)) | (1 << (jvmBasicParser.LETTERS - 118)) | (1 << (jvmBasicParser.NUMBER - 118)) | (1 << (jvmBasicParser.FLOAT - 118)))) !== 0)) {
            this.state = 570;
            this.expression();
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

function PopstmtContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_popstmt;
    return this;
}

PopstmtContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
PopstmtContext.prototype.constructor = PopstmtContext;

PopstmtContext.prototype.POP = function() {
    return this.getToken(jvmBasicParser.POP, 0);
};

PopstmtContext.prototype.expression = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(ExpressionContext);
    } else {
        return this.getTypedRuleContext(ExpressionContext,i);
    }
};

PopstmtContext.prototype.COMMA = function() {
    return this.getToken(jvmBasicParser.COMMA, 0);
};

PopstmtContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterPopstmt(this);
	}
};

PopstmtContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitPopstmt(this);
	}
};




jvmBasicParser.PopstmtContext = PopstmtContext;

jvmBasicParser.prototype.popstmt = function() {

    var localctx = new PopstmtContext(this, this._ctx, this.state);
    this.enterRule(localctx, 108, jvmBasicParser.RULE_popstmt);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 573;
        this.match(jvmBasicParser.POP);
        this.state = 578;
        _la = this._input.LA(1);
        if((((_la) & ~0x1f) == 0 && ((1 << _la) & ((1 << jvmBasicParser.CHR) | (1 << jvmBasicParser.MID) | (1 << jvmBasicParser.LEFT) | (1 << jvmBasicParser.RIGHT) | (1 << jvmBasicParser.STR) | (1 << jvmBasicParser.LPAREN) | (1 << jvmBasicParser.PLUS) | (1 << jvmBasicParser.MINUS))) !== 0) || ((((_la - 40)) & ~0x1f) == 0 && ((1 << (_la - 40)) & ((1 << (jvmBasicParser.SQR - 40)) | (1 << (jvmBasicParser.LEN - 40)) | (1 << (jvmBasicParser.ASC - 40)) | (1 << (jvmBasicParser.PDL - 40)) | (1 << (jvmBasicParser.PEEK - 40)) | (1 << (jvmBasicParser.INTF - 40)) | (1 << (jvmBasicParser.SPC - 40)) | (1 << (jvmBasicParser.FRE - 40)) | (1 << (jvmBasicParser.POS - 40)) | (1 << (jvmBasicParser.USR - 40)))) !== 0) || ((((_la - 83)) & ~0x1f) == 0 && ((1 << (_la - 83)) & ((1 << (jvmBasicParser.FN - 83)) | (1 << (jvmBasicParser.VAL - 83)) | (1 << (jvmBasicParser.SCRN - 83)) | (1 << (jvmBasicParser.SIN - 83)) | (1 << (jvmBasicParser.COS - 83)) | (1 << (jvmBasicParser.TAN - 83)) | (1 << (jvmBasicParser.ATAN - 83)) | (1 << (jvmBasicParser.RND - 83)) | (1 << (jvmBasicParser.SGN - 83)) | (1 << (jvmBasicParser.EXP - 83)) | (1 << (jvmBasicParser.LOG - 83)) | (1 << (jvmBasicParser.ABS - 83)) | (1 << (jvmBasicParser.NOT - 83)))) !== 0) || ((((_la - 118)) & ~0x1f) == 0 && ((1 << (_la - 118)) & ((1 << (jvmBasicParser.STRINGLITERAL - 118)) | (1 << (jvmBasicParser.LETTERS - 118)) | (1 << (jvmBasicParser.NUMBER - 118)) | (1 << (jvmBasicParser.FLOAT - 118)))) !== 0)) {
            this.state = 574;
            this.expression();
            this.state = 575;
            this.match(jvmBasicParser.COMMA);
            this.state = 576;
            this.expression();
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

function AmptstmtContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_amptstmt;
    return this;
}

AmptstmtContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
AmptstmtContext.prototype.constructor = AmptstmtContext;

AmptstmtContext.prototype.AMPERSAND = function() {
    return this.getToken(jvmBasicParser.AMPERSAND, 0);
};

AmptstmtContext.prototype.expression = function() {
    return this.getTypedRuleContext(ExpressionContext,0);
};

AmptstmtContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterAmptstmt(this);
	}
};

AmptstmtContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitAmptstmt(this);
	}
};




jvmBasicParser.AmptstmtContext = AmptstmtContext;

jvmBasicParser.prototype.amptstmt = function() {

    var localctx = new AmptstmtContext(this, this._ctx, this.state);
    this.enterRule(localctx, 110, jvmBasicParser.RULE_amptstmt);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 580;
        this.match(jvmBasicParser.AMPERSAND);
        this.state = 581;
        this.expression();
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

function IncludestmtContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_includestmt;
    return this;
}

IncludestmtContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
IncludestmtContext.prototype.constructor = IncludestmtContext;

IncludestmtContext.prototype.INCLUDE = function() {
    return this.getToken(jvmBasicParser.INCLUDE, 0);
};

IncludestmtContext.prototype.expression = function() {
    return this.getTypedRuleContext(ExpressionContext,0);
};

IncludestmtContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterIncludestmt(this);
	}
};

IncludestmtContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitIncludestmt(this);
	}
};




jvmBasicParser.IncludestmtContext = IncludestmtContext;

jvmBasicParser.prototype.includestmt = function() {

    var localctx = new IncludestmtContext(this, this._ctx, this.state);
    this.enterRule(localctx, 112, jvmBasicParser.RULE_includestmt);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 583;
        this.match(jvmBasicParser.INCLUDE);
        this.state = 584;
        this.expression();
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

function EndstmtContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_endstmt;
    return this;
}

EndstmtContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
EndstmtContext.prototype.constructor = EndstmtContext;

EndstmtContext.prototype.END = function() {
    return this.getToken(jvmBasicParser.END, 0);
};

EndstmtContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterEndstmt(this);
	}
};

EndstmtContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitEndstmt(this);
	}
};




jvmBasicParser.EndstmtContext = EndstmtContext;

jvmBasicParser.prototype.endstmt = function() {

    var localctx = new EndstmtContext(this, this._ctx, this.state);
    this.enterRule(localctx, 114, jvmBasicParser.RULE_endstmt);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 586;
        this.match(jvmBasicParser.END);
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

function ReturnstmtContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_returnstmt;
    return this;
}

ReturnstmtContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
ReturnstmtContext.prototype.constructor = ReturnstmtContext;

ReturnstmtContext.prototype.RETURN = function() {
    return this.getToken(jvmBasicParser.RETURN, 0);
};

ReturnstmtContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterReturnstmt(this);
	}
};

ReturnstmtContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitReturnstmt(this);
	}
};




jvmBasicParser.ReturnstmtContext = ReturnstmtContext;

jvmBasicParser.prototype.returnstmt = function() {

    var localctx = new ReturnstmtContext(this, this._ctx, this.state);
    this.enterRule(localctx, 116, jvmBasicParser.RULE_returnstmt);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 588;
        this.match(jvmBasicParser.RETURN);
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

function RestorestmtContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_restorestmt;
    return this;
}

RestorestmtContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
RestorestmtContext.prototype.constructor = RestorestmtContext;

RestorestmtContext.prototype.RESTORE = function() {
    return this.getToken(jvmBasicParser.RESTORE, 0);
};

RestorestmtContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterRestorestmt(this);
	}
};

RestorestmtContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitRestorestmt(this);
	}
};




jvmBasicParser.RestorestmtContext = RestorestmtContext;

jvmBasicParser.prototype.restorestmt = function() {

    var localctx = new RestorestmtContext(this, this._ctx, this.state);
    this.enterRule(localctx, 118, jvmBasicParser.RULE_restorestmt);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 590;
        this.match(jvmBasicParser.RESTORE);
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

function FuncContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_func;
    return this;
}

FuncContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
FuncContext.prototype.constructor = FuncContext;

FuncContext.prototype.NUMBER = function() {
    return this.getToken(jvmBasicParser.NUMBER, 0);
};

FuncContext.prototype.STRINGLITERAL = function() {
    return this.getToken(jvmBasicParser.STRINGLITERAL, 0);
};

FuncContext.prototype.FLOAT = function() {
    return this.getToken(jvmBasicParser.FLOAT, 0);
};

FuncContext.prototype.vardecl = function() {
    return this.getTypedRuleContext(VardeclContext,0);
};

FuncContext.prototype.chrfunc = function() {
    return this.getTypedRuleContext(ChrfuncContext,0);
};

FuncContext.prototype.sqrfunc = function() {
    return this.getTypedRuleContext(SqrfuncContext,0);
};

FuncContext.prototype.lenfunc = function() {
    return this.getTypedRuleContext(LenfuncContext,0);
};

FuncContext.prototype.strfunc = function() {
    return this.getTypedRuleContext(StrfuncContext,0);
};

FuncContext.prototype.ascfunc = function() {
    return this.getTypedRuleContext(AscfuncContext,0);
};

FuncContext.prototype.scrnfunc = function() {
    return this.getTypedRuleContext(ScrnfuncContext,0);
};

FuncContext.prototype.midfunc = function() {
    return this.getTypedRuleContext(MidfuncContext,0);
};

FuncContext.prototype.pdlfunc = function() {
    return this.getTypedRuleContext(PdlfuncContext,0);
};

FuncContext.prototype.peekfunc = function() {
    return this.getTypedRuleContext(PeekfuncContext,0);
};

FuncContext.prototype.intfunc = function() {
    return this.getTypedRuleContext(IntfuncContext,0);
};

FuncContext.prototype.spcfunc = function() {
    return this.getTypedRuleContext(SpcfuncContext,0);
};

FuncContext.prototype.frefunc = function() {
    return this.getTypedRuleContext(FrefuncContext,0);
};

FuncContext.prototype.posfunc = function() {
    return this.getTypedRuleContext(PosfuncContext,0);
};

FuncContext.prototype.usrfunc = function() {
    return this.getTypedRuleContext(UsrfuncContext,0);
};

FuncContext.prototype.leftfunc = function() {
    return this.getTypedRuleContext(LeftfuncContext,0);
};

FuncContext.prototype.valfunc = function() {
    return this.getTypedRuleContext(ValfuncContext,0);
};

FuncContext.prototype.rightfunc = function() {
    return this.getTypedRuleContext(RightfuncContext,0);
};

FuncContext.prototype.fnfunc = function() {
    return this.getTypedRuleContext(FnfuncContext,0);
};

FuncContext.prototype.sinfunc = function() {
    return this.getTypedRuleContext(SinfuncContext,0);
};

FuncContext.prototype.cosfunc = function() {
    return this.getTypedRuleContext(CosfuncContext,0);
};

FuncContext.prototype.tanfunc = function() {
    return this.getTypedRuleContext(TanfuncContext,0);
};

FuncContext.prototype.atnfunc = function() {
    return this.getTypedRuleContext(AtnfuncContext,0);
};

FuncContext.prototype.rndfunc = function() {
    return this.getTypedRuleContext(RndfuncContext,0);
};

FuncContext.prototype.sgnfunc = function() {
    return this.getTypedRuleContext(SgnfuncContext,0);
};

FuncContext.prototype.expfunc = function() {
    return this.getTypedRuleContext(ExpfuncContext,0);
};

FuncContext.prototype.logfunc = function() {
    return this.getTypedRuleContext(LogfuncContext,0);
};

FuncContext.prototype.absfunc = function() {
    return this.getTypedRuleContext(AbsfuncContext,0);
};

FuncContext.prototype.LPAREN = function() {
    return this.getToken(jvmBasicParser.LPAREN, 0);
};

FuncContext.prototype.expression = function() {
    return this.getTypedRuleContext(ExpressionContext,0);
};

FuncContext.prototype.RPAREN = function() {
    return this.getToken(jvmBasicParser.RPAREN, 0);
};

FuncContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterFunc(this);
	}
};

FuncContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitFunc(this);
	}
};




jvmBasicParser.FuncContext = FuncContext;

jvmBasicParser.prototype.func = function() {

    var localctx = new FuncContext(this, this._ctx, this.state);
    this.enterRule(localctx, 120, jvmBasicParser.RULE_func);
    var _la = 0; // Token type
    try {
        this.state = 625;
        switch(this._input.LA(1)) {
        case jvmBasicParser.STRINGLITERAL:
        case jvmBasicParser.NUMBER:
        case jvmBasicParser.FLOAT:
            this.enterOuterAlt(localctx, 1);
            this.state = 592;
            _la = this._input.LA(1);
            if(!(((((_la - 118)) & ~0x1f) == 0 && ((1 << (_la - 118)) & ((1 << (jvmBasicParser.STRINGLITERAL - 118)) | (1 << (jvmBasicParser.NUMBER - 118)) | (1 << (jvmBasicParser.FLOAT - 118)))) !== 0))) {
            this._errHandler.recoverInline(this);
            }
            else {
                this.consume();
            }
            break;
        case jvmBasicParser.LETTERS:
            this.enterOuterAlt(localctx, 2);
            this.state = 593;
            this.vardecl();
            break;
        case jvmBasicParser.CHR:
            this.enterOuterAlt(localctx, 3);
            this.state = 594;
            this.chrfunc();
            break;
        case jvmBasicParser.SQR:
            this.enterOuterAlt(localctx, 4);
            this.state = 595;
            this.sqrfunc();
            break;
        case jvmBasicParser.LEN:
            this.enterOuterAlt(localctx, 5);
            this.state = 596;
            this.lenfunc();
            break;
        case jvmBasicParser.STR:
            this.enterOuterAlt(localctx, 6);
            this.state = 597;
            this.strfunc();
            break;
        case jvmBasicParser.ASC:
            this.enterOuterAlt(localctx, 7);
            this.state = 598;
            this.ascfunc();
            break;
        case jvmBasicParser.SCRN:
            this.enterOuterAlt(localctx, 8);
            this.state = 599;
            this.scrnfunc();
            break;
        case jvmBasicParser.MID:
            this.enterOuterAlt(localctx, 9);
            this.state = 600;
            this.midfunc();
            break;
        case jvmBasicParser.PDL:
            this.enterOuterAlt(localctx, 10);
            this.state = 601;
            this.pdlfunc();
            break;
        case jvmBasicParser.PEEK:
            this.enterOuterAlt(localctx, 11);
            this.state = 602;
            this.peekfunc();
            break;
        case jvmBasicParser.INTF:
            this.enterOuterAlt(localctx, 12);
            this.state = 603;
            this.intfunc();
            break;
        case jvmBasicParser.SPC:
            this.enterOuterAlt(localctx, 13);
            this.state = 604;
            this.spcfunc();
            break;
        case jvmBasicParser.FRE:
            this.enterOuterAlt(localctx, 14);
            this.state = 605;
            this.frefunc();
            break;
        case jvmBasicParser.POS:
            this.enterOuterAlt(localctx, 15);
            this.state = 606;
            this.posfunc();
            break;
        case jvmBasicParser.USR:
            this.enterOuterAlt(localctx, 16);
            this.state = 607;
            this.usrfunc();
            break;
        case jvmBasicParser.LEFT:
            this.enterOuterAlt(localctx, 17);
            this.state = 608;
            this.leftfunc();
            break;
        case jvmBasicParser.VAL:
            this.enterOuterAlt(localctx, 18);
            this.state = 609;
            this.valfunc();
            break;
        case jvmBasicParser.RIGHT:
            this.enterOuterAlt(localctx, 19);
            this.state = 610;
            this.rightfunc();
            break;
        case jvmBasicParser.FN:
            this.enterOuterAlt(localctx, 20);
            this.state = 611;
            this.fnfunc();
            break;
        case jvmBasicParser.SIN:
            this.enterOuterAlt(localctx, 21);
            this.state = 612;
            this.sinfunc();
            break;
        case jvmBasicParser.COS:
            this.enterOuterAlt(localctx, 22);
            this.state = 613;
            this.cosfunc();
            break;
        case jvmBasicParser.TAN:
            this.enterOuterAlt(localctx, 23);
            this.state = 614;
            this.tanfunc();
            break;
        case jvmBasicParser.ATAN:
            this.enterOuterAlt(localctx, 24);
            this.state = 615;
            this.atnfunc();
            break;
        case jvmBasicParser.RND:
            this.enterOuterAlt(localctx, 25);
            this.state = 616;
            this.rndfunc();
            break;
        case jvmBasicParser.SGN:
            this.enterOuterAlt(localctx, 26);
            this.state = 617;
            this.sgnfunc();
            break;
        case jvmBasicParser.EXP:
            this.enterOuterAlt(localctx, 27);
            this.state = 618;
            this.expfunc();
            break;
        case jvmBasicParser.LOG:
            this.enterOuterAlt(localctx, 28);
            this.state = 619;
            this.logfunc();
            break;
        case jvmBasicParser.ABS:
            this.enterOuterAlt(localctx, 29);
            this.state = 620;
            this.absfunc();
            break;
        case jvmBasicParser.LPAREN:
            this.enterOuterAlt(localctx, 30);
            this.state = 621;
            this.match(jvmBasicParser.LPAREN);
            this.state = 622;
            this.expression();
            this.state = 623;
            this.match(jvmBasicParser.RPAREN);
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

function SignExpressionContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_signExpression;
    return this;
}

SignExpressionContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
SignExpressionContext.prototype.constructor = SignExpressionContext;

SignExpressionContext.prototype.func = function() {
    return this.getTypedRuleContext(FuncContext,0);
};

SignExpressionContext.prototype.NOT = function() {
    return this.getToken(jvmBasicParser.NOT, 0);
};

SignExpressionContext.prototype.PLUS = function(i) {
	if(i===undefined) {
		i = null;
	}
    if(i===null) {
        return this.getTokens(jvmBasicParser.PLUS);
    } else {
        return this.getToken(jvmBasicParser.PLUS, i);
    }
};


SignExpressionContext.prototype.MINUS = function(i) {
	if(i===undefined) {
		i = null;
	}
    if(i===null) {
        return this.getTokens(jvmBasicParser.MINUS);
    } else {
        return this.getToken(jvmBasicParser.MINUS, i);
    }
};


SignExpressionContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterSignExpression(this);
	}
};

SignExpressionContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitSignExpression(this);
	}
};




jvmBasicParser.SignExpressionContext = SignExpressionContext;

jvmBasicParser.prototype.signExpression = function() {

    var localctx = new SignExpressionContext(this, this._ctx, this.state);
    this.enterRule(localctx, 122, jvmBasicParser.RULE_signExpression);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 628;
        _la = this._input.LA(1);
        if(_la===jvmBasicParser.NOT) {
            this.state = 627;
            this.match(jvmBasicParser.NOT);
        }

        this.state = 633;
        this._errHandler.sync(this);
        _la = this._input.LA(1);
        while(_la===jvmBasicParser.PLUS || _la===jvmBasicParser.MINUS) {
            this.state = 630;
            _la = this._input.LA(1);
            if(!(_la===jvmBasicParser.PLUS || _la===jvmBasicParser.MINUS)) {
            this._errHandler.recoverInline(this);
            }
            else {
                this.consume();
            }
            this.state = 635;
            this._errHandler.sync(this);
            _la = this._input.LA(1);
        }
        this.state = 636;
        this.func();
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

function ExponentExpressionContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_exponentExpression;
    return this;
}

ExponentExpressionContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
ExponentExpressionContext.prototype.constructor = ExponentExpressionContext;

ExponentExpressionContext.prototype.signExpression = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(SignExpressionContext);
    } else {
        return this.getTypedRuleContext(SignExpressionContext,i);
    }
};

ExponentExpressionContext.prototype.EXPONENT = function(i) {
	if(i===undefined) {
		i = null;
	}
    if(i===null) {
        return this.getTokens(jvmBasicParser.EXPONENT);
    } else {
        return this.getToken(jvmBasicParser.EXPONENT, i);
    }
};


ExponentExpressionContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterExponentExpression(this);
	}
};

ExponentExpressionContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitExponentExpression(this);
	}
};




jvmBasicParser.ExponentExpressionContext = ExponentExpressionContext;

jvmBasicParser.prototype.exponentExpression = function() {

    var localctx = new ExponentExpressionContext(this, this._ctx, this.state);
    this.enterRule(localctx, 124, jvmBasicParser.RULE_exponentExpression);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 638;
        this.signExpression();
        this.state = 643;
        this._errHandler.sync(this);
        _la = this._input.LA(1);
        while(_la===jvmBasicParser.EXPONENT) {
            this.state = 639;
            this.match(jvmBasicParser.EXPONENT);
            this.state = 640;
            this.signExpression();
            this.state = 645;
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

function MultiplyingExpressionContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_multiplyingExpression;
    return this;
}

MultiplyingExpressionContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
MultiplyingExpressionContext.prototype.constructor = MultiplyingExpressionContext;

MultiplyingExpressionContext.prototype.exponentExpression = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(ExponentExpressionContext);
    } else {
        return this.getTypedRuleContext(ExponentExpressionContext,i);
    }
};

MultiplyingExpressionContext.prototype.TIMES = function(i) {
	if(i===undefined) {
		i = null;
	}
    if(i===null) {
        return this.getTokens(jvmBasicParser.TIMES);
    } else {
        return this.getToken(jvmBasicParser.TIMES, i);
    }
};


MultiplyingExpressionContext.prototype.DIV = function(i) {
	if(i===undefined) {
		i = null;
	}
    if(i===null) {
        return this.getTokens(jvmBasicParser.DIV);
    } else {
        return this.getToken(jvmBasicParser.DIV, i);
    }
};


MultiplyingExpressionContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterMultiplyingExpression(this);
	}
};

MultiplyingExpressionContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitMultiplyingExpression(this);
	}
};




jvmBasicParser.MultiplyingExpressionContext = MultiplyingExpressionContext;

jvmBasicParser.prototype.multiplyingExpression = function() {

    var localctx = new MultiplyingExpressionContext(this, this._ctx, this.state);
    this.enterRule(localctx, 126, jvmBasicParser.RULE_multiplyingExpression);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 646;
        this.exponentExpression();
        this.state = 651;
        this._errHandler.sync(this);
        _la = this._input.LA(1);
        while(_la===jvmBasicParser.TIMES || _la===jvmBasicParser.DIV) {
            this.state = 647;
            _la = this._input.LA(1);
            if(!(_la===jvmBasicParser.TIMES || _la===jvmBasicParser.DIV)) {
            this._errHandler.recoverInline(this);
            }
            else {
                this.consume();
            }
            this.state = 648;
            this.exponentExpression();
            this.state = 653;
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

function AddingExpressionContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_addingExpression;
    return this;
}

AddingExpressionContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
AddingExpressionContext.prototype.constructor = AddingExpressionContext;

AddingExpressionContext.prototype.multiplyingExpression = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(MultiplyingExpressionContext);
    } else {
        return this.getTypedRuleContext(MultiplyingExpressionContext,i);
    }
};

AddingExpressionContext.prototype.PLUS = function(i) {
	if(i===undefined) {
		i = null;
	}
    if(i===null) {
        return this.getTokens(jvmBasicParser.PLUS);
    } else {
        return this.getToken(jvmBasicParser.PLUS, i);
    }
};


AddingExpressionContext.prototype.MINUS = function(i) {
	if(i===undefined) {
		i = null;
	}
    if(i===null) {
        return this.getTokens(jvmBasicParser.MINUS);
    } else {
        return this.getToken(jvmBasicParser.MINUS, i);
    }
};


AddingExpressionContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterAddingExpression(this);
	}
};

AddingExpressionContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitAddingExpression(this);
	}
};




jvmBasicParser.AddingExpressionContext = AddingExpressionContext;

jvmBasicParser.prototype.addingExpression = function() {

    var localctx = new AddingExpressionContext(this, this._ctx, this.state);
    this.enterRule(localctx, 128, jvmBasicParser.RULE_addingExpression);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 654;
        this.multiplyingExpression();
        this.state = 659;
        this._errHandler.sync(this);
        var _alt = this._interp.adaptivePredict(this._input,39,this._ctx)
        while(_alt!=2 && _alt!=antlr4.atn.ATN.INVALID_ALT_NUMBER) {
            if(_alt===1) {
                this.state = 655;
                _la = this._input.LA(1);
                if(!(_la===jvmBasicParser.PLUS || _la===jvmBasicParser.MINUS)) {
                this._errHandler.recoverInline(this);
                }
                else {
                    this.consume();
                }
                this.state = 656;
                this.multiplyingExpression(); 
            }
            this.state = 661;
            this._errHandler.sync(this);
            _alt = this._interp.adaptivePredict(this._input,39,this._ctx);
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

function RelationalExpressionContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_relationalExpression;
    return this;
}

RelationalExpressionContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
RelationalExpressionContext.prototype.constructor = RelationalExpressionContext;

RelationalExpressionContext.prototype.addingExpression = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(AddingExpressionContext);
    } else {
        return this.getTypedRuleContext(AddingExpressionContext,i);
    }
};

RelationalExpressionContext.prototype.relop = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(RelopContext);
    } else {
        return this.getTypedRuleContext(RelopContext,i);
    }
};

RelationalExpressionContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterRelationalExpression(this);
	}
};

RelationalExpressionContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitRelationalExpression(this);
	}
};




jvmBasicParser.RelationalExpressionContext = RelationalExpressionContext;

jvmBasicParser.prototype.relationalExpression = function() {

    var localctx = new RelationalExpressionContext(this, this._ctx, this.state);
    this.enterRule(localctx, 130, jvmBasicParser.RULE_relationalExpression);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 662;
        this.addingExpression();
        this.state = 668;
        this._errHandler.sync(this);
        _la = this._input.LA(1);
        while(((((_la - 23)) & ~0x1f) == 0 && ((1 << (_la - 23)) & ((1 << (jvmBasicParser.GTE - 23)) | (1 << (jvmBasicParser.LTE - 23)) | (1 << (jvmBasicParser.GT - 23)) | (1 << (jvmBasicParser.LT - 23)) | (1 << (jvmBasicParser.NEQ - 23)) | (1 << (jvmBasicParser.EQ - 23)))) !== 0)) {
            this.state = 663;
            this.relop();
            this.state = 664;
            this.addingExpression();
            this.state = 670;
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

function ExpressionContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_expression;
    return this;
}

ExpressionContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
ExpressionContext.prototype.constructor = ExpressionContext;

ExpressionContext.prototype.func = function() {
    return this.getTypedRuleContext(FuncContext,0);
};

ExpressionContext.prototype.relationalExpression = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(RelationalExpressionContext);
    } else {
        return this.getTypedRuleContext(RelationalExpressionContext,i);
    }
};

ExpressionContext.prototype.AND = function(i) {
	if(i===undefined) {
		i = null;
	}
    if(i===null) {
        return this.getTokens(jvmBasicParser.AND);
    } else {
        return this.getToken(jvmBasicParser.AND, i);
    }
};


ExpressionContext.prototype.OR = function(i) {
	if(i===undefined) {
		i = null;
	}
    if(i===null) {
        return this.getTokens(jvmBasicParser.OR);
    } else {
        return this.getToken(jvmBasicParser.OR, i);
    }
};


ExpressionContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterExpression(this);
	}
};

ExpressionContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitExpression(this);
	}
};




jvmBasicParser.ExpressionContext = ExpressionContext;

jvmBasicParser.prototype.expression = function() {

    var localctx = new ExpressionContext(this, this._ctx, this.state);
    this.enterRule(localctx, 132, jvmBasicParser.RULE_expression);
    var _la = 0; // Token type
    try {
        this.state = 680;
        var la_ = this._interp.adaptivePredict(this._input,42,this._ctx);
        switch(la_) {
        case 1:
            this.enterOuterAlt(localctx, 1);
            this.state = 671;
            this.func();
            break;

        case 2:
            this.enterOuterAlt(localctx, 2);
            this.state = 672;
            this.relationalExpression();
            this.state = 677;
            this._errHandler.sync(this);
            _la = this._input.LA(1);
            while(_la===jvmBasicParser.AND || _la===jvmBasicParser.OR) {
                this.state = 673;
                _la = this._input.LA(1);
                if(!(_la===jvmBasicParser.AND || _la===jvmBasicParser.OR)) {
                this._errHandler.recoverInline(this);
                }
                else {
                    this.consume();
                }
                this.state = 674;
                this.relationalExpression();
                this.state = 679;
                this._errHandler.sync(this);
                _la = this._input.LA(1);
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

function VarContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_var;
    return this;
}

VarContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
VarContext.prototype.constructor = VarContext;

VarContext.prototype.varname = function() {
    return this.getTypedRuleContext(VarnameContext,0);
};

VarContext.prototype.varsuffix = function() {
    return this.getTypedRuleContext(VarsuffixContext,0);
};

VarContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterVar(this);
	}
};

VarContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitVar(this);
	}
};




jvmBasicParser.VarContext = VarContext;

jvmBasicParser.prototype.var = function() {

    var localctx = new VarContext(this, this._ctx, this.state);
    this.enterRule(localctx, 134, jvmBasicParser.RULE_var);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 682;
        this.varname();
        this.state = 684;
        _la = this._input.LA(1);
        if(_la===jvmBasicParser.DOLLAR || _la===jvmBasicParser.PERCENT) {
            this.state = 683;
            this.varsuffix();
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

function VarnameContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_varname;
    return this;
}

VarnameContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
VarnameContext.prototype.constructor = VarnameContext;

VarnameContext.prototype.LETTERS = function(i) {
	if(i===undefined) {
		i = null;
	}
    if(i===null) {
        return this.getTokens(jvmBasicParser.LETTERS);
    } else {
        return this.getToken(jvmBasicParser.LETTERS, i);
    }
};


VarnameContext.prototype.NUMBER = function(i) {
	if(i===undefined) {
		i = null;
	}
    if(i===null) {
        return this.getTokens(jvmBasicParser.NUMBER);
    } else {
        return this.getToken(jvmBasicParser.NUMBER, i);
    }
};


VarnameContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterVarname(this);
	}
};

VarnameContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitVarname(this);
	}
};




jvmBasicParser.VarnameContext = VarnameContext;

jvmBasicParser.prototype.varname = function() {

    var localctx = new VarnameContext(this, this._ctx, this.state);
    this.enterRule(localctx, 136, jvmBasicParser.RULE_varname);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 686;
        this.match(jvmBasicParser.LETTERS);
        this.state = 690;
        this._errHandler.sync(this);
        var _alt = this._interp.adaptivePredict(this._input,44,this._ctx)
        while(_alt!=2 && _alt!=antlr4.atn.ATN.INVALID_ALT_NUMBER) {
            if(_alt===1) {
                this.state = 687;
                _la = this._input.LA(1);
                if(!(_la===jvmBasicParser.LETTERS || _la===jvmBasicParser.NUMBER)) {
                this._errHandler.recoverInline(this);
                }
                else {
                    this.consume();
                } 
            }
            this.state = 692;
            this._errHandler.sync(this);
            _alt = this._interp.adaptivePredict(this._input,44,this._ctx);
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

function VarsuffixContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_varsuffix;
    return this;
}

VarsuffixContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
VarsuffixContext.prototype.constructor = VarsuffixContext;

VarsuffixContext.prototype.DOLLAR = function() {
    return this.getToken(jvmBasicParser.DOLLAR, 0);
};

VarsuffixContext.prototype.PERCENT = function() {
    return this.getToken(jvmBasicParser.PERCENT, 0);
};

VarsuffixContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterVarsuffix(this);
	}
};

VarsuffixContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitVarsuffix(this);
	}
};




jvmBasicParser.VarsuffixContext = VarsuffixContext;

jvmBasicParser.prototype.varsuffix = function() {

    var localctx = new VarsuffixContext(this, this._ctx, this.state);
    this.enterRule(localctx, 138, jvmBasicParser.RULE_varsuffix);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 693;
        _la = this._input.LA(1);
        if(!(_la===jvmBasicParser.DOLLAR || _la===jvmBasicParser.PERCENT)) {
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

function VarlistContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_varlist;
    return this;
}

VarlistContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
VarlistContext.prototype.constructor = VarlistContext;

VarlistContext.prototype.vardecl = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(VardeclContext);
    } else {
        return this.getTypedRuleContext(VardeclContext,i);
    }
};

VarlistContext.prototype.COMMA = function(i) {
	if(i===undefined) {
		i = null;
	}
    if(i===null) {
        return this.getTokens(jvmBasicParser.COMMA);
    } else {
        return this.getToken(jvmBasicParser.COMMA, i);
    }
};


VarlistContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterVarlist(this);
	}
};

VarlistContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitVarlist(this);
	}
};




jvmBasicParser.VarlistContext = VarlistContext;

jvmBasicParser.prototype.varlist = function() {

    var localctx = new VarlistContext(this, this._ctx, this.state);
    this.enterRule(localctx, 140, jvmBasicParser.RULE_varlist);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 695;
        this.vardecl();
        this.state = 700;
        this._errHandler.sync(this);
        _la = this._input.LA(1);
        while(_la===jvmBasicParser.COMMA) {
            this.state = 696;
            this.match(jvmBasicParser.COMMA);
            this.state = 697;
            this.vardecl();
            this.state = 702;
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

function ExprlistContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_exprlist;
    return this;
}

ExprlistContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
ExprlistContext.prototype.constructor = ExprlistContext;

ExprlistContext.prototype.expression = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(ExpressionContext);
    } else {
        return this.getTypedRuleContext(ExpressionContext,i);
    }
};

ExprlistContext.prototype.COMMA = function(i) {
	if(i===undefined) {
		i = null;
	}
    if(i===null) {
        return this.getTokens(jvmBasicParser.COMMA);
    } else {
        return this.getToken(jvmBasicParser.COMMA, i);
    }
};


ExprlistContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterExprlist(this);
	}
};

ExprlistContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitExprlist(this);
	}
};




jvmBasicParser.ExprlistContext = ExprlistContext;

jvmBasicParser.prototype.exprlist = function() {

    var localctx = new ExprlistContext(this, this._ctx, this.state);
    this.enterRule(localctx, 142, jvmBasicParser.RULE_exprlist);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 703;
        this.expression();
        this.state = 708;
        this._errHandler.sync(this);
        _la = this._input.LA(1);
        while(_la===jvmBasicParser.COMMA) {
            this.state = 704;
            this.match(jvmBasicParser.COMMA);
            this.state = 705;
            this.expression();
            this.state = 710;
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

function SqrfuncContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_sqrfunc;
    return this;
}

SqrfuncContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
SqrfuncContext.prototype.constructor = SqrfuncContext;

SqrfuncContext.prototype.SQR = function() {
    return this.getToken(jvmBasicParser.SQR, 0);
};

SqrfuncContext.prototype.LPAREN = function() {
    return this.getToken(jvmBasicParser.LPAREN, 0);
};

SqrfuncContext.prototype.expression = function() {
    return this.getTypedRuleContext(ExpressionContext,0);
};

SqrfuncContext.prototype.RPAREN = function() {
    return this.getToken(jvmBasicParser.RPAREN, 0);
};

SqrfuncContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterSqrfunc(this);
	}
};

SqrfuncContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitSqrfunc(this);
	}
};




jvmBasicParser.SqrfuncContext = SqrfuncContext;

jvmBasicParser.prototype.sqrfunc = function() {

    var localctx = new SqrfuncContext(this, this._ctx, this.state);
    this.enterRule(localctx, 144, jvmBasicParser.RULE_sqrfunc);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 711;
        this.match(jvmBasicParser.SQR);
        this.state = 712;
        this.match(jvmBasicParser.LPAREN);
        this.state = 713;
        this.expression();
        this.state = 714;
        this.match(jvmBasicParser.RPAREN);
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

function ChrfuncContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_chrfunc;
    return this;
}

ChrfuncContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
ChrfuncContext.prototype.constructor = ChrfuncContext;

ChrfuncContext.prototype.CHR = function() {
    return this.getToken(jvmBasicParser.CHR, 0);
};

ChrfuncContext.prototype.LPAREN = function() {
    return this.getToken(jvmBasicParser.LPAREN, 0);
};

ChrfuncContext.prototype.expression = function() {
    return this.getTypedRuleContext(ExpressionContext,0);
};

ChrfuncContext.prototype.RPAREN = function() {
    return this.getToken(jvmBasicParser.RPAREN, 0);
};

ChrfuncContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterChrfunc(this);
	}
};

ChrfuncContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitChrfunc(this);
	}
};




jvmBasicParser.ChrfuncContext = ChrfuncContext;

jvmBasicParser.prototype.chrfunc = function() {

    var localctx = new ChrfuncContext(this, this._ctx, this.state);
    this.enterRule(localctx, 146, jvmBasicParser.RULE_chrfunc);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 716;
        this.match(jvmBasicParser.CHR);
        this.state = 717;
        this.match(jvmBasicParser.LPAREN);
        this.state = 718;
        this.expression();
        this.state = 719;
        this.match(jvmBasicParser.RPAREN);
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

function LenfuncContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_lenfunc;
    return this;
}

LenfuncContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
LenfuncContext.prototype.constructor = LenfuncContext;

LenfuncContext.prototype.LEN = function() {
    return this.getToken(jvmBasicParser.LEN, 0);
};

LenfuncContext.prototype.LPAREN = function() {
    return this.getToken(jvmBasicParser.LPAREN, 0);
};

LenfuncContext.prototype.expression = function() {
    return this.getTypedRuleContext(ExpressionContext,0);
};

LenfuncContext.prototype.RPAREN = function() {
    return this.getToken(jvmBasicParser.RPAREN, 0);
};

LenfuncContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterLenfunc(this);
	}
};

LenfuncContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitLenfunc(this);
	}
};




jvmBasicParser.LenfuncContext = LenfuncContext;

jvmBasicParser.prototype.lenfunc = function() {

    var localctx = new LenfuncContext(this, this._ctx, this.state);
    this.enterRule(localctx, 148, jvmBasicParser.RULE_lenfunc);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 721;
        this.match(jvmBasicParser.LEN);
        this.state = 722;
        this.match(jvmBasicParser.LPAREN);
        this.state = 723;
        this.expression();
        this.state = 724;
        this.match(jvmBasicParser.RPAREN);
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

function AscfuncContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_ascfunc;
    return this;
}

AscfuncContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
AscfuncContext.prototype.constructor = AscfuncContext;

AscfuncContext.prototype.ASC = function() {
    return this.getToken(jvmBasicParser.ASC, 0);
};

AscfuncContext.prototype.LPAREN = function() {
    return this.getToken(jvmBasicParser.LPAREN, 0);
};

AscfuncContext.prototype.expression = function() {
    return this.getTypedRuleContext(ExpressionContext,0);
};

AscfuncContext.prototype.RPAREN = function() {
    return this.getToken(jvmBasicParser.RPAREN, 0);
};

AscfuncContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterAscfunc(this);
	}
};

AscfuncContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitAscfunc(this);
	}
};




jvmBasicParser.AscfuncContext = AscfuncContext;

jvmBasicParser.prototype.ascfunc = function() {

    var localctx = new AscfuncContext(this, this._ctx, this.state);
    this.enterRule(localctx, 150, jvmBasicParser.RULE_ascfunc);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 726;
        this.match(jvmBasicParser.ASC);
        this.state = 727;
        this.match(jvmBasicParser.LPAREN);
        this.state = 728;
        this.expression();
        this.state = 729;
        this.match(jvmBasicParser.RPAREN);
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

function MidfuncContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_midfunc;
    return this;
}

MidfuncContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
MidfuncContext.prototype.constructor = MidfuncContext;

MidfuncContext.prototype.MID = function() {
    return this.getToken(jvmBasicParser.MID, 0);
};

MidfuncContext.prototype.LPAREN = function() {
    return this.getToken(jvmBasicParser.LPAREN, 0);
};

MidfuncContext.prototype.expression = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(ExpressionContext);
    } else {
        return this.getTypedRuleContext(ExpressionContext,i);
    }
};

MidfuncContext.prototype.COMMA = function(i) {
	if(i===undefined) {
		i = null;
	}
    if(i===null) {
        return this.getTokens(jvmBasicParser.COMMA);
    } else {
        return this.getToken(jvmBasicParser.COMMA, i);
    }
};


MidfuncContext.prototype.RPAREN = function() {
    return this.getToken(jvmBasicParser.RPAREN, 0);
};

MidfuncContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterMidfunc(this);
	}
};

MidfuncContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitMidfunc(this);
	}
};




jvmBasicParser.MidfuncContext = MidfuncContext;

jvmBasicParser.prototype.midfunc = function() {

    var localctx = new MidfuncContext(this, this._ctx, this.state);
    this.enterRule(localctx, 152, jvmBasicParser.RULE_midfunc);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 731;
        this.match(jvmBasicParser.MID);
        this.state = 732;
        this.match(jvmBasicParser.LPAREN);
        this.state = 733;
        this.expression();
        this.state = 734;
        this.match(jvmBasicParser.COMMA);
        this.state = 735;
        this.expression();
        this.state = 736;
        this.match(jvmBasicParser.COMMA);
        this.state = 737;
        this.expression();
        this.state = 738;
        this.match(jvmBasicParser.RPAREN);
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

function PdlfuncContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_pdlfunc;
    return this;
}

PdlfuncContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
PdlfuncContext.prototype.constructor = PdlfuncContext;

PdlfuncContext.prototype.PDL = function() {
    return this.getToken(jvmBasicParser.PDL, 0);
};

PdlfuncContext.prototype.LPAREN = function() {
    return this.getToken(jvmBasicParser.LPAREN, 0);
};

PdlfuncContext.prototype.expression = function() {
    return this.getTypedRuleContext(ExpressionContext,0);
};

PdlfuncContext.prototype.RPAREN = function() {
    return this.getToken(jvmBasicParser.RPAREN, 0);
};

PdlfuncContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterPdlfunc(this);
	}
};

PdlfuncContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitPdlfunc(this);
	}
};




jvmBasicParser.PdlfuncContext = PdlfuncContext;

jvmBasicParser.prototype.pdlfunc = function() {

    var localctx = new PdlfuncContext(this, this._ctx, this.state);
    this.enterRule(localctx, 154, jvmBasicParser.RULE_pdlfunc);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 740;
        this.match(jvmBasicParser.PDL);
        this.state = 741;
        this.match(jvmBasicParser.LPAREN);
        this.state = 742;
        this.expression();
        this.state = 743;
        this.match(jvmBasicParser.RPAREN);
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

function PeekfuncContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_peekfunc;
    return this;
}

PeekfuncContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
PeekfuncContext.prototype.constructor = PeekfuncContext;

PeekfuncContext.prototype.PEEK = function() {
    return this.getToken(jvmBasicParser.PEEK, 0);
};

PeekfuncContext.prototype.LPAREN = function() {
    return this.getToken(jvmBasicParser.LPAREN, 0);
};

PeekfuncContext.prototype.expression = function() {
    return this.getTypedRuleContext(ExpressionContext,0);
};

PeekfuncContext.prototype.RPAREN = function() {
    return this.getToken(jvmBasicParser.RPAREN, 0);
};

PeekfuncContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterPeekfunc(this);
	}
};

PeekfuncContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitPeekfunc(this);
	}
};




jvmBasicParser.PeekfuncContext = PeekfuncContext;

jvmBasicParser.prototype.peekfunc = function() {

    var localctx = new PeekfuncContext(this, this._ctx, this.state);
    this.enterRule(localctx, 156, jvmBasicParser.RULE_peekfunc);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 745;
        this.match(jvmBasicParser.PEEK);
        this.state = 746;
        this.match(jvmBasicParser.LPAREN);
        this.state = 747;
        this.expression();
        this.state = 748;
        this.match(jvmBasicParser.RPAREN);
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

function IntfuncContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_intfunc;
    return this;
}

IntfuncContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
IntfuncContext.prototype.constructor = IntfuncContext;

IntfuncContext.prototype.INTF = function() {
    return this.getToken(jvmBasicParser.INTF, 0);
};

IntfuncContext.prototype.LPAREN = function() {
    return this.getToken(jvmBasicParser.LPAREN, 0);
};

IntfuncContext.prototype.expression = function() {
    return this.getTypedRuleContext(ExpressionContext,0);
};

IntfuncContext.prototype.RPAREN = function() {
    return this.getToken(jvmBasicParser.RPAREN, 0);
};

IntfuncContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterIntfunc(this);
	}
};

IntfuncContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitIntfunc(this);
	}
};




jvmBasicParser.IntfuncContext = IntfuncContext;

jvmBasicParser.prototype.intfunc = function() {

    var localctx = new IntfuncContext(this, this._ctx, this.state);
    this.enterRule(localctx, 158, jvmBasicParser.RULE_intfunc);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 750;
        this.match(jvmBasicParser.INTF);
        this.state = 751;
        this.match(jvmBasicParser.LPAREN);
        this.state = 752;
        this.expression();
        this.state = 753;
        this.match(jvmBasicParser.RPAREN);
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

function SpcfuncContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_spcfunc;
    return this;
}

SpcfuncContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
SpcfuncContext.prototype.constructor = SpcfuncContext;

SpcfuncContext.prototype.SPC = function() {
    return this.getToken(jvmBasicParser.SPC, 0);
};

SpcfuncContext.prototype.LPAREN = function() {
    return this.getToken(jvmBasicParser.LPAREN, 0);
};

SpcfuncContext.prototype.expression = function() {
    return this.getTypedRuleContext(ExpressionContext,0);
};

SpcfuncContext.prototype.RPAREN = function() {
    return this.getToken(jvmBasicParser.RPAREN, 0);
};

SpcfuncContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterSpcfunc(this);
	}
};

SpcfuncContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitSpcfunc(this);
	}
};




jvmBasicParser.SpcfuncContext = SpcfuncContext;

jvmBasicParser.prototype.spcfunc = function() {

    var localctx = new SpcfuncContext(this, this._ctx, this.state);
    this.enterRule(localctx, 160, jvmBasicParser.RULE_spcfunc);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 755;
        this.match(jvmBasicParser.SPC);
        this.state = 756;
        this.match(jvmBasicParser.LPAREN);
        this.state = 757;
        this.expression();
        this.state = 758;
        this.match(jvmBasicParser.RPAREN);
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

function FrefuncContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_frefunc;
    return this;
}

FrefuncContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
FrefuncContext.prototype.constructor = FrefuncContext;

FrefuncContext.prototype.FRE = function() {
    return this.getToken(jvmBasicParser.FRE, 0);
};

FrefuncContext.prototype.LPAREN = function() {
    return this.getToken(jvmBasicParser.LPAREN, 0);
};

FrefuncContext.prototype.expression = function() {
    return this.getTypedRuleContext(ExpressionContext,0);
};

FrefuncContext.prototype.RPAREN = function() {
    return this.getToken(jvmBasicParser.RPAREN, 0);
};

FrefuncContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterFrefunc(this);
	}
};

FrefuncContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitFrefunc(this);
	}
};




jvmBasicParser.FrefuncContext = FrefuncContext;

jvmBasicParser.prototype.frefunc = function() {

    var localctx = new FrefuncContext(this, this._ctx, this.state);
    this.enterRule(localctx, 162, jvmBasicParser.RULE_frefunc);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 760;
        this.match(jvmBasicParser.FRE);
        this.state = 761;
        this.match(jvmBasicParser.LPAREN);
        this.state = 762;
        this.expression();
        this.state = 763;
        this.match(jvmBasicParser.RPAREN);
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

function PosfuncContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_posfunc;
    return this;
}

PosfuncContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
PosfuncContext.prototype.constructor = PosfuncContext;

PosfuncContext.prototype.POS = function() {
    return this.getToken(jvmBasicParser.POS, 0);
};

PosfuncContext.prototype.LPAREN = function() {
    return this.getToken(jvmBasicParser.LPAREN, 0);
};

PosfuncContext.prototype.expression = function() {
    return this.getTypedRuleContext(ExpressionContext,0);
};

PosfuncContext.prototype.RPAREN = function() {
    return this.getToken(jvmBasicParser.RPAREN, 0);
};

PosfuncContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterPosfunc(this);
	}
};

PosfuncContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitPosfunc(this);
	}
};




jvmBasicParser.PosfuncContext = PosfuncContext;

jvmBasicParser.prototype.posfunc = function() {

    var localctx = new PosfuncContext(this, this._ctx, this.state);
    this.enterRule(localctx, 164, jvmBasicParser.RULE_posfunc);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 765;
        this.match(jvmBasicParser.POS);
        this.state = 766;
        this.match(jvmBasicParser.LPAREN);
        this.state = 767;
        this.expression();
        this.state = 768;
        this.match(jvmBasicParser.RPAREN);
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

function UsrfuncContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_usrfunc;
    return this;
}

UsrfuncContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
UsrfuncContext.prototype.constructor = UsrfuncContext;

UsrfuncContext.prototype.USR = function() {
    return this.getToken(jvmBasicParser.USR, 0);
};

UsrfuncContext.prototype.LPAREN = function() {
    return this.getToken(jvmBasicParser.LPAREN, 0);
};

UsrfuncContext.prototype.expression = function() {
    return this.getTypedRuleContext(ExpressionContext,0);
};

UsrfuncContext.prototype.RPAREN = function() {
    return this.getToken(jvmBasicParser.RPAREN, 0);
};

UsrfuncContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterUsrfunc(this);
	}
};

UsrfuncContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitUsrfunc(this);
	}
};




jvmBasicParser.UsrfuncContext = UsrfuncContext;

jvmBasicParser.prototype.usrfunc = function() {

    var localctx = new UsrfuncContext(this, this._ctx, this.state);
    this.enterRule(localctx, 166, jvmBasicParser.RULE_usrfunc);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 770;
        this.match(jvmBasicParser.USR);
        this.state = 771;
        this.match(jvmBasicParser.LPAREN);
        this.state = 772;
        this.expression();
        this.state = 773;
        this.match(jvmBasicParser.RPAREN);
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

function LeftfuncContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_leftfunc;
    return this;
}

LeftfuncContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
LeftfuncContext.prototype.constructor = LeftfuncContext;

LeftfuncContext.prototype.LEFT = function() {
    return this.getToken(jvmBasicParser.LEFT, 0);
};

LeftfuncContext.prototype.LPAREN = function() {
    return this.getToken(jvmBasicParser.LPAREN, 0);
};

LeftfuncContext.prototype.expression = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(ExpressionContext);
    } else {
        return this.getTypedRuleContext(ExpressionContext,i);
    }
};

LeftfuncContext.prototype.COMMA = function() {
    return this.getToken(jvmBasicParser.COMMA, 0);
};

LeftfuncContext.prototype.RPAREN = function() {
    return this.getToken(jvmBasicParser.RPAREN, 0);
};

LeftfuncContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterLeftfunc(this);
	}
};

LeftfuncContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitLeftfunc(this);
	}
};




jvmBasicParser.LeftfuncContext = LeftfuncContext;

jvmBasicParser.prototype.leftfunc = function() {

    var localctx = new LeftfuncContext(this, this._ctx, this.state);
    this.enterRule(localctx, 168, jvmBasicParser.RULE_leftfunc);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 775;
        this.match(jvmBasicParser.LEFT);
        this.state = 776;
        this.match(jvmBasicParser.LPAREN);
        this.state = 777;
        this.expression();
        this.state = 778;
        this.match(jvmBasicParser.COMMA);
        this.state = 779;
        this.expression();
        this.state = 780;
        this.match(jvmBasicParser.RPAREN);
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

function RightfuncContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_rightfunc;
    return this;
}

RightfuncContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
RightfuncContext.prototype.constructor = RightfuncContext;

RightfuncContext.prototype.RIGHT = function() {
    return this.getToken(jvmBasicParser.RIGHT, 0);
};

RightfuncContext.prototype.LPAREN = function() {
    return this.getToken(jvmBasicParser.LPAREN, 0);
};

RightfuncContext.prototype.expression = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(ExpressionContext);
    } else {
        return this.getTypedRuleContext(ExpressionContext,i);
    }
};

RightfuncContext.prototype.COMMA = function() {
    return this.getToken(jvmBasicParser.COMMA, 0);
};

RightfuncContext.prototype.RPAREN = function() {
    return this.getToken(jvmBasicParser.RPAREN, 0);
};

RightfuncContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterRightfunc(this);
	}
};

RightfuncContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitRightfunc(this);
	}
};




jvmBasicParser.RightfuncContext = RightfuncContext;

jvmBasicParser.prototype.rightfunc = function() {

    var localctx = new RightfuncContext(this, this._ctx, this.state);
    this.enterRule(localctx, 170, jvmBasicParser.RULE_rightfunc);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 782;
        this.match(jvmBasicParser.RIGHT);
        this.state = 783;
        this.match(jvmBasicParser.LPAREN);
        this.state = 784;
        this.expression();
        this.state = 785;
        this.match(jvmBasicParser.COMMA);
        this.state = 786;
        this.expression();
        this.state = 787;
        this.match(jvmBasicParser.RPAREN);
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

function StrfuncContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_strfunc;
    return this;
}

StrfuncContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
StrfuncContext.prototype.constructor = StrfuncContext;

StrfuncContext.prototype.STR = function() {
    return this.getToken(jvmBasicParser.STR, 0);
};

StrfuncContext.prototype.LPAREN = function() {
    return this.getToken(jvmBasicParser.LPAREN, 0);
};

StrfuncContext.prototype.expression = function() {
    return this.getTypedRuleContext(ExpressionContext,0);
};

StrfuncContext.prototype.RPAREN = function() {
    return this.getToken(jvmBasicParser.RPAREN, 0);
};

StrfuncContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterStrfunc(this);
	}
};

StrfuncContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitStrfunc(this);
	}
};




jvmBasicParser.StrfuncContext = StrfuncContext;

jvmBasicParser.prototype.strfunc = function() {

    var localctx = new StrfuncContext(this, this._ctx, this.state);
    this.enterRule(localctx, 172, jvmBasicParser.RULE_strfunc);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 789;
        this.match(jvmBasicParser.STR);
        this.state = 790;
        this.match(jvmBasicParser.LPAREN);
        this.state = 791;
        this.expression();
        this.state = 792;
        this.match(jvmBasicParser.RPAREN);
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

function FnfuncContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_fnfunc;
    return this;
}

FnfuncContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
FnfuncContext.prototype.constructor = FnfuncContext;

FnfuncContext.prototype.FN = function() {
    return this.getToken(jvmBasicParser.FN, 0);
};

FnfuncContext.prototype.var = function() {
    return this.getTypedRuleContext(VarContext,0);
};

FnfuncContext.prototype.LPAREN = function() {
    return this.getToken(jvmBasicParser.LPAREN, 0);
};

FnfuncContext.prototype.expression = function() {
    return this.getTypedRuleContext(ExpressionContext,0);
};

FnfuncContext.prototype.RPAREN = function() {
    return this.getToken(jvmBasicParser.RPAREN, 0);
};

FnfuncContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterFnfunc(this);
	}
};

FnfuncContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitFnfunc(this);
	}
};




jvmBasicParser.FnfuncContext = FnfuncContext;

jvmBasicParser.prototype.fnfunc = function() {

    var localctx = new FnfuncContext(this, this._ctx, this.state);
    this.enterRule(localctx, 174, jvmBasicParser.RULE_fnfunc);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 794;
        this.match(jvmBasicParser.FN);
        this.state = 795;
        this.var();
        this.state = 796;
        this.match(jvmBasicParser.LPAREN);
        this.state = 797;
        this.expression();
        this.state = 798;
        this.match(jvmBasicParser.RPAREN);
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

function ValfuncContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_valfunc;
    return this;
}

ValfuncContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
ValfuncContext.prototype.constructor = ValfuncContext;

ValfuncContext.prototype.VAL = function() {
    return this.getToken(jvmBasicParser.VAL, 0);
};

ValfuncContext.prototype.LPAREN = function() {
    return this.getToken(jvmBasicParser.LPAREN, 0);
};

ValfuncContext.prototype.expression = function() {
    return this.getTypedRuleContext(ExpressionContext,0);
};

ValfuncContext.prototype.RPAREN = function() {
    return this.getToken(jvmBasicParser.RPAREN, 0);
};

ValfuncContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterValfunc(this);
	}
};

ValfuncContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitValfunc(this);
	}
};




jvmBasicParser.ValfuncContext = ValfuncContext;

jvmBasicParser.prototype.valfunc = function() {

    var localctx = new ValfuncContext(this, this._ctx, this.state);
    this.enterRule(localctx, 176, jvmBasicParser.RULE_valfunc);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 800;
        this.match(jvmBasicParser.VAL);
        this.state = 801;
        this.match(jvmBasicParser.LPAREN);
        this.state = 802;
        this.expression();
        this.state = 803;
        this.match(jvmBasicParser.RPAREN);
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

function ScrnfuncContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_scrnfunc;
    return this;
}

ScrnfuncContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
ScrnfuncContext.prototype.constructor = ScrnfuncContext;

ScrnfuncContext.prototype.SCRN = function() {
    return this.getToken(jvmBasicParser.SCRN, 0);
};

ScrnfuncContext.prototype.LPAREN = function() {
    return this.getToken(jvmBasicParser.LPAREN, 0);
};

ScrnfuncContext.prototype.expression = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(ExpressionContext);
    } else {
        return this.getTypedRuleContext(ExpressionContext,i);
    }
};

ScrnfuncContext.prototype.COMMA = function() {
    return this.getToken(jvmBasicParser.COMMA, 0);
};

ScrnfuncContext.prototype.RPAREN = function() {
    return this.getToken(jvmBasicParser.RPAREN, 0);
};

ScrnfuncContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterScrnfunc(this);
	}
};

ScrnfuncContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitScrnfunc(this);
	}
};




jvmBasicParser.ScrnfuncContext = ScrnfuncContext;

jvmBasicParser.prototype.scrnfunc = function() {

    var localctx = new ScrnfuncContext(this, this._ctx, this.state);
    this.enterRule(localctx, 178, jvmBasicParser.RULE_scrnfunc);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 805;
        this.match(jvmBasicParser.SCRN);
        this.state = 806;
        this.match(jvmBasicParser.LPAREN);
        this.state = 807;
        this.expression();
        this.state = 808;
        this.match(jvmBasicParser.COMMA);
        this.state = 809;
        this.expression();
        this.state = 810;
        this.match(jvmBasicParser.RPAREN);
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

function SinfuncContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_sinfunc;
    return this;
}

SinfuncContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
SinfuncContext.prototype.constructor = SinfuncContext;

SinfuncContext.prototype.SIN = function() {
    return this.getToken(jvmBasicParser.SIN, 0);
};

SinfuncContext.prototype.LPAREN = function() {
    return this.getToken(jvmBasicParser.LPAREN, 0);
};

SinfuncContext.prototype.expression = function() {
    return this.getTypedRuleContext(ExpressionContext,0);
};

SinfuncContext.prototype.RPAREN = function() {
    return this.getToken(jvmBasicParser.RPAREN, 0);
};

SinfuncContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterSinfunc(this);
	}
};

SinfuncContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitSinfunc(this);
	}
};




jvmBasicParser.SinfuncContext = SinfuncContext;

jvmBasicParser.prototype.sinfunc = function() {

    var localctx = new SinfuncContext(this, this._ctx, this.state);
    this.enterRule(localctx, 180, jvmBasicParser.RULE_sinfunc);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 812;
        this.match(jvmBasicParser.SIN);
        this.state = 813;
        this.match(jvmBasicParser.LPAREN);
        this.state = 814;
        this.expression();
        this.state = 815;
        this.match(jvmBasicParser.RPAREN);
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

function CosfuncContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_cosfunc;
    return this;
}

CosfuncContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
CosfuncContext.prototype.constructor = CosfuncContext;

CosfuncContext.prototype.COS = function() {
    return this.getToken(jvmBasicParser.COS, 0);
};

CosfuncContext.prototype.LPAREN = function() {
    return this.getToken(jvmBasicParser.LPAREN, 0);
};

CosfuncContext.prototype.expression = function() {
    return this.getTypedRuleContext(ExpressionContext,0);
};

CosfuncContext.prototype.RPAREN = function() {
    return this.getToken(jvmBasicParser.RPAREN, 0);
};

CosfuncContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterCosfunc(this);
	}
};

CosfuncContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitCosfunc(this);
	}
};




jvmBasicParser.CosfuncContext = CosfuncContext;

jvmBasicParser.prototype.cosfunc = function() {

    var localctx = new CosfuncContext(this, this._ctx, this.state);
    this.enterRule(localctx, 182, jvmBasicParser.RULE_cosfunc);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 817;
        this.match(jvmBasicParser.COS);
        this.state = 818;
        this.match(jvmBasicParser.LPAREN);
        this.state = 819;
        this.expression();
        this.state = 820;
        this.match(jvmBasicParser.RPAREN);
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

function TanfuncContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_tanfunc;
    return this;
}

TanfuncContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
TanfuncContext.prototype.constructor = TanfuncContext;

TanfuncContext.prototype.TAN = function() {
    return this.getToken(jvmBasicParser.TAN, 0);
};

TanfuncContext.prototype.LPAREN = function() {
    return this.getToken(jvmBasicParser.LPAREN, 0);
};

TanfuncContext.prototype.expression = function() {
    return this.getTypedRuleContext(ExpressionContext,0);
};

TanfuncContext.prototype.RPAREN = function() {
    return this.getToken(jvmBasicParser.RPAREN, 0);
};

TanfuncContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterTanfunc(this);
	}
};

TanfuncContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitTanfunc(this);
	}
};




jvmBasicParser.TanfuncContext = TanfuncContext;

jvmBasicParser.prototype.tanfunc = function() {

    var localctx = new TanfuncContext(this, this._ctx, this.state);
    this.enterRule(localctx, 184, jvmBasicParser.RULE_tanfunc);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 822;
        this.match(jvmBasicParser.TAN);
        this.state = 823;
        this.match(jvmBasicParser.LPAREN);
        this.state = 824;
        this.expression();
        this.state = 825;
        this.match(jvmBasicParser.RPAREN);
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

function AtnfuncContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_atnfunc;
    return this;
}

AtnfuncContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
AtnfuncContext.prototype.constructor = AtnfuncContext;

AtnfuncContext.prototype.ATAN = function() {
    return this.getToken(jvmBasicParser.ATAN, 0);
};

AtnfuncContext.prototype.LPAREN = function() {
    return this.getToken(jvmBasicParser.LPAREN, 0);
};

AtnfuncContext.prototype.expression = function() {
    return this.getTypedRuleContext(ExpressionContext,0);
};

AtnfuncContext.prototype.RPAREN = function() {
    return this.getToken(jvmBasicParser.RPAREN, 0);
};

AtnfuncContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterAtnfunc(this);
	}
};

AtnfuncContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitAtnfunc(this);
	}
};




jvmBasicParser.AtnfuncContext = AtnfuncContext;

jvmBasicParser.prototype.atnfunc = function() {

    var localctx = new AtnfuncContext(this, this._ctx, this.state);
    this.enterRule(localctx, 186, jvmBasicParser.RULE_atnfunc);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 827;
        this.match(jvmBasicParser.ATAN);
        this.state = 828;
        this.match(jvmBasicParser.LPAREN);
        this.state = 829;
        this.expression();
        this.state = 830;
        this.match(jvmBasicParser.RPAREN);
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

function RndfuncContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_rndfunc;
    return this;
}

RndfuncContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
RndfuncContext.prototype.constructor = RndfuncContext;

RndfuncContext.prototype.RND = function() {
    return this.getToken(jvmBasicParser.RND, 0);
};

RndfuncContext.prototype.LPAREN = function() {
    return this.getToken(jvmBasicParser.LPAREN, 0);
};

RndfuncContext.prototype.expression = function() {
    return this.getTypedRuleContext(ExpressionContext,0);
};

RndfuncContext.prototype.RPAREN = function() {
    return this.getToken(jvmBasicParser.RPAREN, 0);
};

RndfuncContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterRndfunc(this);
	}
};

RndfuncContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitRndfunc(this);
	}
};




jvmBasicParser.RndfuncContext = RndfuncContext;

jvmBasicParser.prototype.rndfunc = function() {

    var localctx = new RndfuncContext(this, this._ctx, this.state);
    this.enterRule(localctx, 188, jvmBasicParser.RULE_rndfunc);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 832;
        this.match(jvmBasicParser.RND);
        this.state = 833;
        this.match(jvmBasicParser.LPAREN);
        this.state = 834;
        this.expression();
        this.state = 835;
        this.match(jvmBasicParser.RPAREN);
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

function SgnfuncContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_sgnfunc;
    return this;
}

SgnfuncContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
SgnfuncContext.prototype.constructor = SgnfuncContext;

SgnfuncContext.prototype.SGN = function() {
    return this.getToken(jvmBasicParser.SGN, 0);
};

SgnfuncContext.prototype.LPAREN = function() {
    return this.getToken(jvmBasicParser.LPAREN, 0);
};

SgnfuncContext.prototype.expression = function() {
    return this.getTypedRuleContext(ExpressionContext,0);
};

SgnfuncContext.prototype.RPAREN = function() {
    return this.getToken(jvmBasicParser.RPAREN, 0);
};

SgnfuncContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterSgnfunc(this);
	}
};

SgnfuncContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitSgnfunc(this);
	}
};




jvmBasicParser.SgnfuncContext = SgnfuncContext;

jvmBasicParser.prototype.sgnfunc = function() {

    var localctx = new SgnfuncContext(this, this._ctx, this.state);
    this.enterRule(localctx, 190, jvmBasicParser.RULE_sgnfunc);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 837;
        this.match(jvmBasicParser.SGN);
        this.state = 838;
        this.match(jvmBasicParser.LPAREN);
        this.state = 839;
        this.expression();
        this.state = 840;
        this.match(jvmBasicParser.RPAREN);
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

function ExpfuncContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_expfunc;
    return this;
}

ExpfuncContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
ExpfuncContext.prototype.constructor = ExpfuncContext;

ExpfuncContext.prototype.EXP = function() {
    return this.getToken(jvmBasicParser.EXP, 0);
};

ExpfuncContext.prototype.LPAREN = function() {
    return this.getToken(jvmBasicParser.LPAREN, 0);
};

ExpfuncContext.prototype.expression = function() {
    return this.getTypedRuleContext(ExpressionContext,0);
};

ExpfuncContext.prototype.RPAREN = function() {
    return this.getToken(jvmBasicParser.RPAREN, 0);
};

ExpfuncContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterExpfunc(this);
	}
};

ExpfuncContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitExpfunc(this);
	}
};




jvmBasicParser.ExpfuncContext = ExpfuncContext;

jvmBasicParser.prototype.expfunc = function() {

    var localctx = new ExpfuncContext(this, this._ctx, this.state);
    this.enterRule(localctx, 192, jvmBasicParser.RULE_expfunc);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 842;
        this.match(jvmBasicParser.EXP);
        this.state = 843;
        this.match(jvmBasicParser.LPAREN);
        this.state = 844;
        this.expression();
        this.state = 845;
        this.match(jvmBasicParser.RPAREN);
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

function LogfuncContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_logfunc;
    return this;
}

LogfuncContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
LogfuncContext.prototype.constructor = LogfuncContext;

LogfuncContext.prototype.LOG = function() {
    return this.getToken(jvmBasicParser.LOG, 0);
};

LogfuncContext.prototype.LPAREN = function() {
    return this.getToken(jvmBasicParser.LPAREN, 0);
};

LogfuncContext.prototype.expression = function() {
    return this.getTypedRuleContext(ExpressionContext,0);
};

LogfuncContext.prototype.RPAREN = function() {
    return this.getToken(jvmBasicParser.RPAREN, 0);
};

LogfuncContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterLogfunc(this);
	}
};

LogfuncContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitLogfunc(this);
	}
};




jvmBasicParser.LogfuncContext = LogfuncContext;

jvmBasicParser.prototype.logfunc = function() {

    var localctx = new LogfuncContext(this, this._ctx, this.state);
    this.enterRule(localctx, 194, jvmBasicParser.RULE_logfunc);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 847;
        this.match(jvmBasicParser.LOG);
        this.state = 848;
        this.match(jvmBasicParser.LPAREN);
        this.state = 849;
        this.expression();
        this.state = 850;
        this.match(jvmBasicParser.RPAREN);
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

function AbsfuncContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = jvmBasicParser.RULE_absfunc;
    return this;
}

AbsfuncContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
AbsfuncContext.prototype.constructor = AbsfuncContext;

AbsfuncContext.prototype.ABS = function() {
    return this.getToken(jvmBasicParser.ABS, 0);
};

AbsfuncContext.prototype.LPAREN = function() {
    return this.getToken(jvmBasicParser.LPAREN, 0);
};

AbsfuncContext.prototype.expression = function() {
    return this.getTypedRuleContext(ExpressionContext,0);
};

AbsfuncContext.prototype.RPAREN = function() {
    return this.getToken(jvmBasicParser.RPAREN, 0);
};

AbsfuncContext.prototype.enterRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.enterAbsfunc(this);
	}
};

AbsfuncContext.prototype.exitRule = function(listener) {
    if(listener instanceof jvmBasicListener ) {
        listener.exitAbsfunc(this);
	}
};




jvmBasicParser.AbsfuncContext = AbsfuncContext;

jvmBasicParser.prototype.absfunc = function() {

    var localctx = new AbsfuncContext(this, this._ctx, this.state);
    this.enterRule(localctx, 196, jvmBasicParser.RULE_absfunc);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 852;
        this.match(jvmBasicParser.ABS);
        this.state = 853;
        this.match(jvmBasicParser.LPAREN);
        this.state = 854;
        this.expression();
        this.state = 855;
        this.match(jvmBasicParser.RPAREN);
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


exports.jvmBasicParser = jvmBasicParser;
