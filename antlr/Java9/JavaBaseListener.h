
// Generated from Java.g4 by ANTLR 4.7.1

#pragma once


#include "antlr4-runtime.h"
#include "JavaListener.h"


/**
 * This class provides an empty implementation of JavaListener,
 * which can be extended to create a listener which only needs to handle a subset
 * of the available methods.
 */
class  JavaBaseListener : public JavaListener {
public:

  virtual void enterLiteral(JavaParser::LiteralContext * /*ctx*/) override { }
  virtual void exitLiteral(JavaParser::LiteralContext * /*ctx*/) override { }

  virtual void enterPrimitiveType(JavaParser::PrimitiveTypeContext * /*ctx*/) override { }
  virtual void exitPrimitiveType(JavaParser::PrimitiveTypeContext * /*ctx*/) override { }

  virtual void enterNumericType(JavaParser::NumericTypeContext * /*ctx*/) override { }
  virtual void exitNumericType(JavaParser::NumericTypeContext * /*ctx*/) override { }

  virtual void enterIntegralType(JavaParser::IntegralTypeContext * /*ctx*/) override { }
  virtual void exitIntegralType(JavaParser::IntegralTypeContext * /*ctx*/) override { }

  virtual void enterFloatingPointType(JavaParser::FloatingPointTypeContext * /*ctx*/) override { }
  virtual void exitFloatingPointType(JavaParser::FloatingPointTypeContext * /*ctx*/) override { }

  virtual void enterReferenceType(JavaParser::ReferenceTypeContext * /*ctx*/) override { }
  virtual void exitReferenceType(JavaParser::ReferenceTypeContext * /*ctx*/) override { }

  virtual void enterClassOrInterfaceType(JavaParser::ClassOrInterfaceTypeContext * /*ctx*/) override { }
  virtual void exitClassOrInterfaceType(JavaParser::ClassOrInterfaceTypeContext * /*ctx*/) override { }

  virtual void enterClassType(JavaParser::ClassTypeContext * /*ctx*/) override { }
  virtual void exitClassType(JavaParser::ClassTypeContext * /*ctx*/) override { }

  virtual void enterClassType_lf_classOrInterfaceType(JavaParser::ClassType_lf_classOrInterfaceTypeContext * /*ctx*/) override { }
  virtual void exitClassType_lf_classOrInterfaceType(JavaParser::ClassType_lf_classOrInterfaceTypeContext * /*ctx*/) override { }

  virtual void enterClassType_lfno_classOrInterfaceType(JavaParser::ClassType_lfno_classOrInterfaceTypeContext * /*ctx*/) override { }
  virtual void exitClassType_lfno_classOrInterfaceType(JavaParser::ClassType_lfno_classOrInterfaceTypeContext * /*ctx*/) override { }

  virtual void enterInterfaceType(JavaParser::InterfaceTypeContext * /*ctx*/) override { }
  virtual void exitInterfaceType(JavaParser::InterfaceTypeContext * /*ctx*/) override { }

  virtual void enterInterfaceType_lf_classOrInterfaceType(JavaParser::InterfaceType_lf_classOrInterfaceTypeContext * /*ctx*/) override { }
  virtual void exitInterfaceType_lf_classOrInterfaceType(JavaParser::InterfaceType_lf_classOrInterfaceTypeContext * /*ctx*/) override { }

  virtual void enterInterfaceType_lfno_classOrInterfaceType(JavaParser::InterfaceType_lfno_classOrInterfaceTypeContext * /*ctx*/) override { }
  virtual void exitInterfaceType_lfno_classOrInterfaceType(JavaParser::InterfaceType_lfno_classOrInterfaceTypeContext * /*ctx*/) override { }

  virtual void enterTypeVariable(JavaParser::TypeVariableContext * /*ctx*/) override { }
  virtual void exitTypeVariable(JavaParser::TypeVariableContext * /*ctx*/) override { }

  virtual void enterArrayType(JavaParser::ArrayTypeContext * /*ctx*/) override { }
  virtual void exitArrayType(JavaParser::ArrayTypeContext * /*ctx*/) override { }

  virtual void enterDims(JavaParser::DimsContext * /*ctx*/) override { }
  virtual void exitDims(JavaParser::DimsContext * /*ctx*/) override { }

  virtual void enterTypeParameter(JavaParser::TypeParameterContext * /*ctx*/) override { }
  virtual void exitTypeParameter(JavaParser::TypeParameterContext * /*ctx*/) override { }

  virtual void enterTypeParameterModifier(JavaParser::TypeParameterModifierContext * /*ctx*/) override { }
  virtual void exitTypeParameterModifier(JavaParser::TypeParameterModifierContext * /*ctx*/) override { }

  virtual void enterTypeBound(JavaParser::TypeBoundContext * /*ctx*/) override { }
  virtual void exitTypeBound(JavaParser::TypeBoundContext * /*ctx*/) override { }

  virtual void enterAdditionalBound(JavaParser::AdditionalBoundContext * /*ctx*/) override { }
  virtual void exitAdditionalBound(JavaParser::AdditionalBoundContext * /*ctx*/) override { }

  virtual void enterTypeArguments(JavaParser::TypeArgumentsContext * /*ctx*/) override { }
  virtual void exitTypeArguments(JavaParser::TypeArgumentsContext * /*ctx*/) override { }

  virtual void enterTypeArgumentList(JavaParser::TypeArgumentListContext * /*ctx*/) override { }
  virtual void exitTypeArgumentList(JavaParser::TypeArgumentListContext * /*ctx*/) override { }

  virtual void enterTypeArgument(JavaParser::TypeArgumentContext * /*ctx*/) override { }
  virtual void exitTypeArgument(JavaParser::TypeArgumentContext * /*ctx*/) override { }

  virtual void enterWildcard(JavaParser::WildcardContext * /*ctx*/) override { }
  virtual void exitWildcard(JavaParser::WildcardContext * /*ctx*/) override { }

  virtual void enterWildcardBounds(JavaParser::WildcardBoundsContext * /*ctx*/) override { }
  virtual void exitWildcardBounds(JavaParser::WildcardBoundsContext * /*ctx*/) override { }

  virtual void enterModuleName(JavaParser::ModuleNameContext * /*ctx*/) override { }
  virtual void exitModuleName(JavaParser::ModuleNameContext * /*ctx*/) override { }

  virtual void enterPackageName(JavaParser::PackageNameContext * /*ctx*/) override { }
  virtual void exitPackageName(JavaParser::PackageNameContext * /*ctx*/) override { }

  virtual void enterTypeName(JavaParser::TypeNameContext * /*ctx*/) override { }
  virtual void exitTypeName(JavaParser::TypeNameContext * /*ctx*/) override { }

  virtual void enterPackageOrTypeName(JavaParser::PackageOrTypeNameContext * /*ctx*/) override { }
  virtual void exitPackageOrTypeName(JavaParser::PackageOrTypeNameContext * /*ctx*/) override { }

  virtual void enterExpressionName(JavaParser::ExpressionNameContext * /*ctx*/) override { }
  virtual void exitExpressionName(JavaParser::ExpressionNameContext * /*ctx*/) override { }

  virtual void enterMethodName(JavaParser::MethodNameContext * /*ctx*/) override { }
  virtual void exitMethodName(JavaParser::MethodNameContext * /*ctx*/) override { }

  virtual void enterAmbiguousName(JavaParser::AmbiguousNameContext * /*ctx*/) override { }
  virtual void exitAmbiguousName(JavaParser::AmbiguousNameContext * /*ctx*/) override { }

  virtual void enterCompilationUnit(JavaParser::CompilationUnitContext * /*ctx*/) override { }
  virtual void exitCompilationUnit(JavaParser::CompilationUnitContext * /*ctx*/) override { }

  virtual void enterOrdinaryCompilation(JavaParser::OrdinaryCompilationContext * /*ctx*/) override { }
  virtual void exitOrdinaryCompilation(JavaParser::OrdinaryCompilationContext * /*ctx*/) override { }

  virtual void enterModularCompilation(JavaParser::ModularCompilationContext * /*ctx*/) override { }
  virtual void exitModularCompilation(JavaParser::ModularCompilationContext * /*ctx*/) override { }

  virtual void enterPackageDeclaration(JavaParser::PackageDeclarationContext * /*ctx*/) override { }
  virtual void exitPackageDeclaration(JavaParser::PackageDeclarationContext * /*ctx*/) override { }

  virtual void enterPackageModifier(JavaParser::PackageModifierContext * /*ctx*/) override { }
  virtual void exitPackageModifier(JavaParser::PackageModifierContext * /*ctx*/) override { }

  virtual void enterImportDeclaration(JavaParser::ImportDeclarationContext * /*ctx*/) override { }
  virtual void exitImportDeclaration(JavaParser::ImportDeclarationContext * /*ctx*/) override { }

  virtual void enterSingleTypeImportDeclaration(JavaParser::SingleTypeImportDeclarationContext * /*ctx*/) override { }
  virtual void exitSingleTypeImportDeclaration(JavaParser::SingleTypeImportDeclarationContext * /*ctx*/) override { }

  virtual void enterTypeImportOnDemandDeclaration(JavaParser::TypeImportOnDemandDeclarationContext * /*ctx*/) override { }
  virtual void exitTypeImportOnDemandDeclaration(JavaParser::TypeImportOnDemandDeclarationContext * /*ctx*/) override { }

  virtual void enterSingleStaticImportDeclaration(JavaParser::SingleStaticImportDeclarationContext * /*ctx*/) override { }
  virtual void exitSingleStaticImportDeclaration(JavaParser::SingleStaticImportDeclarationContext * /*ctx*/) override { }

  virtual void enterStaticImportOnDemandDeclaration(JavaParser::StaticImportOnDemandDeclarationContext * /*ctx*/) override { }
  virtual void exitStaticImportOnDemandDeclaration(JavaParser::StaticImportOnDemandDeclarationContext * /*ctx*/) override { }

  virtual void enterTypeDeclaration(JavaParser::TypeDeclarationContext * /*ctx*/) override { }
  virtual void exitTypeDeclaration(JavaParser::TypeDeclarationContext * /*ctx*/) override { }

  virtual void enterModuleDeclaration(JavaParser::ModuleDeclarationContext * /*ctx*/) override { }
  virtual void exitModuleDeclaration(JavaParser::ModuleDeclarationContext * /*ctx*/) override { }

  virtual void enterModuleDirective(JavaParser::ModuleDirectiveContext * /*ctx*/) override { }
  virtual void exitModuleDirective(JavaParser::ModuleDirectiveContext * /*ctx*/) override { }

  virtual void enterRequiresModifier(JavaParser::RequiresModifierContext * /*ctx*/) override { }
  virtual void exitRequiresModifier(JavaParser::RequiresModifierContext * /*ctx*/) override { }

  virtual void enterClassDeclaration(JavaParser::ClassDeclarationContext * /*ctx*/) override { }
  virtual void exitClassDeclaration(JavaParser::ClassDeclarationContext * /*ctx*/) override { }

  virtual void enterNormalClassDeclaration(JavaParser::NormalClassDeclarationContext * /*ctx*/) override { }
  virtual void exitNormalClassDeclaration(JavaParser::NormalClassDeclarationContext * /*ctx*/) override { }

  virtual void enterClassModifier(JavaParser::ClassModifierContext * /*ctx*/) override { }
  virtual void exitClassModifier(JavaParser::ClassModifierContext * /*ctx*/) override { }

  virtual void enterTypeParameters(JavaParser::TypeParametersContext * /*ctx*/) override { }
  virtual void exitTypeParameters(JavaParser::TypeParametersContext * /*ctx*/) override { }

  virtual void enterTypeParameterList(JavaParser::TypeParameterListContext * /*ctx*/) override { }
  virtual void exitTypeParameterList(JavaParser::TypeParameterListContext * /*ctx*/) override { }

  virtual void enterSuperclass(JavaParser::SuperclassContext * /*ctx*/) override { }
  virtual void exitSuperclass(JavaParser::SuperclassContext * /*ctx*/) override { }

  virtual void enterSuperinterfaces(JavaParser::SuperinterfacesContext * /*ctx*/) override { }
  virtual void exitSuperinterfaces(JavaParser::SuperinterfacesContext * /*ctx*/) override { }

  virtual void enterInterfaceTypeList(JavaParser::InterfaceTypeListContext * /*ctx*/) override { }
  virtual void exitInterfaceTypeList(JavaParser::InterfaceTypeListContext * /*ctx*/) override { }

  virtual void enterClassBody(JavaParser::ClassBodyContext * /*ctx*/) override { }
  virtual void exitClassBody(JavaParser::ClassBodyContext * /*ctx*/) override { }

  virtual void enterClassBodyDeclaration(JavaParser::ClassBodyDeclarationContext * /*ctx*/) override { }
  virtual void exitClassBodyDeclaration(JavaParser::ClassBodyDeclarationContext * /*ctx*/) override { }

  virtual void enterClassMemberDeclaration(JavaParser::ClassMemberDeclarationContext * /*ctx*/) override { }
  virtual void exitClassMemberDeclaration(JavaParser::ClassMemberDeclarationContext * /*ctx*/) override { }

  virtual void enterFieldDeclaration(JavaParser::FieldDeclarationContext * /*ctx*/) override { }
  virtual void exitFieldDeclaration(JavaParser::FieldDeclarationContext * /*ctx*/) override { }

  virtual void enterFieldModifier(JavaParser::FieldModifierContext * /*ctx*/) override { }
  virtual void exitFieldModifier(JavaParser::FieldModifierContext * /*ctx*/) override { }

  virtual void enterVariableDeclaratorList(JavaParser::VariableDeclaratorListContext * /*ctx*/) override { }
  virtual void exitVariableDeclaratorList(JavaParser::VariableDeclaratorListContext * /*ctx*/) override { }

  virtual void enterVariableDeclarator(JavaParser::VariableDeclaratorContext * /*ctx*/) override { }
  virtual void exitVariableDeclarator(JavaParser::VariableDeclaratorContext * /*ctx*/) override { }

  virtual void enterVariableDeclaratorId(JavaParser::VariableDeclaratorIdContext * /*ctx*/) override { }
  virtual void exitVariableDeclaratorId(JavaParser::VariableDeclaratorIdContext * /*ctx*/) override { }

  virtual void enterVariableInitializer(JavaParser::VariableInitializerContext * /*ctx*/) override { }
  virtual void exitVariableInitializer(JavaParser::VariableInitializerContext * /*ctx*/) override { }

  virtual void enterUnannType(JavaParser::UnannTypeContext * /*ctx*/) override { }
  virtual void exitUnannType(JavaParser::UnannTypeContext * /*ctx*/) override { }

  virtual void enterUnannPrimitiveType(JavaParser::UnannPrimitiveTypeContext * /*ctx*/) override { }
  virtual void exitUnannPrimitiveType(JavaParser::UnannPrimitiveTypeContext * /*ctx*/) override { }

  virtual void enterUnannReferenceType(JavaParser::UnannReferenceTypeContext * /*ctx*/) override { }
  virtual void exitUnannReferenceType(JavaParser::UnannReferenceTypeContext * /*ctx*/) override { }

  virtual void enterUnannClassOrInterfaceType(JavaParser::UnannClassOrInterfaceTypeContext * /*ctx*/) override { }
  virtual void exitUnannClassOrInterfaceType(JavaParser::UnannClassOrInterfaceTypeContext * /*ctx*/) override { }

  virtual void enterUnannClassType(JavaParser::UnannClassTypeContext * /*ctx*/) override { }
  virtual void exitUnannClassType(JavaParser::UnannClassTypeContext * /*ctx*/) override { }

  virtual void enterUnannClassType_lf_unannClassOrInterfaceType(JavaParser::UnannClassType_lf_unannClassOrInterfaceTypeContext * /*ctx*/) override { }
  virtual void exitUnannClassType_lf_unannClassOrInterfaceType(JavaParser::UnannClassType_lf_unannClassOrInterfaceTypeContext * /*ctx*/) override { }

