// Generated from CSharpPreprocessorParser.g4 by ANTLR 4.7.1
// jshint ignore: start
var antlr4 = require('antlr4/index');
var CSharpPreprocessorParserListener = require('./CSharpPreprocessorParserListener').CSharpPreprocessorParserListener;
var grammarFileName = "CSharpPreprocessorParser.g4";

var serializedATN = ["\u0003\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964",
    "\u0003\u00c2\u010a\u0004\u0002\t\u0002\u0004\u0003\t\u0003\u0004\u0004",
    "\t\u0004\u0004\u0005\t\u0005\u0004\u0006\t\u0006\u0004\u0007\t\u0007",
    "\u0003\u0002\u0003\u0002\u0003\u0002\u0003\u0002\u0003\u0002\u0003\u0002",
    "\u0003\u0002\u0003\u0002\u0003\u0002\u0003\u0002\u0003\u0002\u0003\u0002",
    "\u0003\u0002\u0003\u0002\u0003\u0002\u0003\u0002\u0003\u0002\u0003\u0002",
    "\u0003\u0002\u0003\u0002\u0003\u0002\u0003\u0002\u0003\u0002\u0003\u0002",
    "\u0003\u0002\u0003\u0002\u0003\u0002\u0003\u0002\u0003\u0002\u0003\u0002",
    "\u0003\u0002\u0005\u0002.\n\u0002\u0003\u0002\u0003\u0002\u0005\u0002",
    "2\n\u0002\u0003\u0002\u0003\u0002\u0003\u0002\u0003\u0002\u0003\u0002",
    "\u0003\u0002\u0003\u0002\u0003\u0002\u0003\u0002\u0003\u0002\u0003\u0002",
    "\u0003\u0002\u0003\u0002\u0003\u0002\u0003\u0002\u0005\u0002C\n\u0002",
    "\u0003\u0002\u0003\u0002\u0003\u0002\u0003\u0002\u0003\u0002\u0005\u0002",
    "J\n\u0002\u0003\u0002\u0003\u0002\u0003\u0002\u0003\u0002\u0003\u0002",
    "\u0003\u0002\u0003\u0002\u0003\u0002\u0005\u0002T\n\u0002\u0003\u0003",
    "\u0003\u0003\u0003\u0004\u0003\u0004\u0003\u0004\u0003\u0004\u0003\u0004",
    "\u0003\u0004\u0003\u0004\u0003\u0004\u0003\u0004\u0003\u0004\u0003\u0004",
    "\u0003\u0004\u0003\u0004\u0003\u0004\u0003\u0004\u0003\u0004\u0005\u0004",
    "h\n\u0004\u0003\u0004\u0003\u0004\u0003\u0004\u0003\u0004\u0003\u0004",
    "\u0003\u0004\u0003\u0004\u0003\u0004\u0003\u0004\u0003\u0004\u0003\u0004",
    "\u0003\u0004\u0003\u0004\u0003\u0004\u0003\u0004\u0003\u0004\u0003\u0004",
    "\u0003\u0004\u0003\u0004\u0003\u0004\u0007\u0004~\n\u0004\f\u0004\u000e",
    "\u0004\u0081\u000b\u0004\u0003\u0005\u0003\u0005\u0003\u0005\u0003\u0005",
    "\u0003\u0005\u0003\u0005\u0003\u0005\u0003\u0005\u0003\u0005\u0003\u0005",
    "\u0003\u0005\u0003\u0005\u0003\u0005\u0003\u0005\u0003\u0005\u0003\u0005",
    "\u0003\u0005\u0003\u0005\u0003\u0005\u0003\u0005\u0003\u0005\u0003\u0005",
    "\u0003\u0005\u0003\u0005\u0003\u0005\u0003\u0005\u0003\u0005\u0003\u0005",
    "\u0003\u0005\u0003\u0005\u0003\u0005\u0003\u0005\u0003\u0005\u0003\u0005",
    "\u0003\u0005\u0003\u0005\u0003\u0005\u0005\u0005\u00a8\n\u0005\u0003",
    "\u0005\u0003\u0005\u0005\u0005\u00ac\n\u0005\u0003\u0005\u0003\u0005",
    "\u0003\u0005\u0003\u0005\u0003\u0005\u0003\u0005\u0003\u0005\u0003\u0005",
    "\u0003\u0005\u0003\u0005\u0003\u0005\u0003\u0005\u0003\u0005\u0003\u0005",
    "\u0003\u0005\u0003\u0005\u0003\u0005\u0003\u0005\u0005\u0005\u00c0\n",
    "\u0005\u0003\u0005\u0003\u0005\u0003\u0005\u0003\u0005\u0003\u0005\u0003",
    "\u0005\u0005\u0005\u00c8\n\u0005\u0003\u0005\u0003\u0005\u0003\u0005",
    "\u0003\u0005\u0003\u0005\u0003\u0005\u0003\u0005\u0003\u0005\u0003\u0005",
    "\u0003\u0005\u0005\u0005\u00d4\n\u0005\u0003\u0006\u0003\u0006\u0003",
    "\u0006\u0003\u0006\u0005\u0006\u00da\n\u0006\u0003\u0007\u0003\u0007",
    "\u0003\u0007\u0003\u0007\u0003\u0007\u0003\u0007\u0003\u0007\u0003\u0007",
    "\u0003\u0007\u0003\u0007\u0003\u0007\u0003\u0007\u0003\u0007\u0003\u0007",
    "\u0003\u0007\u0003\u0007\u0003\u0007\u0003\u0007\u0003\u0007\u0003\u0007",
    "\u0003\u0007\u0003\u0007\u0003\u0007\u0003\u0007\u0003\u0007\u0003\u0007",
    "\u0003\u0007\u0003\u0007\u0003\u0007\u0003\u0007\u0003\u0007\u0003\u0007",
    "\u0003\u0007\u0003\u0007\u0003\u0007\u0003\u0007\u0003\u0007\u0003\u0007",
    "\u0003\u0007\u0003\u0007\u0003\u0007\u0003\u0007\u0003\u0007\u0003\u0007",
    "\u0005\u0007\u0108\n\u0007\u0003\u0007\u0002\u0003\u0006\b\u0002\u0004",
    "\u0006\b\n\f\u0002\u0003\u0003\u0003\u00c0\u00c0\u0002\u0134\u0002S",
    "\u0003\u0002\u0002\u0002\u0004U\u0003\u0002\u0002\u0002\u0006g\u0003",
    "\u0002\u0002\u0002\b\u00d3\u0003\u0002\u0002\u0002\n\u00d9\u0003\u0002",
    "\u0002\u0002\f\u0107\u0003\u0002\u0002\u0002\u000e\u000f\u0007\u00b4",
    "\u0002\u0002\u000f\u0010\u0007\u00bf\u0002\u0002\u0010\u0011\u0005\u0004",
    "\u0003\u0002\u0011\u0012\b\u0002\u0001\u0002\u0012T\u0003\u0002\u0002",
    "\u0002\u0013\u0014\u0007\u00b5\u0002\u0002\u0014\u0015\u0007\u00bf\u0002",
    "\u0002\u0015\u0016\u0005\u0004\u0003\u0002\u0016\u0017\b\u0002\u0001",
    "\u0002\u0017T\u0003\u0002\u0002\u0002\u0018\u0019\u00075\u0002\u0002",
    "\u0019\u001a\u0005\u0006\u0004\u0002\u001a\u001b\u0005\u0004\u0003\u0002",
    "\u001b\u001c\b\u0002\u0001\u0002\u001cT\u0003\u0002\u0002\u0002\u001d",
    "\u001e\u0007\u00b6\u0002\u0002\u001e\u001f\u0005\u0006\u0004\u0002\u001f",
    " \u0005\u0004\u0003\u0002 !\b\u0002\u0001\u0002!T\u0003\u0002\u0002",
    "\u0002\"#\u0007%\u0002\u0002#$\u0005\u0004\u0003\u0002$%\b\u0002\u0001",
    "\u0002%T\u0003\u0002\u0002\u0002&\'\u0007\u00b7\u0002\u0002\'(\u0005",
    "\u0004\u0003\u0002()\b\u0002\u0001\u0002)T\u0003\u0002\u0002\u0002*",
    "1\u0007\u00b8\u0002\u0002+-\u0007\u00b3\u0002\u0002,.\u0007\\\u0002",
    "\u0002-,\u0003\u0002\u0002\u0002-.\u0003\u0002\u0002\u0002.2\u0003\u0002",
    "\u0002\u0002/2\u0007\u001f\u0002\u000202\u0007\u00be\u0002\u00021+\u0003",
    "\u0002\u0002\u00021/\u0003\u0002\u0002\u000210\u0003\u0002\u0002\u0002",
    "23\u0003\u0002\u0002\u000234\u0005\u0004\u0003\u000245\b\u0002\u0001",
    "\u00025T\u0003\u0002\u0002\u000267\u0007\u00b9\u0002\u000278\u0007\u00c1",
    "\u0002\u000289\u0005\u0004\u0003\u00029:\b\u0002\u0001\u0002:T\u0003",
    "\u0002\u0002\u0002;<\u0007\u00ba\u0002\u0002<=\u0007\u00c1\u0002\u0002",
    "=>\u0005\u0004\u0003\u0002>?\b\u0002\u0001\u0002?T\u0003\u0002\u0002",
    "\u0002@B\u0007\u00bb\u0002\u0002AC\u0007\u00c1\u0002\u0002BA\u0003\u0002",
    "\u0002\u0002BC\u0003\u0002\u0002\u0002CD\u0003\u0002\u0002\u0002DE\u0005",
    "\u0004\u0003\u0002EF\b\u0002\u0001\u0002FT\u0003\u0002\u0002\u0002G",
    "I\u0007\u00bc\u0002\u0002HJ\u0007\u00c1\u0002\u0002IH\u0003\u0002\u0002",
    "\u0002IJ\u0003\u0002\u0002\u0002JK\u0003\u0002\u0002\u0002KL\u0005\u0004",
    "\u0003\u0002LM\b\u0002\u0001\u0002MT\u0003\u0002\u0002\u0002NO\u0007",
    "\u00bd\u0002\u0002OP\u0007\u00c1\u0002\u0002PQ\u0005\u0004\u0003\u0002",
    "QR\b\u0002\u0001\u0002RT\u0003\u0002\u0002\u0002S\u000e\u0003\u0002",
    "\u0002\u0002S\u0013\u0003\u0002\u0002\u0002S\u0018\u0003\u0002\u0002",
    "\u0002S\u001d\u0003\u0002\u0002\u0002S\"\u0003\u0002\u0002\u0002S&\u0003",
    "\u0002\u0002\u0002S*\u0003\u0002\u0002\u0002S6\u0003\u0002\u0002\u0002",
    "S;\u0003\u0002\u0002\u0002S@\u0003\u0002\u0002\u0002SG\u0003\u0002\u0002",
    "\u0002SN\u0003\u0002\u0002\u0002T\u0003\u0003\u0002\u0002\u0002UV\t",
    "\u0002\u0002\u0002V\u0005\u0003\u0002\u0002\u0002WX\b\u0004\u0001\u0002",
    "XY\u0007a\u0002\u0002Yh\b\u0004\u0001\u0002Z[\u0007+\u0002\u0002[h\b",
    "\u0004\u0001\u0002\\]\u0007\u00bf\u0002\u0002]h\b\u0004\u0001\u0002",
    "^_\u0007\u0080\u0002\u0002_`\u0005\u0006\u0004\u0002`a\u0007\u0081\u0002",
    "\u0002ab\b\u0004\u0001\u0002bh\u0003\u0002\u0002\u0002cd\u0007\u008e",
    "\u0002\u0002de\u0005\u0006\u0004\u0007ef\b\u0004\u0001\u0002fh\u0003",
    "\u0002\u0002\u0002gW\u0003\u0002\u0002\u0002gZ\u0003\u0002\u0002\u0002",
    "g\\\u0003\u0002\u0002\u0002g^\u0003\u0002\u0002\u0002gc\u0003\u0002",
    "\u0002\u0002h\u007f\u0003\u0002\u0002\u0002ij\f\u0006\u0002\u0002jk",
    "\u0007\u009b\u0002\u0002kl\u0005\u0006\u0004\u0007lm\b\u0004\u0001\u0002",
    "m~\u0003\u0002\u0002\u0002no\f\u0005\u0002\u0002op\u0007\u009c\u0002",
    "\u0002pq\u0005\u0006\u0004\u0006qr\b\u0004\u0001\u0002r~\u0003\u0002",
    "\u0002\u0002st\f\u0004\u0002\u0002tu\u0007\u0098\u0002\u0002uv\u0005",
    "\u0006\u0004\u0005vw\b\u0004\u0001\u0002w~\u0003\u0002\u0002\u0002x",
    "y\f\u0003\u0002\u0002yz\u0007\u0099\u0002\u0002z{\u0005\u0006\u0004",
    "\u0004{|\b\u0004\u0001\u0002|~\u0003\u0002\u0002\u0002}i\u0003\u0002",
    "\u0002\u0002}n\u0003\u0002\u0002\u0002}s\u0003\u0002\u0002\u0002}x\u0003",
    "\u0002\u0002\u0002~\u0081\u0003\u0002\u0002\u0002\u007f}\u0003\u0002",
    "\u0002\u0002\u007f\u0080\u0003\u0002\u0002\u0002\u0080\u0007\u0003\u0002",
    "\u0002\u0002\u0081\u007f\u0003\u0002\u0002\u0002\u0082\u0083\u0007\u00b4",
    "\u0002\u0002\u0083\u0084\u0007\u00bf\u0002\u0002\u0084\u0085\u0005\u0004",
    "\u0003\u0002\u0085\u0086\b\u0005\u0001\u0002\u0086\u0087\u0007\u0002",
    "\u0002\u0003\u0087\u00d4\u0003\u0002\u0002\u0002\u0088\u0089\u0007\u00b5",
    "\u0002\u0002\u0089\u008a\u0007\u00bf\u0002\u0002\u008a\u008b\u0005\u0004",
    "\u0003\u0002\u008b\u008c\b\u0005\u0001\u0002\u008c\u008d\u0007\u0002",
    "\u0002\u0003\u008d\u00d4\u0003\u0002\u0002\u0002\u008e\u008f\u00075",
    "\u0002\u0002\u008f\u0090\u0005\u0006\u0004\u0002\u0090\u0091\u0005\u0004",
    "\u0003\u0002\u0091\u0092\b\u0005\u0001\u0002\u0092\u0093\u0007\u0002",
    "\u0002\u0003\u0093\u00d4\u0003\u0002\u0002\u0002\u0094\u0095\u0007\u00b6",
    "\u0002\u0002\u0095\u0096\u0005\u0006\u0004\u0002\u0096\u0097\u0005\u0004",
    "\u0003\u0002\u0097\u0098\b\u0005\u0001\u0002\u0098\u0099\u0007\u0002",
    "\u0002\u0003\u0099\u00d4\u0003\u0002\u0002\u0002\u009a\u009b\u0007%",
    "\u0002\u0002\u009b\u009c\u0005\u0004\u0003\u0002\u009c\u009d\b\u0005",
    "\u0001\u0002\u009d\u009e\u0007\u0002\u0002\u0003\u009e\u00d4\u0003\u0002",
    "\u0002\u0002\u009f\u00a0\u0007\u00b7\u0002\u0002\u00a0\u00a1\u0005\u0004",
    "\u0003\u0002\u00a1\u00a2\b\u0005\u0001\u0002\u00a2\u00a3\u0007\u0002",
    "\u0002\u0003\u00a3\u00d4\u0003\u0002\u0002\u0002\u00a4\u00ab\u0007\u00b8",
    "\u0002\u0002\u00a5\u00a7\u0007\u00b3\u0002\u0002\u00a6\u00a8\u0007\\",
    "\u0002\u0002\u00a7\u00a6\u0003\u0002\u0002\u0002\u00a7\u00a8\u0003\u0002",
    "\u0002\u0002\u00a8\u00ac\u0003\u0002\u0002\u0002\u00a9\u00ac\u0007\u001f",
    "\u0002\u0002\u00aa\u00ac\u0007\u00be\u0002\u0002\u00ab\u00a5\u0003\u0002",
    "\u0002\u0002\u00ab\u00a9\u0003\u0002\u0002\u0002\u00ab\u00aa\u0003\u0002",
    "\u0002\u0002\u00ac\u00ad\u0003\u0002\u0002\u0002\u00ad\u00ae\u0005\u0004",
    "\u0003\u0002\u00ae\u00af\b\u0005\u0001\u0002\u00af\u00b0\u0007\u0002",
    "\u0002\u0003\u00b0\u00d4\u0003\u0002\u0002\u0002\u00b1\u00b2\u0007\u00b9",
    "\u0002\u0002\u00b2\u00b3\u0007\u00c1\u0002\u0002\u00b3\u00b4\u0005\u0004",
    "\u0003\u0002\u00b4\u00b5\b\u0005\u0001\u0002\u00b5\u00b6\u0007\u0002",
    "\u0002\u0003\u00b6\u00d4\u0003\u0002\u0002\u0002\u00b7\u00b8\u0007\u00ba",
    "\u0002\u0002\u00b8\u00b9\u0007\u00c1\u0002\u0002\u00b9\u00ba\u0005\u0004",
    "\u0003\u0002\u00ba\u00bb\b\u0005\u0001\u0002\u00bb\u00bc\u0007\u0002",
    "\u0002\u0003\u00bc\u00d4\u0003\u0002\u0002\u0002\u00bd\u00bf\u0007\u00bb",
    "\u0002\u0002\u00be\u00c0\u0007\u00c1\u0002\u0002\u00bf\u00be\u0003\u0002",
    "\u0002\u0002\u00bf\u00c0\u0003\u0002\u0002\u0002\u00c0\u00c1\u0003\u0002",
    "\u0002\u0002\u00c1\u00c2\u0005\u0004\u0003\u0002\u00c2\u00c3\b\u0005",
    "\u0001\u0002\u00c3\u00c4\u0007\u0002\u0002\u0003\u00c4\u00d4\u0003\u0002",
    "\u0002\u0002\u00c5\u00c7\u0007\u00bc\u0002\u0002\u00c6\u00c8\u0007\u00c1",
    "\u0002\u0002\u00c7\u00c6\u0003\u0002\u0002\u0002\u00c7\u00c8\u0003\u0002",
    "\u0002\u0002\u00c8\u00c9\u0003\u0002\u0002\u0002\u00c9\u00ca\u0005\u0004",
    "\u0003\u0002\u00ca\u00cb\b\u0005\u0001\u0002\u00cb\u00cc\u0007\u0002",
    "\u0002\u0003\u00cc\u00d4\u0003\u0002\u0002\u0002\u00cd\u00ce\u0007\u00bd",
    "\u0002\u0002\u00ce\u00cf\u0007\u00c1\u0002\u0002\u00cf\u00d0\u0005\u0004",
    "\u0003\u0002\u00d0\u00d1\b\u0005\u0001\u0002\u00d1\u00d2\u0007\u0002",
    "\u0002\u0003\u00d2\u00d4\u0003\u0002\u0002\u0002\u00d3\u0082\u0003\u0002",
    "\u0002\u0002\u00d3\u0088\u0003\u0002\u0002\u0002\u00d3\u008e\u0003\u0002",
    "\u0002\u0002\u00d3\u0094\u0003\u0002\u0002\u0002\u00d3\u009a\u0003\u0002",
    "\u0002\u0002\u00d3\u009f\u0003\u0002\u0002\u0002\u00d3\u00a4\u0003\u0002",
    "\u0002\u0002\u00d3\u00b1\u0003\u0002\u0002\u0002\u00d3\u00b7\u0003\u0002",
    "\u0002\u0002\u00d3\u00bd\u0003\u0002\u0002\u0002\u00d3\u00c5\u0003\u0002",
    "\u0002\u0002\u00d3\u00cd\u0003\u0002\u0002\u0002\u00d4\t\u0003\u0002",
    "\u0002\u0002\u00d5\u00d6\u0007\u00c0\u0002\u0002\u00d6\u00da\u0007\u0002",
    "\u0002\u0003\u00d7\u00d8\u0007\u0002\u0002\u0003\u00d8\u00da\u0007\u0002",
    "\u0002\u0003\u00d9\u00d5\u0003\u0002\u0002\u0002\u00d9\u00d7\u0003\u0002",
    "\u0002\u0002\u00da\u000b\u0003\u0002\u0002\u0002\u00db\u00dc\u0007a",
    "\u0002\u0002\u00dc\u00dd\b\u0007\u0001\u0002\u00dd\u0108\u0007\u0002",
    "\u0002\u0003\u00de\u00df\u0007+\u0002\u0002\u00df\u00e0\b\u0007\u0001",
    "\u0002\u00e0\u0108\u0007\u0002\u0002\u0003\u00e1\u00e2\u0007\u00bf\u0002",
    "\u0002\u00e2\u00e3\b\u0007\u0001\u0002\u00e3\u0108\u0007\u0002\u0002",
    "\u0003\u00e4\u00e5\u0007\u0080\u0002\u0002\u00e5\u00e6\u0005\u0006\u0004",
    "\u0002\u00e6\u00e7\u0007\u0081\u0002\u0002\u00e7\u00e8\b\u0007\u0001",
    "\u0002\u00e8\u00e9\u0007\u0002\u0002\u0003\u00e9\u0108\u0003\u0002\u0002",
    "\u0002\u00ea\u00eb\u0007\u008e\u0002\u0002\u00eb\u00ec\u0005\u0006\u0004",
    "\u0002\u00ec\u00ed\b\u0007\u0001\u0002\u00ed\u00ee\u0007\u0002\u0002",
    "\u0003\u00ee\u0108\u0003\u0002\u0002\u0002\u00ef\u00f0\u0005\u0006\u0004",
    "\u0002\u00f0\u00f1\u0007\u009b\u0002\u0002\u00f1\u00f2\u0005\u0006\u0004",
    "\u0002\u00f2\u00f3\b\u0007\u0001\u0002\u00f3\u00f4\u0007\u0002\u0002",
    "\u0003\u00f4\u0108\u0003\u0002\u0002\u0002\u00f5\u00f6\u0005\u0006\u0004",
    "\u0002\u00f6\u00f7\u0007\u009c\u0002\u0002\u00f7\u00f8\u0005\u0006\u0004",
    "\u0002\u00f8\u00f9\b\u0007\u0001\u0002\u00f9\u00fa\u0007\u0002\u0002",
    "\u0003\u00fa\u0108\u0003\u0002\u0002\u0002\u00fb\u00fc\u0005\u0006\u0004",
    "\u0002\u00fc\u00fd\u0007\u0098\u0002\u0002\u00fd\u00fe\u0005\u0006\u0004",
    "\u0002\u00fe\u00ff\b\u0007\u0001\u0002\u00ff\u0100\u0007\u0002\u0002",
    "\u0003\u0100\u0108\u0003\u0002\u0002\u0002\u0101\u0102\u0005\u0006\u0004",
    "\u0002\u0102\u0103\u0007\u0099\u0002\u0002\u0103\u0104\u0005\u0006\u0004",
    "\u0002\u0104\u0105\b\u0007\u0001\u0002\u0105\u0106\u0007\u0002\u0002",
    "\u0003\u0106\u0108\u0003\u0002\u0002\u0002\u0107\u00db\u0003\u0002\u0002",
    "\u0002\u0107\u00de\u0003\u0002\u0002\u0002\u0107\u00e1\u0003\u0002\u0002",
    "\u0002\u0107\u00e4\u0003\u0002\u0002\u0002\u0107\u00ea\u0003\u0002\u0002",
    "\u0002\u0107\u00ef\u0003\u0002\u0002\u0002\u0107\u00f5\u0003\u0002\u0002",
    "\u0002\u0107\u00fb\u0003\u0002\u0002\u0002\u0107\u0101\u0003\u0002\u0002",
    "\u0002\u0108\r\u0003\u0002\u0002\u0002\u0011-1BISg}\u007f\u00a7\u00ab",
    "\u00bf\u00c7\u00d3\u00d9\u0107"].join("");


