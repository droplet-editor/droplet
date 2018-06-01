# Droplet C# mode
#
# Copyright (c) 2018 Kevin Jessup
# MIT License

helper = require '../helper.coffee'
parser = require '../parser.coffee'
antlrHelper = require '../antlr.coffee'

model = require '../model.coffee'

{fixQuotedString, looseCUnescape, quoteAndCEscape} = helper

ADD_BUTTON = [
  {
    key: 'add-button'
    glyph: '\u25B6'
    border: false
  }
]

BOTH_BUTTON = [
  {
    key: 'subtract-button'
    glyph: '\u25C0'
    border: false
  }
  {
    key: 'add-button'
    glyph: '\u25B6'
    border: false
  }
]

ADD_BUTTON_VERT = [
  {
    key: 'add-button'
    glyph: '\u25BC'
    border: false
  }
]

BOTH_BUTTON_VERT = [
  {
    key: 'subtract-button'
    glyph: '\u25B2'
    border: false
  }
  {
    key: 'add-button'
    glyph: '\u25BC'
    border: false
  }
]

# TODO: all the stuff below this
# TODO: WIP => import statements (using...)

RULES = {
  # Skips : no block for these elements
  'compilation_unit' : 'skip',
  'namespace_or_type_name' : 'skip',
  'type' : 'skip',
  'base_type' : 'skip',
  'simple_type' : 'skip',
  'numeric_type' : 'skip',
  'integral_type' : 'skip',
  'floating_point_type' : 'skip',
  'class_type' : 'skip',
  'type_argument_list' : 'skip',
  'argument_list' : 'skip',
  'argument' : 'skip',
  'expression' : 'skip',
  'non_assignment_expression' : 'skip',
  'assignment' : 'skip',
  'assignment_operator' : 'skip',
  'conditional_expression' : 'skip',
  'null_coalescing_expression' : 'skip',
  'conditional_or_expression' : 'skip',
  'conditional_and_expression' : 'skip',
  'inclusive_or_expression' : 'skip',
  'exclusive_or_expression' : 'skip',
  'and_expression' : 'skip',
  'equality_expression' : 'skip',
  'relational_expression' : 'skip',
  'shift_expression' : 'skip',
  'additive_expression' : 'skip',
  'multiplicative_expression' : 'skip',
  'unary_expression' : 'skip',
  'primary_expression' : 'skip',
  'primary_expression_start' : 'skip',
  'member_access' : 'skip',
  'bracket_expression' : 'skip',
  'indexer_argument' : 'skip',
  'predefined_type' : 'skip',
  'expression_list' : 'skip',
  'object_or_collection_initializer' : 'skip',
  'object_initializer' : 'skip',
  'member_initializer_list' : 'skip',
  'member_initializer' : 'skip',
  'initializer_value' : 'skip',
  'collection_initializer' : 'skip',
  'element_initializer' : 'skip',
  'anonymous_object_initializer' : 'skip',
  'member_declarator_list' : 'skip',
  'member_declarator' : 'skip',
  'unbound_type_name' : 'skip',
  'generic_dimension_specifier' : 'skip',
  'isType' : 'skip',
  'lambda_expression' : 'skip',
  'anonymous_function_signature' : 'skip',
  'explicit_anonymous_function_parameter_list' : 'skip',
  'explicit_anonymous_function_parameter' : 'skip',
  'implicit_anonymous_function_parameter_list' : 'skip',
  'anonymous_function_body' : 'skip',
  'query_expression' : 'skip',
  'from_clause' : 'skip',
  'query_body' : 'skip',
  'query_body_clause' : 'skip',
  'let_clause' : 'skip',
  'where_clause' : 'skip',
  'combined_join_clause' : 'skip',
  'orderby_clause' : 'skip',
  'ordering' : 'skip',
  'select_or_group_clause' : 'skip',
  'query_continuation' : 'skip',
  'statement' : 'skip',
  'labeled_Statement' : 'skip',
  'embedded_statement' : 'skip',
  'simple_embedded_statement' : 'skip',
  'block' : 'skip',
  'local_variable_declaration' : 'skip',
  'local_variable_type' : 'skip',
  'local_variable_declarator' : 'skip',
  'local_variable_initializer' : 'skip',
  'local_constant_declaration' : 'skip',
  'if_body' : 'skip',
  'switch_section' : 'skip',
  'switch_label' : 'skip',
  'statement_list' : 'skip',
  'for_initializer' : 'skip',
  'for_iterator' : 'skip',
  'catch_clauses' : 'skip',
  'specific_catch_clause' : 'skip',
  'general_catch_clause' : 'skip',
  'exception_filter' : 'skip',
  'finally_clause' : 'skip',
  'resource_acquisition' : 'skip',
  'namespace_declaration' : 'skip',
  'qualified_identifier' : 'skip',
  'namespace_body' : 'skip',
  'extern_alias_directives' : 'skip',
  'extern_alias_directive' : 'skip',
  'using_directives' : 'skip',
  'using_directive' : 'skip',
  'namespace_member_declarations' : 'skip',
  'namespace_member_declaration' : 'skip',
  'type_declaration' : 'skip',
  'qualified_alias_member' : 'skip',
  'type_parameter_list' : 'skip',
  'type_parameter' : 'skip',
  'class_base' : 'skip',
  'interface_type_list' : 'skip',
  'type_parameter_constraints_clauses' : 'skip',
  'type_parameter_constraints_clause' : 'skip',
  'type_parameter_constraints' : 'skip',
  'primary_constraint' : 'skip',
  'secondary_constraints' : 'skip',
  'constructor_constraint' : 'skip',
  'class_body' : 'skip',
  'class_member_declarations' : 'skip',
  'class_member_declaration' : 'skip',
  'all_member_modifiers' : 'skip',
  'all_member_modifier' : 'skip',
  'common_member_declaration' : 'skip',
  'typed_member_declaration' : 'skip',
  'constant_declarators' : 'skip',
  'constant_declarator' : 'skip',
  'variable_declarators' : 'skip',
  'variable_declarator' : 'skip',
  'variable_initializer' : 'skip',
  'return_type' : 'skip',
  'member_name' : 'skip',
  'method_body' : 'skip',
  'formal_parameter_list' : 'skip',
  'fixed_parameters' : 'skip',
  'fixed_parameter' : 'skip',
  'parameter_modifier' : 'skip',
  'parameter_array' : 'skip',
  'accessor_declarations' : 'skip',
  'get_accessor_declaration' : 'skip',
  'set_accessor_declaration' : 'skip',
  'accessor_modifier' : 'skip',
  'accessor_body' : 'skip',
  'event_accessor_declarations' : 'skip',
  'add_accessor_declaration' : 'skip',
  'remove_accessor_declaration' : 'skip',
  'overloadable_operator' : 'skip',
  'conversion_operator_declarator' : 'skip',
  'constructor_initializer' : 'skip',
  'body' : 'skip',
  'struct_interfaces' : 'skip',
  'struct_body' : 'skip',
  'struct_member_declaration' : 'skip',
  'array_type' : 'skip',
  'rank_specifier' : 'skip',
  'array_initializer' : 'skip',
  'variant_type_parameter_list' : 'skip',
  'variant_type_parameter' : 'skip',
  'variance_annotation' : 'skip',
  'interface_base' : 'skip',
  'interface_body' : 'skip',
  'interface_member_declaration' : 'skip',
  'interface_accessors' : 'skip',
  'enum_base' : 'skip',
  'enum_body' : 'skip',
  'enum_member_declaration' : 'skip',
  'global_attribute_section' : 'skip',
  'global_attribute_target' : 'skip',
  'attributes' : 'skip',
  'attribute_section' : 'skip',
  'attribute_target' : 'skip',
  'attribute_list' : 'skip',
  'attribute' : 'skip',
  'attribute_argument' : 'skip',
  'pointer_type' : 'skip',
  'fixed_pointer_declarators' : 'skip',
  'fixed_pointer_declarator' : 'skip',
  'fixed_pointer_initializer' : 'skip',
  'fixed_size_buffer_declarator' : 'skip',
  'local_variable_initializer_unsafe' : 'skip',
  'right_arrow' : 'skip',
  'right_shift' : 'skip',
  'right_shift_assignment' : 'skip',
  'literal' : 'skip',
  'boolean_literal' : 'skip',
  'string_literal' : 'skip',
  'interpolated_regular_string' : 'skip',
  'interpolated_verbatium_string' : 'skip',
  'interpolated_regular_string_part' : 'skip',
  'interpolated_verbatium_string_part' : 'skip',
  'interpolated_string_expression' : 'skip',
  'keyword' : 'skip',
  'class_definition' : 'skip',
  'struct_definition' : 'skip',
  'interface_definition' : 'skip',
  'enum_definition' : 'skip',
  'delegate_definition' : 'skip',
  'event_declaration' : 'skip',
  'field_declaration' : 'skip',
  'property_declaration' : 'skip',
  'constant_declaration' : 'skip',
  'indexer_declaration' : 'skip',
  'destructor_definition' : 'skip',
  'constructor_declaration' : 'skip',
  'method_declaration' : 'skip',
  'method_member_name' : 'skip',
  'operator_declaration' : 'skip',
  'arg_declaration' : 'skip',
  'method_invocation' : 'skip',
  'object_creation_expression' : 'skip',
  'identifier' : 'skip',

 # 'compilation_unit' : 'skip'
  #'using_directives' : 'skip'

# Indents: these elements should have indentation

# 'using_directive': (node) ->
#   if node.label is 'usingNamespaceDirective'
#    return 'socket'

# Sockets : can be used to enter inputs into a form or specify types
#  'using_directive': (node) ->
 #   sockets =  [
 #     node.children[1].children[0].children[0]]
  #  color = 'purple'

 #   return {sockets, color}

 # 'local_variable_declaration' : {type: 'block', buttons: BOTH_BUTTON}
}

COLOR_DEFAULTS = {

}

COLOR_RULES = {
# 'using_directive': 'declaration'
}

SHAPE_RULES = {
#'using_directive' : helper.BLOCK_ONLY # e.g. 'using System;'
 # 'local_variable_declaration' : helper.BLOCK_ONLY
}

NATIVE_TYPES = [
#  'int' # TODO: flesh out types
]

EMPTY_STRINGS = {

}

COLOR_CALLBACK = {

}

SHAPE_CALLBACK = {

}

COLOR_DEFAULTS = {

}

MODIFIERS = {


}

DROPDOWNS = {

}

EMPTY_STRINGS = { }

SHOULD_SOCKET = (opts, node) ->
  return true

PARENS = [ ]

config = {
  RULES, COLOR_DEFAULTS, COLOR_RULES, COLOR_CALLBACK, SHAPE_RULES, SHAPE_CALLBACK, NATIVE_TYPES, EMPTY_STRINGS,
  COLOR_DEFAULTS, MODIFIERS, DROPDOWNS, EMPTY_STRINGS, SHOULD_SOCKET, PARENS
}

config.rootContext = 'compilation_unit'

module.exports = parser.wrapParser antlrHelper.createANTLRParser 'CSharp', config