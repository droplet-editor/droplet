/*
 [The "BSD licence"]
 Copyright (c) 2013 Terence Parr, Sam Harwell
 Copyright (c) 2017 Ivan Kochurkin (upgrade to Java 8)
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

parser grammar JavaParser;

options { tokenVocab=JavaLexer; }

compilationUnit
    : packageDeclaration? importDeclaration* typeDeclaration* EOF
    ;

packageDeclaration
    : annotation* PACKAGE qualifiedName ';'
    ;

importDeclaration
    : IMPORT STATIC? qualifiedName ('.' '*')? ';'
    ;

typeDeclaration
    : classOrInterfaceModifier*
      (classDeclaration | enumDeclaration | interfaceDeclaration | annotationTypeDeclaration)
    | ';'
    ;

modifier
    : classOrInterfaceModifier
    | NATIVE
    | SYNCHRONIZED
    | TRANSIENT
    | VOLATILE
    ;

classOrInterfaceModifier
    : annotation
    | PUBLIC
    | PROTECTED
    | PRIVATE
    | STATIC
    | ABSTRACT
    | FINAL    // FINAL for class only -- does not apply to interfaces
    | STRICTFP
    ;

variableModifier
    : FINAL
    | annotation
    ;

classDeclaration
    : CLASS IDENTIFIER typeParameters?
      (EXTENDS typeType)?
      (IMPLEMENTS typeList)?
      classBody
    ;

typeParameters
    : '<' typeParameter (',' typeParameter)* '>'
    ;

typeParameter
    : annotation* IDENTIFIER (EXTENDS typeBound)?
    ;

typeBound
    : typeType ('&' typeType)*
    ;

enumDeclaration
    : ENUM IDENTIFIER (IMPLEMENTS typeList)? '{' enumConstants? ','? enumBodyDeclarations? '}'
    ;

enumConstants
    : enumConstant (',' enumConstant)*
    ;

enumConstant
    : annotation* IDENTIFIER arguments? classBody?
    ;

enumBodyDeclarations
    : ';' classBodyDeclaration*
    ;

interfaceDeclaration
    : INTERFACE IDENTIFIER typeParameters? (EXTENDS typeList)? interfaceBody
    ;

classBody
    : '{' classBodyDeclaration* '}'
    ;

interfaceBody
    : '{' interfaceBodyDeclaration* '}'
    ;

classBodyDeclaration
    : ';'
    | STATIC? block
    | modifier* memberDeclaration
    ;

memberDeclaration
    : methodDeclaration
    | genericMethodDeclaration
    | fieldDeclaration
    | constructorDeclaration
    | genericConstructorDeclaration
    | interfaceDeclaration
    | annotationTypeDeclaration
    | classDeclaration
    | enumDeclaration
    ;

/* We use rule this even for void methods which cannot have [] after parameters.
   This simplifies grammar and we can consider void to be a type, which
   renders the [] matching as a context-sensitive issue or a semantic check
   for invalid return type after parsing.
 */
methodDeclaration
    : typeTypeOrVoid IDENTIFIER formalParameters ('[' ']')*
      (THROWS qualifiedNameList)?
      methodBody
    ;

methodBody
    : block
    | ';'
    ;

typeTypeOrVoid
    : typeType
    | VOID
    ;

genericMethodDeclaration
    : typeParameters methodDeclaration
    ;

genericConstructorDeclaration
    : typeParameters constructorDeclaration
    ;

constructorDeclaration
    : IDENTIFIER formalParameters (THROWS qualifiedNameList)? constructorBody=block
    ;

fieldDeclaration
    : typeType variableDeclarators ';'
    ;

interfaceBodyDeclaration
    : modifier* interfaceMemberDeclaration
    | ';'
    ;

interfaceMemberDeclaration
    : constDeclaration
    | interfaceMethodDeclaration
    | genericInterfaceMethodDeclaration
    | interfaceDeclaration
    | annotationTypeDeclaration
    | classDeclaration
    | enumDeclaration
    ;

