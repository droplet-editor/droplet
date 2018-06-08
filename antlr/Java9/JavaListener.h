
// Generated from Java.g4 by ANTLR 4.7.1

#pragma once


#include "antlr4-runtime.h"
#include "JavaParser.h"


/**
 * This interface defines an abstract listener for a parse tree produced by JavaParser.
 */
class  JavaListener : public antlr4::tree::ParseTreeListener {
public:

  virtual void enterLiteral(JavaParser::LiteralContext *ctx) = 0;
  virtual void exitLiteral(JavaParser::LiteralContext *ctx) = 0;

  virtual void enterPrimitiveType(JavaParser::PrimitiveTypeContext *ctx) = 0;
  virtual void exitPrimitiveType(JavaParser::PrimitiveTypeContext *ctx) = 0;

  virtual void enterNumericType(JavaParser::NumericTypeContext *ctx) = 0;
  virtual void exitNumericType(JavaParser::NumericTypeContext *ctx) = 0;

  virtual void enterIntegralType(JavaParser::IntegralTypeContext *ctx) = 0;
  virtual void exitIntegralType(JavaParser::IntegralTypeContext *ctx) = 0;

  virtual void enterFloatingPointType(JavaParser::FloatingPointTypeContext *ctx) = 0;
  virtual void exitFloatingPointType(JavaParser::FloatingPointTypeContext *ctx) = 0;

  virtual void enterReferenceType(JavaParser::ReferenceTypeContext *ctx) = 0;
  virtual void exitReferenceType(JavaParser::ReferenceTypeContext *ctx) = 0;

  virtual void enterClassOrInterfaceType(JavaParser::ClassOrInterfaceTypeContext *ctx) = 0;
  virtual void exitClassOrInterfaceType(JavaParser::ClassOrInterfaceTypeContext *ctx) = 0;

  virtual void enterClassType(JavaParser::ClassTypeContext *ctx) = 0;
  virtual void exitClassType(JavaParser::ClassTypeContext *ctx) = 0;

  virtual void enterClassType_lf_classOrInterfaceType(JavaParser::ClassType_lf_classOrInterfaceTypeContext *ctx) = 0;
  virtual void exitClassType_lf_classOrInterfaceType(JavaParser::ClassType_lf_classOrInterfaceTypeContext *ctx) = 0;

  virtual void enterClassType_lfno_classOrInterfaceType(JavaParser::ClassType_lfno_classOrInterfaceTypeContext *ctx) = 0;
  virtual void exitClassType_lfno_classOrInterfaceType(JavaParser::ClassType_lfno_classOrInterfaceTypeContext *ctx) = 0;

  virtual void enterInterfaceType(JavaParser::InterfaceTypeContext *ctx) = 0;
  virtual void exitInterfaceType(JavaParser::InterfaceTypeContext *ctx) = 0;

  virtual void enterInterfaceType_lf_classOrInterfaceType(JavaParser::InterfaceType_lf_classOrInterfaceTypeContext *ctx) = 0;
  virtual void exitInterfaceType_lf_classOrInterfaceType(JavaParser::InterfaceType_lf_classOrInterfaceTypeContext *ctx) = 0;

  virtual void enterInterfaceType_lfno_classOrInterfaceType(JavaParser::InterfaceType_lfno_classOrInterfaceTypeContext *ctx) = 0;
  virtual void exitInterfaceType_lfno_classOrInterfaceType(JavaParser::InterfaceType_lfno_classOrInterfaceTypeContext *ctx) = 0;

  virtual void enterTypeVariable(JavaParser::TypeVariableContext *ctx) = 0;
  virtual void exitTypeVariable(JavaParser::TypeVariableContext *ctx) = 0;

  virtual void enterArrayType(JavaParser::ArrayTypeContext *ctx) = 0;
  virtual void exitArrayType(JavaParser::ArrayTypeContext *ctx) = 0;

  virtual void enterDims(JavaParser::DimsContext *ctx) = 0;
  virtual void exitDims(JavaParser::DimsContext *ctx) = 0;

  virtual void enterTypeParameter(JavaParser::TypeParameterContext *ctx) = 0;
  virtual void exitTypeParameter(JavaParser::TypeParameterContext *ctx) = 0;

  virtual void enterTypeParameterModifier(JavaParser::TypeParameterModifierContext *ctx) = 0;
  virtual void exitTypeParameterModifier(JavaParser::TypeParameterModifierContext *ctx) = 0;

  virtual void enterTypeBound(JavaParser::TypeBoundContext *ctx) = 0;
  virtual void exitTypeBound(JavaParser::TypeBoundContext *ctx) = 0;

  virtual void enterAdditionalBound(JavaParser::AdditionalBoundContext *ctx) = 0;
  virtual void exitAdditionalBound(JavaParser::AdditionalBoundContext *ctx) = 0;

  virtual void enterTypeArguments(JavaParser::TypeArgumentsContext *ctx) = 0;
  virtual void exitTypeArguments(JavaParser::TypeArgumentsContext *ctx) = 0;

  virtual void enterTypeArgumentList(JavaParser::TypeArgumentListContext *ctx) = 0;
  virtual void exitTypeArgumentList(JavaParser::TypeArgumentListContext *ctx) = 0;

  virtual void enterTypeArgument(JavaParser::TypeArgumentContext *ctx) = 0;
  virtual void exitTypeArgument(JavaParser::TypeArgumentContext *ctx) = 0;

  virtual void enterWildcard(JavaParser::WildcardContext *ctx) = 0;
  virtual void exitWildcard(JavaParser::WildcardContext *ctx) = 0;

  virtual void enterWildcardBounds(JavaParser::WildcardBoundsContext *ctx) = 0;
  virtual void exitWildcardBounds(JavaParser::WildcardBoundsContext *ctx) = 0;

  virtual void enterModuleName(JavaParser::ModuleNameContext *ctx) = 0;
  virtual void exitModuleName(JavaParser::ModuleNameContext *ctx) = 0;

  virtual void enterPackageName(JavaParser::PackageNameContext *ctx) = 0;
  virtual void exitPackageName(JavaParser::PackageNameContext *ctx) = 0;

  virtual void enterTypeName(JavaParser::TypeNameContext *ctx) = 0;
  virtual void exitTypeName(JavaParser::TypeNameContext *ctx) = 0;

  virtual void enterPackageOrTypeName(JavaParser::PackageOrTypeNameContext *ctx) = 0;
  virtual void exitPackageOrTypeName(JavaParser::PackageOrTypeNameContext *ctx) = 0;

  virtual void enterExpressionName(JavaParser::ExpressionNameContext *ctx) = 0;
  virtual void exitExpressionName(JavaParser::ExpressionNameContext *ctx) = 0;

  virtual void enterMethodName(JavaParser::MethodNameContext *ctx) = 0;
  virtual void exitMethodName(JavaParser::MethodNameContext *ctx) = 0;

  virtual void enterAmbiguousName(JavaParser::AmbiguousNameContext *ctx) = 0;
  virtual void exitAmbiguousName(JavaParser::AmbiguousNameContext *ctx) = 0;

  virtual void enterCompilationUnit(JavaParser::CompilationUnitContext *ctx) = 0;
  virtual void exitCompilationUnit(JavaParser::CompilationUnitContext *ctx) = 0;

  virtual void enterOrdinaryCompilation(JavaParser::OrdinaryCompilationContext *ctx) = 0;
  virtual void exitOrdinaryCompilation(JavaParser::OrdinaryCompilationContext *ctx) = 0;

  virtual void enterModularCompilation(JavaParser::ModularCompilationContext *ctx) = 0;
  virtual void exitModularCompilation(JavaParser::ModularCompilationContext *ctx) = 0;

  virtual void enterPackageDeclaration(JavaParser::PackageDeclarationContext *ctx) = 0;
  virtual void exitPackageDeclaration(JavaParser::PackageDeclarationContext *ctx) = 0;

  virtual void enterPackageModifier(JavaParser::PackageModifierContext *ctx) = 0;
  virtual void exitPackageModifier(JavaParser::PackageModifierContext *ctx) = 0;

  virtual void enterImportDeclaration(JavaParser::ImportDeclarationContext *ctx) = 0;
  virtual void exitImportDeclaration(JavaParser::ImportDeclarationContext *ctx) = 0;

  virtual void enterSingleTypeImportDeclaration(JavaParser::SingleTypeImportDeclarationContext *ctx) = 0;
  virtual void exitSingleTypeImportDeclaration(JavaParser::SingleTypeImportDeclarationContext *ctx) = 0;

  virtual void enterTypeImportOnDemandDeclaration(JavaParser::TypeImportOnDemandDeclarationContext *ctx) = 0;
  virtual void exitTypeImportOnDemandDeclaration(JavaParser::TypeImportOnDemandDeclarationContext *ctx) = 0;

  virtual void enterSingleStaticImportDeclaration(JavaParser::SingleStaticImportDeclarationContext *ctx) = 0;
  virtual void exitSingleStaticImportDeclaration(JavaParser::SingleStaticImportDeclarationContext *ctx) = 0;

  virtual void enterStaticImportOnDemandDeclaration(JavaParser::StaticImportOnDemandDeclarationContext *ctx) = 0;
  virtual void exitStaticImportOnDemandDeclaration(JavaParser::StaticImportOnDemandDeclarationContext *ctx) = 0;

  virtual void enterTypeDeclaration(JavaParser::TypeDeclarationContext *ctx) = 0;
  virtual void exitTypeDeclaration(JavaParser::TypeDeclarationContext *ctx) = 0;

  virtual void enterModuleDeclaration(JavaParser::ModuleDeclarationContext *ctx) = 0;
  virtual void exitModuleDeclaration(JavaParser::ModuleDeclarationContext *ctx) = 0;

  virtual void enterModuleDirective(JavaParser::ModuleDirectiveContext *ctx) = 0;
  virtual void exitModuleDirective(JavaParser::ModuleDirectiveContext *ctx) = 0;

  virtual void enterRequiresModifier(JavaParser::RequiresModifierContext *ctx) = 0;
  virtual void exitRequiresModifier(JavaParser::RequiresModifierContext *ctx) = 0;

  virtual void enterClassDeclaration(JavaParser::ClassDeclarationContext *ctx) = 0;
  virtual void exitClassDeclaration(JavaParser::ClassDeclarationContext *ctx) = 0;

  virtual void enterNormalClassDeclaration(JavaParser::NormalClassDeclarationContext *ctx) = 0;
  virtual void exitNormalClassDeclaration(JavaParser::NormalClassDeclarationContext *ctx) = 0;

  virtual void enterClassModifier(JavaParser::ClassModifierContext *ctx) = 0;
  virtual void exitClassModifier(JavaParser::ClassModifierContext *ctx) = 0;

  virtual void enterTypeParameters(JavaParser::TypeParametersContext *ctx) = 0;
  virtual void exitTypeParameters(JavaParser::TypeParametersContext *ctx) = 0;

  virtual void enterTypeParameterList(JavaParser::TypeParameterListContext *ctx) = 0;
  virtual void exitTypeParameterList(JavaParser::TypeParameterListContext *ctx) = 0;

  virtual void enterSuperclass(JavaParser::SuperclassContext *ctx) = 0;
  virtual void exitSuperclass(JavaParser::SuperclassContext *ctx) = 0;

  virtual void enterSuperinterfaces(JavaParser::SuperinterfacesContext *ctx) = 0;
  virtual void exitSuperinterfaces(JavaParser::SuperinterfacesContext *ctx) = 0;

  virtual void enterInterfaceTypeList(JavaParser::InterfaceTypeListContext *ctx) = 0;
  virtual void exitInterfaceTypeList(JavaParser::InterfaceTypeListContext *ctx) = 0;

  virtual void enterClassBody(JavaParser::ClassBodyContext *ctx) = 0;
  virtual void exitClassBody(JavaParser::ClassBodyContext *ctx) = 0;

  virtual void enterClassBodyDeclaration(JavaParser::ClassBodyDeclarationContext *ctx) = 0;
  virtual void exitClassBodyDeclaration(JavaParser::ClassBodyDeclarationContext *ctx) = 0;

  virtual void enterClassMemberDeclaration(JavaParser::ClassMemberDeclarationContext *ctx) = 0;
  virtual void exitClassMemberDeclaration(JavaParser::ClassMemberDeclarationContext *ctx) = 0;

  virtual void enterFieldDeclaration(JavaParser::FieldDeclarationContext *ctx) = 0;
  virtual void exitFieldDeclaration(JavaParser::FieldDeclarationContext *ctx) = 0;

  virtual void enterFieldModifier(JavaParser::FieldModifierContext *ctx) = 0;
  virtual void exitFieldModifier(JavaParser::FieldModifierContext *ctx) = 0;

  virtual void enterVariableDeclaratorList(JavaParser::VariableDeclaratorListContext *ctx) = 0;
  virtual void exitVariableDeclaratorList(JavaParser::VariableDeclaratorListContext *ctx) = 0;

  virtual void enterVariableDeclarator(JavaParser::VariableDeclaratorContext *ctx) = 0;
  virtual void exitVariableDeclarator(JavaParser::VariableDeclaratorContext *ctx) = 0;

  virtual void enterVariableDeclaratorId(JavaParser::VariableDeclaratorIdContext *ctx) = 0;
  virtual void exitVariableDeclaratorId(JavaParser::VariableDeclaratorIdContext *ctx) = 0;

  virtual void enterVariableInitializer(JavaParser::VariableInitializerContext *ctx) = 0;
  virtual void exitVariableInitializer(JavaParser::VariableInitializerContext *ctx) = 0;

  virtual void enterUnannType(JavaParser::UnannTypeContext *ctx) = 0;
  virtual void exitUnannType(JavaParser::UnannTypeContext *ctx) = 0;

  virtual void enterUnannPrimitiveType(JavaParser::UnannPrimitiveTypeContext *ctx) = 0;
  virtual void exitUnannPrimitiveType(JavaParser::UnannPrimitiveTypeContext *ctx) = 0;

  virtual void enterUnannReferenceType(JavaParser::UnannReferenceTypeContext *ctx) = 0;
  virtual void exitUnannReferenceType(JavaParser::UnannReferenceTypeContext *ctx) = 0;

  virtual void enterUnannClassOrInterfaceType(JavaParser::UnannClassOrInterfaceTypeContext *ctx) = 0;
  virtual void exitUnannClassOrInterfaceType(JavaParser::UnannClassOrInterfaceTypeContext *ctx) = 0;

  virtual void enterUnannClassType(JavaParser::UnannClassTypeContext *ctx) = 0;
  virtual void exitUnannClassType(JavaParser::UnannClassTypeContext *ctx) = 0;

  virtual void enterUnannClassType_lf_unannClassOrInterfaceType(JavaParser::UnannClassType_lf_unannClassOrInterfaceTypeContext *ctx) = 0;
  virtual void exitUnannClassType_lf_unannClassOrInterfaceType(JavaParser::UnannClassType_lf_unannClassOrInterfaceTypeContext *ctx) = 0;

  virtual void enterUnannClassType_lfno_unannClassOrInterfaceType(JavaParser::UnannClassType_lfno_unannClassOrInterfaceTypeContext *ctx) = 0;
  virtual void exitUnannClassType_lfno_unannClassOrInterfaceType(JavaParser::UnannClassType_lfno_unannClassOrInterfaceTypeContext *ctx) = 0;

