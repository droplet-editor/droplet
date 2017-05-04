/*******************************************************************************
 * The MIT License (MIT)
 * 
 * Copyright (c) 2015 Camilo Sanchez (Camiloasc1)
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 ******************************************************************************/

/*******************************************************************************
 * C++14 Grammar for ANTLR v4
 *
 * Based on n4140 draft paper
 * https://github.com/cplusplus/draft/blob/master/papers/n4140.pdf
 * and
 * http://www.nongnu.org/hcb/
 * 
 * Possible Issues:
 * 
 * Input must avoid conditional compilation blocks (this grammar ignores any preprocessor directive)
 * GCC extensions not yet supported (do not try to parse the preprocessor output)
 * Right angle bracket (C++11) - Solution '>>' and '>>=' are not tokens, only '>'
 * Lexer issue with pure-specifier rule ('0' token) - Solution in embedded code
 *   Change it to match the target language you want in line 1097 or verify inside your listeners/visitors
 *   Java:
if($val.text.compareTo("0")!=0) throw new InputMismatchException(this);
 *   JavaScript:
 *   Python2:
 *   Python3:
 *   C#:
 ******************************************************************************/
grammar CPP14;

/*Basic concepts*/
translationunit
:
	declarationseq? EOF
;

/*Expressions*/
primaryexpression
:
	literal
	| This
	| '(' expression ')'
	| idexpression
	| lambdaexpression
;

idexpression
:
	unqualifiedid
	| qualifiedid
;

unqualifiedid
:
	Identifier
	| operatorfunctionid
	| conversionfunctionid
	| literaloperatorid
	| '~' classname
	| '~' decltypespecifier
	| templateid
;

qualifiedid
:
	nestednamespecifier Template? unqualifiedid
;

nestednamespecifier
:
	'::'
	| typename '::'
	| namespacename '::'
	| decltypespecifier '::'
	| nestednamespecifier Identifier '::'
	| nestednamespecifier Template? simpletemplateid '::'
;

lambdaexpression
:
	lambdaintroducer lambdadeclarator? compoundstatement
;

lambdaintroducer
:
	'[' lambdacapture? ']'
;

lambdacapture
:
	capturedefault
	| capturelist
	| capturedefault ',' capturelist
;

capturedefault
:
	'&'
	| '='
;

capturelist
:
	capture '...'?
	| capturelist ',' capture '...'?
;

capture
:
	simplecapture
	| initcapture
;

simplecapture
:
	Identifier
	| '&' Identifier
	| This
;

initcapture
:
	Identifier initializer
	| '&' Identifier initializer
;

lambdadeclarator
:
	'(' parameterdeclarationclause ')' Mutable? exceptionspecification?
	attributespecifierseq? trailingreturntype?
;

postfixexpression
:
	primaryexpression
	| postfixexpression '[' expression ']'
	| postfixexpression '[' bracedinitlist ']'
	| postfixexpression '(' expressionlist? ')'
	| simpletypespecifier '(' expressionlist? ')'
	| typenamespecifier '(' expressionlist? ')'
	| simpletypespecifier bracedinitlist
	| typenamespecifier bracedinitlist
	| postfixexpression '.' Template? idexpression
	| postfixexpression '->' Template? idexpression
	| postfixexpression '.' pseudodestructorname
	| postfixexpression '->' pseudodestructorname
	| postfixexpression '++'
	| postfixexpression '--'
	| Dynamic_cast '<' typeid '>' '(' expression ')'
	| Static_cast '<' typeid '>' '(' expression ')'
	| Reinterpret_cast '<' typeid '>' '(' expression ')'
	| Const_cast '<' typeid '>' '(' expression ')'
	| Typeid '(' expression ')'
	| Typeid '(' typeid ')'
;

expressionlist
:
	initializerlist
;

pseudodestructorname
:
	nestednamespecifier? typename '::' '~' typename
	| nestednamespecifier Template simpletemplateid '::' '~' typename
	| nestednamespecifier? '~' typename
	| '~' decltypespecifier
;

unaryexpression
:
	postfixexpression
	| '++' castexpression
	| '--' castexpression
	| unaryoperator castexpression
	| Sizeof unaryexpression
	| Sizeof '(' typeid ')'
	| Sizeof '...' '(' Identifier ')'
	| Alignof '(' typeid ')'
	| noexceptexpression
	| newexpression
	| deleteexpression
;

unaryoperator
:
	'|'
	| '*'
	| '&'
	| '+'
	| '!'
	| '~'
	| '-'
;

newexpression
:
	'::'? New newplacement? newtypeid newinitializer?
	| '::'? New newplacement? '(' typeid ')' newinitializer?
;

newplacement
:
	'(' expressionlist ')'
;

newtypeid
:
	typespecifierseq newdeclarator?
;

newdeclarator
:
	ptroperator newdeclarator?
	| noptrnewdeclarator
;

noptrnewdeclarator
:
	'[' expression ']' attributespecifierseq?
	| noptrnewdeclarator '[' constantexpression ']' attributespecifierseq?
;

newinitializer
:
	'(' expressionlist? ')'
	| bracedinitlist
;

deleteexpression
:
	'::'? Delete castexpression
	| '::'? Delete '[' ']' castexpression
;

noexceptexpression
:
	Noexcept '(' expression ')'
;

castexpression
:
	unaryexpression
	| '(' typeid ')' castexpression
;

pmexpression
:
	castexpression
	| pmexpression '.*' castexpression
	| pmexpression '->*' castexpression
;

multiplicativeexpression
:
	pmexpression
	| multiplicativeexpression '*' pmexpression
	| multiplicativeexpression '/' pmexpression
	| multiplicativeexpression '%' pmexpression
;

additiveexpression
:
	multiplicativeexpression
	| additiveexpression '+' multiplicativeexpression
	| additiveexpression '-' multiplicativeexpression
;

shiftexpression
:
	additiveexpression
	| shiftexpression '<<' additiveexpression
	| shiftexpression rightShift additiveexpression
;

relationalexpression
:
	shiftexpression
	| relationalexpression '<' shiftexpression
	| relationalexpression '>' shiftexpression
	| relationalexpression '<=' shiftexpression
	| relationalexpression '>=' shiftexpression
;

equalityexpression
:
	relationalexpression
	| equalityexpression '==' relationalexpression
	| equalityexpression '!=' relationalexpression
;

andexpression
:
	equalityexpression
	| andexpression '&' equalityexpression
;

exclusiveorexpression
:
	andexpression
	| exclusiveorexpression '^' andexpression
;

inclusiveorexpression
:
	exclusiveorexpression
	| inclusiveorexpression '|' exclusiveorexpression
;

logicalandexpression
:
	inclusiveorexpression
	| logicalandexpression '&&' inclusiveorexpression
;

logicalorexpression
:
	logicalandexpression
	| logicalorexpression '||' logicalandexpression
;

conditionalexpression
:
	logicalorexpression
	| logicalorexpression '?' expression ':' assignmentexpression
;

assignmentexpression
:
	conditionalexpression
	| logicalorexpression assignmentoperator initializerclause
	| throwexpression
;

assignmentoperator
:
	'='
	| '*='
	| '/='
	| '%='
	| '+='
	| '-='
	| rightShiftAssign
	| '<<='
	| '&='
	| '^='
	| '|='
;

expression
:
	assignmentexpression
	| expression ',' assignmentexpression
;

constantexpression
:
	conditionalexpression
;
/*Statements*/
statement
:
	labeledstatement
	| attributespecifierseq? expressionstatement
	| attributespecifierseq? compoundstatement
	| attributespecifierseq? selectionstatement
	| attributespecifierseq? iterationstatement
	| attributespecifierseq? jumpstatement
	| declarationstatement
	| attributespecifierseq? tryblock
;

labeledstatement
:
	attributespecifierseq? Identifier ':' statement
	| attributespecifierseq? Case constantexpression ':' statement
	| attributespecifierseq? Default ':' statement
;

expressionstatement
:
	expression? ';'
;

compoundstatement
:
	'{' statementseq? '}'
;

statementseq
:
	statement
	| statementseq statement
;

