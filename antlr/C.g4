/*
 [The "BSD licence"]
 Copyright (c) 2013 Sam Harwell
 All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:
 1. Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.
 2. Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the
    documentation and/or other materials provided with the distribution.
 3. The name of the author may not be used to endorse or promote products
    derived from this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

/** C 2011 grammar built from the C11 Spec */
grammar C;

primaryExpression
    :   Identifier
    |   Constant
    |   StringLiteral+
    |   '(' expression ')'
    |   genericSelection
    |   '__extension__'? '(' compoundStatement ')' // Blocks (GCC extension)
    |   '__builtin_va_arg' '(' unaryExpression ',' typeName ')'
    |   '__builtin_offsetof' '(' typeName ',' unaryExpression ')'
    ;

genericSelection
    :   '_Generic' '(' assignmentExpression ',' genericAssocList ')'
    ;

genericAssocList
    :   genericAssociation
    |   genericAssocList ',' genericAssociation
    ;

genericAssociation
    :   typeName ':' assignmentExpression
    |   'default' ':' assignmentExpression
    ;

postfixExpression
    :   primaryExpression
    |   postfixExpression '[' expression ']'
    |   postfixExpression '(' argumentExpressionList? ')'
    |   postfixExpression '.' Identifier
    |   postfixExpression '->' Identifier
    |   postfixExpression '++'
    |   postfixExpression '--'
    |   '(' typeName ')' '{' initializerList '}'
    |   '(' typeName ')' '{' initializerList ',' '}'
    |   '__extension__' '(' typeName ')' '{' initializerList '}'
    |   '__extension__' '(' typeName ')' '{' initializerList ',' '}'
    ;

argumentExpressionList
    :   assignmentExpression
    |   argumentExpressionList ',' assignmentExpression
    ;

unaryExpression
    :   postfixExpression
    |   '++' unaryExpression
    |   '--' unaryExpression
    |   unaryOperator castExpression
    |   'sizeof' '(' typeNameOrExpression ')'
    |   'sizeof' unaryExpression
    |   '_Alignof' '(' typeName ')'
    |   '&&' Identifier // GCC extension address of label
    ;

typeNameOrExpression
    :   typeName
    |   expression
    ;

unaryOperator
    :   '&' | '*' | '+' | '-' | '~' | '!'
    ;

castExpression
    :   unaryExpression
    |   '(' typeName ')' castExpression
    |   '__extension__' '(' typeName ')' castExpression
    ;

multiplicativeExpression
    :   castExpression
    |   multiplicativeExpression '*' castExpression
    |   multiplicativeExpression '/' castExpression
    |   multiplicativeExpression '%' castExpression
    ;

additiveExpression
    :   multiplicativeExpression
    |   additiveExpression '+' multiplicativeExpression
    |   additiveExpression '-' multiplicativeExpression
    ;

shiftExpression
    :   additiveExpression
    |   shiftExpression '<<' additiveExpression
    |   shiftExpression '>>' additiveExpression
    ;

relationalExpression
    :   shiftExpression
    |   relationalExpression '<' shiftExpression
    |   relationalExpression '>' shiftExpression
    |   relationalExpression '<=' shiftExpression
    |   relationalExpression '>=' shiftExpression
    ;

equalityExpression
    :   relationalExpression
    |   equalityExpression '==' relationalExpression
    |   equalityExpression '!=' relationalExpression
    ;

andExpression
    :   equalityExpression
    |   andExpression '&' equalityExpression
    ;

exclusiveOrExpression
    :   andExpression
    |   exclusiveOrExpression '^' andExpression
    ;

inclusiveOrExpression
    :   exclusiveOrExpression
    |   inclusiveOrExpression '|' exclusiveOrExpression
    ;

logicalAndExpression
    :   inclusiveOrExpression
    |   logicalAndExpression '&&' inclusiveOrExpression
    ;

logicalOrExpression
    :   logicalAndExpression
    |   logicalOrExpression '||' logicalAndExpression
    ;

conditionalExpression
    :   logicalOrExpression ('?' expression ':' conditionalExpression)?
    ;

assignmentExpression
    :   conditionalExpression
    |   unaryExpression assignmentOperator assignmentExpression
    ;

assignmentOperator
    :   '=' | '*=' | '/=' | '%=' | '+=' | '-=' | '<<=' | '>>=' | '&=' | '^=' | '|='
    ;

expression
    :   assignmentExpression
    |   expression ',' assignmentExpression
    ;

constantExpression
    :   conditionalExpression
    ;

declaration
    :   specialFunctionDeclaration
    |   declarationSpecifiers initDeclaratorList ';'
    |   declarationSpecifiers ';'
    |   staticAssertDeclaration
    ;

specialFunctionDeclaration
    :   declarationSpecifiers directDeclarator '(' parameterTypeList? ')' ';'
    ;

declarationSpecifiers
    :   declarationSpecifier+
    ;

declarationSpecifiers2
    :   declarationSpecifier+
    ;