  virtual void enterUnannInterfaceType(JavaParser::UnannInterfaceTypeContext *ctx) = 0;
  virtual void exitUnannInterfaceType(JavaParser::UnannInterfaceTypeContext *ctx) = 0;

  virtual void enterUnannInterfaceType_lf_unannClassOrInterfaceType(JavaParser::UnannInterfaceType_lf_unannClassOrInterfaceTypeContext *ctx) = 0;
  virtual void exitUnannInterfaceType_lf_unannClassOrInterfaceType(JavaParser::UnannInterfaceType_lf_unannClassOrInterfaceTypeContext *ctx) = 0;

  virtual void enterUnannInterfaceType_lfno_unannClassOrInterfaceType(JavaParser::UnannInterfaceType_lfno_unannClassOrInterfaceTypeContext *ctx) = 0;
  virtual void exitUnannInterfaceType_lfno_unannClassOrInterfaceType(JavaParser::UnannInterfaceType_lfno_unannClassOrInterfaceTypeContext *ctx) = 0;

  virtual void enterUnannTypeVariable(JavaParser::UnannTypeVariableContext *ctx) = 0;
  virtual void exitUnannTypeVariable(JavaParser::UnannTypeVariableContext *ctx) = 0;

  virtual void enterUnannArrayType(JavaParser::UnannArrayTypeContext *ctx) = 0;
  virtual void exitUnannArrayType(JavaParser::UnannArrayTypeContext *ctx) = 0;

  virtual void enterMethodDeclaration(JavaParser::MethodDeclarationContext *ctx) = 0;
  virtual void exitMethodDeclaration(JavaParser::MethodDeclarationContext *ctx) = 0;

  virtual void enterMethodModifier(JavaParser::MethodModifierContext *ctx) = 0;
  virtual void exitMethodModifier(JavaParser::MethodModifierContext *ctx) = 0;

  virtual void enterMethodHeader(JavaParser::MethodHeaderContext *ctx) = 0;
  virtual void exitMethodHeader(JavaParser::MethodHeaderContext *ctx) = 0;

  virtual void enterResult(JavaParser::ResultContext *ctx) = 0;
  virtual void exitResult(JavaParser::ResultContext *ctx) = 0;

  virtual void enterMethodDeclarator(JavaParser::MethodDeclaratorContext *ctx) = 0;
  virtual void exitMethodDeclarator(JavaParser::MethodDeclaratorContext *ctx) = 0;

  virtual void enterFormalParameterList(JavaParser::FormalParameterListContext *ctx) = 0;
  virtual void exitFormalParameterList(JavaParser::FormalParameterListContext *ctx) = 0;

  virtual void enterFormalParameters(JavaParser::FormalParametersContext *ctx) = 0;
  virtual void exitFormalParameters(JavaParser::FormalParametersContext *ctx) = 0;

  virtual void enterFormalParameter(JavaParser::FormalParameterContext *ctx) = 0;
  virtual void exitFormalParameter(JavaParser::FormalParameterContext *ctx) = 0;

  virtual void enterVariableModifier(JavaParser::VariableModifierContext *ctx) = 0;
  virtual void exitVariableModifier(JavaParser::VariableModifierContext *ctx) = 0;

  virtual void enterLastFormalParameter(JavaParser::LastFormalParameterContext *ctx) = 0;
  virtual void exitLastFormalParameter(JavaParser::LastFormalParameterContext *ctx) = 0;

  virtual void enterReceiverParameter(JavaParser::ReceiverParameterContext *ctx) = 0;
  virtual void exitReceiverParameter(JavaParser::ReceiverParameterContext *ctx) = 0;

  virtual void enterThrows_(JavaParser::Throws_Context *ctx) = 0;
  virtual void exitThrows_(JavaParser::Throws_Context *ctx) = 0;

  virtual void enterExceptionTypeList(JavaParser::ExceptionTypeListContext *ctx) = 0;
  virtual void exitExceptionTypeList(JavaParser::ExceptionTypeListContext *ctx) = 0;

  virtual void enterExceptionType(JavaParser::ExceptionTypeContext *ctx) = 0;
  virtual void exitExceptionType(JavaParser::ExceptionTypeContext *ctx) = 0;

  virtual void enterMethodBody(JavaParser::MethodBodyContext *ctx) = 0;
  virtual void exitMethodBody(JavaParser::MethodBodyContext *ctx) = 0;

  virtual void enterInstanceInitializer(JavaParser::InstanceInitializerContext *ctx) = 0;
  virtual void exitInstanceInitializer(JavaParser::InstanceInitializerContext *ctx) = 0;

  virtual void enterStaticInitializer(JavaParser::StaticInitializerContext *ctx) = 0;
  virtual void exitStaticInitializer(JavaParser::StaticInitializerContext *ctx) = 0;

  virtual void enterConstructorDeclaration(JavaParser::ConstructorDeclarationContext *ctx) = 0;
  virtual void exitConstructorDeclaration(JavaParser::ConstructorDeclarationContext *ctx) = 0;

  virtual void enterConstructorModifier(JavaParser::ConstructorModifierContext *ctx) = 0;
  virtual void exitConstructorModifier(JavaParser::ConstructorModifierContext *ctx) = 0;

  virtual void enterConstructorDeclarator(JavaParser::ConstructorDeclaratorContext *ctx) = 0;
  virtual void exitConstructorDeclarator(JavaParser::ConstructorDeclaratorContext *ctx) = 0;

  virtual void enterSimpleTypeName(JavaParser::SimpleTypeNameContext *ctx) = 0;
  virtual void exitSimpleTypeName(JavaParser::SimpleTypeNameContext *ctx) = 0;

  virtual void enterConstructorBody(JavaParser::ConstructorBodyContext *ctx) = 0;
  virtual void exitConstructorBody(JavaParser::ConstructorBodyContext *ctx) = 0;

  virtual void enterExplicitConstructorInvocation(JavaParser::ExplicitConstructorInvocationContext *ctx) = 0;
  virtual void exitExplicitConstructorInvocation(JavaParser::ExplicitConstructorInvocationContext *ctx) = 0;

  virtual void enterEnumDeclaration(JavaParser::EnumDeclarationContext *ctx) = 0;
  virtual void exitEnumDeclaration(JavaParser::EnumDeclarationContext *ctx) = 0;

  virtual void enterEnumBody(JavaParser::EnumBodyContext *ctx) = 0;
  virtual void exitEnumBody(JavaParser::EnumBodyContext *ctx) = 0;

  virtual void enterEnumConstantList(JavaParser::EnumConstantListContext *ctx) = 0;
  virtual void exitEnumConstantList(JavaParser::EnumConstantListContext *ctx) = 0;

  virtual void enterEnumConstant(JavaParser::EnumConstantContext *ctx) = 0;
  virtual void exitEnumConstant(JavaParser::EnumConstantContext *ctx) = 0;

  virtual void enterEnumConstantModifier(JavaParser::EnumConstantModifierContext *ctx) = 0;
  virtual void exitEnumConstantModifier(JavaParser::EnumConstantModifierContext *ctx) = 0;

  virtual void enterEnumBodyDeclarations(JavaParser::EnumBodyDeclarationsContext *ctx) = 0;
  virtual void exitEnumBodyDeclarations(JavaParser::EnumBodyDeclarationsContext *ctx) = 0;

  virtual void enterInterfaceDeclaration(JavaParser::InterfaceDeclarationContext *ctx) = 0;
  virtual void exitInterfaceDeclaration(JavaParser::InterfaceDeclarationContext *ctx) = 0;

  virtual void enterNormalInterfaceDeclaration(JavaParser::NormalInterfaceDeclarationContext *ctx) = 0;
  virtual void exitNormalInterfaceDeclaration(JavaParser::NormalInterfaceDeclarationContext *ctx) = 0;

  virtual void enterInterfaceModifier(JavaParser::InterfaceModifierContext *ctx) = 0;
  virtual void exitInterfaceModifier(JavaParser::InterfaceModifierContext *ctx) = 0;

  virtual void enterExtendsInterfaces(JavaParser::ExtendsInterfacesContext *ctx) = 0;
  virtual void exitExtendsInterfaces(JavaParser::ExtendsInterfacesContext *ctx) = 0;

  virtual void enterInterfaceBody(JavaParser::InterfaceBodyContext *ctx) = 0;
  virtual void exitInterfaceBody(JavaParser::InterfaceBodyContext *ctx) = 0;

  virtual void enterInterfaceMemberDeclaration(JavaParser::InterfaceMemberDeclarationContext *ctx) = 0;
  virtual void exitInterfaceMemberDeclaration(JavaParser::InterfaceMemberDeclarationContext *ctx) = 0;

  virtual void enterConstantDeclaration(JavaParser::ConstantDeclarationContext *ctx) = 0;
  virtual void exitConstantDeclaration(JavaParser::ConstantDeclarationContext *ctx) = 0;

  virtual void enterConstantModifier(JavaParser::ConstantModifierContext *ctx) = 0;
  virtual void exitConstantModifier(JavaParser::ConstantModifierContext *ctx) = 0;

  virtual void enterInterfaceMethodDeclaration(JavaParser::InterfaceMethodDeclarationContext *ctx) = 0;
  virtual void exitInterfaceMethodDeclaration(JavaParser::InterfaceMethodDeclarationContext *ctx) = 0;

  virtual void enterInterfaceMethodModifier(JavaParser::InterfaceMethodModifierContext *ctx) = 0;
  virtual void exitInterfaceMethodModifier(JavaParser::InterfaceMethodModifierContext *ctx) = 0;

  virtual void enterAnnotationTypeDeclaration(JavaParser::AnnotationTypeDeclarationContext *ctx) = 0;
  virtual void exitAnnotationTypeDeclaration(JavaParser::AnnotationTypeDeclarationContext *ctx) = 0;

  virtual void enterAnnotationTypeBody(JavaParser::AnnotationTypeBodyContext *ctx) = 0;
  virtual void exitAnnotationTypeBody(JavaParser::AnnotationTypeBodyContext *ctx) = 0;

  virtual void enterAnnotationTypeMemberDeclaration(JavaParser::AnnotationTypeMemberDeclarationContext *ctx) = 0;
  virtual void exitAnnotationTypeMemberDeclaration(JavaParser::AnnotationTypeMemberDeclarationContext *ctx) = 0;

  virtual void enterAnnotationTypeElementDeclaration(JavaParser::AnnotationTypeElementDeclarationContext *ctx) = 0;
  virtual void exitAnnotationTypeElementDeclaration(JavaParser::AnnotationTypeElementDeclarationContext *ctx) = 0;

  virtual void enterAnnotationTypeElementModifier(JavaParser::AnnotationTypeElementModifierContext *ctx) = 0;
  virtual void exitAnnotationTypeElementModifier(JavaParser::AnnotationTypeElementModifierContext *ctx) = 0;

  virtual void enterDefaultValue(JavaParser::DefaultValueContext *ctx) = 0;
  virtual void exitDefaultValue(JavaParser::DefaultValueContext *ctx) = 0;

  virtual void enterAnnotation(JavaParser::AnnotationContext *ctx) = 0;
  virtual void exitAnnotation(JavaParser::AnnotationContext *ctx) = 0;

  virtual void enterNormalAnnotation(JavaParser::NormalAnnotationContext *ctx) = 0;
  virtual void exitNormalAnnotation(JavaParser::NormalAnnotationContext *ctx) = 0;

  virtual void enterElementValuePairList(JavaParser::ElementValuePairListContext *ctx) = 0;
  virtual void exitElementValuePairList(JavaParser::ElementValuePairListContext *ctx) = 0;

  virtual void enterElementValuePair(JavaParser::ElementValuePairContext *ctx) = 0;
  virtual void exitElementValuePair(JavaParser::ElementValuePairContext *ctx) = 0;

  virtual void enterElementValue(JavaParser::ElementValueContext *ctx) = 0;
  virtual void exitElementValue(JavaParser::ElementValueContext *ctx) = 0;

  virtual void enterElementValueArrayInitializer(JavaParser::ElementValueArrayInitializerContext *ctx) = 0;
  virtual void exitElementValueArrayInitializer(JavaParser::ElementValueArrayInitializerContext *ctx) = 0;

  virtual void enterElementValueList(JavaParser::ElementValueListContext *ctx) = 0;
  virtual void exitElementValueList(JavaParser::ElementValueListContext *ctx) = 0;

  virtual void enterMarkerAnnotation(JavaParser::MarkerAnnotationContext *ctx) = 0;
  virtual void exitMarkerAnnotation(JavaParser::MarkerAnnotationContext *ctx) = 0;

  virtual void enterSingleElementAnnotation(JavaParser::SingleElementAnnotationContext *ctx) = 0;
  virtual void exitSingleElementAnnotation(JavaParser::SingleElementAnnotationContext *ctx) = 0;

  virtual void enterArrayInitializer(JavaParser::ArrayInitializerContext *ctx) = 0;
  virtual void exitArrayInitializer(JavaParser::ArrayInitializerContext *ctx) = 0;

  virtual void enterVariableInitializerList(JavaParser::VariableInitializerListContext *ctx) = 0;
  virtual void exitVariableInitializerList(JavaParser::VariableInitializerListContext *ctx) = 0;

  virtual void enterBlock(JavaParser::BlockContext *ctx) = 0;
  virtual void exitBlock(JavaParser::BlockContext *ctx) = 0;

  virtual void enterBlockStatements(JavaParser::BlockStatementsContext *ctx) = 0;
  virtual void exitBlockStatements(JavaParser::BlockStatementsContext *ctx) = 0;

  virtual void enterBlockStatement(JavaParser::BlockStatementContext *ctx) = 0;
  virtual void exitBlockStatement(JavaParser::BlockStatementContext *ctx) = 0;

  virtual void enterLocalVariableDeclarationStatement(JavaParser::LocalVariableDeclarationStatementContext *ctx) = 0;
  virtual void exitLocalVariableDeclarationStatement(JavaParser::LocalVariableDeclarationStatementContext *ctx) = 0;

  virtual void enterLocalVariableDeclaration(JavaParser::LocalVariableDeclarationContext *ctx) = 0;
  virtual void exitLocalVariableDeclaration(JavaParser::LocalVariableDeclarationContext *ctx) = 0;

  virtual void enterStatement(JavaParser::StatementContext *ctx) = 0;
  virtual void exitStatement(JavaParser::StatementContext *ctx) = 0;

  virtual void enterStatementNoShortIf(JavaParser::StatementNoShortIfContext *ctx) = 0;
  virtual void exitStatementNoShortIf(JavaParser::StatementNoShortIfContext *ctx) = 0;

  virtual void enterStatementWithoutTrailingSubstatement(JavaParser::StatementWithoutTrailingSubstatementContext *ctx) = 0;
  virtual void exitStatementWithoutTrailingSubstatement(JavaParser::StatementWithoutTrailingSubstatementContext *ctx) = 0;

  virtual void enterEmptyStatement(JavaParser::EmptyStatementContext *ctx) = 0;
  virtual void exitEmptyStatement(JavaParser::EmptyStatementContext *ctx) = 0;