var atn = new antlr4.atn.ATNDeserializer().deserialize(serializedATN);

var decisionsToDFA = atn.decisionToState.map( function(ds, index) { return new antlr4.dfa.DFA(ds, index); });

var sharedContextCache = new antlr4.PredictionContextCache();

var literalNames = [ null, "'\u00EF\u00BB\u00BF'", null, null, null, null, 
                     null, "'#'", "'abstract'", "'add'", "'alias'", "'__arglist'", 
                     "'as'", "'ascending'", "'async'", "'await'", "'base'", 
                     "'bool'", "'break'", "'by'", "'byte'", "'case'", "'catch'", 
                     "'char'", "'checked'", "'class'", "'const'", "'continue'", 
                     "'decimal'", "'default'", "'delegate'", "'descending'", 
                     "'do'", "'double'", "'dynamic'", "'else'", "'enum'", 
                     "'equals'", "'event'", "'explicit'", "'extern'", "'false'", 
                     "'finally'", "'fixed'", "'float'", "'for'", "'foreach'", 
                     "'from'", "'get'", "'goto'", "'group'", "'if'", "'implicit'", 
                     "'in'", "'int'", "'interface'", "'internal'", "'into'", 
                     "'is'", "'join'", "'let'", "'lock'", "'long'", "'nameof'", 
                     "'namespace'", "'new'", "'null'", "'object'", "'on'", 
                     "'operator'", "'orderby'", "'out'", "'override'", "'params'", 
                     "'partial'", "'private'", "'protected'", "'public'", 
                     "'readonly'", "'ref'", "'remove'", "'return'", "'sbyte'", 
                     "'sealed'", "'select'", "'set'", "'short'", "'sizeof'", 
                     "'stackalloc'", "'static'", "'string'", "'struct'", 
                     "'switch'", "'this'", "'throw'", "'true'", "'try'", 
                     "'typeof'", "'uint'", "'ulong'", "'unchecked'", "'unsafe'", 
                     "'ushort'", "'using'", "'var'", "'virtual'", "'void'", 
                     "'volatile'", "'when'", "'where'", "'while'", "'yield'", 
                     null, null, null, null, null, null, null, null, null, 
                     null, "'{'", "'}'", "'['", "']'", "'('", "')'", "'.'", 
                     "','", "':'", "';'", "'+'", "'-'", "'*'", "'/'", "'%'", 
                     "'&'", "'|'", "'^'", "'!'", "'~'", "'='", "'<'", "'>'", 
                     "'?'", "'::'", "'??'", "'++'", "'--'", "'&&'", "'||'", 
                     "'->'", "'=='", "'!='", "'<='", "'>='", "'+='", "'-='", 
                     "'*='", "'/='", "'%='", "'&='", "'|='", "'^='", "'<<'", 
                     "'<<='", "'{{'", null, null, null, null, null, null, 
                     null, null, null, null, "'define'", "'undef'", "'elif'", 
                     "'endif'", "'line'", null, null, null, null, null, 
                     "'hidden'", null, null, null, "'}}'" ];

