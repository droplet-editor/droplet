/*
 * [The "BSD license"]
 *  Copyright (c) 2014 Terence Parr
 *  Copyright (c) 2014 Sam Harwell
 *  Copyright (c) 2017 Chan Chung Kwong
 *  Updated 2018 by Jeremiah Blanchard
 *  All rights reserved.
 *
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions
 *  are met:
 *
 *  1. Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *  2. Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *  3. The name of the author may not be used to endorse or promote products
 *     derived from this software without specific prior written permission.
 *
 *  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 *  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 *  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 *  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 *  NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 *  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 *  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 * A Java 9 grammar for ANTLR 4 derived from the Java Language Specification
 *
 *  $ antlr4 Java.g4
 *  $ javac *.java
 *  $ grun Java compilationUnit *.java
 *
 */
grammar Java;

/*
 * Productions from §3 (Lexical Structure)
 */

literal
	:	IntegerLiteral
	|	FloatingPointLiteral
	|	BooleanLiteral
	|	CharacterLiteral
	|	StringLiteral
	|	NullLiteral
	;

/*
 * Productions from §4 (Types, Values, and Variables)
 */

primitiveType
	:	annotation* numericType
	|	annotation* 'boolean'
	;

numericType
	:	integralType
	|	floatingPointType
	;

integralType
	:	'byte'
	|	'short'
	|	'int'
	|	'long'
	|	'char'
	;

floatingPointType
	:	'float'
	|	'double'
	;

referenceType
	:	classOrInterfaceType
	|	typeVariable
	|	arrayType
	;

/*classOrInterfaceType
	:	classType
	|	interfaceType
	;
*/
classOrInterfaceType
	:	(	classType_lfno_classOrInterfaceType
		|	interfaceType_lfno_classOrInterfaceType
		)
		(	classType_lf_classOrInterfaceType
		|	interfaceType_lf_classOrInterfaceType
		)*
	;

classType
	:	annotation* identifier typeArguments?
	|	classOrInterfaceType '.' annotation* identifier typeArguments?
	;

classType_lf_classOrInterfaceType
	:	'.' annotation* identifier typeArguments?
	;

classType_lfno_classOrInterfaceType
	:	annotation* identifier typeArguments?
	;

interfaceType
	:	classType
	;

interfaceType_lf_classOrInterfaceType
	:	classType_lf_classOrInterfaceType
	;

interfaceType_lfno_classOrInterfaceType
	:	classType_lfno_classOrInterfaceType
	;

typeVariable
	:	annotation* identifier
	;

arrayType
	:	primitiveType dims
	|	classOrInterfaceType dims
	|	typeVariable dims
	;

dims
	:	annotation* '[' ']' (annotation* '[' ']')*
	;

typeParameter
	:	typeParameterModifier* identifier typeBound?
	;

typeParameterModifier
	:	annotation
	;

typeBound
	:	'extends' typeVariable
	|	'extends' classOrInterfaceType additionalBound*
	;

additionalBound
	:	'&' interfaceType
	;

typeArguments
	:	'<' typeArgumentList '>'
	;

typeArgumentList
	:	typeArgument (',' typeArgument)*
	;

typeArgument
	:	referenceType
	|	wildcard
	;

wildcard
	:	annotation* '?' wildcardBounds?
	;

wildcardBounds
	:	'extends' referenceType
	|	'super' referenceType
	;

/*
 * Productions from §6 (Names)
 */

moduleName
	:	identifier
	|	moduleName '.' identifier
	;

packageName
	:	identifier
	|	packageName '.' identifier
	;

typeName
	:	identifier
	|	packageOrTypeName '.' identifier
	;

packageOrTypeName
	:	identifier
	|	packageOrTypeName '.' identifier
	;

expressionName
	:	identifier
	|	ambiguousName '.' identifier
	;

methodName
	:	identifier
	;

ambiguousName
	:	identifier
	|	ambiguousName '.' identifier
	;

/*
 * Productions from §7 (Packages)
 */

compilationUnit
	:	ordinaryCompilation
	|	modularCompilation
	;

ordinaryCompilation
	:	packageDeclaration? importDeclaration* typeDeclaration* EOF
	;

modularCompilation
	:	importDeclaration* moduleDeclaration
	;

packageDeclaration
	:	packageModifier* 'package' packageName ';'
	;

packageModifier
	:	annotation
	;

importDeclaration
	:	singleTypeImportDeclaration
	|	typeImportOnDemandDeclaration
	|	singleStaticImportDeclaration
	|	staticImportOnDemandDeclaration
	;

singleTypeImportDeclaration
	:	'import' typeName ';'
	;

typeImportOnDemandDeclaration
	:	'import' packageOrTypeName '.' '*' ';'
	;

singleStaticImportDeclaration
	:	'import' 'static' typeName '.' identifier ';'
	;

staticImportOnDemandDeclaration
	:	'import' 'static' typeName '.' '*' ';'
	;

typeDeclaration
	:	classDeclaration
	|	interfaceDeclaration
	|	';'
	;

moduleDeclaration
	:	annotation* 'open'? 'module' moduleName '{' moduleDirective* '}'
	;

moduleDirective
	:	'requires' requiresModifier* moduleName ';'
	|	'exports' packageName ('to' moduleName (',' moduleName)*)? ';'
	|	'opens' packageName ('to' moduleName (',' moduleName)*)? ';'
	|	'uses' typeName ';'
	|	'provides' typeName 'with' typeName (',' typeName)* ';'
	;

requiresModifier
	:	'transitive'
	|	'static'
	;

/*
 * Productions from §8 (Classes)
 */

classDeclaration
	:	normalClassDeclaration
	|	enumDeclaration
	;

normalClassDeclaration
	:	classModifier* 'class' identifier typeParameters? superclass? superinterfaces? classBody
	;

classModifier
	:	annotation
	|	'public'
	|	'protected'
	|	'private'
	|	'abstract'
	|	'static'
	|	'final'
	|	'strictfp'
	;

typeParameters
	:	'<' typeParameterList '>'
	;

typeParameterList
	:	typeParameter (',' typeParameter)*
	;

superclass
	:	'extends' classType
	;

superinterfaces
	:	'implements' interfaceTypeList
	;

interfaceTypeList
	:	interfaceType (',' interfaceType)*
	;

classBody
	:	'{' classBodyDeclaration* '}'
	;

classBodyDeclaration
	:	classMemberDeclaration
	|	instanceInitializer
	|	staticInitializer
	|	constructorDeclaration
	;

classMemberDeclaration
	:	fieldDeclaration
	|	methodDeclaration
	|	classDeclaration
	|	interfaceDeclaration
	|	';'
	;

fieldDeclaration
	:	fieldModifier* unannType variableDeclaratorList ';'
	;

fieldModifier
	:	annotation
	|	'public'
	|	'protected'
	|	'private'
	|	'static'
	|	'final'
	|	'transient'
	|	'volatile'
	;

variableDeclaratorList
	:	variableDeclarator (',' variableDeclarator)*
	;

variableDeclarator
	:	variableDeclaratorId ('=' variableInitializer)?
	;

variableDeclaratorId
	:	identifier dims?
	;

variableInitializer
	:	expression
	|	arrayInitializer
	;

unannType
	:	unannPrimitiveType
	|	unannReferenceType
	;

unannPrimitiveType
	:	numericType
	|	'boolean'
	;

unannReferenceType
	:	unannClassOrInterfaceType
	|	unannTypeVariable
	|	unannArrayType
	;

/*unannClassOrInterfaceType
	:	unannClassType
	|	unannInterfaceType
	;
*/

unannClassOrInterfaceType
	:	(	unannClassType_lfno_unannClassOrInterfaceType
		|	unannInterfaceType_lfno_unannClassOrInterfaceType
		)
		(	unannClassType_lf_unannClassOrInterfaceType
		|	unannInterfaceType_lf_unannClassOrInterfaceType
		)*
	;

unannClassType
	:	identifier typeArguments?
	|	unannClassOrInterfaceType '.' annotation* identifier typeArguments?
	;

unannClassType_lf_unannClassOrInterfaceType
	:	'.' annotation* identifier typeArguments?
	;

unannClassType_lfno_unannClassOrInterfaceType
	:	identifier typeArguments?
	;

unannInterfaceType
	:	unannClassType
	;

unannInterfaceType_lf_unannClassOrInterfaceType
	:	unannClassType_lf_unannClassOrInterfaceType
	;

unannInterfaceType_lfno_unannClassOrInterfaceType
	:	unannClassType_lfno_unannClassOrInterfaceType
	;

unannTypeVariable
	:	identifier
	;

unannArrayType
	:	unannPrimitiveType dims
	|	unannClassOrInterfaceType dims
	|	unannTypeVariable dims
	;

methodDeclaration
	:	methodModifier* methodHeader methodBody
	;

methodModifier
	:	annotation
	|	'public'
	|	'protected'
	|	'private'
	|	'abstract'
	|	'static'
	|	'final'
	|	'synchronized'
	|	'native'
	|	'strictfp'
	;

methodHeader
	:	result methodDeclarator throws_?
	|	typeParameters annotation* result methodDeclarator throws_?
	;

result
	:	unannType
	|	'void'
	;

methodDeclarator
	:	identifier '(' formalParameterList? ')' dims?
	;

formalParameterList
	:	formalParameters ',' lastFormalParameter
	|	lastFormalParameter
	|	receiverParameter
	;

formalParameters
	:	formalParameter (',' formalParameter)*
	|	receiverParameter (',' formalParameter)*
	;

formalParameter
	:	variableModifier* unannType variableDeclaratorId
	;

variableModifier
	:	annotation
	|	'final'
	;

lastFormalParameter
	:	variableModifier* unannType annotation* '...' variableDeclaratorId
	|	formalParameter
	;