  virtual void enterLabeledStatement(JavaParser::LabeledStatementContext *ctx) = 0;
  virtual void exitLabeledStatement(JavaParser::LabeledStatementContext *ctx) = 0;

  virtual void enterLabeledStatementNoShortIf(JavaParser::LabeledStatementNoShortIfContext *ctx) = 0;
  virtual void exitLabeledStatementNoShortIf(JavaParser::LabeledStatementNoShortIfContext *ctx) = 0;

  virtual void enterExpressionStatement(JavaParser::ExpressionStatementContext *ctx) = 0;
  virtual void exitExpressionStatement(JavaParser::ExpressionStatementContext *ctx) = 0;

  virtual void enterStatementExpression(JavaParser::StatementExpressionContext *ctx) = 0;
  virtual void exitStatementExpression(JavaParser::StatementExpressionContext *ctx) = 0;

  virtual void enterIfThenStatement(JavaParser::IfThenStatementContext *ctx) = 0;
  virtual void exitIfThenStatement(JavaParser::IfThenStatementContext *ctx) = 0;

  virtual void enterIfThenElseStatement(JavaParser::IfThenElseStatementContext *ctx) = 0;
  virtual void exitIfThenElseStatement(JavaParser::IfThenElseStatementContext *ctx) = 0;

  virtual void enterIfThenElseStatementNoShortIf(JavaParser::IfThenElseStatementNoShortIfContext *ctx) = 0;
  virtual void exitIfThenElseStatementNoShortIf(JavaParser::IfThenElseStatementNoShortIfContext *ctx) = 0;

  virtual void enterAssertStatement(JavaParser::AssertStatementContext *ctx) = 0;
  virtual void exitAssertStatement(JavaParser::AssertStatementContext *ctx) = 0;

  virtual void enterSwitchStatement(JavaParser::SwitchStatementContext *ctx) = 0;
  virtual void exitSwitchStatement(JavaParser::SwitchStatementContext *ctx) = 0;

  virtual void enterSwitchBlock(JavaParser::SwitchBlockContext *ctx) = 0;
  virtual void exitSwitchBlock(JavaParser::SwitchBlockContext *ctx) = 0;

  virtual void enterSwitchBlockStatementGroup(JavaParser::SwitchBlockStatementGroupContext *ctx) = 0;
  virtual void exitSwitchBlockStatementGroup(JavaParser::SwitchBlockStatementGroupContext *ctx) = 0;

  virtual void enterSwitchLabels(JavaParser::SwitchLabelsContext *ctx) = 0;
  virtual void exitSwitchLabels(JavaParser::SwitchLabelsContext *ctx) = 0;

  virtual void enterSwitchLabel(JavaParser::SwitchLabelContext *ctx) = 0;
  virtual void exitSwitchLabel(JavaParser::SwitchLabelContext *ctx) = 0;

  virtual void enterEnumConstantName(JavaParser::EnumConstantNameContext *ctx) = 0;
  virtual void exitEnumConstantName(JavaParser::EnumConstantNameContext *ctx) = 0;

  virtual void enterWhileStatement(JavaParser::WhileStatementContext *ctx) = 0;
  virtual void exitWhileStatement(JavaParser::WhileStatementContext *ctx) = 0;

  virtual void enterWhileStatementNoShortIf(JavaParser::WhileStatementNoShortIfContext *ctx) = 0;
  virtual void exitWhileStatementNoShortIf(JavaParser::WhileStatementNoShortIfContext *ctx) = 0;

  virtual void enterDoStatement(JavaParser::DoStatementContext *ctx) = 0;
  virtual void exitDoStatement(JavaParser::DoStatementContext *ctx) = 0;

  virtual void enterForStatement(JavaParser::ForStatementContext *ctx) = 0;
  virtual void exitForStatement(JavaParser::ForStatementContext *ctx) = 0;

  virtual void enterForStatementNoShortIf(JavaParser::ForStatementNoShortIfContext *ctx) = 0;
  virtual void exitForStatementNoShortIf(JavaParser::ForStatementNoShortIfContext *ctx) = 0;

  virtual void enterBasicForStatement(JavaParser::BasicForStatementContext *ctx) = 0;
  virtual void exitBasicForStatement(JavaParser::BasicForStatementContext *ctx) = 0;

  virtual void enterBasicForStatementNoShortIf(JavaParser::BasicForStatementNoShortIfContext *ctx) = 0;
  virtual void exitBasicForStatementNoShortIf(JavaParser::BasicForStatementNoShortIfContext *ctx) = 0;

  virtual void enterForInit(JavaParser::ForInitContext *ctx) = 0;
  virtual void exitForInit(JavaParser::ForInitContext *ctx) = 0;

  virtual void enterForUpdate(JavaParser::ForUpdateContext *ctx) = 0;
  virtual void exitForUpdate(JavaParser::ForUpdateContext *ctx) = 0;

  virtual void enterStatementExpressionList(JavaParser::StatementExpressionListContext *ctx) = 0;
  virtual void exitStatementExpressionList(JavaParser::StatementExpressionListContext *ctx) = 0;

  virtual void enterEnhancedForStatement(JavaParser::EnhancedForStatementContext *ctx) = 0;
  virtual void exitEnhancedForStatement(JavaParser::EnhancedForStatementContext *ctx) = 0;

  virtual void enterEnhancedForStatementNoShortIf(JavaParser::EnhancedForStatementNoShortIfContext *ctx) = 0;
  virtual void exitEnhancedForStatementNoShortIf(JavaParser::EnhancedForStatementNoShortIfContext *ctx) = 0;

  virtual void enterBreakStatement(JavaParser::BreakStatementContext *ctx) = 0;
  virtual void exitBreakStatement(JavaParser::BreakStatementContext *ctx) = 0;

  virtual void enterContinueStatement(JavaParser::ContinueStatementContext *ctx) = 0;
  virtual void exitContinueStatement(JavaParser::ContinueStatementContext *ctx) = 0;

  virtual void enterReturnStatement(JavaParser::ReturnStatementContext *ctx) = 0;
  virtual void exitReturnStatement(JavaParser::ReturnStatementContext *ctx) = 0;

  virtual void enterThrowStatement(JavaParser::ThrowStatementContext *ctx) = 0;
  virtual void exitThrowStatement(JavaParser::ThrowStatementContext *ctx) = 0;

  virtual void enterSynchronizedStatement(JavaParser::SynchronizedStatementContext *ctx) = 0;
  virtual void exitSynchronizedStatement(JavaParser::SynchronizedStatementContext *ctx) = 0;

  virtual void enterTryStatement(JavaParser::TryStatementContext *ctx) = 0;
  virtual void exitTryStatement(JavaParser::TryStatementContext *ctx) = 0;

  virtual void enterCatches(JavaParser::CatchesContext *ctx) = 0;
  virtual void exitCatches(JavaParser::CatchesContext *ctx) = 0;

  virtual void enterCatchClause(JavaParser::CatchClauseContext *ctx) = 0;
  virtual void exitCatchClause(JavaParser::CatchClauseContext *ctx) = 0;

  virtual void enterCatchFormalParameter(JavaParser::CatchFormalParameterContext *ctx) = 0;
  virtual void exitCatchFormalParameter(JavaParser::CatchFormalParameterContext *ctx) = 0;

  virtual void enterCatchType(JavaParser::CatchTypeContext *ctx) = 0;
  virtual void exitCatchType(JavaParser::CatchTypeContext *ctx) = 0;

  virtual void enterFinally_(JavaParser::Finally_Context *ctx) = 0;
  virtual void exitFinally_(JavaParser::Finally_Context *ctx) = 0;

  virtual void enterTryWithResourcesStatement(JavaParser::TryWithResourcesStatementContext *ctx) = 0;
  virtual void exitTryWithResourcesStatement(JavaParser::TryWithResourcesStatementContext *ctx) = 0;

  virtual void enterResourceSpecification(JavaParser::ResourceSpecificationContext *ctx) = 0;
  virtual void exitResourceSpecification(JavaParser::ResourceSpecificationContext *ctx) = 0;

  virtual void enterResourceList(JavaParser::ResourceListContext *ctx) = 0;
  virtual void exitResourceList(JavaParser::ResourceListContext *ctx) = 0;

  virtual void enterResource(JavaParser::ResourceContext *ctx) = 0;
  virtual void exitResource(JavaParser::ResourceContext *ctx) = 0;

  virtual void enterVariableAccess(JavaParser::VariableAccessContext *ctx) = 0;
  virtual void exitVariableAccess(JavaParser::VariableAccessContext *ctx) = 0;

  virtual void enterPrimary(JavaParser::PrimaryContext *ctx) = 0;
  virtual void exitPrimary(JavaParser::PrimaryContext *ctx) = 0;

  virtual void enterPrimaryNoNewArray(JavaParser::PrimaryNoNewArrayContext *ctx) = 0;
  virtual void exitPrimaryNoNewArray(JavaParser::PrimaryNoNewArrayContext *ctx) = 0;

  virtual void enterPrimaryNoNewArray_lf_arrayAccess(JavaParser::PrimaryNoNewArray_lf_arrayAccessContext *ctx) = 0;
  virtual void exitPrimaryNoNewArray_lf_arrayAccess(JavaParser::PrimaryNoNewArray_lf_arrayAccessContext *ctx) = 0;

  virtual void enterPrimaryNoNewArray_lfno_arrayAccess(JavaParser::PrimaryNoNewArray_lfno_arrayAccessContext *ctx) = 0;
  virtual void exitPrimaryNoNewArray_lfno_arrayAccess(JavaParser::PrimaryNoNewArray_lfno_arrayAccessContext *ctx) = 0;

  virtual void enterPrimaryNoNewArray_lf_primary(JavaParser::PrimaryNoNewArray_lf_primaryContext *ctx) = 0;
  virtual void exitPrimaryNoNewArray_lf_primary(JavaParser::PrimaryNoNewArray_lf_primaryContext *ctx) = 0;

  virtual void enterPrimaryNoNewArray_lf_primary_lf_arrayAccess_lf_primary(JavaParser::PrimaryNoNewArray_lf_primary_lf_arrayAccess_lf_primaryContext *ctx) = 0;
  virtual void exitPrimaryNoNewArray_lf_primary_lf_arrayAccess_lf_primary(JavaParser::PrimaryNoNewArray_lf_primary_lf_arrayAccess_lf_primaryContext *ctx) = 0;

  virtual void enterPrimaryNoNewArray_lf_primary_lfno_arrayAccess_lf_primary(JavaParser::PrimaryNoNewArray_lf_primary_lfno_arrayAccess_lf_primaryContext *ctx) = 0;
  virtual void exitPrimaryNoNewArray_lf_primary_lfno_arrayAccess_lf_primary(JavaParser::PrimaryNoNewArray_lf_primary_lfno_arrayAccess_lf_primaryContext *ctx) = 0;

  virtual void enterPrimaryNoNewArray_lfno_primary(JavaParser::PrimaryNoNewArray_lfno_primaryContext *ctx) = 0;
  virtual void exitPrimaryNoNewArray_lfno_primary(JavaParser::PrimaryNoNewArray_lfno_primaryContext *ctx) = 0;

  virtual void enterPrimaryNoNewArray_lfno_primary_lf_arrayAccess_lfno_primary(JavaParser::PrimaryNoNewArray_lfno_primary_lf_arrayAccess_lfno_primaryContext *ctx) = 0;
  virtual void exitPrimaryNoNewArray_lfno_primary_lf_arrayAccess_lfno_primary(JavaParser::PrimaryNoNewArray_lfno_primary_lf_arrayAccess_lfno_primaryContext *ctx) = 0;

  virtual void enterPrimaryNoNewArray_lfno_primary_lfno_arrayAccess_lfno_primary(JavaParser::PrimaryNoNewArray_lfno_primary_lfno_arrayAccess_lfno_primaryContext *ctx) = 0;
  virtual void exitPrimaryNoNewArray_lfno_primary_lfno_arrayAccess_lfno_primary(JavaParser::PrimaryNoNewArray_lfno_primary_lfno_arrayAccess_lfno_primaryContext *ctx) = 0;

  virtual void enterClassLiteral(JavaParser::ClassLiteralContext *ctx) = 0;
  virtual void exitClassLiteral(JavaParser::ClassLiteralContext *ctx) = 0;

  virtual void enterClassInstanceCreationExpression(JavaParser::ClassInstanceCreationExpressionContext *ctx) = 0;
  virtual void exitClassInstanceCreationExpression(JavaParser::ClassInstanceCreationExpressionContext *ctx) = 0;

  virtual void enterClassInstanceCreationExpression_lf_primary(JavaParser::ClassInstanceCreationExpression_lf_primaryContext *ctx) = 0;
  virtual void exitClassInstanceCreationExpression_lf_primary(JavaParser::ClassInstanceCreationExpression_lf_primaryContext *ctx) = 0;

  virtual void enterClassInstanceCreationExpression_lfno_primary(JavaParser::ClassInstanceCreationExpression_lfno_primaryContext *ctx) = 0;
  virtual void exitClassInstanceCreationExpression_lfno_primary(JavaParser::ClassInstanceCreationExpression_lfno_primaryContext *ctx) = 0;

  virtual void enterTypeArgumentsOrDiamond(JavaParser::TypeArgumentsOrDiamondContext *ctx) = 0;
  virtual void exitTypeArgumentsOrDiamond(JavaParser::TypeArgumentsOrDiamondContext *ctx) = 0;

  virtual void enterFieldAccess(JavaParser::FieldAccessContext *ctx) = 0;
  virtual void exitFieldAccess(JavaParser::FieldAccessContext *ctx) = 0;

  virtual void enterFieldAccess_lf_primary(JavaParser::FieldAccess_lf_primaryContext *ctx) = 0;
  virtual void exitFieldAccess_lf_primary(JavaParser::FieldAccess_lf_primaryContext *ctx) = 0;

  virtual void enterFieldAccess_lfno_primary(JavaParser::FieldAccess_lfno_primaryContext *ctx) = 0;
  virtual void exitFieldAccess_lfno_primary(JavaParser::FieldAccess_lfno_primaryContext *ctx) = 0;

  virtual void enterArrayAccess(JavaParser::ArrayAccessContext *ctx) = 0;
  virtual void exitArrayAccess(JavaParser::ArrayAccessContext *ctx) = 0;

  virtual void enterArrayAccess_lf_primary(JavaParser::ArrayAccess_lf_primaryContext *ctx) = 0;
  virtual void exitArrayAccess_lf_primary(JavaParser::ArrayAccess_lf_primaryContext *ctx) = 0;

  virtual void enterArrayAccess_lfno_primary(JavaParser::ArrayAccess_lfno_primaryContext *ctx) = 0;
  virtual void exitArrayAccess_lfno_primary(JavaParser::ArrayAccess_lfno_primaryContext *ctx) = 0;

  virtual void enterMethodInvocation(JavaParser::MethodInvocationContext *ctx) = 0;
  virtual void exitMethodInvocation(JavaParser::MethodInvocationContext *ctx) = 0;

  virtual void enterMethodInvocation_lf_primary(JavaParser::MethodInvocation_lf_primaryContext *ctx) = 0;
  virtual void exitMethodInvocation_lf_primary(JavaParser::MethodInvocation_lf_primaryContext *ctx) = 0;