selectionstatement
:
	If '(' condition ')' statement
	| If '(' condition ')' statement Else statement
	| Switch '(' condition ')' statement
;

condition
:
	expression
	| attributespecifierseq? declspecifierseq declarator '=' initializerclause
	| attributespecifierseq? declspecifierseq declarator bracedinitlist
;

iterationstatement
:
	While '(' condition ')' statement
	| Do statement While '(' expression ')' ';'
	| For '(' forinitstatement condition? ';' expression? ')' statement
	| For '(' forrangedeclaration ':' forrangeinitializer ')' statement
;

forinitstatement
:
	expressionstatement
	| simpledeclaration
;

forrangedeclaration
:
	attributespecifierseq? declspecifierseq declarator
;

forrangeinitializer
:
	expression
	| bracedinitlist
;

jumpstatement
:
	Break ';'
	| Continue ';'
	| Return expression? ';'
	| Return bracedinitlist ';'
	| Goto Identifier ';'
;

declarationstatement
:
	blockdeclaration
;

/*Declarations*/
declarationseq
:
	declaration
	| declarationseq declaration
;

declaration
:
	blockdeclaration
	| functiondefinition
	| templatedeclaration
	| explicitinstantiation
	| explicitspecialization
	| linkagespecification
	| namespacedefinition
	| emptydeclaration
	| attributedeclaration
;

blockdeclaration
:
	simpledeclaration
	| asmdefinition
	| namespacealiasdefinition
	| usingdeclaration
	| usingdirective
	| static_assertdeclaration
	| aliasdeclaration
	| opaqueenumdeclaration
;

aliasdeclaration
:
	Using Identifier attributespecifierseq? '=' typeid ';'
;

simpledeclaration
:
	declspecifierseq? initdeclaratorlist? ';'
	| attributespecifierseq declspecifierseq? initdeclaratorlist ';'
;

static_assertdeclaration
:
	Static_assert '(' constantexpression ',' Stringliteral ')' ';'
;

emptydeclaration
:
	';'
;

attributedeclaration
:
	attributespecifierseq ';'
;

declspecifier
:
	storageclassspecifier
	| typespecifier
	| functionspecifier
	| Friend
	| Typedef
	| Constexpr
;

declspecifierseq
:
	declspecifier attributespecifierseq?
	| declspecifier declspecifierseq
;

storageclassspecifier
:
	Register
	| Static
	| Thread_local
	| Extern
	| Mutable
;

functionspecifier
:
	Inline
	| Virtual
	| Explicit
;

typedefname
:
	Identifier
;

typespecifier
:
	trailingtypespecifier
	| classspecifier
	| enumspecifier
;

trailingtypespecifier
:
	simpletypespecifier
	| elaboratedtypespecifier
	| typenamespecifier
	| cvqualifier
;

typespecifierseq
:
	typespecifier attributespecifierseq?
	| typespecifier typespecifierseq
;

trailingtypespecifierseq
:
	trailingtypespecifier attributespecifierseq?
	| trailingtypespecifier trailingtypespecifierseq
;

simpletypespecifier
:
	nestednamespecifier? typename
	| nestednamespecifier Template simpletemplateid
	| Char
	| Char16
	| Char32
	| Wchar
	| Bool
	| Short
	| Int
	| Long
	| Signed
	| Unsigned
	| Float
	| Double
	| Void
	| Auto
	| decltypespecifier
;

typename
:
	classname
	| enumname
	| typedefname
	| simpletemplateid
;

decltypespecifier
:
	Decltype '(' expression ')'
	| Decltype '(' Auto ')'
;

elaboratedtypespecifier
:
	classkey attributespecifierseq? nestednamespecifier? Identifier
	| classkey simpletemplateid
	| classkey nestednamespecifier Template? simpletemplateid
	| Enum nestednamespecifier? Identifier
;

enumname
:
	Identifier
;

enumspecifier
:
	enumhead '{' enumeratorlist? '}'
	| enumhead '{' enumeratorlist ',' '}'
;

enumhead
:
	enumkey attributespecifierseq? Identifier? enumbase?
	| enumkey attributespecifierseq? nestednamespecifier Identifier enumbase?
;

opaqueenumdeclaration
:
	enumkey attributespecifierseq? Identifier enumbase? ';'
;

enumkey
:
	Enum
	| Enum Class
	| Enum Struct
;

enumbase
:
	':' typespecifierseq
;

enumeratorlist
:
	enumeratordefinition
	| enumeratorlist ',' enumeratordefinition
;

enumeratordefinition
:
	enumerator
	| enumerator '=' constantexpression
;

enumerator
:
	Identifier
;

namespacename
:
	originalnamespacename
	| namespacealias
;

originalnamespacename
:
	Identifier
;

namespacedefinition
:
	namednamespacedefinition
	| unnamednamespacedefinition
;

namednamespacedefinition
:
	originalnamespacedefinition
	| extensionnamespacedefinition
;

originalnamespacedefinition
:
	Inline? Namespace Identifier '{' namespacebody '}'
;

extensionnamespacedefinition
:
	Inline? Namespace originalnamespacename '{' namespacebody '}'
;

unnamednamespacedefinition
:
	Inline? Namespace '{' namespacebody '}'
;

namespacebody
:
	declarationseq?
;

namespacealias
:
	Identifier
;

namespacealiasdefinition
:
	Namespace Identifier '=' qualifiednamespacespecifier ';'
;

qualifiednamespacespecifier
:
	nestednamespecifier? namespacename
;

usingdeclaration
:
	Using Typename? nestednamespecifier unqualifiedid ';'
	| Using '::' unqualifiedid ';'
;

usingdirective
:
	attributespecifierseq? Using Namespace nestednamespecifier? namespacename ';'
;

asmdefinition
:
	Asm '(' Stringliteral ')' ';'
;

linkagespecification
:
	Extern Stringliteral '{' declarationseq? '}'
	| Extern Stringliteral declaration
;

attributespecifierseq
:
	attributespecifier
	| attributespecifierseq attributespecifier
;

attributespecifier
:
	'[' '[' attributelist ']' ']'
	| alignmentspecifier
;

alignmentspecifier
:
	Alignas '(' typeid '...'? ')'
	| Alignas '(' constantexpression '...'? ')'
;

attributelist
:
	attribute?
	| attributelist ',' attribute?
	| attribute '...'
	| attributelist ',' attribute '...'
;

attribute
:
	attributetoken attributeargumentclause?
;

attributetoken
:
	Identifier
	| attributescopedtoken
;

attributescopedtoken
:
	attributenamespace '::' Identifier
;

attributenamespace
:
	Identifier
;

attributeargumentclause
:
	'(' balancedtokenseq ')'
;

balancedtokenseq
:
	balancedtoken?
	| balancedtokenseq balancedtoken
;

balancedtoken
:
	'(' balancedtokenseq ')'
	| '[' balancedtokenseq ']'
	| '{' balancedtokenseq '}'
	/*any token other than a parenthesis , a bracket , or a brace*/
;

/*Declarators*/
initdeclaratorlist
:
	initdeclarator
	| initdeclaratorlist ',' initdeclarator
;

initdeclarator
:
	declarator initializer?
;

declarator
:
	ptrdeclarator
	| noptrdeclarator parametersandqualifiers trailingreturntype
;

ptrdeclarator
:
	noptrdeclarator
	| ptroperator ptrdeclarator
;

noptrdeclarator
:
	declaratorid attributespecifierseq?
	| noptrdeclarator parametersandqualifiers
	| noptrdeclarator '[' constantexpression? ']' attributespecifierseq?
	| '(' ptrdeclarator ')'
;

parametersandqualifiers
:
	'(' parameterdeclarationclause ')' cvqualifierseq? refqualifier?
	exceptionspecification? attributespecifierseq?
;

trailingreturntype
:
	'->' trailingtypespecifierseq abstractdeclarator?
;

ptroperator
:
	'*' attributespecifierseq? cvqualifierseq?
	| '&' attributespecifierseq?
	| '&&' attributespecifierseq?
	| nestednamespecifier '*' attributespecifierseq? cvqualifierseq?
;

cvqualifierseq
:
	cvqualifier cvqualifierseq?
;