constDeclaration
    : typeType constantDeclarator (',' constantDeclarator)* ';'
    ;

constantDeclarator
    : IDENTIFIER ('[' ']')* '=' variableInitializer
    ;

// see matching of [] comment in methodDeclaratorRest
// methodBody from Java8
interfaceMethodDeclaration
    : interfaceMethodModifier* (typeTypeOrVoid | typeParameters annotation* typeTypeOrVoid)
      IDENTIFIER formalParameters ('[' ']')* (THROWS qualifiedNameList)? methodBody
    ;

// Java8
interfaceMethodModifier
    : annotation
    | PUBLIC
    | ABSTRACT
    | DEFAULT
    | STATIC
    | STRICTFP
    ;

genericInterfaceMethodDeclaration
    : typeParameters interfaceMethodDeclaration
    ;

variableDeclarators
    : variableDeclarator (',' variableDeclarator)*
    ;

variableDeclarator
    : variableDeclaratorId ('=' variableInitializer)?
    ;

variableDeclaratorId
    : IDENTIFIER ('[' ']')*
    ;

variableInitializer
    : arrayInitializer
    | expression
    ;

arrayInitializer
    : '{' (variableInitializer (',' variableInitializer)* (',')? )? '}'
    ;

classOrInterfaceType
    : IDENTIFIER typeArguments? ('.' IDENTIFIER typeArguments?)*
    ;

typeArgument
    : typeType
    | '?' ((EXTENDS | SUPER) typeType)?
    ;

qualifiedNameList
    : qualifiedName (',' qualifiedName)*
    ;

formalParameters
    : '(' formalParameterList? ')'
    ;

formalParameterList
    : formalParameter (',' formalParameter)* (',' lastFormalParameter)?
    | lastFormalParameter
    ;

formalParameter
    : variableModifier* typeType variableDeclaratorId
    ;

lastFormalParameter
    : variableModifier* typeType '...' variableDeclaratorId
    ;

qualifiedName
    : IDENTIFIER ('.' IDENTIFIER)*
    ;

literal
    : integerLiteral
    | floatLiteral
    | CHAR_LITERAL
    | STRING_LITERAL
    | BOOL_LITERAL
    | NULL_LITERAL
    ;

integerLiteral
    : DECIMAL_LITERAL
    | HEX_LITERAL
    | OCT_LITERAL
    | BINARY_LITERAL
    ;

floatLiteral
    : FLOAT_LITERAL
    | HEX_FLOAT_LITERAL
    ;

// ANNOTATIONS

annotation
    : '@' qualifiedName ('(' ( elementValuePairs | elementValue )? ')')?
    ;

elementValuePairs
    : elementValuePair (',' elementValuePair)*
    ;

elementValuePair
    : IDENTIFIER '=' elementValue
    ;

elementValue
    : expression
    | annotation
    | elementValueArrayInitializer
    ;

elementValueArrayInitializer
    : '{' (elementValue (',' elementValue)*)? (',')? '}'
    ;

annotationTypeDeclaration
    : '@' INTERFACE IDENTIFIER annotationTypeBody
    ;

annotationTypeBody
    : '{' (annotationTypeElementDeclaration)* '}'
    ;

annotationTypeElementDeclaration
    : modifier* annotationTypeElementRest
    | ';' // this is not allowed by the grammar, but apparently allowed by the actual compiler
    ;

annotationTypeElementRest
    : typeType annotationMethodOrConstantRest ';'
    | classDeclaration ';'?
    | interfaceDeclaration ';'?
    | enumDeclaration ';'?
    | annotationTypeDeclaration ';'?
    ;

annotationMethodOrConstantRest
    : annotationMethodRest
    | annotationConstantRest
    ;

annotationMethodRest
    : IDENTIFIER '(' ')' defaultValue?
    ;

annotationConstantRest
    : variableDeclarators
    ;

defaultValue
    : DEFAULT elementValue
    ;