  virtual void enterUnannClassType_lfno_unannClassOrInterfaceType(JavaParser::UnannClassType_lfno_unannClassOrInterfaceTypeContext * /*ctx*/) override { }
  virtual void exitUnannClassType_lfno_unannClassOrInterfaceType(JavaParser::UnannClassType_lfno_unannClassOrInterfaceTypeContext * /*ctx*/) override { }

  virtual void enterUnannInterfaceType(JavaParser::UnannInterfaceTypeContext * /*ctx*/) override { }
  virtual void exitUnannInterfaceType(JavaParser::UnannInterfaceTypeContext * /*ctx*/) override { }

  virtual void enterUnannInterfaceType_lf_unannClassOrInterfaceType(JavaParser::UnannInterfaceType_lf_unannClassOrInterfaceTypeContext * /*ctx*/) override { }
  virtual void exitUnannInterfaceType_lf_unannClassOrInterfaceType(JavaParser::UnannInterfaceType_lf_unannClassOrInterfaceTypeContext * /*ctx*/) override { }

  virtual void enterUnannInterfaceType_lfno_unannClassOrInterfaceType(JavaParser::UnannInterfaceType_lfno_unannClassOrInterfaceTypeContext * /*ctx*/) override { }
  virtual void exitUnannInterfaceType_lfno_unannClassOrInterfaceType(JavaParser::UnannInterfaceType_lfno_unannClassOrInterfaceTypeContext * /*ctx*/) override { }

  virtual void enterUnannTypeVariable(JavaParser::UnannTypeVariableContext * /*ctx*/) override { }
  virtual void exitUnannTypeVariable(JavaParser::UnannTypeVariableContext * /*ctx*/) override { }

  virtual void enterUnannArrayType(JavaParser::UnannArrayTypeContext * /*ctx*/) override { }
  virtual void exitUnannArrayType(JavaParser::UnannArrayTypeContext * /*ctx*/) override { }

  virtual void enterMethodDeclaration(JavaParser::MethodDeclarationContext * /*ctx*/) override { }
  virtual void exitMethodDeclaration(JavaParser::MethodDeclarationContext * /*ctx*/) override { }

  virtual void enterMethodModifier(JavaParser::MethodModifierContext * /*ctx*/) override { }
  virtual void exitMethodModifier(JavaParser::MethodModifierContext * /*ctx*/) override { }

  virtual void enterMethodHeader(JavaParser::MethodHeaderContext * /*ctx*/) override { }
  virtual void exitMethodHeader(JavaParser::MethodHeaderContext * /*ctx*/) override { }

  virtual void enterResult(JavaParser::ResultContext * /*ctx*/) override { }
  virtual void exitResult(JavaParser::ResultContext * /*ctx*/) override { }

  virtual void enterMethodDeclarator(JavaParser::MethodDeclaratorContext * /*ctx*/) override { }
  virtual void exitMethodDeclarator(JavaParser::MethodDeclaratorContext * /*ctx*/) override { }

  virtual void enterFormalParameterList(JavaParser::FormalParameterListContext * /*ctx*/) override { }
  virtual void exitFormalParameterList(JavaParser::FormalParameterListContext * /*ctx*/) override { }

  virtual void enterFormalParameters(JavaParser::FormalParametersContext * /*ctx*/) override { }
  virtual void exitFormalParameters(JavaParser::FormalParametersContext * /*ctx*/) override { }

  virtual void enterFormalParameter(JavaParser::FormalParameterContext * /*ctx*/) override { }
  virtual void exitFormalParameter(JavaParser::FormalParameterContext * /*ctx*/) override { }

  virtual void enterVariableModifier(JavaParser::VariableModifierContext * /*ctx*/) override { }
  virtual void exitVariableModifier(JavaParser::VariableModifierContext * /*ctx*/) override { }

  virtual void enterLastFormalParameter(JavaParser::LastFormalParameterContext * /*ctx*/) override { }
  virtual void exitLastFormalParameter(JavaParser::LastFormalParameterContext * /*ctx*/) override { }

  virtual void enterReceiverParameter(JavaParser::ReceiverParameterContext * /*ctx*/) override { }
  virtual void exitReceiverParameter(JavaParser::ReceiverParameterContext * /*ctx*/) override { }

  virtual void enterThrows_(JavaParser::Throws_Context * /*ctx*/) override { }
  virtual void exitThrows_(JavaParser::Throws_Context * /*ctx*/) override { }

  virtual void enterExceptionTypeList(JavaParser::ExceptionTypeListContext * /*ctx*/) override { }
  virtual void exitExceptionTypeList(JavaParser::ExceptionTypeListContext * /*ctx*/) override { }

  virtual void enterExceptionType(JavaParser::ExceptionTypeContext * /*ctx*/) override { }
  virtual void exitExceptionType(JavaParser::ExceptionTypeContext * /*ctx*/) override { }

  virtual void enterMethodBody(JavaParser::MethodBodyContext * /*ctx*/) override { }
  virtual void exitMethodBody(JavaParser::MethodBodyContext * /*ctx*/) override { }

  virtual void enterInstanceInitializer(JavaParser::InstanceInitializerContext * /*ctx*/) override { }
  virtual void exitInstanceInitializer(JavaParser::InstanceInitializerContext * /*ctx*/) override { }

  virtual void enterStaticInitializer(JavaParser::StaticInitializerContext * /*ctx*/) override { }
  virtual void exitStaticInitializer(JavaParser::StaticInitializerContext * /*ctx*/) override { }

  virtual void enterConstructorDeclaration(JavaParser::ConstructorDeclarationContext * /*ctx*/) override { }
  virtual void exitConstructorDeclaration(JavaParser::ConstructorDeclarationContext * /*ctx*/) override { }

  virtual void enterConstructorModifier(JavaParser::ConstructorModifierContext * /*ctx*/) override { }
  virtual void exitConstructorModifier(JavaParser::ConstructorModifierContext * /*ctx*/) override { }

  virtual void enterConstructorDeclarator(JavaParser::ConstructorDeclaratorContext * /*ctx*/) override { }
  virtual void exitConstructorDeclarator(JavaParser::ConstructorDeclaratorContext * /*ctx*/) override { }

  virtual void enterSimpleTypeName(JavaParser::SimpleTypeNameContext * /*ctx*/) override { }
  virtual void exitSimpleTypeName(JavaParser::SimpleTypeNameContext * /*ctx*/) override { }

  virtual void enterConstructorBody(JavaParser::ConstructorBodyContext * /*ctx*/) override { }
  virtual void exitConstructorBody(JavaParser::ConstructorBodyContext * /*ctx*/) override { }

  virtual void enterExplicitConstructorInvocation(JavaParser::ExplicitConstructorInvocationContext * /*ctx*/) override { }
  virtual void exitExplicitConstructorInvocation(JavaParser::ExplicitConstructorInvocationContext * /*ctx*/) override { }

  virtual void enterEnumDeclaration(JavaParser::EnumDeclarationContext * /*ctx*/) override { }
  virtual void exitEnumDeclaration(JavaParser::EnumDeclarationContext * /*ctx*/) override { }

  virtual void enterEnumBody(JavaParser::EnumBodyContext * /*ctx*/) override { }
  virtual void exitEnumBody(JavaParser::EnumBodyContext * /*ctx*/) override { }

  virtual void enterEnumConstantList(JavaParser::EnumConstantListContext * /*ctx*/) override { }
  virtual void exitEnumConstantList(JavaParser::EnumConstantListContext * /*ctx*/) override { }

  virtual void enterEnumConstant(JavaParser::EnumConstantContext * /*ctx*/) override { }
  virtual void exitEnumConstant(JavaParser::EnumConstantContext * /*ctx*/) override { }

  virtual void enterEnumConstantModifier(JavaParser::EnumConstantModifierContext * /*ctx*/) override { }
  virtual void exitEnumConstantModifier(JavaParser::EnumConstantModifierContext * /*ctx*/) override { }

  virtual void enterEnumBodyDeclarations(JavaParser::EnumBodyDeclarationsContext * /*ctx*/) override { }
  virtual void exitEnumBodyDeclarations(JavaParser::EnumBodyDeclarationsContext * /*ctx*/) override { }

  virtual void enterInterfaceDeclaration(JavaParser::InterfaceDeclarationContext * /*ctx*/) override { }
  virtual void exitInterfaceDeclaration(JavaParser::InterfaceDeclarationContext * /*ctx*/) override { }

  virtual void enterNormalInterfaceDeclaration(JavaParser::NormalInterfaceDeclarationContext * /*ctx*/) override { }
  virtual void exitNormalInterfaceDeclaration(JavaParser::NormalInterfaceDeclarationContext * /*ctx*/) override { }

  virtual void enterInterfaceModifier(JavaParser::InterfaceModifierContext * /*ctx*/) override { }
  virtual void exitInterfaceModifier(JavaParser::InterfaceModifierContext * /*ctx*/) override { }

  virtual void enterExtendsInterfaces(JavaParser::ExtendsInterfacesContext * /*ctx*/) override { }
  virtual void exitExtendsInterfaces(JavaParser::ExtendsInterfacesContext * /*ctx*/) override { }

  virtual void enterInterfaceBody(JavaParser::InterfaceBodyContext * /*ctx*/) override { }
  virtual void exitInterfaceBody(JavaParser::InterfaceBodyContext * /*ctx*/) override { }

  virtual void enterInterfaceMemberDeclaration(JavaParser::InterfaceMemberDeclarationContext * /*ctx*/) override { }
  virtual void exitInterfaceMemberDeclaration(JavaParser::InterfaceMemberDeclarationContext * /*ctx*/) override { }

  virtual void enterConstantDeclaration(JavaParser::ConstantDeclarationContext * /*ctx*/) override { }
  virtual void exitConstantDeclaration(JavaParser::ConstantDeclarationContext * /*ctx*/) override { }

  virtual void enterConstantModifier(JavaParser::ConstantModifierContext * /*ctx*/) override { }
  virtual void exitConstantModifier(JavaParser::ConstantModifierContext * /*ctx*/) override { }

  virtual void enterInterfaceMethodDeclaration(JavaParser::InterfaceMethodDeclarationContext * /*ctx*/) override { }
  virtual void exitInterfaceMethodDeclaration(JavaParser::InterfaceMethodDeclarationContext * /*ctx*/) override { }

  virtual void enterInterfaceMethodModifier(JavaParser::InterfaceMethodModifierContext * /*ctx*/) override { }
  virtual void exitInterfaceMethodModifier(JavaParser::InterfaceMethodModifierContext * /*ctx*/) override { }

  virtual void enterAnnotationTypeDeclaration(JavaParser::AnnotationTypeDeclarationContext * /*ctx*/) override { }
  virtual void exitAnnotationTypeDeclaration(JavaParser::AnnotationTypeDeclarationContext * /*ctx*/) override { }

  virtual void enterAnnotationTypeBody(JavaParser::AnnotationTypeBodyContext * /*ctx*/) override { }
  virtual void exitAnnotationTypeBody(JavaParser::AnnotationTypeBodyContext * /*ctx*/) override { }

  virtual void enterAnnotationTypeMemberDeclaration(JavaParser::AnnotationTypeMemberDeclarationContext * /*ctx*/) override { }
  virtual void exitAnnotationTypeMemberDeclaration(JavaParser::AnnotationTypeMemberDeclarationContext * /*ctx*/) override { }

  virtual void enterAnnotationTypeElementDeclaration(JavaParser::AnnotationTypeElementDeclarationContext * /*ctx*/) override { }
  virtual void exitAnnotationTypeElementDeclaration(JavaParser::AnnotationTypeElementDeclarationContext * /*ctx*/) override { }

  virtual void enterAnnotationTypeElementModifier(JavaParser::AnnotationTypeElementModifierContext * /*ctx*/) override { }
  virtual void exitAnnotationTypeElementModifier(JavaParser::AnnotationTypeElementModifierContext * /*ctx*/) override { }

  virtual void enterDefaultValue(JavaParser::DefaultValueContext * /*ctx*/) override { }
  virtual void exitDefaultValue(JavaParser::DefaultValueContext * /*ctx*/) override { }

  virtual void enterAnnotation(JavaParser::AnnotationContext * /*ctx*/) override { }
  virtual void exitAnnotation(JavaParser::AnnotationContext * /*ctx*/) override { }

  virtual void enterNormalAnnotation(JavaParser::NormalAnnotationContext * /*ctx*/) override { }
  virtual void exitNormalAnnotation(JavaParser::NormalAnnotationContext * /*ctx*/) override { }

  virtual void enterElementValuePairList(JavaParser::ElementValuePairListContext * /*ctx*/) override { }
  virtual void exitElementValuePairList(JavaParser::ElementValuePairListContext * /*ctx*/) override { }

  virtual void enterElementValuePair(JavaParser::ElementValuePairContext * /*ctx*/) override { }
  virtual void exitElementValuePair(JavaParser::ElementValuePairContext * /*ctx*/) override { }

  virtual void enterElementValue(JavaParser::ElementValueContext * /*ctx*/) override { }
  virtual void exitElementValue(JavaParser::ElementValueContext * /*ctx*/) override { }

  virtual void enterElementValueArrayInitializer(JavaParser::ElementValueArrayInitializerContext * /*ctx*/) override { }
  virtual void exitElementValueArrayInitializer(JavaParser::ElementValueArrayInitializerContext * /*ctx*/) override { }

  virtual void enterElementValueList(JavaParser::ElementValueListContext * /*ctx*/) override { }
  virtual void exitElementValueList(JavaParser::ElementValueListContext * /*ctx*/) override { }

  virtual void enterMarkerAnnotation(JavaParser::MarkerAnnotationContext * /*ctx*/) override { }
  virtual void exitMarkerAnnotation(JavaParser::MarkerAnnotationContext * /*ctx*/) override { }

  virtual void enterSingleElementAnnotation(JavaParser::SingleElementAnnotationContext * /*ctx*/) override { }
  virtual void exitSingleElementAnnotation(JavaParser::SingleElementAnnotationContext * /*ctx*/) override { }

  virtual void enterArrayInitializer(JavaParser::ArrayInitializerContext * /*ctx*/) override { }
  virtual void exitArrayInitializer(JavaParser::ArrayInitializerContext * /*ctx*/) override { }

  virtual void enterVariableInitializerList(JavaParser::VariableInitializerListContext * /*ctx*/) override { }
  virtual void exitVariableInitializerList(JavaParser::VariableInitializerListContext * /*ctx*/) override { }

  virtual void enterBlock(JavaParser::BlockContext * /*ctx*/) override { }
  virtual void exitBlock(JavaParser::BlockContext * /*ctx*/) override { }

  virtual void enterBlockStatements(JavaParser::BlockStatementsContext * /*ctx*/) override { }
  virtual void exitBlockStatements(JavaParser::BlockStatementsContext * /*ctx*/) override { }

  virtual void enterBlockStatement(JavaParser::BlockStatementContext * /*ctx*/) override { }
  virtual void exitBlockStatement(JavaParser::BlockStatementContext * /*ctx*/) override { }

  virtual void enterLocalVariableDeclarationStatement(JavaParser::LocalVariableDeclarationStatementContext * /*ctx*/) override { }
  virtual void exitLocalVariableDeclarationStatement(JavaParser::LocalVariableDeclarationStatementContext * /*ctx*/) override { }

  virtual void enterLocalVariableDeclaration(JavaParser::LocalVariableDeclarationContext * /*ctx*/) override { }
  virtual void exitLocalVariableDeclaration(JavaParser::LocalVariableDeclarationContext * /*ctx*/) override { }

  virtual void enterStatement(JavaParser::StatementContext * /*ctx*/) override { }
  virtual void exitStatement(JavaParser::StatementContext * /*ctx*/) override { }

  virtual void enterStatementNoShortIf(JavaParser::StatementNoShortIfContext * /*ctx*/) override { }
  virtual void exitStatementNoShortIf(JavaParser::StatementNoShortIfContext * /*ctx*/) override { }

  virtual void enterStatementWithoutTrailingSubstatement(JavaParser::StatementWithoutTrailingSubstatementContext * /*ctx*/) override { }
  virtual void exitStatementWithoutTrailingSubstatement(JavaParser::StatementWithoutTrailingSubstatementContext * /*ctx*/) override { }