receiverParameter
	:	annotation* unannType (identifier '.')? 'this'
	;

throws_
	:	'throws' exceptionTypeList
	;

exceptionTypeList
	:	exceptionType (',' exceptionType)*
	;

exceptionType
	:	classType
	|	typeVariable
	;

methodBody
	:	block
	|	';'
	;

instanceInitializer
	:	block
	;

staticInitializer
	:	'static' block
	;

constructorDeclaration
	:	constructorModifier* constructorDeclarator throws_? constructorBody
	;

constructorModifier
	:	annotation
	|	'public'
	|	'protected'
	|	'private'
	;

constructorDeclarator
	:	typeParameters? simpleTypeName '(' formalParameterList? ')'
	;

simpleTypeName
	:	identifier
	;

constructorBody
	:	'{' explicitConstructorInvocation? blockStatements? '}'
	;

explicitConstructorInvocation
	:	typeArguments? 'this' '(' argumentList? ')' ';'
	|	typeArguments? 'super' '(' argumentList? ')' ';'
	|	expressionName '.' typeArguments? 'super' '(' argumentList? ')' ';'
	|	primary '.' typeArguments? 'super' '(' argumentList? ')' ';'
	;

enumDeclaration
	:	classModifier* 'enum' identifier superinterfaces? enumBody
	;

enumBody
	:	'{' enumConstantList? ','? enumBodyDeclarations? '}'
	;

enumConstantList
	:	enumConstant (',' enumConstant)*
	;

enumConstant
	:	enumConstantModifier* identifier ('(' argumentList? ')')? classBody?
	;

enumConstantModifier
	:	annotation
	;

enumBodyDeclarations
	:	';' classBodyDeclaration*
	;

/*
 * Productions from §9 (Interfaces)
 */

interfaceDeclaration
	:	normalInterfaceDeclaration
	|	annotationTypeDeclaration
	;

normalInterfaceDeclaration
	:	interfaceModifier* 'interface' identifier typeParameters? extendsInterfaces? interfaceBody
	;

interfaceModifier
	:	annotation
	|	'public'
	|	'protected'
	|	'private'
	|	'abstract'
	|	'static'
	|	'strictfp'
	;

extendsInterfaces
	:	'extends' interfaceTypeList
	;

interfaceBody
	:	'{' interfaceMemberDeclaration* '}'
	;

interfaceMemberDeclaration
	:	constantDeclaration
	|	interfaceMethodDeclaration
	|	classDeclaration
	|	interfaceDeclaration
	|	';'
	;

constantDeclaration
	:	constantModifier* unannType variableDeclaratorList ';'
	;

constantModifier
	:	annotation
	|	'public'
	|	'static'
	|	'final'
	;

interfaceMethodDeclaration
	:	interfaceMethodModifier* methodHeader methodBody
	;

interfaceMethodModifier
	:	annotation
	|	'public'
	|	'private'//Introduced in Java 9
	|	'abstract'
	|	'default'
	|	'static'
	|	'strictfp'
	;

annotationTypeDeclaration
	:	interfaceModifier* '@' 'interface' identifier annotationTypeBody
	;

annotationTypeBody
	:	'{' annotationTypeMemberDeclaration* '}'
	;

annotationTypeMemberDeclaration
	:	annotationTypeElementDeclaration
	|	constantDeclaration
	|	classDeclaration
	|	interfaceDeclaration
	|	';'
	;

annotationTypeElementDeclaration
	:	annotationTypeElementModifier* unannType identifier '(' ')' dims? defaultValue? ';'
	;

annotationTypeElementModifier
	:	annotation
	|	'public'
	|	'abstract'
	;

defaultValue
	:	'default' elementValue
	;

annotation
	:	normalAnnotation
	|	markerAnnotation
	|	singleElementAnnotation
	;

normalAnnotation
	:	'@' typeName '(' elementValuePairList? ')'
	;

elementValuePairList
	:	elementValuePair (',' elementValuePair)*
	;

elementValuePair
	:	identifier '=' elementValue
	;

elementValue
	:	conditionalExpression
	|	elementValueArrayInitializer
	|	annotation
	;

elementValueArrayInitializer
	:	'{' elementValueList? ','? '}'
	;

elementValueList
	:	elementValue (',' elementValue)*
	;

markerAnnotation
	:	'@' typeName
	;

singleElementAnnotation
	:	'@' typeName '(' elementValue ')'
	;

/*
 * Productions from §10 (Arrays)
 */

arrayInitializer
	:	'{' variableInitializerList? ','? '}'
	;

variableInitializerList
	:	variableInitializer (',' variableInitializer)*
	;

/*
 * Productions from §14 (Blocks and Statements)
 */

block
	:	'{' blockStatements? '}'
	;

blockStatements
	:	blockStatement+
	;

blockStatement
	:	localVariableDeclarationStatement
	|	classDeclaration
	|	statement
	;

localVariableDeclarationStatement
	:	localVariableDeclaration ';'
	;

localVariableDeclaration
	:	variableModifier* unannType variableDeclaratorList
	;

statement
	:	statementWithoutTrailingSubstatement
	|	labeledStatement
	|	ifThenStatement
	|	ifThenElseStatement
	|	whileStatement
	|	forStatement
	;

statementNoShortIf
	:	statementWithoutTrailingSubstatement
	|	labeledStatementNoShortIf
	|	ifThenElseStatementNoShortIf
	|	whileStatementNoShortIf
	|	forStatementNoShortIf
	;

statementWithoutTrailingSubstatement
	:	block
	|	emptyStatement
	|	expressionStatement
	|	assertStatement
	|	switchStatement
	|	doStatement
	|	breakStatement
	|	continueStatement
	|	returnStatement
	|	synchronizedStatement
	|	throwStatement
	|	tryStatement
	;

emptyStatement
	:	';'
	;

labeledStatement
	:	identifier ':' statement
	;

labeledStatementNoShortIf
	:	identifier ':' statementNoShortIf
	;

expressionStatement
	:	statementExpression ';'
	;

statementExpression
	:	assignment
	|	preIncrementExpression
	|	preDecrementExpression
	|	postIncrementExpression
	|	postDecrementExpression
	|	methodInvocation
	|	classInstanceCreationExpression
	;

ifThenStatement
	:	'if' '(' expression ')' statement
	;

ifThenElseStatement
	:	'if' '(' expression ')' statementNoShortIf 'else' statement
	;

ifThenElseStatementNoShortIf
	:	'if' '(' expression ')' statementNoShortIf 'else' statementNoShortIf
	;

assertStatement
	:	'assert' expression ';'
	|	'assert' expression ':' expression ';'
	;

switchStatement
	:	'switch' '(' expression ')' switchBlock
	;

switchBlock
	:	'{' switchBlockStatementGroup* switchLabel* '}'
	;

switchBlockStatementGroup
	:	switchLabels blockStatements
	;

switchLabels
	:	switchLabel+
	;

switchLabel
	:	'case' constantExpression ':'
	|	'case' enumConstantName ':'
	|	'default' ':'
	;

enumConstantName
	:	identifier
	;

whileStatement
	:	'while' '(' expression ')' statement
	;

whileStatementNoShortIf
	:	'while' '(' expression ')' statementNoShortIf
	;

doStatement
	:	'do' statement 'while' '(' expression ')' ';'
	;

forStatement
	:	basicForStatement
	|	enhancedForStatement
	;

forStatementNoShortIf
	:	basicForStatementNoShortIf
	|	enhancedForStatementNoShortIf
	;

basicForStatement
	:	'for' '(' forInit? ';' expression? ';' forUpdate? ')' statement
	;

basicForStatementNoShortIf
	:	'for' '(' forInit? ';' expression? ';' forUpdate? ')' statementNoShortIf
	;

forInit
	:	statementExpressionList
	|	localVariableDeclaration
	;

forUpdate
	:	statementExpressionList
	;

statementExpressionList
	:	statementExpression (',' statementExpression)*
	;

enhancedForStatement
	:	'for' '(' variableModifier* unannType variableDeclaratorId ':' expression ')' statement
	;

enhancedForStatementNoShortIf
	:	'for' '(' variableModifier* unannType variableDeclaratorId ':' expression ')' statementNoShortIf
	;

breakStatement
	:	'break' identifier? ';'
	;

continueStatement
	:	'continue' identifier? ';'
	;

returnStatement
	:	'return' expression? ';'
	;

throwStatement
	:	'throw' expression ';'
	;

synchronizedStatement
	:	'synchronized' '(' expression ')' block
	;

tryStatement
	:	'try' block catches
	|	'try' block catches? finally_
	|	tryWithResourcesStatement
	;

catches
	:	catchClause+
	;

catchClause
	:	'catch' '(' catchFormalParameter ')' block
	;

catchFormalParameter
	:	variableModifier* catchType variableDeclaratorId
	;

catchType
	:	unannClassType ('|' classType)*
	;

finally_
	:	'finally' block
	;

tryWithResourcesStatement
	:	'try' resourceSpecification block catches? finally_?
	;

resourceSpecification
	:	'(' resourceList ';'? ')'
	;

resourceList
	:	resource (';' resource)*
	;

resource
	:	variableModifier* unannType variableDeclaratorId '=' expression
	|	variableAccess//Introduced in Java 9
	;

variableAccess
	:	expressionName
	|	fieldAccess
	;

/*
 * Productions from §15 (Expressions)
 */

/*primary
	:	primaryNoNewArray
	|	arrayCreationExpression
	;
*/

primary
	:	(	primaryNoNewArray_lfno_primary
		|	arrayCreationExpression
		)
		(	primaryNoNewArray_lf_primary
		)*
	;