// STATEMENTS / BLOCKS

block
    : '{' blockStatement* '}'
    ;

blockStatement
    : localVariableDeclaration ';'
    | statement
    | localTypeDeclaration
    ;

localVariableDeclaration
    : variableModifier* typeType variableDeclarators
    ;

localTypeDeclaration
    : classOrInterfaceModifier*
      (classDeclaration | interfaceDeclaration)
    | ';'
    ;

statement
    : blockLabel=block
    | ASSERT expression (':' expression)? ';'
    | IF parExpression statement (ELSE statement)?
    | FOR '(' forControl ')' statement
    | WHILE parExpression statement
    | DO statement WHILE parExpression ';'
    | TRY block (catchClause+ finallyBlock? | finallyBlock)
    | TRY resourceSpecification block catchClause* finallyBlock?
    | SWITCH parExpression '{' switchBlockStatementGroup* switchLabel* '}'
    | SYNCHRONIZED parExpression block
    | RETURN expression? ';'
    | THROW expression ';'
    | BREAK IDENTIFIER? ';'
    | CONTINUE IDENTIFIER? ';'
    | SEMI
    | statementExpression=expression ';'
    | identifierLabel=IDENTIFIER ':' statement
    ;

catchClause
    : CATCH '(' variableModifier* catchType IDENTIFIER ')' block
    ;

catchType
    : qualifiedName ('|' qualifiedName)*
    ;

finallyBlock
    : FINALLY block
    ;

resourceSpecification
    : '(' resources ';'? ')'
    ;

resources
    : resource (';' resource)*
    ;

resource
    : variableModifier* classOrInterfaceType variableDeclaratorId '=' expression
    ;

/** Matches cases then statements, both of which are mandatory.
 *  To handle empty cases at the end, we add switchLabel* to statement.
 */
switchBlockStatementGroup
    : switchLabel+ blockStatement+
    ;

switchLabel
    : CASE (constantExpression=expression | enumConstantName=IDENTIFIER) ':'
    | DEFAULT ':'
    ;

forControl
    : enhancedForControl
    | forInit? ';' expression? ';' forUpdate=expressionList?
    ;

forInit
    : localVariableDeclaration
    | expressionList
    ;

enhancedForControl
    : variableModifier* typeType variableDeclaratorId ':' expression
    ;

// EXPRESSIONS

parExpression
    : '(' expression ')'
    ;

expressionList
    : expression (',' expression)*
    ;

methodCall
    : IDENTIFIER '(' expressionList? ')'
    ;

expression
    : primary
    | expression bop='.'
      ( IDENTIFIER
      | methodCall
      | THIS
      | NEW nonWildcardTypeArguments? innerCreator
      | SUPER superSuffix
      | explicitGenericInvocation
      )
    | expression '[' expression ']'
    | methodCall
    | NEW creator
    | '(' typeType ')' expression
    | expression postfix=('++' | '--')
    | prefix=('+'|'-'|'++'|'--') expression
    | prefix=('~'|'!') expression
    | expression bop=('*'|'/'|'%') expression
    | expression bop=('+'|'-') expression
    | expression ('<' '<' | '>' '>' '>' | '>' '>') expression
    | expression bop=('<=' | '>=' | '>' | '<') expression
    | expression bop=INSTANCEOF typeType
    | expression bop=('==' | '!=') expression
    | expression bop='&' expression
    | expression bop='^' expression
    | expression bop='|' expression
    | expression bop='&&' expression
    | expression bop='||' expression
    | expression bop='?' expression ':' expression
    | <assoc=right> expression
      bop=('=' | '+=' | '-=' | '*=' | '/=' | '&=' | '|=' | '^=' | '>>=' | '>>>=' | '<<=' | '%=')
      expression
    | lambdaExpression // Java8

    // Java 8 methodReference
    | expression '::' typeArguments? IDENTIFIER
    | typeType '::' (typeArguments? IDENTIFIER | NEW)
    | classType '::' typeArguments? NEW
    ;