declarationSpecifier
    :   storageClassSpecifier
    |   typeSpecifier
    |   typeQualifier
    |   functionSpecifier
    |   alignmentSpecifier
    ;

initDeclaratorList
    :   initDeclarator
    |   initDeclaratorList ',' initDeclarator
    ;

initDeclarator
    :   declarator
    |   declarator '=' initializer
    ;

storageClassSpecifier
    :   'typedef'
    |   'extern'
    |   'static'
    |   '_Thread_local'
    |   'auto'
    |   'register'
    ;

typeSpecifier
    :   ('void'
    |   'char'
    |   'short'
    |   'int'
    |   'long'
    |   'float'
    |   'double'
    |   'signed'
    |   'unsigned'
    |   '_Bool'
    |   '_Complex'
    |   '__m128'
    |   '__m128d'
    |   '__m128i')
    |   '__extension__' '(' ('__m128' | '__m128d' | '__m128i') ')'
    |   atomicTypeSpecifier
    |   structOrUnionSpecifier
    |   enumSpecifier
    |   typedefName
    |   '__typeof__' '(' constantExpression ')' // GCC extension
    ;

/* Droplet: modifies this part of the grammar to add an additional tree node
   around the { block } part of the specifier, so that we are able to make an Indent
   block using that that entire range. */
structOrUnionSpecifier
    :   structOrUnion Identifier? structDeclarationsBlock
    |   structOrUnion Identifier
    ;

structOrUnion
    :   'struct'
    |   'union'
    ;

structDeclarationsBlock
    :   '{' structDeclarationList '}'
    ;

structDeclarationList
    :   structDeclaration
    |   structDeclarationList structDeclaration
    ;

structDeclaration
    :   specifierQualifierList? structDeclaratorList ';'
    |   staticAssertDeclaration
    ;

specifierQualifierList
    :   typeSpecifier specifierQualifierList?
    |   typeQualifier specifierQualifierList?
    ;

structDeclaratorList
    :   structDeclarator
    |   structDeclaratorList ',' structDeclarator
    ;

structDeclarator
    :   declarator
    |   declarator? ':' constantExpression
    ;

enumSpecifier
    :   'enum' Identifier? '{' enumeratorList '}'
    |   'enum' Identifier? '{' enumeratorList ',' '}'
    |   'enum' Identifier
    ;

enumeratorList
    :   enumerator
    |   enumeratorList ',' enumerator
    ;

enumerator
    :   enumerationConstant
    |   enumerationConstant '=' constantExpression
    ;

enumerationConstant
    :   Identifier
    ;

atomicTypeSpecifier
    :   '_Atomic' '(' typeName ')'
    ;

typeQualifier
    :   'const'
    |   'restrict'
    |   'volatile'
    |   '_Atomic'
    ;

functionSpecifier
    :   ('inline'
    |   '_Noreturn'
    |   '__inline__' // GCC extension
    |   '__stdcall')
    |   gccAttributeSpecifier
    |   '__declspec' '(' Identifier ')'
    ;

alignmentSpecifier
    :   '_Alignas' '(' typeName ')'
    |   '_Alignas' '(' constantExpression ')'
    ;

declarator
    :   directDeclarator gccDeclaratorExtension*
    ;

pointerDeclarator
    :   pointer pointerDeclarator
    |   Identifier
    ;

directDeclarator
    :   pointerDeclarator
    |   '(' declarator ')'
    |   directDeclarator '[' typeQualifierList? assignmentExpression? ']'
    |   directDeclarator '[' 'static' typeQualifierList? assignmentExpression ']'
    |   directDeclarator '[' typeQualifierList 'static' assignmentExpression ']'
    |   directDeclarator '[' typeQualifierList? '*' ']'
    |   directDeclarator '(' parameterTypeList ')'
    |   directDeclarator '(' identifierList? ')'
    ;

gccDeclaratorExtension
    :   '__asm' '(' StringLiteral+ ')'
    |   gccAttributeSpecifier
    ;

gccAttributeSpecifier
    :   '__attribute__' '(' '(' gccAttributeList ')' ')'
    ;

gccAttributeList
    :   gccAttribute (',' gccAttribute)*
    |   // empty
    ;

gccAttribute
    :   ~(',' | '(' | ')') // relaxed def for "identifier or reserved word"
        ('(' argumentExpressionList? ')')?
    |   // empty
    ;

nestedParenthesesBlock
    :   (   ~('(' | ')')
        |   '(' nestedParenthesesBlock ')'
        )*
    ;

pointer
    :   '*' typeQualifierList?
    |   '*' typeQualifierList? pointer
    |   '^' typeQualifierList? // Blocks language extension
    |   '^' typeQualifierList? pointer // Blocks language extension
    ;

typeQualifierList
    :   typeQualifier
    |   typeQualifierList typeQualifier
    ;

parameterTypeList
    :   parameterList
    |   parameterList ',' '...'
    ;