cvqualifier
:
	Const
	| Volatile
;

refqualifier
:
	'&'
	| '&&'
;

declaratorid
:
	'...'? idexpression
;

typeid
:
	typespecifierseq abstractdeclarator?
;

abstractdeclarator
:
	ptrabstractdeclarator
	| noptrabstractdeclarator? parametersandqualifiers trailingreturntype
	| abstractpackdeclarator
;

ptrabstractdeclarator
:
	noptrabstractdeclarator
	| ptroperator ptrabstractdeclarator?
;

noptrabstractdeclarator
:
	noptrabstractdeclarator parametersandqualifiers
	| parametersandqualifiers
	| noptrabstractdeclarator '[' constantexpression? ']' attributespecifierseq?
	| '[' constantexpression? ']' attributespecifierseq?
	| '(' ptrabstractdeclarator ')'
;

abstractpackdeclarator
:
	noptrabstractpackdeclarator
	| ptroperator abstractpackdeclarator
;

noptrabstractpackdeclarator
:
	noptrabstractpackdeclarator parametersandqualifiers
	| noptrabstractpackdeclarator '[' constantexpression? ']'
	attributespecifierseq?
	| '...'
;

parameterdeclarationclause
:
	parameterdeclarationlist? '...'?
	| parameterdeclarationlist ',' '...'
;

parameterdeclarationlist
:
	parameterdeclaration
	| parameterdeclarationlist ',' parameterdeclaration
;

parameterdeclaration
:
	attributespecifierseq? declspecifierseq declarator
	| attributespecifierseq? declspecifierseq declarator '=' initializerclause
	| attributespecifierseq? declspecifierseq abstractdeclarator?
	| attributespecifierseq? declspecifierseq abstractdeclarator? '='
	initializerclause
;

functiondefinition
:
	attributespecifierseq? declspecifierseq? declarator virtspecifierseq?
	functionbody
;

functionbody
:
	ctorinitializer? compoundstatement
	| functiontryblock
	| '=' Default ';'
	| '=' Delete ';'
;

initializer
:
	braceorequalinitializer
	| '(' expressionlist ')'
;

braceorequalinitializer
:
	'=' initializerclause
	| bracedinitlist
;

initializerclause
:
	assignmentexpression
	| bracedinitlist
;

initializerlist
:
	initializerclause '...'?
	| initializerlist ',' initializerclause '...'?
;

bracedinitlist
:
	'{' initializerlist ','? '}'
	| '{' '}'
;

/*Classes*/
classname
:
	Identifier
	| simpletemplateid
;

classspecifier
:
	classhead '{' memberspecification? '}'
;

classhead
:
	classkey attributespecifierseq? classheadname classvirtspecifier? baseclause?
	| classkey attributespecifierseq? baseclause?
;

classheadname
:
	nestednamespecifier? classname
;

classvirtspecifier
:
	Final
;

classkey
:
	Class
	| Struct
	| Union
;

memberspecification
:
	memberdeclaration memberspecification?
	| accessspecifier ':' memberspecification?
;

memberdeclaration
:
	attributespecifierseq? declspecifierseq? memberdeclaratorlist? ';'
	| functiondefinition
	| usingdeclaration
	| static_assertdeclaration
	| templatedeclaration
	| aliasdeclaration
	| emptydeclaration
;

memberdeclaratorlist
:
	memberdeclarator
	| memberdeclaratorlist ',' memberdeclarator
;

memberdeclarator
:
	declarator virtspecifierseq? purespecifier?
	| declarator braceorequalinitializer?
	| Identifier? attributespecifierseq? ':' constantexpression
;

virtspecifierseq
:
	virtspecifier
	| virtspecifierseq virtspecifier
;

virtspecifier
:
	Override
	| Final
;

/*
purespecifier:
	'=' '0'//Conflicts with the lexer
 ;
 */
purespecifier
:
	Assign val = Octalliteral
	{if($val.text.compareTo("0")!=0) throw new InputMismatchException(this);}

;

/*Derived classes*/
baseclause
:
	':' basespecifierlist
;

basespecifierlist
:
	basespecifier '...'?
	| basespecifierlist ',' basespecifier '...'?
;

basespecifier
:
	attributespecifierseq? basetypespecifier
	| attributespecifierseq? Virtual accessspecifier? basetypespecifier
	| attributespecifierseq? accessspecifier Virtual? basetypespecifier
;

classordecltype
:
	nestednamespecifier? classname
	| decltypespecifier
;

basetypespecifier
:
	classordecltype
;

accessspecifier
:
	Private
	| Protected
	| Public
;

/*Special member functions*/
conversionfunctionid
:
	Operator conversiontypeid
;

conversiontypeid
:
	typespecifierseq conversiondeclarator?
;

conversiondeclarator
:
	ptroperator conversiondeclarator?
;

ctorinitializer
:
	':' meminitializerlist
;

meminitializerlist
:
	meminitializer '...'?
	| meminitializer '...'? ',' meminitializerlist
;

meminitializer
:
	meminitializerid '(' expressionlist? ')'
	| meminitializerid bracedinitlist
;

meminitializerid
:
	classordecltype
	| Identifier
;

/*Overloading*/
operatorfunctionid
:
	Operator operator
;

literaloperatorid
:
	Operator Stringliteral Identifier
	| Operator Userdefinedstringliteral
;

/*Templates*/
templatedeclaration
:
	Template '<' templateparameterlist '>' declaration
;

templateparameterlist
:
	templateparameter
	| templateparameterlist ',' templateparameter
;

templateparameter
:
	typeparameter
	| parameterdeclaration
;

typeparameter
:
	Class '...'? Identifier?
	| Class Identifier? '=' typeid
	| Typename '...'? Identifier?
	| Typename Identifier? '=' typeid
	| Template '<' templateparameterlist '>' Class '...'? Identifier?
	| Template '<' templateparameterlist '>' Class Identifier? '=' idexpression
;

simpletemplateid
:
	templatename '<' templateargumentlist? '>'
;

templateid
:
	simpletemplateid
	| operatorfunctionid '<' templateargumentlist? '>'
	| literaloperatorid '<' templateargumentlist? '>'
;

templatename
:
	Identifier
;

templateargumentlist
:
	templateargument '...'?
	| templateargumentlist ',' templateargument '...'?
;

templateargument
:
	typeid
	| constantexpression
	| idexpression
;

typenamespecifier
:
	Typename nestednamespecifier Identifier
	| Typename nestednamespecifier Template? simpletemplateid
;

explicitinstantiation
:
	Extern? Template declaration
;

explicitspecialization
:
	Template '<' '>' declaration
;

/*Exception handling*/
tryblock
:
	Try compoundstatement handlerseq
;

functiontryblock
:
	Try ctorinitializer? compoundstatement handlerseq
;

handlerseq
:
	handler handlerseq?
;

handler
:
	Catch '(' exceptiondeclaration ')' compoundstatement
;

exceptiondeclaration
:
	attributespecifierseq? typespecifierseq declarator
	| attributespecifierseq? typespecifierseq abstractdeclarator?
	| '...'
;

throwexpression
:
	Throw assignmentexpression?
;

exceptionspecification
:
	dynamicexceptionspecification
	| noexceptspecification
;

dynamicexceptionspecification
:
	Throw '(' typeidlist? ')'
;

typeidlist
:
	typeid '...'?
	| typeidlist ',' typeid '...'?
;

noexceptspecification
:
	Noexcept '(' constantexpression ')'
	| Noexcept
;

/* Droplet: ANTLR has trouble parsing a string when a rule doesn't
   contain an EOF token at the end of it. To do live reparsing, we
   have to define new duplicate rules for each intermediate node plus EOF
   so that we can parse small parts of the program independently.
  */
  primaryexpression_DropletFile
:
    literal EOF 
    | This EOF 
    | '(' expression ')' EOF 
    | idexpression EOF 
    | lambdaexpression EOF 
;

idexpression_DropletFile
:
    unqualifiedid EOF 
    | qualifiedid EOF 
;

unqualifiedid_DropletFile
:
    Identifier EOF 
    | operatorfunctionid EOF 
    | conversionfunctionid EOF 
    | literaloperatorid EOF 
    | '~' classname EOF 
    | '~' decltypespecifier EOF 
    | templateid EOF 