// Java8
lambdaExpression
    : lambdaParameters '->' lambdaBody
    ;

// Java8
lambdaParameters
    : IDENTIFIER
    | '(' formalParameterList? ')'
    | '(' IDENTIFIER (',' IDENTIFIER)* ')'
    ;

// Java8
lambdaBody
    : expression
    | block
    ;

primary
    : '(' expression ')'
    | THIS
    | SUPER
    | literal
    | IDENTIFIER
    | typeTypeOrVoid '.' CLASS
    | nonWildcardTypeArguments (explicitGenericInvocationSuffix | THIS arguments)
    ;

classType
    : (classOrInterfaceType '.')? annotation* IDENTIFIER typeArguments?
    ;

creator
    : nonWildcardTypeArguments createdName classCreatorRest
    | createdName (arrayCreatorRest | classCreatorRest)
    ;

createdName
    : IDENTIFIER typeArgumentsOrDiamond? ('.' IDENTIFIER typeArgumentsOrDiamond?)*
    | primitiveType
    ;

innerCreator
    : IDENTIFIER nonWildcardTypeArgumentsOrDiamond? classCreatorRest
    ;

arrayCreatorRest
    : '[' (']' ('[' ']')* arrayInitializer | expression ']' ('[' expression ']')* ('[' ']')*)
    ;

classCreatorRest
    : arguments classBody?
    ;

explicitGenericInvocation
    : nonWildcardTypeArguments explicitGenericInvocationSuffix
    ;

typeArgumentsOrDiamond
    : '<' '>'
    | typeArguments
    ;

nonWildcardTypeArgumentsOrDiamond
    : '<' '>'
    | nonWildcardTypeArguments
    ;

nonWildcardTypeArguments
    : '<' typeList '>'
    ;

typeList
    : typeType (',' typeType)*
    ;

typeType
    : annotation? (classOrInterfaceType | primitiveType) ('[' ']')*
    ;

primitiveType
    : BOOLEAN
    | CHAR
    | BYTE
    | SHORT
    | INT
    | LONG
    | FLOAT
    | DOUBLE
    ;

typeArguments
    : '<' typeArgument (',' typeArgument)* '>'
    ;

superSuffix
    : arguments
    | '.' IDENTIFIER arguments?
    ;

explicitGenericInvocationSuffix
    : SUPER superSuffix
    | IDENTIFIER arguments
    ;

arguments
    : '(' expressionList? ')'
    ;

compilationUnit_DropletFile
    : packageDeclaration? importDeclaration* typeDeclaration* EOF
    ;

packageDeclaration_DropletFile
    : annotation* PACKAGE qualifiedName ';' EOF
    ;

importDeclaration_DropletFile
    : IMPORT STATIC? qualifiedName ('.' '*')? ';' * EOF
    ;

typeDeclaration_DropletFile
    : classOrInterfaceModifier*
      (classDeclaration | enumDeclaration | interfaceDeclaration | annotationTypeDeclaration) EOF
    | ';' EOF
    ;

modifier_DropletFile
    : classOrInterfaceModifier EOF
    | NATIVE EOF
    | SYNCHRONIZED EOF
    | TRANSIENT EOF
    | VOLATILE EOF
    ;

classOrInterfaceModifier_DropletFile
    : annotation EOF
    | PUBLIC EOF
    | PROTECTED EOF
    | PRIVATE EOF
    | STATIC EOF
    | ABSTRACT EOF
    | FINAL EOF    // FINAL for class only -- does not apply to interfaces
    | STRICTFP EOF
    ;

variableModifier_DropletFile
    : FINAL EOF
    | annotation EOF
    ;

classDeclaration_DropletFile
    : CLASS IDENTIFIER typeParameters?
      (EXTENDS typeType)?
      (IMPLEMENTS typeList)?
      classBody EOF
    ;

typeParameters_DropletFile
    : '<' typeParameter (',' typeParameter)* '>' EOF
    ;