  virtual void enterMethodInvocation_lfno_primary(JavaParser::MethodInvocation_lfno_primaryContext *ctx) = 0;
  virtual void exitMethodInvocation_lfno_primary(JavaParser::MethodInvocation_lfno_primaryContext *ctx) = 0;

  virtual void enterArgumentList(JavaParser::ArgumentListContext *ctx) = 0;
  virtual void exitArgumentList(JavaParser::ArgumentListContext *ctx) = 0;

  virtual void enterMethodReference(JavaParser::MethodReferenceContext *ctx) = 0;
  virtual void exitMethodReference(JavaParser::MethodReferenceContext *ctx) = 0;

  virtual void enterMethodReference_lf_primary(JavaParser::MethodReference_lf_primaryContext *ctx) = 0;
  virtual void exitMethodReference_lf_primary(JavaParser::MethodReference_lf_primaryContext *ctx) = 0;

  virtual void enterMethodReference_lfno_primary(JavaParser::MethodReference_lfno_primaryContext *ctx) = 0;
  virtual void exitMethodReference_lfno_primary(JavaParser::MethodReference_lfno_primaryContext *ctx) = 0;

  virtual void enterArrayCreationExpression(JavaParser::ArrayCreationExpressionContext *ctx) = 0;
  virtual void exitArrayCreationExpression(JavaParser::ArrayCreationExpressionContext *ctx) = 0;

  virtual void enterDimExprs(JavaParser::DimExprsContext *ctx) = 0;
  virtual void exitDimExprs(JavaParser::DimExprsContext *ctx) = 0;

  virtual void enterDimExpr(JavaParser::DimExprContext *ctx) = 0;
  virtual void exitDimExpr(JavaParser::DimExprContext *ctx) = 0;

  virtual void enterConstantExpression(JavaParser::ConstantExpressionContext *ctx) = 0;
  virtual void exitConstantExpression(JavaParser::ConstantExpressionContext *ctx) = 0;

  virtual void enterExpression(JavaParser::ExpressionContext *ctx) = 0;
  virtual void exitExpression(JavaParser::ExpressionContext *ctx) = 0;

  virtual void enterLambdaExpression(JavaParser::LambdaExpressionContext *ctx) = 0;
  virtual void exitLambdaExpression(JavaParser::LambdaExpressionContext *ctx) = 0;

  virtual void enterLambdaParameters(JavaParser::LambdaParametersContext *ctx) = 0;
  virtual void exitLambdaParameters(JavaParser::LambdaParametersContext *ctx) = 0;

  virtual void enterInferredFormalParameterList(JavaParser::InferredFormalParameterListContext *ctx) = 0;
  virtual void exitInferredFormalParameterList(JavaParser::InferredFormalParameterListContext *ctx) = 0;

  virtual void enterLambdaBody(JavaParser::LambdaBodyContext *ctx) = 0;
  virtual void exitLambdaBody(JavaParser::LambdaBodyContext *ctx) = 0;

  virtual void enterAssignmentExpression(JavaParser::AssignmentExpressionContext *ctx) = 0;
  virtual void exitAssignmentExpression(JavaParser::AssignmentExpressionContext *ctx) = 0;

  virtual void enterAssignment(JavaParser::AssignmentContext *ctx) = 0;
  virtual void exitAssignment(JavaParser::AssignmentContext *ctx) = 0;

  virtual void enterLeftHandSide(JavaParser::LeftHandSideContext *ctx) = 0;
  virtual void exitLeftHandSide(JavaParser::LeftHandSideContext *ctx) = 0;

  virtual void enterAssignmentOperator(JavaParser::AssignmentOperatorContext *ctx) = 0;
  virtual void exitAssignmentOperator(JavaParser::AssignmentOperatorContext *ctx) = 0;

  virtual void enterConditionalExpression(JavaParser::ConditionalExpressionContext *ctx) = 0;
  virtual void exitConditionalExpression(JavaParser::ConditionalExpressionContext *ctx) = 0;

  virtual void enterConditionalOrExpression(JavaParser::ConditionalOrExpressionContext *ctx) = 0;
  virtual void exitConditionalOrExpression(JavaParser::ConditionalOrExpressionContext *ctx) = 0;

  virtual void enterConditionalAndExpression(JavaParser::ConditionalAndExpressionContext *ctx) = 0;
  virtual void exitConditionalAndExpression(JavaParser::ConditionalAndExpressionContext *ctx) = 0;

  virtual void enterInclusiveOrExpression(JavaParser::InclusiveOrExpressionContext *ctx) = 0;
  virtual void exitInclusiveOrExpression(JavaParser::InclusiveOrExpressionContext *ctx) = 0;

  virtual void enterExclusiveOrExpression(JavaParser::ExclusiveOrExpressionContext *ctx) = 0;
  virtual void exitExclusiveOrExpression(JavaParser::ExclusiveOrExpressionContext *ctx) = 0;

  virtual void enterAndExpression(JavaParser::AndExpressionContext *ctx) = 0;
  virtual void exitAndExpression(JavaParser::AndExpressionContext *ctx) = 0;

  virtual void enterEqualityExpression(JavaParser::EqualityExpressionContext *ctx) = 0;
  virtual void exitEqualityExpression(JavaParser::EqualityExpressionContext *ctx) = 0;

  virtual void enterRelationalExpression(JavaParser::RelationalExpressionContext *ctx) = 0;
  virtual void exitRelationalExpression(JavaParser::RelationalExpressionContext *ctx) = 0;

  virtual void enterShiftExpression(JavaParser::ShiftExpressionContext *ctx) = 0;
  virtual void exitShiftExpression(JavaParser::ShiftExpressionContext *ctx) = 0;

  virtual void enterAdditiveExpression(JavaParser::AdditiveExpressionContext *ctx) = 0;
  virtual void exitAdditiveExpression(JavaParser::AdditiveExpressionContext *ctx) = 0;

  virtual void enterMultiplicativeExpression(JavaParser::MultiplicativeExpressionContext *ctx) = 0;
  virtual void exitMultiplicativeExpression(JavaParser::MultiplicativeExpressionContext *ctx) = 0;

  virtual void enterUnaryExpression(JavaParser::UnaryExpressionContext *ctx) = 0;
  virtual void exitUnaryExpression(JavaParser::UnaryExpressionContext *ctx) = 0;

  virtual void enterPreIncrementExpression(JavaParser::PreIncrementExpressionContext *ctx) = 0;
  virtual void exitPreIncrementExpression(JavaParser::PreIncrementExpressionContext *ctx) = 0;

  virtual void enterPreDecrementExpression(JavaParser::PreDecrementExpressionContext *ctx) = 0;
  virtual void exitPreDecrementExpression(JavaParser::PreDecrementExpressionContext *ctx) = 0;

  virtual void enterUnaryExpressionNotPlusMinus(JavaParser::UnaryExpressionNotPlusMinusContext *ctx) = 0;
  virtual void exitUnaryExpressionNotPlusMinus(JavaParser::UnaryExpressionNotPlusMinusContext *ctx) = 0;

  virtual void enterPostfixExpression(JavaParser::PostfixExpressionContext *ctx) = 0;
  virtual void exitPostfixExpression(JavaParser::PostfixExpressionContext *ctx) = 0;

  virtual void enterPostIncrementExpression(JavaParser::PostIncrementExpressionContext *ctx) = 0;
  virtual void exitPostIncrementExpression(JavaParser::PostIncrementExpressionContext *ctx) = 0;

  virtual void enterPostIncrementExpression_lf_postfixExpression(JavaParser::PostIncrementExpression_lf_postfixExpressionContext *ctx) = 0;
  virtual void exitPostIncrementExpression_lf_postfixExpression(JavaParser::PostIncrementExpression_lf_postfixExpressionContext *ctx) = 0;

  virtual void enterPostDecrementExpression(JavaParser::PostDecrementExpressionContext *ctx) = 0;
  virtual void exitPostDecrementExpression(JavaParser::PostDecrementExpressionContext *ctx) = 0;

  virtual void enterPostDecrementExpression_lf_postfixExpression(JavaParser::PostDecrementExpression_lf_postfixExpressionContext *ctx) = 0;
  virtual void exitPostDecrementExpression_lf_postfixExpression(JavaParser::PostDecrementExpression_lf_postfixExpressionContext *ctx) = 0;

  virtual void enterCastExpression(JavaParser::CastExpressionContext *ctx) = 0;
  virtual void exitCastExpression(JavaParser::CastExpressionContext *ctx) = 0;

  virtual void enterLiteral_DropletFile(JavaParser::Literal_DropletFileContext *ctx) = 0;
  virtual void exitLiteral_DropletFile(JavaParser::Literal_DropletFileContext *ctx) = 0;

  virtual void enterPrimitiveType_DropletFile(JavaParser::PrimitiveType_DropletFileContext *ctx) = 0;
  virtual void exitPrimitiveType_DropletFile(JavaParser::PrimitiveType_DropletFileContext *ctx) = 0;

  virtual void enterNumericType_DropletFile(JavaParser::NumericType_DropletFileContext *ctx) = 0;
  virtual void exitNumericType_DropletFile(JavaParser::NumericType_DropletFileContext *ctx) = 0;

  virtual void enterIntegralType_DropletFile(JavaParser::IntegralType_DropletFileContext *ctx) = 0;
  virtual void exitIntegralType_DropletFile(JavaParser::IntegralType_DropletFileContext *ctx) = 0;

  virtual void enterFloatingPointType_DropletFile(JavaParser::FloatingPointType_DropletFileContext *ctx) = 0;
  virtual void exitFloatingPointType_DropletFile(JavaParser::FloatingPointType_DropletFileContext *ctx) = 0;

  virtual void enterReferenceType_DropletFile(JavaParser::ReferenceType_DropletFileContext *ctx) = 0;
  virtual void exitReferenceType_DropletFile(JavaParser::ReferenceType_DropletFileContext *ctx) = 0;

  virtual void enterClassOrInterfaceType_DropletFile(JavaParser::ClassOrInterfaceType_DropletFileContext *ctx) = 0;
  virtual void exitClassOrInterfaceType_DropletFile(JavaParser::ClassOrInterfaceType_DropletFileContext *ctx) = 0;

  virtual void enterClassType_DropletFile(JavaParser::ClassType_DropletFileContext *ctx) = 0;
  virtual void exitClassType_DropletFile(JavaParser::ClassType_DropletFileContext *ctx) = 0;

  virtual void enterClassType_lf_classOrInterfaceType_DropletFile(JavaParser::ClassType_lf_classOrInterfaceType_DropletFileContext *ctx) = 0;
  virtual void exitClassType_lf_classOrInterfaceType_DropletFile(JavaParser::ClassType_lf_classOrInterfaceType_DropletFileContext *ctx) = 0;

  virtual void enterClassType_lfno_classOrInterfaceType_DropletFile(JavaParser::ClassType_lfno_classOrInterfaceType_DropletFileContext *ctx) = 0;
  virtual void exitClassType_lfno_classOrInterfaceType_DropletFile(JavaParser::ClassType_lfno_classOrInterfaceType_DropletFileContext *ctx) = 0;

  virtual void enterInterfaceType_DropletFile(JavaParser::InterfaceType_DropletFileContext *ctx) = 0;
  virtual void exitInterfaceType_DropletFile(JavaParser::InterfaceType_DropletFileContext *ctx) = 0;

  virtual void enterInterfaceType_lf_classOrInterfaceType_DropletFile(JavaParser::InterfaceType_lf_classOrInterfaceType_DropletFileContext *ctx) = 0;
  virtual void exitInterfaceType_lf_classOrInterfaceType_DropletFile(JavaParser::InterfaceType_lf_classOrInterfaceType_DropletFileContext *ctx) = 0;

  virtual void enterInterfaceType_lfno_classOrInterfaceType_DropletFile(JavaParser::InterfaceType_lfno_classOrInterfaceType_DropletFileContext *ctx) = 0;
  virtual void exitInterfaceType_lfno_classOrInterfaceType_DropletFile(JavaParser::InterfaceType_lfno_classOrInterfaceType_DropletFileContext *ctx) = 0;

  virtual void enterTypeVariable_DropletFile(JavaParser::TypeVariable_DropletFileContext *ctx) = 0;
  virtual void exitTypeVariable_DropletFile(JavaParser::TypeVariable_DropletFileContext *ctx) = 0;

  virtual void enterArrayType_DropletFile(JavaParser::ArrayType_DropletFileContext *ctx) = 0;
  virtual void exitArrayType_DropletFile(JavaParser::ArrayType_DropletFileContext *ctx) = 0;

  virtual void enterDims_DropletFile(JavaParser::Dims_DropletFileContext *ctx) = 0;
  virtual void exitDims_DropletFile(JavaParser::Dims_DropletFileContext *ctx) = 0;

  virtual void enterTypeParameter_DropletFile(JavaParser::TypeParameter_DropletFileContext *ctx) = 0;
  virtual void exitTypeParameter_DropletFile(JavaParser::TypeParameter_DropletFileContext *ctx) = 0;

  virtual void enterTypeParameterModifier_DropletFile(JavaParser::TypeParameterModifier_DropletFileContext *ctx) = 0;
  virtual void exitTypeParameterModifier_DropletFile(JavaParser::TypeParameterModifier_DropletFileContext *ctx) = 0;

  virtual void enterTypeBound_DropletFile(JavaParser::TypeBound_DropletFileContext *ctx) = 0;
  virtual void exitTypeBound_DropletFile(JavaParser::TypeBound_DropletFileContext *ctx) = 0;

  virtual void enterAdditionalBound_DropletFile(JavaParser::AdditionalBound_DropletFileContext *ctx) = 0;
  virtual void exitAdditionalBound_DropletFile(JavaParser::AdditionalBound_DropletFileContext *ctx) = 0;

  virtual void enterTypeArguments_DropletFile(JavaParser::TypeArguments_DropletFileContext *ctx) = 0;
  virtual void exitTypeArguments_DropletFile(JavaParser::TypeArguments_DropletFileContext *ctx) = 0;

  virtual void enterTypeArgumentList_DropletFile(JavaParser::TypeArgumentList_DropletFileContext *ctx) = 0;
  virtual void exitTypeArgumentList_DropletFile(JavaParser::TypeArgumentList_DropletFileContext *ctx) = 0;

  virtual void enterTypeArgument_DropletFile(JavaParser::TypeArgument_DropletFileContext *ctx) = 0;
  virtual void exitTypeArgument_DropletFile(JavaParser::TypeArgument_DropletFileContext *ctx) = 0;

  virtual void enterWildcard_DropletFile(JavaParser::Wildcard_DropletFileContext *ctx) = 0;
  virtual void exitWildcard_DropletFile(JavaParser::Wildcard_DropletFileContext *ctx) = 0;

  virtual void enterWildcardBounds_DropletFile(JavaParser::WildcardBounds_DropletFileContext *ctx) = 0;
  virtual void exitWildcardBounds_DropletFile(JavaParser::WildcardBounds_DropletFileContext *ctx) = 0;

  virtual void enterModuleName_DropletFile(JavaParser::ModuleName_DropletFileContext *ctx) = 0;
  virtual void exitModuleName_DropletFile(JavaParser::ModuleName_DropletFileContext *ctx) = 0;