var symbolicNames = [ null, "BYTE_ORDER_MARK", "SINGLE_LINE_DOC_COMMENT", 
                      "DELIMITED_DOC_COMMENT", "SINGLE_LINE_COMMENT", "DELIMITED_COMMENT", 
                      "WHITESPACES", "SHARP", "ABSTRACT", "ADD", "ALIAS", 
                      "ARGLIST", "AS", "ASCENDING", "ASYNC", "AWAIT", "BASE", 
                      "BOOL", "BREAK", "BY", "BYTE", "CASE", "CATCH", "CHAR", 
                      "CHECKED", "CLASS", "CONST", "CONTINUE", "DECIMAL", 
                      "DEFAULT", "DELEGATE", "DESCENDING", "DO", "DOUBLE", 
                      "DYNAMIC", "ELSE", "ENUM", "EQUALS", "EVENT", "EXPLICIT", 
                      "EXTERN", "FALSE", "FINALLY", "FIXED", "FLOAT", "FOR", 
                      "FOREACH", "FROM", "GET", "GOTO", "GROUP", "IF", "IMPLICIT", 
                      "IN", "INT", "INTERFACE", "INTERNAL", "INTO", "IS", 
                      "JOIN", "LET", "LOCK", "LONG", "NAMEOF", "NAMESPACE", 
                      "NEW", "NULL", "OBJECT", "ON", "OPERATOR", "ORDERBY", 
                      "OUT", "OVERRIDE", "PARAMS", "PARTIAL", "PRIVATE", 
                      "PROTECTED", "PUBLIC", "READONLY", "REF", "REMOVE", 
                      "RETURN", "SBYTE", "SEALED", "SELECT", "SET", "SHORT", 
                      "SIZEOF", "STACKALLOC", "STATIC", "STRING", "STRUCT", 
                      "SWITCH", "THIS", "THROW", "TRUE", "TRY", "TYPEOF", 
                      "UINT", "ULONG", "UNCHECKED", "UNSAFE", "USHORT", 
                      "USING", "VAR", "VIRTUAL", "VOID", "VOLATILE", "WHEN", 
                      "WHERE", "WHILE", "YIELD", "IDENTIFIER", "LITERAL_ACCESS", 
                      "INTEGER_LITERAL", "HEX_INTEGER_LITERAL", "REAL_LITERAL", 
                      "CHARACTER_LITERAL", "REGULAR_STRING", "VERBATIUM_STRING", 
                      "INTERPOLATED_REGULAR_STRING_START", "INTERPOLATED_VERBATIUM_STRING_START", 
                      "OPEN_BRACE", "CLOSE_BRACE", "OPEN_BRACKET", "CLOSE_BRACKET", 
                      "OPEN_PARENS", "CLOSE_PARENS", "DOT", "COMMA", "COLON", 
                      "SEMICOLON", "PLUS", "MINUS", "STAR", "DIV", "PERCENT", 
                      "AMP", "BITWISE_OR", "CARET", "BANG", "TILDE", "ASSIGNMENT", 
                      "LT", "GT", "INTERR", "DOUBLE_COLON", "OP_COALESCING", 
                      "OP_INC", "OP_DEC", "OP_AND", "OP_OR", "OP_PTR", "OP_EQ", 
                      "OP_NE", "OP_LE", "OP_GE", "OP_ADD_ASSIGNMENT", "OP_SUB_ASSIGNMENT", 
                      "OP_MULT_ASSIGNMENT", "OP_DIV_ASSIGNMENT", "OP_MOD_ASSIGNMENT", 
                      "OP_AND_ASSIGNMENT", "OP_OR_ASSIGNMENT", "OP_XOR_ASSIGNMENT", 
                      "OP_LEFT_SHIFT", "OP_LEFT_SHIFT_ASSIGNMENT", "DOUBLE_CURLY_INSIDE", 
                      "OPEN_BRACE_INSIDE", "REGULAR_CHAR_INSIDE", "VERBATIUM_DOUBLE_QUOTE_INSIDE", 
                      "DOUBLE_QUOTE_INSIDE", "REGULAR_STRING_INSIDE", "VERBATIUM_INSIDE_STRING", 
                      "CLOSE_BRACE_INSIDE", "FORMAT_STRING", "DIRECTIVE_WHITESPACES", 
                      "DIGITS", "DEFINE", "UNDEF", "ELIF", "ENDIF", "LINE", 
                      "ERROR", "WARNING", "REGION", "ENDREGION", "PRAGMA", 
                      "DIRECTIVE_HIDDEN", "CONDITIONAL_SYMBOL", "DIRECTIVE_NEW_LINE", 
                      "TEXT", "DOUBLE_CURLY_CLOSE_INSIDE" ];

var ruleNames =  [ "preprocessor_directive", "directive_new_line_or_sharp", 
                   "preprocessor_expression", "preprocessor_directive_DropletFile", 
                   "directive_new_line_or_sharp_DropletFile", "preprocessor_expression_DropletFile" ];

function CSharpPreprocessorParser (input) {
	antlr4.Parser.call(this, input);
    this._interp = new antlr4.atn.ParserATNSimulator(this, atn, decisionsToDFA, sharedContextCache);
    this.ruleNames = ruleNames;
    this.literalNames = literalNames;
    this.symbolicNames = symbolicNames;

	    function Stack() {

	        this.items = [];

	        this.push = function(element) {
	            this.items.push(element);
	        };

	        this.pop = function() {
	            this.items.pop();
	        };

	        this.peek = function() {
	            return this.items[length-1];
	        };

	        this.size = function() {
	            return this.items.length;
	        };
	    };

	    var conditions = new Stack();
	    var ConditionalSymbols = new Set();
	    ConditionalSymbols.add("DEBUG");

	    function allConditions() {
	        for(var i = 0; i < conditions.length; i++) {
	            if(!conditions[i]) {
	                return false;
	            }
	        }
	        return true;
	    }

    return this;
}

CSharpPreprocessorParser.prototype = Object.create(antlr4.Parser.prototype);
CSharpPreprocessorParser.prototype.constructor = CSharpPreprocessorParser;

Object.defineProperty(CSharpPreprocessorParser.prototype, "atn", {
	get : function() {
		return atn;
	}
});

CSharpPreprocessorParser.EOF = antlr4.Token.EOF;
CSharpPreprocessorParser.BYTE_ORDER_MARK = 1;
CSharpPreprocessorParser.SINGLE_LINE_DOC_COMMENT = 2;
CSharpPreprocessorParser.DELIMITED_DOC_COMMENT = 3;
CSharpPreprocessorParser.SINGLE_LINE_COMMENT = 4;
CSharpPreprocessorParser.DELIMITED_COMMENT = 5;
CSharpPreprocessorParser.WHITESPACES = 6;
CSharpPreprocessorParser.SHARP = 7;
CSharpPreprocessorParser.ABSTRACT = 8;
CSharpPreprocessorParser.ADD = 9;
CSharpPreprocessorParser.ALIAS = 10;
CSharpPreprocessorParser.ARGLIST = 11;
CSharpPreprocessorParser.AS = 12;
CSharpPreprocessorParser.ASCENDING = 13;
CSharpPreprocessorParser.ASYNC = 14;
CSharpPreprocessorParser.AWAIT = 15;
CSharpPreprocessorParser.BASE = 16;
CSharpPreprocessorParser.BOOL = 17;
CSharpPreprocessorParser.BREAK = 18;
CSharpPreprocessorParser.BY = 19;
CSharpPreprocessorParser.BYTE = 20;
CSharpPreprocessorParser.CASE = 21;
CSharpPreprocessorParser.CATCH = 22;
CSharpPreprocessorParser.CHAR = 23;
CSharpPreprocessorParser.CHECKED = 24;
CSharpPreprocessorParser.CLASS = 25;
CSharpPreprocessorParser.CONST = 26;
CSharpPreprocessorParser.CONTINUE = 27;
CSharpPreprocessorParser.DECIMAL = 28;
CSharpPreprocessorParser.DEFAULT = 29;
CSharpPreprocessorParser.DELEGATE = 30;
CSharpPreprocessorParser.DESCENDING = 31;
CSharpPreprocessorParser.DO = 32;
CSharpPreprocessorParser.DOUBLE = 33;
CSharpPreprocessorParser.DYNAMIC = 34;
CSharpPreprocessorParser.ELSE = 35;
CSharpPreprocessorParser.ENUM = 36;
CSharpPreprocessorParser.EQUALS = 37;
CSharpPreprocessorParser.EVENT = 38;
CSharpPreprocessorParser.EXPLICIT = 39;
CSharpPreprocessorParser.EXTERN = 40;
CSharpPreprocessorParser.FALSE = 41;
CSharpPreprocessorParser.FINALLY = 42;
CSharpPreprocessorParser.FIXED = 43;
CSharpPreprocessorParser.FLOAT = 44;
CSharpPreprocessorParser.FOR = 45;
CSharpPreprocessorParser.FOREACH = 46;
CSharpPreprocessorParser.FROM = 47;
CSharpPreprocessorParser.GET = 48;
CSharpPreprocessorParser.GOTO = 49;
CSharpPreprocessorParser.GROUP = 50;
CSharpPreprocessorParser.IF = 51;
CSharpPreprocessorParser.IMPLICIT = 52;
CSharpPreprocessorParser.IN = 53;
CSharpPreprocessorParser.INT = 54;
CSharpPreprocessorParser.INTERFACE = 55;
CSharpPreprocessorParser.INTERNAL = 56;
CSharpPreprocessorParser.INTO = 57;
CSharpPreprocessorParser.IS = 58;
CSharpPreprocessorParser.JOIN = 59;
CSharpPreprocessorParser.LET = 60;
CSharpPreprocessorParser.LOCK = 61;
CSharpPreprocessorParser.LONG = 62;
CSharpPreprocessorParser.NAMEOF = 63;
CSharpPreprocessorParser.NAMESPACE = 64;
CSharpPreprocessorParser.NEW = 65;
CSharpPreprocessorParser.NULL = 66;
CSharpPreprocessorParser.OBJECT = 67;
CSharpPreprocessorParser.ON = 68;
CSharpPreprocessorParser.OPERATOR = 69;
CSharpPreprocessorParser.ORDERBY = 70;
CSharpPreprocessorParser.OUT = 71;
CSharpPreprocessorParser.OVERRIDE = 72;
CSharpPreprocessorParser.PARAMS = 73;
CSharpPreprocessorParser.PARTIAL = 74;
CSharpPreprocessorParser.PRIVATE = 75;
CSharpPreprocessorParser.PROTECTED = 76;
CSharpPreprocessorParser.PUBLIC = 77;
CSharpPreprocessorParser.READONLY = 78;
CSharpPreprocessorParser.REF = 79;
CSharpPreprocessorParser.REMOVE = 80;
CSharpPreprocessorParser.RETURN = 81;
CSharpPreprocessorParser.SBYTE = 82;
CSharpPreprocessorParser.SEALED = 83;
CSharpPreprocessorParser.SELECT = 84;
CSharpPreprocessorParser.SET = 85;
CSharpPreprocessorParser.SHORT = 86;
CSharpPreprocessorParser.SIZEOF = 87;
CSharpPreprocessorParser.STACKALLOC = 88;
CSharpPreprocessorParser.STATIC = 89;
CSharpPreprocessorParser.STRING = 90;
CSharpPreprocessorParser.STRUCT = 91;
CSharpPreprocessorParser.SWITCH = 92;
CSharpPreprocessorParser.THIS = 93;
CSharpPreprocessorParser.THROW = 94;
CSharpPreprocessorParser.TRUE = 95;
CSharpPreprocessorParser.TRY = 96;
CSharpPreprocessorParser.TYPEOF = 97;
CSharpPreprocessorParser.UINT = 98;
CSharpPreprocessorParser.ULONG = 99;
CSharpPreprocessorParser.UNCHECKED = 100;
CSharpPreprocessorParser.UNSAFE = 101;
CSharpPreprocessorParser.USHORT = 102;
CSharpPreprocessorParser.USING = 103;
CSharpPreprocessorParser.VAR = 104;
CSharpPreprocessorParser.VIRTUAL = 105;
CSharpPreprocessorParser.VOID = 106;
CSharpPreprocessorParser.VOLATILE = 107;
CSharpPreprocessorParser.WHEN = 108;
CSharpPreprocessorParser.WHERE = 109;
CSharpPreprocessorParser.WHILE = 110;
CSharpPreprocessorParser.YIELD = 111;
CSharpPreprocessorParser.IDENTIFIER = 112;
CSharpPreprocessorParser.LITERAL_ACCESS = 113;
CSharpPreprocessorParser.INTEGER_LITERAL = 114;
CSharpPreprocessorParser.HEX_INTEGER_LITERAL = 115;
CSharpPreprocessorParser.REAL_LITERAL = 116;
CSharpPreprocessorParser.CHARACTER_LITERAL = 117;
CSharpPreprocessorParser.REGULAR_STRING = 118;
CSharpPreprocessorParser.VERBATIUM_STRING = 119;
CSharpPreprocessorParser.INTERPOLATED_REGULAR_STRING_START = 120;
CSharpPreprocessorParser.INTERPOLATED_VERBATIUM_STRING_START = 121;
CSharpPreprocessorParser.OPEN_BRACE = 122;
CSharpPreprocessorParser.CLOSE_BRACE = 123;
CSharpPreprocessorParser.OPEN_BRACKET = 124;
CSharpPreprocessorParser.CLOSE_BRACKET = 125;
CSharpPreprocessorParser.OPEN_PARENS = 126;
CSharpPreprocessorParser.CLOSE_PARENS = 127;
CSharpPreprocessorParser.DOT = 128;
CSharpPreprocessorParser.COMMA = 129;
CSharpPreprocessorParser.COLON = 130;
CSharpPreprocessorParser.SEMICOLON = 131;
CSharpPreprocessorParser.PLUS = 132;
CSharpPreprocessorParser.MINUS = 133;
CSharpPreprocessorParser.STAR = 134;
CSharpPreprocessorParser.DIV = 135;
CSharpPreprocessorParser.PERCENT = 136;
CSharpPreprocessorParser.AMP = 137;
CSharpPreprocessorParser.BITWISE_OR = 138;
CSharpPreprocessorParser.CARET = 139;
CSharpPreprocessorParser.BANG = 140;
CSharpPreprocessorParser.TILDE = 141;
CSharpPreprocessorParser.ASSIGNMENT = 142;
CSharpPreprocessorParser.LT = 143;
CSharpPreprocessorParser.GT = 144;
CSharpPreprocessorParser.INTERR = 145;
CSharpPreprocessorParser.DOUBLE_COLON = 146;
CSharpPreprocessorParser.OP_COALESCING = 147;
CSharpPreprocessorParser.OP_INC = 148;
CSharpPreprocessorParser.OP_DEC = 149;
CSharpPreprocessorParser.OP_AND = 150;
CSharpPreprocessorParser.OP_OR = 151;
CSharpPreprocessorParser.OP_PTR = 152;
CSharpPreprocessorParser.OP_EQ = 153;
CSharpPreprocessorParser.OP_NE = 154;
CSharpPreprocessorParser.OP_LE = 155;
CSharpPreprocessorParser.OP_GE = 156;
CSharpPreprocessorParser.OP_ADD_ASSIGNMENT = 157;
CSharpPreprocessorParser.OP_SUB_ASSIGNMENT = 158;
CSharpPreprocessorParser.OP_MULT_ASSIGNMENT = 159;
CSharpPreprocessorParser.OP_DIV_ASSIGNMENT = 160;
CSharpPreprocessorParser.OP_MOD_ASSIGNMENT = 161;
CSharpPreprocessorParser.OP_AND_ASSIGNMENT = 162;
CSharpPreprocessorParser.OP_OR_ASSIGNMENT = 163;
CSharpPreprocessorParser.OP_XOR_ASSIGNMENT = 164;
CSharpPreprocessorParser.OP_LEFT_SHIFT = 165;
CSharpPreprocessorParser.OP_LEFT_SHIFT_ASSIGNMENT = 166;
CSharpPreprocessorParser.DOUBLE_CURLY_INSIDE = 167;
CSharpPreprocessorParser.OPEN_BRACE_INSIDE = 168;
CSharpPreprocessorParser.REGULAR_CHAR_INSIDE = 169;
CSharpPreprocessorParser.VERBATIUM_DOUBLE_QUOTE_INSIDE = 170;
CSharpPreprocessorParser.DOUBLE_QUOTE_INSIDE = 171;
CSharpPreprocessorParser.REGULAR_STRING_INSIDE = 172;
CSharpPreprocessorParser.VERBATIUM_INSIDE_STRING = 173;
CSharpPreprocessorParser.CLOSE_BRACE_INSIDE = 174;
CSharpPreprocessorParser.FORMAT_STRING = 175;
CSharpPreprocessorParser.DIRECTIVE_WHITESPACES = 176;
CSharpPreprocessorParser.DIGITS = 177;
CSharpPreprocessorParser.DEFINE = 178;
CSharpPreprocessorParser.UNDEF = 179;
CSharpPreprocessorParser.ELIF = 180;
CSharpPreprocessorParser.ENDIF = 181;
CSharpPreprocessorParser.LINE = 182;
CSharpPreprocessorParser.ERROR = 183;
CSharpPreprocessorParser.WARNING = 184;
CSharpPreprocessorParser.REGION = 185;
CSharpPreprocessorParser.ENDREGION = 186;
CSharpPreprocessorParser.PRAGMA = 187;
CSharpPreprocessorParser.DIRECTIVE_HIDDEN = 188;
CSharpPreprocessorParser.CONDITIONAL_SYMBOL = 189;
CSharpPreprocessorParser.DIRECTIVE_NEW_LINE = 190;
CSharpPreprocessorParser.TEXT = 191;
CSharpPreprocessorParser.DOUBLE_CURLY_CLOSE_INSIDE = 192;