primaryNoNewArray
	:	literal
	|	classLiteral
	|	'this'
	|	typeName '.' 'this'
	|	'(' expression ')'
	|	classInstanceCreationExpression
	|	fieldAccess
	|	arrayAccess
	|	methodInvocation
	|	methodReference
	;

primaryNoNewArray_lf_arrayAccess
	:
	;

primaryNoNewArray_lfno_arrayAccess
	:	literal
	|	typeName ('[' ']')* '.' 'class'
	|	'void' '.' 'class'
	|	'this'
	|	typeName '.' 'this'
	|	'(' expression ')'
	|	classInstanceCreationExpression
	|	fieldAccess
	|	methodInvocation
	|	methodReference
	;

primaryNoNewArray_lf_primary
	:	classInstanceCreationExpression_lf_primary
	|	fieldAccess_lf_primary
	|	arrayAccess_lf_primary
	|	methodInvocation_lf_primary
	|	methodReference_lf_primary
	;

primaryNoNewArray_lf_primary_lf_arrayAccess_lf_primary
	:
	;

primaryNoNewArray_lf_primary_lfno_arrayAccess_lf_primary
	:	classInstanceCreationExpression_lf_primary
	|	fieldAccess_lf_primary
	|	methodInvocation_lf_primary
	|	methodReference_lf_primary
	;

primaryNoNewArray_lfno_primary
	:	literal
	|	typeName ('[' ']')* '.' 'class'
	|	unannPrimitiveType ('[' ']')* '.' 'class'
	|	'void' '.' 'class'
	|	'this'
	|	typeName '.' 'this'
	|	'(' expression ')'
	|	classInstanceCreationExpression_lfno_primary
	|	fieldAccess_lfno_primary
	|	arrayAccess_lfno_primary
	|	methodInvocation_lfno_primary
	|	methodReference_lfno_primary
	;

primaryNoNewArray_lfno_primary_lf_arrayAccess_lfno_primary
	:
	;

primaryNoNewArray_lfno_primary_lfno_arrayAccess_lfno_primary
	:	literal
	|	typeName ('[' ']')* '.' 'class'
	|	unannPrimitiveType ('[' ']')* '.' 'class'
	|	'void' '.' 'class'
	|	'this'
	|	typeName '.' 'this'
	|	'(' expression ')'
	|	classInstanceCreationExpression_lfno_primary
	|	fieldAccess_lfno_primary
	|	methodInvocation_lfno_primary
	|	methodReference_lfno_primary
	;

classLiteral
	:	(typeName|numericType|'boolean') ('[' ']')* '.' 'class'
	|	'void' '.' 'class'
	;

classInstanceCreationExpression
	:	'new' typeArguments? annotation* identifier ('.' annotation* identifier)* typeArgumentsOrDiamond? '(' argumentList? ')' classBody?
	|	expressionName '.' 'new' typeArguments? annotation* identifier typeArgumentsOrDiamond? '(' argumentList? ')' classBody?
	|	primary '.' 'new' typeArguments? annotation* identifier typeArgumentsOrDiamond? '(' argumentList? ')' classBody?
	;

classInstanceCreationExpression_lf_primary
	:	'.' 'new' typeArguments? annotation* identifier typeArgumentsOrDiamond? '(' argumentList? ')' classBody?
	;

classInstanceCreationExpression_lfno_primary
	:	'new' typeArguments? annotation* identifier ('.' annotation* identifier)* typeArgumentsOrDiamond? '(' argumentList? ')' classBody?
	|	expressionName '.' 'new' typeArguments? annotation* identifier typeArgumentsOrDiamond? '(' argumentList? ')' classBody?
	;

typeArgumentsOrDiamond
	:	typeArguments
	|	'<' '>'
	;

fieldAccess
	:	primary '.' identifier
	|	'super' '.' identifier
	|	typeName '.' 'super' '.' identifier
	;

fieldAccess_lf_primary
	:	'.' identifier
	;

fieldAccess_lfno_primary
	:	'super' '.' identifier
	|	typeName '.' 'super' '.' identifier
	;

/*arrayAccess
	:	expressionName '[' expression ']'
	|	primaryNoNewArray '[' expression ']'
	;
*/

arrayAccess
	:	(	expressionName '[' expression ']'
		|	primaryNoNewArray_lfno_arrayAccess '[' expression ']'
		)
		(	primaryNoNewArray_lf_arrayAccess '[' expression ']'
		)*
	;

arrayAccess_lf_primary
	:	(	primaryNoNewArray_lf_primary_lfno_arrayAccess_lf_primary '[' expression ']'
		)
		(	primaryNoNewArray_lf_primary_lf_arrayAccess_lf_primary '[' expression ']'
		)*
	;

arrayAccess_lfno_primary
	:	(	expressionName '[' expression ']'
		|	primaryNoNewArray_lfno_primary_lfno_arrayAccess_lfno_primary '[' expression ']'
		)
		(	primaryNoNewArray_lfno_primary_lf_arrayAccess_lfno_primary '[' expression ']'
		)*
	;


methodInvocation
	:	methodName '(' argumentList? ')'
	|	typeName '.' typeArguments? identifier '(' argumentList? ')'
	|	expressionName '.' typeArguments? identifier '(' argumentList? ')'
	|	primary '.' typeArguments? identifier '(' argumentList? ')'
	|	'super' '.' typeArguments? identifier '(' argumentList? ')'
	|	typeName '.' 'super' '.' typeArguments? identifier '(' argumentList? ')'
	;

methodInvocation_lf_primary
	:	'.' typeArguments? identifier '(' argumentList? ')'
	;

methodInvocation_lfno_primary
	:	methodName '(' argumentList? ')'
	|	typeName '.' typeArguments? identifier '(' argumentList? ')'
	|	expressionName '.' typeArguments? identifier '(' argumentList? ')'
	|	'super' '.' typeArguments? identifier '(' argumentList? ')'
	|	typeName '.' 'super' '.' typeArguments? identifier '(' argumentList? ')'
	;

argumentList
	:	expression (',' expression)*
	;

methodReference
	:	expressionName '::' typeArguments? identifier
	|	referenceType '::' typeArguments? identifier
	|	primary '::' typeArguments? identifier
	|	'super' '::' typeArguments? identifier
	|	typeName '.' 'super' '::' typeArguments? identifier
	|	classType '::' typeArguments? 'new'
	|	arrayType '::' 'new'
	;

methodReference_lf_primary
	:	'::' typeArguments? identifier
	;

methodReference_lfno_primary
	:	expressionName '::' typeArguments? identifier
	|	referenceType '::' typeArguments? identifier
	|	'super' '::' typeArguments? identifier
	|	typeName '.' 'super' '::' typeArguments? identifier
	|	classType '::' typeArguments? 'new'
	|	arrayType '::' 'new'
	;

arrayCreationExpression
	:	'new' primitiveType dimExprs dims?
	|	'new' classOrInterfaceType dimExprs dims?
	|	'new' primitiveType dims arrayInitializer
	|	'new' classOrInterfaceType dims arrayInitializer
	;

dimExprs
	:	dimExpr+
	;

dimExpr
	:	annotation* '[' expression ']'
	;

constantExpression
	:	expression
	;

expression
	:	lambdaExpression
	|	assignmentExpression
	;

lambdaExpression
	:	lambdaParameters '->' lambdaBody
	;

lambdaParameters
	:	identifier
	|	'(' formalParameterList? ')'
	|	'(' inferredFormalParameterList ')'
	;

inferredFormalParameterList
	:	identifier (',' identifier)*
	;

lambdaBody
	:	expression
	|	block
	;

assignmentExpression
	:	conditionalExpression
	|	assignment
	;

assignment
	:	leftHandSide assignmentOperator expression
	;

leftHandSide
	:	expressionName
	|	fieldAccess
	|	arrayAccess
	;

assignmentOperator
	:	'='
	|	'*='
	|	'/='
	|	'%='
	|	'+='
	|	'-='
	|	'<<='
	|	'>>='
	|	'>>>='
	|	'&='
	|	'^='
	|	'|='
	;

conditionalExpression
	:	conditionalOrExpression
	|	conditionalOrExpression '?' expression ':' (conditionalExpression|lambdaExpression)
	;

conditionalOrExpression
	:	conditionalAndExpression
	|	conditionalOrExpression '||' conditionalAndExpression
	;

conditionalAndExpression
	:	inclusiveOrExpression
	|	conditionalAndExpression '&&' inclusiveOrExpression
	;

inclusiveOrExpression
	:	exclusiveOrExpression
	|	inclusiveOrExpression '|' exclusiveOrExpression
	;

exclusiveOrExpression
	:	andExpression
	|	exclusiveOrExpression '^' andExpression
	;

andExpression
	:	equalityExpression
	|	andExpression '&' equalityExpression
	;

equalityExpression
	:	relationalExpression
	|	equalityExpression '==' relationalExpression
	|	equalityExpression '!=' relationalExpression
	;

relationalExpression
	:	shiftExpression
	|	relationalExpression '<' shiftExpression
	|	relationalExpression '>' shiftExpression
	|	relationalExpression '<=' shiftExpression
	|	relationalExpression '>=' shiftExpression
	|	relationalExpression 'instanceof' referenceType
	;

shiftExpression
	:	additiveExpression
	|	shiftExpression '<' '<' additiveExpression
	|	shiftExpression '>' '>' additiveExpression
	|	shiftExpression '>' '>' '>' additiveExpression
	;

additiveExpression
	:	multiplicativeExpression
	|	additiveExpression '+' multiplicativeExpression
	|	additiveExpression '-' multiplicativeExpression
	;

multiplicativeExpression
	:	unaryExpression
	|	multiplicativeExpression '*' unaryExpression
	|	multiplicativeExpression '/' unaryExpression
	|	multiplicativeExpression '%' unaryExpression
	;