;

qualifiedid_DropletFile
:
    nestednamespecifier Template? unqualifiedid EOF 
;

nestednamespecifier_DropletFile
:
    '::' EOF 
    | typename '::' EOF 
    | namespacename '::' EOF 
    | decltypespecifier '::' EOF 
    | nestednamespecifier Identifier '::' EOF 
    | nestednamespecifier Template? simpletemplateid '::' EOF 
;

lambdaexpression_DropletFile
:
    lambdaintroducer lambdadeclarator? compoundstatement EOF 
;

lambdaintroducer_DropletFile
:
    '[' lambdacapture? ']' EOF 
;

lambdacapture_DropletFile
:
    capturedefault EOF 
    | capturelist EOF 
    | capturedefault ',' capturelist EOF 
;

capturedefault_DropletFile
:
    '&' EOF 
    | '=' EOF 
;

capturelist_DropletFile
:
    capture '...'? EOF 
    | capturelist ',' capture '...'? EOF 
;

capture_DropletFile
:
    simplecapture EOF 
    | initcapture EOF 
;

simplecapture_DropletFile
:
    Identifier EOF 
    | '&' Identifier EOF 
    | This EOF 
;

initcapture_DropletFile
:
    Identifier initializer EOF 
    | '&' Identifier initializer EOF 
;

lambdadeclarator_DropletFile
:
    '(' parameterdeclarationclause ')' Mutable? exceptionspecification? EOF 
    attributespecifierseq? trailingreturntype? EOF
;

postfixexpression_DropletFile
:
    primaryexpression EOF 
    | postfixexpression '[' expression ']' EOF 
    | postfixexpression '[' bracedinitlist ']' EOF 
    | postfixexpression '(' expressionlist? ')' EOF 
    | simpletypespecifier '(' expressionlist? ')' EOF 
    | typenamespecifier '(' expressionlist? ')' EOF 
    | simpletypespecifier bracedinitlist EOF 
    | typenamespecifier bracedinitlist EOF 
    | postfixexpression '.' Template? idexpression EOF 
    | postfixexpression '->' Template? idexpression EOF 
    | postfixexpression '.' pseudodestructorname EOF 
    | postfixexpression '->' pseudodestructorname EOF 
    | postfixexpression '++' EOF 
    | postfixexpression '--' EOF 
    | Dynamic_cast '<' typeid '>' '(' expression ')' EOF 
    | Static_cast '<' typeid '>' '(' expression ')' EOF 
    | Reinterpret_cast '<' typeid '>' '(' expression ')' EOF 
    | Const_cast '<' typeid '>' '(' expression ')' EOF 
    | Typeid '(' expression ')' EOF 
    | Typeid '(' typeid ')' EOF 
;

expressionlist_DropletFile
:
    initializerlist EOF 
;

pseudodestructorname_DropletFile
:
    nestednamespecifier? typename '::' '~' typename EOF 
    | nestednamespecifier Template simpletemplateid '::' '~' typename EOF 
    | nestednamespecifier? '~' typename EOF 
    | '~' decltypespecifier EOF 
;

unaryexpression_DropletFile
:
    postfixexpression EOF 
    | '++' castexpression EOF 
    | '--' castexpression EOF 
    | unaryoperator castexpression EOF 
    | Sizeof unaryexpression EOF 
    | Sizeof '(' typeid ')' EOF 
    | Sizeof '...' '(' Identifier ')' EOF 
    | Alignof '(' typeid ')' EOF 
    | noexceptexpression EOF 
    | newexpression EOF 
    | deleteexpression EOF 
;

unaryoperator_DropletFile
:
    '|' EOF 
    | '*' EOF 
    | '&' EOF 
    | '+' EOF 
    | '!' EOF 
    | '~' EOF 
    | '-' EOF 
;

newexpression_DropletFile
:
    '::'? New newplacement? newtypeid newinitializer? EOF 
    | '::'? New newplacement? '(' typeid ')' newinitializer? EOF 
;

newplacement_DropletFile
:
    '(' expressionlist ')' EOF 
;

newtypeid_DropletFile
:
    typespecifierseq newdeclarator? EOF 
;

newdeclarator_DropletFile
:
    ptroperator newdeclarator? EOF 
    | noptrnewdeclarator EOF 
;

noptrnewdeclarator_DropletFile
:
    '[' expression ']' attributespecifierseq? EOF 
    | noptrnewdeclarator '[' constantexpression ']' attributespecifierseq? EOF 
;

newinitializer_DropletFile
:
    '(' expressionlist? ')' EOF 
    | bracedinitlist EOF 
;

deleteexpression_DropletFile
:
    '::'? Delete castexpression EOF 
    | '::'? Delete '[' ']' castexpression EOF 
;

noexceptexpression_DropletFile
:
    Noexcept '(' expression ')' EOF 
;

castexpression_DropletFile
:
    unaryexpression EOF 
    | '(' typeid ')' castexpression EOF 
;

pmexpression_DropletFile
:
    castexpression EOF 
    | pmexpression '.*' castexpression EOF 
    | pmexpression '->*' castexpression EOF 
;

multiplicativeexpression_DropletFile
:
    pmexpression EOF 
    | multiplicativeexpression '*' pmexpression EOF 
    | multiplicativeexpression '/' pmexpression EOF 
    | multiplicativeexpression '%' pmexpression EOF 
;

additiveexpression_DropletFile
:
    multiplicativeexpression EOF 
    | additiveexpression '+' multiplicativeexpression EOF 
    | additiveexpression '-' multiplicativeexpression EOF 
;

shiftexpression_DropletFile
:
    additiveexpression EOF 
    | shiftexpression '<<' additiveexpression EOF 
    | shiftexpression rightShift additiveexpression EOF 
;

relationalexpression_DropletFile
:
    shiftexpression EOF 
    | relationalexpression '<' shiftexpression EOF 
    | relationalexpression '>' shiftexpression EOF 
    | relationalexpression '<=' shiftexpression EOF 
    | relationalexpression '>=' shiftexpression EOF 
;

equalityexpression_DropletFile
:
    relationalexpression EOF 
    | equalityexpression '==' relationalexpression EOF 
    | equalityexpression '!=' relationalexpression EOF 
;

andexpression_DropletFile
:
    equalityexpression EOF 
    | andexpression '&' equalityexpression EOF 
;

exclusiveorexpression_DropletFile
:
    andexpression EOF 
    | exclusiveorexpression '^' andexpression EOF 
;

inclusiveorexpression_DropletFile
:
    exclusiveorexpression EOF 
    | inclusiveorexpression '|' exclusiveorexpression EOF 
;

logicalandexpression_DropletFile
:
    inclusiveorexpression EOF 
    | logicalandexpression '&&' inclusiveorexpression EOF 
;

logicalorexpression_DropletFile
:
    logicalandexpression EOF 
    | logicalorexpression '||' logicalandexpression EOF 
;

conditionalexpression_DropletFile
:
    logicalorexpression EOF 
    | logicalorexpression '?' expression ':' assignmentexpression EOF 
;

assignmentexpression_DropletFile
:
    conditionalexpression EOF 
    | logicalorexpression assignmentoperator initializerclause EOF 
    | throwexpression EOF 
;

assignmentoperator_DropletFile
:
    '=' EOF 
    | '*=' EOF 
    | '/=' EOF 
    | '%=' EOF 
    | '+=' EOF 
    | '-=' EOF 
    | rightShiftAssign EOF 
    | '<<=' EOF 
    | '&=' EOF 
    | '^=' EOF 
    | '|=' EOF 
;

expression_DropletFile
:
    assignmentexpression EOF 
    | expression ',' assignmentexpression EOF 
;

constantexpression_DropletFile
:
    conditionalexpression EOF 
;

/*Statements*/
statement_DropletFile
:
    labeledstatement EOF 
    | attributespecifierseq? expressionstatement EOF 
    | attributespecifierseq? compoundstatement EOF 
    | attributespecifierseq? selectionstatement EOF 
    | attributespecifierseq? iterationstatement EOF 
    | attributespecifierseq? jumpstatement EOF 
    | declarationstatement EOF 
    | attributespecifierseq? tryblock EOF 
