
// Generated from Java.g4 by ANTLR 4.7.1

#pragma once


#include "antlr4-runtime.h"




class  JavaParser : public antlr4::Parser {
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

  enum {
    RuleLiteral = 0, RulePrimitiveType = 1, RuleNumericType = 2, RuleIntegralType = 3, 
    RuleFloatingPointType = 4, RuleReferenceType = 5, RuleClassOrInterfaceType = 6, 
    RuleClassType = 7, RuleClassType_lf_classOrInterfaceType = 8, RuleClassType_lfno_classOrInterfaceType = 9, 
    RuleInterfaceType = 10, RuleInterfaceType_lf_classOrInterfaceType = 11, 
    RuleInterfaceType_lfno_classOrInterfaceType = 12, RuleTypeVariable = 13, 
    RuleArrayType = 14, RuleDims = 15, RuleTypeParameter = 16, RuleTypeParameterModifier = 17, 
    RuleTypeBound = 18, RuleAdditionalBound = 19, RuleTypeArguments = 20, 
    RuleTypeArgumentList = 21, RuleTypeArgument = 22, RuleWildcard = 23, 
    RuleWildcardBounds = 24, RuleModuleName = 25, RulePackageName = 26, 
    RuleTypeName = 27, RulePackageOrTypeName = 28, RuleExpressionName = 29, 
    RuleMethodName = 30, RuleAmbiguousName = 31, RuleCompilationUnit = 32, 
    RuleOrdinaryCompilation = 33, RuleModularCompilation = 34, RulePackageDeclaration = 35, 
    RulePackageModifier = 36, RuleImportDeclaration = 37, RuleSingleTypeImportDeclaration = 38, 
    RuleTypeImportOnDemandDeclaration = 39, RuleSingleStaticImportDeclaration = 40, 
    RuleStaticImportOnDemandDeclaration = 41, RuleTypeDeclaration = 42, 
    RuleModuleDeclaration = 43, RuleModuleDirective = 44, RuleRequiresModifier = 45, 
    RuleClassDeclaration = 46, RuleNormalClassDeclaration = 47, RuleClassModifier = 48, 
    RuleTypeParameters = 49, RuleTypeParameterList = 50, RuleSuperclass = 51, 
    RuleSuperinterfaces = 52, RuleInterfaceTypeList = 53, RuleClassBody = 54, 
    RuleClassBodyDeclaration = 55, RuleClassMemberDeclaration = 56, RuleFieldDeclaration = 57, 
    RuleFieldModifier = 58, RuleVariableDeclaratorList = 59, RuleVariableDeclarator = 60, 
    RuleVariableDeclaratorId = 61, RuleVariableInitializer = 62, RuleUnannType = 63, 
    RuleUnannPrimitiveType = 64, RuleUnannReferenceType = 65, RuleUnannClassOrInterfaceType = 66, 
    RuleUnannClassType = 67, RuleUnannClassType_lf_unannClassOrInterfaceType = 68, 
    RuleUnannClassType_lfno_unannClassOrInterfaceType = 69, RuleUnannInterfaceType = 70, 
    RuleUnannInterfaceType_lf_unannClassOrInterfaceType = 71, RuleUnannInterfaceType_lfno_unannClassOrInterfaceType = 72, 
    RuleUnannTypeVariable = 73, RuleUnannArrayType = 74, RuleMethodDeclaration = 75, 
    RuleMethodModifier = 76, RuleMethodHeader = 77, RuleResult = 78, RuleMethodDeclarator = 79, 
    RuleFormalParameterList = 80, RuleFormalParameters = 81, RuleFormalParameter = 82, 
    RuleVariableModifier = 83, RuleLastFormalParameter = 84, RuleReceiverParameter = 85, 
    RuleThrows_ = 86, RuleExceptionTypeList = 87, RuleExceptionType = 88, 
    RuleMethodBody = 89, RuleInstanceInitializer = 90, RuleStaticInitializer = 91, 
    RuleConstructorDeclaration = 92, RuleConstructorModifier = 93, RuleConstructorDeclarator = 94, 
    RuleSimpleTypeName = 95, RuleConstructorBody = 96, RuleExplicitConstructorInvocation = 97, 
    RuleEnumDeclaration = 98, RuleEnumBody = 99, RuleEnumConstantList = 100, 
    RuleEnumConstant = 101, RuleEnumConstantModifier = 102, RuleEnumBodyDeclarations = 103, 
    RuleInterfaceDeclaration = 104, RuleNormalInterfaceDeclaration = 105, 
    RuleInterfaceModifier = 106, RuleExtendsInterfaces = 107, RuleInterfaceBody = 108, 
    RuleInterfaceMemberDeclaration = 109, RuleConstantDeclaration = 110, 
    RuleConstantModifier = 111, RuleInterfaceMethodDeclaration = 112, RuleInterfaceMethodModifier = 113, 
    RuleAnnotationTypeDeclaration = 114, RuleAnnotationTypeBody = 115, RuleAnnotationTypeMemberDeclaration = 116, 
    RuleAnnotationTypeElementDeclaration = 117, RuleAnnotationTypeElementModifier = 118, 
    RuleDefaultValue = 119, RuleAnnotation = 120, RuleNormalAnnotation = 121, 
    RuleElementValuePairList = 122, RuleElementValuePair = 123, RuleElementValue = 124, 
    RuleElementValueArrayInitializer = 125, RuleElementValueList = 126, 
    RuleMarkerAnnotation = 127, RuleSingleElementAnnotation = 128, RuleArrayInitializer = 129, 
    RuleVariableInitializerList = 130, RuleBlock = 131, RuleBlockStatements = 132, 
    RuleBlockStatement = 133, RuleLocalVariableDeclarationStatement = 134, 
    RuleLocalVariableDeclaration = 135, RuleStatement = 136, RuleStatementNoShortIf = 137, 
    RuleStatementWithoutTrailingSubstatement = 138, RuleEmptyStatement = 139, 
    RuleLabeledStatement = 140, RuleLabeledStatementNoShortIf = 141, RuleExpressionStatement = 142, 
    RuleStatementExpression = 143, RuleIfThenStatement = 144, RuleIfThenElseStatement = 145, 
    RuleIfThenElseStatementNoShortIf = 146, RuleAssertStatement = 147, RuleSwitchStatement = 148, 
    RuleSwitchBlock = 149, RuleSwitchBlockStatementGroup = 150, RuleSwitchLabels = 151, 
    RuleSwitchLabel = 152, RuleEnumConstantName = 153, RuleWhileStatement = 154, 
    RuleWhileStatementNoShortIf = 155, RuleDoStatement = 156, RuleForStatement = 157, 
    RuleForStatementNoShortIf = 158, RuleBasicForStatement = 159, RuleBasicForStatementNoShortIf = 160, 
    RuleForInit = 161, RuleForUpdate = 162, RuleStatementExpressionList = 163, 
    RuleEnhancedForStatement = 164, RuleEnhancedForStatementNoShortIf = 165, 
    RuleBreakStatement = 166, RuleContinueStatement = 167, RuleReturnStatement = 168, 
    RuleThrowStatement = 169, RuleSynchronizedStatement = 170, RuleTryStatement = 171, 
    RuleCatches = 172, RuleCatchClause = 173, RuleCatchFormalParameter = 174, 
    RuleCatchType = 175, RuleFinally_ = 176, RuleTryWithResourcesStatement = 177, 
    RuleResourceSpecification = 178, RuleResourceList = 179, RuleResource = 180, 
    RuleVariableAccess = 181, RulePrimary = 182, RulePrimaryNoNewArray = 183, 
    RulePrimaryNoNewArray_lf_arrayAccess = 184, RulePrimaryNoNewArray_lfno_arrayAccess = 185, 
    RulePrimaryNoNewArray_lf_primary = 186, RulePrimaryNoNewArray_lf_primary_lf_arrayAccess_lf_primary = 187, 
    RulePrimaryNoNewArray_lf_primary_lfno_arrayAccess_lf_primary = 188, 
    RulePrimaryNoNewArray_lfno_primary = 189, RulePrimaryNoNewArray_lfno_primary_lf_arrayAccess_lfno_primary = 190, 
    RulePrimaryNoNewArray_lfno_primary_lfno_arrayAccess_lfno_primary = 191, 
    RuleClassLiteral = 192, RuleClassInstanceCreationExpression = 193, RuleClassInstanceCreationExpression_lf_primary = 194, 
    RuleClassInstanceCreationExpression_lfno_primary = 195, RuleTypeArgumentsOrDiamond = 196, 
    RuleFieldAccess = 197, RuleFieldAccess_lf_primary = 198, RuleFieldAccess_lfno_primary = 199, 
    RuleArrayAccess = 200, RuleArrayAccess_lf_primary = 201, RuleArrayAccess_lfno_primary = 202, 
    RuleMethodInvocation = 203, RuleMethodInvocation_lf_primary = 204, RuleMethodInvocation_lfno_primary = 205, 
    RuleArgumentList = 206, RuleMethodReference = 207, RuleMethodReference_lf_primary = 208, 
    RuleMethodReference_lfno_primary = 209, RuleArrayCreationExpression = 210, 
    RuleDimExprs = 211, RuleDimExpr = 212, RuleConstantExpression = 213, 
    RuleExpression = 214, RuleLambdaExpression = 215, RuleLambdaParameters = 216, 
    RuleInferredFormalParameterList = 217, RuleLambdaBody = 218, RuleAssignmentExpression = 219, 
    RuleAssignment = 220, RuleLeftHandSide = 221, RuleAssignmentOperator = 222, 
    RuleConditionalExpression = 223, RuleConditionalOrExpression = 224, 
    RuleConditionalAndExpression = 225, RuleInclusiveOrExpression = 226, 
    RuleExclusiveOrExpression = 227, RuleAndExpression = 228, RuleEqualityExpression = 229, 
    RuleRelationalExpression = 230, RuleShiftExpression = 231, RuleAdditiveExpression = 232, 
    RuleMultiplicativeExpression = 233, RuleUnaryExpression = 234, RulePreIncrementExpression = 235, 
    RulePreDecrementExpression = 236, RuleUnaryExpressionNotPlusMinus = 237, 
    RulePostfixExpression = 238, RulePostIncrementExpression = 239, RulePostIncrementExpression_lf_postfixExpression = 240, 
    RulePostDecrementExpression = 241, RulePostDecrementExpression_lf_postfixExpression = 242, 
    RuleCastExpression = 243, RuleLiteral_DropletFile = 244, RulePrimitiveType_DropletFile = 245, 
    RuleNumericType_DropletFile = 246, RuleIntegralType_DropletFile = 247, 
    RuleFloatingPointType_DropletFile = 248, RuleReferenceType_DropletFile = 249, 
    RuleClassOrInterfaceType_DropletFile = 250, RuleClassType_DropletFile = 251, 
    RuleClassType_lf_classOrInterfaceType_DropletFile = 252, RuleClassType_lfno_classOrInterfaceType_DropletFile = 253, 
    RuleInterfaceType_DropletFile = 254, RuleInterfaceType_lf_classOrInterfaceType_DropletFile = 255, 
    RuleInterfaceType_lfno_classOrInterfaceType_DropletFile = 256, RuleTypeVariable_DropletFile = 257, 
    RuleArrayType_DropletFile = 258, RuleDims_DropletFile = 259, RuleTypeParameter_DropletFile = 260, 
    RuleTypeParameterModifier_DropletFile = 261, RuleTypeBound_DropletFile = 262, 
    RuleAdditionalBound_DropletFile = 263, RuleTypeArguments_DropletFile = 264, 
    RuleTypeArgumentList_DropletFile = 265, RuleTypeArgument_DropletFile = 266, 
    RuleWildcard_DropletFile = 267, RuleWildcardBounds_DropletFile = 268, 
    RuleModuleName_DropletFile = 269, RulePackageName_DropletFile = 270, 
    RuleTypeName_DropletFile = 271, RulePackageOrTypeName_DropletFile = 272, 
    RuleExpressionName_DropletFile = 273, RuleMethodName_DropletFile = 274, 
    RuleAmbiguousName_DropletFile = 275, RuleCompilationUnit_DropletFile = 276, 
    RuleOrdinaryCompilation_DropletFile = 277, RuleModularCompilation_DropletFile = 278, 
    RulePackageDeclaration_DropletFile = 279, RulePackageModifier_DropletFile = 280, 
    RuleImportDeclaration_DropletFile = 281, RuleSingleTypeImportDeclaration_DropletFile = 282, 
    RuleTypeImportOnDemandDeclaration_DropletFile = 283, RuleSingleStaticImportDeclaration_DropletFile = 284, 
    RuleStaticImportOnDemandDeclaration_DropletFile = 285, RuleTypeDeclaration_DropletFile = 286, 
    RuleModuleDeclaration_DropletFile = 287, RuleModuleDirective_DropletFile = 288, 
    RuleRequiresModifier_DropletFile = 289, RuleClassDeclaration_DropletFile = 290, 
    RuleNormalClassDeclaration_DropletFile = 291, RuleClassModifier_DropletFile = 292, 
    RuleTypeParameters_DropletFile = 293, RuleTypeParameterList_DropletFile = 294, 
    RuleSuperclass_DropletFile = 295, RuleSuperinterfaces_DropletFile = 296, 
    RuleInterfaceTypeList_DropletFile = 297, RuleClassBody_DropletFile = 298, 
    RuleClassBodyDeclaration_DropletFile = 299, RuleClassMemberDeclaration_DropletFile = 300, 
    RuleFieldDeclaration_DropletFile = 301, RuleFieldModifier_DropletFile = 302, 
    RuleVariableDeclaratorList_DropletFile = 303, RuleVariableDeclarator_DropletFile = 304, 
    RuleVariableDeclaratorId_DropletFile = 305, RuleVariableInitializer_DropletFile = 306, 
    RuleUnannType_DropletFile = 307, RuleUnannPrimitiveType_DropletFile = 308, 
    RuleUnannReferenceType_DropletFile = 309, RuleUnannClassOrInterfaceType_DropletFile = 310, 
    RuleUnannClassType_DropletFile = 311, RuleUnannClassType_lf_unannClassOrInterfaceType_DropletFile = 312, 
    RuleUnannClassType_lfno_unannClassOrInterfaceType_DropletFile = 313, 
    RuleUnannInterfaceType_DropletFile = 314, RuleUnannInterfaceType_lf_unannClassOrInterfaceType_DropletFile = 315, 
    RuleUnannInterfaceType_lfno_unannClassOrInterfaceType_DropletFile = 316, 
    RuleUnannTypeVariable_DropletFile = 317, RuleUnannArrayType_DropletFile = 318, 
    RuleMethodDeclaration_DropletFile = 319, RuleMethodModifier_DropletFile = 320, 
    RuleMethodHeader_DropletFile = 321, RuleResult_DropletFile = 322, RuleMethodDeclarator_DropletFile = 323, 
    RuleFormalParameterList_DropletFile = 324, RuleFormalParameters_DropletFile = 325, 
    RuleFormalParameter_DropletFile = 326, RuleVariableModifier_DropletFile = 327, 
    RuleLastFormalParameter_DropletFile = 328, RuleReceiverParameter_DropletFile = 329, 
    RuleThrows__DropletFile = 330, RuleExceptionTypeList_DropletFile = 331, 
    RuleExceptionType_DropletFile = 332, RuleMethodBody_DropletFile = 333, 
    RuleInstanceInitializer_DropletFile = 334, RuleStaticInitializer_DropletFile = 335, 
    RuleConstructorDeclaration_DropletFile = 336, RuleConstructorModifier_DropletFile = 337, 
    RuleConstructorDeclarator_DropletFile = 338, RuleSimpleTypeName_DropletFile = 339, 
    RuleConstructorBody_DropletFile = 340, RuleExplicitConstructorInvocation_DropletFile = 341, 
    RuleEnumDeclaration_DropletFile = 342, RuleEnumBody_DropletFile = 343, 
    RuleEnumConstantList_DropletFile = 344, RuleEnumConstant_DropletFile = 345, 
    RuleEnumConstantModifier_DropletFile = 346, RuleEnumBodyDeclarations_DropletFile = 347, 
    RuleInterfaceDeclaration_DropletFile = 348, RuleNormalInterfaceDeclaration_DropletFile = 349, 
    RuleInterfaceModifier_DropletFile = 350, RuleExtendsInterfaces_DropletFile = 351, 
    RuleInterfaceBody_DropletFile = 352, RuleInterfaceMemberDeclaration_DropletFile = 353, 
    RuleConstantDeclaration_DropletFile = 354, RuleConstantModifier_DropletFile = 355, 
    RuleInterfaceMethodDeclaration_DropletFile = 356, RuleInterfaceMethodModifier_DropletFile = 357, 
    RuleAnnotationTypeDeclaration_DropletFile = 358, RuleAnnotationTypeBody_DropletFile = 359, 
    RuleAnnotationTypeMemberDeclaration_DropletFile = 360, RuleAnnotationTypeElementDeclaration_DropletFile = 361, 
    RuleAnnotationTypeElementModifier_DropletFile = 362, RuleDefaultValue_DropletFile = 363, 
    RuleAnnotation_DropletFile = 364, RuleNormalAnnotation_DropletFile = 365, 
    RuleElementValuePairList_DropletFile = 366, RuleElementValuePair_DropletFile = 367, 
    RuleElementValue_DropletFile = 368, RuleElementValueArrayInitializer_DropletFile = 369, 
    RuleElementValueList_DropletFile = 370, RuleMarkerAnnotation_DropletFile = 371, 
    RuleSingleElementAnnotation_DropletFile = 372, RuleArrayInitializer_DropletFile = 373, 
    RuleVariableInitializerList_DropletFile = 374, RuleBlock_DropletFile = 375, 
    RuleBlockStatements_DropletFile = 376, RuleBlockStatement_DropletFile = 377, 
    RuleLocalVariableDeclarationStatement_DropletFile = 378, RuleLocalVariableDeclaration_DropletFile = 379, 
    RuleStatement_DropletFile = 380, RuleStatementNoShortIf_DropletFile = 381, 
    RuleStatementWithoutTrailingSubstatement_DropletFile = 382, RuleEmptyStatement_DropletFile = 383, 
    RuleLabeledStatement_DropletFile = 384, RuleLabeledStatementNoShortIf_DropletFile = 385, 
    RuleExpressionStatement_DropletFile = 386, RuleStatementExpression_DropletFile = 387, 
    RuleIfThenStatement_DropletFile = 388, RuleIfThenElseStatement_DropletFile = 389, 
    RuleIfThenElseStatementNoShortIf_DropletFile = 390, RuleAssertStatement_DropletFile = 391, 
    RuleSwitchStatement_DropletFile = 392, RuleSwitchBlock_DropletFile = 393, 
    RuleSwitchBlockStatementGroup_DropletFile = 394, RuleSwitchLabels_DropletFile = 395, 
    RuleSwitchLabel_DropletFile = 396, RuleEnumConstantName_DropletFile = 397, 
    RuleWhileStatement_DropletFile = 398, RuleWhileStatementNoShortIf_DropletFile = 399, 
    RuleDoStatement_DropletFile = 400, RuleForStatement_DropletFile = 401, 
    RuleForStatementNoShortIf_DropletFile = 402, RuleBasicForStatement_DropletFile = 403, 
    RuleBasicForStatementNoShortIf_DropletFile = 404, RuleForInit_DropletFile = 405, 
    RuleForUpdate_DropletFile = 406, RuleStatementExpressionList_DropletFile = 407, 
    RuleEnhancedForStatement_DropletFile = 408, RuleEnhancedForStatementNoShortIf_DropletFile = 409, 
    RuleBreakStatement_DropletFile = 410, RuleContinueStatement_DropletFile = 411, 
    RuleReturnStatement_DropletFile = 412, RuleThrowStatement_DropletFile = 413, 
    RuleSynchronizedStatement_DropletFile = 414, RuleTryStatement_DropletFile = 415, 
    RuleCatches_DropletFile = 416, RuleCatchClause_DropletFile = 417, RuleCatchFormalParameter_DropletFile = 418, 
    RuleCatchType_DropletFile = 419, RuleFinally__DropletFile = 420, RuleTryWithResourcesStatement_DropletFile = 421, 
    RuleResourceSpecification_DropletFile = 422, RuleResourceList_DropletFile = 423, 
    RuleResource_DropletFile = 424, RuleVariableAccess_DropletFile = 425, 
    RulePrimary_DropletFile = 426, RulePrimaryNoNewArray_DropletFile = 427, 
    RulePrimaryNoNewArray_lf_arrayAccess_DropletFile = 428, RulePrimaryNoNewArray_lfno_arrayAccess_DropletFile = 429, 
    RulePrimaryNoNewArray_lf_primary_DropletFile = 430, RulePrimaryNoNewArray_lf_primary_lf_arrayAccess_lf_primary_DropletFile = 431, 
    RulePrimaryNoNewArray_lf_primary_lfno_arrayAccess_lf_primary_DropletFile = 432, 
    RulePrimaryNoNewArray_lfno_primary_DropletFile = 433, RulePrimaryNoNewArray_lfno_primary_lf_arrayAccess_lfno_primary_DropletFile = 434, 
    RulePrimaryNoNewArray_lfno_primary_lfno_arrayAccess_lfno_primary_DropletFile = 435, 
    RuleClassLiteral_DropletFile = 436, RuleClassInstanceCreationExpression_DropletFile = 437, 
    RuleClassInstanceCreationExpression_lf_primary_DropletFile = 438, RuleClassInstanceCreationExpression_lfno_primary_DropletFile = 439, 
    RuleTypeArgumentsOrDiamond_DropletFile = 440, RuleFieldAccess_DropletFile = 441, 
    RuleFieldAccess_lf_primary_DropletFile = 442, RuleFieldAccess_lfno_primary_DropletFile = 443, 
    RuleArrayAccess_DropletFile = 444, RuleArrayAccess_lf_primary_DropletFile = 445, 
    RuleArrayAccess_lfno_primary_DropletFile = 446, RuleMethodInvocation_DropletFile = 447, 
    RuleMethodInvocation_lf_primary_DropletFile = 448, RuleMethodInvocation_lfno_primary_DropletFile = 449, 
    RuleArgumentList_DropletFile = 450, RuleMethodReference_DropletFile = 451, 
    RuleMethodReference_lf_primary_DropletFile = 452, RuleMethodReference_lfno_primary_DropletFile = 453, 
    RuleArrayCreationExpression_DropletFile = 454, RuleDimExprs_DropletFile = 455, 
    RuleDimExpr_DropletFile = 456, RuleConstantExpression_DropletFile = 457, 
    RuleExpression_DropletFile = 458, RuleLambdaExpression_DropletFile = 459, 
    RuleLambdaParameters_DropletFile = 460, RuleInferredFormalParameterList_DropletFile = 461, 
    RuleLambdaBody_DropletFile = 462, RuleAssignmentExpression_DropletFile = 463, 
    RuleAssignment_DropletFile = 464, RuleLeftHandSide_DropletFile = 465, 
    RuleAssignmentOperator_DropletFile = 466, RuleConditionalExpression_DropletFile = 467, 
    RuleConditionalOrExpression_DropletFile = 468, RuleConditionalAndExpression_DropletFile = 469, 
    RuleInclusiveOrExpression_DropletFile = 470, RuleExclusiveOrExpression_DropletFile = 471, 
    RuleAndExpression_DropletFile = 472, RuleEqualityExpression_DropletFile = 473, 
    RuleRelationalExpression_DropletFile = 474, RuleShiftExpression_DropletFile = 475, 
    RuleAdditiveExpression_DropletFile = 476, RuleMultiplicativeExpression_DropletFile = 477, 
    RuleUnaryExpression_DropletFile = 478, RulePreIncrementExpression_DropletFile = 479, 
    RulePreDecrementExpression_DropletFile = 480, RuleUnaryExpressionNotPlusMinus_DropletFile = 481, 
    RulePostfixExpression_DropletFile = 482, RulePostIncrementExpression_DropletFile = 483, 
    RulePostIncrementExpression_lf_postfixExpression_DropletFile = 484, 
    RulePostDecrementExpression_DropletFile = 485, RulePostDecrementExpression_lf_postfixExpression_DropletFile = 486, 
    RuleCastExpression_DropletFile = 487, RuleIdentifier = 488
  };

  JavaParser(antlr4::TokenStream *input);
  ~JavaParser();

  virtual std::string getGrammarFileName() const override;
  virtual const antlr4::atn::ATN& getATN() const override { return _atn; };
  virtual const std::vector<std::string>& getTokenNames() const override { return _tokenNames; }; // deprecated: use vocabulary instead.
  virtual const std::vector<std::string>& getRuleNames() const override;
  virtual antlr4::dfa::Vocabulary& getVocabulary() const override;