unaryExpression
	:	preIncrementExpression
	|	preDecrementExpression
	|	'+' unaryExpression
	|	'-' unaryExpression
	|	unaryExpressionNotPlusMinus
	;

preIncrementExpression
	:	'++' unaryExpression
	;

preDecrementExpression
	:	'--' unaryExpression
	;

unaryExpressionNotPlusMinus
	:	postfixExpression
	|	'~' unaryExpression
	|	'!' unaryExpression
	|	castExpression
	;

/*postfixExpression
	:	primary
	|	expressionName
	|	postIncrementExpression
	|	postDecrementExpression
	;
*/

postfixExpression
	:	(	primary
		|	expressionName
		)
		(	postIncrementExpression_lf_postfixExpression
		|	postDecrementExpression_lf_postfixExpression
		)*
	;

postIncrementExpression
	:	postfixExpression '++'
	;

postIncrementExpression_lf_postfixExpression
	:	'++'
	;

postDecrementExpression
	:	postfixExpression '--'
	;

postDecrementExpression_lf_postfixExpression
	:	'--'
	;

castExpression
	:	'(' primitiveType ')' unaryExpression
	|	'(' referenceType additionalBound* ')' unaryExpressionNotPlusMinus
	|	'(' referenceType additionalBound* ')' lambdaExpression
	;

/**
 * Droplet modifications for Java 9 to handle EOF
 */
literal_DropletFile
	:	IntegerLiteral EOF
	|	FloatingPointLiteral EOF
	|	BooleanLiteral EOF
	|	CharacterLiteral EOF
	|	StringLiteral EOF
	|	NullLiteral EOF
	;

/*
 * Productions from §4 (Types, Values, and Variables)
 */

primitiveType_DropletFile
	:	annotation* numericType EOF
	|	annotation* 'boolean' EOF
	;

numericType_DropletFile
	:	integralType EOF
	|	floatingPointType EOF
	;

integralType_DropletFile
	:	'byte' EOF
	|	'short' EOF
	|	'int' EOF
	|	'long' EOF
	|	'char' EOF
	;

floatingPointType_DropletFile
	:	'float' EOF
	|	'double' EOF
	;

referenceType_DropletFile
	:	classOrInterfaceType EOF
	|	typeVariable EOF
	|	arrayType EOF
	;

/*classOrInterfaceType_DropletFile
	:	classType EOF
	|	interfaceType EOF
	;
*/
classOrInterfaceType_DropletFile
	:	(	classType_lfno_classOrInterfaceType EOF
		|	interfaceType_lfno_classOrInterfaceType EOF
		)
		(	classType_lf_classOrInterfaceType EOF
		|	interfaceType_lf_classOrInterfaceType EOF
		)*
	;

classType_DropletFile
	:	annotation* identifier typeArguments? EOF
	|	classOrInterfaceType '.' annotation* identifier typeArguments? EOF
	;

classType_lf_classOrInterfaceType_DropletFile
	:	'.' annotation* identifier typeArguments? EOF
	;

classType_lfno_classOrInterfaceType_DropletFile
	:	annotation* identifier typeArguments? EOF
	;

interfaceType_DropletFile
	:	classType EOF
	;

interfaceType_lf_classOrInterfaceType_DropletFile
	:	classType_lf_classOrInterfaceType EOF
	;

interfaceType_lfno_classOrInterfaceType_DropletFile
	:	classType_lfno_classOrInterfaceType EOF
	;

typeVariable_DropletFile
	:	annotation* identifier EOF
	;

arrayType_DropletFile
	:	primitiveType dims EOF
	|	classOrInterfaceType dims EOF
	|	typeVariable dims EOF
	;

dims_DropletFile
	:	annotation* '[' ']' (annotation* '[' ']')* EOF
	;

typeParameter_DropletFile
	:	typeParameterModifier* identifier typeBound?
	;

typeParameterModifier_DropletFile
	:	annotation EOF
	;

typeBound_DropletFile
	:	'extends' typeVariable EOF
	|	'extends' classOrInterfaceType additionalBound* EOF
	;

additionalBound_DropletFile
	:	'&' interfaceType EOF
	;

typeArguments_DropletFile
	:	'<' typeArgumentList '>' EOF
	;

typeArgumentList_DropletFile
	:	typeArgument (',' typeArgument)* EOF
	;

typeArgument_DropletFile
	:	referenceType EOF
	|	wildcard EOF
	;

wildcard_DropletFile
	:	annotation* '?' wildcardBounds? EOF
	;

wildcardBounds_DropletFile
	:	'extends' referenceType EOF
	|	'super' referenceType EOF
	;

/*
 * Productions from §6 (Names)
 */

moduleName_DropletFile
	:	identifier EOF
	|	moduleName '.' identifier EOF
	;

packageName_DropletFile
	:	identifier EOF
	|	packageName '.' identifier EOF
	;

typeName_DropletFile
	:	identifier EOF
	|	packageOrTypeName '.' identifier EOF
	;

packageOrTypeName_DropletFile
	:	identifier EOF
	|	packageOrTypeName '.' identifier EOF
	;

expressionName_DropletFile
	:	identifier EOF
	|	ambiguousName '.' identifier EOF
	;

methodName_DropletFile
	:	identifier EOF
	;

ambiguousName_DropletFile
	:	identifier EOF
	|	ambiguousName '.' identifier EOF
	;

/*
 * Productions from §7 (Packages)
 */

compilationUnit_DropletFile
	:	ordinaryCompilation EOF
	|	modularCompilation EOF
	;

ordinaryCompilation_DropletFile
	:	packageDeclaration? importDeclaration* typeDeclaration* EOF
	;

modularCompilation_DropletFile
	:	importDeclaration* moduleDeclaration EOF
	;

packageDeclaration_DropletFile
	:	packageModifier* 'package' packageName ';' EOF
	;

packageModifier_DropletFile
	:	annotation EOF
	;

importDeclaration_DropletFile
	:	singleTypeImportDeclaration EOF
	|	typeImportOnDemandDeclaration EOF
	|	singleStaticImportDeclaration EOF
	|	staticImportOnDemandDeclaration EOF
	;

singleTypeImportDeclaration_DropletFile
	:	'import' typeName ';' EOF
	;

typeImportOnDemandDeclaration_DropletFile
	:	'import' packageOrTypeName '.' '*' ';' EOF
	;

singleStaticImportDeclaration_DropletFile
	:	'import' 'static' typeName '.' identifier ';' EOF
	;

staticImportOnDemandDeclaration_DropletFile
	:	'import' 'static' typeName '.' '*' ';' EOF
	;

typeDeclaration_DropletFile
	:	classDeclaration EOF
	|	interfaceDeclaration EOF
	|	';' EOF
	;

moduleDeclaration_DropletFile
	:	annotation* 'open'? 'module' moduleName '{' moduleDirective* '}' EOF
	;

moduleDirective_DropletFile
	:	'requires' requiresModifier* moduleName ';' EOF
	|	'exports' packageName ('to' moduleName (',' moduleName)*)? ';' EOF
	|	'opens' packageName ('to' moduleName (',' moduleName)*)? ';' EOF
	|	'uses' typeName ';' EOF
	|	'provides' typeName 'with' typeName (',' typeName)* ';' EOF
	;

requiresModifier_DropletFile
	:	'transitive' EOF
	|	'static' EOF
	;

/*
 * Productions from §8 (Classes)
 */

classDeclaration_DropletFile
	:	normalClassDeclaration EOF
	|	enumDeclaration EOF
	;

normalClassDeclaration_DropletFile
	:	classModifier* 'class' identifier typeParameters? superclass? superinterfaces? classBody EOF
	;

classModifier_DropletFile
	:	annotation EOF
	|	'public' EOF
	|	'protected' EOF
	|	'private' EOF
	|	'abstract' EOF
	|	'static' EOF
	|	'final' EOF
	|	'strictfp' EOF
	;

typeParameters_DropletFile
	:	'<' typeParameterList '>' EOF
	;

typeParameterList_DropletFile
	:	typeParameter (',' typeParameter)* EOF
	;

superclass_DropletFile
	:	'extends' classType EOF
	;

superinterfaces_DropletFile
	:	'implements' interfaceTypeList EOF
	;

interfaceTypeList_DropletFile
	:	interfaceType (',' interfaceType)* EOF
	;

classBody_DropletFile
	:	'{' classBodyDeclaration* '}' EOF
	;

classBodyDeclaration_DropletFile
	:	classMemberDeclaration EOF
	|	instanceInitializer EOF
	|	staticInitializer EOF
	|	constructorDeclaration EOF
	;

classMemberDeclaration_DropletFile
	:	fieldDeclaration EOF
	|	methodDeclaration EOF
	|	classDeclaration EOF
	|	interfaceDeclaration EOF
	|	';' EOF
	;

fieldDeclaration_DropletFile
	:	fieldModifier* unannType variableDeclaratorList ';' EOF
	;

fieldModifier_DropletFile
	:	annotation EOF
	|	'public' EOF
	|	'protected' EOF
	|	'private' EOF
	|	'static' EOF
	|	'final' EOF
	|	'transient' EOF
	|	'volatile' EOF
	;

variableDeclaratorList_DropletFile
	:	variableDeclarator (',' variableDeclarator)* EOF
	;

variableDeclarator_DropletFile
	:	variableDeclaratorId ('=' variableInitializer)? EOF
	;

variableDeclaratorId_DropletFile
	:	identifier dims? EOF
	;

variableInitializer_DropletFile
	:	expression EOF
	|	arrayInitializer EOF
	;

unannType_DropletFile
	:	unannPrimitiveType EOF
	|	unannReferenceType EOF
	;

unannPrimitiveType_DropletFile
	:	numericType EOF
	|	'boolean' EOF
	;