typeParameter_DropletFile
    : annotation* IDENTIFIER (EXTENDS typeBound)? EOF
    ;

typeBound_DropletFile
    : typeType ('&' typeType)* EOF
    ;

enumDeclaration_DropletFile
    : ENUM IDENTIFIER (IMPLEMENTS typeList)? '{' enumConstants? ','? enumBodyDeclarations? '}' EOF
    ;

enumConstants_DropletFile
    : enumConstant (',' enumConstant)* EOF
    ;

enumConstant_DropletFile
    : annotation* IDENTIFIER arguments? classBody? EOF
    ;

enumBodyDeclarations_DropletFile
    : ';' classBodyDeclaration* EOF
    ;

interfaceDeclaration_DropletFile
    : INTERFACE IDENTIFIER typeParameters? (EXTENDS typeList)? interfaceBody EOF
    ;

classBody_DropletFile
    : '{' classBodyDeclaration* '}' EOF
    ;

interfaceBody_DropletFile
    : '{' interfaceBodyDeclaration* '}' EOF
    ;

classBodyDeclaration_DropletFile
    : ';' EOF
    | STATIC? block EOF
    | modifier* memberDeclaration EOF
    ;

memberDeclaration_DropletFile
    : methodDeclaration EOF
    | genericMethodDeclaration EOF
    | fieldDeclaration EOF
    | constructorDeclaration EOF
    | genericConstructorDeclaration EOF
    | interfaceDeclaration EOF
    | annotationTypeDeclaration EOF
    | classDeclaration EOF
    | enumDeclaration EOF
    ;

/* We use rule this even for void methods which cannot have [] after parameters.
   This simplifies grammar and we can consider void to be a type, which
   renders the [] matching as a context-sensitive issue or a semantic check
   for invalid return type after parsing.
 */
methodDeclaration_DropletFile
    : typeTypeOrVoid IDENTIFIER formalParameters ('[' ']')*
      (THROWS qualifiedNameList)?
      methodBody EOF
    ;

methodBody_DropletFile
    : block EOF
    | ';' EOF
    ;

typeTypeOrVoid_DropletFile
    : typeType EOF
    | VOID EOF
    ;

genericMethodDeclaration_DropletFile
    : typeParameters methodDeclaration EOF
    ;

genericConstructorDeclaration_DropletFile
    : typeParameters constructorDeclaration EOF
    ;

constructorDeclaration_DropletFile
    : IDENTIFIER formalParameters (THROWS qualifiedNameList)? constructorBody=block EOF
    ;

fieldDeclaration_DropletFile
    : typeType variableDeclarators ';' EOF
    ;

interfaceBodyDeclaration_DropletFile
    : modifier* interfaceMemberDeclaration EOF
    | ';' EOF
    ;

interfaceMemberDeclaration_DropletFile
    : constDeclaration EOF
    | interfaceMethodDeclaration EOF
    | genericInterfaceMethodDeclaration EOF
    | interfaceDeclaration EOF
    | annotationTypeDeclaration EOF
    | classDeclaration EOF
    | enumDeclaration EOF
    ;

constDeclaration_DropletFile
    : typeType constantDeclarator (',' constantDeclarator)* ';' EOF
    ;

constantDeclarator_DropletFile
    : IDENTIFIER ('[' ']')* '=' variableInitializer EOF
    ;

// see matching of [] comment in methodDeclaratorRest
// methodBody from Java8
interfaceMethodDeclaration_DropletFile
    : interfaceMethodModifier* (typeTypeOrVoid | typeParameters annotation* typeTypeOrVoid)
      IDENTIFIER formalParameters ('[' ']')* (THROWS qualifiedNameList)? methodBody EOF
    ;

// Java8
interfaceMethodModifier_DropletFile
    : annotation EOF
    | PUBLIC EOF
    | ABSTRACT EOF
    | DEFAULT EOF
    | STATIC EOF
    | STRICTFP EOF
    ;