  virtual void enterPackageName_DropletFile(JavaParser::PackageName_DropletFileContext *ctx) = 0;
  virtual void exitPackageName_DropletFile(JavaParser::PackageName_DropletFileContext *ctx) = 0;

  virtual void enterTypeName_DropletFile(JavaParser::TypeName_DropletFileContext *ctx) = 0;
  virtual void exitTypeName_DropletFile(JavaParser::TypeName_DropletFileContext *ctx) = 0;

  virtual void enterPackageOrTypeName_DropletFile(JavaParser::PackageOrTypeName_DropletFileContext *ctx) = 0;
  virtual void exitPackageOrTypeName_DropletFile(JavaParser::PackageOrTypeName_DropletFileContext *ctx) = 0;

  virtual void enterExpressionName_DropletFile(JavaParser::ExpressionName_DropletFileContext *ctx) = 0;
  virtual void exitExpressionName_DropletFile(JavaParser::ExpressionName_DropletFileContext *ctx) = 0;

  virtual void enterMethodName_DropletFile(JavaParser::MethodName_DropletFileContext *ctx) = 0;
  virtual void exitMethodName_DropletFile(JavaParser::MethodName_DropletFileContext *ctx) = 0;

  virtual void enterAmbiguousName_DropletFile(JavaParser::AmbiguousName_DropletFileContext *ctx) = 0;
  virtual void exitAmbiguousName_DropletFile(JavaParser::AmbiguousName_DropletFileContext *ctx) = 0;

  virtual void enterCompilationUnit_DropletFile(JavaParser::CompilationUnit_DropletFileContext *ctx) = 0;
  virtual void exitCompilationUnit_DropletFile(JavaParser::CompilationUnit_DropletFileContext *ctx) = 0;

  virtual void enterOrdinaryCompilation_DropletFile(JavaParser::OrdinaryCompilation_DropletFileContext *ctx) = 0;
  virtual void exitOrdinaryCompilation_DropletFile(JavaParser::OrdinaryCompilation_DropletFileContext *ctx) = 0;

  virtual void enterModularCompilation_DropletFile(JavaParser::ModularCompilation_DropletFileContext *ctx) = 0;
  virtual void exitModularCompilation_DropletFile(JavaParser::ModularCompilation_DropletFileContext *ctx) = 0;

  virtual void enterPackageDeclaration_DropletFile(JavaParser::PackageDeclaration_DropletFileContext *ctx) = 0;
  virtual void exitPackageDeclaration_DropletFile(JavaParser::PackageDeclaration_DropletFileContext *ctx) = 0;

  virtual void enterPackageModifier_DropletFile(JavaParser::PackageModifier_DropletFileContext *ctx) = 0;
  virtual void exitPackageModifier_DropletFile(JavaParser::PackageModifier_DropletFileContext *ctx) = 0;

  virtual void enterImportDeclaration_DropletFile(JavaParser::ImportDeclaration_DropletFileContext *ctx) = 0;
  virtual void exitImportDeclaration_DropletFile(JavaParser::ImportDeclaration_DropletFileContext *ctx) = 0;

  virtual void enterSingleTypeImportDeclaration_DropletFile(JavaParser::SingleTypeImportDeclaration_DropletFileContext *ctx) = 0;
  virtual void exitSingleTypeImportDeclaration_DropletFile(JavaParser::SingleTypeImportDeclaration_DropletFileContext *ctx) = 0;

  virtual void enterTypeImportOnDemandDeclaration_DropletFile(JavaParser::TypeImportOnDemandDeclaration_DropletFileContext *ctx) = 0;
  virtual void exitTypeImportOnDemandDeclaration_DropletFile(JavaParser::TypeImportOnDemandDeclaration_DropletFileContext *ctx) = 0;

  virtual void enterSingleStaticImportDeclaration_DropletFile(JavaParser::SingleStaticImportDeclaration_DropletFileContext *ctx) = 0;
  virtual void exitSingleStaticImportDeclaration_DropletFile(JavaParser::SingleStaticImportDeclaration_DropletFileContext *ctx) = 0;

  virtual void enterStaticImportOnDemandDeclaration_DropletFile(JavaParser::StaticImportOnDemandDeclaration_DropletFileContext *ctx) = 0;
  virtual void exitStaticImportOnDemandDeclaration_DropletFile(JavaParser::StaticImportOnDemandDeclaration_DropletFileContext *ctx) = 0;

  virtual void enterTypeDeclaration_DropletFile(JavaParser::TypeDeclaration_DropletFileContext *ctx) = 0;
  virtual void exitTypeDeclaration_DropletFile(JavaParser::TypeDeclaration_DropletFileContext *ctx) = 0;

  virtual void enterModuleDeclaration_DropletFile(JavaParser::ModuleDeclaration_DropletFileContext *ctx) = 0;
  virtual void exitModuleDeclaration_DropletFile(JavaParser::ModuleDeclaration_DropletFileContext *ctx) = 0;

  virtual void enterModuleDirective_DropletFile(JavaParser::ModuleDirective_DropletFileContext *ctx) = 0;
  virtual void exitModuleDirective_DropletFile(JavaParser::ModuleDirective_DropletFileContext *ctx) = 0;

  virtual void enterRequiresModifier_DropletFile(JavaParser::RequiresModifier_DropletFileContext *ctx) = 0;
  virtual void exitRequiresModifier_DropletFile(JavaParser::RequiresModifier_DropletFileContext *ctx) = 0;

  virtual void enterClassDeclaration_DropletFile(JavaParser::ClassDeclaration_DropletFileContext *ctx) = 0;
  virtual void exitClassDeclaration_DropletFile(JavaParser::ClassDeclaration_DropletFileContext *ctx) = 0;

  virtual void enterNormalClassDeclaration_DropletFile(JavaParser::NormalClassDeclaration_DropletFileContext *ctx) = 0;
  virtual void exitNormalClassDeclaration_DropletFile(JavaParser::NormalClassDeclaration_DropletFileContext *ctx) = 0;

  virtual void enterClassModifier_DropletFile(JavaParser::ClassModifier_DropletFileContext *ctx) = 0;
  virtual void exitClassModifier_DropletFile(JavaParser::ClassModifier_DropletFileContext *ctx) = 0;

  virtual void enterTypeParameters_DropletFile(JavaParser::TypeParameters_DropletFileContext *ctx) = 0;
  virtual void exitTypeParameters_DropletFile(JavaParser::TypeParameters_DropletFileContext *ctx) = 0;

  virtual void enterTypeParameterList_DropletFile(JavaParser::TypeParameterList_DropletFileContext *ctx) = 0;
  virtual void exitTypeParameterList_DropletFile(JavaParser::TypeParameterList_DropletFileContext *ctx) = 0;

  virtual void enterSuperclass_DropletFile(JavaParser::Superclass_DropletFileContext *ctx) = 0;
  virtual void exitSuperclass_DropletFile(JavaParser::Superclass_DropletFileContext *ctx) = 0;

  virtual void enterSuperinterfaces_DropletFile(JavaParser::Superinterfaces_DropletFileContext *ctx) = 0;
  virtual void exitSuperinterfaces_DropletFile(JavaParser::Superinterfaces_DropletFileContext *ctx) = 0;

  virtual void enterInterfaceTypeList_DropletFile(JavaParser::InterfaceTypeList_DropletFileContext *ctx) = 0;
  virtual void exitInterfaceTypeList_DropletFile(JavaParser::InterfaceTypeList_DropletFileContext *ctx) = 0;

  virtual void enterClassBody_DropletFile(JavaParser::ClassBody_DropletFileContext *ctx) = 0;
  virtual void exitClassBody_DropletFile(JavaParser::ClassBody_DropletFileContext *ctx) = 0;

  virtual void enterClassBodyDeclaration_DropletFile(JavaParser::ClassBodyDeclaration_DropletFileContext *ctx) = 0;
  virtual void exitClassBodyDeclaration_DropletFile(JavaParser::ClassBodyDeclaration_DropletFileContext *ctx) = 0;

  virtual void enterClassMemberDeclaration_DropletFile(JavaParser::ClassMemberDeclaration_DropletFileContext *ctx) = 0;
  virtual void exitClassMemberDeclaration_DropletFile(JavaParser::ClassMemberDeclaration_DropletFileContext *ctx) = 0;

  virtual void enterFieldDeclaration_DropletFile(JavaParser::FieldDeclaration_DropletFileContext *ctx) = 0;
  virtual void exitFieldDeclaration_DropletFile(JavaParser::FieldDeclaration_DropletFileContext *ctx) = 0;

  virtual void enterFieldModifier_DropletFile(JavaParser::FieldModifier_DropletFileContext *ctx) = 0;
  virtual void exitFieldModifier_DropletFile(JavaParser::FieldModifier_DropletFileContext *ctx) = 0;

  virtual void enterVariableDeclaratorList_DropletFile(JavaParser::VariableDeclaratorList_DropletFileContext *ctx) = 0;
  virtual void exitVariableDeclaratorList_DropletFile(JavaParser::VariableDeclaratorList_DropletFileContext *ctx) = 0;

  virtual void enterVariableDeclarator_DropletFile(JavaParser::VariableDeclarator_DropletFileContext *ctx) = 0;
  virtual void exitVariableDeclarator_DropletFile(JavaParser::VariableDeclarator_DropletFileContext *ctx) = 0;

  virtual void enterVariableDeclaratorId_DropletFile(JavaParser::VariableDeclaratorId_DropletFileContext *ctx) = 0;
  virtual void exitVariableDeclaratorId_DropletFile(JavaParser::VariableDeclaratorId_DropletFileContext *ctx) = 0;

  virtual void enterVariableInitializer_DropletFile(JavaParser::VariableInitializer_DropletFileContext *ctx) = 0;
  virtual void exitVariableInitializer_DropletFile(JavaParser::VariableInitializer_DropletFileContext *ctx) = 0;

  virtual void enterUnannType_DropletFile(JavaParser::UnannType_DropletFileContext *ctx) = 0;
  virtual void exitUnannType_DropletFile(JavaParser::UnannType_DropletFileContext *ctx) = 0;

  virtual void enterUnannPrimitiveType_DropletFile(JavaParser::UnannPrimitiveType_DropletFileContext *ctx) = 0;
  virtual void exitUnannPrimitiveType_DropletFile(JavaParser::UnannPrimitiveType_DropletFileContext *ctx) = 0;

  virtual void enterUnannReferenceType_DropletFile(JavaParser::UnannReferenceType_DropletFileContext *ctx) = 0;
  virtual void exitUnannReferenceType_DropletFile(JavaParser::UnannReferenceType_DropletFileContext *ctx) = 0;

  virtual void enterUnannClassOrInterfaceType_DropletFile(JavaParser::UnannClassOrInterfaceType_DropletFileContext *ctx) = 0;
  virtual void exitUnannClassOrInterfaceType_DropletFile(JavaParser::UnannClassOrInterfaceType_DropletFileContext *ctx) = 0;

  virtual void enterUnannClassType_DropletFile(JavaParser::UnannClassType_DropletFileContext *ctx) = 0;
  virtual void exitUnannClassType_DropletFile(JavaParser::UnannClassType_DropletFileContext *ctx) = 0;

  virtual void enterUnannClassType_lf_unannClassOrInterfaceType_DropletFile(JavaParser::UnannClassType_lf_unannClassOrInterfaceType_DropletFileContext *ctx) = 0;
  virtual void exitUnannClassType_lf_unannClassOrInterfaceType_DropletFile(JavaParser::UnannClassType_lf_unannClassOrInterfaceType_DropletFileContext *ctx) = 0;

  virtual void enterUnannClassType_lfno_unannClassOrInterfaceType_DropletFile(JavaParser::UnannClassType_lfno_unannClassOrInterfaceType_DropletFileContext *ctx) = 0;
  virtual void exitUnannClassType_lfno_unannClassOrInterfaceType_DropletFile(JavaParser::UnannClassType_lfno_unannClassOrInterfaceType_DropletFileContext *ctx) = 0;

  virtual void enterUnannInterfaceType_DropletFile(JavaParser::UnannInterfaceType_DropletFileContext *ctx) = 0;
  virtual void exitUnannInterfaceType_DropletFile(JavaParser::UnannInterfaceType_DropletFileContext *ctx) = 0;

  virtual void enterUnannInterfaceType_lf_unannClassOrInterfaceType_DropletFile(JavaParser::UnannInterfaceType_lf_unannClassOrInterfaceType_DropletFileContext *ctx) = 0;
  virtual void exitUnannInterfaceType_lf_unannClassOrInterfaceType_DropletFile(JavaParser::UnannInterfaceType_lf_unannClassOrInterfaceType_DropletFileContext *ctx) = 0;

  virtual void enterUnannInterfaceType_lfno_unannClassOrInterfaceType_DropletFile(JavaParser::UnannInterfaceType_lfno_unannClassOrInterfaceType_DropletFileContext *ctx) = 0;
  virtual void exitUnannInterfaceType_lfno_unannClassOrInterfaceType_DropletFile(JavaParser::UnannInterfaceType_lfno_unannClassOrInterfaceType_DropletFileContext *ctx) = 0;

  virtual void enterUnannTypeVariable_DropletFile(JavaParser::UnannTypeVariable_DropletFileContext *ctx) = 0;
  virtual void exitUnannTypeVariable_DropletFile(JavaParser::UnannTypeVariable_DropletFileContext *ctx) = 0;

  virtual void enterUnannArrayType_DropletFile(JavaParser::UnannArrayType_DropletFileContext *ctx) = 0;
  virtual void exitUnannArrayType_DropletFile(JavaParser::UnannArrayType_DropletFileContext *ctx) = 0;

  virtual void enterMethodDeclaration_DropletFile(JavaParser::MethodDeclaration_DropletFileContext *ctx) = 0;
  virtual void exitMethodDeclaration_DropletFile(JavaParser::MethodDeclaration_DropletFileContext *ctx) = 0;

  virtual void enterMethodModifier_DropletFile(JavaParser::MethodModifier_DropletFileContext *ctx) = 0;
  virtual void exitMethodModifier_DropletFile(JavaParser::MethodModifier_DropletFileContext *ctx) = 0;

  virtual void enterMethodHeader_DropletFile(JavaParser::MethodHeader_DropletFileContext *ctx) = 0;
  virtual void exitMethodHeader_DropletFile(JavaParser::MethodHeader_DropletFileContext *ctx) = 0;

  virtual void enterResult_DropletFile(JavaParser::Result_DropletFileContext *ctx) = 0;
  virtual void exitResult_DropletFile(JavaParser::Result_DropletFileContext *ctx) = 0;

  virtual void enterMethodDeclarator_DropletFile(JavaParser::MethodDeclarator_DropletFileContext *ctx) = 0;
  virtual void exitMethodDeclarator_DropletFile(JavaParser::MethodDeclarator_DropletFileContext *ctx) = 0;

  virtual void enterFormalParameterList_DropletFile(JavaParser::FormalParameterList_DropletFileContext *ctx) = 0;
  virtual void exitFormalParameterList_DropletFile(JavaParser::FormalParameterList_DropletFileContext *ctx) = 0;