  virtual void enterEmptyStatement(JavaParser::EmptyStatementContext * /*ctx*/) override { }
  virtual void exitEmptyStatement(JavaParser::EmptyStatementContext * /*ctx*/) override { }

  virtual void enterLabeledStatement(JavaParser::LabeledStatementContext * /*ctx*/) override { }
  virtual void exitLabeledStatement(JavaParser::LabeledStatementContext * /*ctx*/) override { }

  virtual void enterLabeledStatementNoShortIf(JavaParser::LabeledStatementNoShortIfContext * /*ctx*/) override { }
  virtual void exitLabeledStatementNoShortIf(JavaParser::LabeledStatementNoShortIfContext * /*ctx*/) override { }

  virtual void enterExpressionStatement(JavaParser::ExpressionStatementContext * /*ctx*/) override { }
  virtual void exitExpressionStatement(JavaParser::ExpressionStatementContext * /*ctx*/) override { }

  virtual void enterStatementExpression(JavaParser::StatementExpressionContext * /*ctx*/) override { }
  virtual void exitStatementExpression(JavaParser::StatementExpressionContext * /*ctx*/) override { }

  virtual void enterIfThenStatement(JavaParser::IfThenStatementContext * /*ctx*/) override { }
  virtual void exitIfThenStatement(JavaParser::IfThenStatementContext * /*ctx*/) override { }

  virtual void enterIfThenElseStatement(JavaParser::IfThenElseStatementContext * /*ctx*/) override { }
  virtual void exitIfThenElseStatement(JavaParser::IfThenElseStatementContext * /*ctx*/) override { }

  virtual void enterIfThenElseStatementNoShortIf(JavaParser::IfThenElseStatementNoShortIfContext * /*ctx*/) override { }
  virtual void exitIfThenElseStatementNoShortIf(JavaParser::IfThenElseStatementNoShortIfContext * /*ctx*/) override { }

  virtual void enterAssertStatement(JavaParser::AssertStatementContext * /*ctx*/) override { }
  virtual void exitAssertStatement(JavaParser::AssertStatementContext * /*ctx*/) override { }

  virtual void enterSwitchStatement(JavaParser::SwitchStatementContext * /*ctx*/) override { }
  virtual void exitSwitchStatement(JavaParser::SwitchStatementContext * /*ctx*/) override { }

  virtual void enterSwitchBlock(JavaParser::SwitchBlockContext * /*ctx*/) override { }
  virtual void exitSwitchBlock(JavaParser::SwitchBlockContext * /*ctx*/) override { }

  virtual void enterSwitchBlockStatementGroup(JavaParser::SwitchBlockStatementGroupContext * /*ctx*/) override { }
  virtual void exitSwitchBlockStatementGroup(JavaParser::SwitchBlockStatementGroupContext * /*ctx*/) override { }

  virtual void enterSwitchLabels(JavaParser::SwitchLabelsContext * /*ctx*/) override { }
  virtual void exitSwitchLabels(JavaParser::SwitchLabelsContext * /*ctx*/) override { }

  virtual void enterSwitchLabel(JavaParser::SwitchLabelContext * /*ctx*/) override { }
  virtual void exitSwitchLabel(JavaParser::SwitchLabelContext * /*ctx*/) override { }

  virtual void enterEnumConstantName(JavaParser::EnumConstantNameContext * /*ctx*/) override { }
  virtual void exitEnumConstantName(JavaParser::EnumConstantNameContext * /*ctx*/) override { }

  virtual void enterWhileStatement(JavaParser::WhileStatementContext * /*ctx*/) override { }
  virtual void exitWhileStatement(JavaParser::WhileStatementContext * /*ctx*/) override { }

  virtual void enterWhileStatementNoShortIf(JavaParser::WhileStatementNoShortIfContext * /*ctx*/) override { }
  virtual void exitWhileStatementNoShortIf(JavaParser::WhileStatementNoShortIfContext * /*ctx*/) override { }

  virtual void enterDoStatement(JavaParser::DoStatementContext * /*ctx*/) override { }
  virtual void exitDoStatement(JavaParser::DoStatementContext * /*ctx*/) override { }

  virtual void enterForStatement(JavaParser::ForStatementContext * /*ctx*/) override { }
  virtual void exitForStatement(JavaParser::ForStatementContext * /*ctx*/) override { }

  virtual void enterForStatementNoShortIf(JavaParser::ForStatementNoShortIfContext * /*ctx*/) override { }
  virtual void exitForStatementNoShortIf(JavaParser::ForStatementNoShortIfContext * /*ctx*/) override { }

  virtual void enterBasicForStatement(JavaParser::BasicForStatementContext * /*ctx*/) override { }
  virtual void exitBasicForStatement(JavaParser::BasicForStatementContext * /*ctx*/) override { }

  virtual void enterBasicForStatementNoShortIf(JavaParser::BasicForStatementNoShortIfContext * /*ctx*/) override { }
  virtual void exitBasicForStatementNoShortIf(JavaParser::BasicForStatementNoShortIfContext * /*ctx*/) override { }

  virtual void enterForInit(JavaParser::ForInitContext * /*ctx*/) override { }
  virtual void exitForInit(JavaParser::ForInitContext * /*ctx*/) override { }

  virtual void enterForUpdate(JavaParser::ForUpdateContext * /*ctx*/) override { }
  virtual void exitForUpdate(JavaParser::ForUpdateContext * /*ctx*/) override { }

  virtual void enterStatementExpressionList(JavaParser::StatementExpressionListContext * /*ctx*/) override { }
  virtual void exitStatementExpressionList(JavaParser::StatementExpressionListContext * /*ctx*/) override { }

  virtual void enterEnhancedForStatement(JavaParser::EnhancedForStatementContext * /*ctx*/) override { }
  virtual void exitEnhancedForStatement(JavaParser::EnhancedForStatementContext * /*ctx*/) override { }

  virtual void enterEnhancedForStatementNoShortIf(JavaParser::EnhancedForStatementNoShortIfContext * /*ctx*/) override { }
  virtual void exitEnhancedForStatementNoShortIf(JavaParser::EnhancedForStatementNoShortIfContext * /*ctx*/) override { }

  virtual void enterBreakStatement(JavaParser::BreakStatementContext * /*ctx*/) override { }
  virtual void exitBreakStatement(JavaParser::BreakStatementContext * /*ctx*/) override { }

  virtual void enterContinueStatement(JavaParser::ContinueStatementContext * /*ctx*/) override { }
  virtual void exitContinueStatement(JavaParser::ContinueStatementContext * /*ctx*/) override { }

  virtual void enterReturnStatement(JavaParser::ReturnStatementContext * /*ctx*/) override { }
  virtual void exitReturnStatement(JavaParser::ReturnStatementContext * /*ctx*/) override { }

  virtual void enterThrowStatement(JavaParser::ThrowStatementContext * /*ctx*/) override { }
  virtual void exitThrowStatement(JavaParser::ThrowStatementContext * /*ctx*/) override { }

  virtual void enterSynchronizedStatement(JavaParser::SynchronizedStatementContext * /*ctx*/) override { }
  virtual void exitSynchronizedStatement(JavaParser::SynchronizedStatementContext * /*ctx*/) override { }

  virtual void enterTryStatement(JavaParser::TryStatementContext * /*ctx*/) override { }
  virtual void exitTryStatement(JavaParser::TryStatementContext * /*ctx*/) override { }

  virtual void enterCatches(JavaParser::CatchesContext * /*ctx*/) override { }
  virtual void exitCatches(JavaParser::CatchesContext * /*ctx*/) override { }

  virtual void enterCatchClause(JavaParser::CatchClauseContext * /*ctx*/) override { }
  virtual void exitCatchClause(JavaParser::CatchClauseContext * /*ctx*/) override { }

  virtual void enterCatchFormalParameter(JavaParser::CatchFormalParameterContext * /*ctx*/) override { }
  virtual void exitCatchFormalParameter(JavaParser::CatchFormalParameterContext * /*ctx*/) override { }

  virtual void enterCatchType(JavaParser::CatchTypeContext * /*ctx*/) override { }
  virtual void exitCatchType(JavaParser::CatchTypeContext * /*ctx*/) override { }

  virtual void enterFinally_(JavaParser::Finally_Context * /*ctx*/) override { }
  virtual void exitFinally_(JavaParser::Finally_Context * /*ctx*/) override { }

  virtual void enterTryWithResourcesStatement(JavaParser::TryWithResourcesStatementContext * /*ctx*/) override { }
  virtual void exitTryWithResourcesStatement(JavaParser::TryWithResourcesStatementContext * /*ctx*/) override { }

  virtual void enterResourceSpecification(JavaParser::ResourceSpecificationContext * /*ctx*/) override { }
  virtual void exitResourceSpecification(JavaParser::ResourceSpecificationContext * /*ctx*/) override { }

  virtual void enterResourceList(JavaParser::ResourceListContext * /*ctx*/) override { }
  virtual void exitResourceList(JavaParser::ResourceListContext * /*ctx*/) override { }

  virtual void enterResource(JavaParser::ResourceContext * /*ctx*/) override { }
  virtual void exitResource(JavaParser::ResourceContext * /*ctx*/) override { }

  virtual void enterVariableAccess(JavaParser::VariableAccessContext * /*ctx*/) override { }
  virtual void exitVariableAccess(JavaParser::VariableAccessContext * /*ctx*/) override { }

  virtual void enterPrimary(JavaParser::PrimaryContext * /*ctx*/) override { }
  virtual void exitPrimary(JavaParser::PrimaryContext * /*ctx*/) override { }

  virtual void enterPrimaryNoNewArray(JavaParser::PrimaryNoNewArrayContext * /*ctx*/) override { }
  virtual void exitPrimaryNoNewArray(JavaParser::PrimaryNoNewArrayContext * /*ctx*/) override { }

  virtual void enterPrimaryNoNewArray_lf_arrayAccess(JavaParser::PrimaryNoNewArray_lf_arrayAccessContext * /*ctx*/) override { }
  virtual void exitPrimaryNoNewArray_lf_arrayAccess(JavaParser::PrimaryNoNewArray_lf_arrayAccessContext * /*ctx*/) override { }

  virtual void enterPrimaryNoNewArray_lfno_arrayAccess(JavaParser::PrimaryNoNewArray_lfno_arrayAccessContext * /*ctx*/) override { }
  virtual void exitPrimaryNoNewArray_lfno_arrayAccess(JavaParser::PrimaryNoNewArray_lfno_arrayAccessContext * /*ctx*/) override { }

  virtual void enterPrimaryNoNewArray_lf_primary(JavaParser::PrimaryNoNewArray_lf_primaryContext * /*ctx*/) override { }
  virtual void exitPrimaryNoNewArray_lf_primary(JavaParser::PrimaryNoNewArray_lf_primaryContext * /*ctx*/) override { }

  virtual void enterPrimaryNoNewArray_lf_primary_lf_arrayAccess_lf_primary(JavaParser::PrimaryNoNewArray_lf_primary_lf_arrayAccess_lf_primaryContext * /*ctx*/) override { }
  virtual void exitPrimaryNoNewArray_lf_primary_lf_arrayAccess_lf_primary(JavaParser::PrimaryNoNewArray_lf_primary_lf_arrayAccess_lf_primaryContext * /*ctx*/) override { }

  virtual void enterPrimaryNoNewArray_lf_primary_lfno_arrayAccess_lf_primary(JavaParser::PrimaryNoNewArray_lf_primary_lfno_arrayAccess_lf_primaryContext * /*ctx*/) override { }
  virtual void exitPrimaryNoNewArray_lf_primary_lfno_arrayAccess_lf_primary(JavaParser::PrimaryNoNewArray_lf_primary_lfno_arrayAccess_lf_primaryContext * /*ctx*/) override { }

  virtual void enterPrimaryNoNewArray_lfno_primary(JavaParser::PrimaryNoNewArray_lfno_primaryContext * /*ctx*/) override { }
  virtual void exitPrimaryNoNewArray_lfno_primary(JavaParser::PrimaryNoNewArray_lfno_primaryContext * /*ctx*/) override { }

  virtual void enterPrimaryNoNewArray_lfno_primary_lf_arrayAccess_lfno_primary(JavaParser::PrimaryNoNewArray_lfno_primary_lf_arrayAccess_lfno_primaryContext * /*ctx*/) override { }
  virtual void exitPrimaryNoNewArray_lfno_primary_lf_arrayAccess_lfno_primary(JavaParser::PrimaryNoNewArray_lfno_primary_lf_arrayAccess_lfno_primaryContext * /*ctx*/) override { }

  virtual void enterPrimaryNoNewArray_lfno_primary_lfno_arrayAccess_lfno_primary(JavaParser::PrimaryNoNewArray_lfno_primary_lfno_arrayAccess_lfno_primaryContext * /*ctx*/) override { }
  virtual void exitPrimaryNoNewArray_lfno_primary_lfno_arrayAccess_lfno_primary(JavaParser::PrimaryNoNewArray_lfno_primary_lfno_arrayAccess_lfno_primaryContext * /*ctx*/) override { }

  virtual void enterClassLiteral(JavaParser::ClassLiteralContext * /*ctx*/) override { }
  virtual void exitClassLiteral(JavaParser::ClassLiteralContext * /*ctx*/) override { }

  virtual void enterClassInstanceCreationExpression(JavaParser::ClassInstanceCreationExpressionContext * /*ctx*/) override { }
  virtual void exitClassInstanceCreationExpression(JavaParser::ClassInstanceCreationExpressionContext * /*ctx*/) override { }

  virtual void enterClassInstanceCreationExpression_lf_primary(JavaParser::ClassInstanceCreationExpression_lf_primaryContext * /*ctx*/) override { }
  virtual void exitClassInstanceCreationExpression_lf_primary(JavaParser::ClassInstanceCreationExpression_lf_primaryContext * /*ctx*/) override { }

  virtual void enterClassInstanceCreationExpression_lfno_primary(JavaParser::ClassInstanceCreationExpression_lfno_primaryContext * /*ctx*/) override { }
  virtual void exitClassInstanceCreationExpression_lfno_primary(JavaParser::ClassInstanceCreationExpression_lfno_primaryContext * /*ctx*/) override { }

  virtual void enterTypeArgumentsOrDiamond(JavaParser::TypeArgumentsOrDiamondContext * /*ctx*/) override { }
  virtual void exitTypeArgumentsOrDiamond(JavaParser::TypeArgumentsOrDiamondContext * /*ctx*/) override { }

  virtual void enterFieldAccess(JavaParser::FieldAccessContext * /*ctx*/) override { }
  virtual void exitFieldAccess(JavaParser::FieldAccessContext * /*ctx*/) override { }

  virtual void enterFieldAccess_lf_primary(JavaParser::FieldAccess_lf_primaryContext * /*ctx*/) override { }
  virtual void exitFieldAccess_lf_primary(JavaParser::FieldAccess_lf_primaryContext * /*ctx*/) override { }

  virtual void enterFieldAccess_lfno_primary(JavaParser::FieldAccess_lfno_primaryContext * /*ctx*/) override { }
  virtual void exitFieldAccess_lfno_primary(JavaParser::FieldAccess_lfno_primaryContext * /*ctx*/) override { }

  virtual void enterArrayAccess(JavaParser::ArrayAccessContext * /*ctx*/) override { }
  virtual void exitArrayAccess(JavaParser::ArrayAccessContext * /*ctx*/) override { }

  virtual void enterArrayAccess_lf_primary(JavaParser::ArrayAccess_lf_primaryContext * /*ctx*/) override { }
  virtual void exitArrayAccess_lf_primary(JavaParser::ArrayAccess_lf_primaryContext * /*ctx*/) override { }

  virtual void enterArrayAccess_lfno_primary(JavaParser::ArrayAccess_lfno_primaryContext * /*ctx*/) override { }
  virtual void exitArrayAccess_lfno_primary(JavaParser::ArrayAccess_lfno_primaryContext * /*ctx*/) override { }

  virtual void enterMethodInvocation(JavaParser::MethodInvocationContext * /*ctx*/) override { }
  virtual void exitMethodInvocation(JavaParser::MethodInvocationContext * /*ctx*/) override { }

