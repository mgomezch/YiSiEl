class Yisiel::Parser
  token '+' '-' '*' '/' '<=' '>=' '!=' '&&' 'end'  'main' 'array' 'num'
        '%' ',' ';' ':' '||' '<-' '->' 'as' 'out'  'proc' 'begin' 'return'
        '$' '~' '=' '>' 'do' 'fi' 'id' 'if' 'var'  'show' 'false' 'string'
        '<' '(' ')' '[' ']'  '|'  'in' 'od' 'of'   'skip' 'true'  'value'
        UMINUS UPLUS

  prechigh
    right    '~'
    nonassoc UMINUS UPLUS
    left     '*' '/' '%'
    left     '+' '-'
    left     ','
    nonassoc '&&'
    nonassoc '||'
    nonassoc '<' '<=' '>' '>='
    nonassoc '=' '!='
    nonassoc '<-'
    nonassoc 'show'
  preclow

  convert
    '+'      'TkSuma'
    '-'      'TkResta'
    '*'      'TkProducto'
    '/'      'TkDivision'
    '%'      'TkResiduo'
    ','      'TkComa'
    ';'      'TkSeq'
    ':'      'TkDosPuntos'
    '$'      'TkDolar'
    '~'      'TkNot'
    '='      'TkIgual'
    '>'      'TkMayor'
    '<'      'TkMenor'
    '('      'TkPAbre'
    ')'      'TkPCierra'
    '['      'TkCAbre'
    ']'      'TkCCierra'
    '|'      'TkPipe'
    '<='     'TkMenorIgual'
    '>='     'TkMayorIgual'
    '!='     'TkNoIgual'
    '&&'     'TkAnd'
    '||'     'TkOr'
    '<-'     'TkAsignacion'
    '->'     'TkGuardia'
    'end'    'TkEnd'
    'num'    'TkNum'
    'true'   'TkTrue'
    'false'  'TkFalse'
    'return' 'TkReturn'
    'string' 'TkStr'
    'array'  'TkArray'
    'begin'  'TkBegin'
    'value'  'TkValue'
    'main'   'TkMain'
    'proc'   'TkProc'
    'show'   'TkShow'
    'skip'   'TkSkip'
    'out'    'TkOut'
    'var'    'TkVar'
    'as'     'TkAs'
    'do'     'TkDo'
    'fi'     'TkFi'
    'id'     'TkId'
    'if'     'TkIf'
    'in'     'TkIn'
    'od'     'TkOd'
    'of'     'TkOf'
  end

  start Programa