  virtual void enterFormalParameters_DropletFile(JavaParser::FormalParameters_DropletFileContext *ctx) = 0;
  virtual void exitFormalParameters_DropletFile(JavaParser::FormalParameters_DropletFileContext *ctx) = 0;

  virtual void enterFormalParameter_DropletFile(JavaParser::FormalParameter_DropletFileContext *ctx) = 0;
  virtual void exitFormalParameter_DropletFile(JavaParser::FormalParameter_DropletFileContext *ctx) = 0;

  virtual void enterVariableModifier_DropletFile(JavaParser::VariableModifier_DropletFileContext *ctx) = 0;
  virtual void exitVariableModifier_DropletFile(JavaParser::VariableModifier_DropletFileContext *ctx) = 0;

  virtual void enterLastFormalParameter_DropletFile(JavaParser::LastFormalParameter_DropletFileContext *ctx) = 0;
  virtual void exitLastFormalParameter_DropletFile(JavaParser::LastFormalParameter_DropletFileContext *ctx) = 0;

  virtual void enterReceiverParameter_DropletFile(JavaParser::ReceiverParameter_DropletFileContext *ctx) = 0;
  virtual void exitReceiverParameter_DropletFile(JavaParser::ReceiverParameter_DropletFileContext *ctx) = 0;

  virtual void enterThrows__DropletFile(JavaParser::Throws__DropletFileContext *ctx) = 0;
  virtual void exitThrows__DropletFile(JavaParser::Throws__DropletFileContext *ctx) = 0;

  virtual void enterExceptionTypeList_DropletFile(JavaParser::ExceptionTypeList_DropletFileContext *ctx) = 0;
  virtual void exitExceptionTypeList_DropletFile(JavaParser::ExceptionTypeList_DropletFileContext *ctx) = 0;

  virtual void enterExceptionType_DropletFile(JavaParser::ExceptionType_DropletFileContext *ctx) = 0;
  virtual void exitExceptionType_DropletFile(JavaParser::ExceptionType_DropletFileContext *ctx) = 0;

  virtual void enterMethodBody_DropletFile(JavaParser::MethodBody_DropletFileContext *ctx) = 0;
  virtual void exitMethodBody_DropletFile(JavaParser::MethodBody_DropletFileContext *ctx) = 0;

  virtual void enterInstanceInitializer_DropletFile(JavaParser::InstanceInitializer_DropletFileContext *ctx) = 0;
  virtual void exitInstanceInitializer_DropletFile(JavaParser::InstanceInitializer_DropletFileContext *ctx) = 0;

  virtual void enterStaticInitializer_DropletFile(JavaParser::StaticInitializer_DropletFileContext *ctx) = 0;
  virtual void exitStaticInitializer_DropletFile(JavaParser::StaticInitializer_DropletFileContext *ctx) = 0;

  virtual void enterConstructorDeclaration_DropletFile(JavaParser::ConstructorDeclaration_DropletFileContext *ctx) = 0;
  virtual void exitConstructorDeclaration_DropletFile(JavaParser::ConstructorDeclaration_DropletFileContext *ctx) = 0;

  virtual void enterConstructorModifier_DropletFile(JavaParser::ConstructorModifier_DropletFileContext *ctx) = 0;
  virtual void exitConstructorModifier_DropletFile(JavaParser::ConstructorModifier_DropletFileContext *ctx) = 0;

  virtual void enterConstructorDeclarator_DropletFile(JavaParser::ConstructorDeclarator_DropletFileContext *ctx) = 0;
  virtual void exitConstructorDeclarator_DropletFile(JavaParser::ConstructorDeclarator_DropletFileContext *ctx) = 0;

  virtual void enterSimpleTypeName_DropletFile(JavaParser::SimpleTypeName_DropletFileContext *ctx) = 0;
  virtual void exitSimpleTypeName_DropletFile(JavaParser::SimpleTypeName_DropletFileContext *ctx) = 0;

  virtual void enterConstructorBody_DropletFile(JavaParser::ConstructorBody_DropletFileContext *ctx) = 0;
  virtual void exitConstructorBody_DropletFile(JavaParser::ConstructorBody_DropletFileContext *ctx) = 0;

  virtual void enterExplicitConstructorInvocation_DropletFile(JavaParser::ExplicitConstructorInvocation_DropletFileContext *ctx) = 0;
  virtual void exitExplicitConstructorInvocation_DropletFile(JavaParser::ExplicitConstructorInvocation_DropletFileContext *ctx) = 0;

  virtual void enterEnumDeclaration_DropletFile(JavaParser::EnumDeclaration_DropletFileContext *ctx) = 0;
  virtual void exitEnumDeclaration_DropletFile(JavaParser::EnumDeclaration_DropletFileContext *ctx) = 0;

  virtual void enterEnumBody_DropletFile(JavaParser::EnumBody_DropletFileContext *ctx) = 0;
  virtual void exitEnumBody_DropletFile(JavaParser::EnumBody_DropletFileContext *ctx) = 0;

  virtual void enterEnumConstantList_DropletFile(JavaParser::EnumConstantList_DropletFileContext *ctx) = 0;
  virtual void exitEnumConstantList_DropletFile(JavaParser::EnumConstantList_DropletFileContext *ctx) = 0;

  virtual void enterEnumConstant_DropletFile(JavaParser::EnumConstant_DropletFileContext *ctx) = 0;
  virtual void exitEnumConstant_DropletFile(JavaParser::EnumConstant_DropletFileContext *ctx) = 0;

  virtual void enterEnumConstantModifier_DropletFile(JavaParser::EnumConstantModifier_DropletFileContext *ctx) = 0;
  virtual void exitEnumConstantModifier_DropletFile(JavaParser::EnumConstantModifier_DropletFileContext *ctx) = 0;

  virtual void enterEnumBodyDeclarations_DropletFile(JavaParser::EnumBodyDeclarations_DropletFileContext *ctx) = 0;
  virtual void exitEnumBodyDeclarations_DropletFile(JavaParser::EnumBodyDeclarations_DropletFileContext *ctx) = 0;

  virtual void enterInterfaceDeclaration_DropletFile(JavaParser::InterfaceDeclaration_DropletFileContext *ctx) = 0;
  virtual void exitInterfaceDeclaration_DropletFile(JavaParser::InterfaceDeclaration_DropletFileContext *ctx) = 0;

  virtual void enterNormalInterfaceDeclaration_DropletFile(JavaParser::NormalInterfaceDeclaration_DropletFileContext *ctx) = 0;
  virtual void exitNormalInterfaceDeclaration_DropletFile(JavaParser::NormalInterfaceDeclaration_DropletFileContext *ctx) = 0;

  virtual void enterInterfaceModifier_DropletFile(JavaParser::InterfaceModifier_DropletFileContext *ctx) = 0;
  virtual void exitInterfaceModifier_DropletFile(JavaParser::InterfaceModifier_DropletFileContext *ctx) = 0;

  virtual void enterExtendsInterfaces_DropletFile(JavaParser::ExtendsInterfaces_DropletFileContext *ctx) = 0;
  virtual void exitExtendsInterfaces_DropletFile(JavaParser::ExtendsInterfaces_DropletFileContext *ctx) = 0;

  virtual void enterInterfaceBody_DropletFile(JavaParser::InterfaceBody_DropletFileContext *ctx) = 0;
  virtual void exitInterfaceBody_DropletFile(JavaParser::InterfaceBody_DropletFileContext *ctx) = 0;

  virtual void enterInterfaceMemberDeclaration_DropletFile(JavaParser::InterfaceMemberDeclaration_DropletFileContext *ctx) = 0;
  virtual void exitInterfaceMemberDeclaration_DropletFile(JavaParser::InterfaceMemberDeclaration_DropletFileContext *ctx) = 0;

  virtual void enterConstantDeclaration_DropletFile(JavaParser::ConstantDeclaration_DropletFileContext *ctx) = 0;
  virtual void exitConstantDeclaration_DropletFile(JavaParser::ConstantDeclaration_DropletFileContext *ctx) = 0;

  virtual void enterConstantModifier_DropletFile(JavaParser::ConstantModifier_DropletFileContext *ctx) = 0;
  virtual void exitConstantModifier_DropletFile(JavaParser::ConstantModifier_DropletFileContext *ctx) = 0;

  virtual void enterInterfaceMethodDeclaration_DropletFile(JavaParser::InterfaceMethodDeclaration_DropletFileContext *ctx) = 0;
  virtual void exitInterfaceMethodDeclaration_DropletFile(JavaParser::InterfaceMethodDeclaration_DropletFileContext *ctx) = 0;

  virtual void enterInterfaceMethodModifier_DropletFile(JavaParser::InterfaceMethodModifier_DropletFileContext *ctx) = 0;
  virtual void exitInterfaceMethodModifier_DropletFile(JavaParser::InterfaceMethodModifier_DropletFileContext *ctx) = 0;

  virtual void enterAnnotationTypeDeclaration_DropletFile(JavaParser::AnnotationTypeDeclaration_DropletFileContext *ctx) = 0;
  virtual void exitAnnotationTypeDeclaration_DropletFile(JavaParser::AnnotationTypeDeclaration_DropletFileContext *ctx) = 0;

  virtual void enterAnnotationTypeBody_DropletFile(JavaParser::AnnotationTypeBody_DropletFileContext *ctx) = 0;
  virtual void exitAnnotationTypeBody_DropletFile(JavaParser::AnnotationTypeBody_DropletFileContext *ctx) = 0;

  virtual void enterAnnotationTypeMemberDeclaration_DropletFile(JavaParser::AnnotationTypeMemberDeclaration_DropletFileContext *ctx) = 0;
  virtual void exitAnnotationTypeMemberDeclaration_DropletFile(JavaParser::AnnotationTypeMemberDeclaration_DropletFileContext *ctx) = 0;

  virtual void enterAnnotationTypeElementDeclaration_DropletFile(JavaParser::AnnotationTypeElementDeclaration_DropletFileContext *ctx) = 0;
  virtual void exitAnnotationTypeElementDeclaration_DropletFile(JavaParser::AnnotationTypeElementDeclaration_DropletFileContext *ctx) = 0;

  virtual void enterAnnotationTypeElementModifier_DropletFile(JavaParser::AnnotationTypeElementModifier_DropletFileContext *ctx) = 0;
  virtual void exitAnnotationTypeElementModifier_DropletFile(JavaParser::AnnotationTypeElementModifier_DropletFileContext *ctx) = 0;

  virtual void enterDefaultValue_DropletFile(JavaParser::DefaultValue_DropletFileContext *ctx) = 0;
  virtual void exitDefaultValue_DropletFile(JavaParser::DefaultValue_DropletFileContext *ctx) = 0;

  virtual void enterAnnotation_DropletFile(JavaParser::Annotation_DropletFileContext *ctx) = 0;
  virtual void exitAnnotation_DropletFile(JavaParser::Annotation_DropletFileContext *ctx) = 0;

  virtual void enterNormalAnnotation_DropletFile(JavaParser::NormalAnnotation_DropletFileContext *ctx) = 0;
  virtual void exitNormalAnnotation_DropletFile(JavaParser::NormalAnnotation_DropletFileContext *ctx) = 0;

  virtual void enterElementValuePairList_DropletFile(JavaParser::ElementValuePairList_DropletFileContext *ctx) = 0;
  virtual void exitElementValuePairList_DropletFile(JavaParser::ElementValuePairList_DropletFileContext *ctx) = 0;

  virtual void enterElementValuePair_DropletFile(JavaParser::ElementValuePair_DropletFileContext *ctx) = 0;
  virtual void exitElementValuePair_DropletFile(JavaParser::ElementValuePair_DropletFileContext *ctx) = 0;

  virtual void enterElementValue_DropletFile(JavaParser::ElementValue_DropletFileContext *ctx) = 0;
  virtual void exitElementValue_DropletFile(JavaParser::ElementValue_DropletFileContext *ctx) = 0;

  virtual void enterElementValueArrayInitializer_DropletFile(JavaParser::ElementValueArrayInitializer_DropletFileContext *ctx) = 0;
  virtual void exitElementValueArrayInitializer_DropletFile(JavaParser::ElementValueArrayInitializer_DropletFileContext *ctx) = 0;

  virtual void enterElementValueList_DropletFile(JavaParser::ElementValueList_DropletFileContext *ctx) = 0;
  virtual void exitElementValueList_DropletFile(JavaParser::ElementValueList_DropletFileContext *ctx) = 0;

  virtual void enterMarkerAnnotation_DropletFile(JavaParser::MarkerAnnotation_DropletFileContext *ctx) = 0;
  virtual void exitMarkerAnnotation_DropletFile(JavaParser::MarkerAnnotation_DropletFileContext *ctx) = 0;

  virtual void enterSingleElementAnnotation_DropletFile(JavaParser::SingleElementAnnotation_DropletFileContext *ctx) = 0;
  virtual void exitSingleElementAnnotation_DropletFile(JavaParser::SingleElementAnnotation_DropletFileContext *ctx) = 0;

  virtual void enterArrayInitializer_DropletFile(JavaParser::ArrayInitializer_DropletFileContext *ctx) = 0;
  virtual void exitArrayInitializer_DropletFile(JavaParser::ArrayInitializer_DropletFileContext *ctx) = 0;

  virtual void enterVariableInitializerList_DropletFile(JavaParser::VariableInitializerList_DropletFileContext *ctx) = 0;
  virtual void exitVariableInitializerList_DropletFile(JavaParser::VariableInitializerList_DropletFileContext *ctx) = 0;

  virtual void enterBlock_DropletFile(JavaParser::Block_DropletFileContext *ctx) = 0;
  virtual void exitBlock_DropletFile(JavaParser::Block_DropletFileContext *ctx) = 0;

  virtual void enterBlockStatements_DropletFile(JavaParser::BlockStatements_DropletFileContext *ctx) = 0;
  virtual void exitBlockStatements_DropletFile(JavaParser::BlockStatements_DropletFileContext *ctx) = 0;

  virtual void enterBlockStatement_DropletFile(JavaParser::BlockStatement_DropletFileContext *ctx) = 0;
  virtual void exitBlockStatement_DropletFile(JavaParser::BlockStatement_DropletFileContext *ctx) = 0;

  virtual void enterLocalVariableDeclarationStatement_DropletFile(JavaParser::LocalVariableDeclarationStatement_DropletFileContext *ctx) = 0;
  virtual void exitLocalVariableDeclarationStatement_DropletFile(JavaParser::LocalVariableDeclarationStatement_DropletFileContext *ctx) = 0;

  virtual void enterLocalVariableDeclaration_DropletFile(JavaParser::LocalVariableDeclaration_DropletFileContext *ctx) = 0;
  virtual void exitLocalVariableDeclaration_DropletFile(JavaParser::LocalVariableDeclaration_DropletFileContext *ctx) = 0;

  virtual void enterStatement_DropletFile(JavaParser::Statement_DropletFileContext *ctx) = 0;
  virtual void exitStatement_DropletFile(JavaParser::Statement_DropletFileContext *ctx) = 0;

  virtual void enterStatementNoShortIf_DropletFile(JavaParser::StatementNoShortIf_DropletFileContext *ctx) = 0;
  virtual void exitStatementNoShortIf_DropletFile(JavaParser::StatementNoShortIf_DropletFileContext *ctx) = 0;