  virtual void enterMethodInvocation_lf_primary(JavaParser::MethodInvocation_lf_primaryContext * /*ctx*/) override { }
  virtual void exitMethodInvocation_lf_primary(JavaParser::MethodInvocation_lf_primaryContext * /*ctx*/) override { }

  virtual void enterMethodInvocation_lfno_primary(JavaParser::MethodInvocation_lfno_primaryContext * /*ctx*/) override { }
  virtual void exitMethodInvocation_lfno_primary(JavaParser::MethodInvocation_lfno_primaryContext * /*ctx*/) override { }

  virtual void enterArgumentList(JavaParser::ArgumentListContext * /*ctx*/) override { }
  virtual void exitArgumentList(JavaParser::ArgumentListContext * /*ctx*/) override { }

  virtual void enterMethodReference(JavaParser::MethodReferenceContext * /*ctx*/) override { }
  virtual void exitMethodReference(JavaParser::MethodReferenceContext * /*ctx*/) override { }

  virtual void enterMethodReference_lf_primary(JavaParser::MethodReference_lf_primaryContext * /*ctx*/) override { }
  virtual void exitMethodReference_lf_primary(JavaParser::MethodReference_lf_primaryContext * /*ctx*/) override { }

  virtual void enterMethodReference_lfno_primary(JavaParser::MethodReference_lfno_primaryContext * /*ctx*/) override { }
  virtual void exitMethodReference_lfno_primary(JavaParser::MethodReference_lfno_primaryContext * /*ctx*/) override { }

  virtual void enterArrayCreationExpression(JavaParser::ArrayCreationExpressionContext * /*ctx*/) override { }
  virtual void exitArrayCreationExpression(JavaParser::ArrayCreationExpressionContext * /*ctx*/) override { }

  virtual void enterDimExprs(JavaParser::DimExprsContext * /*ctx*/) override { }
  virtual void exitDimExprs(JavaParser::DimExprsContext * /*ctx*/) override { }

  virtual void enterDimExpr(JavaParser::DimExprContext * /*ctx*/) override { }
  virtual void exitDimExpr(JavaParser::DimExprContext * /*ctx*/) override { }

  virtual void enterConstantExpression(JavaParser::ConstantExpressionContext * /*ctx*/) override { }
  virtual void exitConstantExpression(JavaParser::ConstantExpressionContext * /*ctx*/) override { }

  virtual void enterExpression(JavaParser::ExpressionContext * /*ctx*/) override { }
  virtual void exitExpression(JavaParser::ExpressionContext * /*ctx*/) override { }

  virtual void enterLambdaExpression(JavaParser::LambdaExpressionContext * /*ctx*/) override { }
  virtual void exitLambdaExpression(JavaParser::LambdaExpressionContext * /*ctx*/) override { }

  virtual void enterLambdaParameters(JavaParser::LambdaParametersContext * /*ctx*/) override { }
  virtual void exitLambdaParameters(JavaParser::LambdaParametersContext * /*ctx*/) override { }

  virtual void enterInferredFormalParameterList(JavaParser::InferredFormalParameterListContext * /*ctx*/) override { }
  virtual void exitInferredFormalParameterList(JavaParser::InferredFormalParameterListContext * /*ctx*/) override { }

  virtual void enterLambdaBody(JavaParser::LambdaBodyContext * /*ctx*/) override { }
  virtual void exitLambdaBody(JavaParser::LambdaBodyContext * /*ctx*/) override { }

  virtual void enterAssignmentExpression(JavaParser::AssignmentExpressionContext * /*ctx*/) override { }
  virtual void exitAssignmentExpression(JavaParser::AssignmentExpressionContext * /*ctx*/) override { }

  virtual void enterAssignment(JavaParser::AssignmentContext * /*ctx*/) override { }
  virtual void exitAssignment(JavaParser::AssignmentContext * /*ctx*/) override { }

  virtual void enterLeftHandSide(JavaParser::LeftHandSideContext * /*ctx*/) override { }
  virtual void exitLeftHandSide(JavaParser::LeftHandSideContext * /*ctx*/) override { }

  virtual void enterAssignmentOperator(JavaParser::AssignmentOperatorContext * /*ctx*/) override { }
  virtual void exitAssignmentOperator(JavaParser::AssignmentOperatorContext * /*ctx*/) override { }

  virtual void enterConditionalExpression(JavaParser::ConditionalExpressionContext * /*ctx*/) override { }
  virtual void exitConditionalExpression(JavaParser::ConditionalExpressionContext * /*ctx*/) override { }

  virtual void enterConditionalOrExpression(JavaParser::ConditionalOrExpressionContext * /*ctx*/) override { }
  virtual void exitConditionalOrExpression(JavaParser::ConditionalOrExpressionContext * /*ctx*/) override { }

  virtual void enterConditionalAndExpression(JavaParser::ConditionalAndExpressionContext * /*ctx*/) override { }
  virtual void exitConditionalAndExpression(JavaParser::ConditionalAndExpressionContext * /*ctx*/) override { }

  virtual void enterInclusiveOrExpression(JavaParser::InclusiveOrExpressionContext * /*ctx*/) override { }
  virtual void exitInclusiveOrExpression(JavaParser::InclusiveOrExpressionContext * /*ctx*/) override { }

  virtual void enterExclusiveOrExpression(JavaParser::ExclusiveOrExpressionContext * /*ctx*/) override { }
  virtual void exitExclusiveOrExpression(JavaParser::ExclusiveOrExpressionContext * /*ctx*/) override { }

  virtual void enterAndExpression(JavaParser::AndExpressionContext * /*ctx*/) override { }
  virtual void exitAndExpression(JavaParser::AndExpressionContext * /*ctx*/) override { }

  virtual void enterEqualityExpression(JavaParser::EqualityExpressionContext * /*ctx*/) override { }
  virtual void exitEqualityExpression(JavaParser::EqualityExpressionContext * /*ctx*/) override { }

  virtual void enterRelationalExpression(JavaParser::RelationalExpressionContext * /*ctx*/) override { }
  virtual void exitRelationalExpression(JavaParser::RelationalExpressionContext * /*ctx*/) override { }

  virtual void enterShiftExpression(JavaParser::ShiftExpressionContext * /*ctx*/) override { }
  virtual void exitShiftExpression(JavaParser::ShiftExpressionContext * /*ctx*/) override { }

  virtual void enterAdditiveExpression(JavaParser::AdditiveExpressionContext * /*ctx*/) override { }
  virtual void exitAdditiveExpression(JavaParser::AdditiveExpressionContext * /*ctx*/) override { }

  virtual void enterMultiplicativeExpression(JavaParser::MultiplicativeExpressionContext * /*ctx*/) override { }
  virtual void exitMultiplicativeExpression(JavaParser::MultiplicativeExpressionContext * /*ctx*/) override { }

  virtual void enterUnaryExpression(JavaParser::UnaryExpressionContext * /*ctx*/) override { }
  virtual void exitUnaryExpression(JavaParser::UnaryExpressionContext * /*ctx*/) override { }

  virtual void enterPreIncrementExpression(JavaParser::PreIncrementExpressionContext * /*ctx*/) override { }
  virtual void exitPreIncrementExpression(JavaParser::PreIncrementExpressionContext * /*ctx*/) override { }

  virtual void enterPreDecrementExpression(JavaParser::PreDecrementExpressionContext * /*ctx*/) override { }
  virtual void exitPreDecrementExpression(JavaParser::PreDecrementExpressionContext * /*ctx*/) override { }

  virtual void enterUnaryExpressionNotPlusMinus(JavaParser::UnaryExpressionNotPlusMinusContext * /*ctx*/) override { }
  virtual void exitUnaryExpressionNotPlusMinus(JavaParser::UnaryExpressionNotPlusMinusContext * /*ctx*/) override { }

  virtual void enterPostfixExpression(JavaParser::PostfixExpressionContext * /*ctx*/) override { }
  virtual void exitPostfixExpression(JavaParser::PostfixExpressionContext * /*ctx*/) override { }

  virtual void enterPostIncrementExpression(JavaParser::PostIncrementExpressionContext * /*ctx*/) override { }
  virtual void exitPostIncrementExpression(JavaParser::PostIncrementExpressionContext * /*ctx*/) override { }

  virtual void enterPostIncrementExpression_lf_postfixExpression(JavaParser::PostIncrementExpression_lf_postfixExpressionContext * /*ctx*/) override { }
  virtual void exitPostIncrementExpression_lf_postfixExpression(JavaParser::PostIncrementExpression_lf_postfixExpressionContext * /*ctx*/) override { }

  virtual void enterPostDecrementExpression(JavaParser::PostDecrementExpressionContext * /*ctx*/) override { }
  virtual void exitPostDecrementExpression(JavaParser::PostDecrementExpressionContext * /*ctx*/) override { }

  virtual void enterPostDecrementExpression_lf_postfixExpression(JavaParser::PostDecrementExpression_lf_postfixExpressionContext * /*ctx*/) override { }
  virtual void exitPostDecrementExpression_lf_postfixExpression(JavaParser::PostDecrementExpression_lf_postfixExpressionContext * /*ctx*/) override { }

  virtual void enterCastExpression(JavaParser::CastExpressionContext * /*ctx*/) override { }
  virtual void exitCastExpression(JavaParser::CastExpressionContext * /*ctx*/) override { }

  virtual void enterLiteral_DropletFile(JavaParser::Literal_DropletFileContext * /*ctx*/) override { }
  virtual void exitLiteral_DropletFile(JavaParser::Literal_DropletFileContext * /*ctx*/) override { }

  virtual void enterPrimitiveType_DropletFile(JavaParser::PrimitiveType_DropletFileContext * /*ctx*/) override { }
  virtual void exitPrimitiveType_DropletFile(JavaParser::PrimitiveType_DropletFileContext * /*ctx*/) override { }

  virtual void enterNumericType_DropletFile(JavaParser::NumericType_DropletFileContext * /*ctx*/) override { }
  virtual void exitNumericType_DropletFile(JavaParser::NumericType_DropletFileContext * /*ctx*/) override { }

  virtual void enterIntegralType_DropletFile(JavaParser::IntegralType_DropletFileContext * /*ctx*/) override { }
  virtual void exitIntegralType_DropletFile(JavaParser::IntegralType_DropletFileContext * /*ctx*/) override { }

  virtual void enterFloatingPointType_DropletFile(JavaParser::FloatingPointType_DropletFileContext * /*ctx*/) override { }
  virtual void exitFloatingPointType_DropletFile(JavaParser::FloatingPointType_DropletFileContext * /*ctx*/) override { }

  virtual void enterReferenceType_DropletFile(JavaParser::ReferenceType_DropletFileContext * /*ctx*/) override { }
  virtual void exitReferenceType_DropletFile(JavaParser::ReferenceType_DropletFileContext * /*ctx*/) override { }

  virtual void enterClassOrInterfaceType_DropletFile(JavaParser::ClassOrInterfaceType_DropletFileContext * /*ctx*/) override { }
  virtual void exitClassOrInterfaceType_DropletFile(JavaParser::ClassOrInterfaceType_DropletFileContext * /*ctx*/) override { }

  virtual void enterClassType_DropletFile(JavaParser::ClassType_DropletFileContext * /*ctx*/) override { }
  virtual void exitClassType_DropletFile(JavaParser::ClassType_DropletFileContext * /*ctx*/) override { }

  virtual void enterClassType_lf_classOrInterfaceType_DropletFile(JavaParser::ClassType_lf_classOrInterfaceType_DropletFileContext * /*ctx*/) override { }
  virtual void exitClassType_lf_classOrInterfaceType_DropletFile(JavaParser::ClassType_lf_classOrInterfaceType_DropletFileContext * /*ctx*/) override { }

  virtual void enterClassType_lfno_classOrInterfaceType_DropletFile(JavaParser::ClassType_lfno_classOrInterfaceType_DropletFileContext * /*ctx*/) override { }
  virtual void exitClassType_lfno_classOrInterfaceType_DropletFile(JavaParser::ClassType_lfno_classOrInterfaceType_DropletFileContext * /*ctx*/) override { }

  virtual void enterInterfaceType_DropletFile(JavaParser::InterfaceType_DropletFileContext * /*ctx*/) override { }
  virtual void exitInterfaceType_DropletFile(JavaParser::InterfaceType_DropletFileContext * /*ctx*/) override { }

  virtual void enterInterfaceType_lf_classOrInterfaceType_DropletFile(JavaParser::InterfaceType_lf_classOrInterfaceType_DropletFileContext * /*ctx*/) override { }
  virtual void exitInterfaceType_lf_classOrInterfaceType_DropletFile(JavaParser::InterfaceType_lf_classOrInterfaceType_DropletFileContext * /*ctx*/) override { }

  virtual void enterInterfaceType_lfno_classOrInterfaceType_DropletFile(JavaParser::InterfaceType_lfno_classOrInterfaceType_DropletFileContext * /*ctx*/) override { }
  virtual void exitInterfaceType_lfno_classOrInterfaceType_DropletFile(JavaParser::InterfaceType_lfno_classOrInterfaceType_DropletFileContext * /*ctx*/) override { }

  virtual void enterTypeVariable_DropletFile(JavaParser::TypeVariable_DropletFileContext * /*ctx*/) override { }
  virtual void exitTypeVariable_DropletFile(JavaParser::TypeVariable_DropletFileContext * /*ctx*/) override { }

  virtual void enterArrayType_DropletFile(JavaParser::ArrayType_DropletFileContext * /*ctx*/) override { }
  virtual void exitArrayType_DropletFile(JavaParser::ArrayType_DropletFileContext * /*ctx*/) override { }

  virtual void enterDims_DropletFile(JavaParser::Dims_DropletFileContext * /*ctx*/) override { }
  virtual void exitDims_DropletFile(JavaParser::Dims_DropletFileContext * /*ctx*/) override { }

  virtual void enterTypeParameter_DropletFile(JavaParser::TypeParameter_DropletFileContext * /*ctx*/) override { }
  virtual void exitTypeParameter_DropletFile(JavaParser::TypeParameter_DropletFileContext * /*ctx*/) override { }

  virtual void enterTypeParameterModifier_DropletFile(JavaParser::TypeParameterModifier_DropletFileContext * /*ctx*/) override { }
  virtual void exitTypeParameterModifier_DropletFile(JavaParser::TypeParameterModifier_DropletFileContext * /*ctx*/) override { }

  virtual void enterTypeBound_DropletFile(JavaParser::TypeBound_DropletFileContext * /*ctx*/) override { }
  virtual void exitTypeBound_DropletFile(JavaParser::TypeBound_DropletFileContext * /*ctx*/) override { }

  virtual void enterAdditionalBound_DropletFile(JavaParser::AdditionalBound_DropletFileContext * /*ctx*/) override { }
  virtual void exitAdditionalBound_DropletFile(JavaParser::AdditionalBound_DropletFileContext * /*ctx*/) override { }

  virtual void enterTypeArguments_DropletFile(JavaParser::TypeArguments_DropletFileContext * /*ctx*/) override { }
  virtual void exitTypeArguments_DropletFile(JavaParser::TypeArguments_DropletFileContext * /*ctx*/) override { }

  virtual void enterTypeArgumentList_DropletFile(JavaParser::TypeArgumentList_DropletFileContext * /*ctx*/) override { }
  virtual void exitTypeArgumentList_DropletFile(JavaParser::TypeArgumentList_DropletFileContext * /*ctx*/) override { }

  virtual void enterTypeArgument_DropletFile(JavaParser::TypeArgument_DropletFileContext * /*ctx*/) override { }
  virtual void exitTypeArgument_DropletFile(JavaParser::TypeArgument_DropletFileContext * /*ctx*/) override { }

  virtual void enterWildcard_DropletFile(JavaParser::Wildcard_DropletFileContext * /*ctx*/) override { }
  virtual void exitWildcard_DropletFile(JavaParser::Wildcard_DropletFileContext * /*ctx*/) override { }

  virtual void enterWildcardBounds_DropletFile(JavaParser::WildcardBounds_DropletFileContext * /*ctx*/) override { }
  virtual void exitWildcardBounds_DropletFile(JavaParser::WildcardBounds_DropletFileContext * /*ctx*/) override { }