unannReferenceType_DropletFile
	:	unannClassOrInterfaceType EOF
	|	unannTypeVariable EOF
	|	unannArrayType EOF
	;

/*unannClassOrInterfaceType_DropletFile
	:	unannClassType EOF
	|	unannInterfaceType EOF
	;
*/

unannClassOrInterfaceType_DropletFile
	:	(	unannClassType_lfno_unannClassOrInterfaceType EOF
		|	unannInterfaceType_lfno_unannClassOrInterfaceType EOF
		)
		(	unannClassType_lf_unannClassOrInterfaceType EOF
		|	unannInterfaceType_lf_unannClassOrInterfaceType EOF
		)*
	;

unannClassType_DropletFile
	:	identifier typeArguments? EOF
	|	unannClassOrInterfaceType '.' annotation* identifier typeArguments? EOF
	;

unannClassType_lf_unannClassOrInterfaceType_DropletFile
	:	'.' annotation* identifier typeArguments? EOF
	;

unannClassType_lfno_unannClassOrInterfaceType_DropletFile
	:	identifier typeArguments? EOF
	;

unannInterfaceType_DropletFile
	:	unannClassType EOF
	;

unannInterfaceType_lf_unannClassOrInterfaceType_DropletFile
	:	unannClassType_lf_unannClassOrInterfaceType EOF
	;

unannInterfaceType_lfno_unannClassOrInterfaceType_DropletFile
	:	unannClassType_lfno_unannClassOrInterfaceType EOF
	;

unannTypeVariable_DropletFile
	:	identifier EOF
	;

unannArrayType_DropletFile
	:	unannPrimitiveType dims EOF
	|	unannClassOrInterfaceType dims EOF
	|	unannTypeVariable dims EOF
	;

methodDeclaration_DropletFile
	:	methodModifier* methodHeader methodBody EOF
	;

methodModifier_DropletFile
	:	annotation EOF
	|	'public' EOF
	|	'protected' EOF
	|	'private' EOF
	|	'abstract' EOF
	|	'static' EOF
	|	'final' EOF
	|	'synchronized' EOF
	|	'native' EOF
	|	'strictfp' EOF
	;

methodHeader_DropletFile
	:	result methodDeclarator throws_? EOF
	|	typeParameters annotation* result methodDeclarator throws_? EOF
	;

result_DropletFile
	:	unannType EOF
	|	'void' EOF
	;

methodDeclarator_DropletFile
	:	identifier '(' formalParameterList? ')' dims? EOF
	;

formalParameterList_DropletFile
	:	formalParameters ',' lastFormalParameter EOF
	|	lastFormalParameter EOF
	|	receiverParameter EOF
	;

formalParameters_DropletFile
	:	formalParameter (',' formalParameter)* EOF
	|	receiverParameter (',' formalParameter)* EOF
	;

formalParameter_DropletFile
	:	variableModifier* unannType variableDeclaratorId EOF
	;

variableModifier_DropletFile
	:	annotation EOF
	|	'final' EOF
	;

lastFormalParameter_DropletFile
	:	variableModifier* unannType annotation* '...' variableDeclaratorId EOF
	|	formalParameter EOF
	;

receiverParameter_DropletFile
	:	annotation* unannType (identifier '.')? 'this' EOF
	;

throws__DropletFile
	:	'throws' exceptionTypeList EOF
	;

exceptionTypeList_DropletFile
	:	exceptionType (',' exceptionType)* EOF
	;

exceptionType_DropletFile
	:	classType EOF
	|	typeVariable EOF
	;

methodBody_DropletFile
	:	block EOF
	|	';' EOF
	;

instanceInitializer_DropletFile
	:	block EOF
	;

staticInitializer_DropletFile
	:	'static' block EOF
	;

constructorDeclaration_DropletFile
	:	constructorModifier* constructorDeclarator throws_? constructorBody EOF
	;

constructorModifier_DropletFile
	:	annotation EOF
	|	'public' EOF
	|	'protected' EOF
	|	'private' EOF
	;

constructorDeclarator_DropletFile
	:	typeParameters? simpleTypeName '(' formalParameterList? ')' EOF
	;

simpleTypeName_DropletFile
	:	identifier EOF
	;

constructorBody_DropletFile
	:	'{' explicitConstructorInvocation? blockStatements? '}' EOF
	;

explicitConstructorInvocation_DropletFile
	:	typeArguments? 'this' '(' argumentList? ')' ';' EOF
	|	typeArguments? 'super' '(' argumentList? ')' ';' EOF
	|	expressionName '.' typeArguments? 'super' '(' argumentList? ')' ';' EOF
	|	primary '.' typeArguments? 'super' '(' argumentList? ')' ';' EOF
	;

enumDeclaration_DropletFile
	:	classModifier* 'enum' identifier superinterfaces? enumBody EOF
	;

enumBody_DropletFile
	:	'{' enumConstantList? ','? enumBodyDeclarations? '}' EOF
	;

enumConstantList_DropletFile
	:	enumConstant (',' enumConstant)* EOF
	;

enumConstant_DropletFile
	:	enumConstantModifier* identifier ('(' argumentList? ')')? classBody? EOF
	;

enumConstantModifier_DropletFile
	:	annotation EOF
	;

enumBodyDeclarations_DropletFile
	:	';' classBodyDeclaration* EOF
	;

/*
 * Productions from §9 (Interfaces)
 */

interfaceDeclaration_DropletFile
	:	normalInterfaceDeclaration EOF
	|	annotationTypeDeclaration EOF
	;

normalInterfaceDeclaration_DropletFile
	:	interfaceModifier* 'interface' identifier typeParameters? extendsInterfaces? interfaceBody EOF
	;

interfaceModifier_DropletFile
	:	annotation EOF
	|	'public' EOF
	|	'protected' EOF
	|	'private' EOF
	|	'abstract' EOF
	|	'static' EOF
	|	'strictfp' EOF
	;

extendsInterfaces_DropletFile
	:	'extends' interfaceTypeList EOF
	;

interfaceBody_DropletFile
	:	'{' interfaceMemberDeclaration* '}' EOF
	;

interfaceMemberDeclaration_DropletFile
	:	constantDeclaration EOF
	|	interfaceMethodDeclaration EOF
	|	classDeclaration EOF
	|	interfaceDeclaration EOF
	|	';' EOF
	;

constantDeclaration_DropletFile
	:	constantModifier* unannType variableDeclaratorList ';' EOF
	;

constantModifier_DropletFile
	:	annotation EOF
	|	'public' EOF
	|	'static' EOF
	|	'final' EOF
	;

interfaceMethodDeclaration_DropletFile
	:	interfaceMethodModifier* methodHeader methodBody EOF
	;

interfaceMethodModifier_DropletFile
	:	annotation EOF
	|	'public' EOF
	|	'private' EOF //Introduced in Java 9
	|	'abstract' EOF
	|	'default' EOF
	|	'static' EOF
	|	'strictfp' EOF
	;

annotationTypeDeclaration_DropletFile
	:	interfaceModifier* '@' 'interface' identifier annotationTypeBody EOF
	;

annotationTypeBody_DropletFile
	:	'{' annotationTypeMemberDeclaration* '}' EOF
	;

annotationTypeMemberDeclaration_DropletFile
	:	annotationTypeElementDeclaration EOF
	|	constantDeclaration EOF
	|	classDeclaration EOF
	|	interfaceDeclaration EOF
	|	';' EOF
	;

annotationTypeElementDeclaration_DropletFile
	:	annotationTypeElementModifier* unannType identifier '(' ')' dims? defaultValue? ';' EOF
	;

annotationTypeElementModifier_DropletFile
	:	annotation EOF
	|	'public' EOF
	|	'abstract' EOF
	;

defaultValue_DropletFile
	:	'default' elementValue EOF
	;

annotation_DropletFile
	:	normalAnnotation EOF
	|	markerAnnotation EOF
	|	singleElementAnnotation EOF
	;

normalAnnotation_DropletFile
	:	'@' typeName '(' elementValuePairList? ')' EOF
	;

elementValuePairList_DropletFile
	:	elementValuePair (',' elementValuePair)* EOF
	;

elementValuePair_DropletFile
	:	identifier '=' elementValue EOF
	;

elementValue_DropletFile
	:	conditionalExpression EOF
	|	elementValueArrayInitializer EOF
	|	annotation EOF
	;

elementValueArrayInitializer_DropletFile
	:	'{' elementValueList? ','? '}' EOF
	;

elementValueList_DropletFile
	:	elementValue (',' elementValue)* EOF
	;

markerAnnotation_DropletFile
	:	'@' typeName EOF
	;

singleElementAnnotation_DropletFile
	:	'@' typeName '(' elementValue ')' EOF
	;

/*
 * Productions from §10 (Arrays)
 */

arrayInitializer_DropletFile
	:	'{' variableInitializerList? ','? '}' EOF
	;

variableInitializerList_DropletFile
	:	variableInitializer (',' variableInitializer)* EOF
	;

/*
 * Productions from §14 (Blocks and Statements)
 */

block_DropletFile
	:	'{' blockStatements? '}' EOF
	;

blockStatements_DropletFile
	:	blockStatement+ EOF
	;

blockStatement_DropletFile
	:	localVariableDeclarationStatement EOF
	|	classDeclaration EOF
	|	statement EOF
	;

localVariableDeclarationStatement_DropletFile
	:	localVariableDeclaration ';' EOF
	;

localVariableDeclaration_DropletFile
	:	variableModifier* unannType variableDeclaratorList EOF
	;

statement_DropletFile
	:	statementWithoutTrailingSubstatement EOF
	|	labeledStatement EOF
	|	ifThenStatement EOF
	|	ifThenElseStatement EOF
	|	whileStatement EOF
	|	forStatement EOF
	;

