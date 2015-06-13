// Generated from jvmBasic.g4 by ANTLR 4.5
// jshint ignore: start
var antlr4 = require('antlr4/index');

// This class defines a complete listener for a parse tree produced by jvmBasicParser.
function jvmBasicListener() {
	antlr4.tree.ParseTreeListener.call(this);
	return this;
}

jvmBasicListener.prototype = Object.create(antlr4.tree.ParseTreeListener.prototype);
jvmBasicListener.prototype.constructor = jvmBasicListener;

// Enter a parse tree produced by jvmBasicParser#prog.
jvmBasicListener.prototype.enterProg = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#prog.
jvmBasicListener.prototype.exitProg = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#line.
jvmBasicListener.prototype.enterLine = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#line.
jvmBasicListener.prototype.exitLine = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#amperoper.
jvmBasicListener.prototype.enterAmperoper = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#amperoper.
jvmBasicListener.prototype.exitAmperoper = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#linenumber.
jvmBasicListener.prototype.enterLinenumber = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#linenumber.
jvmBasicListener.prototype.exitLinenumber = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#amprstmt.
jvmBasicListener.prototype.enterAmprstmt = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#amprstmt.
jvmBasicListener.prototype.exitAmprstmt = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#statement.
jvmBasicListener.prototype.enterStatement = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#statement.
jvmBasicListener.prototype.exitStatement = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#vardecl.
jvmBasicListener.prototype.enterVardecl = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#vardecl.
jvmBasicListener.prototype.exitVardecl = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#printstmt1.
jvmBasicListener.prototype.enterPrintstmt1 = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#printstmt1.
jvmBasicListener.prototype.exitPrintstmt1 = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#printlist.
jvmBasicListener.prototype.enterPrintlist = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#printlist.
jvmBasicListener.prototype.exitPrintlist = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#getstmt.
jvmBasicListener.prototype.enterGetstmt = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#getstmt.
jvmBasicListener.prototype.exitGetstmt = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#letstmt.
jvmBasicListener.prototype.enterLetstmt = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#letstmt.
jvmBasicListener.prototype.exitLetstmt = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#variableassignment.
jvmBasicListener.prototype.enterVariableassignment = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#variableassignment.
jvmBasicListener.prototype.exitVariableassignment = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#relop.
jvmBasicListener.prototype.enterRelop = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#relop.
jvmBasicListener.prototype.exitRelop = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#gte.
jvmBasicListener.prototype.enterGte = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#gte.
jvmBasicListener.prototype.exitGte = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#lte.
jvmBasicListener.prototype.enterLte = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#lte.
jvmBasicListener.prototype.exitLte = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#neq.
jvmBasicListener.prototype.enterNeq = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#neq.
jvmBasicListener.prototype.exitNeq = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#ifstmt.
jvmBasicListener.prototype.enterIfstmt = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#ifstmt.
jvmBasicListener.prototype.exitIfstmt = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#forstmt.
jvmBasicListener.prototype.enterForstmt = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#forstmt.
jvmBasicListener.prototype.exitForstmt = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#inputstmt.
jvmBasicListener.prototype.enterInputstmt = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#inputstmt.
jvmBasicListener.prototype.exitInputstmt = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#readstmt.
jvmBasicListener.prototype.enterReadstmt = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#readstmt.
jvmBasicListener.prototype.exitReadstmt = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#dimstmt.
jvmBasicListener.prototype.enterDimstmt = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#dimstmt.
jvmBasicListener.prototype.exitDimstmt = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#gotostmt.
jvmBasicListener.prototype.enterGotostmt = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#gotostmt.
jvmBasicListener.prototype.exitGotostmt = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#gosubstmt.
jvmBasicListener.prototype.enterGosubstmt = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#gosubstmt.
jvmBasicListener.prototype.exitGosubstmt = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#pokestmt.
jvmBasicListener.prototype.enterPokestmt = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#pokestmt.
jvmBasicListener.prototype.exitPokestmt = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#callstmt.
jvmBasicListener.prototype.enterCallstmt = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#callstmt.
jvmBasicListener.prototype.exitCallstmt = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#hplotstmt.
jvmBasicListener.prototype.enterHplotstmt = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#hplotstmt.
jvmBasicListener.prototype.exitHplotstmt = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#vplotstmt.
jvmBasicListener.prototype.enterVplotstmt = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#vplotstmt.
jvmBasicListener.prototype.exitVplotstmt = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#plotstmt.
jvmBasicListener.prototype.enterPlotstmt = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#plotstmt.
jvmBasicListener.prototype.exitPlotstmt = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#ongotostmt.
jvmBasicListener.prototype.enterOngotostmt = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#ongotostmt.
jvmBasicListener.prototype.exitOngotostmt = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#ongosubstmt.
jvmBasicListener.prototype.enterOngosubstmt = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#ongosubstmt.
jvmBasicListener.prototype.exitOngosubstmt = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#vtabstmnt.
jvmBasicListener.prototype.enterVtabstmnt = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#vtabstmnt.
jvmBasicListener.prototype.exitVtabstmnt = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#htabstmnt.
jvmBasicListener.prototype.enterHtabstmnt = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#htabstmnt.
jvmBasicListener.prototype.exitHtabstmnt = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#himemstmt.
jvmBasicListener.prototype.enterHimemstmt = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#himemstmt.
jvmBasicListener.prototype.exitHimemstmt = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#lomemstmt.
jvmBasicListener.prototype.enterLomemstmt = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#lomemstmt.
jvmBasicListener.prototype.exitLomemstmt = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#datastmt.
jvmBasicListener.prototype.enterDatastmt = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#datastmt.
jvmBasicListener.prototype.exitDatastmt = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#datum.
jvmBasicListener.prototype.enterDatum = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#datum.
jvmBasicListener.prototype.exitDatum = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#waitstmt.
jvmBasicListener.prototype.enterWaitstmt = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#waitstmt.
jvmBasicListener.prototype.exitWaitstmt = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#xdrawstmt.
jvmBasicListener.prototype.enterXdrawstmt = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#xdrawstmt.
jvmBasicListener.prototype.exitXdrawstmt = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#drawstmt.
jvmBasicListener.prototype.enterDrawstmt = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#drawstmt.
jvmBasicListener.prototype.exitDrawstmt = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#defstmt.
jvmBasicListener.prototype.enterDefstmt = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#defstmt.
jvmBasicListener.prototype.exitDefstmt = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#tabstmt.
jvmBasicListener.prototype.enterTabstmt = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#tabstmt.
jvmBasicListener.prototype.exitTabstmt = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#speedstmt.
jvmBasicListener.prototype.enterSpeedstmt = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#speedstmt.
jvmBasicListener.prototype.exitSpeedstmt = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#rotstmt.
jvmBasicListener.prototype.enterRotstmt = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#rotstmt.
jvmBasicListener.prototype.exitRotstmt = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#scalestmt.
jvmBasicListener.prototype.enterScalestmt = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#scalestmt.
jvmBasicListener.prototype.exitScalestmt = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#colorstmt.
jvmBasicListener.prototype.enterColorstmt = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#colorstmt.
jvmBasicListener.prototype.exitColorstmt = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#hcolorstmt.
jvmBasicListener.prototype.enterHcolorstmt = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#hcolorstmt.
jvmBasicListener.prototype.exitHcolorstmt = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#hlinstmt.
jvmBasicListener.prototype.enterHlinstmt = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#hlinstmt.
jvmBasicListener.prototype.exitHlinstmt = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#vlinstmt.
jvmBasicListener.prototype.enterVlinstmt = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#vlinstmt.
jvmBasicListener.prototype.exitVlinstmt = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#onerrstmt.
jvmBasicListener.prototype.enterOnerrstmt = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#onerrstmt.
jvmBasicListener.prototype.exitOnerrstmt = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#prstmt.
jvmBasicListener.prototype.enterPrstmt = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#prstmt.
jvmBasicListener.prototype.exitPrstmt = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#instmt.
jvmBasicListener.prototype.enterInstmt = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#instmt.
jvmBasicListener.prototype.exitInstmt = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#storestmt.
jvmBasicListener.prototype.enterStorestmt = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#storestmt.
jvmBasicListener.prototype.exitStorestmt = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#recallstmt.
jvmBasicListener.prototype.enterRecallstmt = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#recallstmt.
jvmBasicListener.prototype.exitRecallstmt = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#liststmt.
jvmBasicListener.prototype.enterListstmt = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#liststmt.
jvmBasicListener.prototype.exitListstmt = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#popstmt.
jvmBasicListener.prototype.enterPopstmt = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#popstmt.
jvmBasicListener.prototype.exitPopstmt = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#amptstmt.
jvmBasicListener.prototype.enterAmptstmt = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#amptstmt.
jvmBasicListener.prototype.exitAmptstmt = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#includestmt.
jvmBasicListener.prototype.enterIncludestmt = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#includestmt.
jvmBasicListener.prototype.exitIncludestmt = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#endstmt.
jvmBasicListener.prototype.enterEndstmt = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#endstmt.
jvmBasicListener.prototype.exitEndstmt = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#returnstmt.
jvmBasicListener.prototype.enterReturnstmt = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#returnstmt.
jvmBasicListener.prototype.exitReturnstmt = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#restorestmt.
jvmBasicListener.prototype.enterRestorestmt = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#restorestmt.
jvmBasicListener.prototype.exitRestorestmt = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#func.
jvmBasicListener.prototype.enterFunc = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#func.
jvmBasicListener.prototype.exitFunc = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#signExpression.
jvmBasicListener.prototype.enterSignExpression = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#signExpression.
jvmBasicListener.prototype.exitSignExpression = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#exponentExpression.
jvmBasicListener.prototype.enterExponentExpression = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#exponentExpression.
jvmBasicListener.prototype.exitExponentExpression = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#multiplyingExpression.
jvmBasicListener.prototype.enterMultiplyingExpression = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#multiplyingExpression.
jvmBasicListener.prototype.exitMultiplyingExpression = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#addingExpression.
jvmBasicListener.prototype.enterAddingExpression = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#addingExpression.
jvmBasicListener.prototype.exitAddingExpression = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#relationalExpression.
jvmBasicListener.prototype.enterRelationalExpression = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#relationalExpression.
jvmBasicListener.prototype.exitRelationalExpression = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#expression.
jvmBasicListener.prototype.enterExpression = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#expression.
jvmBasicListener.prototype.exitExpression = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#var.
jvmBasicListener.prototype.enterVar = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#var.
jvmBasicListener.prototype.exitVar = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#varname.
jvmBasicListener.prototype.enterVarname = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#varname.
jvmBasicListener.prototype.exitVarname = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#varsuffix.
jvmBasicListener.prototype.enterVarsuffix = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#varsuffix.
jvmBasicListener.prototype.exitVarsuffix = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#varlist.
jvmBasicListener.prototype.enterVarlist = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#varlist.
jvmBasicListener.prototype.exitVarlist = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#exprlist.
jvmBasicListener.prototype.enterExprlist = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#exprlist.
jvmBasicListener.prototype.exitExprlist = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#sqrfunc.
jvmBasicListener.prototype.enterSqrfunc = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#sqrfunc.
jvmBasicListener.prototype.exitSqrfunc = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#chrfunc.
jvmBasicListener.prototype.enterChrfunc = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#chrfunc.
jvmBasicListener.prototype.exitChrfunc = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#lenfunc.
jvmBasicListener.prototype.enterLenfunc = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#lenfunc.
jvmBasicListener.prototype.exitLenfunc = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#ascfunc.
jvmBasicListener.prototype.enterAscfunc = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#ascfunc.
jvmBasicListener.prototype.exitAscfunc = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#midfunc.
jvmBasicListener.prototype.enterMidfunc = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#midfunc.
jvmBasicListener.prototype.exitMidfunc = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#pdlfunc.
jvmBasicListener.prototype.enterPdlfunc = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#pdlfunc.
jvmBasicListener.prototype.exitPdlfunc = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#peekfunc.
jvmBasicListener.prototype.enterPeekfunc = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#peekfunc.
jvmBasicListener.prototype.exitPeekfunc = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#intfunc.
jvmBasicListener.prototype.enterIntfunc = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#intfunc.
jvmBasicListener.prototype.exitIntfunc = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#spcfunc.
jvmBasicListener.prototype.enterSpcfunc = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#spcfunc.
jvmBasicListener.prototype.exitSpcfunc = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#frefunc.
jvmBasicListener.prototype.enterFrefunc = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#frefunc.
jvmBasicListener.prototype.exitFrefunc = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#posfunc.
jvmBasicListener.prototype.enterPosfunc = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#posfunc.
jvmBasicListener.prototype.exitPosfunc = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#usrfunc.
jvmBasicListener.prototype.enterUsrfunc = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#usrfunc.
jvmBasicListener.prototype.exitUsrfunc = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#leftfunc.
jvmBasicListener.prototype.enterLeftfunc = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#leftfunc.
jvmBasicListener.prototype.exitLeftfunc = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#rightfunc.
jvmBasicListener.prototype.enterRightfunc = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#rightfunc.
jvmBasicListener.prototype.exitRightfunc = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#strfunc.
jvmBasicListener.prototype.enterStrfunc = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#strfunc.
jvmBasicListener.prototype.exitStrfunc = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#fnfunc.
jvmBasicListener.prototype.enterFnfunc = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#fnfunc.
jvmBasicListener.prototype.exitFnfunc = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#valfunc.
jvmBasicListener.prototype.enterValfunc = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#valfunc.
jvmBasicListener.prototype.exitValfunc = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#scrnfunc.
jvmBasicListener.prototype.enterScrnfunc = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#scrnfunc.
jvmBasicListener.prototype.exitScrnfunc = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#sinfunc.
jvmBasicListener.prototype.enterSinfunc = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#sinfunc.
jvmBasicListener.prototype.exitSinfunc = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#cosfunc.
jvmBasicListener.prototype.enterCosfunc = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#cosfunc.
jvmBasicListener.prototype.exitCosfunc = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#tanfunc.
jvmBasicListener.prototype.enterTanfunc = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#tanfunc.
jvmBasicListener.prototype.exitTanfunc = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#atnfunc.
jvmBasicListener.prototype.enterAtnfunc = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#atnfunc.
jvmBasicListener.prototype.exitAtnfunc = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#rndfunc.
jvmBasicListener.prototype.enterRndfunc = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#rndfunc.
jvmBasicListener.prototype.exitRndfunc = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#sgnfunc.
jvmBasicListener.prototype.enterSgnfunc = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#sgnfunc.
jvmBasicListener.prototype.exitSgnfunc = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#expfunc.
jvmBasicListener.prototype.enterExpfunc = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#expfunc.
jvmBasicListener.prototype.exitExpfunc = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#logfunc.
jvmBasicListener.prototype.enterLogfunc = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#logfunc.
jvmBasicListener.prototype.exitLogfunc = function(ctx) {
};


// Enter a parse tree produced by jvmBasicParser#absfunc.
jvmBasicListener.prototype.enterAbsfunc = function(ctx) {
};

// Exit a parse tree produced by jvmBasicParser#absfunc.
jvmBasicListener.prototype.exitAbsfunc = function(ctx) {
};



exports.jvmBasicListener = jvmBasicListener;