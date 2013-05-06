require 'Magia'

module Yisiel; end

$ast_type_tree = [
  ["Programa"     , %w[definiciones procedimientos instrucciones         ], []],
  ["Definicion"   , %w[ident line col                                    ], [
    ["Value"      , %w[                                                  ], []],
    ["Array"      , %w[size                                              ], []]
  ]],
  ["Procedimiento", %w[ident line col parametros definiciones instruccion], []],
  ["Parametro"    , %w[ident line col                                    ], [
    ["In"         , %w[                                                  ], []],
    ["Out"        , %w[                                                  ], []],
  ]],
  ["Instruccion"  , %w[                                                  ], [
    ["Vacia"      , %w[                                                  ], []],
    ["Asignacion" , %w[lvalues expresiones                               ], []],
    ["Seleccion"  , %w[casos                                             ], []],
    ["Repeticion" , %w[casos                                             ], []],
    ["Bloque"     , %w[instrucciones                                     ], []],
    ["Invocar"    , %w[ident line col expresiones                        ], []],
    ["Return"     , %w[                                                  ], []],
    ["Show"       , %w[                                                  ], [
      ["Expresion", %w[expresion                                         ], []],
      ["String"   , %w[string                                            ], []]
    ]]
  ]],
  ["LValue"       , %w[                                                  ], [
    ["Value"      , %w[ident line col                                    ], []],
    ["Array"      , %w[ident line col expresion                          ], []]
  ]],
  ["Caso"         , %w[predicado instruccion                             ], []],
  ["Expresion"    , %w[                                                  ], [
    ["Suma"       , %w[lhs rhs                                           ], []],
    ["Resta"      , %w[lhs rhs                                           ], []],
    ["Residuo"    , %w[lhs rhs                                           ], []],
    ["Producto"   , %w[lhs rhs                                           ], []],
    ["Division"   , %w[lhs rhs                                           ], []],
    ["Numero"     , %w[numero                                            ], []],
    ["Negativo"   , %w[expresion                                         ], []],
    ["Longitud"   , %w[ident line col                                    ], []],
    ["Definido"   , %w[                                                  ], [
      ["Value"    , %w[ident line col                                    ], []],
      ["Array"    , %w[ident line col expresion                          ], []]
    ]]
  ]],
  ["Predicado"    , %w[                                                  ], [
    ["Menor"      , %w[lhs rhs                                           ], []],
    ["MenorIgual" , %w[lhs rhs                                           ], []],
    ["Mayor"      , %w[lhs rhs                                           ], []],
    ["MayorIgual" , %w[lhs rhs                                           ], []],
    ["Igual"      , %w[lhs rhs                                           ], []],
    ["NoIgual"    , %w[lhs rhs                                           ], []],
    ["And"        , %w[lhs rhs                                           ], []],
    ["Or"         , %w[lhs rhs                                           ], []],
    ["Not"        , %w[predicado                                         ], []],
    ["True"       , %w[                                                  ], []],
    ["False"      , %w[                                                  ], []]
  ]]
]

# Definición de todos los tipos usados por el árbol.
module Yisiel
  Magia::define_types($ast_type_tree, Yisiel)
end