  virtual void enterModuleName_DropletFile(JavaParser::ModuleName_DropletFileContext * /*ctx*/) override { }
  virtual void exitModuleName_DropletFile(JavaParser::ModuleName_DropletFileContext * /*ctx*/) override { }

  virtual void enterPackageName_DropletFile(JavaParser::PackageName_DropletFileContext * /*ctx*/) override { }
  virtual void exitPackageName_DropletFile(JavaParser::PackageName_DropletFileContext * /*ctx*/) override { }

  virtual void enterTypeName_DropletFile(JavaParser::TypeName_DropletFileContext * /*ctx*/) override { }
  virtual void exitTypeName_DropletFile(JavaParser::TypeName_DropletFileContext * /*ctx*/) override { }

  virtual void enterPackageOrTypeName_DropletFile(JavaParser::PackageOrTypeName_DropletFileContext * /*ctx*/) override { }
  virtual void exitPackageOrTypeName_DropletFile(JavaParser::PackageOrTypeName_DropletFileContext * /*ctx*/) override { }

  virtual void enterExpressionName_DropletFile(JavaParser::ExpressionName_DropletFileContext * /*ctx*/) override { }
  virtual void exitExpressionName_DropletFile(JavaParser::ExpressionName_DropletFileContext * /*ctx*/) override { }

  virtual void enterMethodName_DropletFile(JavaParser::MethodName_DropletFileContext * /*ctx*/) override { }
  virtual void exitMethodName_DropletFile(JavaParser::MethodName_DropletFileContext * /*ctx*/) override { }

  virtual void enterAmbiguousName_DropletFile(JavaParser::AmbiguousName_DropletFileContext * /*ctx*/) override { }
  virtual void exitAmbiguousName_DropletFile(JavaParser::AmbiguousName_DropletFileContext * /*ctx*/) override { }

  virtual void enterCompilationUnit_DropletFile(JavaParser::CompilationUnit_DropletFileContext * /*ctx*/) override { }
  virtual void exitCompilationUnit_DropletFile(JavaParser::CompilationUnit_DropletFileContext * /*ctx*/) override { }

  virtual void enterOrdinaryCompilation_DropletFile(JavaParser::OrdinaryCompilation_DropletFileContext * /*ctx*/) override { }
  virtual void exitOrdinaryCompilation_DropletFile(JavaParser::OrdinaryCompilation_DropletFileContext * /*ctx*/) override { }

  virtual void enterModularCompilation_DropletFile(JavaParser::ModularCompilation_DropletFileContext * /*ctx*/) override { }
  virtual void exitModularCompilation_DropletFile(JavaParser::ModularCompilation_DropletFileContext * /*ctx*/) override { }

  virtual void enterPackageDeclaration_DropletFile(JavaParser::PackageDeclaration_DropletFileContext * /*ctx*/) override { }
  virtual void exitPackageDeclaration_DropletFile(JavaParser::PackageDeclaration_DropletFileContext * /*ctx*/) override { }

  virtual void enterPackageModifier_DropletFile(JavaParser::PackageModifier_DropletFileContext * /*ctx*/) override { }
  virtual void exitPackageModifier_DropletFile(JavaParser::PackageModifier_DropletFileContext * /*ctx*/) override { }

  virtual void enterImportDeclaration_DropletFile(JavaParser::ImportDeclaration_DropletFileContext * /*ctx*/) override { }
  virtual void exitImportDeclaration_DropletFile(JavaParser::ImportDeclaration_DropletFileContext * /*ctx*/) override { }

  virtual void enterSingleTypeImportDeclaration_DropletFile(JavaParser::SingleTypeImportDeclaration_DropletFileContext * /*ctx*/) override { }
  virtual void exitSingleTypeImportDeclaration_DropletFile(JavaParser::SingleTypeImportDeclaration_DropletFileContext * /*ctx*/) override { }

  virtual void enterTypeImportOnDemandDeclaration_DropletFile(JavaParser::TypeImportOnDemandDeclaration_DropletFileContext * /*ctx*/) override { }
  virtual void exitTypeImportOnDemandDeclaration_DropletFile(JavaParser::TypeImportOnDemandDeclaration_DropletFileContext * /*ctx*/) override { }

  virtual void enterSingleStaticImportDeclaration_DropletFile(JavaParser::SingleStaticImportDeclaration_DropletFileContext * /*ctx*/) override { }
  virtual void exitSingleStaticImportDeclaration_DropletFile(JavaParser::SingleStaticImportDeclaration_DropletFileContext * /*ctx*/) override { }

  virtual void enterStaticImportOnDemandDeclaration_DropletFile(JavaParser::StaticImportOnDemandDeclaration_DropletFileContext * /*ctx*/) override { }
  virtual void exitStaticImportOnDemandDeclaration_DropletFile(JavaParser::StaticImportOnDemandDeclaration_DropletFileContext * /*ctx*/) override { }

  virtual void enterTypeDeclaration_DropletFile(JavaParser::TypeDeclaration_DropletFileContext * /*ctx*/) override { }
  virtual void exitTypeDeclaration_DropletFile(JavaParser::TypeDeclaration_DropletFileContext * /*ctx*/) override { }

  virtual void enterModuleDeclaration_DropletFile(JavaParser::ModuleDeclaration_DropletFileContext * /*ctx*/) override { }
  virtual void exitModuleDeclaration_DropletFile(JavaParser::ModuleDeclaration_DropletFileContext * /*ctx*/) override { }

  virtual void enterModuleDirective_DropletFile(JavaParser::ModuleDirective_DropletFileContext * /*ctx*/) override { }
  virtual void exitModuleDirective_DropletFile(JavaParser::ModuleDirective_DropletFileContext * /*ctx*/) override { }

  virtual void enterRequiresModifier_DropletFile(JavaParser::RequiresModifier_DropletFileContext * /*ctx*/) override { }
  virtual void exitRequiresModifier_DropletFile(JavaParser::RequiresModifier_DropletFileContext * /*ctx*/) override { }

  virtual void enterClassDeclaration_DropletFile(JavaParser::ClassDeclaration_DropletFileContext * /*ctx*/) override { }
  virtual void exitClassDeclaration_DropletFile(JavaParser::ClassDeclaration_DropletFileContext * /*ctx*/) override { }

  virtual void enterNormalClassDeclaration_DropletFile(JavaParser::NormalClassDeclaration_DropletFileContext * /*ctx*/) override { }
  virtual void exitNormalClassDeclaration_DropletFile(JavaParser::NormalClassDeclaration_DropletFileContext * /*ctx*/) override { }

  virtual void enterClassModifier_DropletFile(JavaParser::ClassModifier_DropletFileContext * /*ctx*/) override { }
  virtual void exitClassModifier_DropletFile(JavaParser::ClassModifier_DropletFileContext * /*ctx*/) override { }

  virtual void enterTypeParameters_DropletFile(JavaParser::TypeParameters_DropletFileContext * /*ctx*/) override { }
  virtual void exitTypeParameters_DropletFile(JavaParser::TypeParameters_DropletFileContext * /*ctx*/) override { }

  virtual void enterTypeParameterList_DropletFile(JavaParser::TypeParameterList_DropletFileContext * /*ctx*/) override { }
  virtual void exitTypeParameterList_DropletFile(JavaParser::TypeParameterList_DropletFileContext * /*ctx*/) override { }

  virtual void enterSuperclass_DropletFile(JavaParser::Superclass_DropletFileContext * /*ctx*/) override { }
  virtual void exitSuperclass_DropletFile(JavaParser::Superclass_DropletFileContext * /*ctx*/) override { }

  virtual void enterSuperinterfaces_DropletFile(JavaParser::Superinterfaces_DropletFileContext * /*ctx*/) override { }
  virtual void exitSuperinterfaces_DropletFile(JavaParser::Superinterfaces_DropletFileContext * /*ctx*/) override { }

  virtual void enterInterfaceTypeList_DropletFile(JavaParser::InterfaceTypeList_DropletFileContext * /*ctx*/) override { }
  virtual void exitInterfaceTypeList_DropletFile(JavaParser::InterfaceTypeList_DropletFileContext * /*ctx*/) override { }

  virtual void enterClassBody_DropletFile(JavaParser::ClassBody_DropletFileContext * /*ctx*/) override { }
  virtual void exitClassBody_DropletFile(JavaParser::ClassBody_DropletFileContext * /*ctx*/) override { }

  virtual void enterClassBodyDeclaration_DropletFile(JavaParser::ClassBodyDeclaration_DropletFileContext * /*ctx*/) override { }
  virtual void exitClassBodyDeclaration_DropletFile(JavaParser::ClassBodyDeclaration_DropletFileContext * /*ctx*/) override { }

  virtual void enterClassMemberDeclaration_DropletFile(JavaParser::ClassMemberDeclaration_DropletFileContext * /*ctx*/) override { }
  virtual void exitClassMemberDeclaration_DropletFile(JavaParser::ClassMemberDeclaration_DropletFileContext * /*ctx*/) override { }

  virtual void enterFieldDeclaration_DropletFile(JavaParser::FieldDeclaration_DropletFileContext * /*ctx*/) override { }
  virtual void exitFieldDeclaration_DropletFile(JavaParser::FieldDeclaration_DropletFileContext * /*ctx*/) override { }

  virtual void enterFieldModifier_DropletFile(JavaParser::FieldModifier_DropletFileContext * /*ctx*/) override { }
  virtual void exitFieldModifier_DropletFile(JavaParser::FieldModifier_DropletFileContext * /*ctx*/) override { }

  virtual void enterVariableDeclaratorList_DropletFile(JavaParser::VariableDeclaratorList_DropletFileContext * /*ctx*/) override { }
  virtual void exitVariableDeclaratorList_DropletFile(JavaParser::VariableDeclaratorList_DropletFileContext * /*ctx*/) override { }

  virtual void enterVariableDeclarator_DropletFile(JavaParser::VariableDeclarator_DropletFileContext * /*ctx*/) override { }
  virtual void exitVariableDeclarator_DropletFile(JavaParser::VariableDeclarator_DropletFileContext * /*ctx*/) override { }

  virtual void enterVariableDeclaratorId_DropletFile(JavaParser::VariableDeclaratorId_DropletFileContext * /*ctx*/) override { }
  virtual void exitVariableDeclaratorId_DropletFile(JavaParser::VariableDeclaratorId_DropletFileContext * /*ctx*/) override { }

  virtual void enterVariableInitializer_DropletFile(JavaParser::VariableInitializer_DropletFileContext * /*ctx*/) override { }
  virtual void exitVariableInitializer_DropletFile(JavaParser::VariableInitializer_DropletFileContext * /*ctx*/) override { }

  virtual void enterUnannType_DropletFile(JavaParser::UnannType_DropletFileContext * /*ctx*/) override { }
  virtual void exitUnannType_DropletFile(JavaParser::UnannType_DropletFileContext * /*ctx*/) override { }

  virtual void enterUnannPrimitiveType_DropletFile(JavaParser::UnannPrimitiveType_DropletFileContext * /*ctx*/) override { }
  virtual void exitUnannPrimitiveType_DropletFile(JavaParser::UnannPrimitiveType_DropletFileContext * /*ctx*/) override { }

  virtual void enterUnannReferenceType_DropletFile(JavaParser::UnannReferenceType_DropletFileContext * /*ctx*/) override { }
  virtual void exitUnannReferenceType_DropletFile(JavaParser::UnannReferenceType_DropletFileContext * /*ctx*/) override { }

  virtual void enterUnannClassOrInterfaceType_DropletFile(JavaParser::UnannClassOrInterfaceType_DropletFileContext * /*ctx*/) override { }
  virtual void exitUnannClassOrInterfaceType_DropletFile(JavaParser::UnannClassOrInterfaceType_DropletFileContext * /*ctx*/) override { }

  virtual void enterUnannClassType_DropletFile(JavaParser::UnannClassType_DropletFileContext * /*ctx*/) override { }
  virtual void exitUnannClassType_DropletFile(JavaParser::UnannClassType_DropletFileContext * /*ctx*/) override { }

  virtual void enterUnannClassType_lf_unannClassOrInterfaceType_DropletFile(JavaParser::UnannClassType_lf_unannClassOrInterfaceType_DropletFileContext * /*ctx*/) override { }
  virtual void exitUnannClassType_lf_unannClassOrInterfaceType_DropletFile(JavaParser::UnannClassType_lf_unannClassOrInterfaceType_DropletFileContext * /*ctx*/) override { }

  virtual void enterUnannClassType_lfno_unannClassOrInterfaceType_DropletFile(JavaParser::UnannClassType_lfno_unannClassOrInterfaceType_DropletFileContext * /*ctx*/) override { }
  virtual void exitUnannClassType_lfno_unannClassOrInterfaceType_DropletFile(JavaParser::UnannClassType_lfno_unannClassOrInterfaceType_DropletFileContext * /*ctx*/) override { }

  virtual void enterUnannInterfaceType_DropletFile(JavaParser::UnannInterfaceType_DropletFileContext * /*ctx*/) override { }
  virtual void exitUnannInterfaceType_DropletFile(JavaParser::UnannInterfaceType_DropletFileContext * /*ctx*/) override { }

  virtual void enterUnannInterfaceType_lf_unannClassOrInterfaceType_DropletFile(JavaParser::UnannInterfaceType_lf_unannClassOrInterfaceType_DropletFileContext * /*ctx*/) override { }
  virtual void exitUnannInterfaceType_lf_unannClassOrInterfaceType_DropletFile(JavaParser::UnannInterfaceType_lf_unannClassOrInterfaceType_DropletFileContext * /*ctx*/) override { }

  virtual void enterUnannInterfaceType_lfno_unannClassOrInterfaceType_DropletFile(JavaParser::UnannInterfaceType_lfno_unannClassOrInterfaceType_DropletFileContext * /*ctx*/) override { }
  virtual void exitUnannInterfaceType_lfno_unannClassOrInterfaceType_DropletFile(JavaParser::UnannInterfaceType_lfno_unannClassOrInterfaceType_DropletFileContext * /*ctx*/) override { }

  virtual void enterUnannTypeVariable_DropletFile(JavaParser::UnannTypeVariable_DropletFileContext * /*ctx*/) override { }
  virtual void exitUnannTypeVariable_DropletFile(JavaParser::UnannTypeVariable_DropletFileContext * /*ctx*/) override { }

  virtual void enterUnannArrayType_DropletFile(JavaParser::UnannArrayType_DropletFileContext * /*ctx*/) override { }
  virtual void exitUnannArrayType_DropletFile(JavaParser::UnannArrayType_DropletFileContext * /*ctx*/) override { }

  virtual void enterMethodDeclaration_DropletFile(JavaParser::MethodDeclaration_DropletFileContext * /*ctx*/) override { }
  virtual void exitMethodDeclaration_DropletFile(JavaParser::MethodDeclaration_DropletFileContext * /*ctx*/) override { }

  virtual void enterMethodModifier_DropletFile(JavaParser::MethodModifier_DropletFileContext * /*ctx*/) override { }
  virtual void exitMethodModifier_DropletFile(JavaParser::MethodModifier_DropletFileContext * /*ctx*/) override { }

  virtual void enterMethodHeader_DropletFile(JavaParser::MethodHeader_DropletFileContext * /*ctx*/) override { }
  virtual void exitMethodHeader_DropletFile(JavaParser::MethodHeader_DropletFileContext * /*ctx*/) override { }

  virtual void enterResult_DropletFile(JavaParser::Result_DropletFileContext * /*ctx*/) override { }
  virtual void exitResult_DropletFile(JavaParser::Result_DropletFileContext * /*ctx*/) override { }

  virtual void enterMethodDeclarator_DropletFile(JavaParser::MethodDeclarator_DropletFileContext * /*ctx*/) override { }
  virtual void exitMethodDeclarator_DropletFile(JavaParser::MethodDeclarator_DropletFileContext * /*ctx*/) override { }

  virtual void enterFormalParameterList_DropletFile(JavaParser::FormalParameterList_DropletFileContext * /*ctx*/) override { }
  virtual void exitFormalParameterList_DropletFile(JavaParser::FormalParameterList_DropletFileContext * /*ctx*/) override { }