CSharpPreprocessorParser.RULE_preprocessor_directive = 0;
CSharpPreprocessorParser.RULE_directive_new_line_or_sharp = 1;
CSharpPreprocessorParser.RULE_preprocessor_expression = 2;
CSharpPreprocessorParser.RULE_preprocessor_directive_DropletFile = 3;
CSharpPreprocessorParser.RULE_directive_new_line_or_sharp_DropletFile = 4;
CSharpPreprocessorParser.RULE_preprocessor_expression_DropletFile = 5;

function Preprocessor_directiveContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = CSharpPreprocessorParser.RULE_preprocessor_directive;
    this.value = null
    return this;
}

Preprocessor_directiveContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
Preprocessor_directiveContext.prototype.constructor = Preprocessor_directiveContext;


 
Preprocessor_directiveContext.prototype.copyFrom = function(ctx) {
    antlr4.ParserRuleContext.prototype.copyFrom.call(this, ctx);
    this.value = ctx.value;
};


function PreprocessorDiagnosticContext(parser, ctx) {
	Preprocessor_directiveContext.call(this, parser);
    Preprocessor_directiveContext.prototype.copyFrom.call(this, ctx);
    return this;
}

PreprocessorDiagnosticContext.prototype = Object.create(Preprocessor_directiveContext.prototype);
PreprocessorDiagnosticContext.prototype.constructor = PreprocessorDiagnosticContext;

CSharpPreprocessorParser.PreprocessorDiagnosticContext = PreprocessorDiagnosticContext;

PreprocessorDiagnosticContext.prototype.ERROR = function() {
    return this.getToken(CSharpPreprocessorParser.ERROR, 0);
};

PreprocessorDiagnosticContext.prototype.TEXT = function() {
    return this.getToken(CSharpPreprocessorParser.TEXT, 0);
};

PreprocessorDiagnosticContext.prototype.directive_new_line_or_sharp = function() {
    return this.getTypedRuleContext(Directive_new_line_or_sharpContext,0);
};

PreprocessorDiagnosticContext.prototype.WARNING = function() {
    return this.getToken(CSharpPreprocessorParser.WARNING, 0);
};
PreprocessorDiagnosticContext.prototype.enterRule = function(listener) {
    if(listener instanceof CSharpPreprocessorParserListener ) {
        listener.enterPreprocessorDiagnostic(this);
	}
};

PreprocessorDiagnosticContext.prototype.exitRule = function(listener) {
    if(listener instanceof CSharpPreprocessorParserListener ) {
        listener.exitPreprocessorDiagnostic(this);
	}
};


function PreprocessorRegionContext(parser, ctx) {
	Preprocessor_directiveContext.call(this, parser);
    Preprocessor_directiveContext.prototype.copyFrom.call(this, ctx);
    return this;
}

PreprocessorRegionContext.prototype = Object.create(Preprocessor_directiveContext.prototype);
PreprocessorRegionContext.prototype.constructor = PreprocessorRegionContext;

CSharpPreprocessorParser.PreprocessorRegionContext = PreprocessorRegionContext;

PreprocessorRegionContext.prototype.REGION = function() {
    return this.getToken(CSharpPreprocessorParser.REGION, 0);
};

PreprocessorRegionContext.prototype.directive_new_line_or_sharp = function() {
    return this.getTypedRuleContext(Directive_new_line_or_sharpContext,0);
};

PreprocessorRegionContext.prototype.TEXT = function() {
    return this.getToken(CSharpPreprocessorParser.TEXT, 0);
};

PreprocessorRegionContext.prototype.ENDREGION = function() {
    return this.getToken(CSharpPreprocessorParser.ENDREGION, 0);
};
PreprocessorRegionContext.prototype.enterRule = function(listener) {
    if(listener instanceof CSharpPreprocessorParserListener ) {
        listener.enterPreprocessorRegion(this);
	}
};

PreprocessorRegionContext.prototype.exitRule = function(listener) {
    if(listener instanceof CSharpPreprocessorParserListener ) {
        listener.exitPreprocessorRegion(this);
	}
};


function PreprocessorDeclarationContext(parser, ctx) {
	Preprocessor_directiveContext.call(this, parser);
    this._CONDITIONAL_SYMBOL = null; // Token;
    Preprocessor_directiveContext.prototype.copyFrom.call(this, ctx);
    return this;
}

PreprocessorDeclarationContext.prototype = Object.create(Preprocessor_directiveContext.prototype);
PreprocessorDeclarationContext.prototype.constructor = PreprocessorDeclarationContext;

CSharpPreprocessorParser.PreprocessorDeclarationContext = PreprocessorDeclarationContext;

PreprocessorDeclarationContext.prototype.DEFINE = function() {
    return this.getToken(CSharpPreprocessorParser.DEFINE, 0);
};

PreprocessorDeclarationContext.prototype.CONDITIONAL_SYMBOL = function() {
    return this.getToken(CSharpPreprocessorParser.CONDITIONAL_SYMBOL, 0);
};

PreprocessorDeclarationContext.prototype.directive_new_line_or_sharp = function() {
    return this.getTypedRuleContext(Directive_new_line_or_sharpContext,0);
};

PreprocessorDeclarationContext.prototype.UNDEF = function() {
    return this.getToken(CSharpPreprocessorParser.UNDEF, 0);
};
PreprocessorDeclarationContext.prototype.enterRule = function(listener) {
    if(listener instanceof CSharpPreprocessorParserListener ) {
        listener.enterPreprocessorDeclaration(this);
	}
};

PreprocessorDeclarationContext.prototype.exitRule = function(listener) {
    if(listener instanceof CSharpPreprocessorParserListener ) {
        listener.exitPreprocessorDeclaration(this);
	}
};


function PreprocessorConditionalContext(parser, ctx) {
	Preprocessor_directiveContext.call(this, parser);
    this.expr = null; // Preprocessor_expressionContext;
    Preprocessor_directiveContext.prototype.copyFrom.call(this, ctx);
    return this;
}

PreprocessorConditionalContext.prototype = Object.create(Preprocessor_directiveContext.prototype);
PreprocessorConditionalContext.prototype.constructor = PreprocessorConditionalContext;

CSharpPreprocessorParser.PreprocessorConditionalContext = PreprocessorConditionalContext;

PreprocessorConditionalContext.prototype.IF = function() {
    return this.getToken(CSharpPreprocessorParser.IF, 0);
};

PreprocessorConditionalContext.prototype.directive_new_line_or_sharp = function() {
    return this.getTypedRuleContext(Directive_new_line_or_sharpContext,0);
};

PreprocessorConditionalContext.prototype.preprocessor_expression = function() {
    return this.getTypedRuleContext(Preprocessor_expressionContext,0);
};

PreprocessorConditionalContext.prototype.ELIF = function() {
    return this.getToken(CSharpPreprocessorParser.ELIF, 0);
};

PreprocessorConditionalContext.prototype.ELSE = function() {
    return this.getToken(CSharpPreprocessorParser.ELSE, 0);
};

PreprocessorConditionalContext.prototype.ENDIF = function() {
    return this.getToken(CSharpPreprocessorParser.ENDIF, 0);
};
PreprocessorConditionalContext.prototype.enterRule = function(listener) {
    if(listener instanceof CSharpPreprocessorParserListener ) {
        listener.enterPreprocessorConditional(this);
	}
};

PreprocessorConditionalContext.prototype.exitRule = function(listener) {
    if(listener instanceof CSharpPreprocessorParserListener ) {
        listener.exitPreprocessorConditional(this);
	}
};


function PreprocessorPragmaContext(parser, ctx) {
	Preprocessor_directiveContext.call(this, parser);
    Preprocessor_directiveContext.prototype.copyFrom.call(this, ctx);
    return this;
}

PreprocessorPragmaContext.prototype = Object.create(Preprocessor_directiveContext.prototype);
PreprocessorPragmaContext.prototype.constructor = PreprocessorPragmaContext;

CSharpPreprocessorParser.PreprocessorPragmaContext = PreprocessorPragmaContext;