genericInterfaceMethodDeclaration_DropletFile
    : typeParameters interfaceMethodDeclaration EOF
    ;

variableDeclarators_DropletFile
    : variableDeclarator (',' variableDeclarator)* EOF
    ;

variableDeclarator_DropletFile
    : variableDeclaratorId ('=' variableInitializer)? EOF
    ;

variableDeclaratorId_DropletFile
    : IDENTIFIER ('[' ']')* EOF
    ;

variableInitializer_DropletFile
    : arrayInitializer EOF
    | expression EOF
    ;

arrayInitializer_DropletFile
    : '{' (variableInitializer (',' variableInitializer)* (',')? )? '}' EOF
    ;

classOrInterfaceType_DropletFile
    : IDENTIFIER typeArguments? ('.' IDENTIFIER typeArguments?)* EOF
    ;

typeArgument_DropletFile
    : typeType EOF
    | '?' ((EXTENDS | SUPER) typeType)? EOF
    ;

qualifiedNameList_DropletFile
    : qualifiedName (',' qualifiedName)* EOF
    ;

formalParameters_DropletFile
    : '(' formalParameterList? ')' EOF
    ;

formalParameterList_DropletFile
    : formalParameter (',' formalParameter)* (',' lastFormalParameter)? EOF
    | lastFormalParameter EOF
    ;

formalParameter_DropletFile
    : variableModifier* typeType variableDeclaratorId EOF
    ;

lastFormalParameter_DropletFile
    : variableModifier* typeType '...' variableDeclaratorId EOF
    ;

qualifiedName_DropletFile
    : IDENTIFIER ('.' IDENTIFIER)* EOF
    ;

literal_DropletFile
    : integerLiteral EOF
    | floatLiteral EOF
    | CHAR_LITERAL EOF
    | STRING_LITERAL EOF
    | BOOL_LITERAL EOF
    | NULL_LITERAL EOF
    ;

integerLiteral_DropletFile
    : DECIMAL_LITERAL EOF
    | HEX_LITERAL EOF
    | OCT_LITERAL EOF
    | BINARY_LITERAL EOF
    ;

floatLiteral_DropletFile
    : FLOAT_LITERAL EOF
    | HEX_FLOAT_LITERAL EOF
    ;

// ANNOTATIONS

annotation_DropletFile
    : '@' qualifiedName ('(' ( elementValuePairs | elementValue )? ')')? EOF
    ;

elementValuePairs_DropletFile
    : elementValuePair (',' elementValuePair)* EOF
    ;

elementValuePair_DropletFile
    : IDENTIFIER '=' elementValue EOF
    ;

elementValue_DropletFile
    : expression EOF
    | annotation EOF
    | elementValueArrayInitializer EOF
    ;

elementValueArrayInitializer_DropletFile
    : '{' (elementValue (',' elementValue)*)? (',')? '}' EOF
    ;

annotationTypeDeclaration_DropletFile
    : '@' INTERFACE IDENTIFIER annotationTypeBody EOF
    ;

annotationTypeBody_DropletFile
    : '{' (annotationTypeElementDeclaration)* '}' EOF
    ;

annotationTypeElementDeclaration_DropletFile
    : modifier* annotationTypeElementRest EOF
    | ';' EOF // this is not allowed by the grammar, but apparently allowed by the actual compiler
    ;

annotationTypeElementRest_DropletFile
    : typeType annotationMethodOrConstantRest ';' EOF
    | classDeclaration ';'? EOF
    | interfaceDeclaration ';'? EOF
    | enumDeclaration ';'? EOF
    | annotationTypeDeclaration ';'? EOF
    ;

annotationMethodOrConstantRest_DropletFile
    : annotationMethodRest EOF
    | annotationConstantRest EOF
    ;

annotationMethodRest_DropletFile
    : IDENTIFIER '(' ')' defaultValue? EOF
    ;

annotationConstantRest_DropletFile
    : variableDeclarators EOF
    ;

defaultValue_DropletFile
    : DEFAULT elementValue EOF
    ;