  virtual void enterFormalParameters_DropletFile(JavaParser::FormalParameters_DropletFileContext * /*ctx*/) override { }
  virtual void exitFormalParameters_DropletFile(JavaParser::FormalParameters_DropletFileContext * /*ctx*/) override { }

  virtual void enterFormalParameter_DropletFile(JavaParser::FormalParameter_DropletFileContext * /*ctx*/) override { }
  virtual void exitFormalParameter_DropletFile(JavaParser::FormalParameter_DropletFileContext * /*ctx*/) override { }

  virtual void enterVariableModifier_DropletFile(JavaParser::VariableModifier_DropletFileContext * /*ctx*/) override { }
  virtual void exitVariableModifier_DropletFile(JavaParser::VariableModifier_DropletFileContext * /*ctx*/) override { }

  virtual void enterLastFormalParameter_DropletFile(JavaParser::LastFormalParameter_DropletFileContext * /*ctx*/) override { }
  virtual void exitLastFormalParameter_DropletFile(JavaParser::LastFormalParameter_DropletFileContext * /*ctx*/) override { }

  virtual void enterReceiverParameter_DropletFile(JavaParser::ReceiverParameter_DropletFileContext * /*ctx*/) override { }
  virtual void exitReceiverParameter_DropletFile(JavaParser::ReceiverParameter_DropletFileContext * /*ctx*/) override { }

  virtual void enterThrows__DropletFile(JavaParser::Throws__DropletFileContext * /*ctx*/) override { }
  virtual void exitThrows__DropletFile(JavaParser::Throws__DropletFileContext * /*ctx*/) override { }

  virtual void enterExceptionTypeList_DropletFile(JavaParser::ExceptionTypeList_DropletFileContext * /*ctx*/) override { }
  virtual void exitExceptionTypeList_DropletFile(JavaParser::ExceptionTypeList_DropletFileContext * /*ctx*/) override { }

  virtual void enterExceptionType_DropletFile(JavaParser::ExceptionType_DropletFileContext * /*ctx*/) override { }
  virtual void exitExceptionType_DropletFile(JavaParser::ExceptionType_DropletFileContext * /*ctx*/) override { }

  virtual void enterMethodBody_DropletFile(JavaParser::MethodBody_DropletFileContext * /*ctx*/) override { }
  virtual void exitMethodBody_DropletFile(JavaParser::MethodBody_DropletFileContext * /*ctx*/) override { }

  virtual void enterInstanceInitializer_DropletFile(JavaParser::InstanceInitializer_DropletFileContext * /*ctx*/) override { }
  virtual void exitInstanceInitializer_DropletFile(JavaParser::InstanceInitializer_DropletFileContext * /*ctx*/) override { }

  virtual void enterStaticInitializer_DropletFile(JavaParser::StaticInitializer_DropletFileContext * /*ctx*/) override { }
  virtual void exitStaticInitializer_DropletFile(JavaParser::StaticInitializer_DropletFileContext * /*ctx*/) override { }

  virtual void enterConstructorDeclaration_DropletFile(JavaParser::ConstructorDeclaration_DropletFileContext * /*ctx*/) override { }
  virtual void exitConstructorDeclaration_DropletFile(JavaParser::ConstructorDeclaration_DropletFileContext * /*ctx*/) override { }

  virtual void enterConstructorModifier_DropletFile(JavaParser::ConstructorModifier_DropletFileContext * /*ctx*/) override { }
  virtual void exitConstructorModifier_DropletFile(JavaParser::ConstructorModifier_DropletFileContext * /*ctx*/) override { }

  virtual void enterConstructorDeclarator_DropletFile(JavaParser::ConstructorDeclarator_DropletFileContext * /*ctx*/) override { }
  virtual void exitConstructorDeclarator_DropletFile(JavaParser::ConstructorDeclarator_DropletFileContext * /*ctx*/) override { }

  virtual void enterSimpleTypeName_DropletFile(JavaParser::SimpleTypeName_DropletFileContext * /*ctx*/) override { }
  virtual void exitSimpleTypeName_DropletFile(JavaParser::SimpleTypeName_DropletFileContext * /*ctx*/) override { }

  virtual void enterConstructorBody_DropletFile(JavaParser::ConstructorBody_DropletFileContext * /*ctx*/) override { }
  virtual void exitConstructorBody_DropletFile(JavaParser::ConstructorBody_DropletFileContext * /*ctx*/) override { }

  virtual void enterExplicitConstructorInvocation_DropletFile(JavaParser::ExplicitConstructorInvocation_DropletFileContext * /*ctx*/) override { }
  virtual void exitExplicitConstructorInvocation_DropletFile(JavaParser::ExplicitConstructorInvocation_DropletFileContext * /*ctx*/) override { }

  virtual void enterEnumDeclaration_DropletFile(JavaParser::EnumDeclaration_DropletFileContext * /*ctx*/) override { }
  virtual void exitEnumDeclaration_DropletFile(JavaParser::EnumDeclaration_DropletFileContext * /*ctx*/) override { }

  virtual void enterEnumBody_DropletFile(JavaParser::EnumBody_DropletFileContext * /*ctx*/) override { }
  virtual void exitEnumBody_DropletFile(JavaParser::EnumBody_DropletFileContext * /*ctx*/) override { }

  virtual void enterEnumConstantList_DropletFile(JavaParser::EnumConstantList_DropletFileContext * /*ctx*/) override { }
  virtual void exitEnumConstantList_DropletFile(JavaParser::EnumConstantList_DropletFileContext * /*ctx*/) override { }

  virtual void enterEnumConstant_DropletFile(JavaParser::EnumConstant_DropletFileContext * /*ctx*/) override { }
  virtual void exitEnumConstant_DropletFile(JavaParser::EnumConstant_DropletFileContext * /*ctx*/) override { }

  virtual void enterEnumConstantModifier_DropletFile(JavaParser::EnumConstantModifier_DropletFileContext * /*ctx*/) override { }
  virtual void exitEnumConstantModifier_DropletFile(JavaParser::EnumConstantModifier_DropletFileContext * /*ctx*/) override { }

  virtual void enterEnumBodyDeclarations_DropletFile(JavaParser::EnumBodyDeclarations_DropletFileContext * /*ctx*/) override { }
  virtual void exitEnumBodyDeclarations_DropletFile(JavaParser::EnumBodyDeclarations_DropletFileContext * /*ctx*/) override { }

  virtual void enterInterfaceDeclaration_DropletFile(JavaParser::InterfaceDeclaration_DropletFileContext * /*ctx*/) override { }
  virtual void exitInterfaceDeclaration_DropletFile(JavaParser::InterfaceDeclaration_DropletFileContext * /*ctx*/) override { }

  virtual void enterNormalInterfaceDeclaration_DropletFile(JavaParser::NormalInterfaceDeclaration_DropletFileContext * /*ctx*/) override { }
  virtual void exitNormalInterfaceDeclaration_DropletFile(JavaParser::NormalInterfaceDeclaration_DropletFileContext * /*ctx*/) override { }

  virtual void enterInterfaceModifier_DropletFile(JavaParser::InterfaceModifier_DropletFileContext * /*ctx*/) override { }
  virtual void exitInterfaceModifier_DropletFile(JavaParser::InterfaceModifier_DropletFileContext * /*ctx*/) override { }

  virtual void enterExtendsInterfaces_DropletFile(JavaParser::ExtendsInterfaces_DropletFileContext * /*ctx*/) override { }
  virtual void exitExtendsInterfaces_DropletFile(JavaParser::ExtendsInterfaces_DropletFileContext * /*ctx*/) override { }

  virtual void enterInterfaceBody_DropletFile(JavaParser::InterfaceBody_DropletFileContext * /*ctx*/) override { }
  virtual void exitInterfaceBody_DropletFile(JavaParser::InterfaceBody_DropletFileContext * /*ctx*/) override { }

  virtual void enterInterfaceMemberDeclaration_DropletFile(JavaParser::InterfaceMemberDeclaration_DropletFileContext * /*ctx*/) override { }
  virtual void exitInterfaceMemberDeclaration_DropletFile(JavaParser::InterfaceMemberDeclaration_DropletFileContext * /*ctx*/) override { }

  virtual void enterConstantDeclaration_DropletFile(JavaParser::ConstantDeclaration_DropletFileContext * /*ctx*/) override { }
  virtual void exitConstantDeclaration_DropletFile(JavaParser::ConstantDeclaration_DropletFileContext * /*ctx*/) override { }

  virtual void enterConstantModifier_DropletFile(JavaParser::ConstantModifier_DropletFileContext * /*ctx*/) override { }
  virtual void exitConstantModifier_DropletFile(JavaParser::ConstantModifier_DropletFileContext * /*ctx*/) override { }

  virtual void enterInterfaceMethodDeclaration_DropletFile(JavaParser::InterfaceMethodDeclaration_DropletFileContext * /*ctx*/) override { }
  virtual void exitInterfaceMethodDeclaration_DropletFile(JavaParser::InterfaceMethodDeclaration_DropletFileContext * /*ctx*/) override { }

  virtual void enterInterfaceMethodModifier_DropletFile(JavaParser::InterfaceMethodModifier_DropletFileContext * /*ctx*/) override { }
  virtual void exitInterfaceMethodModifier_DropletFile(JavaParser::InterfaceMethodModifier_DropletFileContext * /*ctx*/) override { }

  virtual void enterAnnotationTypeDeclaration_DropletFile(JavaParser::AnnotationTypeDeclaration_DropletFileContext * /*ctx*/) override { }
  virtual void exitAnnotationTypeDeclaration_DropletFile(JavaParser::AnnotationTypeDeclaration_DropletFileContext * /*ctx*/) override { }

  virtual void enterAnnotationTypeBody_DropletFile(JavaParser::AnnotationTypeBody_DropletFileContext * /*ctx*/) override { }
  virtual void exitAnnotationTypeBody_DropletFile(JavaParser::AnnotationTypeBody_DropletFileContext * /*ctx*/) override { }

  virtual void enterAnnotationTypeMemberDeclaration_DropletFile(JavaParser::AnnotationTypeMemberDeclaration_DropletFileContext * /*ctx*/) override { }
  virtual void exitAnnotationTypeMemberDeclaration_DropletFile(JavaParser::AnnotationTypeMemberDeclaration_DropletFileContext * /*ctx*/) override { }

  virtual void enterAnnotationTypeElementDeclaration_DropletFile(JavaParser::AnnotationTypeElementDeclaration_DropletFileContext * /*ctx*/) override { }
  virtual void exitAnnotationTypeElementDeclaration_DropletFile(JavaParser::AnnotationTypeElementDeclaration_DropletFileContext * /*ctx*/) override { }

  virtual void enterAnnotationTypeElementModifier_DropletFile(JavaParser::AnnotationTypeElementModifier_DropletFileContext * /*ctx*/) override { }
  virtual void exitAnnotationTypeElementModifier_DropletFile(JavaParser::AnnotationTypeElementModifier_DropletFileContext * /*ctx*/) override { }

  virtual void enterDefaultValue_DropletFile(JavaParser::DefaultValue_DropletFileContext * /*ctx*/) override { }
  virtual void exitDefaultValue_DropletFile(JavaParser::DefaultValue_DropletFileContext * /*ctx*/) override { }

  virtual void enterAnnotation_DropletFile(JavaParser::Annotation_DropletFileContext * /*ctx*/) override { }
  virtual void exitAnnotation_DropletFile(JavaParser::Annotation_DropletFileContext * /*ctx*/) override { }

  virtual void enterNormalAnnotation_DropletFile(JavaParser::NormalAnnotation_DropletFileContext * /*ctx*/) override { }
  virtual void exitNormalAnnotation_DropletFile(JavaParser::NormalAnnotation_DropletFileContext * /*ctx*/) override { }

  virtual void enterElementValuePairList_DropletFile(JavaParser::ElementValuePairList_DropletFileContext * /*ctx*/) override { }
  virtual void exitElementValuePairList_DropletFile(JavaParser::ElementValuePairList_DropletFileContext * /*ctx*/) override { }

  virtual void enterElementValuePair_DropletFile(JavaParser::ElementValuePair_DropletFileContext * /*ctx*/) override { }
  virtual void exitElementValuePair_DropletFile(JavaParser::ElementValuePair_DropletFileContext * /*ctx*/) override { }

  virtual void enterElementValue_DropletFile(JavaParser::ElementValue_DropletFileContext * /*ctx*/) override { }
  virtual void exitElementValue_DropletFile(JavaParser::ElementValue_DropletFileContext * /*ctx*/) override { }

  virtual void enterElementValueArrayInitializer_DropletFile(JavaParser::ElementValueArrayInitializer_DropletFileContext * /*ctx*/) override { }
  virtual void exitElementValueArrayInitializer_DropletFile(JavaParser::ElementValueArrayInitializer_DropletFileContext * /*ctx*/) override { }

  virtual void enterElementValueList_DropletFile(JavaParser::ElementValueList_DropletFileContext * /*ctx*/) override { }
  virtual void exitElementValueList_DropletFile(JavaParser::ElementValueList_DropletFileContext * /*ctx*/) override { }

  virtual void enterMarkerAnnotation_DropletFile(JavaParser::MarkerAnnotation_DropletFileContext * /*ctx*/) override { }
  virtual void exitMarkerAnnotation_DropletFile(JavaParser::MarkerAnnotation_DropletFileContext * /*ctx*/) override { }

  virtual void enterSingleElementAnnotation_DropletFile(JavaParser::SingleElementAnnotation_DropletFileContext * /*ctx*/) override { }
  virtual void exitSingleElementAnnotation_DropletFile(JavaParser::SingleElementAnnotation_DropletFileContext * /*ctx*/) override { }

  virtual void enterArrayInitializer_DropletFile(JavaParser::ArrayInitializer_DropletFileContext * /*ctx*/) override { }
  virtual void exitArrayInitializer_DropletFile(JavaParser::ArrayInitializer_DropletFileContext * /*ctx*/) override { }

  virtual void enterVariableInitializerList_DropletFile(JavaParser::VariableInitializerList_DropletFileContext * /*ctx*/) override { }
  virtual void exitVariableInitializerList_DropletFile(JavaParser::VariableInitializerList_DropletFileContext * /*ctx*/) override { }

  virtual void enterBlock_DropletFile(JavaParser::Block_DropletFileContext * /*ctx*/) override { }
  virtual void exitBlock_DropletFile(JavaParser::Block_DropletFileContext * /*ctx*/) override { }

  virtual void enterBlockStatements_DropletFile(JavaParser::BlockStatements_DropletFileContext * /*ctx*/) override { }
  virtual void exitBlockStatements_DropletFile(JavaParser::BlockStatements_DropletFileContext * /*ctx*/) override { }

  virtual void enterBlockStatement_DropletFile(JavaParser::BlockStatement_DropletFileContext * /*ctx*/) override { }
  virtual void exitBlockStatement_DropletFile(JavaParser::BlockStatement_DropletFileContext * /*ctx*/) override { }

  virtual void enterLocalVariableDeclarationStatement_DropletFile(JavaParser::LocalVariableDeclarationStatement_DropletFileContext * /*ctx*/) override { }
  virtual void exitLocalVariableDeclarationStatement_DropletFile(JavaParser::LocalVariableDeclarationStatement_DropletFileContext * /*ctx*/) override { }

  virtual void enterLocalVariableDeclaration_DropletFile(JavaParser::LocalVariableDeclaration_DropletFileContext * /*ctx*/) override { }
  virtual void exitLocalVariableDeclaration_DropletFile(JavaParser::LocalVariableDeclaration_DropletFileContext * /*ctx*/) override { }

  virtual void enterStatement_DropletFile(JavaParser::Statement_DropletFileContext * /*ctx*/) override { }
  virtual void exitStatement_DropletFile(JavaParser::Statement_DropletFileContext * /*ctx*/) override { }

  virtual void enterStatementNoShortIf_DropletFile(JavaParser::StatementNoShortIf_DropletFileContext * /*ctx*/) override { }
  virtual void exitStatementNoShortIf_DropletFile(JavaParser::StatementNoShortIf_DropletFileContext * /*ctx*/) override { }