parameterList
    :   parameterDeclaration
    |   parameterList ',' parameterDeclaration
    ;

parameterDeclaration
    :   declarationSpecifiers declarator
    |   declarationSpecifiers2 abstractDeclarator?
    ;

identifierList
    :   Identifier
    |   identifierList ',' Identifier
    ;

typeName
    :   specifierQualifierList abstractDeclarator?
    ;

abstractDeclarator
    :   pointer
    |   pointer? directAbstractDeclarator gccDeclaratorExtension*
    ;

directAbstractDeclarator
    :   '(' abstractDeclarator ')' gccDeclaratorExtension*
    |   '[' typeQualifierList? assignmentExpression? ']'
    |   '[' 'static' typeQualifierList? assignmentExpression ']'
    |   '[' typeQualifierList 'static' assignmentExpression ']'
    |   '[' '*' ']'
    |   '(' parameterTypeList? ')' gccDeclaratorExtension*
    |   directAbstractDeclarator '[' typeQualifierList? assignmentExpression? ']'
    |   directAbstractDeclarator '[' 'static' typeQualifierList? assignmentExpression ']'
    |   directAbstractDeclarator '[' typeQualifierList 'static' assignmentExpression ']'
    |   directAbstractDeclarator '[' '*' ']'
    |   directAbstractDeclarator '(' parameterTypeList? ')' gccDeclaratorExtension*
    ;

typedefName
    :   Identifier
    ;

initializer
    :   assignmentExpression
    |   '{' initializerList '}'
    |   '{' initializerList ',' '}'
    ;

initializerList
    :   designation? initializer
    |   initializerList ',' designation? initializer
    ;

designation
    :   designatorList '='
    ;

designatorList
    :   designator
    |   designatorList designator
    ;

designator
    :   '[' constantExpression ']'
    |   '.' Identifier
    ;

staticAssertDeclaration
    :   '_Static_assert' '(' constantExpression ',' StringLiteral+ ')' ';'
    ;

statement
    :   labeledStatement
    |   compoundStatement
    |   expressionStatement
    |   selectionStatement
    |   iterationStatement
    |   jumpStatement
    |   ('__asm' | '__asm__') ('volatile' | '__volatile__') '(' (logicalOrExpression (',' logicalOrExpression)*)? (':' (logicalOrExpression (',' logicalOrExpression)*)?)* ')' ';'
    ;

labeledStatement
    :   Identifier ':' statement
    ;

switchLabel
    :   'case' constantExpression ':'
    |   'default' ':'
    ;

compoundStatement
    :   '{' blockItemList? '}'
    ;

blockItemList
    :   blockItem
    |   blockItemList blockItem
    ;

/* Droplet: In the standard C grammar, there is an ambiguity:
   `a (b);`
   could either be a method named `a` called with argument `b`, or a declaration
   of a variable `b` with type `a`.

   This ANTLR grammar always interpreted it as the latter, but for Droplet purposes
   we want it interpreted as the former, as that is the more common use case.

   We therefore have a new type of node, specialMethodCall, for just this case
   which takes priority over declarations. */
blockItem
    :   specialMethodCall
    |   declaration
    |   statement
    ;

specialMethodCall
    :   Identifier '(' assignmentExpression ')' ';'
    ;

expressionStatement
    :   expression? ';'
    ;

selectionStatement
    :   'if' '(' expression ')' statement ('else' statement)?
    |   'switch' '(' expression ')' switchCompoundStatement
    ;

switchCase
    :   switchLabel switchBlockItemList
    ;

switchBlockItemList
    :   blockItemList
    ;

switchCaseList
    :   switchCase
    |   switchCaseList switchCase
    ;

switchCompoundStatement
    :   '{' switchCaseList? '}'
    |   statement
    ;

iterationStatement
    :   'while' '(' expression ')' statement
    |   'do' statement 'while' '(' expression ')' ';'
    |   'for' '(' expression? ';' expression? ';' expression? ')' statement
    |   'for' '(' declaration expression? ';' expression? ')' statement
    ;

jumpStatement
    :   'goto' Identifier ';'
    |   'continue' ';'
    |   'break' ';'
    |   'return' expression? ';'
    |   'goto' unaryExpression ';' // GCC extension
    ;

compilationUnit
    :   translationUnit? EOF
    |   EOF
    ;

translationUnit
    :   externalDeclaration
    |   translationUnit externalDeclaration
    ;

externalDeclaration
    :   functionDefinition
    |   initDeclaratorList ';'
    |   declaration
    |   ';' // stray ;
    ;

functionDefinition
    :   declarationSpecifiers? declarator declarationList? compoundStatement
    ;

declarationList
    :   declaration
    |   declarationList declaration
    ;

/* Droplet: ANTLR has trouble parsing a string when a rule doesn't
   contain an EOF token at the end of it. To do live reparsing, we
   have to define new duplicate rules for each intermediate node plus EOF
   so that we can parse small parts of the program independently.
  */