// STATEMENTS / BLOCKS

block_DropletFile
    : '{' blockStatement* '}' EOF
    ;

blockStatement_DropletFile
    : localVariableDeclaration ';' EOF
    | statement EOF
    | localTypeDeclaration EOF
    ;

localVariableDeclaration_DropletFile
    : variableModifier* typeType variableDeclarators EOF
    ;

localTypeDeclaration_DropletFile
    : classOrInterfaceModifier*
      (classDeclaration | interfaceDeclaration) EOF
    | ';' EOF
    ;

statement_DropletFile
    : blockLabel=block EOF
    | ASSERT expression (':' expression)? ';' EOF
    | IF parExpression statement (ELSE statement)? EOF
    | FOR '(' forControl ')' statement EOF
    | WHILE parExpression statement EOF
    | DO statement WHILE parExpression ';' EOF
    | TRY block (catchClause+ finallyBlock? | finallyBlock) EOF
    | TRY resourceSpecification block catchClause* finallyBlock? EOF
    | SWITCH parExpression '{' switchBlockStatementGroup* switchLabel* '}' EOF
    | SYNCHRONIZED parExpression block EOF
    | RETURN expression? ';' EOF
    | THROW expression ';' EOF
    | BREAK IDENTIFIER? ';' EOF
    | CONTINUE IDENTIFIER? ';' EOF
    | SEMI EOF
    | statementExpression=expression ';' EOF
    | identifierLabel=IDENTIFIER ':' statement EOF
    ;

catchClause_DropletFile
    : CATCH '(' variableModifier* catchType IDENTIFIER ')' block EOF
    ;

catchType_DropletFile
    : qualifiedName ('|' qualifiedName)* EOF
    ;

finallyBlock_DropletFile
    : FINALLY block EOF
    ;

resourceSpecification_DropletFile
    : '(' resources ';'? ')' EOF
    ;

resources_DropletFile
    : resource (';' resource)* EOF
    ;

resource_DropletFile
    : variableModifier* classOrInterfaceType variableDeclaratorId '=' expression EOF
    ;

/** Matches cases then statements, both of which are mandatory.
 *  To handle empty cases at the end, we add switchLabel* to statement.
 */
switchBlockStatementGroup_DropletFile
    : switchLabel+ blockStatement+ EOF
    ;

switchLabel_DropletFile
    : CASE (constantExpression=expression | enumConstantName=IDENTIFIER) ':' EOF
    | DEFAULT ':' EOF
    ;

forControl_DropletFile
    : enhancedForControl EOF
    | forInit? ';' expression? ';' forUpdate=expressionList? EOF
    ;

forInit_DropletFile
    : localVariableDeclaration EOF
    | expressionList EOF
    ;

enhancedForControl_DropletFile
    : variableModifier* typeType variableDeclaratorId ':' expression EOF
    ;

// EXPRESSIONS

parExpression_DropletFile
    : '(' expression ')' EOF
    ;

expressionList_DropletFile
    : expression (',' expression)* EOF
    ;

methodCall_DropletFile
    : IDENTIFIER '(' expressionList? ')' EOF
    ;

