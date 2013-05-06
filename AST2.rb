require 'Magia'

module Yisiel; end

$ast_type_tree = [
  ["AST"        , %w[                                                  ], [
    ["Prog"     , %w[definiciones procedimientos instrucciones         ], []],
    ["Def"      , %w[ident line col                                    ], [
      ["Value"  , %w[                                                  ], []],
      ["Array"  , %w[size                                              ], []]
    ]],
    ["Proc"     , %w[ident line col parametros definiciones instruccion], []],
    ["Param"    , %w[ident line col                                    ], [
      ["In"     , %w[                                                  ], []],
      ["Out"    , %w[                                                  ], []],
    ]],
    ["Stmt"     , %w[                                                  ], [
      ["Skip"   , %w[                                                  ], []],
      ["Set"    , %w[lvalues expresiones                               ], []],
      ["If"     , %w[casos                                             ], []],
      ["Do"     , %w[casos                                             ], []],
      ["Block"  , %w[instrucciones                                     ], []],
      ["Call"   , %w[ident line col expresiones                        ], []],
      ["Ret"    , %w[                                                  ], []],
      ["Show"   , %w[                                                  ], [
        ["Math" , %w[expresion                                         ], []],
        ["Str"  , %w[string                                            ], []]
      ]]
    ]],
    ["LValue"   , %w[                                                  ], [
      ["Value"  , %w[ident line col                                    ], []],
      ["Array"  , %w[ident line col expresion                          ], []]
    ]],
    ["Caso"     , %w[predicado instruccion                             ], []],
    ["Math"     , %w[                                                  ], [
      ["Add"    , %w[lhs rhs                                           ], []],
      ["Sub"    , %w[lhs rhs                                           ], []],
      ["Mod"    , %w[lhs rhs                                           ], []],
      ["Prod"   , %w[lhs rhs                                           ], []],
      ["Div"    , %w[lhs rhs                                           ], []],
      ["Num"    , %w[numero                                            ], []],
      ["Neg"    , %w[expresion                                         ], []],
      ["Size"   , %w[ident line col                                    ], []],
      ["Def"    , %w[                                                  ], [
        ["Value", %w[ident line col                                    ], []],
        ["Array", %w[ident line col expresion                          ], []]
      ]]
    ]],
    ["Bool"     , %w[                                                  ], [
      ["L"      , %w[lhs rhs                                           ], []],
      ["LE"     , %w[lhs rhs                                           ], []],
      ["G"      , %w[lhs rhs                                           ], []],
      ["GE"     , %w[lhs rhs                                           ], []],
      ["E"      , %w[lhs rhs                                           ], []],
      ["NE"     , %w[lhs rhs                                           ], []],
      ["And"    , %w[lhs rhs                                           ], []],
      ["Or"     , %w[lhs rhs                                           ], []],
      ["Not"    , %w[predicado                                         ], []],
      ["True"   , %w[                                                  ], []],
      ["False"  , %w[                                                  ], []]
    ]]
  ]]
]

# Definición de todos los tipos usados por el árbol.
Magia::define_types($ast_type_tree, Yisiel)

class Yisiel::AST
# def check; end
# def run  ; end
end