primaryExpression_DropletFile
    :   Identifier EOF
    |   Constant EOF
    |   StringLiteral+ EOF
    |   '(' expression ')' EOF
    |   genericSelection EOF
    |   '__extension__'? '(' compoundStatement ')' // Blocks (GCC extension) EOF
    |   '__builtin_va_arg' '(' unaryExpression ',' typeName ')' EOF
    |   '__builtin_offsetof' '(' typeName ',' unaryExpression ')' EOF
    ;

genericSelection_DropletFile
    :   '_Generic' '(' assignmentExpression ',' genericAssocList ')' EOF
    ;

genericAssocList_DropletFile
    :   genericAssociation EOF
    |   genericAssocList ',' genericAssociation EOF
    ;

genericAssociation_DropletFile
    :   typeName ':' assignmentExpression EOF
    |   'default' ':' assignmentExpression EOF
    ;

postfixExpression_DropletFile
    :   primaryExpression EOF
    |   postfixExpression '[' expression ']' EOF
    |   postfixExpression '(' argumentExpressionList? ')' EOF
    |   postfixExpression '.' Identifier EOF
    |   postfixExpression '->' Identifier EOF
    |   postfixExpression '++' EOF
    |   postfixExpression '--' EOF
    |   '(' typeName ')' '{' initializerList '}' EOF
    |   '(' typeName ')' '{' initializerList ',' '}' EOF
    |   '__extension__' '(' typeName ')' '{' initializerList '}' EOF
    |   '__extension__' '(' typeName ')' '{' initializerList ',' '}' EOF
    ;

argumentExpressionList_DropletFile
    :   assignmentExpression EOF
    |   argumentExpressionList ',' assignmentExpression EOF
    ;

unaryExpression_DropletFile
    :   postfixExpression EOF
    |   '++' unaryExpression EOF
    |   '--' unaryExpression EOF
    |   unaryOperator castExpression EOF
    |   'sizeof' '(' typeNameOrExpression ')' EOF
    |   'sizeof' '(' expression ')' EOF
    |   'sizeof' unaryExpression EOF
    |   '_Alignof' '(' typeName ')' EOF
    |   '&&' Identifier // GCC extension address of label EOF
    ;

typeNameOrExpression_DropletFile
    :   typeName EOF
    |   expression EOF
    ;

unaryOperator_DropletFile
    :   '&' | '*' | '+' | '-' | '~' | '!' EOF
    ;

castExpression_DropletFile
    :   unaryExpression EOF
    |   '(' typeName ')' castExpression EOF
    |   '__extension__' '(' typeName ')' castExpression EOF
    ;

multiplicativeExpression_DropletFile
    :   castExpression EOF
    |   multiplicativeExpression '*' castExpression EOF
    |   multiplicativeExpression '/' castExpression EOF
    |   multiplicativeExpression '%' castExpression EOF
    ;

additiveExpression_DropletFile
    :   multiplicativeExpression EOF
    |   additiveExpression '+' multiplicativeExpression EOF
    |   additiveExpression '-' multiplicativeExpression EOF
    ;

shiftExpression_DropletFile
    :   additiveExpression EOF
    |   shiftExpression '<<' additiveExpression EOF
    |   shiftExpression '>>' additiveExpression EOF
    ;

relationalExpression_DropletFile
    :   shiftExpression EOF
    |   relationalExpression '<' shiftExpression EOF
    |   relationalExpression '>' shiftExpression EOF
    |   relationalExpression '<=' shiftExpression EOF
    |   relationalExpression '>=' shiftExpression EOF
    ;

equalityExpression_DropletFile
    :   relationalExpression EOF
    |   equalityExpression '==' relationalExpression EOF
    |   equalityExpression '!=' relationalExpression EOF
    ;

andExpression_DropletFile
    :   equalityExpression EOF
    |   andExpression '&' equalityExpression EOF
    ;

exclusiveOrExpression_DropletFile
    :   andExpression EOF
    |   exclusiveOrExpression '^' andExpression EOF
    ;

inclusiveOrExpression_DropletFile
    :   exclusiveOrExpression EOF
    |   inclusiveOrExpression '|' exclusiveOrExpression EOF
    ;

logicalAndExpression_DropletFile
    :   inclusiveOrExpression EOF
    |   logicalAndExpression '&&' inclusiveOrExpression EOF
    ;

logicalOrExpression_DropletFile
    :   logicalAndExpression EOF
    |   logicalOrExpression '||' logicalAndExpression EOF
    ;

conditionalExpression_DropletFile
    :   logicalOrExpression ('?' expression ':' conditionalExpression)? EOF
    ;

assignmentExpression_DropletFile
    :   conditionalExpression EOF
    |   unaryExpression assignmentOperator assignmentExpression EOF
    ;

assignmentOperator_DropletFile
    :   '=' | '*=' | '/=' | '%=' | '+=' | '-=' | '<<=' | '>>=' | '&=' | '^=' | '|=' EOF
    ;