  virtual void enterStatementWithoutTrailingSubstatement_DropletFile(JavaParser::StatementWithoutTrailingSubstatement_DropletFileContext *ctx) = 0;
  virtual void exitStatementWithoutTrailingSubstatement_DropletFile(JavaParser::StatementWithoutTrailingSubstatement_DropletFileContext *ctx) = 0;

  virtual void enterEmptyStatement_DropletFile(JavaParser::EmptyStatement_DropletFileContext *ctx) = 0;
  virtual void exitEmptyStatement_DropletFile(JavaParser::EmptyStatement_DropletFileContext *ctx) = 0;

  virtual void enterLabeledStatement_DropletFile(JavaParser::LabeledStatement_DropletFileContext *ctx) = 0;
  virtual void exitLabeledStatement_DropletFile(JavaParser::LabeledStatement_DropletFileContext *ctx) = 0;

  virtual void enterLabeledStatementNoShortIf_DropletFile(JavaParser::LabeledStatementNoShortIf_DropletFileContext *ctx) = 0;
  virtual void exitLabeledStatementNoShortIf_DropletFile(JavaParser::LabeledStatementNoShortIf_DropletFileContext *ctx) = 0;

  virtual void enterExpressionStatement_DropletFile(JavaParser::ExpressionStatement_DropletFileContext *ctx) = 0;
  virtual void exitExpressionStatement_DropletFile(JavaParser::ExpressionStatement_DropletFileContext *ctx) = 0;

  virtual void enterStatementExpression_DropletFile(JavaParser::StatementExpression_DropletFileContext *ctx) = 0;
  virtual void exitStatementExpression_DropletFile(JavaParser::StatementExpression_DropletFileContext *ctx) = 0;

  virtual void enterIfThenStatement_DropletFile(JavaParser::IfThenStatement_DropletFileContext *ctx) = 0;
  virtual void exitIfThenStatement_DropletFile(JavaParser::IfThenStatement_DropletFileContext *ctx) = 0;

  virtual void enterIfThenElseStatement_DropletFile(JavaParser::IfThenElseStatement_DropletFileContext *ctx) = 0;
  virtual void exitIfThenElseStatement_DropletFile(JavaParser::IfThenElseStatement_DropletFileContext *ctx) = 0;

  virtual void enterIfThenElseStatementNoShortIf_DropletFile(JavaParser::IfThenElseStatementNoShortIf_DropletFileContext *ctx) = 0;
  virtual void exitIfThenElseStatementNoShortIf_DropletFile(JavaParser::IfThenElseStatementNoShortIf_DropletFileContext *ctx) = 0;

  virtual void enterAssertStatement_DropletFile(JavaParser::AssertStatement_DropletFileContext *ctx) = 0;
  virtual void exitAssertStatement_DropletFile(JavaParser::AssertStatement_DropletFileContext *ctx) = 0;

  virtual void enterSwitchStatement_DropletFile(JavaParser::SwitchStatement_DropletFileContext *ctx) = 0;
  virtual void exitSwitchStatement_DropletFile(JavaParser::SwitchStatement_DropletFileContext *ctx) = 0;

  virtual void enterSwitchBlock_DropletFile(JavaParser::SwitchBlock_DropletFileContext *ctx) = 0;
  virtual void exitSwitchBlock_DropletFile(JavaParser::SwitchBlock_DropletFileContext *ctx) = 0;

  virtual void enterSwitchBlockStatementGroup_DropletFile(JavaParser::SwitchBlockStatementGroup_DropletFileContext *ctx) = 0;
  virtual void exitSwitchBlockStatementGroup_DropletFile(JavaParser::SwitchBlockStatementGroup_DropletFileContext *ctx) = 0;

  virtual void enterSwitchLabels_DropletFile(JavaParser::SwitchLabels_DropletFileContext *ctx) = 0;
  virtual void exitSwitchLabels_DropletFile(JavaParser::SwitchLabels_DropletFileContext *ctx) = 0;

  virtual void enterSwitchLabel_DropletFile(JavaParser::SwitchLabel_DropletFileContext *ctx) = 0;
  virtual void exitSwitchLabel_DropletFile(JavaParser::SwitchLabel_DropletFileContext *ctx) = 0;

  virtual void enterEnumConstantName_DropletFile(JavaParser::EnumConstantName_DropletFileContext *ctx) = 0;
  virtual void exitEnumConstantName_DropletFile(JavaParser::EnumConstantName_DropletFileContext *ctx) = 0;

  virtual void enterWhileStatement_DropletFile(JavaParser::WhileStatement_DropletFileContext *ctx) = 0;
  virtual void exitWhileStatement_DropletFile(JavaParser::WhileStatement_DropletFileContext *ctx) = 0;

  virtual void enterWhileStatementNoShortIf_DropletFile(JavaParser::WhileStatementNoShortIf_DropletFileContext *ctx) = 0;
  virtual void exitWhileStatementNoShortIf_DropletFile(JavaParser::WhileStatementNoShortIf_DropletFileContext *ctx) = 0;

  virtual void enterDoStatement_DropletFile(JavaParser::DoStatement_DropletFileContext *ctx) = 0;
  virtual void exitDoStatement_DropletFile(JavaParser::DoStatement_DropletFileContext *ctx) = 0;

  virtual void enterForStatement_DropletFile(JavaParser::ForStatement_DropletFileContext *ctx) = 0;
  virtual void exitForStatement_DropletFile(JavaParser::ForStatement_DropletFileContext *ctx) = 0;

  virtual void enterForStatementNoShortIf_DropletFile(JavaParser::ForStatementNoShortIf_DropletFileContext *ctx) = 0;
  virtual void exitForStatementNoShortIf_DropletFile(JavaParser::ForStatementNoShortIf_DropletFileContext *ctx) = 0;

  virtual void enterBasicForStatement_DropletFile(JavaParser::BasicForStatement_DropletFileContext *ctx) = 0;
  virtual void exitBasicForStatement_DropletFile(JavaParser::BasicForStatement_DropletFileContext *ctx) = 0;

  virtual void enterBasicForStatementNoShortIf_DropletFile(JavaParser::BasicForStatementNoShortIf_DropletFileContext *ctx) = 0;
  virtual void exitBasicForStatementNoShortIf_DropletFile(JavaParser::BasicForStatementNoShortIf_DropletFileContext *ctx) = 0;

  virtual void enterForInit_DropletFile(JavaParser::ForInit_DropletFileContext *ctx) = 0;
  virtual void exitForInit_DropletFile(JavaParser::ForInit_DropletFileContext *ctx) = 0;

  virtual void enterForUpdate_DropletFile(JavaParser::ForUpdate_DropletFileContext *ctx) = 0;
  virtual void exitForUpdate_DropletFile(JavaParser::ForUpdate_DropletFileContext *ctx) = 0;

  virtual void enterStatementExpressionList_DropletFile(JavaParser::StatementExpressionList_DropletFileContext *ctx) = 0;
  virtual void exitStatementExpressionList_DropletFile(JavaParser::StatementExpressionList_DropletFileContext *ctx) = 0;

  virtual void enterEnhancedForStatement_DropletFile(JavaParser::EnhancedForStatement_DropletFileContext *ctx) = 0;
  virtual void exitEnhancedForStatement_DropletFile(JavaParser::EnhancedForStatement_DropletFileContext *ctx) = 0;

  virtual void enterEnhancedForStatementNoShortIf_DropletFile(JavaParser::EnhancedForStatementNoShortIf_DropletFileContext *ctx) = 0;
  virtual void exitEnhancedForStatementNoShortIf_DropletFile(JavaParser::EnhancedForStatementNoShortIf_DropletFileContext *ctx) = 0;

  virtual void enterBreakStatement_DropletFile(JavaParser::BreakStatement_DropletFileContext *ctx) = 0;
  virtual void exitBreakStatement_DropletFile(JavaParser::BreakStatement_DropletFileContext *ctx) = 0;

  virtual void enterContinueStatement_DropletFile(JavaParser::ContinueStatement_DropletFileContext *ctx) = 0;
  virtual void exitContinueStatement_DropletFile(JavaParser::ContinueStatement_DropletFileContext *ctx) = 0;

  virtual void enterReturnStatement_DropletFile(JavaParser::ReturnStatement_DropletFileContext *ctx) = 0;
  virtual void exitReturnStatement_DropletFile(JavaParser::ReturnStatement_DropletFileContext *ctx) = 0;

  virtual void enterThrowStatement_DropletFile(JavaParser::ThrowStatement_DropletFileContext *ctx) = 0;
  virtual void exitThrowStatement_DropletFile(JavaParser::ThrowStatement_DropletFileContext *ctx) = 0;

  virtual void enterSynchronizedStatement_DropletFile(JavaParser::SynchronizedStatement_DropletFileContext *ctx) = 0;
  virtual void exitSynchronizedStatement_DropletFile(JavaParser::SynchronizedStatement_DropletFileContext *ctx) = 0;

  virtual void enterTryStatement_DropletFile(JavaParser::TryStatement_DropletFileContext *ctx) = 0;
  virtual void exitTryStatement_DropletFile(JavaParser::TryStatement_DropletFileContext *ctx) = 0;

  virtual void enterCatches_DropletFile(JavaParser::Catches_DropletFileContext *ctx) = 0;
  virtual void exitCatches_DropletFile(JavaParser::Catches_DropletFileContext *ctx) = 0;

  virtual void enterCatchClause_DropletFile(JavaParser::CatchClause_DropletFileContext *ctx) = 0;
  virtual void exitCatchClause_DropletFile(JavaParser::CatchClause_DropletFileContext *ctx) = 0;

  virtual void enterCatchFormalParameter_DropletFile(JavaParser::CatchFormalParameter_DropletFileContext *ctx) = 0;
  virtual void exitCatchFormalParameter_DropletFile(JavaParser::CatchFormalParameter_DropletFileContext *ctx) = 0;

  virtual void enterCatchType_DropletFile(JavaParser::CatchType_DropletFileContext *ctx) = 0;
  virtual void exitCatchType_DropletFile(JavaParser::CatchType_DropletFileContext *ctx) = 0;

  virtual void enterFinally__DropletFile(JavaParser::Finally__DropletFileContext *ctx) = 0;
  virtual void exitFinally__DropletFile(JavaParser::Finally__DropletFileContext *ctx) = 0;

  virtual void enterTryWithResourcesStatement_DropletFile(JavaParser::TryWithResourcesStatement_DropletFileContext *ctx) = 0;
  virtual void exitTryWithResourcesStatement_DropletFile(JavaParser::TryWithResourcesStatement_DropletFileContext *ctx) = 0;

  virtual void enterResourceSpecification_DropletFile(JavaParser::ResourceSpecification_DropletFileContext *ctx) = 0;
  virtual void exitResourceSpecification_DropletFile(JavaParser::ResourceSpecification_DropletFileContext *ctx) = 0;

  virtual void enterResourceList_DropletFile(JavaParser::ResourceList_DropletFileContext *ctx) = 0;
  virtual void exitResourceList_DropletFile(JavaParser::ResourceList_DropletFileContext *ctx) = 0;

  virtual void enterResource_DropletFile(JavaParser::Resource_DropletFileContext *ctx) = 0;
  virtual void exitResource_DropletFile(JavaParser::Resource_DropletFileContext *ctx) = 0;

  virtual void enterVariableAccess_DropletFile(JavaParser::VariableAccess_DropletFileContext *ctx) = 0;
  virtual void exitVariableAccess_DropletFile(JavaParser::VariableAccess_DropletFileContext *ctx) = 0;

  virtual void enterPrimary_DropletFile(JavaParser::Primary_DropletFileContext *ctx) = 0;
  virtual void exitPrimary_DropletFile(JavaParser::Primary_DropletFileContext *ctx) = 0;

  virtual void enterPrimaryNoNewArray_DropletFile(JavaParser::PrimaryNoNewArray_DropletFileContext *ctx) = 0;
  virtual void exitPrimaryNoNewArray_DropletFile(JavaParser::PrimaryNoNewArray_DropletFileContext *ctx) = 0;

  virtual void enterPrimaryNoNewArray_lf_arrayAccess_DropletFile(JavaParser::PrimaryNoNewArray_lf_arrayAccess_DropletFileContext *ctx) = 0;
  virtual void exitPrimaryNoNewArray_lf_arrayAccess_DropletFile(JavaParser::PrimaryNoNewArray_lf_arrayAccess_DropletFileContext *ctx) = 0;

  virtual void enterPrimaryNoNewArray_lfno_arrayAccess_DropletFile(JavaParser::PrimaryNoNewArray_lfno_arrayAccess_DropletFileContext *ctx) = 0;
  virtual void exitPrimaryNoNewArray_lfno_arrayAccess_DropletFile(JavaParser::PrimaryNoNewArray_lfno_arrayAccess_DropletFileContext *ctx) = 0;

  virtual void enterPrimaryNoNewArray_lf_primary_DropletFile(JavaParser::PrimaryNoNewArray_lf_primary_DropletFileContext *ctx) = 0;
  virtual void exitPrimaryNoNewArray_lf_primary_DropletFile(JavaParser::PrimaryNoNewArray_lf_primary_DropletFileContext *ctx) = 0;

  virtual void enterPrimaryNoNewArray_lf_primary_lf_arrayAccess_lf_primary_DropletFile(JavaParser::PrimaryNoNewArray_lf_primary_lf_arrayAccess_lf_primary_DropletFileContext *ctx) = 0;
  virtual void exitPrimaryNoNewArray_lf_primary_lf_arrayAccess_lf_primary_DropletFile(JavaParser::PrimaryNoNewArray_lf_primary_lf_arrayAccess_lf_primary_DropletFileContext *ctx) = 0;

  virtual void enterPrimaryNoNewArray_lf_primary_lfno_arrayAccess_lf_primary_DropletFile(JavaParser::PrimaryNoNewArray_lf_primary_lfno_arrayAccess_lf_primary_DropletFileContext *ctx) = 0;
  virtual void exitPrimaryNoNewArray_lf_primary_lfno_arrayAccess_lf_primary_DropletFile(JavaParser::PrimaryNoNewArray_lf_primary_lfno_arrayAccess_lf_primary_DropletFileContext *ctx) = 0;

  virtual void enterPrimaryNoNewArray_lfno_primary_DropletFile(JavaParser::PrimaryNoNewArray_lfno_primary_DropletFileContext *ctx) = 0;
  virtual void exitPrimaryNoNewArray_lfno_primary_DropletFile(JavaParser::PrimaryNoNewArray_lfno_primary_DropletFileContext *ctx) = 0;

  virtual void enterPrimaryNoNewArray_lfno_primary_lf_arrayAccess_lfno_primary_DropletFile(JavaParser::PrimaryNoNewArray_lfno_primary_lf_arrayAccess_lfno_primary_DropletFileContext *ctx) = 0;
  virtual void exitPrimaryNoNewArray_lfno_primary_lf_arrayAccess_lfno_primary_DropletFile(JavaParser::PrimaryNoNewArray_lfno_primary_lf_arrayAccess_lfno_primary_DropletFileContext *ctx) = 0;