expression_DropletFile
    : primary EOF
    | expression bop='.'
      ( IDENTIFIER
      | methodCall
      | THIS
      | NEW nonWildcardTypeArguments? innerCreator
      | SUPER superSuffix
      | explicitGenericInvocation
      ) EOF
    | expression '[' expression ']' EOF
    | methodCall EOF
    | NEW creator EOF
    | '(' typeType ')' expression EOF
    | expression postfix=('++' | '--') EOF
    | prefix=('+'|'-'|'++'|'--') expression EOF
    | prefix=('~'|'!') expression EOF
    | expression bop=('*'|'/'|'%') expression EOF
    | expression bop=('+'|'-') expression EOF
    | expression ('<' '<' | '>' '>' '>' | '>' '>') expression EOF
    | expression bop=('<=' | '>=' | '>' | '<') expression EOF
    | expression bop=INSTANCEOF typeType EOF
    | expression bop=('==' | '!=') expression EOF
    | expression bop='&' expression EOF
    | expression bop='^' expression EOF
    | expression bop='|' expression EOF
    | expression bop='&&' expression EOF
    | expression bop='||' expression EOF
    | expression bop='?' expression ':' expression EOF
    | <assoc=right> expression
      bop=('=' | '+=' | '-=' | '*=' | '/=' | '&=' | '|=' | '^=' | '>>=' | '>>>=' | '<<=' | '%=')
      expression EOF
    | lambdaExpression  EOF // Java8

    // Java 8 methodReference
    | expression '::' typeArguments? IDENTIFIER EOF
    | typeType '::' (typeArguments? IDENTIFIER | NEW) EOF
    | classType '::' typeArguments? NEW EOF
    ;

// Java8
lambdaExpression_DropletFile
    : lambdaParameters '->' lambdaBody EOF
    ;

// Java8
lambdaParameters_DropletFile
    : IDENTIFIER EOF
    | '(' formalParameterList? ')' EOF
    | '(' IDENTIFIER (',' IDENTIFIER)* ')' EOF
    ;

// Java8
lambdaBody_DropletFile
    : expression EOF
    | block EOF
    ;

primary_DropletFile
    : '(' expression ')' EOF
    | THIS EOF
    | SUPER EOF
    | literal EOF
    | IDENTIFIER EOF
    | typeTypeOrVoid '.' CLASS EOF
    | nonWildcardTypeArguments (explicitGenericInvocationSuffix | THIS arguments) EOF
    ;

classType_DropletFile
    : (classOrInterfaceType '.')? annotation* IDENTIFIER typeArguments? EOF
    ;

creator_DropletFile
    : nonWildcardTypeArguments createdName classCreatorRest EOF
    | createdName (arrayCreatorRest | classCreatorRest) EOF
    ;

createdName_DropletFile
    : IDENTIFIER typeArgumentsOrDiamond? ('.' IDENTIFIER typeArgumentsOrDiamond?)* EOF
    | primitiveType EOF
    ;

innerCreator_DropletFile
    : IDENTIFIER nonWildcardTypeArgumentsOrDiamond? classCreatorRest EOF
    ;

arrayCreatorRest_DropletFile
    : '[' (']' ('[' ']')* arrayInitializer | expression ']' ('[' expression ']')* ('[' ']')*) EOF
    ;

classCreatorRest_DropletFile
    : arguments classBody? EOF
    ;

explicitGenericInvocation_DropletFile
    : nonWildcardTypeArguments explicitGenericInvocationSuffix EOF
    ;

typeArgumentsOrDiamond_DropletFile
    : '<' '>' EOF
    | typeArguments EOF
    ;

nonWildcardTypeArgumentsOrDiamond_DropletFile
    : '<' '>' EOF
    | nonWildcardTypeArguments EOF
    ;

nonWildcardTypeArguments_DropletFile
    : '<' typeList '>' EOF
    ;

typeList_DropletFile
    : typeType (',' typeType)* EOF
    ;

typeType_DropletFile
    : annotation? (classOrInterfaceType | primitiveType) ('[' ']')* EOF
    ;

primitiveType_DropletFile
    : BOOLEAN EOF
    | CHAR EOF
    | BYTE EOF
    | SHORT EOF
    | INT EOF
    | LONG EOF
    | FLOAT EOF
    | DOUBLE EOF
    ;

typeArguments_DropletFile
    : '<' typeArgument (',' typeArgument)* '>' EOF
    ;

superSuffix_DropletFile
    : arguments EOF
    | '.' IDENTIFIER arguments? EOF
    ;

explicitGenericInvocationSuffix_DropletFile
    : SUPER superSuffix EOF
    | IDENTIFIER arguments EOF
    ;

arguments_DropletFile
    : '(' expressionList? ')' EOF
    ;