expression_DropletFile
    :   assignmentExpression EOF
    |   expression ',' assignmentExpression EOF
    ;

constantExpression_DropletFile
    :   conditionalExpression EOF
    ;

declaration_DropletFile
    :   specialFunctionDeclaration EOF
    |   declarationSpecifiers initDeclaratorList ';' EOF
    |   declarationSpecifiers ';' EOF
    |   staticAssertDeclaration EOF
    ;

specialFunctionDeclaration_DropletFile
    :   declarationSpecifiers directDeclarator '(' parameterTypeList? ')' ';' EOF
    ;

declarationSpecifiers_DropletFile
    :   declarationSpecifier+ EOF
    ;

declarationSpecifiers2_DropletFile
    :   declarationSpecifier+ EOF
    ;

declarationSpecifier_DropletFile
    :   storageClassSpecifier EOF
    |   typeSpecifier EOF
    |   typeQualifier EOF
    |   functionSpecifier EOF
    |   alignmentSpecifier EOF
    ;

initDeclaratorList_DropletFile
    :   initDeclarator EOF
    |   initDeclaratorList ',' initDeclarator EOF
    ;

initDeclarator_DropletFile
    :   declarator EOF
    |   declarator '=' initializer EOF
    ;

storageClassSpecifier_DropletFile
    :   'typedef' EOF
    |   'extern' EOF
    |   'static' EOF
    |   '_Thread_local' EOF
    |   'auto' EOF
    |   'register' EOF
    ;

typeSpecifier_DropletFile
    :   ('void' EOF
    |   'char' EOF
    |   'short' EOF
    |   'int' EOF
    |   'long' EOF
    |   'float' EOF
    |   'double' EOF
    |   'signed' EOF
    |   'unsigned' EOF
    |   '_Bool' EOF
    |   '_Complex' EOF
    |   '__m128' EOF
    |   '__m128d' EOF
    |   '__m128i') EOF
    |   '__extension__' '(' ('__m128' | '__m128d' | '__m128i') ')' EOF
    |   atomicTypeSpecifier EOF
    |   structOrUnionSpecifier EOF
    |   enumSpecifier EOF
    |   typedefName EOF
    |   '__typeof__' '(' constantExpression ')' // GCC extension EOF
    ;

structOrUnionSpecifier_DropletFile
    :   structOrUnion Identifier? structDeclarationsBlock EOF
    |   structOrUnion Identifier EOF
    ;

structOrUnion_DropletFile
    :   'struct' EOF
    |   'union' EOF
    ;


structDeclarationsBlock_DropletFile
    :   '{' structDeclarationList '}' EOF
    ;

structDeclarationList_DropletFile
    :   structDeclaration EOF
    |   structDeclarationList structDeclaration EOF
    ;

structDeclaration_DropletFile
    :   specifierQualifierList? structDeclaratorList ';' EOF
    |   staticAssertDeclaration EOF
    ;

specifierQualifierList_DropletFile
    :   typeSpecifier specifierQualifierList? EOF
    |   typeQualifier specifierQualifierList? EOF
    ;

structDeclaratorList_DropletFile
    :   structDeclarator EOF
    |   structDeclaratorList ',' structDeclarator EOF
    ;

structDeclarator_DropletFile
    :   declarator EOF
    |   declarator? ':' constantExpression EOF
    ;

enumSpecifier_DropletFile
    :   'enum' Identifier? '{' enumeratorList '}' EOF
    |   'enum' Identifier? '{' enumeratorList ',' '}' EOF
    |   'enum' Identifier EOF
    ;

enumeratorList_DropletFile
    :   enumerator EOF
    |   enumeratorList ',' enumerator EOF
    ;

enumerator_DropletFile
    :   enumerationConstant EOF
    |   enumerationConstant '=' constantExpression EOF
    ;

enumerationConstant_DropletFile
    :   Identifier EOF
    ;

atomicTypeSpecifier_DropletFile
    :   '_Atomic' '(' typeName ')' EOF
    ;

typeQualifier_DropletFile
    :   'const' EOF
    |   'restrict' EOF
    |   'volatile' EOF
    |   '_Atomic' EOF
    ;

functionSpecifier_DropletFile
    :   ('inline' EOF
    |   '_Noreturn' EOF
    |   '__inline__' // GCC extension EOF
    |   '__stdcall') EOF
    |   gccAttributeSpecifier EOF
    |   '__declspec' '(' Identifier ')' EOF
    ;

alignmentSpecifier_DropletFile
    :   '_Alignas' '(' typeName ')' EOF
    |   '_Alignas' '(' constantExpression ')' EOF
    ;

declarator_DropletFile
    :   pointer? directDeclarator gccDeclaratorExtension* EOF
    ;

pointerDeclarator_DropletFile
    :   pointer pointerDeclarator EOF
    |   Identifier EOF
    ;