  virtual void enterStatementWithoutTrailingSubstatement_DropletFile(JavaParser::StatementWithoutTrailingSubstatement_DropletFileContext * /*ctx*/) override { }
  virtual void exitStatementWithoutTrailingSubstatement_DropletFile(JavaParser::StatementWithoutTrailingSubstatement_DropletFileContext * /*ctx*/) override { }

  virtual void enterEmptyStatement_DropletFile(JavaParser::EmptyStatement_DropletFileContext * /*ctx*/) override { }
  virtual void exitEmptyStatement_DropletFile(JavaParser::EmptyStatement_DropletFileContext * /*ctx*/) override { }

  virtual void enterLabeledStatement_DropletFile(JavaParser::LabeledStatement_DropletFileContext * /*ctx*/) override { }
  virtual void exitLabeledStatement_DropletFile(JavaParser::LabeledStatement_DropletFileContext * /*ctx*/) override { }

  virtual void enterLabeledStatementNoShortIf_DropletFile(JavaParser::LabeledStatementNoShortIf_DropletFileContext * /*ctx*/) override { }
  virtual void exitLabeledStatementNoShortIf_DropletFile(JavaParser::LabeledStatementNoShortIf_DropletFileContext * /*ctx*/) override { }

  virtual void enterExpressionStatement_DropletFile(JavaParser::ExpressionStatement_DropletFileContext * /*ctx*/) override { }
  virtual void exitExpressionStatement_DropletFile(JavaParser::ExpressionStatement_DropletFileContext * /*ctx*/) override { }

  virtual void enterStatementExpression_DropletFile(JavaParser::StatementExpression_DropletFileContext * /*ctx*/) override { }
  virtual void exitStatementExpression_DropletFile(JavaParser::StatementExpression_DropletFileContext * /*ctx*/) override { }

  virtual void enterIfThenStatement_DropletFile(JavaParser::IfThenStatement_DropletFileContext * /*ctx*/) override { }
  virtual void exitIfThenStatement_DropletFile(JavaParser::IfThenStatement_DropletFileContext * /*ctx*/) override { }

  virtual void enterIfThenElseStatement_DropletFile(JavaParser::IfThenElseStatement_DropletFileContext * /*ctx*/) override { }
  virtual void exitIfThenElseStatement_DropletFile(JavaParser::IfThenElseStatement_DropletFileContext * /*ctx*/) override { }

  virtual void enterIfThenElseStatementNoShortIf_DropletFile(JavaParser::IfThenElseStatementNoShortIf_DropletFileContext * /*ctx*/) override { }
  virtual void exitIfThenElseStatementNoShortIf_DropletFile(JavaParser::IfThenElseStatementNoShortIf_DropletFileContext * /*ctx*/) override { }

  virtual void enterAssertStatement_DropletFile(JavaParser::AssertStatement_DropletFileContext * /*ctx*/) override { }
  virtual void exitAssertStatement_DropletFile(JavaParser::AssertStatement_DropletFileContext * /*ctx*/) override { }

  virtual void enterSwitchStatement_DropletFile(JavaParser::SwitchStatement_DropletFileContext * /*ctx*/) override { }
  virtual void exitSwitchStatement_DropletFile(JavaParser::SwitchStatement_DropletFileContext * /*ctx*/) override { }

  virtual void enterSwitchBlock_DropletFile(JavaParser::SwitchBlock_DropletFileContext * /*ctx*/) override { }
  virtual void exitSwitchBlock_DropletFile(JavaParser::SwitchBlock_DropletFileContext * /*ctx*/) override { }

  virtual void enterSwitchBlockStatementGroup_DropletFile(JavaParser::SwitchBlockStatementGroup_DropletFileContext * /*ctx*/) override { }
  virtual void exitSwitchBlockStatementGroup_DropletFile(JavaParser::SwitchBlockStatementGroup_DropletFileContext * /*ctx*/) override { }

  virtual void enterSwitchLabels_DropletFile(JavaParser::SwitchLabels_DropletFileContext * /*ctx*/) override { }
  virtual void exitSwitchLabels_DropletFile(JavaParser::SwitchLabels_DropletFileContext * /*ctx*/) override { }

  virtual void enterSwitchLabel_DropletFile(JavaParser::SwitchLabel_DropletFileContext * /*ctx*/) override { }
  virtual void exitSwitchLabel_DropletFile(JavaParser::SwitchLabel_DropletFileContext * /*ctx*/) override { }

  virtual void enterEnumConstantName_DropletFile(JavaParser::EnumConstantName_DropletFileContext * /*ctx*/) override { }
  virtual void exitEnumConstantName_DropletFile(JavaParser::EnumConstantName_DropletFileContext * /*ctx*/) override { }

  virtual void enterWhileStatement_DropletFile(JavaParser::WhileStatement_DropletFileContext * /*ctx*/) override { }
  virtual void exitWhileStatement_DropletFile(JavaParser::WhileStatement_DropletFileContext * /*ctx*/) override { }

  virtual void enterWhileStatementNoShortIf_DropletFile(JavaParser::WhileStatementNoShortIf_DropletFileContext * /*ctx*/) override { }
  virtual void exitWhileStatementNoShortIf_DropletFile(JavaParser::WhileStatementNoShortIf_DropletFileContext * /*ctx*/) override { }

  virtual void enterDoStatement_DropletFile(JavaParser::DoStatement_DropletFileContext * /*ctx*/) override { }
  virtual void exitDoStatement_DropletFile(JavaParser::DoStatement_DropletFileContext * /*ctx*/) override { }

  virtual void enterForStatement_DropletFile(JavaParser::ForStatement_DropletFileContext * /*ctx*/) override { }
  virtual void exitForStatement_DropletFile(JavaParser::ForStatement_DropletFileContext * /*ctx*/) override { }

  virtual void enterForStatementNoShortIf_DropletFile(JavaParser::ForStatementNoShortIf_DropletFileContext * /*ctx*/) override { }
  virtual void exitForStatementNoShortIf_DropletFile(JavaParser::ForStatementNoShortIf_DropletFileContext * /*ctx*/) override { }

  virtual void enterBasicForStatement_DropletFile(JavaParser::BasicForStatement_DropletFileContext * /*ctx*/) override { }
  virtual void exitBasicForStatement_DropletFile(JavaParser::BasicForStatement_DropletFileContext * /*ctx*/) override { }

  virtual void enterBasicForStatementNoShortIf_DropletFile(JavaParser::BasicForStatementNoShortIf_DropletFileContext * /*ctx*/) override { }
  virtual void exitBasicForStatementNoShortIf_DropletFile(JavaParser::BasicForStatementNoShortIf_DropletFileContext * /*ctx*/) override { }

  virtual void enterForInit_DropletFile(JavaParser::ForInit_DropletFileContext * /*ctx*/) override { }
  virtual void exitForInit_DropletFile(JavaParser::ForInit_DropletFileContext * /*ctx*/) override { }

  virtual void enterForUpdate_DropletFile(JavaParser::ForUpdate_DropletFileContext * /*ctx*/) override { }
  virtual void exitForUpdate_DropletFile(JavaParser::ForUpdate_DropletFileContext * /*ctx*/) override { }

  virtual void enterStatementExpressionList_DropletFile(JavaParser::StatementExpressionList_DropletFileContext * /*ctx*/) override { }
  virtual void exitStatementExpressionList_DropletFile(JavaParser::StatementExpressionList_DropletFileContext * /*ctx*/) override { }

  virtual void enterEnhancedForStatement_DropletFile(JavaParser::EnhancedForStatement_DropletFileContext * /*ctx*/) override { }
  virtual void exitEnhancedForStatement_DropletFile(JavaParser::EnhancedForStatement_DropletFileContext * /*ctx*/) override { }

  virtual void enterEnhancedForStatementNoShortIf_DropletFile(JavaParser::EnhancedForStatementNoShortIf_DropletFileContext * /*ctx*/) override { }
  virtual void exitEnhancedForStatementNoShortIf_DropletFile(JavaParser::EnhancedForStatementNoShortIf_DropletFileContext * /*ctx*/) override { }

  virtual void enterBreakStatement_DropletFile(JavaParser::BreakStatement_DropletFileContext * /*ctx*/) override { }
  virtual void exitBreakStatement_DropletFile(JavaParser::BreakStatement_DropletFileContext * /*ctx*/) override { }

  virtual void enterContinueStatement_DropletFile(JavaParser::ContinueStatement_DropletFileContext * /*ctx*/) override { }
  virtual void exitContinueStatement_DropletFile(JavaParser::ContinueStatement_DropletFileContext * /*ctx*/) override { }

  virtual void enterReturnStatement_DropletFile(JavaParser::ReturnStatement_DropletFileContext * /*ctx*/) override { }
  virtual void exitReturnStatement_DropletFile(JavaParser::ReturnStatement_DropletFileContext * /*ctx*/) override { }

  virtual void enterThrowStatement_DropletFile(JavaParser::ThrowStatement_DropletFileContext * /*ctx*/) override { }
  virtual void exitThrowStatement_DropletFile(JavaParser::ThrowStatement_DropletFileContext * /*ctx*/) override { }

  virtual void enterSynchronizedStatement_DropletFile(JavaParser::SynchronizedStatement_DropletFileContext * /*ctx*/) override { }
  virtual void exitSynchronizedStatement_DropletFile(JavaParser::SynchronizedStatement_DropletFileContext * /*ctx*/) override { }

  virtual void enterTryStatement_DropletFile(JavaParser::TryStatement_DropletFileContext * /*ctx*/) override { }
  virtual void exitTryStatement_DropletFile(JavaParser::TryStatement_DropletFileContext * /*ctx*/) override { }

  virtual void enterCatches_DropletFile(JavaParser::Catches_DropletFileContext * /*ctx*/) override { }
  virtual void exitCatches_DropletFile(JavaParser::Catches_DropletFileContext * /*ctx*/) override { }

  virtual void enterCatchClause_DropletFile(JavaParser::CatchClause_DropletFileContext * /*ctx*/) override { }
  virtual void exitCatchClause_DropletFile(JavaParser::CatchClause_DropletFileContext * /*ctx*/) override { }

  virtual void enterCatchFormalParameter_DropletFile(JavaParser::CatchFormalParameter_DropletFileContext * /*ctx*/) override { }
  virtual void exitCatchFormalParameter_DropletFile(JavaParser::CatchFormalParameter_DropletFileContext * /*ctx*/) override { }

  virtual void enterCatchType_DropletFile(JavaParser::CatchType_DropletFileContext * /*ctx*/) override { }
  virtual void exitCatchType_DropletFile(JavaParser::CatchType_DropletFileContext * /*ctx*/) override { }

  virtual void enterFinally__DropletFile(JavaParser::Finally__DropletFileContext * /*ctx*/) override { }
  virtual void exitFinally__DropletFile(JavaParser::Finally__DropletFileContext * /*ctx*/) override { }

  virtual void enterTryWithResourcesStatement_DropletFile(JavaParser::TryWithResourcesStatement_DropletFileContext * /*ctx*/) override { }
  virtual void exitTryWithResourcesStatement_DropletFile(JavaParser::TryWithResourcesStatement_DropletFileContext * /*ctx*/) override { }

  virtual void enterResourceSpecification_DropletFile(JavaParser::ResourceSpecification_DropletFileContext * /*ctx*/) override { }
  virtual void exitResourceSpecification_DropletFile(JavaParser::ResourceSpecification_DropletFileContext * /*ctx*/) override { }

  virtual void enterResourceList_DropletFile(JavaParser::ResourceList_DropletFileContext * /*ctx*/) override { }
  virtual void exitResourceList_DropletFile(JavaParser::ResourceList_DropletFileContext * /*ctx*/) override { }

  virtual void enterResource_DropletFile(JavaParser::Resource_DropletFileContext * /*ctx*/) override { }
  virtual void exitResource_DropletFile(JavaParser::Resource_DropletFileContext * /*ctx*/) override { }

  virtual void enterVariableAccess_DropletFile(JavaParser::VariableAccess_DropletFileContext * /*ctx*/) override { }
  virtual void exitVariableAccess_DropletFile(JavaParser::VariableAccess_DropletFileContext * /*ctx*/) override { }

  virtual void enterPrimary_DropletFile(JavaParser::Primary_DropletFileContext * /*ctx*/) override { }
  virtual void exitPrimary_DropletFile(JavaParser::Primary_DropletFileContext * /*ctx*/) override { }

  virtual void enterPrimaryNoNewArray_DropletFile(JavaParser::PrimaryNoNewArray_DropletFileContext * /*ctx*/) override { }
  virtual void exitPrimaryNoNewArray_DropletFile(JavaParser::PrimaryNoNewArray_DropletFileContext * /*ctx*/) override { }

  virtual void enterPrimaryNoNewArray_lf_arrayAccess_DropletFile(JavaParser::PrimaryNoNewArray_lf_arrayAccess_DropletFileContext * /*ctx*/) override { }
  virtual void exitPrimaryNoNewArray_lf_arrayAccess_DropletFile(JavaParser::PrimaryNoNewArray_lf_arrayAccess_DropletFileContext * /*ctx*/) override { }

  virtual void enterPrimaryNoNewArray_lfno_arrayAccess_DropletFile(JavaParser::PrimaryNoNewArray_lfno_arrayAccess_DropletFileContext * /*ctx*/) override { }
  virtual void exitPrimaryNoNewArray_lfno_arrayAccess_DropletFile(JavaParser::PrimaryNoNewArray_lfno_arrayAccess_DropletFileContext * /*ctx*/) override { }

  virtual void enterPrimaryNoNewArray_lf_primary_DropletFile(JavaParser::PrimaryNoNewArray_lf_primary_DropletFileContext * /*ctx*/) override { }
  virtual void exitPrimaryNoNewArray_lf_primary_DropletFile(JavaParser::PrimaryNoNewArray_lf_primary_DropletFileContext * /*ctx*/) override { }

  virtual void enterPrimaryNoNewArray_lf_primary_lf_arrayAccess_lf_primary_DropletFile(JavaParser::PrimaryNoNewArray_lf_primary_lf_arrayAccess_lf_primary_DropletFileContext * /*ctx*/) override { }
  virtual void exitPrimaryNoNewArray_lf_primary_lf_arrayAccess_lf_primary_DropletFile(JavaParser::PrimaryNoNewArray_lf_primary_lf_arrayAccess_lf_primary_DropletFileContext * /*ctx*/) override { }

  virtual void enterPrimaryNoNewArray_lf_primary_lfno_arrayAccess_lf_primary_DropletFile(JavaParser::PrimaryNoNewArray_lf_primary_lfno_arrayAccess_lf_primary_DropletFileContext * /*ctx*/) override { }
  virtual void exitPrimaryNoNewArray_lf_primary_lfno_arrayAccess_lf_primary_DropletFile(JavaParser::PrimaryNoNewArray_lf_primary_lfno_arrayAccess_lf_primary_DropletFileContext * /*ctx*/) override { }

  virtual void enterPrimaryNoNewArray_lfno_primary_DropletFile(JavaParser::PrimaryNoNewArray_lfno_primary_DropletFileContext * /*ctx*/) override { }
  virtual void exitPrimaryNoNewArray_lfno_primary_DropletFile(JavaParser::PrimaryNoNewArray_lfno_primary_DropletFileContext * /*ctx*/) override { }

  virtual void enterPrimaryNoNewArray_lfno_primary_lf_arrayAccess_lfno_primary_DropletFile(JavaParser::PrimaryNoNewArray_lfno_primary_lf_arrayAccess_lfno_primary_DropletFileContext * /*ctx*/) override { }
  virtual void exitPrimaryNoNewArray_lfno_primary_lf_arrayAccess_lfno_primary_DropletFile(JavaParser::PrimaryNoNewArray_lfno_primary_lf_arrayAccess_lfno_primary_DropletFileContext * /*ctx*/) override { }