statementNoShortIf_DropletFile
	:	statementWithoutTrailingSubstatement EOF
	|	labeledStatementNoShortIf EOF
	|	ifThenElseStatementNoShortIf EOF
	|	whileStatementNoShortIf EOF
	|	forStatementNoShortIf EOF
	;

statementWithoutTrailingSubstatement_DropletFile
	:	block EOF
	|	emptyStatement EOF
	|	expressionStatement EOF
	|	assertStatement EOF
	|	switchStatement EOF
	|	doStatement EOF
	|	breakStatement EOF
	|	continueStatement EOF
	|	returnStatement EOF
	|	synchronizedStatement EOF
	|	throwStatement EOF
	|	tryStatement EOF
	;

emptyStatement_DropletFile
	:	';' EOF
	;

labeledStatement_DropletFile
	:	identifier ':' statement EOF
	;

labeledStatementNoShortIf_DropletFile
	:	identifier ':' statementNoShortIf EOF
	;

expressionStatement_DropletFile
	:	statementExpression ';' EOF
	;

statementExpression_DropletFile
	:	assignment EOF
	|	preIncrementExpression EOF
	|	preDecrementExpression EOF
	|	postIncrementExpression EOF
	|	postDecrementExpression EOF
	|	methodInvocation EOF
	|	classInstanceCreationExpression EOF
	;

ifThenStatement_DropletFile
	:	'if' '(' expression ')' statement EOF
	;

ifThenElseStatement_DropletFile
	:	'if' '(' expression ')' statementNoShortIf 'else' statement EOF
	;

ifThenElseStatementNoShortIf_DropletFile
	:	'if' '(' expression ')' statementNoShortIf 'else' statementNoShortIf EOF
	;

assertStatement_DropletFile
	:	'assert' expression ';' EOF
	|	'assert' expression ':' expression ';' EOF
	;

switchStatement_DropletFile
	:	'switch' '(' expression ')' switchBlock EOF
	;

switchBlock_DropletFile
	:	'{' switchBlockStatementGroup* switchLabel* '}' EOF
	;

switchBlockStatementGroup_DropletFile
	:	switchLabels blockStatements EOF
	;

switchLabels_DropletFile
	:	switchLabel+ EOF
	;

switchLabel_DropletFile
	:	'case' constantExpression ':' EOF
	|	'case' enumConstantName ':' EOF
	|	'default' ':' EOF
	;

enumConstantName_DropletFile
	:	identifier EOF
	;

whileStatement_DropletFile
	:	'while' '(' expression ')' statement EOF
	;

whileStatementNoShortIf_DropletFile
	:	'while' '(' expression ')' statementNoShortIf EOF
	;

doStatement_DropletFile
	:	'do' statement 'while' '(' expression ')' ';' EOF
	;

forStatement_DropletFile
	:	basicForStatement EOF
	|	enhancedForStatement EOF
	;

forStatementNoShortIf_DropletFile
	:	basicForStatementNoShortIf EOF
	|	enhancedForStatementNoShortIf EOF
	;

basicForStatement_DropletFile
	:	'for' '(' forInit? ';' expression? ';' forUpdate? ')' statement EOF
	;

basicForStatementNoShortIf_DropletFile
	:	'for' '(' forInit? ';' expression? ';' forUpdate? ')' statementNoShortIf EOF
	;

forInit_DropletFile
	:	statementExpressionList EOF
	|	localVariableDeclaration EOF
	;

forUpdate_DropletFile
	:	statementExpressionList EOF
	;

statementExpressionList_DropletFile
	:	statementExpression (',' statementExpression)* EOF
	;

enhancedForStatement_DropletFile
	:	'for' '(' variableModifier* unannType variableDeclaratorId ':' expression ')' statement EOF
	;

enhancedForStatementNoShortIf_DropletFile
	:	'for' '(' variableModifier* unannType variableDeclaratorId ':' expression ')' statementNoShortIf
	;

breakStatement_DropletFile
	:	'break' identifier? ';' EOF
	;

continueStatement_DropletFile
	:	'continue' identifier? ';' EOF
	;

returnStatement_DropletFile
	:	'return' expression? ';' EOF
	;

throwStatement_DropletFile
	:	'throw' expression ';' EOF
	;

synchronizedStatement_DropletFile
	:	'synchronized' '(' expression ')' block EOF
	;

tryStatement_DropletFile
	:	'try' block catches EOF
	|	'try' block catches? finally_ EOF
	|	tryWithResourcesStatement EOF
	;

catches_DropletFile
	:	catchClause+ EOF
	;

catchClause_DropletFile
	:	'catch' '(' catchFormalParameter ')' block EOF
	;

catchFormalParameter_DropletFile
	:	variableModifier* catchType variableDeclaratorId EOF
	;

catchType_DropletFile
	:	unannClassType ('|' classType)* EOF
	;

finally__DropletFile
	:	'finally' block EOF
	;

tryWithResourcesStatement_DropletFile
	:	'try' resourceSpecification block catches? finally_? EOF
	;

resourceSpecification_DropletFile
	:	'(' resourceList ';'? ')' EOF
	;

resourceList_DropletFile
	:	resource (';' resource)* EOF
	;

resource_DropletFile
	:	variableModifier* unannType variableDeclaratorId '=' expression EOF
	|	variableAccess  EOF //Introduced in Java 9
	;

variableAccess_DropletFile
	:	expressionName EOF
	|	fieldAccess EOF
	;

/*
 * Productions from §15 (Expressions)
 */

/*primary_DropletFile
	:	primaryNoNewArray EOF
	|	arrayCreationExpression EOF
	;
*/

primary_DropletFile
	:	(	primaryNoNewArray_lfno_primary EOF
		|	arrayCreationExpression EOF
		)
		(	primaryNoNewArray_lf_primary EOF
		)*
	;

primaryNoNewArray_DropletFile
	:	literal EOF
	|	classLiteral EOF
	|	'this' EOF
	|	typeName '.' 'this' EOF
	|	'(' expression ')' EOF
	|	classInstanceCreationExpression EOF
	|	fieldAccess EOF
	|	arrayAccess EOF
	|	methodInvocation EOF
	|	methodReference EOF
	;

primaryNoNewArray_lf_arrayAccess_DropletFile
	:
	;

primaryNoNewArray_lfno_arrayAccess_DropletFile
	:	literal EOF
	|	typeName ('[' ']')* '.' 'class' EOF
	|	'void' '.' 'class' EOF
	|	'this'
	|	typeName '.' 'this' EOF
	|	'(' expression ')' EOF
	|	classInstanceCreationExpression EOF
	|	fieldAccess EOF
	|	methodInvocation EOF
	|	methodReference EOF
	;

primaryNoNewArray_lf_primary_DropletFile
	:	classInstanceCreationExpression_lf_primary EOF
	|	fieldAccess_lf_primary EOF
	|	arrayAccess_lf_primary EOF
	|	methodInvocation_lf_primary EOF
	|	methodReference_lf_primary EOF
	;

primaryNoNewArray_lf_primary_lf_arrayAccess_lf_primary_DropletFile
	:
	;

primaryNoNewArray_lf_primary_lfno_arrayAccess_lf_primary_DropletFile
	:	classInstanceCreationExpression_lf_primary EOF
	|	fieldAccess_lf_primary EOF
	|	methodInvocation_lf_primary EOF
	|	methodReference_lf_primary EOF
	;

primaryNoNewArray_lfno_primary_DropletFile
	:	literal EOF
	|	typeName ('[' ']')* '.' 'class' EOF
	|	unannPrimitiveType ('[' ']')* '.' 'class' EOF
	|	'void' '.' 'class' EOF
	|	'this' EOF
	|	typeName '.' 'this' EOF
	|	'(' expression ')' EOF
	|	classInstanceCreationExpression_lfno_primary EOF
	|	fieldAccess_lfno_primary EOF
	|	arrayAccess_lfno_primary EOF
	|	methodInvocation_lfno_primary EOF
	|	methodReference_lfno_primary EOF
	;

primaryNoNewArray_lfno_primary_lf_arrayAccess_lfno_primary_DropletFile
	:
	;

primaryNoNewArray_lfno_primary_lfno_arrayAccess_lfno_primary_DropletFile
	:	literal EOF
	|	typeName ('[' ']')* '.' 'class' EOF
	|	unannPrimitiveType ('[' ']')* '.' 'class' EOF
	|	'void' '.' 'class' EOF
	|	'this' EOF
	|	typeName '.' 'this' EOF
	|	'(' expression ')' EOF
	|	classInstanceCreationExpression_lfno_primary EOF
	|	fieldAccess_lfno_primary EOF
	|	methodInvocation_lfno_primary EOF
	|	methodReference_lfno_primary EOF
	;

classLiteral_DropletFile
	:	(typeName|numericType|'boolean') ('[' ']')* '.' 'class' EOF
	|	'void' '.' 'class' EOF
	;

classInstanceCreationExpression_DropletFile
	:	'new' typeArguments? annotation* identifier ('.' annotation* identifier)* typeArgumentsOrDiamond? '(' argumentList? ')' classBody? EOF
	|	expressionName '.' 'new' typeArguments? annotation* identifier typeArgumentsOrDiamond? '(' argumentList? ')' classBody? EOF
	|	primary '.' 'new' typeArguments? annotation* identifier typeArgumentsOrDiamond? '(' argumentList? ')' classBody? EOF
	;

classInstanceCreationExpression_lf_primary_DropletFile
	:	'.' 'new' typeArguments? annotation* identifier typeArgumentsOrDiamond? '(' argumentList? ')' classBody? EOF
	;