;

labeledstatement_DropletFile
:
    attributespecifierseq? Identifier ':' statement EOF 
    | attributespecifierseq? Case constantexpression ':' statement EOF 
    | attributespecifierseq? Default ':' statement EOF 
;

expressionstatement_DropletFile
:
    expression? ';' EOF 
;

compoundstatement_DropletFile
:
    '{' statementseq? '}' EOF 
;

statementseq_DropletFile
:
    statement EOF 
    | statementseq statement EOF 
;

selectionstatement_DropletFile
:
    If '(' condition ')' statement EOF 
    | If '(' condition ')' statement Else statement EOF 
    | Switch '(' condition ')' statement EOF 
;

condition_DropletFile
:
    expression EOF 
    | attributespecifierseq? declspecifierseq declarator '=' initializerclause EOF 
    | attributespecifierseq? declspecifierseq declarator bracedinitlist EOF 
;

iterationstatement_DropletFile
:
    While '(' condition ')' statement EOF 
    | Do statement While '(' expression ')' ';' EOF 
    | For '(' forinitstatement condition? ';' expression? ')' statement EOF 
    | For '(' forrangedeclaration ':' forrangeinitializer ')' statement EOF 
;

forinitstatement_DropletFile
:
    expressionstatement EOF 
    | simpledeclaration EOF 
;

forrangedeclaration_DropletFile
:
    attributespecifierseq? declspecifierseq declarator EOF 
;

forrangeinitializer_DropletFile
:
    expression EOF 
    | bracedinitlist EOF 
;

jumpstatement_DropletFile
:
    Break ';' EOF 
    | Continue ';' EOF 
    | Return expression? ';' EOF 
    | Return bracedinitlist ';' EOF 
    | Goto Identifier ';' EOF 
;

declarationstatement_DropletFile
:
    blockdeclaration EOF 
;

/*Declarations*/
declarationseq_DropletFile
:
    declaration EOF 
    | declarationseq declaration EOF 
;

declaration_DropletFile
:
    blockdeclaration EOF 
    | functiondefinition EOF 
    | templatedeclaration EOF 
    | explicitinstantiation EOF 
    | explicitspecialization EOF 
    | linkagespecification EOF 
    | namespacedefinition EOF 
    | emptydeclaration EOF 
    | attributedeclaration EOF 
;

blockdeclaration_DropletFile
:
    simpledeclaration EOF 
    | asmdefinition EOF 
    | namespacealiasdefinition EOF 
    | usingdeclaration EOF 
    | usingdirective EOF 
    | static_assertdeclaration EOF 
    | aliasdeclaration EOF 
    | opaqueenumdeclaration EOF 
;

aliasdeclaration_DropletFile
:
    Using Identifier attributespecifierseq? '=' typeid ';' EOF 
;

simpledeclaration_DropletFile
:
    declspecifierseq? initdeclaratorlist? ';' EOF 
    | attributespecifierseq declspecifierseq? initdeclaratorlist ';' EOF 
;

static_assertdeclaration_DropletFile
:
    Static_assert '(' constantexpression ',' Stringliteral ')' ';' EOF 
;

emptydeclaration_DropletFile
:
    ';' EOF 
;

attributedeclaration_DropletFile
:
    attributespecifierseq ';' EOF 
;

declspecifier_DropletFile
:
    storageclassspecifier EOF 
    | typespecifier EOF 
    | functionspecifier EOF 
    | Friend EOF 
    | Typedef EOF 
    | Constexpr EOF 
;

declspecifierseq_DropletFile
:
    declspecifier attributespecifierseq? EOF 
    | declspecifier declspecifierseq EOF 
;

storageclassspecifier_DropletFile
:
    Register EOF 
    | Static EOF 
    | Thread_local EOF 
    | Extern EOF 
    | Mutable EOF 
;

functionspecifier_DropletFile
:
    Inline EOF 
    | Virtual EOF 
    | Explicit EOF 
;

typedefname_DropletFile
:
    Identifier EOF 
;

typespecifier_DropletFile
:
    trailingtypespecifier EOF 
    | classspecifier EOF 
    | enumspecifier EOF 
;

trailingtypespecifier_DropletFile
:
    simpletypespecifier EOF 
    | elaboratedtypespecifier EOF 
    | typenamespecifier EOF 
    | cvqualifier EOF 
;

typespecifierseq_DropletFile
:
    typespecifier attributespecifierseq? EOF 
    | typespecifier typespecifierseq EOF 
;

trailingtypespecifierseq_DropletFile
:
    trailingtypespecifier attributespecifierseq? EOF 
    | trailingtypespecifier trailingtypespecifierseq EOF 
;

simpletypespecifier_DropletFile
:
    nestednamespecifier? typename EOF 
    | nestednamespecifier Template simpletemplateid EOF 
    | Char EOF 
    | Char16 EOF 
    | Char32 EOF 
    | Wchar EOF 
    | Bool EOF 
    | Short EOF 
    | Int EOF 
    | Long EOF 
    | Signed EOF 
    | Unsigned EOF 
    | Float EOF 
    | Double EOF 
    | Void EOF 
    | Auto EOF 
    | decltypespecifier EOF 
;

typename_DropletFile
:
    classname EOF 
    | enumname EOF 
    | typedefname EOF 
    | simpletemplateid EOF 
;

decltypespecifier_DropletFile
:
    Decltype '(' expression ')' EOF 
    | Decltype '(' Auto ')' EOF 
;

elaboratedtypespecifier_DropletFile
:
    classkey attributespecifierseq? nestednamespecifier? Identifier EOF 
    | classkey simpletemplateid EOF 
    | classkey nestednamespecifier Template? simpletemplateid EOF 
    | Enum nestednamespecifier? Identifier EOF 
;

enumname_DropletFile
:
    Identifier EOF 
;

enumspecifier_DropletFile
:
    enumhead '{' enumeratorlist? '}' EOF 
    | enumhead '{' enumeratorlist ',' '}' EOF 
;

enumhead_DropletFile
:
    enumkey attributespecifierseq? Identifier? enumbase? EOF 
    | enumkey attributespecifierseq? nestednamespecifier Identifier enumbase? EOF 
;

opaqueenumdeclaration_DropletFile
:
    enumkey attributespecifierseq? Identifier enumbase? ';' EOF 
;

enumkey_DropletFile
:
    Enum EOF 
    | Enum Class EOF 
    | Enum Struct EOF 
;

enumbase_DropletFile
:
    ':' typespecifierseq EOF 
;

enumeratorlist_DropletFile
:
    enumeratordefinition EOF 
    | enumeratorlist ',' enumeratordefinition EOF 
;

enumeratordefinition_DropletFile
:
    enumerator EOF 
    | enumerator '=' constantexpression EOF 
;

enumerator_DropletFile
:
    Identifier EOF 
;

namespacename_DropletFile
:
    originalnamespacename EOF 
    | namespacealias EOF 
;

originalnamespacename_DropletFile
:
    Identifier EOF 
;

namespacedefinition_DropletFile
:
    namednamespacedefinition EOF 
    | unnamednamespacedefinition EOF 
;

namednamespacedefinition_DropletFile
:
    originalnamespacedefinition EOF 
    | extensionnamespacedefinition EOF 
;

originalnamespacedefinition_DropletFile
:
    Inline? Namespace Identifier '{' namespacebody '}' EOF 
;

extensionnamespacedefinition_DropletFile
:
    Inline? Namespace originalnamespacename '{' namespacebody '}' EOF 
;

unnamednamespacedefinition_DropletFile
:
    Inline? Namespace '{' namespacebody '}' EOF 
;

namespacebody_DropletFile
:
    declarationseq? EOF 
;

namespacealias_DropletFile
:
    Identifier EOF 
;

namespacealiasdefinition_DropletFile
:
    Namespace Identifier '=' qualifiednamespacespecifier ';' EOF 
;

qualifiednamespacespecifier_DropletFile
:
    nestednamespecifier? namespacename EOF 
;