directDeclarator_DropletFile
    :   Identifier EOF
    |   '(' declarator ')' EOF
    |   directDeclarator '[' typeQualifierList? assignmentExpression? ']' EOF
    |   directDeclarator '[' 'static' typeQualifierList? assignmentExpression ']' EOF
    |   directDeclarator '[' typeQualifierList 'static' assignmentExpression ']' EOF
    |   directDeclarator '[' typeQualifierList? '*' ']' EOF
    |   directDeclarator '(' parameterTypeList ')' EOF
    |   directDeclarator '(' identifierList? ')' EOF
    ;

gccDeclaratorExtension_DropletFile
    :   '__asm' '(' StringLiteral+ ')' EOF
    |   gccAttributeSpecifier EOF
    ;

gccAttributeSpecifier_DropletFile
    :   '__attribute__' '(' '(' gccAttributeList ')' ')' EOF
    ;

gccAttributeList_DropletFile
    :   gccAttribute (',' gccAttribute)* EOF
    |   // empty EOF
    ;

gccAttribute_DropletFile
    :   ~(',' | '(' | ')') // relaxed def for "identifier or reserved word"
        ('(' argumentExpressionList? ')')? EOF
    |   EOF // empty
    ;

nestedParenthesesBlock_DropletFile
    :   (   ~('(' | ')')
        |   '(' nestedParenthesesBlock ')'
        )* EOF
    ;

pointer_DropletFile
    :   '*' typeQualifierList? EOF
    |   '*' typeQualifierList? pointer EOF
    |   '^' typeQualifierList? // Blocks language extension EOF
    |   '^' typeQualifierList? pointer // Blocks language extension EOF
    ;

typeQualifierList_DropletFile
    :   typeQualifier EOF
    |   typeQualifierList typeQualifier EOF
    ;

parameterTypeList_DropletFile
    :   parameterList EOF
    |   parameterList ',' '...' EOF
    ;

parameterList_DropletFile
    :   parameterDeclaration EOF
    |   parameterList ',' parameterDeclaration EOF
    ;

parameterDeclaration_DropletFile
    :   declarationSpecifiers declarator EOF
    |   declarationSpecifiers2 abstractDeclarator? EOF
    ;

identifierList_DropletFile
    :   Identifier EOF
    |   identifierList ',' Identifier EOF
    ;

typeName_DropletFile
    :   specifierQualifierList abstractDeclarator? EOF
    ;

abstractDeclarator_DropletFile
    :   pointer EOF
    |   pointer? directAbstractDeclarator gccDeclaratorExtension* EOF
    ;

directAbstractDeclarator_DropletFile
    :   '(' abstractDeclarator ')' gccDeclaratorExtension* EOF
    |   '[' typeQualifierList? assignmentExpression? ']' EOF
    |   '[' 'static' typeQualifierList? assignmentExpression ']' EOF
    |   '[' typeQualifierList 'static' assignmentExpression ']' EOF
    |   '[' '*' ']' EOF
    |   '(' parameterTypeList? ')' gccDeclaratorExtension* EOF
    |   directAbstractDeclarator '[' typeQualifierList? assignmentExpression? ']' EOF
    |   directAbstractDeclarator '[' 'static' typeQualifierList? assignmentExpression ']' EOF
    |   directAbstractDeclarator '[' typeQualifierList 'static' assignmentExpression ']' EOF
    |   directAbstractDeclarator '[' '*' ']' EOF
    |   directAbstractDeclarator '(' parameterTypeList? ')' gccDeclaratorExtension* EOF
    ;

typedefName_DropletFile
    :   Identifier EOF
    ;

initializer_DropletFile
    :   assignmentExpression EOF
    |   '{' initializerList '}' EOF
    |   '{' initializerList ',' '}' EOF
    ;

initializerList_DropletFile
    :   designation? initializer EOF
    |   initializerList ',' designation? initializer EOF
    ;

designation_DropletFile
    :   designatorList '=' EOF
    ;

designatorList_DropletFile
    :   designator EOF
    |   designatorList designator EOF
    ;

designator_DropletFile
    :   '[' constantExpression ']' EOF
    |   '.' Identifier EOF
    ;

staticAssertDeclaration_DropletFile
    :   '_Static_assert' '(' constantExpression ',' StringLiteral+ ')' ';' EOF
    ;

statement_DropletFile
    :   labeledStatement EOF
    |   compoundStatement EOF
    |   expressionStatement EOF
    |   selectionStatement EOF
    |   iterationStatement EOF
    |   jumpStatement EOF
    |   ('__asm' | '__asm__') ('volatile' | '__volatile__') '(' (logicalOrExpression (',' logicalOrExpression)*)? (':' (logicalOrExpression (',' logicalOrExpression)*)?)* ')' ';' EOF
    ;

labeledStatement_DropletFile
    :   Identifier ':' statement EOF
    ;

switchLabeledStatement_DropletFile
    :   'case' constantExpression ':' statement EOF
    |   'default' ':' statement EOF
    ;

compoundStatement_DropletFile
    :   '{' blockItemList? '}' EOF
    ;