classInstanceCreationExpression_lfno_primary_DropletFile
	:	'new' typeArguments? annotation* identifier ('.' annotation* identifier)* typeArgumentsOrDiamond? '(' argumentList? ')' classBody? EOF
	|	expressionName '.' 'new' typeArguments? annotation* identifier typeArgumentsOrDiamond? '(' argumentList? ')' classBody? EOF
	;

typeArgumentsOrDiamond_DropletFile
	:	typeArguments EOF
	|	'<' '>' EOF
	;

fieldAccess_DropletFile
	:	primary '.' identifier EOF
	|	'super' '.' identifier EOF
	|	typeName '.' 'super' '.' identifier EOF
	;

fieldAccess_lf_primary_DropletFile
	:	'.' identifier EOF
	;

fieldAccess_lfno_primary_DropletFile
	:	'super' '.' identifier EOF
	|	typeName '.' 'super' '.' identifier EOF
	;

/*arrayAccess_DropletFile
	:	expressionName '[' expression ']' EOF
	|	primaryNoNewArray '[' expression ']' EOF
	;
*/

arrayAccess_DropletFile
	:	(	expressionName '[' expression ']' EOF
		|	primaryNoNewArray_lfno_arrayAccess '[' expression ']' EOF
		)
		(	primaryNoNewArray_lf_arrayAccess '[' expression ']' EOF
		)*
	;

arrayAccess_lf_primary_DropletFile
	:	(	primaryNoNewArray_lf_primary_lfno_arrayAccess_lf_primary '[' expression ']' EOF
		)
		(	primaryNoNewArray_lf_primary_lf_arrayAccess_lf_primary '[' expression ']' EOF
		)*
	;

arrayAccess_lfno_primary_DropletFile
	:	(	expressionName '[' expression ']' EOF
		|	primaryNoNewArray_lfno_primary_lfno_arrayAccess_lfno_primary '[' expression ']' EOF
		)
		(	primaryNoNewArray_lfno_primary_lf_arrayAccess_lfno_primary '[' expression ']' EOF
		)*
	;


methodInvocation_DropletFile
	:	methodName '(' argumentList? ')' EOF
	|	typeName '.' typeArguments? identifier '(' argumentList? ')' EOF
	|	expressionName '.' typeArguments? identifier '(' argumentList? ')' EOF
	|	primary '.' typeArguments? identifier '(' argumentList? ')' EOF
	|	'super' '.' typeArguments? identifier '(' argumentList? ')' EOF
	|	typeName '.' 'super' '.' typeArguments? identifier '(' argumentList? ')' EOF
	;

methodInvocation_lf_primary_DropletFile
	:	'.' typeArguments? identifier '(' argumentList? ')' EOF
	;

methodInvocation_lfno_primary_DropletFile
	:	methodName '(' argumentList? ')' EOF
	|	typeName '.' typeArguments? identifier '(' argumentList? ')' EOF
	|	expressionName '.' typeArguments? identifier '(' argumentList? ')' EOF
	|	'super' '.' typeArguments? identifier '(' argumentList? ')' EOF
	|	typeName '.' 'super' '.' typeArguments? identifier '(' argumentList? ')' EOF
	;

argumentList_DropletFile
	:	expression (',' expression)* EOF
	;

methodReference_DropletFile
	:	expressionName '::' typeArguments? identifier EOF
	|	referenceType '::' typeArguments? identifier EOF
	|	primary '::' typeArguments? identifier EOF
	|	'super' '::' typeArguments? identifier EOF
	|	typeName '.' 'super' '::' typeArguments? identifier EOF
	|	classType '::' typeArguments? 'new' EOF
	|	arrayType '::' 'new' EOF
	;

methodReference_lf_primary_DropletFile
	:	'::' typeArguments? identifier EOF
	;

methodReference_lfno_primary_DropletFile
	:	expressionName '::' typeArguments? identifier EOF
	|	referenceType '::' typeArguments? identifier EOF
	|	'super' '::' typeArguments? identifier EOF
	|	typeName '.' 'super' '::' typeArguments? identifier EOF
	|	classType '::' typeArguments? 'new' EOF
	|	arrayType '::' 'new' EOF
	;

arrayCreationExpression_DropletFile
	:	'new' primitiveType dimExprs dims? EOF
	|	'new' classOrInterfaceType dimExprs dims? EOF
	|	'new' primitiveType dims arrayInitializer EOF
	|	'new' classOrInterfaceType dims arrayInitializer EOF
	;

dimExprs_DropletFile
	:	dimExpr+ EOF
	;

dimExpr_DropletFile
	:	annotation* '[' expression ']' EOF
	;

constantExpression_DropletFile
	:	expression EOF
	;

expression_DropletFile
	:	lambdaExpression EOF
	|	assignmentExpression EOF
	;

lambdaExpression_DropletFile
	:	lambdaParameters '->' lambdaBody EOF
	;

lambdaParameters_DropletFile
	:	identifier EOF
	|	'(' formalParameterList? ')' EOF
	|	'(' inferredFormalParameterList ')' EOF
	;

inferredFormalParameterList_DropletFile
	:	identifier (',' identifier)* EOF
	;

lambdaBody_DropletFile
	:	expression EOF
	|	block EOF
	;

assignmentExpression_DropletFile
	:	conditionalExpression EOF
	|	assignment EOF
	;

assignment_DropletFile
	:	leftHandSide assignmentOperator expression EOF
	;

leftHandSide_DropletFile
	:	expressionName EOF
	|	fieldAccess EOF
	|	arrayAccess EOF
	;

assignmentOperator_DropletFile
	:	'=' EOF
	|	'*=' EOF
	|	'/=' EOF
	|	'%=' EOF
	|	'+=' EOF
	|	'-=' EOF
	|	'<<=' EOF
	|	'>>=' EOF
	|	'>>>=' EOF
	|	'&=' EOF
	|	'^=' EOF
	|	'|=' EOF
	;

conditionalExpression_DropletFile
	:	conditionalOrExpression EOF
	|	conditionalOrExpression '?' expression ':' (conditionalExpression|lambdaExpression) EOF
	;

conditionalOrExpression_DropletFile
	:	conditionalAndExpression EOF
	|	conditionalOrExpression '||' conditionalAndExpression EOF
	;

conditionalAndExpression_DropletFile
	:	inclusiveOrExpression EOF
	|	conditionalAndExpression '&&' inclusiveOrExpression EOF
	;

inclusiveOrExpression_DropletFile
	:	exclusiveOrExpression EOF
	|	inclusiveOrExpression '|' exclusiveOrExpression EOF
	;

exclusiveOrExpression_DropletFile
	:	andExpression EOF
	|	exclusiveOrExpression '^' andExpression EOF
	;

andExpression_DropletFile
	:	equalityExpression EOF
	|	andExpression '&' equalityExpression EOF
	;

equalityExpression_DropletFile
	:	relationalExpression EOF
	|	equalityExpression '==' relationalExpression EOF
	|	equalityExpression '!=' relationalExpression EOF
	;

relationalExpression_DropletFile
	:	shiftExpression EOF
	|	relationalExpression '<' shiftExpression EOF
	|	relationalExpression '>' shiftExpression EOF
	|	relationalExpression '<=' shiftExpression EOF
	|	relationalExpression '>=' shiftExpression EOF
	|	relationalExpression 'instanceof' referenceType EOF
	;

shiftExpression_DropletFile
	:	additiveExpression EOF
	|	shiftExpression '<' '<' additiveExpression EOF
	|	shiftExpression '>' '>' additiveExpression EOF
	|	shiftExpression '>' '>' '>' additiveExpression EOF
	;

additiveExpression_DropletFile
	:	multiplicativeExpression EOF
	|	additiveExpression '+' multiplicativeExpression EOF
	|	additiveExpression '-' multiplicativeExpression EOF
	;

multiplicativeExpression_DropletFile
	:	unaryExpression EOF
	|	multiplicativeExpression '*' unaryExpression EOF
	|	multiplicativeExpression '/' unaryExpression EOF
	|	multiplicativeExpression '%' unaryExpression EOF
	;

unaryExpression_DropletFile
	:	preIncrementExpression EOF
	|	preDecrementExpression EOF
	|	'+' unaryExpression EOF
	|	'-' unaryExpression EOF
	|	unaryExpressionNotPlusMinus EOF
	;

preIncrementExpression_DropletFile
	:	'++' unaryExpression EOF
	;

preDecrementExpression_DropletFile
	:	'--' unaryExpression EOF
	;

unaryExpressionNotPlusMinus_DropletFile
	:	postfixExpression EOF
	|	'~' unaryExpression EOF
	|	'!' unaryExpression EOF
	|	castExpression EOF
	;

/*postfixExpression_DropletFile
	:	primary EOF
	|	expressionName EOF
	|	postIncrementExpression EOF
	|	postDecrementExpression EOF
	;
*/

postfixExpression_DropletFile
	:	(	primary EOF
		|	expressionName EOF
		)
		(	postIncrementExpression_lf_postfixExpression EOF
		|	postDecrementExpression_lf_postfixExpression EOF
		)*
	;

postIncrementExpression_DropletFile
	:	postfixExpression '++' EOF
	;

postIncrementExpression_lf_postfixExpression_DropletFile
	:	'++' EOF
	;

postDecrementExpression_DropletFile
	:	postfixExpression '--' EOF
	;

postDecrementExpression_lf_postfixExpression_DropletFile
	:	'--' EOF
	;

castExpression_DropletFile
	:	'(' primitiveType ')' unaryExpression EOF
	|	'(' referenceType additionalBound* ')' unaryExpressionNotPlusMinus EOF
	|	'(' referenceType additionalBound* ')' lambdaExpression EOF
	;

// LEXER

identifier : Identifier | 'to' | 'module' | 'open' | 'with';