  virtual void enterPrimaryNoNewArray_lfno_primary_lfno_arrayAccess_lfno_primary_DropletFile(JavaParser::PrimaryNoNewArray_lfno_primary_lfno_arrayAccess_lfno_primary_DropletFileContext *ctx) = 0;
  virtual void exitPrimaryNoNewArray_lfno_primary_lfno_arrayAccess_lfno_primary_DropletFile(JavaParser::PrimaryNoNewArray_lfno_primary_lfno_arrayAccess_lfno_primary_DropletFileContext *ctx) = 0;

  virtual void enterClassLiteral_DropletFile(JavaParser::ClassLiteral_DropletFileContext *ctx) = 0;
  virtual void exitClassLiteral_DropletFile(JavaParser::ClassLiteral_DropletFileContext *ctx) = 0;

  virtual void enterClassInstanceCreationExpression_DropletFile(JavaParser::ClassInstanceCreationExpression_DropletFileContext *ctx) = 0;
  virtual void exitClassInstanceCreationExpression_DropletFile(JavaParser::ClassInstanceCreationExpression_DropletFileContext *ctx) = 0;

  virtual void enterClassInstanceCreationExpression_lf_primary_DropletFile(JavaParser::ClassInstanceCreationExpression_lf_primary_DropletFileContext *ctx) = 0;
  virtual void exitClassInstanceCreationExpression_lf_primary_DropletFile(JavaParser::ClassInstanceCreationExpression_lf_primary_DropletFileContext *ctx) = 0;

  virtual void enterClassInstanceCreationExpression_lfno_primary_DropletFile(JavaParser::ClassInstanceCreationExpression_lfno_primary_DropletFileContext *ctx) = 0;
  virtual void exitClassInstanceCreationExpression_lfno_primary_DropletFile(JavaParser::ClassInstanceCreationExpression_lfno_primary_DropletFileContext *ctx) = 0;

  virtual void enterTypeArgumentsOrDiamond_DropletFile(JavaParser::TypeArgumentsOrDiamond_DropletFileContext *ctx) = 0;
  virtual void exitTypeArgumentsOrDiamond_DropletFile(JavaParser::TypeArgumentsOrDiamond_DropletFileContext *ctx) = 0;

  virtual void enterFieldAccess_DropletFile(JavaParser::FieldAccess_DropletFileContext *ctx) = 0;
  virtual void exitFieldAccess_DropletFile(JavaParser::FieldAccess_DropletFileContext *ctx) = 0;

  virtual void enterFieldAccess_lf_primary_DropletFile(JavaParser::FieldAccess_lf_primary_DropletFileContext *ctx) = 0;
  virtual void exitFieldAccess_lf_primary_DropletFile(JavaParser::FieldAccess_lf_primary_DropletFileContext *ctx) = 0;

  virtual void enterFieldAccess_lfno_primary_DropletFile(JavaParser::FieldAccess_lfno_primary_DropletFileContext *ctx) = 0;
  virtual void exitFieldAccess_lfno_primary_DropletFile(JavaParser::FieldAccess_lfno_primary_DropletFileContext *ctx) = 0;

  virtual void enterArrayAccess_DropletFile(JavaParser::ArrayAccess_DropletFileContext *ctx) = 0;
  virtual void exitArrayAccess_DropletFile(JavaParser::ArrayAccess_DropletFileContext *ctx) = 0;

  virtual void enterArrayAccess_lf_primary_DropletFile(JavaParser::ArrayAccess_lf_primary_DropletFileContext *ctx) = 0;
  virtual void exitArrayAccess_lf_primary_DropletFile(JavaParser::ArrayAccess_lf_primary_DropletFileContext *ctx) = 0;

  virtual void enterArrayAccess_lfno_primary_DropletFile(JavaParser::ArrayAccess_lfno_primary_DropletFileContext *ctx) = 0;
  virtual void exitArrayAccess_lfno_primary_DropletFile(JavaParser::ArrayAccess_lfno_primary_DropletFileContext *ctx) = 0;

  virtual void enterMethodInvocation_DropletFile(JavaParser::MethodInvocation_DropletFileContext *ctx) = 0;
  virtual void exitMethodInvocation_DropletFile(JavaParser::MethodInvocation_DropletFileContext *ctx) = 0;

  virtual void enterMethodInvocation_lf_primary_DropletFile(JavaParser::MethodInvocation_lf_primary_DropletFileContext *ctx) = 0;
  virtual void exitMethodInvocation_lf_primary_DropletFile(JavaParser::MethodInvocation_lf_primary_DropletFileContext *ctx) = 0;

  virtual void enterMethodInvocation_lfno_primary_DropletFile(JavaParser::MethodInvocation_lfno_primary_DropletFileContext *ctx) = 0;
  virtual void exitMethodInvocation_lfno_primary_DropletFile(JavaParser::MethodInvocation_lfno_primary_DropletFileContext *ctx) = 0;

  virtual void enterArgumentList_DropletFile(JavaParser::ArgumentList_DropletFileContext *ctx) = 0;
  virtual void exitArgumentList_DropletFile(JavaParser::ArgumentList_DropletFileContext *ctx) = 0;

  virtual void enterMethodReference_DropletFile(JavaParser::MethodReference_DropletFileContext *ctx) = 0;
  virtual void exitMethodReference_DropletFile(JavaParser::MethodReference_DropletFileContext *ctx) = 0;

  virtual void enterMethodReference_lf_primary_DropletFile(JavaParser::MethodReference_lf_primary_DropletFileContext *ctx) = 0;
  virtual void exitMethodReference_lf_primary_DropletFile(JavaParser::MethodReference_lf_primary_DropletFileContext *ctx) = 0;

  virtual void enterMethodReference_lfno_primary_DropletFile(JavaParser::MethodReference_lfno_primary_DropletFileContext *ctx) = 0;
  virtual void exitMethodReference_lfno_primary_DropletFile(JavaParser::MethodReference_lfno_primary_DropletFileContext *ctx) = 0;

  virtual void enterArrayCreationExpression_DropletFile(JavaParser::ArrayCreationExpression_DropletFileContext *ctx) = 0;
  virtual void exitArrayCreationExpression_DropletFile(JavaParser::ArrayCreationExpression_DropletFileContext *ctx) = 0;

  virtual void enterDimExprs_DropletFile(JavaParser::DimExprs_DropletFileContext *ctx) = 0;
  virtual void exitDimExprs_DropletFile(JavaParser::DimExprs_DropletFileContext *ctx) = 0;

  virtual void enterDimExpr_DropletFile(JavaParser::DimExpr_DropletFileContext *ctx) = 0;
  virtual void exitDimExpr_DropletFile(JavaParser::DimExpr_DropletFileContext *ctx) = 0;

  virtual void enterConstantExpression_DropletFile(JavaParser::ConstantExpression_DropletFileContext *ctx) = 0;
  virtual void exitConstantExpression_DropletFile(JavaParser::ConstantExpression_DropletFileContext *ctx) = 0;

  virtual void enterExpression_DropletFile(JavaParser::Expression_DropletFileContext *ctx) = 0;
  virtual void exitExpression_DropletFile(JavaParser::Expression_DropletFileContext *ctx) = 0;

  virtual void enterLambdaExpression_DropletFile(JavaParser::LambdaExpression_DropletFileContext *ctx) = 0;
  virtual void exitLambdaExpression_DropletFile(JavaParser::LambdaExpression_DropletFileContext *ctx) = 0;

  virtual void enterLambdaParameters_DropletFile(JavaParser::LambdaParameters_DropletFileContext *ctx) = 0;
  virtual void exitLambdaParameters_DropletFile(JavaParser::LambdaParameters_DropletFileContext *ctx) = 0;

  virtual void enterInferredFormalParameterList_DropletFile(JavaParser::InferredFormalParameterList_DropletFileContext *ctx) = 0;
  virtual void exitInferredFormalParameterList_DropletFile(JavaParser::InferredFormalParameterList_DropletFileContext *ctx) = 0;

  virtual void enterLambdaBody_DropletFile(JavaParser::LambdaBody_DropletFileContext *ctx) = 0;
  virtual void exitLambdaBody_DropletFile(JavaParser::LambdaBody_DropletFileContext *ctx) = 0;

  virtual void enterAssignmentExpression_DropletFile(JavaParser::AssignmentExpression_DropletFileContext *ctx) = 0;
  virtual void exitAssignmentExpression_DropletFile(JavaParser::AssignmentExpression_DropletFileContext *ctx) = 0;

  virtual void enterAssignment_DropletFile(JavaParser::Assignment_DropletFileContext *ctx) = 0;
  virtual void exitAssignment_DropletFile(JavaParser::Assignment_DropletFileContext *ctx) = 0;

  virtual void enterLeftHandSide_DropletFile(JavaParser::LeftHandSide_DropletFileContext *ctx) = 0;
  virtual void exitLeftHandSide_DropletFile(JavaParser::LeftHandSide_DropletFileContext *ctx) = 0;

  virtual void enterAssignmentOperator_DropletFile(JavaParser::AssignmentOperator_DropletFileContext *ctx) = 0;
  virtual void exitAssignmentOperator_DropletFile(JavaParser::AssignmentOperator_DropletFileContext *ctx) = 0;

  virtual void enterConditionalExpression_DropletFile(JavaParser::ConditionalExpression_DropletFileContext *ctx) = 0;
  virtual void exitConditionalExpression_DropletFile(JavaParser::ConditionalExpression_DropletFileContext *ctx) = 0;

  virtual void enterConditionalOrExpression_DropletFile(JavaParser::ConditionalOrExpression_DropletFileContext *ctx) = 0;
  virtual void exitConditionalOrExpression_DropletFile(JavaParser::ConditionalOrExpression_DropletFileContext *ctx) = 0;

  virtual void enterConditionalAndExpression_DropletFile(JavaParser::ConditionalAndExpression_DropletFileContext *ctx) = 0;
  virtual void exitConditionalAndExpression_DropletFile(JavaParser::ConditionalAndExpression_DropletFileContext *ctx) = 0;

  virtual void enterInclusiveOrExpression_DropletFile(JavaParser::InclusiveOrExpression_DropletFileContext *ctx) = 0;
  virtual void exitInclusiveOrExpression_DropletFile(JavaParser::InclusiveOrExpression_DropletFileContext *ctx) = 0;

  virtual void enterExclusiveOrExpression_DropletFile(JavaParser::ExclusiveOrExpression_DropletFileContext *ctx) = 0;
  virtual void exitExclusiveOrExpression_DropletFile(JavaParser::ExclusiveOrExpression_DropletFileContext *ctx) = 0;

  virtual void enterAndExpression_DropletFile(JavaParser::AndExpression_DropletFileContext *ctx) = 0;
  virtual void exitAndExpression_DropletFile(JavaParser::AndExpression_DropletFileContext *ctx) = 0;

  virtual void enterEqualityExpression_DropletFile(JavaParser::EqualityExpression_DropletFileContext *ctx) = 0;
  virtual void exitEqualityExpression_DropletFile(JavaParser::EqualityExpression_DropletFileContext *ctx) = 0;

  virtual void enterRelationalExpression_DropletFile(JavaParser::RelationalExpression_DropletFileContext *ctx) = 0;
  virtual void exitRelationalExpression_DropletFile(JavaParser::RelationalExpression_DropletFileContext *ctx) = 0;

  virtual void enterShiftExpression_DropletFile(JavaParser::ShiftExpression_DropletFileContext *ctx) = 0;
  virtual void exitShiftExpression_DropletFile(JavaParser::ShiftExpression_DropletFileContext *ctx) = 0;

  virtual void enterAdditiveExpression_DropletFile(JavaParser::AdditiveExpression_DropletFileContext *ctx) = 0;
  virtual void exitAdditiveExpression_DropletFile(JavaParser::AdditiveExpression_DropletFileContext *ctx) = 0;

  virtual void enterMultiplicativeExpression_DropletFile(JavaParser::MultiplicativeExpression_DropletFileContext *ctx) = 0;
  virtual void exitMultiplicativeExpression_DropletFile(JavaParser::MultiplicativeExpression_DropletFileContext *ctx) = 0;

  virtual void enterUnaryExpression_DropletFile(JavaParser::UnaryExpression_DropletFileContext *ctx) = 0;
  virtual void exitUnaryExpression_DropletFile(JavaParser::UnaryExpression_DropletFileContext *ctx) = 0;

  virtual void enterPreIncrementExpression_DropletFile(JavaParser::PreIncrementExpression_DropletFileContext *ctx) = 0;
  virtual void exitPreIncrementExpression_DropletFile(JavaParser::PreIncrementExpression_DropletFileContext *ctx) = 0;

  virtual void enterPreDecrementExpression_DropletFile(JavaParser::PreDecrementExpression_DropletFileContext *ctx) = 0;
  virtual void exitPreDecrementExpression_DropletFile(JavaParser::PreDecrementExpression_DropletFileContext *ctx) = 0;

  virtual void enterUnaryExpressionNotPlusMinus_DropletFile(JavaParser::UnaryExpressionNotPlusMinus_DropletFileContext *ctx) = 0;
  virtual void exitUnaryExpressionNotPlusMinus_DropletFile(JavaParser::UnaryExpressionNotPlusMinus_DropletFileContext *ctx) = 0;

  virtual void enterPostfixExpression_DropletFile(JavaParser::PostfixExpression_DropletFileContext *ctx) = 0;
  virtual void exitPostfixExpression_DropletFile(JavaParser::PostfixExpression_DropletFileContext *ctx) = 0;

  virtual void enterPostIncrementExpression_DropletFile(JavaParser::PostIncrementExpression_DropletFileContext *ctx) = 0;
  virtual void exitPostIncrementExpression_DropletFile(JavaParser::PostIncrementExpression_DropletFileContext *ctx) = 0;

  virtual void enterPostIncrementExpression_lf_postfixExpression_DropletFile(JavaParser::PostIncrementExpression_lf_postfixExpression_DropletFileContext *ctx) = 0;
  virtual void exitPostIncrementExpression_lf_postfixExpression_DropletFile(JavaParser::PostIncrementExpression_lf_postfixExpression_DropletFileContext *ctx) = 0;

  virtual void enterPostDecrementExpression_DropletFile(JavaParser::PostDecrementExpression_DropletFileContext *ctx) = 0;
  virtual void exitPostDecrementExpression_DropletFile(JavaParser::PostDecrementExpression_DropletFileContext *ctx) = 0;

  virtual void enterPostDecrementExpression_lf_postfixExpression_DropletFile(JavaParser::PostDecrementExpression_lf_postfixExpression_DropletFileContext *ctx) = 0;
  virtual void exitPostDecrementExpression_lf_postfixExpression_DropletFile(JavaParser::PostDecrementExpression_lf_postfixExpression_DropletFileContext *ctx) = 0;

  virtual void enterCastExpression_DropletFile(JavaParser::CastExpression_DropletFileContext *ctx) = 0;
  virtual void exitCastExpression_DropletFile(JavaParser::CastExpression_DropletFileContext *ctx) = 0;

  virtual void enterIdentifier(JavaParser::IdentifierContext *ctx) = 0;
  virtual void exitIdentifier(JavaParser::IdentifierContext *ctx) = 0;


};