blockItemList_DropletFile
    :   blockItem EOF
    |   blockItemList blockItem EOF
    ;

// A block item can be a special kind of function call, which we
// check before we check declarations to avoid conflicts with a (b);.
blockItem_DropletFile
    :   specialMethodCall EOF
    |   initDeclarator EOF
    |   declaration EOF
    |   statement EOF
    |   EOF
    ;

specialMethodCall_DropletFile
    :   Identifier '(' assignmentExpression ')' ';' EOF
    ;

expressionStatement_DropletFile
    :   expression? ';' EOF
    ;

selectionStatement_DropletFile
    :   'if' '(' expression ')' statement ('else' statement)? EOF
    |   'switch' '(' expression ')' switchCompoundStatement EOF
    ;

switchCase_DropletFile
    :   switchLabel switchBlockItemList EOF
    ;

switchBlockItemList_DropletFile
    :   blockItemList EOF
    ;

switchCaseList_DropletFile
    :   switchCase EOF
    |   switchCaseList switchCase EOF
    ;

switchCompoundStatement_DropletFile
    :   '{' switchCaseList? '}' EOF
    |   statement EOF
    ;

iterationStatement_DropletFile
    :   'while' '(' expression ')' statement EOF
    |   'do' statement 'while' '(' expression ')' ';' EOF
    |   'for' '(' expression? ';' expression? ';' expression? ')' statement EOF
    |   'for' '(' declaration expression? ';' expression? ')' statement EOF
    ;

jumpStatement_DropletFile
    :   'goto' Identifier ';' EOF
    |   'continue' ';' EOF
    |   'break' ';' EOF
    |   'return' expression? ';' EOF
    |   'goto' unaryExpression ';' EOF // GCC extension
    ;

compilationUnit_DropletFile
    :   translationUnit? EOF
    |   EOF
    ;

translationUnit_DropletFile
    :   externalDeclaration EOF
    |   translationUnit externalDeclaration EOF
    ;

externalDeclaration_DropletFile
    :   functionDefinition EOF
    |   declaration EOF
    |   ';' EOF // stray ;
    ;

functionDefinition_DropletFile
    :   declarationSpecifiers? declarator declarationList? compoundStatement EOF
    ;

declarationList_DropletFile
    :   declaration EOF
    |   declarationList declaration EOF
    ;

Auto : 'auto';
Break : 'break';
Case : 'case';
Char : 'char';
Const : 'const';
Continue : 'continue';
Default : 'default';
Do : 'do';
Double : 'double';
Else : 'else';
Enum : 'enum';
Extern : 'extern';
Float : 'float';
For : 'for';
Goto : 'goto';
If : 'if';
Inline : 'inline';
Int : 'int';
Long : 'long';
Register : 'register';
Restrict : 'restrict';
Return : 'return';
Short : 'short';
Signed : 'signed';
Sizeof : 'sizeof';
Static : 'static';
Struct : 'struct';
Switch : 'switch';
Typedef : 'typedef';
Union : 'union';
Unsigned : 'unsigned';
Void : 'void';
Volatile : 'volatile';
While : 'while';

Alignas : '_Alignas';
Alignof : '_Alignof';
Atomic : '_Atomic';
Bool : '_Bool';
Complex : '_Complex';
Generic : '_Generic';
Imaginary : '_Imaginary';
Noreturn : '_Noreturn';
StaticAssert : '_Static_assert';
ThreadLocal : '_Thread_local';

LeftParen : '(';
RightParen : ')';
LeftBracket : '[';
RightBracket : ']';
LeftBrace : '{';
RightBrace : '}';

Less : '<';
LessEqual : '<=';
Greater : '>';
GreaterEqual : '>=';
LeftShift : '<<';
RightShift : '>>';

Plus : '+';
PlusPlus : '++';
Minus : '-';
MinusMinus : '--';
Star : '*';
Div : '/';
Mod : '%';

And : '&';
Or : '|';
AndAnd : '&&';
OrOr : '||';
Caret : '^';
Not : '!';
Tilde : '~';

Question : '?';
Colon : ':';
Semi : ';';
Comma : ',';

Assign : '=';
// '*=' | '/=' | '%=' | '+=' | '-=' | '<<=' | '>>=' | '&=' | '^=' | '|='
StarAssign : '*=';
DivAssign : '/=';
ModAssign : '%=';
PlusAssign : '+=';
MinusAssign : '-=';
LeftShiftAssign : '<<=';
RightShiftAssign : '>>=';
AndAssign : '&=';
XorAssign : '^=';
OrAssign : '|=';

Equal : '==';
NotEqual : '!=';

Arrow : '->';
Dot : '.';
Ellipsis : '...';

Identifier
    :   IdentifierNondigit
        (   IdentifierNondigit
        |   Digit
        )*
    ;

fragment
IdentifierNondigit
    :   Nondigit
    |   UniversalCharacterName
    //|   // other implementation-defined characters...
    ;