// §3.9 Keywords

ABSTRACT : 'abstract';
ASSERT : 'assert';
BOOLEAN : 'boolean';
BREAK : 'break';
BYTE : 'byte';
CASE : 'case';
CATCH : 'catch';
CHAR : 'char';
CLASS : 'class';
CONST : 'const';
CONTINUE : 'continue';
DEFAULT : 'default';
DO : 'do';
DOUBLE : 'double';
ELSE : 'else';
ENUM : 'enum';
EXTENDS : 'extends';
FINAL : 'final';
FINALLY : 'finally';
FLOAT : 'float';
FOR : 'for';
IF : 'if';
GOTO : 'goto';
IMPLEMENTS : 'implements';
IMPORT : 'import';
INSTANCEOF : 'instanceof';
INT : 'int';
INTERFACE : 'interface';
LONG : 'long';
NATIVE : 'native';
NEW : 'new';
PACKAGE : 'package';
PRIVATE : 'private';
PROTECTED : 'protected';
PUBLIC : 'public';
RETURN : 'return';
SHORT : 'short';
STATIC : 'static';
STRICTFP : 'strictfp';
SUPER : 'super';
SWITCH : 'switch';
SYNCHRONIZED : 'synchronized';
THIS : 'this';
THROW : 'throw';
THROWS : 'throws';
TRANSIENT : 'transient';
TRY : 'try';
VOID : 'void';
VOLATILE : 'volatile';
WHILE : 'while';
UNDER_SCORE : '_';//Introduced in Java 9

// §3.10.1 Integer Literals

IntegerLiteral
	:	DecimalIntegerLiteral
	|	HexIntegerLiteral
	|	OctalIntegerLiteral
	|	BinaryIntegerLiteral
	;

fragment
DecimalIntegerLiteral
	:	DecimalNumeral IntegerTypeSuffix?
	;

fragment
HexIntegerLiteral
	:	HexNumeral IntegerTypeSuffix?
	;

fragment
OctalIntegerLiteral
	:	OctalNumeral IntegerTypeSuffix?
	;

fragment
BinaryIntegerLiteral
	:	BinaryNumeral IntegerTypeSuffix?
	;

fragment
IntegerTypeSuffix
	:	[lL]
	;

fragment
DecimalNumeral
	:	'0'
	|	NonZeroDigit (Digits? | Underscores Digits)
	;

fragment
Digits
	:	Digit (DigitsAndUnderscores? Digit)?
	;

fragment
Digit
	:	'0'
	|	NonZeroDigit
	;

fragment
NonZeroDigit
	:	[1-9]
	;

fragment
DigitsAndUnderscores
	:	DigitOrUnderscore+
	;

fragment
DigitOrUnderscore
	:	Digit
	|	'_'
	;

fragment
Underscores
	:	'_'+
	;

fragment
HexNumeral
	:	'0' [xX] HexDigits
	;

fragment
HexDigits
	:	HexDigit (HexDigitsAndUnderscores? HexDigit)?
	;

fragment
HexDigit
	:	[0-9a-fA-F]
	;

fragment
HexDigitsAndUnderscores
	:	HexDigitOrUnderscore+
	;

fragment
HexDigitOrUnderscore
	:	HexDigit
	|	'_'
	;

fragment
OctalNumeral
	:	'0' Underscores? OctalDigits
	;

fragment
OctalDigits
	:	OctalDigit (OctalDigitsAndUnderscores? OctalDigit)?
	;

fragment
OctalDigit
	:	[0-7]
	;

fragment
OctalDigitsAndUnderscores
	:	OctalDigitOrUnderscore+
	;

fragment
OctalDigitOrUnderscore
	:	OctalDigit
	|	'_'
	;

fragment
BinaryNumeral
	:	'0' [bB] BinaryDigits
	;

fragment
BinaryDigits
	:	BinaryDigit (BinaryDigitsAndUnderscores? BinaryDigit)?
	;

fragment
BinaryDigit
	:	[01]
	;

fragment
BinaryDigitsAndUnderscores
	:	BinaryDigitOrUnderscore+
	;

fragment
BinaryDigitOrUnderscore
	:	BinaryDigit
	|	'_'
	;

// §3.10.2 Floating-Point Literals

FloatingPointLiteral
	:	DecimalFloatingPointLiteral
	|	HexadecimalFloatingPointLiteral
	;

fragment
DecimalFloatingPointLiteral
	:	Digits '.' Digits? ExponentPart? FloatTypeSuffix?
	|	'.' Digits ExponentPart? FloatTypeSuffix?
	|	Digits ExponentPart FloatTypeSuffix?
	|	Digits FloatTypeSuffix
	;

fragment
ExponentPart
	:	ExponentIndicator SignedInteger
	;

fragment
ExponentIndicator
	:	[eE]
	;

fragment
SignedInteger
	:	Sign? Digits
	;

fragment
Sign
	:	[+-]
	;

fragment
FloatTypeSuffix
	:	[fFdD]
	;

fragment
HexadecimalFloatingPointLiteral
	:	HexSignificand BinaryExponent FloatTypeSuffix?
	;

fragment
HexSignificand
	:	HexNumeral '.'?
	|	'0' [xX] HexDigits? '.' HexDigits
	;

fragment
BinaryExponent
	:	BinaryExponentIndicator SignedInteger
	;

fragment
BinaryExponentIndicator
	:	[pP]
	;

// §3.10.3 Boolean Literals

BooleanLiteral
	:	'true'
	|	'false'
	;

// §3.10.4 Character Literals

CharacterLiteral
	:	'\'' SingleCharacter '\''
	|	'\'' EscapeSequence '\''
	;

fragment
SingleCharacter
	:	~['\\\r\n]
	;

// §3.10.5 String Literals

StringLiteral
	:	'"' StringCharacters? '"'
	;

fragment
StringCharacters
	:	StringCharacter+
	;

fragment
StringCharacter
	:	~["\\\r\n]
	|	EscapeSequence
	;

// §3.10.6 Escape Sequences for Character and String Literals

fragment
EscapeSequence
	:	'\\' [btnfr"'\\]
	|	OctalEscape
    |   UnicodeEscape // This is not in the spec but prevents having to preprocess the input
	;

fragment
OctalEscape
	:	'\\' OctalDigit
	|	'\\' OctalDigit OctalDigit
	|	'\\' ZeroToThree OctalDigit OctalDigit
	;

fragment
ZeroToThree
	:	[0-3]
	;

// This is not in the spec but prevents having to preprocess the input
fragment
UnicodeEscape
    :   '\\' 'u'+ HexDigit HexDigit HexDigit HexDigit
    ;

// §3.10.7 The Null Literal

NullLiteral
	:	'null'
	;

// §3.11 Separators

LPAREN : '(';
RPAREN : ')';
LBRACE : '{';
RBRACE : '}';
LBRACK : '[';
RBRACK : ']';
SEMI : ';';
COMMA : ',';
DOT : '.';
ELLIPSIS : '...';
AT : '@';
COLONCOLON : '::';


// §3.12 Operators

ASSIGN : '=';
GT : '>';
LT : '<';
BANG : '!';
TILDE : '~';
QUESTION : '?';
COLON : ':';
ARROW : '->';
EQUAL : '==';
LE : '<=';
GE : '>=';
NOTEQUAL : '!=';
AND : '&&';
OR : '||';
INC : '++';
DEC : '--';
ADD : '+';
SUB : '-';
MUL : '*';
DIV : '/';
BITAND : '&';
BITOR : '|';
CARET : '^';
MOD : '%';
//LSHIFT : '<<';
//RSHIFT : '>>';
//URSHIFT : '>>>';

ADD_ASSIGN : '+=';
SUB_ASSIGN : '-=';
MUL_ASSIGN : '*=';
DIV_ASSIGN : '/=';
AND_ASSIGN : '&=';
OR_ASSIGN : '|=';
XOR_ASSIGN : '^=';
MOD_ASSIGN : '%=';
LSHIFT_ASSIGN : '<<=';
RSHIFT_ASSIGN : '>>=';
URSHIFT_ASSIGN : '>>>=';

// §3.8 Identifiers (must appear after all keywords in the grammar)

Identifier
	:	JavaLetter JavaLetterOrDigit*
	;

fragment
JavaLetter
	:	[a-zA-Z$_] // these are the "java letters" below 0x7F
	|	// covers all characters above 0x7F which are not a surrogate
		~[\u0000-\u007F\uD800-\uDBFF]
//		{Character.isJavaIdentifierStart(_input.LA(-1))}?
	|	// covers UTF-16 surrogate pairs encodings for U+10000 to U+10FFFF
		[\uD800-\uDBFF] [\uDC00-\uDFFF]
//		{Character.isJavaIdentifierStart(Character.toCodePoint((char)_input.LA(-2), (char)_input.LA(-1)))}?
	;

fragment
JavaLetterOrDigit
	:	[a-zA-Z0-9$_] // these are the "java letters or digits" below 0x7F
	|	// covers all characters above 0x7F which are not a surrogate
		~[\u0000-\u007F\uD800-\uDBFF]
//		{Character.isJavaIdentifierPart(_input.LA(-1))}?
	|	// covers UTF-16 surrogate pairs encodings for U+10000 to U+10FFFF
		[\uD800-\uDBFF] [\uDC00-\uDFFF]
//		{Character.isJavaIdentifierPart(Character.toCodePoint((char)_input.LA(-2), (char)_input.LA(-1)))}?
	;

//
// Whitespace and comments
//

WS  :  [ \t\r\n\u000C]+ -> skip
    ;

COMMENT
    :   '/*' .*? '*/' -> channel(HIDDEN)
    ;

LINE_COMMENT
    :   '//' ~[\r\n]* -> channel(HIDDEN)
    ;