  class LiteralContext;
  class PrimitiveTypeContext;
  class NumericTypeContext;
  class IntegralTypeContext;
  class FloatingPointTypeContext;
  class ReferenceTypeContext;
  class ClassOrInterfaceTypeContext;
  class ClassTypeContext;
  class ClassType_lf_classOrInterfaceTypeContext;
  class ClassType_lfno_classOrInterfaceTypeContext;
  class InterfaceTypeContext;
  class InterfaceType_lf_classOrInterfaceTypeContext;
  class InterfaceType_lfno_classOrInterfaceTypeContext;
  class TypeVariableContext;
  class ArrayTypeContext;
  class DimsContext;
  class TypeParameterContext;
  class TypeParameterModifierContext;
  class TypeBoundContext;
  class AdditionalBoundContext;
  class TypeArgumentsContext;
  class TypeArgumentListContext;
  class TypeArgumentContext;
  class WildcardContext;
  class WildcardBoundsContext;
  class ModuleNameContext;
  class PackageNameContext;
  class TypeNameContext;
  class PackageOrTypeNameContext;
  class ExpressionNameContext;
  class MethodNameContext;
  class AmbiguousNameContext;
  class CompilationUnitContext;
  class OrdinaryCompilationContext;
  class ModularCompilationContext;
  class PackageDeclarationContext;
  class PackageModifierContext;
  class ImportDeclarationContext;
  class SingleTypeImportDeclarationContext;
  class TypeImportOnDemandDeclarationContext;
  class SingleStaticImportDeclarationContext;
  class StaticImportOnDemandDeclarationContext;
  class TypeDeclarationContext;
  class ModuleDeclarationContext;
  class ModuleDirectiveContext;
  class RequiresModifierContext;
  class ClassDeclarationContext;
  class NormalClassDeclarationContext;
  class ClassModifierContext;
  class TypeParametersContext;
  class TypeParameterListContext;
  class SuperclassContext;
  class SuperinterfacesContext;
  class InterfaceTypeListContext;
  class ClassBodyContext;
  class ClassBodyDeclarationContext;
  class ClassMemberDeclarationContext;
  class FieldDeclarationContext;
  class FieldModifierContext;
  class VariableDeclaratorListContext;
  class VariableDeclaratorContext;
  class VariableDeclaratorIdContext;
  class VariableInitializerContext;
  class UnannTypeContext;
  class UnannPrimitiveTypeContext;
  class UnannReferenceTypeContext;
  class UnannClassOrInterfaceTypeContext;
  class UnannClassTypeContext;
  class UnannClassType_lf_unannClassOrInterfaceTypeContext;
  class UnannClassType_lfno_unannClassOrInterfaceTypeContext;
  class UnannInterfaceTypeContext;
  class UnannInterfaceType_lf_unannClassOrInterfaceTypeContext;
  class UnannInterfaceType_lfno_unannClassOrInterfaceTypeContext;
  class UnannTypeVariableContext;
  class UnannArrayTypeContext;
  class MethodDeclarationContext;
  class MethodModifierContext;
  class MethodHeaderContext;
  class ResultContext;
  class MethodDeclaratorContext;
  class FormalParameterListContext;
  class FormalParametersContext;
  class FormalParameterContext;
  class VariableModifierContext;
  class LastFormalParameterContext;
  class ReceiverParameterContext;
  class Throws_Context;
  class ExceptionTypeListContext;
  class ExceptionTypeContext;
  class MethodBodyContext;
  class InstanceInitializerContext;
  class StaticInitializerContext;
  class ConstructorDeclarationContext;
  class ConstructorModifierContext;
  class ConstructorDeclaratorContext;
  class SimpleTypeNameContext;
  class ConstructorBodyContext;
  class ExplicitConstructorInvocationContext;
  class EnumDeclarationContext;
  class EnumBodyContext;
  class EnumConstantListContext;
  class EnumConstantContext;
  class EnumConstantModifierContext;
  class EnumBodyDeclarationsContext;
  class InterfaceDeclarationContext;
  class NormalInterfaceDeclarationContext;
  class InterfaceModifierContext;
  class ExtendsInterfacesContext;
  class InterfaceBodyContext;
  class InterfaceMemberDeclarationContext;
  class ConstantDeclarationContext;
  class ConstantModifierContext;
  class InterfaceMethodDeclarationContext;
  class InterfaceMethodModifierContext;
  class AnnotationTypeDeclarationContext;
  class AnnotationTypeBodyContext;
  class AnnotationTypeMemberDeclarationContext;
  class AnnotationTypeElementDeclarationContext;
  class AnnotationTypeElementModifierContext;
  class DefaultValueContext;
  class AnnotationContext;
  class NormalAnnotationContext;
  class ElementValuePairListContext;
  class ElementValuePairContext;
  class ElementValueContext;
  class ElementValueArrayInitializerContext;
  class ElementValueListContext;
  class MarkerAnnotationContext;
  class SingleElementAnnotationContext;
  class ArrayInitializerContext;
  class VariableInitializerListContext;
  class BlockContext;
  class BlockStatementsContext;
  class BlockStatementContext;
  class LocalVariableDeclarationStatementContext;
  class LocalVariableDeclarationContext;
  class StatementContext;
  class StatementNoShortIfContext;
  class StatementWithoutTrailingSubstatementContext;
  class EmptyStatementContext;
  class LabeledStatementContext;
  class LabeledStatementNoShortIfContext;
  class ExpressionStatementContext;
  class StatementExpressionContext;
  class IfThenStatementContext;
  class IfThenElseStatementContext;
  class IfThenElseStatementNoShortIfContext;
  class AssertStatementContext;
  class SwitchStatementContext;
  class SwitchBlockContext;
  class SwitchBlockStatementGroupContext;
  class SwitchLabelsContext;
  class SwitchLabelContext;
  class EnumConstantNameContext;
  class WhileStatementContext;
  class WhileStatementNoShortIfContext;
  class DoStatementContext;
  class ForStatementContext;
  class ForStatementNoShortIfContext;
  class BasicForStatementContext;
  class BasicForStatementNoShortIfContext;
  class ForInitContext;
  class ForUpdateContext;
  class StatementExpressionListContext;
  class EnhancedForStatementContext;
  class EnhancedForStatementNoShortIfContext;
  class BreakStatementContext;
  class ContinueStatementContext;
  class ReturnStatementContext;
  class ThrowStatementContext;
  class SynchronizedStatementContext;
  class TryStatementContext;
  class CatchesContext;
  class CatchClauseContext;
  class CatchFormalParameterContext;
  class CatchTypeContext;
  class Finally_Context;
  class TryWithResourcesStatementContext;
  class ResourceSpecificationContext;
  class ResourceListContext;
  class ResourceContext;
  class VariableAccessContext;
  class PrimaryContext;
  class PrimaryNoNewArrayContext;
  class PrimaryNoNewArray_lf_arrayAccessContext;
  class PrimaryNoNewArray_lfno_arrayAccessContext;
  class PrimaryNoNewArray_lf_primaryContext;
  class PrimaryNoNewArray_lf_primary_lf_arrayAccess_lf_primaryContext;
  class PrimaryNoNewArray_lf_primary_lfno_arrayAccess_lf_primaryContext;
  class PrimaryNoNewArray_lfno_primaryContext;
  class PrimaryNoNewArray_lfno_primary_lf_arrayAccess_lfno_primaryContext;
  class PrimaryNoNewArray_lfno_primary_lfno_arrayAccess_lfno_primaryContext;
  class ClassLiteralContext;
  class ClassInstanceCreationExpressionContext;
  class ClassInstanceCreationExpression_lf_primaryContext;
  class ClassInstanceCreationExpression_lfno_primaryContext;
  class TypeArgumentsOrDiamondContext;
  class FieldAccessContext;
  class FieldAccess_lf_primaryContext;
  class FieldAccess_lfno_primaryContext;
  class ArrayAccessContext;
  class ArrayAccess_lf_primaryContext;
  class ArrayAccess_lfno_primaryContext;
  class MethodInvocationContext;
  class MethodInvocation_lf_primaryContext;
  class MethodInvocation_lfno_primaryContext;
  class ArgumentListContext;
  class MethodReferenceContext;
  class MethodReference_lf_primaryContext;
  class MethodReference_lfno_primaryContext;
  class ArrayCreationExpressionContext;
  class DimExprsContext;
  class DimExprContext;
  class ConstantExpressionContext;
  class ExpressionContext;
  class LambdaExpressionContext;
  class LambdaParametersContext;
  class InferredFormalParameterListContext;
  class LambdaBodyContext;
  class AssignmentExpressionContext;
  class AssignmentContext;
  class LeftHandSideContext;
  class AssignmentOperatorContext;
  class ConditionalExpressionContext;
  class ConditionalOrExpressionContext;
  class ConditionalAndExpressionContext;
  class InclusiveOrExpressionContext;
  class ExclusiveOrExpressionContext;
  class AndExpressionContext;
  class EqualityExpressionContext;
  class RelationalExpressionContext;
  class ShiftExpressionContext;
  class AdditiveExpressionContext;
  class MultiplicativeExpressionContext;
  class UnaryExpressionContext;
  class PreIncrementExpressionContext;
  class PreDecrementExpressionContext;
  class UnaryExpressionNotPlusMinusContext;
  class PostfixExpressionContext;
  class PostIncrementExpressionContext;
  class PostIncrementExpression_lf_postfixExpressionContext;
  class PostDecrementExpressionContext;
  class PostDecrementExpression_lf_postfixExpressionContext;
  class CastExpressionContext;
  class Literal_DropletFileContext;
  class PrimitiveType_DropletFileContext;
  class NumericType_DropletFileContext;
  class IntegralType_DropletFileContext;
  class FloatingPointType_DropletFileContext;
  class ReferenceType_DropletFileContext;
  class ClassOrInterfaceType_DropletFileContext;
  class ClassType_DropletFileContext;
  class ClassType_lf_classOrInterfaceType_DropletFileContext;
  class ClassType_lfno_classOrInterfaceType_DropletFileContext;
  class InterfaceType_DropletFileContext;
  class InterfaceType_lf_classOrInterfaceType_DropletFileContext;
  class InterfaceType_lfno_classOrInterfaceType_DropletFileContext;
  class TypeVariable_DropletFileContext;
  class ArrayType_DropletFileContext;
  class Dims_DropletFileContext;
  class TypeParameter_DropletFileContext;
  class TypeParameterModifier_DropletFileContext;
  class TypeBound_DropletFileContext;
  class AdditionalBound_DropletFileContext;
  class TypeArguments_DropletFileContext;
  class TypeArgumentList_DropletFileContext;
  class TypeArgument_DropletFileContext;
  class Wildcard_DropletFileContext;
  class WildcardBounds_DropletFileContext;
  class ModuleName_DropletFileContext;
  class PackageName_DropletFileContext;
  class TypeName_DropletFileContext;
  class PackageOrTypeName_DropletFileContext;
  class ExpressionName_DropletFileContext;
  class MethodName_DropletFileContext;
  class AmbiguousName_DropletFileContext;
  class CompilationUnit_DropletFileContext;
  class OrdinaryCompilation_DropletFileContext;
  class ModularCompilation_DropletFileContext;
  class PackageDeclaration_DropletFileContext;
  class PackageModifier_DropletFileContext;
  class ImportDeclaration_DropletFileContext;
  class SingleTypeImportDeclaration_DropletFileContext;
  class TypeImportOnDemandDeclaration_DropletFileContext;
  class SingleStaticImportDeclaration_DropletFileContext;
  class StaticImportOnDemandDeclaration_DropletFileContext;
  class TypeDeclaration_DropletFileContext;
  class ModuleDeclaration_DropletFileContext;
  class ModuleDirective_DropletFileContext;
  class RequiresModifier_DropletFileContext;
  class ClassDeclaration_DropletFileContext;
  class NormalClassDeclaration_DropletFileContext;
  class ClassModifier_DropletFileContext;
  class TypeParameters_DropletFileContext;
  class TypeParameterList_DropletFileContext;
  class Superclass_DropletFileContext;
  class Superinterfaces_DropletFileContext;
  class InterfaceTypeList_DropletFileContext;
  class ClassBody_DropletFileContext;
  class ClassBodyDeclaration_DropletFileContext;
  class ClassMemberDeclaration_DropletFileContext;
  class FieldDeclaration_DropletFileContext;
  class FieldModifier_DropletFileContext;
  class VariableDeclaratorList_DropletFileContext;
  class VariableDeclarator_DropletFileContext;
  class VariableDeclaratorId_DropletFileContext;
  class VariableInitializer_DropletFileContext;
  class UnannType_DropletFileContext;
  class UnannPrimitiveType_DropletFileContext;
  class UnannReferenceType_DropletFileContext;
  class UnannClassOrInterfaceType_DropletFileContext;
  class UnannClassType_DropletFileContext;
  class UnannClassType_lf_unannClassOrInterfaceType_DropletFileContext;
  class UnannClassType_lfno_unannClassOrInterfaceType_DropletFileContext;
  class UnannInterfaceType_DropletFileContext;
  class UnannInterfaceType_lf_unannClassOrInterfaceType_DropletFileContext;
  class UnannInterfaceType_lfno_unannClassOrInterfaceType_DropletFileContext;
  class UnannTypeVariable_DropletFileContext;
  class UnannArrayType_DropletFileContext;
  class MethodDeclaration_DropletFileContext;
  class MethodModifier_DropletFileContext;
  class MethodHeader_DropletFileContext;
  class Result_DropletFileContext;
  class MethodDeclarator_DropletFileContext;
  class FormalParameterList_DropletFileContext;
  class FormalParameters_DropletFileContext;
  class FormalParameter_DropletFileContext;
  class VariableModifier_DropletFileContext;
  class LastFormalParameter_DropletFileContext;
  class ReceiverParameter_DropletFileContext;
  class Throws__DropletFileContext;
  class ExceptionTypeList_DropletFileContext;
  class ExceptionType_DropletFileContext;
  class MethodBody_DropletFileContext;
  class InstanceInitializer_DropletFileContext;
  class StaticInitializer_DropletFileContext;
  class ConstructorDeclaration_DropletFileContext;
  class ConstructorModifier_DropletFileContext;
  class ConstructorDeclarator_DropletFileContext;
  class SimpleTypeName_DropletFileContext;
  class ConstructorBody_DropletFileContext;
  class ExplicitConstructorInvocation_DropletFileContext;
  class EnumDeclaration_DropletFileContext;
  class EnumBody_DropletFileContext;
  class EnumConstantList_DropletFileContext;
  class EnumConstant_DropletFileContext;
  class EnumConstantModifier_DropletFileContext;
  class EnumBodyDeclarations_DropletFileContext;
  class InterfaceDeclaration_DropletFileContext;
  class NormalInterfaceDeclaration_DropletFileContext;
  class InterfaceModifier_DropletFileContext;
  class ExtendsInterfaces_DropletFileContext;
  class InterfaceBody_DropletFileContext;
  class InterfaceMemberDeclaration_DropletFileContext;
  class ConstantDeclaration_DropletFileContext;
  class ConstantModifier_DropletFileContext;
  class InterfaceMethodDeclaration_DropletFileContext;
  class InterfaceMethodModifier_DropletFileContext;
  class AnnotationTypeDeclaration_DropletFileContext;
  class AnnotationTypeBody_DropletFileContext;
  class AnnotationTypeMemberDeclaration_DropletFileContext;
  class AnnotationTypeElementDeclaration_DropletFileContext;
  class AnnotationTypeElementModifier_DropletFileContext;
  class DefaultValue_DropletFileContext;
  class Annotation_DropletFileContext;
  class NormalAnnotation_DropletFileContext;
  class ElementValuePairList_DropletFileContext;
  class ElementValuePair_DropletFileContext;
  class ElementValue_DropletFileContext;
  class ElementValueArrayInitializer_DropletFileContext;
  class ElementValueList_DropletFileContext;
  class MarkerAnnotation_DropletFileContext;
  class SingleElementAnnotation_DropletFileContext;
  class ArrayInitializer_DropletFileContext;
  class VariableInitializerList_DropletFileContext;
  class Block_DropletFileContext;
  class BlockStatements_DropletFileContext;
  class BlockStatement_DropletFileContext;
  class LocalVariableDeclarationStatement_DropletFileContext;
  class LocalVariableDeclaration_DropletFileContext;
  class Statement_DropletFileContext;
  class StatementNoShortIf_DropletFileContext;
  class StatementWithoutTrailingSubstatement_DropletFileContext;
  class EmptyStatement_DropletFileContext;
  class LabeledStatement_DropletFileContext;
  class LabeledStatementNoShortIf_DropletFileContext;
  class ExpressionStatement_DropletFileContext;
  class StatementExpression_DropletFileContext;
  class IfThenStatement_DropletFileContext;
  class IfThenElseStatement_DropletFileContext;
  class IfThenElseStatementNoShortIf_DropletFileContext;
  class AssertStatement_DropletFileContext;
  class SwitchStatement_DropletFileContext;
  class SwitchBlock_DropletFileContext;
  class SwitchBlockStatementGroup_DropletFileContext;
  class SwitchLabels_DropletFileContext;
  class SwitchLabel_DropletFileContext;
  class EnumConstantName_DropletFileContext;
  class WhileStatement_DropletFileContext;
  class WhileStatementNoShortIf_DropletFileContext;
  class DoStatement_DropletFileContext;
  class ForStatement_DropletFileContext;
  class ForStatementNoShortIf_DropletFileContext;
  class BasicForStatement_DropletFileContext;
  class BasicForStatementNoShortIf_DropletFileContext;
  class ForInit_DropletFileContext;
  class ForUpdate_DropletFileContext;
  class StatementExpressionList_DropletFileContext;
  class EnhancedForStatement_DropletFileContext;
  class EnhancedForStatementNoShortIf_DropletFileContext;
  class BreakStatement_DropletFileContext;
  class ContinueStatement_DropletFileContext;
  class ReturnStatement_DropletFileContext;
  class ThrowStatement_DropletFileContext;
  class SynchronizedStatement_DropletFileContext;
  class TryStatement_DropletFileContext;
  class Catches_DropletFileContext;
  class CatchClause_DropletFileContext;
  class CatchFormalParameter_DropletFileContext;
  class CatchType_DropletFileContext;
  class Finally__DropletFileContext;
  class TryWithResourcesStatement_DropletFileContext;
  class ResourceSpecification_DropletFileContext;
  class ResourceList_DropletFileContext;
  class Resource_DropletFileContext;
  class VariableAccess_DropletFileContext;
  class Primary_DropletFileContext;
  class PrimaryNoNewArray_DropletFileContext;
  class PrimaryNoNewArray_lf_arrayAccess_DropletFileContext;
  class PrimaryNoNewArray_lfno_arrayAccess_DropletFileContext;
  class PrimaryNoNewArray_lf_primary_DropletFileContext;
  class PrimaryNoNewArray_lf_primary_lf_arrayAccess_lf_primary_DropletFileContext;
  class PrimaryNoNewArray_lf_primary_lfno_arrayAccess_lf_primary_DropletFileContext;
  class PrimaryNoNewArray_lfno_primary_DropletFileContext;
  class PrimaryNoNewArray_lfno_primary_lf_arrayAccess_lfno_primary_DropletFileContext;
  class PrimaryNoNewArray_lfno_primary_lfno_arrayAccess_lfno_primary_DropletFileContext;
  class ClassLiteral_DropletFileContext;
  class ClassInstanceCreationExpression_DropletFileContext;
  class ClassInstanceCreationExpression_lf_primary_DropletFileContext;
  class ClassInstanceCreationExpression_lfno_primary_DropletFileContext;
  class TypeArgumentsOrDiamond_DropletFileContext;
  class FieldAccess_DropletFileContext;
  class FieldAccess_lf_primary_DropletFileContext;
  class FieldAccess_lfno_primary_DropletFileContext;
  class ArrayAccess_DropletFileContext;
  class ArrayAccess_lf_primary_DropletFileContext;
  class ArrayAccess_lfno_primary_DropletFileContext;
  class MethodInvocation_DropletFileContext;
  class MethodInvocation_lf_primary_DropletFileContext;
  class MethodInvocation_lfno_primary_DropletFileContext;
  class ArgumentList_DropletFileContext;
  class MethodReference_DropletFileContext;
  class MethodReference_lf_primary_DropletFileContext;
  class MethodReference_lfno_primary_DropletFileContext;
  class ArrayCreationExpression_DropletFileContext;
  class DimExprs_DropletFileContext;
  class DimExpr_DropletFileContext;
  class ConstantExpression_DropletFileContext;
  class Expression_DropletFileContext;
  class LambdaExpression_DropletFileContext;
  class LambdaParameters_DropletFileContext;
  class InferredFormalParameterList_DropletFileContext;
  class LambdaBody_DropletFileContext;
  class AssignmentExpression_DropletFileContext;
  class Assignment_DropletFileContext;
  class LeftHandSide_DropletFileContext;
  class AssignmentOperator_DropletFileContext;
  class ConditionalExpression_DropletFileContext;
  class ConditionalOrExpression_DropletFileContext;
  class ConditionalAndExpression_DropletFileContext;
  class InclusiveOrExpression_DropletFileContext;
  class ExclusiveOrExpression_DropletFileContext;
  class AndExpression_DropletFileContext;
  class EqualityExpression_DropletFileContext;
  class RelationalExpression_DropletFileContext;
  class ShiftExpression_DropletFileContext;
  class AdditiveExpression_DropletFileContext;
  class MultiplicativeExpression_DropletFileContext;
  class UnaryExpression_DropletFileContext;
  class PreIncrementExpression_DropletFileContext;
  class PreDecrementExpression_DropletFileContext;
  class UnaryExpressionNotPlusMinus_DropletFileContext;
  class PostfixExpression_DropletFileContext;
  class PostIncrementExpression_DropletFileContext;
  class PostIncrementExpression_lf_postfixExpression_DropletFileContext;
  class PostDecrementExpression_DropletFileContext;
  class PostDecrementExpression_lf_postfixExpression_DropletFileContext;
  class CastExpression_DropletFileContext;
  class IdentifierContext; 

  class  LiteralContext : public antlr4::ParserRuleContext {
  public:
    LiteralContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *IntegerLiteral();
    antlr4::tree::TerminalNode *FloatingPointLiteral();
    antlr4::tree::TerminalNode *BooleanLiteral();
    antlr4::tree::TerminalNode *CharacterLiteral();
    antlr4::tree::TerminalNode *StringLiteral();
    antlr4::tree::TerminalNode *NullLiteral();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  LiteralContext* literal();