usingdeclaration_DropletFile
:
    Using Typename? nestednamespecifier unqualifiedid ';' EOF 
    | Using '::' unqualifiedid ';' EOF 
;

usingdirective_DropletFile
:
    attributespecifierseq? Using Namespace nestednamespecifier? namespacename ';' EOF 
;

asmdefinition_DropletFile
:
    Asm '(' Stringliteral ')' ';' EOF 
;

linkagespecification_DropletFile
:
    Extern Stringliteral '{' declarationseq? '}' EOF 
    | Extern Stringliteral declaration EOF 
;

attributespecifierseq_DropletFile
:
    attributespecifier EOF 
    | attributespecifierseq attributespecifier EOF 
;

attributespecifier_DropletFile
:
    '[' '[' attributelist ']' ']' EOF 
    | alignmentspecifier EOF 
;

alignmentspecifier_DropletFile
:
    Alignas '(' typeid '...'? ')' EOF 
    | Alignas '(' constantexpression '...'? ')' EOF 
;

attributelist_DropletFile
:
    attribute? EOF 
    | attributelist ',' attribute? EOF 
    | attribute '...' EOF 
    | attributelist ',' attribute '...' EOF 
;

attribute_DropletFile
:
    attributetoken attributeargumentclause? EOF 
;

attributetoken_DropletFile
:
    Identifier EOF 
    | attributescopedtoken EOF 
;

attributescopedtoken_DropletFile
:
    attributenamespace '::' Identifier EOF 
;

attributenamespace_DropletFile
:
    Identifier EOF 
;

attributeargumentclause_DropletFile
:
    '(' balancedtokenseq ')' EOF 
;

balancedtokenseq_DropletFile
:
    balancedtoken? EOF 
    | balancedtokenseq balancedtoken EOF 
;

balancedtoken_DropletFile
:
    '(' balancedtokenseq ')' EOF 
    | '[' balancedtokenseq ']' EOF 
    | '{' balancedtokenseq '}' EOF 
    /*any token other than a parenthesis , a bracket , or a brace*/
;

/*Declarators*/
initdeclaratorlist_DropletFile
:
    initdeclarator EOF 
    | initdeclaratorlist ',' initdeclarator EOF 
;

initdeclarator_DropletFile
:
    declarator initializer? EOF 
;

declarator_DropletFile
:
    ptrdeclarator EOF 
    | noptrdeclarator parametersandqualifiers trailingreturntype EOF 
;

ptrdeclarator_DropletFile
:
    noptrdeclarator EOF 
    | ptroperator ptrdeclarator EOF 
;

noptrdeclarator_DropletFile
:
    declaratorid attributespecifierseq? EOF 
    | noptrdeclarator parametersandqualifiers EOF 
    | noptrdeclarator '[' constantexpression? ']' attributespecifierseq? EOF 
    | '(' ptrdeclarator ')' EOF 
;

parametersandqualifiers_DropletFile
:
    '(' parameterdeclarationclause ')' cvqualifierseq? refqualifier? EOF 
    exceptionspecification? attributespecifierseq? EOF
;

trailingreturntype_DropletFile
:
    '->' trailingtypespecifierseq abstractdeclarator? EOF 
;

ptroperator_DropletFile
:
    '*' attributespecifierseq? cvqualifierseq? EOF 
    | '&' attributespecifierseq? EOF 
    | '&&' attributespecifierseq? EOF 
    | nestednamespecifier '*' attributespecifierseq? cvqualifierseq? EOF 
;

cvqualifierseq_DropletFile
:
    cvqualifier cvqualifierseq? EOF 
;

cvqualifier_DropletFile
:
    Const EOF 
    | Volatile EOF 
;

refqualifier_DropletFile
:
    '&' EOF 
    | '&&' EOF 
;

declaratorid_DropletFile
:
    '...'? idexpression EOF 
;

typeid_DropletFile
:
    typespecifierseq abstractdeclarator? EOF 
;

abstractdeclarator_DropletFile
:
    ptrabstractdeclarator EOF 
    | noptrabstractdeclarator? parametersandqualifiers trailingreturntype EOF 
    | abstractpackdeclarator EOF 
;

ptrabstractdeclarator_DropletFile
:
    noptrabstractdeclarator EOF 
    | ptroperator ptrabstractdeclarator? EOF 
;

noptrabstractdeclarator_DropletFile
:
    noptrabstractdeclarator parametersandqualifiers EOF 
    | parametersandqualifiers EOF 
    | noptrabstractdeclarator '[' constantexpression? ']' attributespecifierseq? EOF 
    | '[' constantexpression? ']' attributespecifierseq? EOF 
    | '(' ptrabstractdeclarator ')' EOF 
;

abstractpackdeclarator_DropletFile
:
    noptrabstractpackdeclarator EOF 
    | ptroperator abstractpackdeclarator EOF 
;

noptrabstractpackdeclarator_DropletFile
:
    noptrabstractpackdeclarator parametersandqualifiers EOF 
    | noptrabstractpackdeclarator '[' constantexpression? ']' EOF 
    attributespecifierseq? EOF
    | '...' EOF 
;

parameterdeclarationclause_DropletFile
:
    parameterdeclarationlist? '...'? EOF 
    | parameterdeclarationlist ',' '...' EOF 
;

parameterdeclarationlist_DropletFile
:
    parameterdeclaration EOF 
    | parameterdeclarationlist ',' parameterdeclaration EOF 
;

parameterdeclaration_DropletFile
:
    attributespecifierseq? declspecifierseq declarator EOF 
    | attributespecifierseq? declspecifierseq declarator '=' initializerclause EOF 
    | attributespecifierseq? declspecifierseq abstractdeclarator? EOF 
    | attributespecifierseq? declspecifierseq abstractdeclarator? '=' EOF 
    initializerclause EOF
;

functiondefinition_DropletFile
:
    attributespecifierseq? declspecifierseq? declarator virtspecifierseq? EOF 
    functionbody EOF
;

functionbody_DropletFile
:
    ctorinitializer? compoundstatement EOF 
    | functiontryblock EOF 
    | '=' Default ';' EOF 
    | '=' Delete ';' EOF 
;

initializer_DropletFile
:
    braceorequalinitializer EOF 
    | '(' expressionlist ')' EOF 
;

braceorequalinitializer_DropletFile
:
    '=' initializerclause EOF 
    | bracedinitlist EOF 
;

initializerclause_DropletFile
:
    assignmentexpression EOF 
    | bracedinitlist EOF 
;

initializerlist_DropletFile
:
    initializerclause '...'? EOF 
    | initializerlist ',' initializerclause '...'? EOF 
;

bracedinitlist_DropletFile
:
    '{' initializerlist ','? '}' EOF 
    | '{' '}' EOF 
;

/*Classes*/
classname_DropletFile
:
    Identifier EOF 
    | simpletemplateid EOF 
;

classspecifier_DropletFile
:
    classhead '{' memberspecification? '}' EOF 
;

classhead_DropletFile
:
    classkey attributespecifierseq? classheadname classvirtspecifier? baseclause? EOF 
    | classkey attributespecifierseq? baseclause? EOF 
;

classheadname_DropletFile
:
    nestednamespecifier? classname EOF 
;

classvirtspecifier_DropletFile
:
    Final EOF 
;

classkey_DropletFile
:
    Class EOF 
    | Struct EOF 
    | Union EOF 
;

memberspecification_DropletFile
:
    memberdeclaration memberspecification? EOF 
    | accessspecifier ':' memberspecification? EOF 
;


memberdeclaration_DropletFile
:
    attributespecifierseq? declspecifierseq? memberdeclaratorlist? ';' EOF 
    | functiondefinition EOF 
    | usingdeclaration EOF 
    | static_assertdeclaration EOF 
    | templatedeclaration EOF 
    | aliasdeclaration EOF 
    | emptydeclaration EOF 
;

memberdeclaratorlist_DropletFile
:
    memberdeclarator EOF 
    | memberdeclaratorlist ',' memberdeclarator EOF 
;

memberdeclarator_DropletFile
:
    declarator virtspecifierseq? purespecifier? EOF 
    | declarator braceorequalinitializer? EOF 
    | Identifier? attributespecifierseq? ':' constantexpression EOF 