PreprocessorPragmaContext.prototype.PRAGMA = function() {
    return this.getToken(CSharpPreprocessorParser.PRAGMA, 0);
};

PreprocessorPragmaContext.prototype.TEXT = function() {
    return this.getToken(CSharpPreprocessorParser.TEXT, 0);
};

PreprocessorPragmaContext.prototype.directive_new_line_or_sharp = function() {
    return this.getTypedRuleContext(Directive_new_line_or_sharpContext,0);
};
PreprocessorPragmaContext.prototype.enterRule = function(listener) {
    if(listener instanceof CSharpPreprocessorParserListener ) {
        listener.enterPreprocessorPragma(this);
	}
};

PreprocessorPragmaContext.prototype.exitRule = function(listener) {
    if(listener instanceof CSharpPreprocessorParserListener ) {
        listener.exitPreprocessorPragma(this);
	}
};


function PreprocessorLineContext(parser, ctx) {
	Preprocessor_directiveContext.call(this, parser);
    Preprocessor_directiveContext.prototype.copyFrom.call(this, ctx);
    return this;
}

PreprocessorLineContext.prototype = Object.create(Preprocessor_directiveContext.prototype);
PreprocessorLineContext.prototype.constructor = PreprocessorLineContext;

CSharpPreprocessorParser.PreprocessorLineContext = PreprocessorLineContext;

PreprocessorLineContext.prototype.LINE = function() {
    return this.getToken(CSharpPreprocessorParser.LINE, 0);
};

PreprocessorLineContext.prototype.directive_new_line_or_sharp = function() {
    return this.getTypedRuleContext(Directive_new_line_or_sharpContext,0);
};

PreprocessorLineContext.prototype.DIGITS = function() {
    return this.getToken(CSharpPreprocessorParser.DIGITS, 0);
};

PreprocessorLineContext.prototype.DEFAULT = function() {
    return this.getToken(CSharpPreprocessorParser.DEFAULT, 0);
};

PreprocessorLineContext.prototype.DIRECTIVE_HIDDEN = function() {
    return this.getToken(CSharpPreprocessorParser.DIRECTIVE_HIDDEN, 0);
};

PreprocessorLineContext.prototype.STRING = function() {
    return this.getToken(CSharpPreprocessorParser.STRING, 0);
};
PreprocessorLineContext.prototype.enterRule = function(listener) {
    if(listener instanceof CSharpPreprocessorParserListener ) {
        listener.enterPreprocessorLine(this);
	}
};

PreprocessorLineContext.prototype.exitRule = function(listener) {
    if(listener instanceof CSharpPreprocessorParserListener ) {
        listener.exitPreprocessorLine(this);
	}
};



CSharpPreprocessorParser.Preprocessor_directiveContext = Preprocessor_directiveContext;