fragment
Nondigit
    :   [a-zA-Z_]
    ;

fragment
Digit
    :   [0-9]
    ;

fragment
UniversalCharacterName
    :   '\\u' HexQuad
    |   '\\U' HexQuad HexQuad
    ;

fragment
HexQuad
    :   HexadecimalDigit HexadecimalDigit HexadecimalDigit HexadecimalDigit
    ;

Constant
    :   IntegerConstant
    |   FloatingConstant
    //|   EnumerationConstant
    |   CharacterConstant
    ;

fragment
IntegerConstant
    :   DecimalConstant IntegerSuffix?
    |   OctalConstant IntegerSuffix?
    |   HexadecimalConstant IntegerSuffix?
    ;

fragment
DecimalConstant
    :   NonzeroDigit Digit*
    ;

fragment
OctalConstant
    :   '0' OctalDigit*
    ;

fragment
HexadecimalConstant
    :   HexadecimalPrefix HexadecimalDigit+
    ;

fragment
HexadecimalPrefix
    :   '0' [xX]
    ;

fragment
NonzeroDigit
    :   [1-9]
    ;

fragment
OctalDigit
    :   [0-7]
    ;

fragment
HexadecimalDigit
    :   [0-9a-fA-F]
    ;

fragment
IntegerSuffix
    :   UnsignedSuffix LongSuffix?
    |   UnsignedSuffix LongLongSuffix
    |   LongSuffix UnsignedSuffix?
    |   LongLongSuffix UnsignedSuffix?
    ;

fragment
UnsignedSuffix
    :   [uU]
    ;

fragment
LongSuffix
    :   [lL]
    ;

fragment
LongLongSuffix
    :   'll' | 'LL'
    ;

fragment
FloatingConstant
    :   DecimalFloatingConstant
    |   HexadecimalFloatingConstant
    ;

fragment
DecimalFloatingConstant
    :   FractionalConstant ExponentPart? FloatingSuffix?
    |   DigitSequence ExponentPart FloatingSuffix?
    ;

fragment
HexadecimalFloatingConstant
    :   HexadecimalPrefix HexadecimalFractionalConstant BinaryExponentPart FloatingSuffix?
    |   HexadecimalPrefix HexadecimalDigitSequence BinaryExponentPart FloatingSuffix?
    ;

fragment
FractionalConstant
    :   DigitSequence? '.' DigitSequence
    |   DigitSequence '.'
    ;

fragment
ExponentPart
    :   'e' Sign? DigitSequence
    |   'E' Sign? DigitSequence
    ;

fragment
Sign
    :   '+' | '-'
    ;

fragment
DigitSequence
    :   Digit+
    ;

fragment
HexadecimalFractionalConstant
    :   HexadecimalDigitSequence? '.' HexadecimalDigitSequence
    |   HexadecimalDigitSequence '.'
    ;

fragment
BinaryExponentPart
    :   'p' Sign? DigitSequence
    |   'P' Sign? DigitSequence
    ;

fragment
HexadecimalDigitSequence
    :   HexadecimalDigit+
    ;

fragment
FloatingSuffix
    :   'f' | 'l' | 'F' | 'L'
    ;

fragment
CharacterConstant
    :   '\'' CCharSequence '\''
    |   'L\'' CCharSequence '\''
    |   'u\'' CCharSequence '\''
    |   'U\'' CCharSequence '\''
    ;

fragment
CCharSequence
    :   CChar+
    ;

fragment
CChar
    :   ~['\\\r\n]
    |   EscapeSequence
    ;

fragment
EscapeSequence
    :   SimpleEscapeSequence
    |   OctalEscapeSequence
    |   HexadecimalEscapeSequence
    |   UniversalCharacterName
    ;

fragment
SimpleEscapeSequence
    :   '\\' ['"?abfnrtv\\]
    ;

fragment
OctalEscapeSequence
    :   '\\' OctalDigit
    |   '\\' OctalDigit OctalDigit
    |   '\\' OctalDigit OctalDigit OctalDigit
    ;

fragment
HexadecimalEscapeSequence
    :   '\\x' HexadecimalDigit+
    ;

StringLiteral
    :   EncodingPrefix? '"' SCharSequence? '"'
    ;

fragment
EncodingPrefix
    :   'u8'
    |   'u'
    |   'U'
    |   'L'
    ;

fragment
SCharSequence
    :   SChar+
    ;

fragment
SChar
    :   ~["\\\r\n]
    |   EscapeSequence
    ;

/* Droplet: we parse all directives as if they were comments,
   distinguishing between them later in parseComment. */
Directive
    :   '#' [^\r\n]*? ~[\r\n]*
        -> skip
    ;

Whitespace
    :   [ \t]+
        -> skip
    ;

Newline
    :   (   '\r' '\n'?
        |   '\n'
        )
        -> skip
    ;

BlockComment
    :   '/*' .*? '*/'
        -> skip
    ;

LineComment
    :   '//' ~[\r\n]*
        -> skip
    ;