rule
       Programa: Definiciones Procedimientos 'main' MInstrucciones 'end'       { result =                 Programa::new(val[0], val[1], val[3])                                       ; r "      Programa -> Definiciones Procedimientos main MInstrucciones end"                  }
               | Definiciones                'main' MInstrucciones 'end'       { result =                 Programa::new(val[0], []    , val[2])                                       ; r "      Programa -> Definiciones main MInstrucciones end"                                 }
               |              Procedimientos 'main' MInstrucciones 'end'       { result =                 Programa::new([]    , val[0], val[2])                                       ; r "      Programa -> Procedimientos main MInstrucciones end"                               }
               |                             'main' MInstrucciones 'end'       { result =                 Programa::new([]    , []    , val[1])                                       ; r "      Programa -> main MInstrucciones end"                                              }
               ;
   Definiciones: Definiciones Definicion                                       { result = val[0] + val[1]                                                                             ; r "  Definiciones -> Definiciones Definicion"                                              }
               |              Definicion                                       { result =          val[0]                                                                             ; r "  Definiciones -> Definicion"                                                           }
               ;
     Definicion: 'var' IDs ':' 'value'                                         { result = val[1].map { |ident| DefinicionValue::new(ident.code, ident.line, ident.col) }              ; r "    Definicion -> var IDs : value"                                                      }
               | 'var' IDs ':' 'array' 'of' 'num'                              { result = val[1].map { |ident| DefinicionArray::new(ident.code, ident.line, ident.col, val[5].code) } ; r "    Definicion -> var IDs : array of TkNum(#{val[5].code})"                             }
               ;
            IDs: IDs ',' 'id'                                                  { result = val[0] + [val[2]]                                                                           ; r "           IDs -> IDs , TkId(#{val[2].code})"                                           }
               |         'id'                                                  { result =          [val[0]]                                                                           ; r "           IDs -> TkId(#{val[0].code})"                                                 }
               ;
 Procedimientos: Procedimientos Procedimiento                                  { result = val[0] + [val[1]]                                                                           ; r "Procedimientos -> Procedimientos Procedimiento"                                         }
               |                Procedimiento                                  { result =          [val[0]]                                                                           ; r "Procedimientos -> Procedimiento"                                                        }
               ;
  Procedimiento: 'proc' 'id' '(' Parametros ')' 'as' Definiciones PInstruccion { result =            Procedimiento::new(val[1].code, val[1].line, val[1].col, val[3], val[6], val[7]) ; r " Procedimiento -> proc TkId(#{val[1].code}) ( Parametros ) as Definiciones PInstruccion"}
               | 'proc' 'id' '(' Parametros ')' 'as'              PInstruccion { result =            Procedimiento::new(val[1].code, val[1].line, val[1].col, val[3], []    , val[6]) ; r " Procedimiento -> proc TkId(#{val[1].code}) ( Parametros ) as PInstruccion"             }
               | 'proc' 'id' '('            ')' 'as' Definiciones PInstruccion { result =            Procedimiento::new(val[1].code, val[1].line, val[1].col, []    , val[5], val[6]) ; r " Procedimiento -> proc TkId(#{val[1].code}) ( ) as Definiciones PInstruccion"           }
               | 'proc' 'id' '('            ')' 'as'              PInstruccion { result =            Procedimiento::new(val[1].code, val[1].line, val[1].col, []    , []    , val[5]) ; r " Procedimiento -> proc TkId(#{val[1].code}) ( ) as PInstruccion"                        }
               ;
     Parametros: Parametros ',' Parametro                                      { result = val[0] + [val[2]]                                                                           ; r "    Parametros -> Parametros , Parametro"                                               }
               |                Parametro                                      { result =          [val[0]]                                                                           ; r "    Parametros -> Parametro"                                                            }
               ;
      Parametro: 'in'  'id'                                                    { result =              ParametroIn::new(val[1].code, val[1].line, val[1].col)                         ; r "     Parametro -> in  TkId(#{val[1].code})"                                             }
               | 'out' 'id'                                                    { result =             ParametroOut::new(val[1].code, val[1].line, val[1].col)                         ; r "     Parametro -> out TkId(#{val[1].code})"                                             }
               ;
 MInstrucciones: MInstrucciones ';' MInstruccion                               { result = val[0] + [val[2]]                                                                           ; r "MInstrucciones -> MInstrucciones ; MInstruccion"                                        }
               |                    MInstruccion                               { result =          [val[0]]                                                                           ; r "MInstrucciones -> MInstruccion"                                                         }
               ;
   MInstruccion: 'skip'                                                        { result =         InstruccionVacia::new                                                               ; r "  MInstruccion -> skip"                                                                 }
               | Asignaciones                                                  { result =    InstruccionAsignacion::new(val[0].transpose[0], val[0].transpose[1])                     ; r "  MInstruccion -> Asignaciones"                                                         }
               | 'if' MCasos 'fi'                                              { result =     InstruccionSeleccion::new(val[1])                                                       ; r "  MInstruccion -> if MCasos fi"                                                         }
               | 'do' MCasos 'od'                                              { result =    InstruccionRepeticion::new(val[1])                                                       ; r "  MInstruccion -> do MCasos od"                                                         }
               | 'begin' MInstrucciones 'end'                                  { result =        InstruccionBloque::new(val[1])                                                       ; r "  MInstruccion -> begin MInstrucciones end"                                             }
               | 'id' '(' Expresiones ')'                                      { result =       InstruccionInvocar::new(val[0].code, val[0].line, val[0].col, val[2])                 ; r "  MInstruccion -> TkId(#{val[0].code}) ( Expresiones )"                                 }
               | 'id' '(' ')'                                                  { result =       InstruccionInvocar::new(val[0].code, val[0].line, val[0].col, [])                     ; r "  MInstruccion -> TkId(#{val[0].code}) ( )"                                             }
               | 'show' Expresion                                              { result = InstruccionShowExpresion::new(val[1])                                                       ; r "  MInstruccion -> show Expresion"                                                       }
               | 'show' 'string'                                               { result =    InstruccionShowString::new(val[1].code)                                                  ; r "  MInstruccion -> show string"                                                          }
               ;
 PInstrucciones: PInstrucciones ';' PInstruccion                               { result = val[0] + [val[2]]                                                                           ; r "PInstrucciones -> PInstrucciones ; PInstruccion"                                        }
               |                    PInstruccion                               { result =          [val[0]]                                                                           ; r "PInstrucciones -> PInstruccion"                                                         }
               ;
   PInstruccion: 'skip'                                                        { result =         InstruccionVacia::new                                                               ; r "  PInstruccion -> skip"                                                                 }
               | Asignaciones                                                  { result =    InstruccionAsignacion::new(val[0].transpose[0], val[0].transpose[1])                     ; r "  PInstruccion -> Asignaciones"                                                         }
               | 'if' PCasos 'fi'                                              { result =     InstruccionSeleccion::new(val[1])                                                       ; r "  PInstruccion -> if PCasos fi"                                                         }
               | 'do' PCasos 'od'                                              { result =    InstruccionRepeticion::new(val[1])                                                       ; r "  PInstruccion -> do PCasos od"                                                         }
               | 'begin' PInstrucciones 'end'                                  { result =        InstruccionBloque::new(val[1])                                                       ; r "  PInstruccion -> begin PInstrucciones end"                                             }
               | 'id' '(' Expresiones ')'                                      { result =       InstruccionInvocar::new(val[0].code, val[0].line, val[0].col, val[2])                 ; r "  PInstruccion -> TkId(#{val[0].code}) ( Expresiones )"                                 }
               | 'id' '(' ')'                                                  { result =       InstruccionInvocar::new(val[0].code, val[0].line, val[0].col, [])                     ; r "  PInstruccion -> TkId(#{val[0].code}) ( )"                                             }
               | 'show' Expresion                                              { result = InstruccionShowExpresion::new(val[1])                                                       ; r "  PInstruccion -> show Expresion"                                                       }
               | 'show' 'string'                                               { result =    InstruccionShowString::new(val[1].code)                                                  ; r "  PInstruccion -> show string"                                                          }
               | 'return'                                                      { result =        InstruccionReturn::new()                                                             ; r "  PInstruccion -> return"                                                               }
               ;
    Expresiones: Expresiones ',' Expresion                                     { result = val[0] + [val[2]]                                                                           ; r "   Expresiones -> Expresiones , Expresion"                                              }
               |                 Expresion                                     { result =          [val[0]]                                                                           ; r "   Expresiones -> Expresion"                                                            }
               ;
   Asignaciones: LValue ',' Asignaciones ',' Expresion                         { result = val[2] + [[val[0], val[4]]]                                                                 ; r "  Asignaciones -> LValue , Asignaciones , Expresion"                                    }
               | LValue '<-' Expresion                                         { result =          [[val[0], val[2]]]                                                                 ; r "  Asignaciones -> LValue <- Expresion"                                                  }
               ;
         LValue: 'id'                                                          { result =              LValueValue::new(val[0].code, val[0].line, val[0].col)                         ; r "        LValue -> TkId(#{val[0].code})"                                                 }
               | 'id' '[' Expresion ']'                                        { result =              LValueArray::new(val[0].code, val[0].line, val[0].col, val[2])                 ; r "        LValue -> TkId(#{val[0].code}) [ Expresion ]"                                   }
               ;
         MCasos: MCasos '|' MCaso                                              { result = val[0] + [val[2]]                                                                           ; r "        MCasos -> MCasos MCaso"                                                         }
               |            MCaso                                              { result =          [val[0]]                                                                           ; r "        MCasos -> MCaso"                                                                }
               ;
          MCaso: Predicado '->' MInstruccion                                   { result =                     Caso::new(val[0], val[2])                                               ; r "         MCaso -> Predicado -> MInstruccion"                                            }
               ;
         PCasos: PCasos '|' PCaso                                              { result = val[0] + [val[2]]                                                                           ; r "        PCasos -> PCasos PCaso"                                                         }
               |            PCaso                                              { result =          [val[0]]                                                                           ; r "        PCasos -> PCaso"                                                                }
               ;
          PCaso: Predicado '->' PInstruccion                                   { result =                     Caso::new(val[0], val[2])                                               ; r "         PCaso -> Predicado -> PInstruccion"                                            }
               ;
      Expresion: Expresion '+' Expresion                                       { result =            ExpresionSuma::new(val[0], val[2])                                               ; r "     Expresion -> Expresion + Expresion"                                                }
               | Expresion '-' Expresion                                       { result =           ExpresionResta::new(val[0], val[2])                                               ; r "     Expresion -> Expresion - Expresion"                                                }
               | Expresion '%' Expresion                                       { result =         ExpresionResiduo::new(val[0], val[2])                                               ; r "     Expresion -> Expresion % Expresion"                                                }
               | Expresion '*' Expresion                                       { result =        ExpresionProducto::new(val[0], val[2])                                               ; r "     Expresion -> Expresion * Expresion"                                                }
               | Expresion '/' Expresion                                       { result =        ExpresionDivision::new(val[0], val[2])                                               ; r "     Expresion -> Expresion / Expresion"                                                }
               | '-' 'num'                                             =UMINUS { result =        ExpresionNegativo::new(ExpresionNumero::new(val[1].code))                            ; r "     Expresion -> - TkNum(#{val[1].code})"                                              }
               | '+' 'num'                                             =UPLUS  { result =          ExpresionNumero::new(val[1].code)                                                  ; r "     Expresion -> + TkNum(#{val[1].code})"                                              }
               |     'num'                                                     { result =          ExpresionNumero::new(val[0].code)                                                  ; r "     Expresion -> TkNum(#{val[0].code})"                                                }
               | '$' 'id'                                                      { result =        ExpresionLongitud::new(val[1].code, val[1].line, val[1].col)                         ; r "     Expresion -> $ TkId(#{val[1].code})"                                               }
               | 'id'                                                          { result =   ExpresionDefinidoValue::new(val[0].code, val[0].line, val[0].col)                         ; r "     Expresion -> TkId(#{val[0].code})"                                                 }
               | 'id' '[' Expresion ']'                                        { result =   ExpresionDefinidoArray::new(val[0].code, val[0].line, val[0].col, val[2])                 ; r "     Expresion -> TkId(#{val[0].code}) [ Expresion ]"                                   }
               | '(' Expresion ')'                                             { result = val[1]                                                                                      ; r "     Expresion -> ( Expresion )"                                                        }
               ;
      Predicado: Expresion '<'  Expresion                                      { result =           PredicadoMenor::new(val[0], val[2])                                               ; r "     Predicado -> Expresion <  Expresion"                                               }
               | Expresion '<=' Expresion                                      { result =      PredicadoMenorIgual::new(val[0], val[2])                                               ; r "     Predicado -> Expresion <= Expresion"                                               }
               | Expresion '>'  Expresion                                      { result =           PredicadoMayor::new(val[0], val[2])                                               ; r "     Predicado -> Expresion >  Expresion"                                               }
               | Expresion '>=' Expresion                                      { result =      PredicadoMayorIgual::new(val[0], val[2])                                               ; r "     Predicado -> Expresion >= Expresion"                                               }
               | Expresion  '=' Expresion                                      { result =           PredicadoIgual::new(val[0], val[2])                                               ; r "     Predicado -> Expresion  = Expresion"                                               }
               | Expresion '!=' Expresion                                      { result =         PredicadoNoIgual::new(val[0], val[2])                                               ; r "     Predicado -> Expresion != Expresion"                                               }
               | Predicado '&&' Predicado                                      { result =             PredicadoAnd::new(val[0], val[2])                                               ; r "     Predicado -> Predicado && Predicado"                                               }
               | Predicado '||' Predicado                                      { result =              PredicadoOr::new(val[0], val[2])                                               ; r "     Predicado -> Predicado || Predicado"                                               }
               | '~' Predicado                                                 { result =             PredicadoNot::new(val[1])                                                       ; r "     Predicado -> ~ Predicado"                                                          }
               | 'true'                                                        { result =            PredicadoTrue::new                                                               ; r "     Predicado -> true"                                                                 }
               | 'false'                                                       { result =           PredicadoFalse::new                                                               ; r "     Predicado -> false"                                                                }
               | '(' Predicado ')'                                             { result = val[1]                                                                                      ; r "     Predicado -> ( Predicado )"                                                        }
               ;