;

virtspecifierseq_DropletFile
:
    virtspecifier EOF 
    | virtspecifierseq virtspecifier EOF 
;

virtspecifier_DropletFile
:
    Override EOF 
    | Final EOF 
;

purespecifier_DropletFile
:
    Assign val = Octalliteral EOF 
    {if($val.text.compareTo("0")!=0) throw new InputMismatchException(this);} EOF
;

/*Derived classes*/
baseclause_DropletFile
:
    ':' basespecifierlist EOF 
;

basespecifierlist_DropletFile
:
    basespecifier '...'? EOF 
    | basespecifierlist ',' basespecifier '...'? EOF 
;

basespecifier_DropletFile
:
    attributespecifierseq? basetypespecifier EOF 
    | attributespecifierseq? Virtual accessspecifier? basetypespecifier EOF 
    | attributespecifierseq? accessspecifier Virtual? basetypespecifier EOF 
;

classordecltype_DropletFile
:
    nestednamespecifier? classname EOF 
    | decltypespecifier EOF 
;

basetypespecifier_DropletFile
:
    classordecltype EOF 
;

accessspecifier_DropletFile
:
    Private EOF 
    | Protected EOF 
    | Public EOF 
;

/*Special member functions*/
conversionfunctionid_DropletFile
:
    Operator conversiontypeid EOF 
;

conversiontypeid_DropletFile
:
    typespecifierseq conversiondeclarator? EOF 
;

conversiondeclarator_DropletFile
:
    ptroperator conversiondeclarator? EOF 
;

ctorinitializer_DropletFile
:
    ':' meminitializerlist EOF 
;

meminitializerlist_DropletFile
:
    meminitializer '...'? EOF 
    | meminitializer '...'? ',' meminitializerlist EOF 
;

meminitializer_DropletFile
:
    meminitializerid '(' expressionlist? ')' EOF 
    | meminitializerid bracedinitlist EOF 
;

meminitializerid_DropletFile
:
    classordecltype EOF 
    | Identifier EOF 
;

/*Overloading*/
operatorfunctionid_DropletFile
:
    Operator operator EOF 
;

literaloperatorid_DropletFile
:
    Operator Stringliteral Identifier EOF 
    | Operator Userdefinedstringliteral EOF 
;

/*Templates*/
templatedeclaration_DropletFile
:
    Template '<' templateparameterlist '>' declaration EOF 
;

templateparameterlist_DropletFile
:
    templateparameter EOF 
    | templateparameterlist ',' templateparameter EOF 
;

templateparameter_DropletFile
:
    typeparameter EOF 
    | parameterdeclaration EOF 
;

typeparameter_DropletFile
:
    Class '...'? Identifier? EOF 
    | Class Identifier? '=' typeid EOF 
    | Typename '...'? Identifier? EOF 
    | Typename Identifier? '=' typeid EOF 
    | Template '<' templateparameterlist '>' Class '...'? Identifier? EOF 
    | Template '<' templateparameterlist '>' Class Identifier? '=' idexpression EOF 
;

simpletemplateid_DropletFile
:
    templatename '<' templateargumentlist? '>' EOF 
;

templateid_DropletFile
:
    simpletemplateid EOF 
    | operatorfunctionid '<' templateargumentlist? '>' EOF 
    | literaloperatorid '<' templateargumentlist? '>' EOF 
;

templatename_DropletFile
:
    Identifier EOF 
;

templateargumentlist_DropletFile
:
    templateargument '...'? EOF 
    | templateargumentlist ',' templateargument '...'? EOF 
;

templateargument_DropletFile
:
    typeid EOF 
    | constantexpression EOF 
    | idexpression EOF 
;

typenamespecifier_DropletFile
:
    Typename nestednamespecifier Identifier EOF 
    | Typename nestednamespecifier Template? simpletemplateid EOF 
;

explicitinstantiation_DropletFile
:
    Extern? Template declaration EOF 
;

explicitspecialization_DropletFile
:
    Template '<' '>' declaration EOF 
;

/*Exception handling*/
tryblock_DropletFile
:
    Try compoundstatement handlerseq EOF 
;

functiontryblock_DropletFile
:
    Try ctorinitializer? compoundstatement handlerseq EOF 
;

handlerseq_DropletFile
:
    handler handlerseq? EOF 
;

handler_DropletFile
:
    Catch '(' exceptiondeclaration ')' compoundstatement EOF 
;

exceptiondeclaration_DropletFile
:
    attributespecifierseq? typespecifierseq declarator EOF 
    | attributespecifierseq? typespecifierseq abstractdeclarator? EOF 
    | '...' EOF 
;

throwexpression_DropletFile
:
    Throw assignmentexpression? EOF 
;

exceptionspecification_DropletFile
:
    dynamicexceptionspecification EOF 
    | noexceptspecification EOF 
;

dynamicexceptionspecification_DropletFile
:
    Throw '(' typeidlist? ')' EOF 
;

typeidlist_DropletFile
:
    typeid '...'? EOF 
    | typeidlist ',' typeid '...'? EOF 
;

noexceptspecification_DropletFile
:
    Noexcept '(' constantexpression ')' EOF 
    | Noexcept EOF 
;

  
/*Preprocessing directives*/

MultiLineMacro
:
    '#' (~[\n]*? '\\' '\r'? '\n')+ ~[\n]+ -> channel(HIDDEN)
;

Directive
:
    '#' ~[\n]* -> channel(HIDDEN)
;

/*Lexer*/

/*Keywords*/
Alignas
:
	'alignas'
;

Alignof
:
	'alignof'
;

Asm
:
	'asm'
;

Auto
:
	'auto'
;

Bool
:
	'bool'
;

Break
:
	'break'
;

Case
:
	'case'
;

Catch
:
	'catch'
;

Char
:
	'char'
;

Char16
:
	'char16_t'
;

Char32
:
	'char32_t'
;

Class
:
	'class'
;

Const
:
	'const'
;

Constexpr
:
	'constexpr'
;

Const_cast
:
	'const_cast'
;

Continue
:
	'continue'
;

Decltype
:
	'decltype'
;

Default
:
	'default'
;

Delete
:
	'delete'
;

Do
:
	'do'
;

Double
:
	'double'
;

Dynamic_cast
:
	'dynamic_cast'
;

Else
:
	'else'
;

Enum
:
	'enum'
;

Explicit
:
	'explicit'
;

Export
:
	'export'
;

Extern
:
	'extern'
;

False
:
	'false'
;

Final
:
	'final'
;

Float
:
	'float'
;

For
:
	'for'
;

Friend
:
	'friend'
;

Goto
:
	'goto'
;

If
:
	'if'
;

Inline
:
	'inline'
;

Int
:
	'int'
;

Long
:
	'long'
;

Mutable
:
	'mutable'
;

Namespace
:
	'namespace'
;

New
:
	'new'
;

Noexcept
:
	'noexcept'
;

Nullptr
:
	'nullptr'
;

Operator
:
	'operator'
;

Override
:
	'override'
;

Private
:
	'private'
;

Protected
:
	'protected'
;

Public
:
	'public'
;

Register
:
	'register'
;

Reinterpret_cast
:
	'reinterpret_cast'
;

Return
:
	'return'
;

Short
:
	'short'
;

Signed
:
	'signed'
;

Sizeof
:
	'sizeof'
;

Static
:
	'static'
;

Static_assert
:
	'static_assert'
;

Static_cast
:
	'static_cast'
;

Struct
:
	'struct'
;

Switch
:
	'switch'
;

Template
:
	'template'
;

This
:
	'this'
;

Thread_local
:
	'thread_local'
;

Throw
:
	'throw'
;

True
:
	'true'
;

Try
:
	'try'
;

Typedef
:
	'typedef'
;

Typeid
:
	'typeid'
;

Typename
:
	'typename'
;

Union
:
	'union'
;

Unsigned
:
	'unsigned'
;

Using
:
	'using'
;

Virtual
:
	'virtual'
;

Void
:
	'void'
;

Volatile
:
	'volatile'
;

Wchar
:
	'wchar_t'
;

While
:
	'while'