  class  PrimitiveTypeContext : public antlr4::ParserRuleContext {
  public:
    PrimitiveTypeContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    NumericTypeContext *numericType();
    std::vector<AnnotationContext *> annotation();
    AnnotationContext* annotation(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  PrimitiveTypeContext* primitiveType();

  class  NumericTypeContext : public antlr4::ParserRuleContext {
  public:
    NumericTypeContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IntegralTypeContext *integralType();
    FloatingPointTypeContext *floatingPointType();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  NumericTypeContext* numericType();

  class  IntegralTypeContext : public antlr4::ParserRuleContext {
  public:
    IntegralTypeContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  IntegralTypeContext* integralType();

  class  FloatingPointTypeContext : public antlr4::ParserRuleContext {
  public:
    FloatingPointTypeContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  FloatingPointTypeContext* floatingPointType();

  class  ReferenceTypeContext : public antlr4::ParserRuleContext {
  public:
    ReferenceTypeContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ClassOrInterfaceTypeContext *classOrInterfaceType();
    TypeVariableContext *typeVariable();
    ArrayTypeContext *arrayType();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ReferenceTypeContext* referenceType();

  class  ClassOrInterfaceTypeContext : public antlr4::ParserRuleContext {
  public:
    ClassOrInterfaceTypeContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ClassType_lfno_classOrInterfaceTypeContext *classType_lfno_classOrInterfaceType();
    InterfaceType_lfno_classOrInterfaceTypeContext *interfaceType_lfno_classOrInterfaceType();
    std::vector<ClassType_lf_classOrInterfaceTypeContext *> classType_lf_classOrInterfaceType();
    ClassType_lf_classOrInterfaceTypeContext* classType_lf_classOrInterfaceType(size_t i);
    std::vector<InterfaceType_lf_classOrInterfaceTypeContext *> interfaceType_lf_classOrInterfaceType();
    InterfaceType_lf_classOrInterfaceTypeContext* interfaceType_lf_classOrInterfaceType(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ClassOrInterfaceTypeContext* classOrInterfaceType();

  class  ClassTypeContext : public antlr4::ParserRuleContext {
  public:
    ClassTypeContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    std::vector<AnnotationContext *> annotation();
    AnnotationContext* annotation(size_t i);
    TypeArgumentsContext *typeArguments();
    ClassOrInterfaceTypeContext *classOrInterfaceType();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ClassTypeContext* classType();

  class  ClassType_lf_classOrInterfaceTypeContext : public antlr4::ParserRuleContext {
  public:
    ClassType_lf_classOrInterfaceTypeContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    std::vector<AnnotationContext *> annotation();
    AnnotationContext* annotation(size_t i);
    TypeArgumentsContext *typeArguments();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ClassType_lf_classOrInterfaceTypeContext* classType_lf_classOrInterfaceType();

  class  ClassType_lfno_classOrInterfaceTypeContext : public antlr4::ParserRuleContext {
  public:
    ClassType_lfno_classOrInterfaceTypeContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    std::vector<AnnotationContext *> annotation();
    AnnotationContext* annotation(size_t i);
    TypeArgumentsContext *typeArguments();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ClassType_lfno_classOrInterfaceTypeContext* classType_lfno_classOrInterfaceType();

  class  InterfaceTypeContext : public antlr4::ParserRuleContext {
  public:
    InterfaceTypeContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ClassTypeContext *classType();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  InterfaceTypeContext* interfaceType();

  class  InterfaceType_lf_classOrInterfaceTypeContext : public antlr4::ParserRuleContext {
  public:
    InterfaceType_lf_classOrInterfaceTypeContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ClassType_lf_classOrInterfaceTypeContext *classType_lf_classOrInterfaceType();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  InterfaceType_lf_classOrInterfaceTypeContext* interfaceType_lf_classOrInterfaceType();

  class  InterfaceType_lfno_classOrInterfaceTypeContext : public antlr4::ParserRuleContext {
  public:
    InterfaceType_lfno_classOrInterfaceTypeContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ClassType_lfno_classOrInterfaceTypeContext *classType_lfno_classOrInterfaceType();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  InterfaceType_lfno_classOrInterfaceTypeContext* interfaceType_lfno_classOrInterfaceType();

  class  TypeVariableContext : public antlr4::ParserRuleContext {
  public:
    TypeVariableContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    std::vector<AnnotationContext *> annotation();
    AnnotationContext* annotation(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  TypeVariableContext* typeVariable();

  class  ArrayTypeContext : public antlr4::ParserRuleContext {
  public:
    ArrayTypeContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    PrimitiveTypeContext *primitiveType();
    DimsContext *dims();
    ClassOrInterfaceTypeContext *classOrInterfaceType();
    TypeVariableContext *typeVariable();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ArrayTypeContext* arrayType();

  class  DimsContext : public antlr4::ParserRuleContext {
  public:
    DimsContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<AnnotationContext *> annotation();
    AnnotationContext* annotation(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  DimsContext* dims();

  class  TypeParameterContext : public antlr4::ParserRuleContext {
  public:
    TypeParameterContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    std::vector<TypeParameterModifierContext *> typeParameterModifier();
    TypeParameterModifierContext* typeParameterModifier(size_t i);
    TypeBoundContext *typeBound();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  TypeParameterContext* typeParameter();

  class  TypeParameterModifierContext : public antlr4::ParserRuleContext {
  public:
    TypeParameterModifierContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    AnnotationContext *annotation();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  TypeParameterModifierContext* typeParameterModifier();

  class  TypeBoundContext : public antlr4::ParserRuleContext {
  public:
    TypeBoundContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    TypeVariableContext *typeVariable();
    ClassOrInterfaceTypeContext *classOrInterfaceType();
    std::vector<AdditionalBoundContext *> additionalBound();
    AdditionalBoundContext* additionalBound(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  TypeBoundContext* typeBound();

  class  AdditionalBoundContext : public antlr4::ParserRuleContext {
  public:
    AdditionalBoundContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    InterfaceTypeContext *interfaceType();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  AdditionalBoundContext* additionalBound();

  class  TypeArgumentsContext : public antlr4::ParserRuleContext {
  public:
    TypeArgumentsContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    TypeArgumentListContext *typeArgumentList();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  TypeArgumentsContext* typeArguments();

  class  TypeArgumentListContext : public antlr4::ParserRuleContext {
  public:
    TypeArgumentListContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<TypeArgumentContext *> typeArgument();
    TypeArgumentContext* typeArgument(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  TypeArgumentListContext* typeArgumentList();

  class  TypeArgumentContext : public antlr4::ParserRuleContext {
  public:
    TypeArgumentContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ReferenceTypeContext *referenceType();
    WildcardContext *wildcard();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  TypeArgumentContext* typeArgument();

  class  WildcardContext : public antlr4::ParserRuleContext {
  public:
    WildcardContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<AnnotationContext *> annotation();
    AnnotationContext* annotation(size_t i);
    WildcardBoundsContext *wildcardBounds();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  WildcardContext* wildcard();

  class  WildcardBoundsContext : public antlr4::ParserRuleContext {
  public:
    WildcardBoundsContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ReferenceTypeContext *referenceType();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  WildcardBoundsContext* wildcardBounds();

  class  ModuleNameContext : public antlr4::ParserRuleContext {
  public:
    ModuleNameContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    ModuleNameContext *moduleName();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ModuleNameContext* moduleName();
  ModuleNameContext* moduleName(int precedence);
  class  PackageNameContext : public antlr4::ParserRuleContext {
  public:
    PackageNameContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    PackageNameContext *packageName();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  PackageNameContext* packageName();
  PackageNameContext* packageName(int precedence);
  class  TypeNameContext : public antlr4::ParserRuleContext {
  public:
    TypeNameContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    PackageOrTypeNameContext *packageOrTypeName();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  TypeNameContext* typeName();

  class  PackageOrTypeNameContext : public antlr4::ParserRuleContext {
  public:
    PackageOrTypeNameContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    PackageOrTypeNameContext *packageOrTypeName();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  PackageOrTypeNameContext* packageOrTypeName();
  PackageOrTypeNameContext* packageOrTypeName(int precedence);
  class  ExpressionNameContext : public antlr4::ParserRuleContext {
  public:
    ExpressionNameContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    AmbiguousNameContext *ambiguousName();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ExpressionNameContext* expressionName();

  class  MethodNameContext : public antlr4::ParserRuleContext {
  public:
    MethodNameContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  MethodNameContext* methodName();

  class  AmbiguousNameContext : public antlr4::ParserRuleContext {
  public:
    AmbiguousNameContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    AmbiguousNameContext *ambiguousName();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  AmbiguousNameContext* ambiguousName();
  AmbiguousNameContext* ambiguousName(int precedence);
  class  CompilationUnitContext : public antlr4::ParserRuleContext {
  public:
    CompilationUnitContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    OrdinaryCompilationContext *ordinaryCompilation();
    ModularCompilationContext *modularCompilation();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  CompilationUnitContext* compilationUnit();

  class  OrdinaryCompilationContext : public antlr4::ParserRuleContext {
  public:
    OrdinaryCompilationContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *EOF();
    PackageDeclarationContext *packageDeclaration();
    std::vector<ImportDeclarationContext *> importDeclaration();
    ImportDeclarationContext* importDeclaration(size_t i);
    std::vector<TypeDeclarationContext *> typeDeclaration();
    TypeDeclarationContext* typeDeclaration(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  OrdinaryCompilationContext* ordinaryCompilation();

  class  ModularCompilationContext : public antlr4::ParserRuleContext {
  public:
    ModularCompilationContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ModuleDeclarationContext *moduleDeclaration();
    std::vector<ImportDeclarationContext *> importDeclaration();
    ImportDeclarationContext* importDeclaration(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ModularCompilationContext* modularCompilation();

  class  PackageDeclarationContext : public antlr4::ParserRuleContext {
  public:
    PackageDeclarationContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    PackageNameContext *packageName();
    std::vector<PackageModifierContext *> packageModifier();
    PackageModifierContext* packageModifier(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  PackageDeclarationContext* packageDeclaration();

  class  PackageModifierContext : public antlr4::ParserRuleContext {
  public:
    PackageModifierContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    AnnotationContext *annotation();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  PackageModifierContext* packageModifier();

  class  ImportDeclarationContext : public antlr4::ParserRuleContext {
  public:
    ImportDeclarationContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    SingleTypeImportDeclarationContext *singleTypeImportDeclaration();
    TypeImportOnDemandDeclarationContext *typeImportOnDemandDeclaration();
    SingleStaticImportDeclarationContext *singleStaticImportDeclaration();
    StaticImportOnDemandDeclarationContext *staticImportOnDemandDeclaration();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ImportDeclarationContext* importDeclaration();

  class  SingleTypeImportDeclarationContext : public antlr4::ParserRuleContext {
  public:
    SingleTypeImportDeclarationContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    TypeNameContext *typeName();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  SingleTypeImportDeclarationContext* singleTypeImportDeclaration();

  class  TypeImportOnDemandDeclarationContext : public antlr4::ParserRuleContext {
  public:
    TypeImportOnDemandDeclarationContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    PackageOrTypeNameContext *packageOrTypeName();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  TypeImportOnDemandDeclarationContext* typeImportOnDemandDeclaration();

  class  SingleStaticImportDeclarationContext : public antlr4::ParserRuleContext {
  public:
    SingleStaticImportDeclarationContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    TypeNameContext *typeName();
    IdentifierContext *identifier();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  SingleStaticImportDeclarationContext* singleStaticImportDeclaration();

  class  StaticImportOnDemandDeclarationContext : public antlr4::ParserRuleContext {
  public:
    StaticImportOnDemandDeclarationContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    TypeNameContext *typeName();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  StaticImportOnDemandDeclarationContext* staticImportOnDemandDeclaration();

  class  TypeDeclarationContext : public antlr4::ParserRuleContext {
  public:
    TypeDeclarationContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ClassDeclarationContext *classDeclaration();
    InterfaceDeclarationContext *interfaceDeclaration();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  TypeDeclarationContext* typeDeclaration();

  class  ModuleDeclarationContext : public antlr4::ParserRuleContext {
  public:
    ModuleDeclarationContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ModuleNameContext *moduleName();
    std::vector<AnnotationContext *> annotation();
    AnnotationContext* annotation(size_t i);
    std::vector<ModuleDirectiveContext *> moduleDirective();
    ModuleDirectiveContext* moduleDirective(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ModuleDeclarationContext* moduleDeclaration();

  class  ModuleDirectiveContext : public antlr4::ParserRuleContext {
  public:
    ModuleDirectiveContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<ModuleNameContext *> moduleName();
    ModuleNameContext* moduleName(size_t i);
    std::vector<RequiresModifierContext *> requiresModifier();
    RequiresModifierContext* requiresModifier(size_t i);
    PackageNameContext *packageName();
    std::vector<TypeNameContext *> typeName();
    TypeNameContext* typeName(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ModuleDirectiveContext* moduleDirective();

  class  RequiresModifierContext : public antlr4::ParserRuleContext {
  public:
    RequiresModifierContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  RequiresModifierContext* requiresModifier();

  class  ClassDeclarationContext : public antlr4::ParserRuleContext {
  public:
    ClassDeclarationContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    NormalClassDeclarationContext *normalClassDeclaration();
    EnumDeclarationContext *enumDeclaration();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ClassDeclarationContext* classDeclaration();

  class  NormalClassDeclarationContext : public antlr4::ParserRuleContext {
  public:
    NormalClassDeclarationContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    ClassBodyContext *classBody();
    std::vector<ClassModifierContext *> classModifier();
    ClassModifierContext* classModifier(size_t i);
    TypeParametersContext *typeParameters();
    SuperclassContext *superclass();
    SuperinterfacesContext *superinterfaces();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  NormalClassDeclarationContext* normalClassDeclaration();

  class  ClassModifierContext : public antlr4::ParserRuleContext {
  public:
    ClassModifierContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    AnnotationContext *annotation();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ClassModifierContext* classModifier();

  class  TypeParametersContext : public antlr4::ParserRuleContext {
  public:
    TypeParametersContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    TypeParameterListContext *typeParameterList();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  TypeParametersContext* typeParameters();

  class  TypeParameterListContext : public antlr4::ParserRuleContext {
  public:
    TypeParameterListContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<TypeParameterContext *> typeParameter();
    TypeParameterContext* typeParameter(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  TypeParameterListContext* typeParameterList();

  class  SuperclassContext : public antlr4::ParserRuleContext {
  public:
    SuperclassContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ClassTypeContext *classType();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  SuperclassContext* superclass();

  class  SuperinterfacesContext : public antlr4::ParserRuleContext {
  public:
    SuperinterfacesContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    InterfaceTypeListContext *interfaceTypeList();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  SuperinterfacesContext* superinterfaces();

  class  InterfaceTypeListContext : public antlr4::ParserRuleContext {
  public:
    InterfaceTypeListContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<InterfaceTypeContext *> interfaceType();
    InterfaceTypeContext* interfaceType(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  InterfaceTypeListContext* interfaceTypeList();

  class  ClassBodyContext : public antlr4::ParserRuleContext {
  public:
    ClassBodyContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<ClassBodyDeclarationContext *> classBodyDeclaration();
    ClassBodyDeclarationContext* classBodyDeclaration(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ClassBodyContext* classBody();

  class  ClassBodyDeclarationContext : public antlr4::ParserRuleContext {
  public:
    ClassBodyDeclarationContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ClassMemberDeclarationContext *classMemberDeclaration();
    InstanceInitializerContext *instanceInitializer();
    StaticInitializerContext *staticInitializer();
    ConstructorDeclarationContext *constructorDeclaration();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ClassBodyDeclarationContext* classBodyDeclaration();

  class  ClassMemberDeclarationContext : public antlr4::ParserRuleContext {
  public:
    ClassMemberDeclarationContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    FieldDeclarationContext *fieldDeclaration();
    MethodDeclarationContext *methodDeclaration();
    ClassDeclarationContext *classDeclaration();
    InterfaceDeclarationContext *interfaceDeclaration();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ClassMemberDeclarationContext* classMemberDeclaration();

  class  FieldDeclarationContext : public antlr4::ParserRuleContext {
  public:
    FieldDeclarationContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    UnannTypeContext *unannType();
    VariableDeclaratorListContext *variableDeclaratorList();
    std::vector<FieldModifierContext *> fieldModifier();
    FieldModifierContext* fieldModifier(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  FieldDeclarationContext* fieldDeclaration();

  class  FieldModifierContext : public antlr4::ParserRuleContext {
  public:
    FieldModifierContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    AnnotationContext *annotation();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  FieldModifierContext* fieldModifier();

  class  VariableDeclaratorListContext : public antlr4::ParserRuleContext {
  public:
    VariableDeclaratorListContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<VariableDeclaratorContext *> variableDeclarator();
    VariableDeclaratorContext* variableDeclarator(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  VariableDeclaratorListContext* variableDeclaratorList();

  class  VariableDeclaratorContext : public antlr4::ParserRuleContext {
  public:
    VariableDeclaratorContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    VariableDeclaratorIdContext *variableDeclaratorId();
    VariableInitializerContext *variableInitializer();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  VariableDeclaratorContext* variableDeclarator();

  class  VariableDeclaratorIdContext : public antlr4::ParserRuleContext {
  public:
    VariableDeclaratorIdContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    DimsContext *dims();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  VariableDeclaratorIdContext* variableDeclaratorId();

  class  VariableInitializerContext : public antlr4::ParserRuleContext {
  public:
    VariableInitializerContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExpressionContext *expression();
    ArrayInitializerContext *arrayInitializer();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  VariableInitializerContext* variableInitializer();

  class  UnannTypeContext : public antlr4::ParserRuleContext {
  public:
    UnannTypeContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    UnannPrimitiveTypeContext *unannPrimitiveType();
    UnannReferenceTypeContext *unannReferenceType();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  UnannTypeContext* unannType();

  class  UnannPrimitiveTypeContext : public antlr4::ParserRuleContext {
  public:
    UnannPrimitiveTypeContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    NumericTypeContext *numericType();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  UnannPrimitiveTypeContext* unannPrimitiveType();

  class  UnannReferenceTypeContext : public antlr4::ParserRuleContext {
  public:
    UnannReferenceTypeContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    UnannClassOrInterfaceTypeContext *unannClassOrInterfaceType();
    UnannTypeVariableContext *unannTypeVariable();
    UnannArrayTypeContext *unannArrayType();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  UnannReferenceTypeContext* unannReferenceType();

  class  UnannClassOrInterfaceTypeContext : public antlr4::ParserRuleContext {
  public:
    UnannClassOrInterfaceTypeContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    UnannClassType_lfno_unannClassOrInterfaceTypeContext *unannClassType_lfno_unannClassOrInterfaceType();
    UnannInterfaceType_lfno_unannClassOrInterfaceTypeContext *unannInterfaceType_lfno_unannClassOrInterfaceType();
    std::vector<UnannClassType_lf_unannClassOrInterfaceTypeContext *> unannClassType_lf_unannClassOrInterfaceType();
    UnannClassType_lf_unannClassOrInterfaceTypeContext* unannClassType_lf_unannClassOrInterfaceType(size_t i);
    std::vector<UnannInterfaceType_lf_unannClassOrInterfaceTypeContext *> unannInterfaceType_lf_unannClassOrInterfaceType();
    UnannInterfaceType_lf_unannClassOrInterfaceTypeContext* unannInterfaceType_lf_unannClassOrInterfaceType(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  UnannClassOrInterfaceTypeContext* unannClassOrInterfaceType();

  class  UnannClassTypeContext : public antlr4::ParserRuleContext {
  public:
    UnannClassTypeContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    TypeArgumentsContext *typeArguments();
    UnannClassOrInterfaceTypeContext *unannClassOrInterfaceType();
    std::vector<AnnotationContext *> annotation();
    AnnotationContext* annotation(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  UnannClassTypeContext* unannClassType();

  class  UnannClassType_lf_unannClassOrInterfaceTypeContext : public antlr4::ParserRuleContext {
  public:
    UnannClassType_lf_unannClassOrInterfaceTypeContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    std::vector<AnnotationContext *> annotation();
    AnnotationContext* annotation(size_t i);
    TypeArgumentsContext *typeArguments();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  UnannClassType_lf_unannClassOrInterfaceTypeContext* unannClassType_lf_unannClassOrInterfaceType();

  class  UnannClassType_lfno_unannClassOrInterfaceTypeContext : public antlr4::ParserRuleContext {
  public:
    UnannClassType_lfno_unannClassOrInterfaceTypeContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    TypeArgumentsContext *typeArguments();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  UnannClassType_lfno_unannClassOrInterfaceTypeContext* unannClassType_lfno_unannClassOrInterfaceType();

  class  UnannInterfaceTypeContext : public antlr4::ParserRuleContext {
  public:
    UnannInterfaceTypeContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    UnannClassTypeContext *unannClassType();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  UnannInterfaceTypeContext* unannInterfaceType();

  class  UnannInterfaceType_lf_unannClassOrInterfaceTypeContext : public antlr4::ParserRuleContext {
  public:
    UnannInterfaceType_lf_unannClassOrInterfaceTypeContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    UnannClassType_lf_unannClassOrInterfaceTypeContext *unannClassType_lf_unannClassOrInterfaceType();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  UnannInterfaceType_lf_unannClassOrInterfaceTypeContext* unannInterfaceType_lf_unannClassOrInterfaceType();

  class  UnannInterfaceType_lfno_unannClassOrInterfaceTypeContext : public antlr4::ParserRuleContext {
  public:
    UnannInterfaceType_lfno_unannClassOrInterfaceTypeContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    UnannClassType_lfno_unannClassOrInterfaceTypeContext *unannClassType_lfno_unannClassOrInterfaceType();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  UnannInterfaceType_lfno_unannClassOrInterfaceTypeContext* unannInterfaceType_lfno_unannClassOrInterfaceType();

  class  UnannTypeVariableContext : public antlr4::ParserRuleContext {
  public:
    UnannTypeVariableContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  UnannTypeVariableContext* unannTypeVariable();

  class  UnannArrayTypeContext : public antlr4::ParserRuleContext {
  public:
    UnannArrayTypeContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    UnannPrimitiveTypeContext *unannPrimitiveType();
    DimsContext *dims();
    UnannClassOrInterfaceTypeContext *unannClassOrInterfaceType();
    UnannTypeVariableContext *unannTypeVariable();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  UnannArrayTypeContext* unannArrayType();

  class  MethodDeclarationContext : public antlr4::ParserRuleContext {
  public:
    MethodDeclarationContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    MethodHeaderContext *methodHeader();
    MethodBodyContext *methodBody();
    std::vector<MethodModifierContext *> methodModifier();
    MethodModifierContext* methodModifier(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  MethodDeclarationContext* methodDeclaration();

  class  MethodModifierContext : public antlr4::ParserRuleContext {
  public:
    MethodModifierContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    AnnotationContext *annotation();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  MethodModifierContext* methodModifier();

  class  MethodHeaderContext : public antlr4::ParserRuleContext {
  public:
    MethodHeaderContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ResultContext *result();
    MethodDeclaratorContext *methodDeclarator();
    Throws_Context *throws_();
    TypeParametersContext *typeParameters();
    std::vector<AnnotationContext *> annotation();
    AnnotationContext* annotation(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  MethodHeaderContext* methodHeader();

  class  ResultContext : public antlr4::ParserRuleContext {
  public:
    ResultContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    UnannTypeContext *unannType();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ResultContext* result();

  class  MethodDeclaratorContext : public antlr4::ParserRuleContext {
  public:
    MethodDeclaratorContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    FormalParameterListContext *formalParameterList();
    DimsContext *dims();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  MethodDeclaratorContext* methodDeclarator();

  class  FormalParameterListContext : public antlr4::ParserRuleContext {
  public:
    FormalParameterListContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    FormalParametersContext *formalParameters();
    LastFormalParameterContext *lastFormalParameter();
    ReceiverParameterContext *receiverParameter();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  FormalParameterListContext* formalParameterList();

  class  FormalParametersContext : public antlr4::ParserRuleContext {
  public:
    FormalParametersContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<FormalParameterContext *> formalParameter();
    FormalParameterContext* formalParameter(size_t i);
    ReceiverParameterContext *receiverParameter();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  FormalParametersContext* formalParameters();

  class  FormalParameterContext : public antlr4::ParserRuleContext {
  public:
    FormalParameterContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    UnannTypeContext *unannType();
    VariableDeclaratorIdContext *variableDeclaratorId();
    std::vector<VariableModifierContext *> variableModifier();
    VariableModifierContext* variableModifier(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  FormalParameterContext* formalParameter();

  class  VariableModifierContext : public antlr4::ParserRuleContext {
  public:
    VariableModifierContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    AnnotationContext *annotation();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  VariableModifierContext* variableModifier();

  class  LastFormalParameterContext : public antlr4::ParserRuleContext {
  public:
    LastFormalParameterContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    UnannTypeContext *unannType();
    VariableDeclaratorIdContext *variableDeclaratorId();
    std::vector<VariableModifierContext *> variableModifier();
    VariableModifierContext* variableModifier(size_t i);
    std::vector<AnnotationContext *> annotation();
    AnnotationContext* annotation(size_t i);
    FormalParameterContext *formalParameter();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  LastFormalParameterContext* lastFormalParameter();

  class  ReceiverParameterContext : public antlr4::ParserRuleContext {
  public:
    ReceiverParameterContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    UnannTypeContext *unannType();
    std::vector<AnnotationContext *> annotation();
    AnnotationContext* annotation(size_t i);
    IdentifierContext *identifier();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ReceiverParameterContext* receiverParameter();

  class  Throws_Context : public antlr4::ParserRuleContext {
  public:
    Throws_Context(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExceptionTypeListContext *exceptionTypeList();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  Throws_Context* throws_();

  class  ExceptionTypeListContext : public antlr4::ParserRuleContext {
  public:
    ExceptionTypeListContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<ExceptionTypeContext *> exceptionType();
    ExceptionTypeContext* exceptionType(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ExceptionTypeListContext* exceptionTypeList();

  class  ExceptionTypeContext : public antlr4::ParserRuleContext {
  public:
    ExceptionTypeContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ClassTypeContext *classType();
    TypeVariableContext *typeVariable();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ExceptionTypeContext* exceptionType();

  class  MethodBodyContext : public antlr4::ParserRuleContext {
  public:
    MethodBodyContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    BlockContext *block();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  MethodBodyContext* methodBody();

  class  InstanceInitializerContext : public antlr4::ParserRuleContext {
  public:
    InstanceInitializerContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    BlockContext *block();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  InstanceInitializerContext* instanceInitializer();

  class  StaticInitializerContext : public antlr4::ParserRuleContext {
  public:
    StaticInitializerContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    BlockContext *block();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  StaticInitializerContext* staticInitializer();

  class  ConstructorDeclarationContext : public antlr4::ParserRuleContext {
  public:
    ConstructorDeclarationContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ConstructorDeclaratorContext *constructorDeclarator();
    ConstructorBodyContext *constructorBody();
    std::vector<ConstructorModifierContext *> constructorModifier();
    ConstructorModifierContext* constructorModifier(size_t i);
    Throws_Context *throws_();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ConstructorDeclarationContext* constructorDeclaration();

  class  ConstructorModifierContext : public antlr4::ParserRuleContext {
  public:
    ConstructorModifierContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    AnnotationContext *annotation();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ConstructorModifierContext* constructorModifier();

  class  ConstructorDeclaratorContext : public antlr4::ParserRuleContext {
  public:
    ConstructorDeclaratorContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    SimpleTypeNameContext *simpleTypeName();
    TypeParametersContext *typeParameters();
    FormalParameterListContext *formalParameterList();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ConstructorDeclaratorContext* constructorDeclarator();

  class  SimpleTypeNameContext : public antlr4::ParserRuleContext {
  public:
    SimpleTypeNameContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  SimpleTypeNameContext* simpleTypeName();

  class  ConstructorBodyContext : public antlr4::ParserRuleContext {
  public:
    ConstructorBodyContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExplicitConstructorInvocationContext *explicitConstructorInvocation();
    BlockStatementsContext *blockStatements();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ConstructorBodyContext* constructorBody();

  class  ExplicitConstructorInvocationContext : public antlr4::ParserRuleContext {
  public:
    ExplicitConstructorInvocationContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    TypeArgumentsContext *typeArguments();
    ArgumentListContext *argumentList();
    ExpressionNameContext *expressionName();
    PrimaryContext *primary();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ExplicitConstructorInvocationContext* explicitConstructorInvocation();

  class  EnumDeclarationContext : public antlr4::ParserRuleContext {
  public:
    EnumDeclarationContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    EnumBodyContext *enumBody();
    std::vector<ClassModifierContext *> classModifier();
    ClassModifierContext* classModifier(size_t i);
    SuperinterfacesContext *superinterfaces();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  EnumDeclarationContext* enumDeclaration();

  class  EnumBodyContext : public antlr4::ParserRuleContext {
  public:
    EnumBodyContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    EnumConstantListContext *enumConstantList();
    EnumBodyDeclarationsContext *enumBodyDeclarations();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  EnumBodyContext* enumBody();

  class  EnumConstantListContext : public antlr4::ParserRuleContext {
  public:
    EnumConstantListContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<EnumConstantContext *> enumConstant();
    EnumConstantContext* enumConstant(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  EnumConstantListContext* enumConstantList();

  class  EnumConstantContext : public antlr4::ParserRuleContext {
  public:
    EnumConstantContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    std::vector<EnumConstantModifierContext *> enumConstantModifier();
    EnumConstantModifierContext* enumConstantModifier(size_t i);
    ClassBodyContext *classBody();
    ArgumentListContext *argumentList();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  EnumConstantContext* enumConstant();

  class  EnumConstantModifierContext : public antlr4::ParserRuleContext {
  public:
    EnumConstantModifierContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    AnnotationContext *annotation();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  EnumConstantModifierContext* enumConstantModifier();

  class  EnumBodyDeclarationsContext : public antlr4::ParserRuleContext {
  public:
    EnumBodyDeclarationsContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<ClassBodyDeclarationContext *> classBodyDeclaration();
    ClassBodyDeclarationContext* classBodyDeclaration(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  EnumBodyDeclarationsContext* enumBodyDeclarations();

  class  InterfaceDeclarationContext : public antlr4::ParserRuleContext {
  public:
    InterfaceDeclarationContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    NormalInterfaceDeclarationContext *normalInterfaceDeclaration();
    AnnotationTypeDeclarationContext *annotationTypeDeclaration();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  InterfaceDeclarationContext* interfaceDeclaration();

  class  NormalInterfaceDeclarationContext : public antlr4::ParserRuleContext {
  public:
    NormalInterfaceDeclarationContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    InterfaceBodyContext *interfaceBody();
    std::vector<InterfaceModifierContext *> interfaceModifier();
    InterfaceModifierContext* interfaceModifier(size_t i);
    TypeParametersContext *typeParameters();
    ExtendsInterfacesContext *extendsInterfaces();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  NormalInterfaceDeclarationContext* normalInterfaceDeclaration();

  class  InterfaceModifierContext : public antlr4::ParserRuleContext {
  public:
    InterfaceModifierContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    AnnotationContext *annotation();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  InterfaceModifierContext* interfaceModifier();

  class  ExtendsInterfacesContext : public antlr4::ParserRuleContext {
  public:
    ExtendsInterfacesContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    InterfaceTypeListContext *interfaceTypeList();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ExtendsInterfacesContext* extendsInterfaces();

  class  InterfaceBodyContext : public antlr4::ParserRuleContext {
  public:
    InterfaceBodyContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<InterfaceMemberDeclarationContext *> interfaceMemberDeclaration();
    InterfaceMemberDeclarationContext* interfaceMemberDeclaration(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  InterfaceBodyContext* interfaceBody();

  class  InterfaceMemberDeclarationContext : public antlr4::ParserRuleContext {
  public:
    InterfaceMemberDeclarationContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ConstantDeclarationContext *constantDeclaration();
    InterfaceMethodDeclarationContext *interfaceMethodDeclaration();
    ClassDeclarationContext *classDeclaration();
    InterfaceDeclarationContext *interfaceDeclaration();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  InterfaceMemberDeclarationContext* interfaceMemberDeclaration();

  class  ConstantDeclarationContext : public antlr4::ParserRuleContext {
  public:
    ConstantDeclarationContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    UnannTypeContext *unannType();
    VariableDeclaratorListContext *variableDeclaratorList();
    std::vector<ConstantModifierContext *> constantModifier();
    ConstantModifierContext* constantModifier(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ConstantDeclarationContext* constantDeclaration();

  class  ConstantModifierContext : public antlr4::ParserRuleContext {
  public:
    ConstantModifierContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    AnnotationContext *annotation();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ConstantModifierContext* constantModifier();

  class  InterfaceMethodDeclarationContext : public antlr4::ParserRuleContext {
  public:
    InterfaceMethodDeclarationContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    MethodHeaderContext *methodHeader();
    MethodBodyContext *methodBody();
    std::vector<InterfaceMethodModifierContext *> interfaceMethodModifier();
    InterfaceMethodModifierContext* interfaceMethodModifier(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  InterfaceMethodDeclarationContext* interfaceMethodDeclaration();

  class  InterfaceMethodModifierContext : public antlr4::ParserRuleContext {
  public:
    InterfaceMethodModifierContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    AnnotationContext *annotation();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  InterfaceMethodModifierContext* interfaceMethodModifier();

  class  AnnotationTypeDeclarationContext : public antlr4::ParserRuleContext {
  public:
    AnnotationTypeDeclarationContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    AnnotationTypeBodyContext *annotationTypeBody();
    std::vector<InterfaceModifierContext *> interfaceModifier();
    InterfaceModifierContext* interfaceModifier(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  AnnotationTypeDeclarationContext* annotationTypeDeclaration();

  class  AnnotationTypeBodyContext : public antlr4::ParserRuleContext {
  public:
    AnnotationTypeBodyContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<AnnotationTypeMemberDeclarationContext *> annotationTypeMemberDeclaration();
    AnnotationTypeMemberDeclarationContext* annotationTypeMemberDeclaration(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  AnnotationTypeBodyContext* annotationTypeBody();

  class  AnnotationTypeMemberDeclarationContext : public antlr4::ParserRuleContext {
  public:
    AnnotationTypeMemberDeclarationContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    AnnotationTypeElementDeclarationContext *annotationTypeElementDeclaration();
    ConstantDeclarationContext *constantDeclaration();
    ClassDeclarationContext *classDeclaration();
    InterfaceDeclarationContext *interfaceDeclaration();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  AnnotationTypeMemberDeclarationContext* annotationTypeMemberDeclaration();

  class  AnnotationTypeElementDeclarationContext : public antlr4::ParserRuleContext {
  public:
    AnnotationTypeElementDeclarationContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    UnannTypeContext *unannType();
    IdentifierContext *identifier();
    std::vector<AnnotationTypeElementModifierContext *> annotationTypeElementModifier();
    AnnotationTypeElementModifierContext* annotationTypeElementModifier(size_t i);
    DimsContext *dims();
    DefaultValueContext *defaultValue();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  AnnotationTypeElementDeclarationContext* annotationTypeElementDeclaration();

  class  AnnotationTypeElementModifierContext : public antlr4::ParserRuleContext {
  public:
    AnnotationTypeElementModifierContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    AnnotationContext *annotation();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  AnnotationTypeElementModifierContext* annotationTypeElementModifier();

  class  DefaultValueContext : public antlr4::ParserRuleContext {
  public:
    DefaultValueContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ElementValueContext *elementValue();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  DefaultValueContext* defaultValue();

  class  AnnotationContext : public antlr4::ParserRuleContext {
  public:
    AnnotationContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    NormalAnnotationContext *normalAnnotation();
    MarkerAnnotationContext *markerAnnotation();
    SingleElementAnnotationContext *singleElementAnnotation();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  AnnotationContext* annotation();

  class  NormalAnnotationContext : public antlr4::ParserRuleContext {
  public:
    NormalAnnotationContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    TypeNameContext *typeName();
    ElementValuePairListContext *elementValuePairList();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  NormalAnnotationContext* normalAnnotation();

  class  ElementValuePairListContext : public antlr4::ParserRuleContext {
  public:
    ElementValuePairListContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<ElementValuePairContext *> elementValuePair();
    ElementValuePairContext* elementValuePair(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ElementValuePairListContext* elementValuePairList();

  class  ElementValuePairContext : public antlr4::ParserRuleContext {
  public:
    ElementValuePairContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    ElementValueContext *elementValue();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ElementValuePairContext* elementValuePair();

  class  ElementValueContext : public antlr4::ParserRuleContext {
  public:
    ElementValueContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ConditionalExpressionContext *conditionalExpression();
    ElementValueArrayInitializerContext *elementValueArrayInitializer();
    AnnotationContext *annotation();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ElementValueContext* elementValue();

  class  ElementValueArrayInitializerContext : public antlr4::ParserRuleContext {
  public:
    ElementValueArrayInitializerContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ElementValueListContext *elementValueList();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ElementValueArrayInitializerContext* elementValueArrayInitializer();

  class  ElementValueListContext : public antlr4::ParserRuleContext {
  public:
    ElementValueListContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<ElementValueContext *> elementValue();
    ElementValueContext* elementValue(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ElementValueListContext* elementValueList();

  class  MarkerAnnotationContext : public antlr4::ParserRuleContext {
  public:
    MarkerAnnotationContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    TypeNameContext *typeName();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  MarkerAnnotationContext* markerAnnotation();

  class  SingleElementAnnotationContext : public antlr4::ParserRuleContext {
  public:
    SingleElementAnnotationContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    TypeNameContext *typeName();
    ElementValueContext *elementValue();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  SingleElementAnnotationContext* singleElementAnnotation();

  class  ArrayInitializerContext : public antlr4::ParserRuleContext {
  public:
    ArrayInitializerContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    VariableInitializerListContext *variableInitializerList();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ArrayInitializerContext* arrayInitializer();

  class  VariableInitializerListContext : public antlr4::ParserRuleContext {
  public:
    VariableInitializerListContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<VariableInitializerContext *> variableInitializer();
    VariableInitializerContext* variableInitializer(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  VariableInitializerListContext* variableInitializerList();

  class  BlockContext : public antlr4::ParserRuleContext {
  public:
    BlockContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    BlockStatementsContext *blockStatements();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  BlockContext* block();

  class  BlockStatementsContext : public antlr4::ParserRuleContext {
  public:
    BlockStatementsContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<BlockStatementContext *> blockStatement();
    BlockStatementContext* blockStatement(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  BlockStatementsContext* blockStatements();

  class  BlockStatementContext : public antlr4::ParserRuleContext {
  public:
    BlockStatementContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    LocalVariableDeclarationStatementContext *localVariableDeclarationStatement();
    ClassDeclarationContext *classDeclaration();
    StatementContext *statement();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  BlockStatementContext* blockStatement();

  class  LocalVariableDeclarationStatementContext : public antlr4::ParserRuleContext {
  public:
    LocalVariableDeclarationStatementContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    LocalVariableDeclarationContext *localVariableDeclaration();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  LocalVariableDeclarationStatementContext* localVariableDeclarationStatement();

  class  LocalVariableDeclarationContext : public antlr4::ParserRuleContext {
  public:
    LocalVariableDeclarationContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    UnannTypeContext *unannType();
    VariableDeclaratorListContext *variableDeclaratorList();
    std::vector<VariableModifierContext *> variableModifier();
    VariableModifierContext* variableModifier(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  LocalVariableDeclarationContext* localVariableDeclaration();

  class  StatementContext : public antlr4::ParserRuleContext {
  public:
    StatementContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    StatementWithoutTrailingSubstatementContext *statementWithoutTrailingSubstatement();
    LabeledStatementContext *labeledStatement();
    IfThenStatementContext *ifThenStatement();
    IfThenElseStatementContext *ifThenElseStatement();
    WhileStatementContext *whileStatement();
    ForStatementContext *forStatement();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  StatementContext* statement();

  class  StatementNoShortIfContext : public antlr4::ParserRuleContext {
  public:
    StatementNoShortIfContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    StatementWithoutTrailingSubstatementContext *statementWithoutTrailingSubstatement();
    LabeledStatementNoShortIfContext *labeledStatementNoShortIf();
    IfThenElseStatementNoShortIfContext *ifThenElseStatementNoShortIf();
    WhileStatementNoShortIfContext *whileStatementNoShortIf();
    ForStatementNoShortIfContext *forStatementNoShortIf();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  StatementNoShortIfContext* statementNoShortIf();

  class  StatementWithoutTrailingSubstatementContext : public antlr4::ParserRuleContext {
  public:
    StatementWithoutTrailingSubstatementContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    BlockContext *block();
    EmptyStatementContext *emptyStatement();
    ExpressionStatementContext *expressionStatement();
    AssertStatementContext *assertStatement();
    SwitchStatementContext *switchStatement();
    DoStatementContext *doStatement();
    BreakStatementContext *breakStatement();
    ContinueStatementContext *continueStatement();
    ReturnStatementContext *returnStatement();
    SynchronizedStatementContext *synchronizedStatement();
    ThrowStatementContext *throwStatement();
    TryStatementContext *tryStatement();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  StatementWithoutTrailingSubstatementContext* statementWithoutTrailingSubstatement();

  class  EmptyStatementContext : public antlr4::ParserRuleContext {
  public:
    EmptyStatementContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  EmptyStatementContext* emptyStatement();

  class  LabeledStatementContext : public antlr4::ParserRuleContext {
  public:
    LabeledStatementContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    StatementContext *statement();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  LabeledStatementContext* labeledStatement();

  class  LabeledStatementNoShortIfContext : public antlr4::ParserRuleContext {
  public:
    LabeledStatementNoShortIfContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    StatementNoShortIfContext *statementNoShortIf();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  LabeledStatementNoShortIfContext* labeledStatementNoShortIf();

  class  ExpressionStatementContext : public antlr4::ParserRuleContext {
  public:
    ExpressionStatementContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    StatementExpressionContext *statementExpression();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ExpressionStatementContext* expressionStatement();

  class  StatementExpressionContext : public antlr4::ParserRuleContext {
  public:
    StatementExpressionContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    AssignmentContext *assignment();
    PreIncrementExpressionContext *preIncrementExpression();
    PreDecrementExpressionContext *preDecrementExpression();
    PostIncrementExpressionContext *postIncrementExpression();
    PostDecrementExpressionContext *postDecrementExpression();
    MethodInvocationContext *methodInvocation();
    ClassInstanceCreationExpressionContext *classInstanceCreationExpression();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  StatementExpressionContext* statementExpression();

  class  IfThenStatementContext : public antlr4::ParserRuleContext {
  public:
    IfThenStatementContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExpressionContext *expression();
    StatementContext *statement();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  IfThenStatementContext* ifThenStatement();

  class  IfThenElseStatementContext : public antlr4::ParserRuleContext {
  public:
    IfThenElseStatementContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExpressionContext *expression();
    StatementNoShortIfContext *statementNoShortIf();
    StatementContext *statement();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  IfThenElseStatementContext* ifThenElseStatement();

  class  IfThenElseStatementNoShortIfContext : public antlr4::ParserRuleContext {
  public:
    IfThenElseStatementNoShortIfContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExpressionContext *expression();
    std::vector<StatementNoShortIfContext *> statementNoShortIf();
    StatementNoShortIfContext* statementNoShortIf(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  IfThenElseStatementNoShortIfContext* ifThenElseStatementNoShortIf();

  class  AssertStatementContext : public antlr4::ParserRuleContext {
  public:
    AssertStatementContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<ExpressionContext *> expression();
    ExpressionContext* expression(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  AssertStatementContext* assertStatement();

  class  SwitchStatementContext : public antlr4::ParserRuleContext {
  public:
    SwitchStatementContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExpressionContext *expression();
    SwitchBlockContext *switchBlock();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  SwitchStatementContext* switchStatement();

  class  SwitchBlockContext : public antlr4::ParserRuleContext {
  public:
    SwitchBlockContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<SwitchBlockStatementGroupContext *> switchBlockStatementGroup();
    SwitchBlockStatementGroupContext* switchBlockStatementGroup(size_t i);
    std::vector<SwitchLabelContext *> switchLabel();
    SwitchLabelContext* switchLabel(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  SwitchBlockContext* switchBlock();

  class  SwitchBlockStatementGroupContext : public antlr4::ParserRuleContext {
  public:
    SwitchBlockStatementGroupContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    SwitchLabelsContext *switchLabels();
    BlockStatementsContext *blockStatements();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  SwitchBlockStatementGroupContext* switchBlockStatementGroup();

  class  SwitchLabelsContext : public antlr4::ParserRuleContext {
  public:
    SwitchLabelsContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<SwitchLabelContext *> switchLabel();
    SwitchLabelContext* switchLabel(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  SwitchLabelsContext* switchLabels();

  class  SwitchLabelContext : public antlr4::ParserRuleContext {
  public:
    SwitchLabelContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ConstantExpressionContext *constantExpression();
    EnumConstantNameContext *enumConstantName();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  SwitchLabelContext* switchLabel();

  class  EnumConstantNameContext : public antlr4::ParserRuleContext {
  public:
    EnumConstantNameContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  EnumConstantNameContext* enumConstantName();

  class  WhileStatementContext : public antlr4::ParserRuleContext {
  public:
    WhileStatementContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExpressionContext *expression();
    StatementContext *statement();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  WhileStatementContext* whileStatement();

  class  WhileStatementNoShortIfContext : public antlr4::ParserRuleContext {
  public:
    WhileStatementNoShortIfContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExpressionContext *expression();
    StatementNoShortIfContext *statementNoShortIf();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  WhileStatementNoShortIfContext* whileStatementNoShortIf();

  class  DoStatementContext : public antlr4::ParserRuleContext {
  public:
    DoStatementContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    StatementContext *statement();
    ExpressionContext *expression();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  DoStatementContext* doStatement();

  class  ForStatementContext : public antlr4::ParserRuleContext {
  public:
    ForStatementContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    BasicForStatementContext *basicForStatement();
    EnhancedForStatementContext *enhancedForStatement();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ForStatementContext* forStatement();

  class  ForStatementNoShortIfContext : public antlr4::ParserRuleContext {
  public:
    ForStatementNoShortIfContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    BasicForStatementNoShortIfContext *basicForStatementNoShortIf();
    EnhancedForStatementNoShortIfContext *enhancedForStatementNoShortIf();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ForStatementNoShortIfContext* forStatementNoShortIf();

  class  BasicForStatementContext : public antlr4::ParserRuleContext {
  public:
    BasicForStatementContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    StatementContext *statement();
    ForInitContext *forInit();
    ExpressionContext *expression();
    ForUpdateContext *forUpdate();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  BasicForStatementContext* basicForStatement();

  class  BasicForStatementNoShortIfContext : public antlr4::ParserRuleContext {
  public:
    BasicForStatementNoShortIfContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    StatementNoShortIfContext *statementNoShortIf();
    ForInitContext *forInit();
    ExpressionContext *expression();
    ForUpdateContext *forUpdate();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  BasicForStatementNoShortIfContext* basicForStatementNoShortIf();

  class  ForInitContext : public antlr4::ParserRuleContext {
  public:
    ForInitContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    StatementExpressionListContext *statementExpressionList();
    LocalVariableDeclarationContext *localVariableDeclaration();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ForInitContext* forInit();

  class  ForUpdateContext : public antlr4::ParserRuleContext {
  public:
    ForUpdateContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    StatementExpressionListContext *statementExpressionList();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ForUpdateContext* forUpdate();

  class  StatementExpressionListContext : public antlr4::ParserRuleContext {
  public:
    StatementExpressionListContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<StatementExpressionContext *> statementExpression();
    StatementExpressionContext* statementExpression(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  StatementExpressionListContext* statementExpressionList();

  class  EnhancedForStatementContext : public antlr4::ParserRuleContext {
  public:
    EnhancedForStatementContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    UnannTypeContext *unannType();
    VariableDeclaratorIdContext *variableDeclaratorId();
    ExpressionContext *expression();
    StatementContext *statement();
    std::vector<VariableModifierContext *> variableModifier();
    VariableModifierContext* variableModifier(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  EnhancedForStatementContext* enhancedForStatement();

  class  EnhancedForStatementNoShortIfContext : public antlr4::ParserRuleContext {
  public:
    EnhancedForStatementNoShortIfContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    UnannTypeContext *unannType();
    VariableDeclaratorIdContext *variableDeclaratorId();
    ExpressionContext *expression();
    StatementNoShortIfContext *statementNoShortIf();
    std::vector<VariableModifierContext *> variableModifier();
    VariableModifierContext* variableModifier(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  EnhancedForStatementNoShortIfContext* enhancedForStatementNoShortIf();

  class  BreakStatementContext : public antlr4::ParserRuleContext {
  public:
    BreakStatementContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  BreakStatementContext* breakStatement();

  class  ContinueStatementContext : public antlr4::ParserRuleContext {
  public:
    ContinueStatementContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ContinueStatementContext* continueStatement();

  class  ReturnStatementContext : public antlr4::ParserRuleContext {
  public:
    ReturnStatementContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExpressionContext *expression();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ReturnStatementContext* returnStatement();

  class  ThrowStatementContext : public antlr4::ParserRuleContext {
  public:
    ThrowStatementContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExpressionContext *expression();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ThrowStatementContext* throwStatement();

  class  SynchronizedStatementContext : public antlr4::ParserRuleContext {
  public:
    SynchronizedStatementContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExpressionContext *expression();
    BlockContext *block();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  SynchronizedStatementContext* synchronizedStatement();

  class  TryStatementContext : public antlr4::ParserRuleContext {
  public:
    TryStatementContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    BlockContext *block();
    CatchesContext *catches();
    Finally_Context *finally_();
    TryWithResourcesStatementContext *tryWithResourcesStatement();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  TryStatementContext* tryStatement();

  class  CatchesContext : public antlr4::ParserRuleContext {
  public:
    CatchesContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<CatchClauseContext *> catchClause();
    CatchClauseContext* catchClause(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  CatchesContext* catches();

  class  CatchClauseContext : public antlr4::ParserRuleContext {
  public:
    CatchClauseContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    CatchFormalParameterContext *catchFormalParameter();
    BlockContext *block();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  CatchClauseContext* catchClause();

  class  CatchFormalParameterContext : public antlr4::ParserRuleContext {
  public:
    CatchFormalParameterContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    CatchTypeContext *catchType();
    VariableDeclaratorIdContext *variableDeclaratorId();
    std::vector<VariableModifierContext *> variableModifier();
    VariableModifierContext* variableModifier(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  CatchFormalParameterContext* catchFormalParameter();

  class  CatchTypeContext : public antlr4::ParserRuleContext {
  public:
    CatchTypeContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    UnannClassTypeContext *unannClassType();
    std::vector<ClassTypeContext *> classType();
    ClassTypeContext* classType(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  CatchTypeContext* catchType();

  class  Finally_Context : public antlr4::ParserRuleContext {
  public:
    Finally_Context(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    BlockContext *block();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  Finally_Context* finally_();

  class  TryWithResourcesStatementContext : public antlr4::ParserRuleContext {
  public:
    TryWithResourcesStatementContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ResourceSpecificationContext *resourceSpecification();
    BlockContext *block();
    CatchesContext *catches();
    Finally_Context *finally_();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  TryWithResourcesStatementContext* tryWithResourcesStatement();

  class  ResourceSpecificationContext : public antlr4::ParserRuleContext {
  public:
    ResourceSpecificationContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ResourceListContext *resourceList();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ResourceSpecificationContext* resourceSpecification();

  class  ResourceListContext : public antlr4::ParserRuleContext {
  public:
    ResourceListContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<ResourceContext *> resource();
    ResourceContext* resource(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ResourceListContext* resourceList();

  class  ResourceContext : public antlr4::ParserRuleContext {
  public:
    ResourceContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    UnannTypeContext *unannType();
    VariableDeclaratorIdContext *variableDeclaratorId();
    ExpressionContext *expression();
    std::vector<VariableModifierContext *> variableModifier();
    VariableModifierContext* variableModifier(size_t i);
    VariableAccessContext *variableAccess();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ResourceContext* resource();

  class  VariableAccessContext : public antlr4::ParserRuleContext {
  public:
    VariableAccessContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExpressionNameContext *expressionName();
    FieldAccessContext *fieldAccess();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  VariableAccessContext* variableAccess();

  class  PrimaryContext : public antlr4::ParserRuleContext {
  public:
    PrimaryContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    PrimaryNoNewArray_lfno_primaryContext *primaryNoNewArray_lfno_primary();
    ArrayCreationExpressionContext *arrayCreationExpression();
    std::vector<PrimaryNoNewArray_lf_primaryContext *> primaryNoNewArray_lf_primary();
    PrimaryNoNewArray_lf_primaryContext* primaryNoNewArray_lf_primary(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  PrimaryContext* primary();

  class  PrimaryNoNewArrayContext : public antlr4::ParserRuleContext {
  public:
    PrimaryNoNewArrayContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    LiteralContext *literal();
    ClassLiteralContext *classLiteral();
    TypeNameContext *typeName();
    ExpressionContext *expression();
    ClassInstanceCreationExpressionContext *classInstanceCreationExpression();
    FieldAccessContext *fieldAccess();
    ArrayAccessContext *arrayAccess();
    MethodInvocationContext *methodInvocation();
    MethodReferenceContext *methodReference();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  PrimaryNoNewArrayContext* primaryNoNewArray();

  class  PrimaryNoNewArray_lf_arrayAccessContext : public antlr4::ParserRuleContext {
  public:
    PrimaryNoNewArray_lf_arrayAccessContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  PrimaryNoNewArray_lf_arrayAccessContext* primaryNoNewArray_lf_arrayAccess();

  class  PrimaryNoNewArray_lfno_arrayAccessContext : public antlr4::ParserRuleContext {
  public:
    PrimaryNoNewArray_lfno_arrayAccessContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    LiteralContext *literal();
    TypeNameContext *typeName();
    ExpressionContext *expression();
    ClassInstanceCreationExpressionContext *classInstanceCreationExpression();
    FieldAccessContext *fieldAccess();
    MethodInvocationContext *methodInvocation();
    MethodReferenceContext *methodReference();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  PrimaryNoNewArray_lfno_arrayAccessContext* primaryNoNewArray_lfno_arrayAccess();

  class  PrimaryNoNewArray_lf_primaryContext : public antlr4::ParserRuleContext {
  public:
    PrimaryNoNewArray_lf_primaryContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ClassInstanceCreationExpression_lf_primaryContext *classInstanceCreationExpression_lf_primary();
    FieldAccess_lf_primaryContext *fieldAccess_lf_primary();
    ArrayAccess_lf_primaryContext *arrayAccess_lf_primary();
    MethodInvocation_lf_primaryContext *methodInvocation_lf_primary();
    MethodReference_lf_primaryContext *methodReference_lf_primary();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  PrimaryNoNewArray_lf_primaryContext* primaryNoNewArray_lf_primary();

  class  PrimaryNoNewArray_lf_primary_lf_arrayAccess_lf_primaryContext : public antlr4::ParserRuleContext {
  public:
    PrimaryNoNewArray_lf_primary_lf_arrayAccess_lf_primaryContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  PrimaryNoNewArray_lf_primary_lf_arrayAccess_lf_primaryContext* primaryNoNewArray_lf_primary_lf_arrayAccess_lf_primary();

  class  PrimaryNoNewArray_lf_primary_lfno_arrayAccess_lf_primaryContext : public antlr4::ParserRuleContext {
  public:
    PrimaryNoNewArray_lf_primary_lfno_arrayAccess_lf_primaryContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ClassInstanceCreationExpression_lf_primaryContext *classInstanceCreationExpression_lf_primary();
    FieldAccess_lf_primaryContext *fieldAccess_lf_primary();
    MethodInvocation_lf_primaryContext *methodInvocation_lf_primary();
    MethodReference_lf_primaryContext *methodReference_lf_primary();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  PrimaryNoNewArray_lf_primary_lfno_arrayAccess_lf_primaryContext* primaryNoNewArray_lf_primary_lfno_arrayAccess_lf_primary();

  class  PrimaryNoNewArray_lfno_primaryContext : public antlr4::ParserRuleContext {
  public:
    PrimaryNoNewArray_lfno_primaryContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    LiteralContext *literal();
    TypeNameContext *typeName();
    UnannPrimitiveTypeContext *unannPrimitiveType();
    ExpressionContext *expression();
    ClassInstanceCreationExpression_lfno_primaryContext *classInstanceCreationExpression_lfno_primary();
    FieldAccess_lfno_primaryContext *fieldAccess_lfno_primary();
    ArrayAccess_lfno_primaryContext *arrayAccess_lfno_primary();
    MethodInvocation_lfno_primaryContext *methodInvocation_lfno_primary();
    MethodReference_lfno_primaryContext *methodReference_lfno_primary();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  PrimaryNoNewArray_lfno_primaryContext* primaryNoNewArray_lfno_primary();

  class  PrimaryNoNewArray_lfno_primary_lf_arrayAccess_lfno_primaryContext : public antlr4::ParserRuleContext {
  public:
    PrimaryNoNewArray_lfno_primary_lf_arrayAccess_lfno_primaryContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  PrimaryNoNewArray_lfno_primary_lf_arrayAccess_lfno_primaryContext* primaryNoNewArray_lfno_primary_lf_arrayAccess_lfno_primary();

  class  PrimaryNoNewArray_lfno_primary_lfno_arrayAccess_lfno_primaryContext : public antlr4::ParserRuleContext {
  public:
    PrimaryNoNewArray_lfno_primary_lfno_arrayAccess_lfno_primaryContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    LiteralContext *literal();
    TypeNameContext *typeName();
    UnannPrimitiveTypeContext *unannPrimitiveType();
    ExpressionContext *expression();
    ClassInstanceCreationExpression_lfno_primaryContext *classInstanceCreationExpression_lfno_primary();
    FieldAccess_lfno_primaryContext *fieldAccess_lfno_primary();
    MethodInvocation_lfno_primaryContext *methodInvocation_lfno_primary();
    MethodReference_lfno_primaryContext *methodReference_lfno_primary();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  PrimaryNoNewArray_lfno_primary_lfno_arrayAccess_lfno_primaryContext* primaryNoNewArray_lfno_primary_lfno_arrayAccess_lfno_primary();

  class  ClassLiteralContext : public antlr4::ParserRuleContext {
  public:
    ClassLiteralContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    TypeNameContext *typeName();
    NumericTypeContext *numericType();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ClassLiteralContext* classLiteral();

  class  ClassInstanceCreationExpressionContext : public antlr4::ParserRuleContext {
  public:
    ClassInstanceCreationExpressionContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<IdentifierContext *> identifier();
    IdentifierContext* identifier(size_t i);
    TypeArgumentsContext *typeArguments();
    std::vector<AnnotationContext *> annotation();
    AnnotationContext* annotation(size_t i);
    TypeArgumentsOrDiamondContext *typeArgumentsOrDiamond();
    ArgumentListContext *argumentList();
    ClassBodyContext *classBody();
    ExpressionNameContext *expressionName();
    PrimaryContext *primary();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ClassInstanceCreationExpressionContext* classInstanceCreationExpression();

  class  ClassInstanceCreationExpression_lf_primaryContext : public antlr4::ParserRuleContext {
  public:
    ClassInstanceCreationExpression_lf_primaryContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    TypeArgumentsContext *typeArguments();
    std::vector<AnnotationContext *> annotation();
    AnnotationContext* annotation(size_t i);
    TypeArgumentsOrDiamondContext *typeArgumentsOrDiamond();
    ArgumentListContext *argumentList();
    ClassBodyContext *classBody();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ClassInstanceCreationExpression_lf_primaryContext* classInstanceCreationExpression_lf_primary();

  class  ClassInstanceCreationExpression_lfno_primaryContext : public antlr4::ParserRuleContext {
  public:
    ClassInstanceCreationExpression_lfno_primaryContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<IdentifierContext *> identifier();
    IdentifierContext* identifier(size_t i);
    TypeArgumentsContext *typeArguments();
    std::vector<AnnotationContext *> annotation();
    AnnotationContext* annotation(size_t i);
    TypeArgumentsOrDiamondContext *typeArgumentsOrDiamond();
    ArgumentListContext *argumentList();
    ClassBodyContext *classBody();
    ExpressionNameContext *expressionName();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ClassInstanceCreationExpression_lfno_primaryContext* classInstanceCreationExpression_lfno_primary();

  class  TypeArgumentsOrDiamondContext : public antlr4::ParserRuleContext {
  public:
    TypeArgumentsOrDiamondContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    TypeArgumentsContext *typeArguments();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  TypeArgumentsOrDiamondContext* typeArgumentsOrDiamond();

  class  FieldAccessContext : public antlr4::ParserRuleContext {
  public:
    FieldAccessContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    PrimaryContext *primary();
    IdentifierContext *identifier();
    TypeNameContext *typeName();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  FieldAccessContext* fieldAccess();

  class  FieldAccess_lf_primaryContext : public antlr4::ParserRuleContext {
  public:
    FieldAccess_lf_primaryContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  FieldAccess_lf_primaryContext* fieldAccess_lf_primary();

  class  FieldAccess_lfno_primaryContext : public antlr4::ParserRuleContext {
  public:
    FieldAccess_lfno_primaryContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    TypeNameContext *typeName();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  FieldAccess_lfno_primaryContext* fieldAccess_lfno_primary();

  class  ArrayAccessContext : public antlr4::ParserRuleContext {
  public:
    ArrayAccessContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExpressionNameContext *expressionName();
    std::vector<ExpressionContext *> expression();
    ExpressionContext* expression(size_t i);
    PrimaryNoNewArray_lfno_arrayAccessContext *primaryNoNewArray_lfno_arrayAccess();
    std::vector<PrimaryNoNewArray_lf_arrayAccessContext *> primaryNoNewArray_lf_arrayAccess();
    PrimaryNoNewArray_lf_arrayAccessContext* primaryNoNewArray_lf_arrayAccess(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ArrayAccessContext* arrayAccess();

  class  ArrayAccess_lf_primaryContext : public antlr4::ParserRuleContext {
  public:
    ArrayAccess_lf_primaryContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    PrimaryNoNewArray_lf_primary_lfno_arrayAccess_lf_primaryContext *primaryNoNewArray_lf_primary_lfno_arrayAccess_lf_primary();
    std::vector<ExpressionContext *> expression();
    ExpressionContext* expression(size_t i);
    std::vector<PrimaryNoNewArray_lf_primary_lf_arrayAccess_lf_primaryContext *> primaryNoNewArray_lf_primary_lf_arrayAccess_lf_primary();
    PrimaryNoNewArray_lf_primary_lf_arrayAccess_lf_primaryContext* primaryNoNewArray_lf_primary_lf_arrayAccess_lf_primary(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ArrayAccess_lf_primaryContext* arrayAccess_lf_primary();

  class  ArrayAccess_lfno_primaryContext : public antlr4::ParserRuleContext {
  public:
    ArrayAccess_lfno_primaryContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExpressionNameContext *expressionName();
    std::vector<ExpressionContext *> expression();
    ExpressionContext* expression(size_t i);
    PrimaryNoNewArray_lfno_primary_lfno_arrayAccess_lfno_primaryContext *primaryNoNewArray_lfno_primary_lfno_arrayAccess_lfno_primary();
    std::vector<PrimaryNoNewArray_lfno_primary_lf_arrayAccess_lfno_primaryContext *> primaryNoNewArray_lfno_primary_lf_arrayAccess_lfno_primary();
    PrimaryNoNewArray_lfno_primary_lf_arrayAccess_lfno_primaryContext* primaryNoNewArray_lfno_primary_lf_arrayAccess_lfno_primary(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ArrayAccess_lfno_primaryContext* arrayAccess_lfno_primary();

  class  MethodInvocationContext : public antlr4::ParserRuleContext {
  public:
    MethodInvocationContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    MethodNameContext *methodName();
    ArgumentListContext *argumentList();
    TypeNameContext *typeName();
    IdentifierContext *identifier();
    TypeArgumentsContext *typeArguments();
    ExpressionNameContext *expressionName();
    PrimaryContext *primary();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  MethodInvocationContext* methodInvocation();

  class  MethodInvocation_lf_primaryContext : public antlr4::ParserRuleContext {
  public:
    MethodInvocation_lf_primaryContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    TypeArgumentsContext *typeArguments();
    ArgumentListContext *argumentList();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  MethodInvocation_lf_primaryContext* methodInvocation_lf_primary();

  class  MethodInvocation_lfno_primaryContext : public antlr4::ParserRuleContext {
  public:
    MethodInvocation_lfno_primaryContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    MethodNameContext *methodName();
    ArgumentListContext *argumentList();
    TypeNameContext *typeName();
    IdentifierContext *identifier();
    TypeArgumentsContext *typeArguments();
    ExpressionNameContext *expressionName();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  MethodInvocation_lfno_primaryContext* methodInvocation_lfno_primary();

  class  ArgumentListContext : public antlr4::ParserRuleContext {
  public:
    ArgumentListContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<ExpressionContext *> expression();
    ExpressionContext* expression(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ArgumentListContext* argumentList();

  class  MethodReferenceContext : public antlr4::ParserRuleContext {
  public:
    MethodReferenceContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExpressionNameContext *expressionName();
    IdentifierContext *identifier();
    TypeArgumentsContext *typeArguments();
    ReferenceTypeContext *referenceType();
    PrimaryContext *primary();
    TypeNameContext *typeName();
    ClassTypeContext *classType();
    ArrayTypeContext *arrayType();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  MethodReferenceContext* methodReference();

  class  MethodReference_lf_primaryContext : public antlr4::ParserRuleContext {
  public:
    MethodReference_lf_primaryContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    TypeArgumentsContext *typeArguments();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  MethodReference_lf_primaryContext* methodReference_lf_primary();

  class  MethodReference_lfno_primaryContext : public antlr4::ParserRuleContext {
  public:
    MethodReference_lfno_primaryContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExpressionNameContext *expressionName();
    IdentifierContext *identifier();
    TypeArgumentsContext *typeArguments();
    ReferenceTypeContext *referenceType();
    TypeNameContext *typeName();
    ClassTypeContext *classType();
    ArrayTypeContext *arrayType();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  MethodReference_lfno_primaryContext* methodReference_lfno_primary();

  class  ArrayCreationExpressionContext : public antlr4::ParserRuleContext {
  public:
    ArrayCreationExpressionContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    PrimitiveTypeContext *primitiveType();
    DimExprsContext *dimExprs();
    DimsContext *dims();
    ClassOrInterfaceTypeContext *classOrInterfaceType();
    ArrayInitializerContext *arrayInitializer();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ArrayCreationExpressionContext* arrayCreationExpression();

  class  DimExprsContext : public antlr4::ParserRuleContext {
  public:
    DimExprsContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<DimExprContext *> dimExpr();
    DimExprContext* dimExpr(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  DimExprsContext* dimExprs();

  class  DimExprContext : public antlr4::ParserRuleContext {
  public:
    DimExprContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExpressionContext *expression();
    std::vector<AnnotationContext *> annotation();
    AnnotationContext* annotation(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  DimExprContext* dimExpr();

  class  ConstantExpressionContext : public antlr4::ParserRuleContext {
  public:
    ConstantExpressionContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExpressionContext *expression();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ConstantExpressionContext* constantExpression();

  class  ExpressionContext : public antlr4::ParserRuleContext {
  public:
    ExpressionContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    LambdaExpressionContext *lambdaExpression();
    AssignmentExpressionContext *assignmentExpression();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ExpressionContext* expression();

  class  LambdaExpressionContext : public antlr4::ParserRuleContext {
  public:
    LambdaExpressionContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    LambdaParametersContext *lambdaParameters();
    LambdaBodyContext *lambdaBody();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  LambdaExpressionContext* lambdaExpression();

  class  LambdaParametersContext : public antlr4::ParserRuleContext {
  public:
    LambdaParametersContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    FormalParameterListContext *formalParameterList();
    InferredFormalParameterListContext *inferredFormalParameterList();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  LambdaParametersContext* lambdaParameters();

  class  InferredFormalParameterListContext : public antlr4::ParserRuleContext {
  public:
    InferredFormalParameterListContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<IdentifierContext *> identifier();
    IdentifierContext* identifier(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  InferredFormalParameterListContext* inferredFormalParameterList();

  class  LambdaBodyContext : public antlr4::ParserRuleContext {
  public:
    LambdaBodyContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExpressionContext *expression();
    BlockContext *block();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  LambdaBodyContext* lambdaBody();

  class  AssignmentExpressionContext : public antlr4::ParserRuleContext {
  public:
    AssignmentExpressionContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ConditionalExpressionContext *conditionalExpression();
    AssignmentContext *assignment();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  AssignmentExpressionContext* assignmentExpression();

  class  AssignmentContext : public antlr4::ParserRuleContext {
  public:
    AssignmentContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    LeftHandSideContext *leftHandSide();
    AssignmentOperatorContext *assignmentOperator();
    ExpressionContext *expression();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  AssignmentContext* assignment();

  class  LeftHandSideContext : public antlr4::ParserRuleContext {
  public:
    LeftHandSideContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExpressionNameContext *expressionName();
    FieldAccessContext *fieldAccess();
    ArrayAccessContext *arrayAccess();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  LeftHandSideContext* leftHandSide();

  class  AssignmentOperatorContext : public antlr4::ParserRuleContext {
  public:
    AssignmentOperatorContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  AssignmentOperatorContext* assignmentOperator();

  class  ConditionalExpressionContext : public antlr4::ParserRuleContext {
  public:
    ConditionalExpressionContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ConditionalOrExpressionContext *conditionalOrExpression();
    ExpressionContext *expression();
    ConditionalExpressionContext *conditionalExpression();
    LambdaExpressionContext *lambdaExpression();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ConditionalExpressionContext* conditionalExpression();

  class  ConditionalOrExpressionContext : public antlr4::ParserRuleContext {
  public:
    ConditionalOrExpressionContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ConditionalAndExpressionContext *conditionalAndExpression();
    ConditionalOrExpressionContext *conditionalOrExpression();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ConditionalOrExpressionContext* conditionalOrExpression();
  ConditionalOrExpressionContext* conditionalOrExpression(int precedence);
  class  ConditionalAndExpressionContext : public antlr4::ParserRuleContext {
  public:
    ConditionalAndExpressionContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    InclusiveOrExpressionContext *inclusiveOrExpression();
    ConditionalAndExpressionContext *conditionalAndExpression();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ConditionalAndExpressionContext* conditionalAndExpression();
  ConditionalAndExpressionContext* conditionalAndExpression(int precedence);
  class  InclusiveOrExpressionContext : public antlr4::ParserRuleContext {
  public:
    InclusiveOrExpressionContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExclusiveOrExpressionContext *exclusiveOrExpression();
    InclusiveOrExpressionContext *inclusiveOrExpression();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  InclusiveOrExpressionContext* inclusiveOrExpression();
  InclusiveOrExpressionContext* inclusiveOrExpression(int precedence);
  class  ExclusiveOrExpressionContext : public antlr4::ParserRuleContext {
  public:
    ExclusiveOrExpressionContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    AndExpressionContext *andExpression();
    ExclusiveOrExpressionContext *exclusiveOrExpression();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ExclusiveOrExpressionContext* exclusiveOrExpression();
  ExclusiveOrExpressionContext* exclusiveOrExpression(int precedence);
  class  AndExpressionContext : public antlr4::ParserRuleContext {
  public:
    AndExpressionContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    EqualityExpressionContext *equalityExpression();
    AndExpressionContext *andExpression();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  AndExpressionContext* andExpression();
  AndExpressionContext* andExpression(int precedence);
  class  EqualityExpressionContext : public antlr4::ParserRuleContext {
  public:
    EqualityExpressionContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    RelationalExpressionContext *relationalExpression();
    EqualityExpressionContext *equalityExpression();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  EqualityExpressionContext* equalityExpression();
  EqualityExpressionContext* equalityExpression(int precedence);
  class  RelationalExpressionContext : public antlr4::ParserRuleContext {
  public:
    RelationalExpressionContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ShiftExpressionContext *shiftExpression();
    RelationalExpressionContext *relationalExpression();
    ReferenceTypeContext *referenceType();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  RelationalExpressionContext* relationalExpression();
  RelationalExpressionContext* relationalExpression(int precedence);
  class  ShiftExpressionContext : public antlr4::ParserRuleContext {
  public:
    ShiftExpressionContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    AdditiveExpressionContext *additiveExpression();
    ShiftExpressionContext *shiftExpression();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ShiftExpressionContext* shiftExpression();
  ShiftExpressionContext* shiftExpression(int precedence);
  class  AdditiveExpressionContext : public antlr4::ParserRuleContext {
  public:
    AdditiveExpressionContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    MultiplicativeExpressionContext *multiplicativeExpression();
    AdditiveExpressionContext *additiveExpression();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  AdditiveExpressionContext* additiveExpression();
  AdditiveExpressionContext* additiveExpression(int precedence);
  class  MultiplicativeExpressionContext : public antlr4::ParserRuleContext {
  public:
    MultiplicativeExpressionContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    UnaryExpressionContext *unaryExpression();
    MultiplicativeExpressionContext *multiplicativeExpression();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  MultiplicativeExpressionContext* multiplicativeExpression();
  MultiplicativeExpressionContext* multiplicativeExpression(int precedence);
  class  UnaryExpressionContext : public antlr4::ParserRuleContext {
  public:
    UnaryExpressionContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    PreIncrementExpressionContext *preIncrementExpression();
    PreDecrementExpressionContext *preDecrementExpression();
    UnaryExpressionContext *unaryExpression();
    UnaryExpressionNotPlusMinusContext *unaryExpressionNotPlusMinus();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  UnaryExpressionContext* unaryExpression();

  class  PreIncrementExpressionContext : public antlr4::ParserRuleContext {
  public:
    PreIncrementExpressionContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    UnaryExpressionContext *unaryExpression();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  PreIncrementExpressionContext* preIncrementExpression();

  class  PreDecrementExpressionContext : public antlr4::ParserRuleContext {
  public:
    PreDecrementExpressionContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    UnaryExpressionContext *unaryExpression();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  PreDecrementExpressionContext* preDecrementExpression();

  class  UnaryExpressionNotPlusMinusContext : public antlr4::ParserRuleContext {
  public:
    UnaryExpressionNotPlusMinusContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    PostfixExpressionContext *postfixExpression();
    UnaryExpressionContext *unaryExpression();
    CastExpressionContext *castExpression();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  UnaryExpressionNotPlusMinusContext* unaryExpressionNotPlusMinus();

  class  PostfixExpressionContext : public antlr4::ParserRuleContext {
  public:
    PostfixExpressionContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    PrimaryContext *primary();
    ExpressionNameContext *expressionName();
    std::vector<PostIncrementExpression_lf_postfixExpressionContext *> postIncrementExpression_lf_postfixExpression();
    PostIncrementExpression_lf_postfixExpressionContext* postIncrementExpression_lf_postfixExpression(size_t i);
    std::vector<PostDecrementExpression_lf_postfixExpressionContext *> postDecrementExpression_lf_postfixExpression();
    PostDecrementExpression_lf_postfixExpressionContext* postDecrementExpression_lf_postfixExpression(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  PostfixExpressionContext* postfixExpression();

  class  PostIncrementExpressionContext : public antlr4::ParserRuleContext {
  public:
    PostIncrementExpressionContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    PostfixExpressionContext *postfixExpression();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  PostIncrementExpressionContext* postIncrementExpression();

  class  PostIncrementExpression_lf_postfixExpressionContext : public antlr4::ParserRuleContext {
  public:
    PostIncrementExpression_lf_postfixExpressionContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  PostIncrementExpression_lf_postfixExpressionContext* postIncrementExpression_lf_postfixExpression();

  class  PostDecrementExpressionContext : public antlr4::ParserRuleContext {
  public:
    PostDecrementExpressionContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    PostfixExpressionContext *postfixExpression();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  PostDecrementExpressionContext* postDecrementExpression();

  class  PostDecrementExpression_lf_postfixExpressionContext : public antlr4::ParserRuleContext {
  public:
    PostDecrementExpression_lf_postfixExpressionContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  PostDecrementExpression_lf_postfixExpressionContext* postDecrementExpression_lf_postfixExpression();

  class  CastExpressionContext : public antlr4::ParserRuleContext {
  public:
    CastExpressionContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    PrimitiveTypeContext *primitiveType();
    UnaryExpressionContext *unaryExpression();
    ReferenceTypeContext *referenceType();
    UnaryExpressionNotPlusMinusContext *unaryExpressionNotPlusMinus();
    std::vector<AdditionalBoundContext *> additionalBound();
    AdditionalBoundContext* additionalBound(size_t i);
    LambdaExpressionContext *lambdaExpression();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  CastExpressionContext* castExpression();

  class  Literal_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    Literal_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *IntegerLiteral();
    antlr4::tree::TerminalNode *EOF();
    antlr4::tree::TerminalNode *FloatingPointLiteral();
    antlr4::tree::TerminalNode *BooleanLiteral();
    antlr4::tree::TerminalNode *CharacterLiteral();
    antlr4::tree::TerminalNode *StringLiteral();
    antlr4::tree::TerminalNode *NullLiteral();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  Literal_DropletFileContext* literal_DropletFile();

  class  PrimitiveType_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    PrimitiveType_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    NumericTypeContext *numericType();
    antlr4::tree::TerminalNode *EOF();
    std::vector<AnnotationContext *> annotation();
    AnnotationContext* annotation(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  PrimitiveType_DropletFileContext* primitiveType_DropletFile();

  class  NumericType_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    NumericType_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IntegralTypeContext *integralType();
    antlr4::tree::TerminalNode *EOF();
    FloatingPointTypeContext *floatingPointType();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  NumericType_DropletFileContext* numericType_DropletFile();

  class  IntegralType_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    IntegralType_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  IntegralType_DropletFileContext* integralType_DropletFile();

  class  FloatingPointType_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    FloatingPointType_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  FloatingPointType_DropletFileContext* floatingPointType_DropletFile();

  class  ReferenceType_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ReferenceType_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ClassOrInterfaceTypeContext *classOrInterfaceType();
    antlr4::tree::TerminalNode *EOF();
    TypeVariableContext *typeVariable();
    ArrayTypeContext *arrayType();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ReferenceType_DropletFileContext* referenceType_DropletFile();

  class  ClassOrInterfaceType_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ClassOrInterfaceType_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ClassType_lfno_classOrInterfaceTypeContext *classType_lfno_classOrInterfaceType();
    std::vector<antlr4::tree::TerminalNode *> EOF();
    antlr4::tree::TerminalNode* EOF(size_t i);
    InterfaceType_lfno_classOrInterfaceTypeContext *interfaceType_lfno_classOrInterfaceType();
    std::vector<ClassType_lf_classOrInterfaceTypeContext *> classType_lf_classOrInterfaceType();
    ClassType_lf_classOrInterfaceTypeContext* classType_lf_classOrInterfaceType(size_t i);
    std::vector<InterfaceType_lf_classOrInterfaceTypeContext *> interfaceType_lf_classOrInterfaceType();
    InterfaceType_lf_classOrInterfaceTypeContext* interfaceType_lf_classOrInterfaceType(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ClassOrInterfaceType_DropletFileContext* classOrInterfaceType_DropletFile();

  class  ClassType_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ClassType_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    antlr4::tree::TerminalNode *EOF();
    std::vector<AnnotationContext *> annotation();
    AnnotationContext* annotation(size_t i);
    TypeArgumentsContext *typeArguments();
    ClassOrInterfaceTypeContext *classOrInterfaceType();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ClassType_DropletFileContext* classType_DropletFile();

  class  ClassType_lf_classOrInterfaceType_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ClassType_lf_classOrInterfaceType_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    antlr4::tree::TerminalNode *EOF();
    std::vector<AnnotationContext *> annotation();
    AnnotationContext* annotation(size_t i);
    TypeArgumentsContext *typeArguments();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ClassType_lf_classOrInterfaceType_DropletFileContext* classType_lf_classOrInterfaceType_DropletFile();

  class  ClassType_lfno_classOrInterfaceType_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ClassType_lfno_classOrInterfaceType_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    antlr4::tree::TerminalNode *EOF();
    std::vector<AnnotationContext *> annotation();
    AnnotationContext* annotation(size_t i);
    TypeArgumentsContext *typeArguments();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ClassType_lfno_classOrInterfaceType_DropletFileContext* classType_lfno_classOrInterfaceType_DropletFile();

  class  InterfaceType_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    InterfaceType_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ClassTypeContext *classType();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  InterfaceType_DropletFileContext* interfaceType_DropletFile();

  class  InterfaceType_lf_classOrInterfaceType_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    InterfaceType_lf_classOrInterfaceType_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ClassType_lf_classOrInterfaceTypeContext *classType_lf_classOrInterfaceType();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  InterfaceType_lf_classOrInterfaceType_DropletFileContext* interfaceType_lf_classOrInterfaceType_DropletFile();

  class  InterfaceType_lfno_classOrInterfaceType_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    InterfaceType_lfno_classOrInterfaceType_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ClassType_lfno_classOrInterfaceTypeContext *classType_lfno_classOrInterfaceType();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  InterfaceType_lfno_classOrInterfaceType_DropletFileContext* interfaceType_lfno_classOrInterfaceType_DropletFile();

  class  TypeVariable_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    TypeVariable_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    antlr4::tree::TerminalNode *EOF();
    std::vector<AnnotationContext *> annotation();
    AnnotationContext* annotation(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  TypeVariable_DropletFileContext* typeVariable_DropletFile();

  class  ArrayType_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ArrayType_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    PrimitiveTypeContext *primitiveType();
    DimsContext *dims();
    antlr4::tree::TerminalNode *EOF();
    ClassOrInterfaceTypeContext *classOrInterfaceType();
    TypeVariableContext *typeVariable();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ArrayType_DropletFileContext* arrayType_DropletFile();

  class  Dims_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    Dims_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *EOF();
    std::vector<AnnotationContext *> annotation();
    AnnotationContext* annotation(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  Dims_DropletFileContext* dims_DropletFile();

  class  TypeParameter_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    TypeParameter_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    std::vector<TypeParameterModifierContext *> typeParameterModifier();
    TypeParameterModifierContext* typeParameterModifier(size_t i);
    TypeBoundContext *typeBound();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  TypeParameter_DropletFileContext* typeParameter_DropletFile();

  class  TypeParameterModifier_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    TypeParameterModifier_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    AnnotationContext *annotation();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  TypeParameterModifier_DropletFileContext* typeParameterModifier_DropletFile();

  class  TypeBound_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    TypeBound_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    TypeVariableContext *typeVariable();
    antlr4::tree::TerminalNode *EOF();
    ClassOrInterfaceTypeContext *classOrInterfaceType();
    std::vector<AdditionalBoundContext *> additionalBound();
    AdditionalBoundContext* additionalBound(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  TypeBound_DropletFileContext* typeBound_DropletFile();

  class  AdditionalBound_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    AdditionalBound_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    InterfaceTypeContext *interfaceType();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  AdditionalBound_DropletFileContext* additionalBound_DropletFile();

  class  TypeArguments_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    TypeArguments_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    TypeArgumentListContext *typeArgumentList();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  TypeArguments_DropletFileContext* typeArguments_DropletFile();

  class  TypeArgumentList_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    TypeArgumentList_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<TypeArgumentContext *> typeArgument();
    TypeArgumentContext* typeArgument(size_t i);
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  TypeArgumentList_DropletFileContext* typeArgumentList_DropletFile();

  class  TypeArgument_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    TypeArgument_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ReferenceTypeContext *referenceType();
    antlr4::tree::TerminalNode *EOF();
    WildcardContext *wildcard();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  TypeArgument_DropletFileContext* typeArgument_DropletFile();

  class  Wildcard_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    Wildcard_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *EOF();
    std::vector<AnnotationContext *> annotation();
    AnnotationContext* annotation(size_t i);
    WildcardBoundsContext *wildcardBounds();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  Wildcard_DropletFileContext* wildcard_DropletFile();

  class  WildcardBounds_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    WildcardBounds_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ReferenceTypeContext *referenceType();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  WildcardBounds_DropletFileContext* wildcardBounds_DropletFile();

  class  ModuleName_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ModuleName_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    antlr4::tree::TerminalNode *EOF();
    ModuleNameContext *moduleName();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ModuleName_DropletFileContext* moduleName_DropletFile();

  class  PackageName_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    PackageName_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    antlr4::tree::TerminalNode *EOF();
    PackageNameContext *packageName();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  PackageName_DropletFileContext* packageName_DropletFile();

  class  TypeName_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    TypeName_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    antlr4::tree::TerminalNode *EOF();
    PackageOrTypeNameContext *packageOrTypeName();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  TypeName_DropletFileContext* typeName_DropletFile();

  class  PackageOrTypeName_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    PackageOrTypeName_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    antlr4::tree::TerminalNode *EOF();
    PackageOrTypeNameContext *packageOrTypeName();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  PackageOrTypeName_DropletFileContext* packageOrTypeName_DropletFile();

  class  ExpressionName_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ExpressionName_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    antlr4::tree::TerminalNode *EOF();
    AmbiguousNameContext *ambiguousName();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ExpressionName_DropletFileContext* expressionName_DropletFile();

  class  MethodName_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    MethodName_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  MethodName_DropletFileContext* methodName_DropletFile();

  class  AmbiguousName_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    AmbiguousName_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    antlr4::tree::TerminalNode *EOF();
    AmbiguousNameContext *ambiguousName();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  AmbiguousName_DropletFileContext* ambiguousName_DropletFile();

  class  CompilationUnit_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    CompilationUnit_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    OrdinaryCompilationContext *ordinaryCompilation();
    antlr4::tree::TerminalNode *EOF();
    ModularCompilationContext *modularCompilation();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  CompilationUnit_DropletFileContext* compilationUnit_DropletFile();

  class  OrdinaryCompilation_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    OrdinaryCompilation_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *EOF();
    PackageDeclarationContext *packageDeclaration();
    std::vector<ImportDeclarationContext *> importDeclaration();
    ImportDeclarationContext* importDeclaration(size_t i);
    std::vector<TypeDeclarationContext *> typeDeclaration();
    TypeDeclarationContext* typeDeclaration(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  OrdinaryCompilation_DropletFileContext* ordinaryCompilation_DropletFile();

  class  ModularCompilation_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ModularCompilation_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ModuleDeclarationContext *moduleDeclaration();
    antlr4::tree::TerminalNode *EOF();
    std::vector<ImportDeclarationContext *> importDeclaration();
    ImportDeclarationContext* importDeclaration(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ModularCompilation_DropletFileContext* modularCompilation_DropletFile();

  class  PackageDeclaration_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    PackageDeclaration_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    PackageNameContext *packageName();
    antlr4::tree::TerminalNode *EOF();
    std::vector<PackageModifierContext *> packageModifier();
    PackageModifierContext* packageModifier(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  PackageDeclaration_DropletFileContext* packageDeclaration_DropletFile();

  class  PackageModifier_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    PackageModifier_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    AnnotationContext *annotation();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  PackageModifier_DropletFileContext* packageModifier_DropletFile();

  class  ImportDeclaration_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ImportDeclaration_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    SingleTypeImportDeclarationContext *singleTypeImportDeclaration();
    antlr4::tree::TerminalNode *EOF();
    TypeImportOnDemandDeclarationContext *typeImportOnDemandDeclaration();
    SingleStaticImportDeclarationContext *singleStaticImportDeclaration();
    StaticImportOnDemandDeclarationContext *staticImportOnDemandDeclaration();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ImportDeclaration_DropletFileContext* importDeclaration_DropletFile();

  class  SingleTypeImportDeclaration_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    SingleTypeImportDeclaration_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    TypeNameContext *typeName();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  SingleTypeImportDeclaration_DropletFileContext* singleTypeImportDeclaration_DropletFile();

  class  TypeImportOnDemandDeclaration_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    TypeImportOnDemandDeclaration_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    PackageOrTypeNameContext *packageOrTypeName();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  TypeImportOnDemandDeclaration_DropletFileContext* typeImportOnDemandDeclaration_DropletFile();

  class  SingleStaticImportDeclaration_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    SingleStaticImportDeclaration_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    TypeNameContext *typeName();
    IdentifierContext *identifier();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  SingleStaticImportDeclaration_DropletFileContext* singleStaticImportDeclaration_DropletFile();

  class  StaticImportOnDemandDeclaration_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    StaticImportOnDemandDeclaration_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    TypeNameContext *typeName();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  StaticImportOnDemandDeclaration_DropletFileContext* staticImportOnDemandDeclaration_DropletFile();

  class  TypeDeclaration_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    TypeDeclaration_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ClassDeclarationContext *classDeclaration();
    antlr4::tree::TerminalNode *EOF();
    InterfaceDeclarationContext *interfaceDeclaration();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  TypeDeclaration_DropletFileContext* typeDeclaration_DropletFile();

  class  ModuleDeclaration_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ModuleDeclaration_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ModuleNameContext *moduleName();
    antlr4::tree::TerminalNode *EOF();
    std::vector<AnnotationContext *> annotation();
    AnnotationContext* annotation(size_t i);
    std::vector<ModuleDirectiveContext *> moduleDirective();
    ModuleDirectiveContext* moduleDirective(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ModuleDeclaration_DropletFileContext* moduleDeclaration_DropletFile();

  class  ModuleDirective_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ModuleDirective_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<ModuleNameContext *> moduleName();
    ModuleNameContext* moduleName(size_t i);
    antlr4::tree::TerminalNode *EOF();
    std::vector<RequiresModifierContext *> requiresModifier();
    RequiresModifierContext* requiresModifier(size_t i);
    PackageNameContext *packageName();
    std::vector<TypeNameContext *> typeName();
    TypeNameContext* typeName(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ModuleDirective_DropletFileContext* moduleDirective_DropletFile();

  class  RequiresModifier_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    RequiresModifier_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  RequiresModifier_DropletFileContext* requiresModifier_DropletFile();

  class  ClassDeclaration_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ClassDeclaration_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    NormalClassDeclarationContext *normalClassDeclaration();
    antlr4::tree::TerminalNode *EOF();
    EnumDeclarationContext *enumDeclaration();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ClassDeclaration_DropletFileContext* classDeclaration_DropletFile();

  class  NormalClassDeclaration_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    NormalClassDeclaration_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    ClassBodyContext *classBody();
    antlr4::tree::TerminalNode *EOF();
    std::vector<ClassModifierContext *> classModifier();
    ClassModifierContext* classModifier(size_t i);
    TypeParametersContext *typeParameters();
    SuperclassContext *superclass();
    SuperinterfacesContext *superinterfaces();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  NormalClassDeclaration_DropletFileContext* normalClassDeclaration_DropletFile();

  class  ClassModifier_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ClassModifier_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    AnnotationContext *annotation();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ClassModifier_DropletFileContext* classModifier_DropletFile();

  class  TypeParameters_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    TypeParameters_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    TypeParameterListContext *typeParameterList();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  TypeParameters_DropletFileContext* typeParameters_DropletFile();

  class  TypeParameterList_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    TypeParameterList_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<TypeParameterContext *> typeParameter();
    TypeParameterContext* typeParameter(size_t i);
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  TypeParameterList_DropletFileContext* typeParameterList_DropletFile();

  class  Superclass_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    Superclass_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ClassTypeContext *classType();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  Superclass_DropletFileContext* superclass_DropletFile();

  class  Superinterfaces_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    Superinterfaces_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    InterfaceTypeListContext *interfaceTypeList();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  Superinterfaces_DropletFileContext* superinterfaces_DropletFile();

  class  InterfaceTypeList_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    InterfaceTypeList_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<InterfaceTypeContext *> interfaceType();
    InterfaceTypeContext* interfaceType(size_t i);
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  InterfaceTypeList_DropletFileContext* interfaceTypeList_DropletFile();

  class  ClassBody_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ClassBody_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *EOF();
    std::vector<ClassBodyDeclarationContext *> classBodyDeclaration();
    ClassBodyDeclarationContext* classBodyDeclaration(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ClassBody_DropletFileContext* classBody_DropletFile();

  class  ClassBodyDeclaration_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ClassBodyDeclaration_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ClassMemberDeclarationContext *classMemberDeclaration();
    antlr4::tree::TerminalNode *EOF();
    InstanceInitializerContext *instanceInitializer();
    StaticInitializerContext *staticInitializer();
    ConstructorDeclarationContext *constructorDeclaration();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ClassBodyDeclaration_DropletFileContext* classBodyDeclaration_DropletFile();

  class  ClassMemberDeclaration_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ClassMemberDeclaration_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    FieldDeclarationContext *fieldDeclaration();
    antlr4::tree::TerminalNode *EOF();
    MethodDeclarationContext *methodDeclaration();
    ClassDeclarationContext *classDeclaration();
    InterfaceDeclarationContext *interfaceDeclaration();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ClassMemberDeclaration_DropletFileContext* classMemberDeclaration_DropletFile();

  class  FieldDeclaration_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    FieldDeclaration_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    UnannTypeContext *unannType();
    VariableDeclaratorListContext *variableDeclaratorList();
    antlr4::tree::TerminalNode *EOF();
    std::vector<FieldModifierContext *> fieldModifier();
    FieldModifierContext* fieldModifier(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  FieldDeclaration_DropletFileContext* fieldDeclaration_DropletFile();

  class  FieldModifier_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    FieldModifier_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    AnnotationContext *annotation();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  FieldModifier_DropletFileContext* fieldModifier_DropletFile();

  class  VariableDeclaratorList_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    VariableDeclaratorList_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<VariableDeclaratorContext *> variableDeclarator();
    VariableDeclaratorContext* variableDeclarator(size_t i);
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  VariableDeclaratorList_DropletFileContext* variableDeclaratorList_DropletFile();

  class  VariableDeclarator_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    VariableDeclarator_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    VariableDeclaratorIdContext *variableDeclaratorId();
    antlr4::tree::TerminalNode *EOF();
    VariableInitializerContext *variableInitializer();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  VariableDeclarator_DropletFileContext* variableDeclarator_DropletFile();

  class  VariableDeclaratorId_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    VariableDeclaratorId_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    antlr4::tree::TerminalNode *EOF();
    DimsContext *dims();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  VariableDeclaratorId_DropletFileContext* variableDeclaratorId_DropletFile();

  class  VariableInitializer_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    VariableInitializer_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExpressionContext *expression();
    antlr4::tree::TerminalNode *EOF();
    ArrayInitializerContext *arrayInitializer();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  VariableInitializer_DropletFileContext* variableInitializer_DropletFile();

  class  UnannType_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    UnannType_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    UnannPrimitiveTypeContext *unannPrimitiveType();
    antlr4::tree::TerminalNode *EOF();
    UnannReferenceTypeContext *unannReferenceType();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  UnannType_DropletFileContext* unannType_DropletFile();

  class  UnannPrimitiveType_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    UnannPrimitiveType_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    NumericTypeContext *numericType();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  UnannPrimitiveType_DropletFileContext* unannPrimitiveType_DropletFile();

  class  UnannReferenceType_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    UnannReferenceType_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    UnannClassOrInterfaceTypeContext *unannClassOrInterfaceType();
    antlr4::tree::TerminalNode *EOF();
    UnannTypeVariableContext *unannTypeVariable();
    UnannArrayTypeContext *unannArrayType();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  UnannReferenceType_DropletFileContext* unannReferenceType_DropletFile();

  class  UnannClassOrInterfaceType_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    UnannClassOrInterfaceType_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    UnannClassType_lfno_unannClassOrInterfaceTypeContext *unannClassType_lfno_unannClassOrInterfaceType();
    std::vector<antlr4::tree::TerminalNode *> EOF();
    antlr4::tree::TerminalNode* EOF(size_t i);
    UnannInterfaceType_lfno_unannClassOrInterfaceTypeContext *unannInterfaceType_lfno_unannClassOrInterfaceType();
    std::vector<UnannClassType_lf_unannClassOrInterfaceTypeContext *> unannClassType_lf_unannClassOrInterfaceType();
    UnannClassType_lf_unannClassOrInterfaceTypeContext* unannClassType_lf_unannClassOrInterfaceType(size_t i);
    std::vector<UnannInterfaceType_lf_unannClassOrInterfaceTypeContext *> unannInterfaceType_lf_unannClassOrInterfaceType();
    UnannInterfaceType_lf_unannClassOrInterfaceTypeContext* unannInterfaceType_lf_unannClassOrInterfaceType(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  UnannClassOrInterfaceType_DropletFileContext* unannClassOrInterfaceType_DropletFile();

  class  UnannClassType_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    UnannClassType_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    antlr4::tree::TerminalNode *EOF();
    TypeArgumentsContext *typeArguments();
    UnannClassOrInterfaceTypeContext *unannClassOrInterfaceType();
    std::vector<AnnotationContext *> annotation();
    AnnotationContext* annotation(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  UnannClassType_DropletFileContext* unannClassType_DropletFile();

  class  UnannClassType_lf_unannClassOrInterfaceType_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    UnannClassType_lf_unannClassOrInterfaceType_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    antlr4::tree::TerminalNode *EOF();
    std::vector<AnnotationContext *> annotation();
    AnnotationContext* annotation(size_t i);
    TypeArgumentsContext *typeArguments();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  UnannClassType_lf_unannClassOrInterfaceType_DropletFileContext* unannClassType_lf_unannClassOrInterfaceType_DropletFile();

  class  UnannClassType_lfno_unannClassOrInterfaceType_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    UnannClassType_lfno_unannClassOrInterfaceType_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    antlr4::tree::TerminalNode *EOF();
    TypeArgumentsContext *typeArguments();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  UnannClassType_lfno_unannClassOrInterfaceType_DropletFileContext* unannClassType_lfno_unannClassOrInterfaceType_DropletFile();

  class  UnannInterfaceType_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    UnannInterfaceType_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    UnannClassTypeContext *unannClassType();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  UnannInterfaceType_DropletFileContext* unannInterfaceType_DropletFile();

  class  UnannInterfaceType_lf_unannClassOrInterfaceType_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    UnannInterfaceType_lf_unannClassOrInterfaceType_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    UnannClassType_lf_unannClassOrInterfaceTypeContext *unannClassType_lf_unannClassOrInterfaceType();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  UnannInterfaceType_lf_unannClassOrInterfaceType_DropletFileContext* unannInterfaceType_lf_unannClassOrInterfaceType_DropletFile();

  class  UnannInterfaceType_lfno_unannClassOrInterfaceType_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    UnannInterfaceType_lfno_unannClassOrInterfaceType_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    UnannClassType_lfno_unannClassOrInterfaceTypeContext *unannClassType_lfno_unannClassOrInterfaceType();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  UnannInterfaceType_lfno_unannClassOrInterfaceType_DropletFileContext* unannInterfaceType_lfno_unannClassOrInterfaceType_DropletFile();

  class  UnannTypeVariable_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    UnannTypeVariable_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  UnannTypeVariable_DropletFileContext* unannTypeVariable_DropletFile();

  class  UnannArrayType_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    UnannArrayType_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    UnannPrimitiveTypeContext *unannPrimitiveType();
    DimsContext *dims();
    antlr4::tree::TerminalNode *EOF();
    UnannClassOrInterfaceTypeContext *unannClassOrInterfaceType();
    UnannTypeVariableContext *unannTypeVariable();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  UnannArrayType_DropletFileContext* unannArrayType_DropletFile();

  class  MethodDeclaration_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    MethodDeclaration_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    MethodHeaderContext *methodHeader();
    MethodBodyContext *methodBody();
    antlr4::tree::TerminalNode *EOF();
    std::vector<MethodModifierContext *> methodModifier();
    MethodModifierContext* methodModifier(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  MethodDeclaration_DropletFileContext* methodDeclaration_DropletFile();

  class  MethodModifier_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    MethodModifier_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    AnnotationContext *annotation();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  MethodModifier_DropletFileContext* methodModifier_DropletFile();

  class  MethodHeader_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    MethodHeader_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ResultContext *result();
    MethodDeclaratorContext *methodDeclarator();
    antlr4::tree::TerminalNode *EOF();
    Throws_Context *throws_();
    TypeParametersContext *typeParameters();
    std::vector<AnnotationContext *> annotation();
    AnnotationContext* annotation(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  MethodHeader_DropletFileContext* methodHeader_DropletFile();

  class  Result_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    Result_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    UnannTypeContext *unannType();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  Result_DropletFileContext* result_DropletFile();

  class  MethodDeclarator_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    MethodDeclarator_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    antlr4::tree::TerminalNode *EOF();
    FormalParameterListContext *formalParameterList();
    DimsContext *dims();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  MethodDeclarator_DropletFileContext* methodDeclarator_DropletFile();

  class  FormalParameterList_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    FormalParameterList_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    FormalParametersContext *formalParameters();
    LastFormalParameterContext *lastFormalParameter();
    antlr4::tree::TerminalNode *EOF();
    ReceiverParameterContext *receiverParameter();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  FormalParameterList_DropletFileContext* formalParameterList_DropletFile();

  class  FormalParameters_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    FormalParameters_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<FormalParameterContext *> formalParameter();
    FormalParameterContext* formalParameter(size_t i);
    antlr4::tree::TerminalNode *EOF();
    ReceiverParameterContext *receiverParameter();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  FormalParameters_DropletFileContext* formalParameters_DropletFile();

  class  FormalParameter_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    FormalParameter_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    UnannTypeContext *unannType();
    VariableDeclaratorIdContext *variableDeclaratorId();
    antlr4::tree::TerminalNode *EOF();
    std::vector<VariableModifierContext *> variableModifier();
    VariableModifierContext* variableModifier(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  FormalParameter_DropletFileContext* formalParameter_DropletFile();

  class  VariableModifier_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    VariableModifier_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    AnnotationContext *annotation();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  VariableModifier_DropletFileContext* variableModifier_DropletFile();

  class  LastFormalParameter_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    LastFormalParameter_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    UnannTypeContext *unannType();
    VariableDeclaratorIdContext *variableDeclaratorId();
    antlr4::tree::TerminalNode *EOF();
    std::vector<VariableModifierContext *> variableModifier();
    VariableModifierContext* variableModifier(size_t i);
    std::vector<AnnotationContext *> annotation();
    AnnotationContext* annotation(size_t i);
    FormalParameterContext *formalParameter();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  LastFormalParameter_DropletFileContext* lastFormalParameter_DropletFile();

  class  ReceiverParameter_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ReceiverParameter_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    UnannTypeContext *unannType();
    antlr4::tree::TerminalNode *EOF();
    std::vector<AnnotationContext *> annotation();
    AnnotationContext* annotation(size_t i);
    IdentifierContext *identifier();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ReceiverParameter_DropletFileContext* receiverParameter_DropletFile();

  class  Throws__DropletFileContext : public antlr4::ParserRuleContext {
  public:
    Throws__DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExceptionTypeListContext *exceptionTypeList();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  Throws__DropletFileContext* throws__DropletFile();

  class  ExceptionTypeList_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ExceptionTypeList_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<ExceptionTypeContext *> exceptionType();
    ExceptionTypeContext* exceptionType(size_t i);
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ExceptionTypeList_DropletFileContext* exceptionTypeList_DropletFile();

  class  ExceptionType_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ExceptionType_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ClassTypeContext *classType();
    antlr4::tree::TerminalNode *EOF();
    TypeVariableContext *typeVariable();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ExceptionType_DropletFileContext* exceptionType_DropletFile();

  class  MethodBody_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    MethodBody_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    BlockContext *block();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  MethodBody_DropletFileContext* methodBody_DropletFile();

  class  InstanceInitializer_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    InstanceInitializer_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    BlockContext *block();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  InstanceInitializer_DropletFileContext* instanceInitializer_DropletFile();

  class  StaticInitializer_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    StaticInitializer_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    BlockContext *block();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  StaticInitializer_DropletFileContext* staticInitializer_DropletFile();

  class  ConstructorDeclaration_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ConstructorDeclaration_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ConstructorDeclaratorContext *constructorDeclarator();
    ConstructorBodyContext *constructorBody();
    antlr4::tree::TerminalNode *EOF();
    std::vector<ConstructorModifierContext *> constructorModifier();
    ConstructorModifierContext* constructorModifier(size_t i);
    Throws_Context *throws_();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ConstructorDeclaration_DropletFileContext* constructorDeclaration_DropletFile();

  class  ConstructorModifier_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ConstructorModifier_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    AnnotationContext *annotation();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ConstructorModifier_DropletFileContext* constructorModifier_DropletFile();

  class  ConstructorDeclarator_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ConstructorDeclarator_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    SimpleTypeNameContext *simpleTypeName();
    antlr4::tree::TerminalNode *EOF();
    TypeParametersContext *typeParameters();
    FormalParameterListContext *formalParameterList();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ConstructorDeclarator_DropletFileContext* constructorDeclarator_DropletFile();

  class  SimpleTypeName_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    SimpleTypeName_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  SimpleTypeName_DropletFileContext* simpleTypeName_DropletFile();

  class  ConstructorBody_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ConstructorBody_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *EOF();
    ExplicitConstructorInvocationContext *explicitConstructorInvocation();
    BlockStatementsContext *blockStatements();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ConstructorBody_DropletFileContext* constructorBody_DropletFile();

  class  ExplicitConstructorInvocation_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ExplicitConstructorInvocation_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *EOF();
    TypeArgumentsContext *typeArguments();
    ArgumentListContext *argumentList();
    ExpressionNameContext *expressionName();
    PrimaryContext *primary();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ExplicitConstructorInvocation_DropletFileContext* explicitConstructorInvocation_DropletFile();

  class  EnumDeclaration_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    EnumDeclaration_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    EnumBodyContext *enumBody();
    antlr4::tree::TerminalNode *EOF();
    std::vector<ClassModifierContext *> classModifier();
    ClassModifierContext* classModifier(size_t i);
    SuperinterfacesContext *superinterfaces();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  EnumDeclaration_DropletFileContext* enumDeclaration_DropletFile();

  class  EnumBody_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    EnumBody_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *EOF();
    EnumConstantListContext *enumConstantList();
    EnumBodyDeclarationsContext *enumBodyDeclarations();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  EnumBody_DropletFileContext* enumBody_DropletFile();

  class  EnumConstantList_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    EnumConstantList_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<EnumConstantContext *> enumConstant();
    EnumConstantContext* enumConstant(size_t i);
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  EnumConstantList_DropletFileContext* enumConstantList_DropletFile();

  class  EnumConstant_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    EnumConstant_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    antlr4::tree::TerminalNode *EOF();
    std::vector<EnumConstantModifierContext *> enumConstantModifier();
    EnumConstantModifierContext* enumConstantModifier(size_t i);
    ClassBodyContext *classBody();
    ArgumentListContext *argumentList();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  EnumConstant_DropletFileContext* enumConstant_DropletFile();

  class  EnumConstantModifier_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    EnumConstantModifier_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    AnnotationContext *annotation();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  EnumConstantModifier_DropletFileContext* enumConstantModifier_DropletFile();

  class  EnumBodyDeclarations_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    EnumBodyDeclarations_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *EOF();
    std::vector<ClassBodyDeclarationContext *> classBodyDeclaration();
    ClassBodyDeclarationContext* classBodyDeclaration(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  EnumBodyDeclarations_DropletFileContext* enumBodyDeclarations_DropletFile();

  class  InterfaceDeclaration_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    InterfaceDeclaration_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    NormalInterfaceDeclarationContext *normalInterfaceDeclaration();
    antlr4::tree::TerminalNode *EOF();
    AnnotationTypeDeclarationContext *annotationTypeDeclaration();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  InterfaceDeclaration_DropletFileContext* interfaceDeclaration_DropletFile();

  class  NormalInterfaceDeclaration_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    NormalInterfaceDeclaration_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    InterfaceBodyContext *interfaceBody();
    antlr4::tree::TerminalNode *EOF();
    std::vector<InterfaceModifierContext *> interfaceModifier();
    InterfaceModifierContext* interfaceModifier(size_t i);
    TypeParametersContext *typeParameters();
    ExtendsInterfacesContext *extendsInterfaces();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  NormalInterfaceDeclaration_DropletFileContext* normalInterfaceDeclaration_DropletFile();

  class  InterfaceModifier_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    InterfaceModifier_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    AnnotationContext *annotation();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  InterfaceModifier_DropletFileContext* interfaceModifier_DropletFile();

  class  ExtendsInterfaces_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ExtendsInterfaces_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    InterfaceTypeListContext *interfaceTypeList();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ExtendsInterfaces_DropletFileContext* extendsInterfaces_DropletFile();

  class  InterfaceBody_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    InterfaceBody_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *EOF();
    std::vector<InterfaceMemberDeclarationContext *> interfaceMemberDeclaration();
    InterfaceMemberDeclarationContext* interfaceMemberDeclaration(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  InterfaceBody_DropletFileContext* interfaceBody_DropletFile();

  class  InterfaceMemberDeclaration_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    InterfaceMemberDeclaration_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ConstantDeclarationContext *constantDeclaration();
    antlr4::tree::TerminalNode *EOF();
    InterfaceMethodDeclarationContext *interfaceMethodDeclaration();
    ClassDeclarationContext *classDeclaration();
    InterfaceDeclarationContext *interfaceDeclaration();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  InterfaceMemberDeclaration_DropletFileContext* interfaceMemberDeclaration_DropletFile();

  class  ConstantDeclaration_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ConstantDeclaration_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    UnannTypeContext *unannType();
    VariableDeclaratorListContext *variableDeclaratorList();
    antlr4::tree::TerminalNode *EOF();
    std::vector<ConstantModifierContext *> constantModifier();
    ConstantModifierContext* constantModifier(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ConstantDeclaration_DropletFileContext* constantDeclaration_DropletFile();

  class  ConstantModifier_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ConstantModifier_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    AnnotationContext *annotation();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ConstantModifier_DropletFileContext* constantModifier_DropletFile();

  class  InterfaceMethodDeclaration_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    InterfaceMethodDeclaration_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    MethodHeaderContext *methodHeader();
    MethodBodyContext *methodBody();
    antlr4::tree::TerminalNode *EOF();
    std::vector<InterfaceMethodModifierContext *> interfaceMethodModifier();
    InterfaceMethodModifierContext* interfaceMethodModifier(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  InterfaceMethodDeclaration_DropletFileContext* interfaceMethodDeclaration_DropletFile();

  class  InterfaceMethodModifier_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    InterfaceMethodModifier_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    AnnotationContext *annotation();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  InterfaceMethodModifier_DropletFileContext* interfaceMethodModifier_DropletFile();

  class  AnnotationTypeDeclaration_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    AnnotationTypeDeclaration_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    AnnotationTypeBodyContext *annotationTypeBody();
    antlr4::tree::TerminalNode *EOF();
    std::vector<InterfaceModifierContext *> interfaceModifier();
    InterfaceModifierContext* interfaceModifier(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  AnnotationTypeDeclaration_DropletFileContext* annotationTypeDeclaration_DropletFile();

  class  AnnotationTypeBody_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    AnnotationTypeBody_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *EOF();
    std::vector<AnnotationTypeMemberDeclarationContext *> annotationTypeMemberDeclaration();
    AnnotationTypeMemberDeclarationContext* annotationTypeMemberDeclaration(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  AnnotationTypeBody_DropletFileContext* annotationTypeBody_DropletFile();

  class  AnnotationTypeMemberDeclaration_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    AnnotationTypeMemberDeclaration_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    AnnotationTypeElementDeclarationContext *annotationTypeElementDeclaration();
    antlr4::tree::TerminalNode *EOF();
    ConstantDeclarationContext *constantDeclaration();
    ClassDeclarationContext *classDeclaration();
    InterfaceDeclarationContext *interfaceDeclaration();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  AnnotationTypeMemberDeclaration_DropletFileContext* annotationTypeMemberDeclaration_DropletFile();

  class  AnnotationTypeElementDeclaration_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    AnnotationTypeElementDeclaration_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    UnannTypeContext *unannType();
    IdentifierContext *identifier();
    antlr4::tree::TerminalNode *EOF();
    std::vector<AnnotationTypeElementModifierContext *> annotationTypeElementModifier();
    AnnotationTypeElementModifierContext* annotationTypeElementModifier(size_t i);
    DimsContext *dims();
    DefaultValueContext *defaultValue();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  AnnotationTypeElementDeclaration_DropletFileContext* annotationTypeElementDeclaration_DropletFile();

  class  AnnotationTypeElementModifier_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    AnnotationTypeElementModifier_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    AnnotationContext *annotation();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  AnnotationTypeElementModifier_DropletFileContext* annotationTypeElementModifier_DropletFile();

  class  DefaultValue_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    DefaultValue_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ElementValueContext *elementValue();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  DefaultValue_DropletFileContext* defaultValue_DropletFile();

  class  Annotation_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    Annotation_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    NormalAnnotationContext *normalAnnotation();
    antlr4::tree::TerminalNode *EOF();
    MarkerAnnotationContext *markerAnnotation();
    SingleElementAnnotationContext *singleElementAnnotation();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  Annotation_DropletFileContext* annotation_DropletFile();

  class  NormalAnnotation_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    NormalAnnotation_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    TypeNameContext *typeName();
    antlr4::tree::TerminalNode *EOF();
    ElementValuePairListContext *elementValuePairList();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  NormalAnnotation_DropletFileContext* normalAnnotation_DropletFile();

  class  ElementValuePairList_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ElementValuePairList_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<ElementValuePairContext *> elementValuePair();
    ElementValuePairContext* elementValuePair(size_t i);
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ElementValuePairList_DropletFileContext* elementValuePairList_DropletFile();

  class  ElementValuePair_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ElementValuePair_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    ElementValueContext *elementValue();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ElementValuePair_DropletFileContext* elementValuePair_DropletFile();

  class  ElementValue_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ElementValue_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ConditionalExpressionContext *conditionalExpression();
    antlr4::tree::TerminalNode *EOF();
    ElementValueArrayInitializerContext *elementValueArrayInitializer();
    AnnotationContext *annotation();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ElementValue_DropletFileContext* elementValue_DropletFile();

  class  ElementValueArrayInitializer_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ElementValueArrayInitializer_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *EOF();
    ElementValueListContext *elementValueList();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ElementValueArrayInitializer_DropletFileContext* elementValueArrayInitializer_DropletFile();

  class  ElementValueList_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ElementValueList_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<ElementValueContext *> elementValue();
    ElementValueContext* elementValue(size_t i);
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ElementValueList_DropletFileContext* elementValueList_DropletFile();

  class  MarkerAnnotation_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    MarkerAnnotation_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    TypeNameContext *typeName();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  MarkerAnnotation_DropletFileContext* markerAnnotation_DropletFile();

  class  SingleElementAnnotation_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    SingleElementAnnotation_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    TypeNameContext *typeName();
    ElementValueContext *elementValue();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  SingleElementAnnotation_DropletFileContext* singleElementAnnotation_DropletFile();

  class  ArrayInitializer_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ArrayInitializer_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *EOF();
    VariableInitializerListContext *variableInitializerList();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ArrayInitializer_DropletFileContext* arrayInitializer_DropletFile();

  class  VariableInitializerList_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    VariableInitializerList_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<VariableInitializerContext *> variableInitializer();
    VariableInitializerContext* variableInitializer(size_t i);
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  VariableInitializerList_DropletFileContext* variableInitializerList_DropletFile();

  class  Block_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    Block_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *EOF();
    BlockStatementsContext *blockStatements();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  Block_DropletFileContext* block_DropletFile();

  class  BlockStatements_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    BlockStatements_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *EOF();
    std::vector<BlockStatementContext *> blockStatement();
    BlockStatementContext* blockStatement(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  BlockStatements_DropletFileContext* blockStatements_DropletFile();

  class  BlockStatement_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    BlockStatement_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    LocalVariableDeclarationStatementContext *localVariableDeclarationStatement();
    antlr4::tree::TerminalNode *EOF();
    ClassDeclarationContext *classDeclaration();
    StatementContext *statement();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  BlockStatement_DropletFileContext* blockStatement_DropletFile();

  class  LocalVariableDeclarationStatement_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    LocalVariableDeclarationStatement_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    LocalVariableDeclarationContext *localVariableDeclaration();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  LocalVariableDeclarationStatement_DropletFileContext* localVariableDeclarationStatement_DropletFile();

  class  LocalVariableDeclaration_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    LocalVariableDeclaration_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    UnannTypeContext *unannType();
    VariableDeclaratorListContext *variableDeclaratorList();
    antlr4::tree::TerminalNode *EOF();
    std::vector<VariableModifierContext *> variableModifier();
    VariableModifierContext* variableModifier(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  LocalVariableDeclaration_DropletFileContext* localVariableDeclaration_DropletFile();

  class  Statement_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    Statement_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    StatementWithoutTrailingSubstatementContext *statementWithoutTrailingSubstatement();
    antlr4::tree::TerminalNode *EOF();
    LabeledStatementContext *labeledStatement();
    IfThenStatementContext *ifThenStatement();
    IfThenElseStatementContext *ifThenElseStatement();
    WhileStatementContext *whileStatement();
    ForStatementContext *forStatement();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  Statement_DropletFileContext* statement_DropletFile();

  class  StatementNoShortIf_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    StatementNoShortIf_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    StatementWithoutTrailingSubstatementContext *statementWithoutTrailingSubstatement();
    antlr4::tree::TerminalNode *EOF();
    LabeledStatementNoShortIfContext *labeledStatementNoShortIf();
    IfThenElseStatementNoShortIfContext *ifThenElseStatementNoShortIf();
    WhileStatementNoShortIfContext *whileStatementNoShortIf();
    ForStatementNoShortIfContext *forStatementNoShortIf();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  StatementNoShortIf_DropletFileContext* statementNoShortIf_DropletFile();

  class  StatementWithoutTrailingSubstatement_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    StatementWithoutTrailingSubstatement_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    BlockContext *block();
    antlr4::tree::TerminalNode *EOF();
    EmptyStatementContext *emptyStatement();
    ExpressionStatementContext *expressionStatement();
    AssertStatementContext *assertStatement();
    SwitchStatementContext *switchStatement();
    DoStatementContext *doStatement();
    BreakStatementContext *breakStatement();
    ContinueStatementContext *continueStatement();
    ReturnStatementContext *returnStatement();
    SynchronizedStatementContext *synchronizedStatement();
    ThrowStatementContext *throwStatement();
    TryStatementContext *tryStatement();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  StatementWithoutTrailingSubstatement_DropletFileContext* statementWithoutTrailingSubstatement_DropletFile();

  class  EmptyStatement_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    EmptyStatement_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  EmptyStatement_DropletFileContext* emptyStatement_DropletFile();

  class  LabeledStatement_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    LabeledStatement_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    StatementContext *statement();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  LabeledStatement_DropletFileContext* labeledStatement_DropletFile();

  class  LabeledStatementNoShortIf_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    LabeledStatementNoShortIf_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    StatementNoShortIfContext *statementNoShortIf();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  LabeledStatementNoShortIf_DropletFileContext* labeledStatementNoShortIf_DropletFile();

  class  ExpressionStatement_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ExpressionStatement_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    StatementExpressionContext *statementExpression();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ExpressionStatement_DropletFileContext* expressionStatement_DropletFile();

  class  StatementExpression_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    StatementExpression_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    AssignmentContext *assignment();
    antlr4::tree::TerminalNode *EOF();
    PreIncrementExpressionContext *preIncrementExpression();
    PreDecrementExpressionContext *preDecrementExpression();
    PostIncrementExpressionContext *postIncrementExpression();
    PostDecrementExpressionContext *postDecrementExpression();
    MethodInvocationContext *methodInvocation();
    ClassInstanceCreationExpressionContext *classInstanceCreationExpression();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  StatementExpression_DropletFileContext* statementExpression_DropletFile();

  class  IfThenStatement_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    IfThenStatement_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExpressionContext *expression();
    StatementContext *statement();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  IfThenStatement_DropletFileContext* ifThenStatement_DropletFile();

  class  IfThenElseStatement_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    IfThenElseStatement_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExpressionContext *expression();
    StatementNoShortIfContext *statementNoShortIf();
    StatementContext *statement();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  IfThenElseStatement_DropletFileContext* ifThenElseStatement_DropletFile();

  class  IfThenElseStatementNoShortIf_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    IfThenElseStatementNoShortIf_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExpressionContext *expression();
    std::vector<StatementNoShortIfContext *> statementNoShortIf();
    StatementNoShortIfContext* statementNoShortIf(size_t i);
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  IfThenElseStatementNoShortIf_DropletFileContext* ifThenElseStatementNoShortIf_DropletFile();

  class  AssertStatement_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    AssertStatement_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<ExpressionContext *> expression();
    ExpressionContext* expression(size_t i);
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  AssertStatement_DropletFileContext* assertStatement_DropletFile();

  class  SwitchStatement_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    SwitchStatement_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExpressionContext *expression();
    SwitchBlockContext *switchBlock();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  SwitchStatement_DropletFileContext* switchStatement_DropletFile();

  class  SwitchBlock_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    SwitchBlock_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *EOF();
    std::vector<SwitchBlockStatementGroupContext *> switchBlockStatementGroup();
    SwitchBlockStatementGroupContext* switchBlockStatementGroup(size_t i);
    std::vector<SwitchLabelContext *> switchLabel();
    SwitchLabelContext* switchLabel(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  SwitchBlock_DropletFileContext* switchBlock_DropletFile();

  class  SwitchBlockStatementGroup_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    SwitchBlockStatementGroup_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    SwitchLabelsContext *switchLabels();
    BlockStatementsContext *blockStatements();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  SwitchBlockStatementGroup_DropletFileContext* switchBlockStatementGroup_DropletFile();

  class  SwitchLabels_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    SwitchLabels_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *EOF();
    std::vector<SwitchLabelContext *> switchLabel();
    SwitchLabelContext* switchLabel(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  SwitchLabels_DropletFileContext* switchLabels_DropletFile();

  class  SwitchLabel_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    SwitchLabel_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ConstantExpressionContext *constantExpression();
    antlr4::tree::TerminalNode *EOF();
    EnumConstantNameContext *enumConstantName();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  SwitchLabel_DropletFileContext* switchLabel_DropletFile();

  class  EnumConstantName_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    EnumConstantName_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  EnumConstantName_DropletFileContext* enumConstantName_DropletFile();

  class  WhileStatement_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    WhileStatement_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExpressionContext *expression();
    StatementContext *statement();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  WhileStatement_DropletFileContext* whileStatement_DropletFile();

  class  WhileStatementNoShortIf_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    WhileStatementNoShortIf_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExpressionContext *expression();
    StatementNoShortIfContext *statementNoShortIf();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  WhileStatementNoShortIf_DropletFileContext* whileStatementNoShortIf_DropletFile();

  class  DoStatement_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    DoStatement_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    StatementContext *statement();
    ExpressionContext *expression();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  DoStatement_DropletFileContext* doStatement_DropletFile();

  class  ForStatement_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ForStatement_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    BasicForStatementContext *basicForStatement();
    antlr4::tree::TerminalNode *EOF();
    EnhancedForStatementContext *enhancedForStatement();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ForStatement_DropletFileContext* forStatement_DropletFile();

  class  ForStatementNoShortIf_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ForStatementNoShortIf_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    BasicForStatementNoShortIfContext *basicForStatementNoShortIf();
    antlr4::tree::TerminalNode *EOF();
    EnhancedForStatementNoShortIfContext *enhancedForStatementNoShortIf();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ForStatementNoShortIf_DropletFileContext* forStatementNoShortIf_DropletFile();

  class  BasicForStatement_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    BasicForStatement_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    StatementContext *statement();
    antlr4::tree::TerminalNode *EOF();
    ForInitContext *forInit();
    ExpressionContext *expression();
    ForUpdateContext *forUpdate();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  BasicForStatement_DropletFileContext* basicForStatement_DropletFile();

  class  BasicForStatementNoShortIf_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    BasicForStatementNoShortIf_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    StatementNoShortIfContext *statementNoShortIf();
    antlr4::tree::TerminalNode *EOF();
    ForInitContext *forInit();
    ExpressionContext *expression();
    ForUpdateContext *forUpdate();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  BasicForStatementNoShortIf_DropletFileContext* basicForStatementNoShortIf_DropletFile();

  class  ForInit_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ForInit_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    StatementExpressionListContext *statementExpressionList();
    antlr4::tree::TerminalNode *EOF();
    LocalVariableDeclarationContext *localVariableDeclaration();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ForInit_DropletFileContext* forInit_DropletFile();

  class  ForUpdate_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ForUpdate_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    StatementExpressionListContext *statementExpressionList();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ForUpdate_DropletFileContext* forUpdate_DropletFile();

  class  StatementExpressionList_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    StatementExpressionList_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<StatementExpressionContext *> statementExpression();
    StatementExpressionContext* statementExpression(size_t i);
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  StatementExpressionList_DropletFileContext* statementExpressionList_DropletFile();

  class  EnhancedForStatement_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    EnhancedForStatement_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    UnannTypeContext *unannType();
    VariableDeclaratorIdContext *variableDeclaratorId();
    ExpressionContext *expression();
    StatementContext *statement();
    antlr4::tree::TerminalNode *EOF();
    std::vector<VariableModifierContext *> variableModifier();
    VariableModifierContext* variableModifier(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  EnhancedForStatement_DropletFileContext* enhancedForStatement_DropletFile();

  class  EnhancedForStatementNoShortIf_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    EnhancedForStatementNoShortIf_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    UnannTypeContext *unannType();
    VariableDeclaratorIdContext *variableDeclaratorId();
    ExpressionContext *expression();
    StatementNoShortIfContext *statementNoShortIf();
    std::vector<VariableModifierContext *> variableModifier();
    VariableModifierContext* variableModifier(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  EnhancedForStatementNoShortIf_DropletFileContext* enhancedForStatementNoShortIf_DropletFile();

  class  BreakStatement_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    BreakStatement_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *EOF();
    IdentifierContext *identifier();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  BreakStatement_DropletFileContext* breakStatement_DropletFile();

  class  ContinueStatement_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ContinueStatement_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *EOF();
    IdentifierContext *identifier();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ContinueStatement_DropletFileContext* continueStatement_DropletFile();

  class  ReturnStatement_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ReturnStatement_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *EOF();
    ExpressionContext *expression();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ReturnStatement_DropletFileContext* returnStatement_DropletFile();

  class  ThrowStatement_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ThrowStatement_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExpressionContext *expression();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ThrowStatement_DropletFileContext* throwStatement_DropletFile();

  class  SynchronizedStatement_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    SynchronizedStatement_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExpressionContext *expression();
    BlockContext *block();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  SynchronizedStatement_DropletFileContext* synchronizedStatement_DropletFile();

  class  TryStatement_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    TryStatement_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    BlockContext *block();
    CatchesContext *catches();
    antlr4::tree::TerminalNode *EOF();
    Finally_Context *finally_();
    TryWithResourcesStatementContext *tryWithResourcesStatement();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  TryStatement_DropletFileContext* tryStatement_DropletFile();

  class  Catches_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    Catches_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *EOF();
    std::vector<CatchClauseContext *> catchClause();
    CatchClauseContext* catchClause(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  Catches_DropletFileContext* catches_DropletFile();

  class  CatchClause_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    CatchClause_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    CatchFormalParameterContext *catchFormalParameter();
    BlockContext *block();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  CatchClause_DropletFileContext* catchClause_DropletFile();

  class  CatchFormalParameter_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    CatchFormalParameter_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    CatchTypeContext *catchType();
    VariableDeclaratorIdContext *variableDeclaratorId();
    antlr4::tree::TerminalNode *EOF();
    std::vector<VariableModifierContext *> variableModifier();
    VariableModifierContext* variableModifier(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  CatchFormalParameter_DropletFileContext* catchFormalParameter_DropletFile();

  class  CatchType_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    CatchType_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    UnannClassTypeContext *unannClassType();
    antlr4::tree::TerminalNode *EOF();
    std::vector<ClassTypeContext *> classType();
    ClassTypeContext* classType(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  CatchType_DropletFileContext* catchType_DropletFile();

  class  Finally__DropletFileContext : public antlr4::ParserRuleContext {
  public:
    Finally__DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    BlockContext *block();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  Finally__DropletFileContext* finally__DropletFile();

  class  TryWithResourcesStatement_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    TryWithResourcesStatement_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ResourceSpecificationContext *resourceSpecification();
    BlockContext *block();
    antlr4::tree::TerminalNode *EOF();
    CatchesContext *catches();
    Finally_Context *finally_();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  TryWithResourcesStatement_DropletFileContext* tryWithResourcesStatement_DropletFile();

  class  ResourceSpecification_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ResourceSpecification_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ResourceListContext *resourceList();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ResourceSpecification_DropletFileContext* resourceSpecification_DropletFile();

  class  ResourceList_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ResourceList_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<ResourceContext *> resource();
    ResourceContext* resource(size_t i);
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ResourceList_DropletFileContext* resourceList_DropletFile();

  class  Resource_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    Resource_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    UnannTypeContext *unannType();
    VariableDeclaratorIdContext *variableDeclaratorId();
    ExpressionContext *expression();
    antlr4::tree::TerminalNode *EOF();
    std::vector<VariableModifierContext *> variableModifier();
    VariableModifierContext* variableModifier(size_t i);
    VariableAccessContext *variableAccess();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  Resource_DropletFileContext* resource_DropletFile();

  class  VariableAccess_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    VariableAccess_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExpressionNameContext *expressionName();
    antlr4::tree::TerminalNode *EOF();
    FieldAccessContext *fieldAccess();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  VariableAccess_DropletFileContext* variableAccess_DropletFile();

  class  Primary_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    Primary_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    PrimaryNoNewArray_lfno_primaryContext *primaryNoNewArray_lfno_primary();
    std::vector<antlr4::tree::TerminalNode *> EOF();
    antlr4::tree::TerminalNode* EOF(size_t i);
    ArrayCreationExpressionContext *arrayCreationExpression();
    std::vector<PrimaryNoNewArray_lf_primaryContext *> primaryNoNewArray_lf_primary();
    PrimaryNoNewArray_lf_primaryContext* primaryNoNewArray_lf_primary(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  Primary_DropletFileContext* primary_DropletFile();

  class  PrimaryNoNewArray_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    PrimaryNoNewArray_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    LiteralContext *literal();
    antlr4::tree::TerminalNode *EOF();
    ClassLiteralContext *classLiteral();
    TypeNameContext *typeName();
    ExpressionContext *expression();
    ClassInstanceCreationExpressionContext *classInstanceCreationExpression();
    FieldAccessContext *fieldAccess();
    ArrayAccessContext *arrayAccess();
    MethodInvocationContext *methodInvocation();
    MethodReferenceContext *methodReference();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  PrimaryNoNewArray_DropletFileContext* primaryNoNewArray_DropletFile();

  class  PrimaryNoNewArray_lf_arrayAccess_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    PrimaryNoNewArray_lf_arrayAccess_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  PrimaryNoNewArray_lf_arrayAccess_DropletFileContext* primaryNoNewArray_lf_arrayAccess_DropletFile();

  class  PrimaryNoNewArray_lfno_arrayAccess_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    PrimaryNoNewArray_lfno_arrayAccess_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    LiteralContext *literal();
    antlr4::tree::TerminalNode *EOF();
    TypeNameContext *typeName();
    ExpressionContext *expression();
    ClassInstanceCreationExpressionContext *classInstanceCreationExpression();
    FieldAccessContext *fieldAccess();
    MethodInvocationContext *methodInvocation();
    MethodReferenceContext *methodReference();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  PrimaryNoNewArray_lfno_arrayAccess_DropletFileContext* primaryNoNewArray_lfno_arrayAccess_DropletFile();

  class  PrimaryNoNewArray_lf_primary_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    PrimaryNoNewArray_lf_primary_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ClassInstanceCreationExpression_lf_primaryContext *classInstanceCreationExpression_lf_primary();
    antlr4::tree::TerminalNode *EOF();
    FieldAccess_lf_primaryContext *fieldAccess_lf_primary();
    ArrayAccess_lf_primaryContext *arrayAccess_lf_primary();
    MethodInvocation_lf_primaryContext *methodInvocation_lf_primary();
    MethodReference_lf_primaryContext *methodReference_lf_primary();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  PrimaryNoNewArray_lf_primary_DropletFileContext* primaryNoNewArray_lf_primary_DropletFile();

  class  PrimaryNoNewArray_lf_primary_lf_arrayAccess_lf_primary_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    PrimaryNoNewArray_lf_primary_lf_arrayAccess_lf_primary_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  PrimaryNoNewArray_lf_primary_lf_arrayAccess_lf_primary_DropletFileContext* primaryNoNewArray_lf_primary_lf_arrayAccess_lf_primary_DropletFile();

  class  PrimaryNoNewArray_lf_primary_lfno_arrayAccess_lf_primary_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    PrimaryNoNewArray_lf_primary_lfno_arrayAccess_lf_primary_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ClassInstanceCreationExpression_lf_primaryContext *classInstanceCreationExpression_lf_primary();
    antlr4::tree::TerminalNode *EOF();
    FieldAccess_lf_primaryContext *fieldAccess_lf_primary();
    MethodInvocation_lf_primaryContext *methodInvocation_lf_primary();
    MethodReference_lf_primaryContext *methodReference_lf_primary();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  PrimaryNoNewArray_lf_primary_lfno_arrayAccess_lf_primary_DropletFileContext* primaryNoNewArray_lf_primary_lfno_arrayAccess_lf_primary_DropletFile();

  class  PrimaryNoNewArray_lfno_primary_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    PrimaryNoNewArray_lfno_primary_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    LiteralContext *literal();
    antlr4::tree::TerminalNode *EOF();
    TypeNameContext *typeName();
    UnannPrimitiveTypeContext *unannPrimitiveType();
    ExpressionContext *expression();
    ClassInstanceCreationExpression_lfno_primaryContext *classInstanceCreationExpression_lfno_primary();
    FieldAccess_lfno_primaryContext *fieldAccess_lfno_primary();
    ArrayAccess_lfno_primaryContext *arrayAccess_lfno_primary();
    MethodInvocation_lfno_primaryContext *methodInvocation_lfno_primary();
    MethodReference_lfno_primaryContext *methodReference_lfno_primary();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  PrimaryNoNewArray_lfno_primary_DropletFileContext* primaryNoNewArray_lfno_primary_DropletFile();

  class  PrimaryNoNewArray_lfno_primary_lf_arrayAccess_lfno_primary_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    PrimaryNoNewArray_lfno_primary_lf_arrayAccess_lfno_primary_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  PrimaryNoNewArray_lfno_primary_lf_arrayAccess_lfno_primary_DropletFileContext* primaryNoNewArray_lfno_primary_lf_arrayAccess_lfno_primary_DropletFile();

  class  PrimaryNoNewArray_lfno_primary_lfno_arrayAccess_lfno_primary_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    PrimaryNoNewArray_lfno_primary_lfno_arrayAccess_lfno_primary_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    LiteralContext *literal();
    antlr4::tree::TerminalNode *EOF();
    TypeNameContext *typeName();
    UnannPrimitiveTypeContext *unannPrimitiveType();
    ExpressionContext *expression();
    ClassInstanceCreationExpression_lfno_primaryContext *classInstanceCreationExpression_lfno_primary();
    FieldAccess_lfno_primaryContext *fieldAccess_lfno_primary();
    MethodInvocation_lfno_primaryContext *methodInvocation_lfno_primary();
    MethodReference_lfno_primaryContext *methodReference_lfno_primary();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  PrimaryNoNewArray_lfno_primary_lfno_arrayAccess_lfno_primary_DropletFileContext* primaryNoNewArray_lfno_primary_lfno_arrayAccess_lfno_primary_DropletFile();

  class  ClassLiteral_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ClassLiteral_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *EOF();
    TypeNameContext *typeName();
    NumericTypeContext *numericType();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ClassLiteral_DropletFileContext* classLiteral_DropletFile();

  class  ClassInstanceCreationExpression_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ClassInstanceCreationExpression_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<IdentifierContext *> identifier();
    IdentifierContext* identifier(size_t i);
    antlr4::tree::TerminalNode *EOF();
    TypeArgumentsContext *typeArguments();
    std::vector<AnnotationContext *> annotation();
    AnnotationContext* annotation(size_t i);
    TypeArgumentsOrDiamondContext *typeArgumentsOrDiamond();
    ArgumentListContext *argumentList();
    ClassBodyContext *classBody();
    ExpressionNameContext *expressionName();
    PrimaryContext *primary();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ClassInstanceCreationExpression_DropletFileContext* classInstanceCreationExpression_DropletFile();

  class  ClassInstanceCreationExpression_lf_primary_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ClassInstanceCreationExpression_lf_primary_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    antlr4::tree::TerminalNode *EOF();
    TypeArgumentsContext *typeArguments();
    std::vector<AnnotationContext *> annotation();
    AnnotationContext* annotation(size_t i);
    TypeArgumentsOrDiamondContext *typeArgumentsOrDiamond();
    ArgumentListContext *argumentList();
    ClassBodyContext *classBody();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ClassInstanceCreationExpression_lf_primary_DropletFileContext* classInstanceCreationExpression_lf_primary_DropletFile();

  class  ClassInstanceCreationExpression_lfno_primary_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ClassInstanceCreationExpression_lfno_primary_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<IdentifierContext *> identifier();
    IdentifierContext* identifier(size_t i);
    antlr4::tree::TerminalNode *EOF();
    TypeArgumentsContext *typeArguments();
    std::vector<AnnotationContext *> annotation();
    AnnotationContext* annotation(size_t i);
    TypeArgumentsOrDiamondContext *typeArgumentsOrDiamond();
    ArgumentListContext *argumentList();
    ClassBodyContext *classBody();
    ExpressionNameContext *expressionName();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ClassInstanceCreationExpression_lfno_primary_DropletFileContext* classInstanceCreationExpression_lfno_primary_DropletFile();

  class  TypeArgumentsOrDiamond_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    TypeArgumentsOrDiamond_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    TypeArgumentsContext *typeArguments();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  TypeArgumentsOrDiamond_DropletFileContext* typeArgumentsOrDiamond_DropletFile();

  class  FieldAccess_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    FieldAccess_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    PrimaryContext *primary();
    IdentifierContext *identifier();
    antlr4::tree::TerminalNode *EOF();
    TypeNameContext *typeName();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  FieldAccess_DropletFileContext* fieldAccess_DropletFile();

  class  FieldAccess_lf_primary_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    FieldAccess_lf_primary_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  FieldAccess_lf_primary_DropletFileContext* fieldAccess_lf_primary_DropletFile();

  class  FieldAccess_lfno_primary_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    FieldAccess_lfno_primary_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    antlr4::tree::TerminalNode *EOF();
    TypeNameContext *typeName();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  FieldAccess_lfno_primary_DropletFileContext* fieldAccess_lfno_primary_DropletFile();

  class  ArrayAccess_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ArrayAccess_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExpressionNameContext *expressionName();
    std::vector<ExpressionContext *> expression();
    ExpressionContext* expression(size_t i);
    std::vector<antlr4::tree::TerminalNode *> EOF();
    antlr4::tree::TerminalNode* EOF(size_t i);
    PrimaryNoNewArray_lfno_arrayAccessContext *primaryNoNewArray_lfno_arrayAccess();
    std::vector<PrimaryNoNewArray_lf_arrayAccessContext *> primaryNoNewArray_lf_arrayAccess();
    PrimaryNoNewArray_lf_arrayAccessContext* primaryNoNewArray_lf_arrayAccess(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ArrayAccess_DropletFileContext* arrayAccess_DropletFile();

  class  ArrayAccess_lf_primary_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ArrayAccess_lf_primary_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    PrimaryNoNewArray_lf_primary_lfno_arrayAccess_lf_primaryContext *primaryNoNewArray_lf_primary_lfno_arrayAccess_lf_primary();
    std::vector<ExpressionContext *> expression();
    ExpressionContext* expression(size_t i);
    std::vector<antlr4::tree::TerminalNode *> EOF();
    antlr4::tree::TerminalNode* EOF(size_t i);
    std::vector<PrimaryNoNewArray_lf_primary_lf_arrayAccess_lf_primaryContext *> primaryNoNewArray_lf_primary_lf_arrayAccess_lf_primary();
    PrimaryNoNewArray_lf_primary_lf_arrayAccess_lf_primaryContext* primaryNoNewArray_lf_primary_lf_arrayAccess_lf_primary(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ArrayAccess_lf_primary_DropletFileContext* arrayAccess_lf_primary_DropletFile();

  class  ArrayAccess_lfno_primary_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ArrayAccess_lfno_primary_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExpressionNameContext *expressionName();
    std::vector<ExpressionContext *> expression();
    ExpressionContext* expression(size_t i);
    std::vector<antlr4::tree::TerminalNode *> EOF();
    antlr4::tree::TerminalNode* EOF(size_t i);
    PrimaryNoNewArray_lfno_primary_lfno_arrayAccess_lfno_primaryContext *primaryNoNewArray_lfno_primary_lfno_arrayAccess_lfno_primary();
    std::vector<PrimaryNoNewArray_lfno_primary_lf_arrayAccess_lfno_primaryContext *> primaryNoNewArray_lfno_primary_lf_arrayAccess_lfno_primary();
    PrimaryNoNewArray_lfno_primary_lf_arrayAccess_lfno_primaryContext* primaryNoNewArray_lfno_primary_lf_arrayAccess_lfno_primary(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ArrayAccess_lfno_primary_DropletFileContext* arrayAccess_lfno_primary_DropletFile();

  class  MethodInvocation_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    MethodInvocation_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    MethodNameContext *methodName();
    antlr4::tree::TerminalNode *EOF();
    ArgumentListContext *argumentList();
    TypeNameContext *typeName();
    IdentifierContext *identifier();
    TypeArgumentsContext *typeArguments();
    ExpressionNameContext *expressionName();
    PrimaryContext *primary();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  MethodInvocation_DropletFileContext* methodInvocation_DropletFile();

  class  MethodInvocation_lf_primary_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    MethodInvocation_lf_primary_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    antlr4::tree::TerminalNode *EOF();
    TypeArgumentsContext *typeArguments();
    ArgumentListContext *argumentList();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  MethodInvocation_lf_primary_DropletFileContext* methodInvocation_lf_primary_DropletFile();

  class  MethodInvocation_lfno_primary_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    MethodInvocation_lfno_primary_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    MethodNameContext *methodName();
    antlr4::tree::TerminalNode *EOF();
    ArgumentListContext *argumentList();
    TypeNameContext *typeName();
    IdentifierContext *identifier();
    TypeArgumentsContext *typeArguments();
    ExpressionNameContext *expressionName();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  MethodInvocation_lfno_primary_DropletFileContext* methodInvocation_lfno_primary_DropletFile();

  class  ArgumentList_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ArgumentList_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<ExpressionContext *> expression();
    ExpressionContext* expression(size_t i);
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ArgumentList_DropletFileContext* argumentList_DropletFile();

  class  MethodReference_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    MethodReference_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExpressionNameContext *expressionName();
    IdentifierContext *identifier();
    antlr4::tree::TerminalNode *EOF();
    TypeArgumentsContext *typeArguments();
    ReferenceTypeContext *referenceType();
    PrimaryContext *primary();
    TypeNameContext *typeName();
    ClassTypeContext *classType();
    ArrayTypeContext *arrayType();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  MethodReference_DropletFileContext* methodReference_DropletFile();

  class  MethodReference_lf_primary_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    MethodReference_lf_primary_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    antlr4::tree::TerminalNode *EOF();
    TypeArgumentsContext *typeArguments();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  MethodReference_lf_primary_DropletFileContext* methodReference_lf_primary_DropletFile();

  class  MethodReference_lfno_primary_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    MethodReference_lfno_primary_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExpressionNameContext *expressionName();
    IdentifierContext *identifier();
    antlr4::tree::TerminalNode *EOF();
    TypeArgumentsContext *typeArguments();
    ReferenceTypeContext *referenceType();
    TypeNameContext *typeName();
    ClassTypeContext *classType();
    ArrayTypeContext *arrayType();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  MethodReference_lfno_primary_DropletFileContext* methodReference_lfno_primary_DropletFile();

  class  ArrayCreationExpression_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ArrayCreationExpression_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    PrimitiveTypeContext *primitiveType();
    DimExprsContext *dimExprs();
    antlr4::tree::TerminalNode *EOF();
    DimsContext *dims();
    ClassOrInterfaceTypeContext *classOrInterfaceType();
    ArrayInitializerContext *arrayInitializer();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ArrayCreationExpression_DropletFileContext* arrayCreationExpression_DropletFile();

  class  DimExprs_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    DimExprs_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *EOF();
    std::vector<DimExprContext *> dimExpr();
    DimExprContext* dimExpr(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  DimExprs_DropletFileContext* dimExprs_DropletFile();

  class  DimExpr_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    DimExpr_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExpressionContext *expression();
    antlr4::tree::TerminalNode *EOF();
    std::vector<AnnotationContext *> annotation();
    AnnotationContext* annotation(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  DimExpr_DropletFileContext* dimExpr_DropletFile();

  class  ConstantExpression_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ConstantExpression_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExpressionContext *expression();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ConstantExpression_DropletFileContext* constantExpression_DropletFile();

  class  Expression_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    Expression_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    LambdaExpressionContext *lambdaExpression();
    antlr4::tree::TerminalNode *EOF();
    AssignmentExpressionContext *assignmentExpression();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  Expression_DropletFileContext* expression_DropletFile();

  class  LambdaExpression_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    LambdaExpression_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    LambdaParametersContext *lambdaParameters();
    LambdaBodyContext *lambdaBody();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  LambdaExpression_DropletFileContext* lambdaExpression_DropletFile();

  class  LambdaParameters_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    LambdaParameters_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    antlr4::tree::TerminalNode *EOF();
    FormalParameterListContext *formalParameterList();
    InferredFormalParameterListContext *inferredFormalParameterList();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  LambdaParameters_DropletFileContext* lambdaParameters_DropletFile();

  class  InferredFormalParameterList_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    InferredFormalParameterList_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<IdentifierContext *> identifier();
    IdentifierContext* identifier(size_t i);
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  InferredFormalParameterList_DropletFileContext* inferredFormalParameterList_DropletFile();

  class  LambdaBody_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    LambdaBody_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExpressionContext *expression();
    antlr4::tree::TerminalNode *EOF();
    BlockContext *block();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  LambdaBody_DropletFileContext* lambdaBody_DropletFile();

  class  AssignmentExpression_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    AssignmentExpression_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ConditionalExpressionContext *conditionalExpression();
    antlr4::tree::TerminalNode *EOF();
    AssignmentContext *assignment();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  AssignmentExpression_DropletFileContext* assignmentExpression_DropletFile();

  class  Assignment_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    Assignment_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    LeftHandSideContext *leftHandSide();
    AssignmentOperatorContext *assignmentOperator();
    ExpressionContext *expression();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  Assignment_DropletFileContext* assignment_DropletFile();

  class  LeftHandSide_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    LeftHandSide_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExpressionNameContext *expressionName();
    antlr4::tree::TerminalNode *EOF();
    FieldAccessContext *fieldAccess();
    ArrayAccessContext *arrayAccess();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  LeftHandSide_DropletFileContext* leftHandSide_DropletFile();

  class  AssignmentOperator_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    AssignmentOperator_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  AssignmentOperator_DropletFileContext* assignmentOperator_DropletFile();

  class  ConditionalExpression_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ConditionalExpression_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ConditionalOrExpressionContext *conditionalOrExpression();
    antlr4::tree::TerminalNode *EOF();
    ExpressionContext *expression();
    ConditionalExpressionContext *conditionalExpression();
    LambdaExpressionContext *lambdaExpression();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ConditionalExpression_DropletFileContext* conditionalExpression_DropletFile();

  class  ConditionalOrExpression_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ConditionalOrExpression_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ConditionalAndExpressionContext *conditionalAndExpression();
    antlr4::tree::TerminalNode *EOF();
    ConditionalOrExpressionContext *conditionalOrExpression();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ConditionalOrExpression_DropletFileContext* conditionalOrExpression_DropletFile();

  class  ConditionalAndExpression_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ConditionalAndExpression_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    InclusiveOrExpressionContext *inclusiveOrExpression();
    antlr4::tree::TerminalNode *EOF();
    ConditionalAndExpressionContext *conditionalAndExpression();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ConditionalAndExpression_DropletFileContext* conditionalAndExpression_DropletFile();

  class  InclusiveOrExpression_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    InclusiveOrExpression_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExclusiveOrExpressionContext *exclusiveOrExpression();
    antlr4::tree::TerminalNode *EOF();
    InclusiveOrExpressionContext *inclusiveOrExpression();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  InclusiveOrExpression_DropletFileContext* inclusiveOrExpression_DropletFile();

  class  ExclusiveOrExpression_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ExclusiveOrExpression_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    AndExpressionContext *andExpression();
    antlr4::tree::TerminalNode *EOF();
    ExclusiveOrExpressionContext *exclusiveOrExpression();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ExclusiveOrExpression_DropletFileContext* exclusiveOrExpression_DropletFile();

  class  AndExpression_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    AndExpression_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    EqualityExpressionContext *equalityExpression();
    antlr4::tree::TerminalNode *EOF();
    AndExpressionContext *andExpression();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  AndExpression_DropletFileContext* andExpression_DropletFile();

  class  EqualityExpression_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    EqualityExpression_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    RelationalExpressionContext *relationalExpression();
    antlr4::tree::TerminalNode *EOF();
    EqualityExpressionContext *equalityExpression();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  EqualityExpression_DropletFileContext* equalityExpression_DropletFile();

  class  RelationalExpression_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    RelationalExpression_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ShiftExpressionContext *shiftExpression();
    antlr4::tree::TerminalNode *EOF();
    RelationalExpressionContext *relationalExpression();
    ReferenceTypeContext *referenceType();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  RelationalExpression_DropletFileContext* relationalExpression_DropletFile();

  class  ShiftExpression_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    ShiftExpression_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    AdditiveExpressionContext *additiveExpression();
    antlr4::tree::TerminalNode *EOF();
    ShiftExpressionContext *shiftExpression();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  ShiftExpression_DropletFileContext* shiftExpression_DropletFile();

  class  AdditiveExpression_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    AdditiveExpression_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    MultiplicativeExpressionContext *multiplicativeExpression();
    antlr4::tree::TerminalNode *EOF();
    AdditiveExpressionContext *additiveExpression();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  AdditiveExpression_DropletFileContext* additiveExpression_DropletFile();

  class  MultiplicativeExpression_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    MultiplicativeExpression_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    UnaryExpressionContext *unaryExpression();
    antlr4::tree::TerminalNode *EOF();
    MultiplicativeExpressionContext *multiplicativeExpression();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  MultiplicativeExpression_DropletFileContext* multiplicativeExpression_DropletFile();

  class  UnaryExpression_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    UnaryExpression_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    PreIncrementExpressionContext *preIncrementExpression();
    antlr4::tree::TerminalNode *EOF();
    PreDecrementExpressionContext *preDecrementExpression();
    UnaryExpressionContext *unaryExpression();
    UnaryExpressionNotPlusMinusContext *unaryExpressionNotPlusMinus();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  UnaryExpression_DropletFileContext* unaryExpression_DropletFile();

  class  PreIncrementExpression_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    PreIncrementExpression_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    UnaryExpressionContext *unaryExpression();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  PreIncrementExpression_DropletFileContext* preIncrementExpression_DropletFile();

  class  PreDecrementExpression_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    PreDecrementExpression_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    UnaryExpressionContext *unaryExpression();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  PreDecrementExpression_DropletFileContext* preDecrementExpression_DropletFile();

  class  UnaryExpressionNotPlusMinus_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    UnaryExpressionNotPlusMinus_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    PostfixExpressionContext *postfixExpression();
    antlr4::tree::TerminalNode *EOF();
    UnaryExpressionContext *unaryExpression();
    CastExpressionContext *castExpression();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  UnaryExpressionNotPlusMinus_DropletFileContext* unaryExpressionNotPlusMinus_DropletFile();

  class  PostfixExpression_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    PostfixExpression_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    PrimaryContext *primary();
    std::vector<antlr4::tree::TerminalNode *> EOF();
    antlr4::tree::TerminalNode* EOF(size_t i);
    ExpressionNameContext *expressionName();
    std::vector<PostIncrementExpression_lf_postfixExpressionContext *> postIncrementExpression_lf_postfixExpression();
    PostIncrementExpression_lf_postfixExpressionContext* postIncrementExpression_lf_postfixExpression(size_t i);
    std::vector<PostDecrementExpression_lf_postfixExpressionContext *> postDecrementExpression_lf_postfixExpression();
    PostDecrementExpression_lf_postfixExpressionContext* postDecrementExpression_lf_postfixExpression(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  PostfixExpression_DropletFileContext* postfixExpression_DropletFile();

  class  PostIncrementExpression_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    PostIncrementExpression_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    PostfixExpressionContext *postfixExpression();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  PostIncrementExpression_DropletFileContext* postIncrementExpression_DropletFile();

  class  PostIncrementExpression_lf_postfixExpression_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    PostIncrementExpression_lf_postfixExpression_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  PostIncrementExpression_lf_postfixExpression_DropletFileContext* postIncrementExpression_lf_postfixExpression_DropletFile();

  class  PostDecrementExpression_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    PostDecrementExpression_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    PostfixExpressionContext *postfixExpression();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  PostDecrementExpression_DropletFileContext* postDecrementExpression_DropletFile();

  class  PostDecrementExpression_lf_postfixExpression_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    PostDecrementExpression_lf_postfixExpression_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  PostDecrementExpression_lf_postfixExpression_DropletFileContext* postDecrementExpression_lf_postfixExpression_DropletFile();

  class  CastExpression_DropletFileContext : public antlr4::ParserRuleContext {
  public:
    CastExpression_DropletFileContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    PrimitiveTypeContext *primitiveType();
    UnaryExpressionContext *unaryExpression();
    antlr4::tree::TerminalNode *EOF();
    ReferenceTypeContext *referenceType();
    UnaryExpressionNotPlusMinusContext *unaryExpressionNotPlusMinus();
    std::vector<AdditionalBoundContext *> additionalBound();
    AdditionalBoundContext* additionalBound(size_t i);
    LambdaExpressionContext *lambdaExpression();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  CastExpression_DropletFileContext* castExpression_DropletFile();

  class  IdentifierContext : public antlr4::ParserRuleContext {
  public:
    IdentifierContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *Identifier();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
   
  };

  IdentifierContext* identifier();


  virtual bool sempred(antlr4::RuleContext *_localctx, size_t ruleIndex, size_t predicateIndex) override;
  bool moduleNameSempred(ModuleNameContext *_localctx, size_t predicateIndex);
  bool packageNameSempred(PackageNameContext *_localctx, size_t predicateIndex);
  bool packageOrTypeNameSempred(PackageOrTypeNameContext *_localctx, size_t predicateIndex);
  bool ambiguousNameSempred(AmbiguousNameContext *_localctx, size_t predicateIndex);
  bool conditionalOrExpressionSempred(ConditionalOrExpressionContext *_localctx, size_t predicateIndex);
  bool conditionalAndExpressionSempred(ConditionalAndExpressionContext *_localctx, size_t predicateIndex);
  bool inclusiveOrExpressionSempred(InclusiveOrExpressionContext *_localctx, size_t predicateIndex);
  bool exclusiveOrExpressionSempred(ExclusiveOrExpressionContext *_localctx, size_t predicateIndex);
  bool andExpressionSempred(AndExpressionContext *_localctx, size_t predicateIndex);
  bool equalityExpressionSempred(EqualityExpressionContext *_localctx, size_t predicateIndex);
  bool relationalExpressionSempred(RelationalExpressionContext *_localctx, size_t predicateIndex);
  bool shiftExpressionSempred(ShiftExpressionContext *_localctx, size_t predicateIndex);
  bool additiveExpressionSempred(AdditiveExpressionContext *_localctx, size_t predicateIndex);
  bool multiplicativeExpressionSempred(MultiplicativeExpressionContext *_localctx, size_t predicateIndex);

private:
  static std::vector<antlr4::dfa::DFA> _decisionToDFA;
  static antlr4::atn::PredictionContextCache _sharedContextCache;
  static std::vector<std::string> _ruleNames;
  static std::vector<std::string> _tokenNames;

  static std::vector<std::string> _literalNames;
  static std::vector<std::string> _symbolicNames;
  static antlr4::dfa::Vocabulary _vocabulary;
  static antlr4::atn::ATN _atn;
  static std::vector<uint16_t> _serializedATN;


  struct Initializer {
    Initializer();
  };
  static Initializer _init;
};