  virtual void enterPrimaryNoNewArray_lfno_primary_lfno_arrayAccess_lfno_primary_DropletFile(JavaParser::PrimaryNoNewArray_lfno_primary_lfno_arrayAccess_lfno_primary_DropletFileContext * /*ctx*/) override { }
  virtual void exitPrimaryNoNewArray_lfno_primary_lfno_arrayAccess_lfno_primary_DropletFile(JavaParser::PrimaryNoNewArray_lfno_primary_lfno_arrayAccess_lfno_primary_DropletFileContext * /*ctx*/) override { }

  virtual void enterClassLiteral_DropletFile(JavaParser::ClassLiteral_DropletFileContext * /*ctx*/) override { }
  virtual void exitClassLiteral_DropletFile(JavaParser::ClassLiteral_DropletFileContext * /*ctx*/) override { }

  virtual void enterClassInstanceCreationExpression_DropletFile(JavaParser::ClassInstanceCreationExpression_DropletFileContext * /*ctx*/) override { }
  virtual void exitClassInstanceCreationExpression_DropletFile(JavaParser::ClassInstanceCreationExpression_DropletFileContext * /*ctx*/) override { }

  virtual void enterClassInstanceCreationExpression_lf_primary_DropletFile(JavaParser::ClassInstanceCreationExpression_lf_primary_DropletFileContext * /*ctx*/) override { }
  virtual void exitClassInstanceCreationExpression_lf_primary_DropletFile(JavaParser::ClassInstanceCreationExpression_lf_primary_DropletFileContext * /*ctx*/) override { }

  virtual void enterClassInstanceCreationExpression_lfno_primary_DropletFile(JavaParser::ClassInstanceCreationExpression_lfno_primary_DropletFileContext * /*ctx*/) override { }
  virtual void exitClassInstanceCreationExpression_lfno_primary_DropletFile(JavaParser::ClassInstanceCreationExpression_lfno_primary_DropletFileContext * /*ctx*/) override { }

  virtual void enterTypeArgumentsOrDiamond_DropletFile(JavaParser::TypeArgumentsOrDiamond_DropletFileContext * /*ctx*/) override { }
  virtual void exitTypeArgumentsOrDiamond_DropletFile(JavaParser::TypeArgumentsOrDiamond_DropletFileContext * /*ctx*/) override { }

  virtual void enterFieldAccess_DropletFile(JavaParser::FieldAccess_DropletFileContext * /*ctx*/) override { }
  virtual void exitFieldAccess_DropletFile(JavaParser::FieldAccess_DropletFileContext * /*ctx*/) override { }

  virtual void enterFieldAccess_lf_primary_DropletFile(JavaParser::FieldAccess_lf_primary_DropletFileContext * /*ctx*/) override { }
  virtual void exitFieldAccess_lf_primary_DropletFile(JavaParser::FieldAccess_lf_primary_DropletFileContext * /*ctx*/) override { }

  virtual void enterFieldAccess_lfno_primary_DropletFile(JavaParser::FieldAccess_lfno_primary_DropletFileContext * /*ctx*/) override { }
  virtual void exitFieldAccess_lfno_primary_DropletFile(JavaParser::FieldAccess_lfno_primary_DropletFileContext * /*ctx*/) override { }

  virtual void enterArrayAccess_DropletFile(JavaParser::ArrayAccess_DropletFileContext * /*ctx*/) override { }
  virtual void exitArrayAccess_DropletFile(JavaParser::ArrayAccess_DropletFileContext * /*ctx*/) override { }

  virtual void enterArrayAccess_lf_primary_DropletFile(JavaParser::ArrayAccess_lf_primary_DropletFileContext * /*ctx*/) override { }
  virtual void exitArrayAccess_lf_primary_DropletFile(JavaParser::ArrayAccess_lf_primary_DropletFileContext * /*ctx*/) override { }

  virtual void enterArrayAccess_lfno_primary_DropletFile(JavaParser::ArrayAccess_lfno_primary_DropletFileContext * /*ctx*/) override { }
  virtual void exitArrayAccess_lfno_primary_DropletFile(JavaParser::ArrayAccess_lfno_primary_DropletFileContext * /*ctx*/) override { }

  virtual void enterMethodInvocation_DropletFile(JavaParser::MethodInvocation_DropletFileContext * /*ctx*/) override { }
  virtual void exitMethodInvocation_DropletFile(JavaParser::MethodInvocation_DropletFileContext * /*ctx*/) override { }

  virtual void enterMethodInvocation_lf_primary_DropletFile(JavaParser::MethodInvocation_lf_primary_DropletFileContext * /*ctx*/) override { }
  virtual void exitMethodInvocation_lf_primary_DropletFile(JavaParser::MethodInvocation_lf_primary_DropletFileContext * /*ctx*/) override { }

  virtual void enterMethodInvocation_lfno_primary_DropletFile(JavaParser::MethodInvocation_lfno_primary_DropletFileContext * /*ctx*/) override { }
  virtual void exitMethodInvocation_lfno_primary_DropletFile(JavaParser::MethodInvocation_lfno_primary_DropletFileContext * /*ctx*/) override { }

  virtual void enterArgumentList_DropletFile(JavaParser::ArgumentList_DropletFileContext * /*ctx*/) override { }
  virtual void exitArgumentList_DropletFile(JavaParser::ArgumentList_DropletFileContext * /*ctx*/) override { }

  virtual void enterMethodReference_DropletFile(JavaParser::MethodReference_DropletFileContext * /*ctx*/) override { }
  virtual void exitMethodReference_DropletFile(JavaParser::MethodReference_DropletFileContext * /*ctx*/) override { }

  virtual void enterMethodReference_lf_primary_DropletFile(JavaParser::MethodReference_lf_primary_DropletFileContext * /*ctx*/) override { }
  virtual void exitMethodReference_lf_primary_DropletFile(JavaParser::MethodReference_lf_primary_DropletFileContext * /*ctx*/) override { }

  virtual void enterMethodReference_lfno_primary_DropletFile(JavaParser::MethodReference_lfno_primary_DropletFileContext * /*ctx*/) override { }
  virtual void exitMethodReference_lfno_primary_DropletFile(JavaParser::MethodReference_lfno_primary_DropletFileContext * /*ctx*/) override { }

  virtual void enterArrayCreationExpression_DropletFile(JavaParser::ArrayCreationExpression_DropletFileContext * /*ctx*/) override { }
  virtual void exitArrayCreationExpression_DropletFile(JavaParser::ArrayCreationExpression_DropletFileContext * /*ctx*/) override { }

  virtual void enterDimExprs_DropletFile(JavaParser::DimExprs_DropletFileContext * /*ctx*/) override { }
  virtual void exitDimExprs_DropletFile(JavaParser::DimExprs_DropletFileContext * /*ctx*/) override { }

  virtual void enterDimExpr_DropletFile(JavaParser::DimExpr_DropletFileContext * /*ctx*/) override { }
  virtual void exitDimExpr_DropletFile(JavaParser::DimExpr_DropletFileContext * /*ctx*/) override { }

  virtual void enterConstantExpression_DropletFile(JavaParser::ConstantExpression_DropletFileContext * /*ctx*/) override { }
  virtual void exitConstantExpression_DropletFile(JavaParser::ConstantExpression_DropletFileContext * /*ctx*/) override { }

  virtual void enterExpression_DropletFile(JavaParser::Expression_DropletFileContext * /*ctx*/) override { }
  virtual void exitExpression_DropletFile(JavaParser::Expression_DropletFileContext * /*ctx*/) override { }

  virtual void enterLambdaExpression_DropletFile(JavaParser::LambdaExpression_DropletFileContext * /*ctx*/) override { }
  virtual void exitLambdaExpression_DropletFile(JavaParser::LambdaExpression_DropletFileContext * /*ctx*/) override { }

  virtual void enterLambdaParameters_DropletFile(JavaParser::LambdaParameters_DropletFileContext * /*ctx*/) override { }
  virtual void exitLambdaParameters_DropletFile(JavaParser::LambdaParameters_DropletFileContext * /*ctx*/) override { }

  virtual void enterInferredFormalParameterList_DropletFile(JavaParser::InferredFormalParameterList_DropletFileContext * /*ctx*/) override { }
  virtual void exitInferredFormalParameterList_DropletFile(JavaParser::InferredFormalParameterList_DropletFileContext * /*ctx*/) override { }

  virtual void enterLambdaBody_DropletFile(JavaParser::LambdaBody_DropletFileContext * /*ctx*/) override { }
  virtual void exitLambdaBody_DropletFile(JavaParser::LambdaBody_DropletFileContext * /*ctx*/) override { }

  virtual void enterAssignmentExpression_DropletFile(JavaParser::AssignmentExpression_DropletFileContext * /*ctx*/) override { }
  virtual void exitAssignmentExpression_DropletFile(JavaParser::AssignmentExpression_DropletFileContext * /*ctx*/) override { }

  virtual void enterAssignment_DropletFile(JavaParser::Assignment_DropletFileContext * /*ctx*/) override { }
  virtual void exitAssignment_DropletFile(JavaParser::Assignment_DropletFileContext * /*ctx*/) override { }

  virtual void enterLeftHandSide_DropletFile(JavaParser::LeftHandSide_DropletFileContext * /*ctx*/) override { }
  virtual void exitLeftHandSide_DropletFile(JavaParser::LeftHandSide_DropletFileContext * /*ctx*/) override { }

  virtual void enterAssignmentOperator_DropletFile(JavaParser::AssignmentOperator_DropletFileContext * /*ctx*/) override { }
  virtual void exitAssignmentOperator_DropletFile(JavaParser::AssignmentOperator_DropletFileContext * /*ctx*/) override { }

  virtual void enterConditionalExpression_DropletFile(JavaParser::ConditionalExpression_DropletFileContext * /*ctx*/) override { }
  virtual void exitConditionalExpression_DropletFile(JavaParser::ConditionalExpression_DropletFileContext * /*ctx*/) override { }

  virtual void enterConditionalOrExpression_DropletFile(JavaParser::ConditionalOrExpression_DropletFileContext * /*ctx*/) override { }
  virtual void exitConditionalOrExpression_DropletFile(JavaParser::ConditionalOrExpression_DropletFileContext * /*ctx*/) override { }

  virtual void enterConditionalAndExpression_DropletFile(JavaParser::ConditionalAndExpression_DropletFileContext * /*ctx*/) override { }
  virtual void exitConditionalAndExpression_DropletFile(JavaParser::ConditionalAndExpression_DropletFileContext * /*ctx*/) override { }

  virtual void enterInclusiveOrExpression_DropletFile(JavaParser::InclusiveOrExpression_DropletFileContext * /*ctx*/) override { }
  virtual void exitInclusiveOrExpression_DropletFile(JavaParser::InclusiveOrExpression_DropletFileContext * /*ctx*/) override { }

  virtual void enterExclusiveOrExpression_DropletFile(JavaParser::ExclusiveOrExpression_DropletFileContext * /*ctx*/) override { }
  virtual void exitExclusiveOrExpression_DropletFile(JavaParser::ExclusiveOrExpression_DropletFileContext * /*ctx*/) override { }

  virtual void enterAndExpression_DropletFile(JavaParser::AndExpression_DropletFileContext * /*ctx*/) override { }
  virtual void exitAndExpression_DropletFile(JavaParser::AndExpression_DropletFileContext * /*ctx*/) override { }

  virtual void enterEqualityExpression_DropletFile(JavaParser::EqualityExpression_DropletFileContext * /*ctx*/) override { }
  virtual void exitEqualityExpression_DropletFile(JavaParser::EqualityExpression_DropletFileContext * /*ctx*/) override { }

  virtual void enterRelationalExpression_DropletFile(JavaParser::RelationalExpression_DropletFileContext * /*ctx*/) override { }
  virtual void exitRelationalExpression_DropletFile(JavaParser::RelationalExpression_DropletFileContext * /*ctx*/) override { }

  virtual void enterShiftExpression_DropletFile(JavaParser::ShiftExpression_DropletFileContext * /*ctx*/) override { }
  virtual void exitShiftExpression_DropletFile(JavaParser::ShiftExpression_DropletFileContext * /*ctx*/) override { }

  virtual void enterAdditiveExpression_DropletFile(JavaParser::AdditiveExpression_DropletFileContext * /*ctx*/) override { }
  virtual void exitAdditiveExpression_DropletFile(JavaParser::AdditiveExpression_DropletFileContext * /*ctx*/) override { }

  virtual void enterMultiplicativeExpression_DropletFile(JavaParser::MultiplicativeExpression_DropletFileContext * /*ctx*/) override { }
  virtual void exitMultiplicativeExpression_DropletFile(JavaParser::MultiplicativeExpression_DropletFileContext * /*ctx*/) override { }

  virtual void enterUnaryExpression_DropletFile(JavaParser::UnaryExpression_DropletFileContext * /*ctx*/) override { }
  virtual void exitUnaryExpression_DropletFile(JavaParser::UnaryExpression_DropletFileContext * /*ctx*/) override { }

  virtual void enterPreIncrementExpression_DropletFile(JavaParser::PreIncrementExpression_DropletFileContext * /*ctx*/) override { }
  virtual void exitPreIncrementExpression_DropletFile(JavaParser::PreIncrementExpression_DropletFileContext * /*ctx*/) override { }

  virtual void enterPreDecrementExpression_DropletFile(JavaParser::PreDecrementExpression_DropletFileContext * /*ctx*/) override { }
  virtual void exitPreDecrementExpression_DropletFile(JavaParser::PreDecrementExpression_DropletFileContext * /*ctx*/) override { }

  virtual void enterUnaryExpressionNotPlusMinus_DropletFile(JavaParser::UnaryExpressionNotPlusMinus_DropletFileContext * /*ctx*/) override { }
  virtual void exitUnaryExpressionNotPlusMinus_DropletFile(JavaParser::UnaryExpressionNotPlusMinus_DropletFileContext * /*ctx*/) override { }

  virtual void enterPostfixExpression_DropletFile(JavaParser::PostfixExpression_DropletFileContext * /*ctx*/) override { }
  virtual void exitPostfixExpression_DropletFile(JavaParser::PostfixExpression_DropletFileContext * /*ctx*/) override { }

  virtual void enterPostIncrementExpression_DropletFile(JavaParser::PostIncrementExpression_DropletFileContext * /*ctx*/) override { }
  virtual void exitPostIncrementExpression_DropletFile(JavaParser::PostIncrementExpression_DropletFileContext * /*ctx*/) override { }

  virtual void enterPostIncrementExpression_lf_postfixExpression_DropletFile(JavaParser::PostIncrementExpression_lf_postfixExpression_DropletFileContext * /*ctx*/) override { }
  virtual void exitPostIncrementExpression_lf_postfixExpression_DropletFile(JavaParser::PostIncrementExpression_lf_postfixExpression_DropletFileContext * /*ctx*/) override { }

  virtual void enterPostDecrementExpression_DropletFile(JavaParser::PostDecrementExpression_DropletFileContext * /*ctx*/) override { }
  virtual void exitPostDecrementExpression_DropletFile(JavaParser::PostDecrementExpression_DropletFileContext * /*ctx*/) override { }

  virtual void enterPostDecrementExpression_lf_postfixExpression_DropletFile(JavaParser::PostDecrementExpression_lf_postfixExpression_DropletFileContext * /*ctx*/) override { }
  virtual void exitPostDecrementExpression_lf_postfixExpression_DropletFile(JavaParser::PostDecrementExpression_lf_postfixExpression_DropletFileContext * /*ctx*/) override { }

  virtual void enterCastExpression_DropletFile(JavaParser::CastExpression_DropletFileContext * /*ctx*/) override { }
  virtual void exitCastExpression_DropletFile(JavaParser::CastExpression_DropletFileContext * /*ctx*/) override { }

  virtual void enterIdentifier(JavaParser::IdentifierContext * /*ctx*/) override { }
  virtual void exitIdentifier(JavaParser::IdentifierContext * /*ctx*/) override { }


  virtual void enterEveryRule(antlr4::ParserRuleContext * /*ctx*/) override { }
  virtual void exitEveryRule(antlr4::ParserRuleContext * /*ctx*/) override { }
  virtual void visitTerminal(antlr4::tree::TerminalNode * /*node*/) override { }
  virtual void visitErrorNode(antlr4::tree::ErrorNode * /*node*/) override { }

};