---- header ----

require 'Lexer'
require 'AST'

module Yisiel
  class ParseError < RuntimeError; end

  class SyntaxError < ParseError
    attr_reader :token, :context

    def initialize(token, context)
      @token   = token
      @context = context
    end

    def to_s
      last_tokens = []
      3.times do
        t = @context.pop
        break unless t
        last_tokens << t
      end
      ret  = "Error de sintaxis en la línea #{@token.line}, columna #{@token.col} cerca de #{token.code}\n"
      ret += "Contexto: #{last_tokens.reverse.inject("") { |s, t| s + t.code.to_s }}\n" unless last_tokens == []
      return ret
    end
  end

  class LexicalError < ParseError
    attr_reader :errors

    def initialize(errors)
      @errors = errors
    end

    def to_s
      errors.inject("Se encontraron errores lexicográficos:\n") { |s, error| s + error.to_s + "\n" }
    end
  end
end

---- inner ----

    def next_token
      token = @lexer.yylex
      @tokens << token
      return [false, false] unless token
      return [token.class, token]
    end

    def on_error(id, token, stack)
      raise SyntaxError::new(token, @tokens)
    end

    def parse(lexer)
#     @yydebug = true # DEBUG
      @lexer  = lexer
      @output = ""
      @tokens = []
      begin
        ast = do_parse
      rescue LexerException => e
        errors = [e]
        if not e.kind_of? FatalException
          lexer.skip(" ")
          go = true
          while go
            begin
              go = lexer.yylex
            rescue FatalException => e
              errors << e
              break
            rescue LexerException => e
              errors << e
              lexer.skip(" ")
            end
          end
        end
        raise LexicalError::new(errors)
      end
      puts @output unless @output == "" or $entrega != 2
      return ast
    end

    def r(string)
      @output << string + "\n"
    end