;

/*Operators*/
LeftParen
:
	'('
;

RightParen
:
	')'
;

LeftBracket
:
	'['
;

RightBracket
:
	']'
;

LeftBrace
:
	'{'
;

RightBrace
:
	'}'
;

Plus
:
	'+'
;

Minus
:
	'-'
;

Star
:
	'*'
;

Div
:
	'/'
;

Mod
:
	'%'
;

Caret
:
	'^'
;

And
:
	'&'
;

Or
:
	'|'
;

Tilde
:
	'~'
;

Not
:
	'!'
;

Assign
:
	'='
;

Less
:
	'<'
;

Greater
:
	'>'
;

PlusAssign
:
	'+='
;

MinusAssign
:
	'-='
;

StarAssign
:
	'*='
;

DivAssign
:
	'/='
;

ModAssign
:
	'%='
;

XorAssign
:
	'^='
;

AndAssign
:
	'&='
;

OrAssign
:
	'|='
;

LeftShift
:
	'<<'
;

rightShift
:
//'>>'
	Greater Greater
;

LeftShiftAssign
:
	'<<='
;

rightShiftAssign
:
//'>>='
	Greater Greater Assign
;

Equal
:
	'=='
;

NotEqual
:
	'!='
;

LessEqual
:
	'<='
;

GreaterEqual
:
	'>='
;

AndAnd
:
	'&&'
;

OrOr
:
	'||'
;

PlusPlus
:
	'++'
;

MinusMinus
:
	'--'
;

Comma
:
	','
;

ArrowStar
:
	'->*'
;

Arrow
:
	'->'
;

Question
:
	'?'
;

Colon
:
	':'
;

Doublecolon
:
	'::'
;

Semi
:
	';'
;

Dot
:
	'.'
;

DotStar
:
	'.*'
;

Ellipsis
:
	'...'
;

operator
:
	New
	| Delete
	| New '[' ']'
	| Delete '[' ']'
	| '+'
	| '-'
	| '*'
	| '/'
	| '%'
	| '^'
	| '&'
	| '|'
	| '~'
	| '!'
	| '='
	| '<'
	| '>'
	| '+='
	| '-='
	| '*='
	| '/='
	| '%='
	| '^='
	| '&='
	| '|='
	| '<<'
	| rightShift
	| rightShiftAssign
	| '<<='
	| '=='
	| '!='
	| '<='
	| '>='
	| '&&'
	| '||'
	| '++'
	| '--'
	| ','
	| '->*'
	| '->'
	| '(' ')'
	| '[' ']'
;

/*Lexer*/
fragment
Hexquad
:
	HEXADECIMALDIGIT HEXADECIMALDIGIT HEXADECIMALDIGIT HEXADECIMALDIGIT
;

fragment
Universalcharactername
:
	'\\u' Hexquad
	| '\\U' Hexquad Hexquad
;

Identifier
:
/*
	Identifiernondigit
	| Identifier Identifiernondigit
	| Identifier DIGIT
	*/
	Identifiernondigit
	(
		Identifiernondigit
		| DIGIT
	)*
;

fragment
Identifiernondigit
:
	NONDIGIT
	| Universalcharactername
	/* other implementation defined characters*/
;

fragment
NONDIGIT
:
	[a-zA-Z_]
;

fragment
DIGIT
:
	[0-9]
;

literal
:
	Integerliteral
	| Characterliteral
	| Floatingliteral
	| Stringliteral
	| booleanliteral
	| pointerliteral
	| userdefinedliteral
;

Integerliteral
:
	Decimalliteral Integersuffix?
	| Octalliteral Integersuffix?
	| Hexadecimalliteral Integersuffix?
	| Binaryliteral Integersuffix?
;

Decimalliteral
:
	NONZERODIGIT
	(
		'\''? DIGIT
	)*
;

Octalliteral
:
	'0'
	(
		'\''? OCTALDIGIT
	)*
;

Hexadecimalliteral
:
	(
		'0x'
		| '0X'
	) HEXADECIMALDIGIT
	(
		'\''? HEXADECIMALDIGIT
	)*
;

Binaryliteral
:
	(
		'0b'
		| '0B'
	) BINARYDIGIT
	(
		'\''? BINARYDIGIT
	)*
;

fragment
NONZERODIGIT
:
	[1-9]
;

fragment
OCTALDIGIT
:
	[0-7]
;

fragment
HEXADECIMALDIGIT
:
	[0-9a-fA-F]
;

fragment
BINARYDIGIT
:
	[01]
;

Integersuffix
:
	Unsignedsuffix Longsuffix?
	| Unsignedsuffix Longlongsuffix?
	| Longsuffix Unsignedsuffix?
	| Longlongsuffix Unsignedsuffix?
;

fragment
Unsignedsuffix
:
	[uU]
;

fragment
Longsuffix
:
	[lL]
;

fragment
Longlongsuffix
:
	'll'
	| 'LL'
;

Characterliteral
:
	'\'' Cchar+ '\''
	| 'u' '\'' Cchar+ '\''
	| 'U' '\'' Cchar+ '\''
	| 'L' '\'' Cchar+ '\''
;

fragment
Cchar
:
	~['\\\r\n]
	| Escapesequence
	| Universalcharactername
;
fragment
Escapesequence
:
	Simpleescapesequence
	| Octalescapesequence
	| Hexadecimalescapesequence
;
fragment
Simpleescapesequence
:
	'\\\''
	| '\\"'
	| '\\?'
	| '\\\\'
	| '\\a'
	| '\\b'
	| '\\f'
	| '\\n'
	| '\\r'
	| '\\t'
	| '\\v'
;

fragment
Octalescapesequence
:
	'\\' OCTALDIGIT
	| '\\' OCTALDIGIT OCTALDIGIT
	| '\\' OCTALDIGIT OCTALDIGIT OCTALDIGIT
;

fragment
Hexadecimalescapesequence
:
	'\\x' HEXADECIMALDIGIT+
;

Floatingliteral
:
	Fractionalconstant Exponentpart? Floatingsuffix?
	| Digitsequence Exponentpart Floatingsuffix?
;

fragment
Fractionalconstant
:
	Digitsequence? '.' Digitsequence
	| Digitsequence '.'
;

fragment
Exponentpart
:
	'e' SIGN? Digitsequence
	| 'E' SIGN? Digitsequence
;

fragment
SIGN
:
	[+-]
;

fragment
Digitsequence
:
	DIGIT
	(
		'\''? DIGIT
	)*
;

fragment
Floatingsuffix
:
	[flFL]
;

Stringliteral
:
	Encodingprefix? '"' Schar* '"'
	| Encodingprefix? 'R' Rawstring
;

fragment
Encodingprefix
:
	'u8'
	| 'u'
	| 'U'
	| 'L'
;

fragment
Schar
:
	~["\\\r\n]
	| Escapesequence
	| Universalcharactername
;
fragment
Rawstring /* '"' dcharsequence? '(' rcharsequence? ')' dcharsequence? '"' */
:
	'"' .*? '(' .*? ')' .*? '"'
;
booleanliteral
:
	False
	| True
;
pointerliteral
:
	Nullptr
;
userdefinedliteral
:
	Userdefinedintegerliteral
	| Userdefinedfloatingliteral
	| Userdefinedstringliteral
	| Userdefinedcharacterliteral
;
Userdefinedintegerliteral
:
	Decimalliteral Udsuffix
	| Octalliteral Udsuffix
	| Hexadecimalliteral Udsuffix
	| Binaryliteral Udsuffix
;
Userdefinedfloatingliteral
:
	Fractionalconstant Exponentpart? Udsuffix
	| Digitsequence Exponentpart Udsuffix
;
Userdefinedstringliteral
:
	Stringliteral Udsuffix
;
Userdefinedcharacterliteral
:
	Characterliteral Udsuffix
;
fragment
Udsuffix
:
	Identifier
;
Whitespace
:
	[ \t]+ -> skip
;
Newline
:
	(
		'\r' '\n'?
		| '\n'
	) -> skip
;
BlockComment
:
	'/*' .*? '*/' -> skip
;
LineComment
:
	'//' ~[\r\n]* -> skip
;