CSharpPreprocessorParser.prototype.preprocessor_directive = function() {

    var localctx = new Preprocessor_directiveContext(this, this._ctx, this.state);
    this.enterRule(localctx, 0, CSharpPreprocessorParser.RULE_preprocessor_directive);
    var _la = 0; // Token type
    try {
        this.state = 81;
        this._errHandler.sync(this);
        switch(this._input.LA(1)) {
        case CSharpPreprocessorParser.DEFINE:
            localctx = new PreprocessorDeclarationContext(this, localctx);
            this.enterOuterAlt(localctx, 1);
            this.state = 12;
            this.match(CSharpPreprocessorParser.DEFINE);
            this.state = 13;
            localctx._CONDITIONAL_SYMBOL = this.match(CSharpPreprocessorParser.CONDITIONAL_SYMBOL);
            this.state = 14;
            this.directive_new_line_or_sharp();
             ConditionalSymbols.add((localctx._CONDITIONAL_SYMBOL===null ? null : localctx._CONDITIONAL_SYMBOL.text));
            	   localctx.value =  allConditions() 
            break;
        case CSharpPreprocessorParser.UNDEF:
            localctx = new PreprocessorDeclarationContext(this, localctx);
            this.enterOuterAlt(localctx, 2);
            this.state = 17;
            this.match(CSharpPreprocessorParser.UNDEF);
            this.state = 18;
            localctx._CONDITIONAL_SYMBOL = this.match(CSharpPreprocessorParser.CONDITIONAL_SYMBOL);
            this.state = 19;
            this.directive_new_line_or_sharp();
             ConditionalSymbols.remove((localctx._CONDITIONAL_SYMBOL===null ? null : localctx._CONDITIONAL_SYMBOL.text));
            	   localctx.value =  allConditions() 
            break;
        case CSharpPreprocessorParser.IF:
            localctx = new PreprocessorConditionalContext(this, localctx);
            this.enterOuterAlt(localctx, 3);
            this.state = 22;
            this.match(CSharpPreprocessorParser.IF);
            this.state = 23;
            localctx.expr = this.preprocessor_expression(0);
            this.state = 24;
            this.directive_new_line_or_sharp();
             localctx.value =  localctx.expr.value.equals("true") && allConditions() conditions.push(localctx.expr.value.equals("true")); 
            break;
        case CSharpPreprocessorParser.ELIF:
            localctx = new PreprocessorConditionalContext(this, localctx);
            this.enterOuterAlt(localctx, 4);
            this.state = 27;
            this.match(CSharpPreprocessorParser.ELIF);
            this.state = 28;
            localctx.expr = this.preprocessor_expression(0);
            this.state = 29;
            this.directive_new_line_or_sharp();
             if (!conditions.peek()) { conditions.pop(); localctx.value =  localctx.expr.value.equals("true") && allConditions()
            	     conditions.push(localctx.expr.value.equals("true")); } else localctx.value =  false 
            break;
        case CSharpPreprocessorParser.ELSE:
            localctx = new PreprocessorConditionalContext(this, localctx);
            this.enterOuterAlt(localctx, 5);
            this.state = 32;
            this.match(CSharpPreprocessorParser.ELSE);
            this.state = 33;
            this.directive_new_line_or_sharp();
             if (!conditions.peek()) { conditions.pop(); localctx.value =  true && allConditions() conditions.push(true); }
            	    else localctx.value =  false 
            break;
        case CSharpPreprocessorParser.ENDIF:
            localctx = new PreprocessorConditionalContext(this, localctx);
            this.enterOuterAlt(localctx, 6);
            this.state = 36;
            this.match(CSharpPreprocessorParser.ENDIF);
            this.state = 37;
            this.directive_new_line_or_sharp();
             conditions.pop(); localctx.value =  conditions.peek() 
            break;
        case CSharpPreprocessorParser.LINE:
            localctx = new PreprocessorLineContext(this, localctx);
            this.enterOuterAlt(localctx, 7);
            this.state = 40;
            this.match(CSharpPreprocessorParser.LINE);
            this.state = 47;
            this._errHandler.sync(this);
            switch(this._input.LA(1)) {
            case CSharpPreprocessorParser.DIGITS:
                this.state = 41;
                this.match(CSharpPreprocessorParser.DIGITS);
                this.state = 43;
                this._errHandler.sync(this);
                _la = this._input.LA(1);
                if(_la===CSharpPreprocessorParser.STRING) {
                    this.state = 42;
                    this.match(CSharpPreprocessorParser.STRING);
                }

                break;
            case CSharpPreprocessorParser.DEFAULT:
                this.state = 45;
                this.match(CSharpPreprocessorParser.DEFAULT);
                break;
            case CSharpPreprocessorParser.DIRECTIVE_HIDDEN:
                this.state = 46;
                this.match(CSharpPreprocessorParser.DIRECTIVE_HIDDEN);
                break;
            default:
                throw new antlr4.error.NoViableAltException(this);
            }
            this.state = 49;
            this.directive_new_line_or_sharp();
             localctx.value =  allConditions() 
            break;
        case CSharpPreprocessorParser.ERROR:
            localctx = new PreprocessorDiagnosticContext(this, localctx);
            this.enterOuterAlt(localctx, 8);
            this.state = 52;
            this.match(CSharpPreprocessorParser.ERROR);
            this.state = 53;
            this.match(CSharpPreprocessorParser.TEXT);
            this.state = 54;
            this.directive_new_line_or_sharp();
             localctx.value =  allConditions() 
            break;
        case CSharpPreprocessorParser.WARNING:
            localctx = new PreprocessorDiagnosticContext(this, localctx);
            this.enterOuterAlt(localctx, 9);
            this.state = 57;
            this.match(CSharpPreprocessorParser.WARNING);
            this.state = 58;
            this.match(CSharpPreprocessorParser.TEXT);
            this.state = 59;
            this.directive_new_line_or_sharp();
             localctx.value =  allConditions() 
            break;
        case CSharpPreprocessorParser.REGION:
            localctx = new PreprocessorRegionContext(this, localctx);
            this.enterOuterAlt(localctx, 10);
            this.state = 62;
            this.match(CSharpPreprocessorParser.REGION);
            this.state = 64;
            this._errHandler.sync(this);
            _la = this._input.LA(1);
            if(_la===CSharpPreprocessorParser.TEXT) {
                this.state = 63;
                this.match(CSharpPreprocessorParser.TEXT);
            }

            this.state = 66;
            this.directive_new_line_or_sharp();
             localctx.value =  allConditions() 
            break;
        case CSharpPreprocessorParser.ENDREGION:
            localctx = new PreprocessorRegionContext(this, localctx);
            this.enterOuterAlt(localctx, 11);
            this.state = 69;
            this.match(CSharpPreprocessorParser.ENDREGION);
            this.state = 71;
            this._errHandler.sync(this);
            _la = this._input.LA(1);
            if(_la===CSharpPreprocessorParser.TEXT) {
                this.state = 70;
                this.match(CSharpPreprocessorParser.TEXT);
            }

            this.state = 73;
            this.directive_new_line_or_sharp();
             localctx.value =  allConditions() 
            break;
        case CSharpPreprocessorParser.PRAGMA:
            localctx = new PreprocessorPragmaContext(this, localctx);
            this.enterOuterAlt(localctx, 12);
            this.state = 76;
            this.match(CSharpPreprocessorParser.PRAGMA);
            this.state = 77;
            this.match(CSharpPreprocessorParser.TEXT);
            this.state = 78;
            this.directive_new_line_or_sharp();
             localctx.value =  allConditions() 
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

function Directive_new_line_or_sharpContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = CSharpPreprocessorParser.RULE_directive_new_line_or_sharp;
    return this;
}

Directive_new_line_or_sharpContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
Directive_new_line_or_sharpContext.prototype.constructor = Directive_new_line_or_sharpContext;

Directive_new_line_or_sharpContext.prototype.DIRECTIVE_NEW_LINE = function() {
    return this.getToken(CSharpPreprocessorParser.DIRECTIVE_NEW_LINE, 0);
};

Directive_new_line_or_sharpContext.prototype.EOF = function() {
    return this.getToken(CSharpPreprocessorParser.EOF, 0);
};

Directive_new_line_or_sharpContext.prototype.enterRule = function(listener) {
    if(listener instanceof CSharpPreprocessorParserListener ) {
        listener.enterDirective_new_line_or_sharp(this);
	}
};

Directive_new_line_or_sharpContext.prototype.exitRule = function(listener) {
    if(listener instanceof CSharpPreprocessorParserListener ) {
        listener.exitDirective_new_line_or_sharp(this);
	}
};




CSharpPreprocessorParser.Directive_new_line_or_sharpContext = Directive_new_line_or_sharpContext;

CSharpPreprocessorParser.prototype.directive_new_line_or_sharp = function() {

    var localctx = new Directive_new_line_or_sharpContext(this, this._ctx, this.state);
    this.enterRule(localctx, 2, CSharpPreprocessorParser.RULE_directive_new_line_or_sharp);
    var _la = 0; // Token type
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 83;
        _la = this._input.LA(1);
        if(!(_la===CSharpPreprocessorParser.EOF || _la===CSharpPreprocessorParser.DIRECTIVE_NEW_LINE)) {
        this._errHandler.recoverInline(this);
        }
        else {
        	this._errHandler.reportMatch(this);
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

function Preprocessor_expressionContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = CSharpPreprocessorParser.RULE_preprocessor_expression;
    this.value = null
    this.expr1 = null; // Preprocessor_expressionContext
    this._CONDITIONAL_SYMBOL = null; // Token
    this.expr = null; // Preprocessor_expressionContext
    this.expr2 = null; // Preprocessor_expressionContext
    return this;
}

Preprocessor_expressionContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
Preprocessor_expressionContext.prototype.constructor = Preprocessor_expressionContext;

Preprocessor_expressionContext.prototype.TRUE = function() {
    return this.getToken(CSharpPreprocessorParser.TRUE, 0);
};

Preprocessor_expressionContext.prototype.FALSE = function() {
    return this.getToken(CSharpPreprocessorParser.FALSE, 0);
};

Preprocessor_expressionContext.prototype.CONDITIONAL_SYMBOL = function() {
    return this.getToken(CSharpPreprocessorParser.CONDITIONAL_SYMBOL, 0);
};

Preprocessor_expressionContext.prototype.OPEN_PARENS = function() {
    return this.getToken(CSharpPreprocessorParser.OPEN_PARENS, 0);
};

Preprocessor_expressionContext.prototype.CLOSE_PARENS = function() {
    return this.getToken(CSharpPreprocessorParser.CLOSE_PARENS, 0);
};

Preprocessor_expressionContext.prototype.preprocessor_expression = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(Preprocessor_expressionContext);
    } else {
        return this.getTypedRuleContext(Preprocessor_expressionContext,i);
    }
};

Preprocessor_expressionContext.prototype.BANG = function() {
    return this.getToken(CSharpPreprocessorParser.BANG, 0);
};

Preprocessor_expressionContext.prototype.OP_EQ = function() {
    return this.getToken(CSharpPreprocessorParser.OP_EQ, 0);
};

Preprocessor_expressionContext.prototype.OP_NE = function() {
    return this.getToken(CSharpPreprocessorParser.OP_NE, 0);
};

Preprocessor_expressionContext.prototype.OP_AND = function() {
    return this.getToken(CSharpPreprocessorParser.OP_AND, 0);
};

Preprocessor_expressionContext.prototype.OP_OR = function() {
    return this.getToken(CSharpPreprocessorParser.OP_OR, 0);
};

Preprocessor_expressionContext.prototype.enterRule = function(listener) {
    if(listener instanceof CSharpPreprocessorParserListener ) {
        listener.enterPreprocessor_expression(this);
	}
};

Preprocessor_expressionContext.prototype.exitRule = function(listener) {
    if(listener instanceof CSharpPreprocessorParserListener ) {
        listener.exitPreprocessor_expression(this);
	}
};



CSharpPreprocessorParser.prototype.preprocessor_expression = function(_p) {
	if(_p===undefined) {
	    _p = 0;
	}
    var _parentctx = this._ctx;
    var _parentState = this.state;
    var localctx = new Preprocessor_expressionContext(this, this._ctx, _parentState);
    var _prevctx = localctx;
    var _startState = 4;
    this.enterRecursionRule(localctx, 4, CSharpPreprocessorParser.RULE_preprocessor_expression, _p);
    try {
        this.enterOuterAlt(localctx, 1);
        this.state = 101;
        this._errHandler.sync(this);
        switch(this._input.LA(1)) {
        case CSharpPreprocessorParser.TRUE:
            this.state = 86;
            this.match(CSharpPreprocessorParser.TRUE);
             localctx.value =  "true" 
            break;
        case CSharpPreprocessorParser.FALSE:
            this.state = 88;
            this.match(CSharpPreprocessorParser.FALSE);
             localctx.value =  "false" 
            break;
        case CSharpPreprocessorParser.CONDITIONAL_SYMBOL:
            this.state = 90;
            localctx._CONDITIONAL_SYMBOL = this.match(CSharpPreprocessorParser.CONDITIONAL_SYMBOL);
             localctx.value =  ConditionalSymbols.has((localctx._CONDITIONAL_SYMBOL===null ? null : localctx._CONDITIONAL_SYMBOL.text)) ? "true" : "false" 
            break;
        case CSharpPreprocessorParser.OPEN_PARENS:
            this.state = 92;
            this.match(CSharpPreprocessorParser.OPEN_PARENS);
            this.state = 93;
            localctx.expr = this.preprocessor_expression(0);
            this.state = 94;
            this.match(CSharpPreprocessorParser.CLOSE_PARENS);
             localctx.value =  localctx.expr.value 
            break;
        case CSharpPreprocessorParser.BANG:
            this.state = 97;
            this.match(CSharpPreprocessorParser.BANG);
            this.state = 98;
            localctx.expr = this.preprocessor_expression(5);
             localctx.value =  localctx.expr.value.equals("true") ? "false" : "true" 
            break;
        default:
            throw new antlr4.error.NoViableAltException(this);
        }
        this._ctx.stop = this._input.LT(-1);
        this.state = 125;
        this._errHandler.sync(this);
        var _alt = this._interp.adaptivePredict(this._input,7,this._ctx)
        while(_alt!=2 && _alt!=antlr4.atn.ATN.INVALID_ALT_NUMBER) {
            if(_alt===1) {
                if(this._parseListeners!==null) {
                    this.triggerExitRuleEvent();
                }
                _prevctx = localctx;
                this.state = 123;
                this._errHandler.sync(this);
                var la_ = this._interp.adaptivePredict(this._input,6,this._ctx);
                switch(la_) {
                case 1:
                    localctx = new Preprocessor_expressionContext(this, _parentctx, _parentState);
                    localctx.expr1 = _prevctx;
                    this.pushNewRecursionContext(localctx, _startState, CSharpPreprocessorParser.RULE_preprocessor_expression);
                    this.state = 103;
                    if (!( this.precpred(this._ctx, 4))) {
                        throw new antlr4.error.FailedPredicateException(this, "this.precpred(this._ctx, 4)");
                    }
                    this.state = 104;
                    this.match(CSharpPreprocessorParser.OP_EQ);
                    this.state = 105;
                    localctx.expr2 = this.preprocessor_expression(5);
                     localctx.value =  (localctx.expr1.value == localctx.expr2.value ? "true" : "false") 
                    break;

                case 2:
                    localctx = new Preprocessor_expressionContext(this, _parentctx, _parentState);
                    localctx.expr1 = _prevctx;
                    this.pushNewRecursionContext(localctx, _startState, CSharpPreprocessorParser.RULE_preprocessor_expression);
                    this.state = 108;
                    if (!( this.precpred(this._ctx, 3))) {
                        throw new antlr4.error.FailedPredicateException(this, "this.precpred(this._ctx, 3)");
                    }
                    this.state = 109;
                    this.match(CSharpPreprocessorParser.OP_NE);
                    this.state = 110;
                    localctx.expr2 = this.preprocessor_expression(4);
                     localctx.value =  (localctx.expr1.value != localctx.expr2.value ? "true" : "false") 
                    break;

                case 3:
                    localctx = new Preprocessor_expressionContext(this, _parentctx, _parentState);
                    localctx.expr1 = _prevctx;
                    this.pushNewRecursionContext(localctx, _startState, CSharpPreprocessorParser.RULE_preprocessor_expression);
                    this.state = 113;
                    if (!( this.precpred(this._ctx, 2))) {
                        throw new antlr4.error.FailedPredicateException(this, "this.precpred(this._ctx, 2)");
                    }
                    this.state = 114;
                    this.match(CSharpPreprocessorParser.OP_AND);
                    this.state = 115;
                    localctx.expr2 = this.preprocessor_expression(3);
                     localctx.value =  (localctx.expr1.value.equals("true") && localctx.expr2.value.equals("true") ? "true" : "false") 
                    break;

                case 4:
                    localctx = new Preprocessor_expressionContext(this, _parentctx, _parentState);
                    localctx.expr1 = _prevctx;
                    this.pushNewRecursionContext(localctx, _startState, CSharpPreprocessorParser.RULE_preprocessor_expression);
                    this.state = 118;
                    if (!( this.precpred(this._ctx, 1))) {
                        throw new antlr4.error.FailedPredicateException(this, "this.precpred(this._ctx, 1)");
                    }
                    this.state = 119;
                    this.match(CSharpPreprocessorParser.OP_OR);
                    this.state = 120;
                    localctx.expr2 = this.preprocessor_expression(2);
                     localctx.value =  (localctx.expr1.value.equals("true") || localctx.expr2.value.equals("true") ? "true" : "false") 
                    break;

                } 
            }
            this.state = 127;
            this._errHandler.sync(this);
            _alt = this._interp.adaptivePredict(this._input,7,this._ctx);
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

function Preprocessor_directive_DropletFileContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = CSharpPreprocessorParser.RULE_preprocessor_directive_DropletFile;
    this.value = null
    return this;
}

Preprocessor_directive_DropletFileContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
Preprocessor_directive_DropletFileContext.prototype.constructor = Preprocessor_directive_DropletFileContext;


 
Preprocessor_directive_DropletFileContext.prototype.copyFrom = function(ctx) {
    antlr4.ParserRuleContext.prototype.copyFrom.call(this, ctx);
    this.value = ctx.value;
};


function PreprocessorDeclaration_DropletFileContext(parser, ctx) {
	Preprocessor_directive_DropletFileContext.call(this, parser);
    this._CONDITIONAL_SYMBOL = null; // Token;
    Preprocessor_directive_DropletFileContext.prototype.copyFrom.call(this, ctx);
    return this;
}

PreprocessorDeclaration_DropletFileContext.prototype = Object.create(Preprocessor_directive_DropletFileContext.prototype);
PreprocessorDeclaration_DropletFileContext.prototype.constructor = PreprocessorDeclaration_DropletFileContext;

CSharpPreprocessorParser.PreprocessorDeclaration_DropletFileContext = PreprocessorDeclaration_DropletFileContext;

PreprocessorDeclaration_DropletFileContext.prototype.DEFINE = function() {
    return this.getToken(CSharpPreprocessorParser.DEFINE, 0);
};

PreprocessorDeclaration_DropletFileContext.prototype.CONDITIONAL_SYMBOL = function() {
    return this.getToken(CSharpPreprocessorParser.CONDITIONAL_SYMBOL, 0);
};

PreprocessorDeclaration_DropletFileContext.prototype.directive_new_line_or_sharp = function() {
    return this.getTypedRuleContext(Directive_new_line_or_sharpContext,0);
};

PreprocessorDeclaration_DropletFileContext.prototype.EOF = function() {
    return this.getToken(CSharpPreprocessorParser.EOF, 0);
};

PreprocessorDeclaration_DropletFileContext.prototype.UNDEF = function() {
    return this.getToken(CSharpPreprocessorParser.UNDEF, 0);
};
PreprocessorDeclaration_DropletFileContext.prototype.enterRule = function(listener) {
    if(listener instanceof CSharpPreprocessorParserListener ) {
        listener.enterPreprocessorDeclaration_DropletFile(this);
	}
};

PreprocessorDeclaration_DropletFileContext.prototype.exitRule = function(listener) {
    if(listener instanceof CSharpPreprocessorParserListener ) {
        listener.exitPreprocessorDeclaration_DropletFile(this);
	}
};


function PreprocessorPragma_DropletFileContext(parser, ctx) {
	Preprocessor_directive_DropletFileContext.call(this, parser);
    Preprocessor_directive_DropletFileContext.prototype.copyFrom.call(this, ctx);
    return this;
}

PreprocessorPragma_DropletFileContext.prototype = Object.create(Preprocessor_directive_DropletFileContext.prototype);
PreprocessorPragma_DropletFileContext.prototype.constructor = PreprocessorPragma_DropletFileContext;

CSharpPreprocessorParser.PreprocessorPragma_DropletFileContext = PreprocessorPragma_DropletFileContext;

PreprocessorPragma_DropletFileContext.prototype.PRAGMA = function() {
    return this.getToken(CSharpPreprocessorParser.PRAGMA, 0);
};

PreprocessorPragma_DropletFileContext.prototype.TEXT = function() {
    return this.getToken(CSharpPreprocessorParser.TEXT, 0);
};

PreprocessorPragma_DropletFileContext.prototype.directive_new_line_or_sharp = function() {
    return this.getTypedRuleContext(Directive_new_line_or_sharpContext,0);
};

PreprocessorPragma_DropletFileContext.prototype.EOF = function() {
    return this.getToken(CSharpPreprocessorParser.EOF, 0);
};
PreprocessorPragma_DropletFileContext.prototype.enterRule = function(listener) {
    if(listener instanceof CSharpPreprocessorParserListener ) {
        listener.enterPreprocessorPragma_DropletFile(this);
	}
};

PreprocessorPragma_DropletFileContext.prototype.exitRule = function(listener) {
    if(listener instanceof CSharpPreprocessorParserListener ) {
        listener.exitPreprocessorPragma_DropletFile(this);
	}
};


function PreprocessorRegion_DropletFileContext(parser, ctx) {
	Preprocessor_directive_DropletFileContext.call(this, parser);
    Preprocessor_directive_DropletFileContext.prototype.copyFrom.call(this, ctx);
    return this;
}

PreprocessorRegion_DropletFileContext.prototype = Object.create(Preprocessor_directive_DropletFileContext.prototype);
PreprocessorRegion_DropletFileContext.prototype.constructor = PreprocessorRegion_DropletFileContext;

CSharpPreprocessorParser.PreprocessorRegion_DropletFileContext = PreprocessorRegion_DropletFileContext;

PreprocessorRegion_DropletFileContext.prototype.REGION = function() {
    return this.getToken(CSharpPreprocessorParser.REGION, 0);
};

PreprocessorRegion_DropletFileContext.prototype.directive_new_line_or_sharp = function() {
    return this.getTypedRuleContext(Directive_new_line_or_sharpContext,0);
};

PreprocessorRegion_DropletFileContext.prototype.EOF = function() {
    return this.getToken(CSharpPreprocessorParser.EOF, 0);
};

PreprocessorRegion_DropletFileContext.prototype.TEXT = function() {
    return this.getToken(CSharpPreprocessorParser.TEXT, 0);
};

PreprocessorRegion_DropletFileContext.prototype.ENDREGION = function() {
    return this.getToken(CSharpPreprocessorParser.ENDREGION, 0);
};
PreprocessorRegion_DropletFileContext.prototype.enterRule = function(listener) {
    if(listener instanceof CSharpPreprocessorParserListener ) {
        listener.enterPreprocessorRegion_DropletFile(this);
	}
};

PreprocessorRegion_DropletFileContext.prototype.exitRule = function(listener) {
    if(listener instanceof CSharpPreprocessorParserListener ) {
        listener.exitPreprocessorRegion_DropletFile(this);
	}
};


function PreprocessorLine_DropletFileContext(parser, ctx) {
	Preprocessor_directive_DropletFileContext.call(this, parser);
    Preprocessor_directive_DropletFileContext.prototype.copyFrom.call(this, ctx);
    return this;
}

PreprocessorLine_DropletFileContext.prototype = Object.create(Preprocessor_directive_DropletFileContext.prototype);
PreprocessorLine_DropletFileContext.prototype.constructor = PreprocessorLine_DropletFileContext;

CSharpPreprocessorParser.PreprocessorLine_DropletFileContext = PreprocessorLine_DropletFileContext;

PreprocessorLine_DropletFileContext.prototype.LINE = function() {
    return this.getToken(CSharpPreprocessorParser.LINE, 0);
};

PreprocessorLine_DropletFileContext.prototype.directive_new_line_or_sharp = function() {
    return this.getTypedRuleContext(Directive_new_line_or_sharpContext,0);
};

PreprocessorLine_DropletFileContext.prototype.EOF = function() {
    return this.getToken(CSharpPreprocessorParser.EOF, 0);
};

PreprocessorLine_DropletFileContext.prototype.DIGITS = function() {
    return this.getToken(CSharpPreprocessorParser.DIGITS, 0);
};

PreprocessorLine_DropletFileContext.prototype.DEFAULT = function() {
    return this.getToken(CSharpPreprocessorParser.DEFAULT, 0);
};

PreprocessorLine_DropletFileContext.prototype.DIRECTIVE_HIDDEN = function() {
    return this.getToken(CSharpPreprocessorParser.DIRECTIVE_HIDDEN, 0);
};

PreprocessorLine_DropletFileContext.prototype.STRING = function() {
    return this.getToken(CSharpPreprocessorParser.STRING, 0);
};
PreprocessorLine_DropletFileContext.prototype.enterRule = function(listener) {
    if(listener instanceof CSharpPreprocessorParserListener ) {
        listener.enterPreprocessorLine_DropletFile(this);
	}
};

PreprocessorLine_DropletFileContext.prototype.exitRule = function(listener) {
    if(listener instanceof CSharpPreprocessorParserListener ) {
        listener.exitPreprocessorLine_DropletFile(this);
	}
};


function PreprocessorDiagnostic_DropletFileContext(parser, ctx) {
	Preprocessor_directive_DropletFileContext.call(this, parser);
    Preprocessor_directive_DropletFileContext.prototype.copyFrom.call(this, ctx);
    return this;
}

PreprocessorDiagnostic_DropletFileContext.prototype = Object.create(Preprocessor_directive_DropletFileContext.prototype);
PreprocessorDiagnostic_DropletFileContext.prototype.constructor = PreprocessorDiagnostic_DropletFileContext;

CSharpPreprocessorParser.PreprocessorDiagnostic_DropletFileContext = PreprocessorDiagnostic_DropletFileContext;

PreprocessorDiagnostic_DropletFileContext.prototype.ERROR = function() {
    return this.getToken(CSharpPreprocessorParser.ERROR, 0);
};

PreprocessorDiagnostic_DropletFileContext.prototype.TEXT = function() {
    return this.getToken(CSharpPreprocessorParser.TEXT, 0);
};

PreprocessorDiagnostic_DropletFileContext.prototype.directive_new_line_or_sharp = function() {
    return this.getTypedRuleContext(Directive_new_line_or_sharpContext,0);
};

PreprocessorDiagnostic_DropletFileContext.prototype.EOF = function() {
    return this.getToken(CSharpPreprocessorParser.EOF, 0);
};

PreprocessorDiagnostic_DropletFileContext.prototype.WARNING = function() {
    return this.getToken(CSharpPreprocessorParser.WARNING, 0);
};
PreprocessorDiagnostic_DropletFileContext.prototype.enterRule = function(listener) {
    if(listener instanceof CSharpPreprocessorParserListener ) {
        listener.enterPreprocessorDiagnostic_DropletFile(this);
	}
};

PreprocessorDiagnostic_DropletFileContext.prototype.exitRule = function(listener) {
    if(listener instanceof CSharpPreprocessorParserListener ) {
        listener.exitPreprocessorDiagnostic_DropletFile(this);
	}
};


function PreprocessorConditional_DropletFileContext(parser, ctx) {
	Preprocessor_directive_DropletFileContext.call(this, parser);
    this.expr = null; // Preprocessor_expressionContext;
    Preprocessor_directive_DropletFileContext.prototype.copyFrom.call(this, ctx);
    return this;
}

PreprocessorConditional_DropletFileContext.prototype = Object.create(Preprocessor_directive_DropletFileContext.prototype);
PreprocessorConditional_DropletFileContext.prototype.constructor = PreprocessorConditional_DropletFileContext;

CSharpPreprocessorParser.PreprocessorConditional_DropletFileContext = PreprocessorConditional_DropletFileContext;

PreprocessorConditional_DropletFileContext.prototype.IF = function() {
    return this.getToken(CSharpPreprocessorParser.IF, 0);
};

PreprocessorConditional_DropletFileContext.prototype.directive_new_line_or_sharp = function() {
    return this.getTypedRuleContext(Directive_new_line_or_sharpContext,0);
};

PreprocessorConditional_DropletFileContext.prototype.EOF = function() {
    return this.getToken(CSharpPreprocessorParser.EOF, 0);
};

PreprocessorConditional_DropletFileContext.prototype.preprocessor_expression = function() {
    return this.getTypedRuleContext(Preprocessor_expressionContext,0);
};

PreprocessorConditional_DropletFileContext.prototype.ELIF = function() {
    return this.getToken(CSharpPreprocessorParser.ELIF, 0);
};

PreprocessorConditional_DropletFileContext.prototype.ELSE = function() {
    return this.getToken(CSharpPreprocessorParser.ELSE, 0);
};

PreprocessorConditional_DropletFileContext.prototype.ENDIF = function() {
    return this.getToken(CSharpPreprocessorParser.ENDIF, 0);
};
PreprocessorConditional_DropletFileContext.prototype.enterRule = function(listener) {
    if(listener instanceof CSharpPreprocessorParserListener ) {
        listener.enterPreprocessorConditional_DropletFile(this);
	}
};

PreprocessorConditional_DropletFileContext.prototype.exitRule = function(listener) {
    if(listener instanceof CSharpPreprocessorParserListener ) {
        listener.exitPreprocessorConditional_DropletFile(this);
	}
};



CSharpPreprocessorParser.Preprocessor_directive_DropletFileContext = Preprocessor_directive_DropletFileContext;

CSharpPreprocessorParser.prototype.preprocessor_directive_DropletFile = function() {

    var localctx = new Preprocessor_directive_DropletFileContext(this, this._ctx, this.state);
    this.enterRule(localctx, 6, CSharpPreprocessorParser.RULE_preprocessor_directive_DropletFile);
    var _la = 0; // Token type
    try {
        this.state = 209;
        this._errHandler.sync(this);
        switch(this._input.LA(1)) {
        case CSharpPreprocessorParser.DEFINE:
            localctx = new PreprocessorDeclaration_DropletFileContext(this, localctx);
            this.enterOuterAlt(localctx, 1);
            this.state = 128;
            this.match(CSharpPreprocessorParser.DEFINE);
            this.state = 129;
            localctx._CONDITIONAL_SYMBOL = this.match(CSharpPreprocessorParser.CONDITIONAL_SYMBOL);
            this.state = 130;
            this.directive_new_line_or_sharp();
             ConditionalSymbols.add((localctx._CONDITIONAL_SYMBOL===null ? null : localctx._CONDITIONAL_SYMBOL.text));
            	   localctx.value =  allConditions() 
            this.state = 132;
            this.match(CSharpPreprocessorParser.EOF);
            break;
        case CSharpPreprocessorParser.UNDEF:
            localctx = new PreprocessorDeclaration_DropletFileContext(this, localctx);
            this.enterOuterAlt(localctx, 2);
            this.state = 134;
            this.match(CSharpPreprocessorParser.UNDEF);
            this.state = 135;
            localctx._CONDITIONAL_SYMBOL = this.match(CSharpPreprocessorParser.CONDITIONAL_SYMBOL);
            this.state = 136;
            this.directive_new_line_or_sharp();
             ConditionalSymbols.remove((localctx._CONDITIONAL_SYMBOL===null ? null : localctx._CONDITIONAL_SYMBOL.text));
            	   localctx.value =  allConditions() 
            this.state = 138;
            this.match(CSharpPreprocessorParser.EOF);
            break;
        case CSharpPreprocessorParser.IF:
            localctx = new PreprocessorConditional_DropletFileContext(this, localctx);
            this.enterOuterAlt(localctx, 3);
            this.state = 140;
            this.match(CSharpPreprocessorParser.IF);
            this.state = 141;
            localctx.expr = this.preprocessor_expression(0);
            this.state = 142;
            this.directive_new_line_or_sharp();
             localctx.value =  localctx.expr.value.equals("true") && allConditions() conditions.push(localctx.expr.value.equals("true")); 
            this.state = 144;
            this.match(CSharpPreprocessorParser.EOF);
            break;
        case CSharpPreprocessorParser.ELIF:
            localctx = new PreprocessorConditional_DropletFileContext(this, localctx);
            this.enterOuterAlt(localctx, 4);
            this.state = 146;
            this.match(CSharpPreprocessorParser.ELIF);
            this.state = 147;
            localctx.expr = this.preprocessor_expression(0);
            this.state = 148;
            this.directive_new_line_or_sharp();
             if (!conditions.peek()) { conditions.pop(); localctx.value =  localctx.expr.value.equals("true") && allConditions()
            	     conditions.push(localctx.expr.value.equals("true")); } else localctx.value =  false 
            this.state = 150;
            this.match(CSharpPreprocessorParser.EOF);
            break;
        case CSharpPreprocessorParser.ELSE:
            localctx = new PreprocessorConditional_DropletFileContext(this, localctx);
            this.enterOuterAlt(localctx, 5);
            this.state = 152;
            this.match(CSharpPreprocessorParser.ELSE);
            this.state = 153;
            this.directive_new_line_or_sharp();
             if (!conditions.peek()) { conditions.pop(); localctx.value =  true && allConditions() conditions.push(true); }
            	    else localctx.value =  false 
            this.state = 155;
            this.match(CSharpPreprocessorParser.EOF);
            break;
        case CSharpPreprocessorParser.ENDIF:
            localctx = new PreprocessorConditional_DropletFileContext(this, localctx);
            this.enterOuterAlt(localctx, 6);
            this.state = 157;
            this.match(CSharpPreprocessorParser.ENDIF);
            this.state = 158;
            this.directive_new_line_or_sharp();
             conditions.pop(); localctx.value =  conditions.peek() 
            this.state = 160;
            this.match(CSharpPreprocessorParser.EOF);
            break;
        case CSharpPreprocessorParser.LINE:
            localctx = new PreprocessorLine_DropletFileContext(this, localctx);
            this.enterOuterAlt(localctx, 7);
            this.state = 162;
            this.match(CSharpPreprocessorParser.LINE);
            this.state = 169;
            this._errHandler.sync(this);
            switch(this._input.LA(1)) {
            case CSharpPreprocessorParser.DIGITS:
                this.state = 163;
                this.match(CSharpPreprocessorParser.DIGITS);
                this.state = 165;
                this._errHandler.sync(this);
                _la = this._input.LA(1);
                if(_la===CSharpPreprocessorParser.STRING) {
                    this.state = 164;
                    this.match(CSharpPreprocessorParser.STRING);
                }

                break;
            case CSharpPreprocessorParser.DEFAULT:
                this.state = 167;
                this.match(CSharpPreprocessorParser.DEFAULT);
                break;
            case CSharpPreprocessorParser.DIRECTIVE_HIDDEN:
                this.state = 168;
                this.match(CSharpPreprocessorParser.DIRECTIVE_HIDDEN);
                break;
            default:
                throw new antlr4.error.NoViableAltException(this);
            }
            this.state = 171;
            this.directive_new_line_or_sharp();
             localctx.value =  allConditions() 
            this.state = 173;
            this.match(CSharpPreprocessorParser.EOF);
            break;
        case CSharpPreprocessorParser.ERROR:
            localctx = new PreprocessorDiagnostic_DropletFileContext(this, localctx);
            this.enterOuterAlt(localctx, 8);
            this.state = 175;
            this.match(CSharpPreprocessorParser.ERROR);
            this.state = 176;
            this.match(CSharpPreprocessorParser.TEXT);
            this.state = 177;
            this.directive_new_line_or_sharp();
             localctx.value =  allConditions() 
            this.state = 179;
            this.match(CSharpPreprocessorParser.EOF);
            break;
        case CSharpPreprocessorParser.WARNING:
            localctx = new PreprocessorDiagnostic_DropletFileContext(this, localctx);
            this.enterOuterAlt(localctx, 9);
            this.state = 181;
            this.match(CSharpPreprocessorParser.WARNING);
            this.state = 182;
            this.match(CSharpPreprocessorParser.TEXT);
            this.state = 183;
            this.directive_new_line_or_sharp();
             localctx.value =  allConditions() 
            this.state = 185;
            this.match(CSharpPreprocessorParser.EOF);
            break;
        case CSharpPreprocessorParser.REGION:
            localctx = new PreprocessorRegion_DropletFileContext(this, localctx);
            this.enterOuterAlt(localctx, 10);
            this.state = 187;
            this.match(CSharpPreprocessorParser.REGION);
            this.state = 189;
            this._errHandler.sync(this);
            _la = this._input.LA(1);
            if(_la===CSharpPreprocessorParser.TEXT) {
                this.state = 188;
                this.match(CSharpPreprocessorParser.TEXT);
            }

            this.state = 191;
            this.directive_new_line_or_sharp();
             localctx.value =  allConditions() 
            this.state = 193;
            this.match(CSharpPreprocessorParser.EOF);
            break;
        case CSharpPreprocessorParser.ENDREGION:
            localctx = new PreprocessorRegion_DropletFileContext(this, localctx);
            this.enterOuterAlt(localctx, 11);
            this.state = 195;
            this.match(CSharpPreprocessorParser.ENDREGION);
            this.state = 197;
            this._errHandler.sync(this);
            _la = this._input.LA(1);
            if(_la===CSharpPreprocessorParser.TEXT) {
                this.state = 196;
                this.match(CSharpPreprocessorParser.TEXT);
            }

            this.state = 199;
            this.directive_new_line_or_sharp();
             localctx.value =  allConditions() 
            this.state = 201;
            this.match(CSharpPreprocessorParser.EOF);
            break;
        case CSharpPreprocessorParser.PRAGMA:
            localctx = new PreprocessorPragma_DropletFileContext(this, localctx);
            this.enterOuterAlt(localctx, 12);
            this.state = 203;
            this.match(CSharpPreprocessorParser.PRAGMA);
            this.state = 204;
            this.match(CSharpPreprocessorParser.TEXT);
            this.state = 205;
            this.directive_new_line_or_sharp();
             localctx.value =  allConditions() 
            this.state = 207;
            this.match(CSharpPreprocessorParser.EOF);
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

function Directive_new_line_or_sharp_DropletFileContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = CSharpPreprocessorParser.RULE_directive_new_line_or_sharp_DropletFile;
    return this;
}

Directive_new_line_or_sharp_DropletFileContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
Directive_new_line_or_sharp_DropletFileContext.prototype.constructor = Directive_new_line_or_sharp_DropletFileContext;

Directive_new_line_or_sharp_DropletFileContext.prototype.DIRECTIVE_NEW_LINE = function() {
    return this.getToken(CSharpPreprocessorParser.DIRECTIVE_NEW_LINE, 0);
};

Directive_new_line_or_sharp_DropletFileContext.prototype.EOF = function(i) {
	if(i===undefined) {
		i = null;
	}
    if(i===null) {
        return this.getTokens(CSharpPreprocessorParser.EOF);
    } else {
        return this.getToken(CSharpPreprocessorParser.EOF, i);
    }
};


Directive_new_line_or_sharp_DropletFileContext.prototype.enterRule = function(listener) {
    if(listener instanceof CSharpPreprocessorParserListener ) {
        listener.enterDirective_new_line_or_sharp_DropletFile(this);
	}
};

Directive_new_line_or_sharp_DropletFileContext.prototype.exitRule = function(listener) {
    if(listener instanceof CSharpPreprocessorParserListener ) {
        listener.exitDirective_new_line_or_sharp_DropletFile(this);
	}
};




CSharpPreprocessorParser.Directive_new_line_or_sharp_DropletFileContext = Directive_new_line_or_sharp_DropletFileContext;

CSharpPreprocessorParser.prototype.directive_new_line_or_sharp_DropletFile = function() {

    var localctx = new Directive_new_line_or_sharp_DropletFileContext(this, this._ctx, this.state);
    this.enterRule(localctx, 8, CSharpPreprocessorParser.RULE_directive_new_line_or_sharp_DropletFile);
    try {
        this.state = 215;
        this._errHandler.sync(this);
        switch(this._input.LA(1)) {
        case CSharpPreprocessorParser.DIRECTIVE_NEW_LINE:
            this.enterOuterAlt(localctx, 1);
            this.state = 211;
            this.match(CSharpPreprocessorParser.DIRECTIVE_NEW_LINE);
            this.state = 212;
            this.match(CSharpPreprocessorParser.EOF);
            break;
        case CSharpPreprocessorParser.EOF:
            this.enterOuterAlt(localctx, 2);
            this.state = 213;
            this.match(CSharpPreprocessorParser.EOF);
            this.state = 214;
            this.match(CSharpPreprocessorParser.EOF);
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

function Preprocessor_expression_DropletFileContext(parser, parent, invokingState) {
	if(parent===undefined) {
	    parent = null;
	}
	if(invokingState===undefined || invokingState===null) {
		invokingState = -1;
	}
	antlr4.ParserRuleContext.call(this, parent, invokingState);
    this.parser = parser;
    this.ruleIndex = CSharpPreprocessorParser.RULE_preprocessor_expression_DropletFile;
    this.value = null
    this._CONDITIONAL_SYMBOL = null; // Token
    this.expr = null; // Preprocessor_expressionContext
    this.expr1 = null; // Preprocessor_expressionContext
    this.expr2 = null; // Preprocessor_expressionContext
    return this;
}

Preprocessor_expression_DropletFileContext.prototype = Object.create(antlr4.ParserRuleContext.prototype);
Preprocessor_expression_DropletFileContext.prototype.constructor = Preprocessor_expression_DropletFileContext;

Preprocessor_expression_DropletFileContext.prototype.TRUE = function() {
    return this.getToken(CSharpPreprocessorParser.TRUE, 0);
};

Preprocessor_expression_DropletFileContext.prototype.EOF = function() {
    return this.getToken(CSharpPreprocessorParser.EOF, 0);
};

Preprocessor_expression_DropletFileContext.prototype.FALSE = function() {
    return this.getToken(CSharpPreprocessorParser.FALSE, 0);
};

Preprocessor_expression_DropletFileContext.prototype.CONDITIONAL_SYMBOL = function() {
    return this.getToken(CSharpPreprocessorParser.CONDITIONAL_SYMBOL, 0);
};

Preprocessor_expression_DropletFileContext.prototype.OPEN_PARENS = function() {
    return this.getToken(CSharpPreprocessorParser.OPEN_PARENS, 0);
};

Preprocessor_expression_DropletFileContext.prototype.CLOSE_PARENS = function() {
    return this.getToken(CSharpPreprocessorParser.CLOSE_PARENS, 0);
};

Preprocessor_expression_DropletFileContext.prototype.preprocessor_expression = function(i) {
    if(i===undefined) {
        i = null;
    }
    if(i===null) {
        return this.getTypedRuleContexts(Preprocessor_expressionContext);
    } else {
        return this.getTypedRuleContext(Preprocessor_expressionContext,i);
    }
};

Preprocessor_expression_DropletFileContext.prototype.BANG = function() {
    return this.getToken(CSharpPreprocessorParser.BANG, 0);
};

Preprocessor_expression_DropletFileContext.prototype.OP_EQ = function() {
    return this.getToken(CSharpPreprocessorParser.OP_EQ, 0);
};

Preprocessor_expression_DropletFileContext.prototype.OP_NE = function() {
    return this.getToken(CSharpPreprocessorParser.OP_NE, 0);
};

Preprocessor_expression_DropletFileContext.prototype.OP_AND = function() {
    return this.getToken(CSharpPreprocessorParser.OP_AND, 0);
};

Preprocessor_expression_DropletFileContext.prototype.OP_OR = function() {
    return this.getToken(CSharpPreprocessorParser.OP_OR, 0);
};

Preprocessor_expression_DropletFileContext.prototype.enterRule = function(listener) {
    if(listener instanceof CSharpPreprocessorParserListener ) {
        listener.enterPreprocessor_expression_DropletFile(this);
	}
};

Preprocessor_expression_DropletFileContext.prototype.exitRule = function(listener) {
    if(listener instanceof CSharpPreprocessorParserListener ) {
        listener.exitPreprocessor_expression_DropletFile(this);
	}
};




CSharpPreprocessorParser.Preprocessor_expression_DropletFileContext = Preprocessor_expression_DropletFileContext;

CSharpPreprocessorParser.prototype.preprocessor_expression_DropletFile = function() {

    var localctx = new Preprocessor_expression_DropletFileContext(this, this._ctx, this.state);
    this.enterRule(localctx, 10, CSharpPreprocessorParser.RULE_preprocessor_expression_DropletFile);
    try {
        this.state = 261;
        this._errHandler.sync(this);
        var la_ = this._interp.adaptivePredict(this._input,14,this._ctx);
        switch(la_) {
        case 1:
            this.enterOuterAlt(localctx, 1);
            this.state = 217;
            this.match(CSharpPreprocessorParser.TRUE);
             localctx.value =  "true" 
            this.state = 219;
            this.match(CSharpPreprocessorParser.EOF);
            break;

        case 2:
            this.enterOuterAlt(localctx, 2);
            this.state = 220;
            this.match(CSharpPreprocessorParser.FALSE);
             localctx.value =  "false" 
            this.state = 222;
            this.match(CSharpPreprocessorParser.EOF);
            break;

        case 3:
            this.enterOuterAlt(localctx, 3);
            this.state = 223;
            localctx._CONDITIONAL_SYMBOL = this.match(CSharpPreprocessorParser.CONDITIONAL_SYMBOL);
             localctx.value =  ConditionalSymbols.has((localctx._CONDITIONAL_SYMBOL===null ? null : localctx._CONDITIONAL_SYMBOL.text)) ? "true" : "false" 
            this.state = 225;
            this.match(CSharpPreprocessorParser.EOF);
            break;

        case 4:
            this.enterOuterAlt(localctx, 4);
            this.state = 226;
            this.match(CSharpPreprocessorParser.OPEN_PARENS);
            this.state = 227;
            localctx.expr = this.preprocessor_expression(0);
            this.state = 228;
            this.match(CSharpPreprocessorParser.CLOSE_PARENS);
             localctx.value =  localctx.expr.value 
            this.state = 230;
            this.match(CSharpPreprocessorParser.EOF);
            break;

        case 5:
            this.enterOuterAlt(localctx, 5);
            this.state = 232;
            this.match(CSharpPreprocessorParser.BANG);
            this.state = 233;
            localctx.expr = this.preprocessor_expression(0);
             localctx.value =  localctx.expr.value.equals("true") ? "false" : "true" 
            this.state = 235;
            this.match(CSharpPreprocessorParser.EOF);
            break;

        case 6:
            this.enterOuterAlt(localctx, 6);
            this.state = 237;
            localctx.expr1 = this.preprocessor_expression(0);
            this.state = 238;
            this.match(CSharpPreprocessorParser.OP_EQ);
            this.state = 239;
            localctx.expr2 = this.preprocessor_expression(0);
             localctx.value =  (localctx.expr1.value == localctx.expr2.value ? "true" : "false") 
            this.state = 241;
            this.match(CSharpPreprocessorParser.EOF);
            break;

        case 7:
            this.enterOuterAlt(localctx, 7);
            this.state = 243;
            localctx.expr1 = this.preprocessor_expression(0);
            this.state = 244;
            this.match(CSharpPreprocessorParser.OP_NE);
            this.state = 245;
            localctx.expr2 = this.preprocessor_expression(0);
             localctx.value =  (localctx.expr1.value != localctx.expr2.value ? "true" : "false") 
            this.state = 247;
            this.match(CSharpPreprocessorParser.EOF);
            break;

        case 8:
            this.enterOuterAlt(localctx, 8);
            this.state = 249;
            localctx.expr1 = this.preprocessor_expression(0);
            this.state = 250;
            this.match(CSharpPreprocessorParser.OP_AND);
            this.state = 251;
            localctx.expr2 = this.preprocessor_expression(0);
             localctx.value =  (localctx.expr1.value.equals("true") && localctx.expr2.value.equals("true") ? "true" : "false") 
            this.state = 253;
            this.match(CSharpPreprocessorParser.EOF);
            break;

        case 9:
            this.enterOuterAlt(localctx, 9);
            this.state = 255;
            localctx.expr1 = this.preprocessor_expression(0);
            this.state = 256;
            this.match(CSharpPreprocessorParser.OP_OR);
            this.state = 257;
            localctx.expr2 = this.preprocessor_expression(0);
             localctx.value =  (localctx.expr1.value.equals("true") || localctx.expr2.value.equals("true") ? "true" : "false") 
            this.state = 259;
            this.match(CSharpPreprocessorParser.EOF);
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


CSharpPreprocessorParser.prototype.sempred = function(localctx, ruleIndex, predIndex) {
	switch(ruleIndex) {
	case 2:
			return this.preprocessor_expression_sempred(localctx, predIndex);
    default:
        throw "No predicate with index:" + ruleIndex;
   }
};

CSharpPreprocessorParser.prototype.preprocessor_expression_sempred = function(localctx, predIndex) {
	switch(predIndex) {
		case 0:
			return this.precpred(this._ctx, 4);
		case 1:
			return this.precpred(this._ctx, 3);
		case 2:
			return this.precpred(this._ctx, 2);
		case 3:
			return this.precpred(this._ctx, 1);
		default:
			throw "No predicate with index:" + predIndex;
	}
};


exports.CSharpPreprocessorParser = CSharpPreprocessorParser;
