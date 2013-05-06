#
# DO NOT MODIFY!!!!
# This file is automatically generated by racc 1.4.5
# from racc grammer file "Parser2.y".
#

require 'racc/parser'



require 'Lexer'
require 'AST2'

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


module Yisiel

  class Parser < Racc::Parser

module_eval <<'..end Parser2.y modeval..idf44f23b8a2', 'Parser2.y', 219

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
      @yydebug = true # DEBUG
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

..end Parser2.y modeval..idf44f23b8a2

##### racc 1.4.5 generates ###

racc_reduce_table = [
 0, 0, :racc_error,
 5, 53, :_reduce_1,
 4, 53, :_reduce_2,
 4, 53, :_reduce_3,
 3, 53, :_reduce_4,
 2, 54, :_reduce_5,
 1, 54, :_reduce_6,
 4, 57, :_reduce_7,
 6, 57, :_reduce_8,
 3, 58, :_reduce_9,
 1, 58, :_reduce_10,
 2, 55, :_reduce_11,
 1, 55, :_reduce_12,
 8, 59, :_reduce_13,
 7, 59, :_reduce_14,
 7, 59, :_reduce_15,
 6, 59, :_reduce_16,
 3, 60, :_reduce_17,
 1, 60, :_reduce_18,
 2, 62, :_reduce_19,
 2, 62, :_reduce_20,
 3, 56, :_reduce_21,
 1, 56, :_reduce_22,
 1, 63, :_reduce_23,
 1, 63, :_reduce_24,
 3, 63, :_reduce_25,
 3, 63, :_reduce_26,
 3, 63, :_reduce_27,
 4, 63, :_reduce_28,
 3, 63, :_reduce_29,
 2, 63, :_reduce_30,
 2, 63, :_reduce_31,
 3, 68, :_reduce_32,
 1, 68, :_reduce_33,
 1, 61, :_reduce_34,
 1, 61, :_reduce_35,
 3, 61, :_reduce_36,
 3, 61, :_reduce_37,
 3, 61, :_reduce_38,
 4, 61, :_reduce_39,
 3, 61, :_reduce_40,
 2, 61, :_reduce_41,
 2, 61, :_reduce_42,
 1, 61, :_reduce_43,
 3, 66, :_reduce_44,
 1, 66, :_reduce_45,
 5, 64, :_reduce_46,
 3, 64, :_reduce_47,
 1, 70, :_reduce_48,
 4, 70, :_reduce_49,
 3, 65, :_reduce_50,
 1, 65, :_reduce_51,
 3, 71, :_reduce_52,
 3, 69, :_reduce_53,
 1, 69, :_reduce_54,
 3, 73, :_reduce_55,
 3, 67, :_reduce_56,
 3, 67, :_reduce_57,
 3, 67, :_reduce_58,
 3, 67, :_reduce_59,
 3, 67, :_reduce_60,
 2, 67, :_reduce_61,
 2, 67, :_reduce_62,
 1, 67, :_reduce_63,
 2, 67, :_reduce_64,
 1, 67, :_reduce_65,
 4, 67, :_reduce_66,
 3, 67, :_reduce_67,
 3, 72, :_reduce_68,
 3, 72, :_reduce_69,
 3, 72, :_reduce_70,
 3, 72, :_reduce_71,
 3, 72, :_reduce_72,
 3, 72, :_reduce_73,
 3, 72, :_reduce_74,
 3, 72, :_reduce_75,
 2, 72, :_reduce_76,
 1, 72, :_reduce_77,
 1, 72, :_reduce_78,
 3, 72, :_reduce_79 ]

racc_reduce_n = 80

racc_shift_n = 174

racc_action_table = [
    30,    32,    30,    32,   123,    77,   100,    77,   128,   166,
   123,    29,    72,    29,   -80,   165,    76,    30,    32,    59,
    61,    62,    64,    79,    34,    35,    34,    35,    29,   124,
    39,    60,    39,   129,    31,   173,    31,    37,   116,    37,
   127,    34,    35,   101,    30,    32,    33,    39,    33,    94,
    84,    31,    25,   162,    37,    29,    41,   115,    56,    30,
    32,    30,    32,    33,     3,   163,   148,    19,    34,    35,
    29,    95,    29,    53,    39,     4,    30,    32,    31,     3,
    58,    37,    93,    34,    35,    34,    35,    29,    41,    39,
    33,    39,     3,    31,    94,    31,    37,    80,    37,    70,
    34,    35,    42,    30,    32,    33,    39,    33,    41,    81,
    31,   132,    98,    37,    29,   130,    95,    41,    30,    32,
    30,    32,    33,    59,    61,    62,    64,    34,    35,    29,
    12,    29,   159,    39,    51,    60,    15,    31,    18,     9,
    37,    11,    34,    35,    34,    35,    62,    64,    39,    33,
    39,   137,    31,    13,    31,    37,    60,    37,    59,    61,
    62,    64,   126,   133,    33,    12,    33,    30,    32,   102,
    60,    15,    51,    18,     9,    41,    11,    81,    29,    88,
    59,    61,    62,    64,    66,    67,    69,   122,    13,    30,
    32,    34,    60,    62,    64,    47,    86,    39,   125,    48,
    29,    30,    32,    60,    45,   169,    65,    68,   131,    30,
    32,    71,    29,    34,    24,    23,    63,     1,   115,    39,
    29,    30,    32,    30,    32,    34,    45,    91,   163,     3,
   167,    39,    29,    34,    29,    50,   155,    51,    45,    39,
     4,    30,    32,    30,    32,    34,    45,    34,    77,    21,
    99,    39,    29,    39,    29,    30,    32,    76,    45,    78,
    45,    77,   -80,    30,    32,    34,    29,    34,   nil,   nil,
    76,    39,   164,    39,    29,    30,    32,   nil,    45,    34,
    45,   nil,   nil,    30,    32,    39,    29,    34,    54,   nil,
    55,   nil,    45,    39,    29,    30,    32,    30,    32,    34,
    45,   nil,   nil,   nil,   nil,    39,    29,    34,    29,   nil,
   nil,   nil,    45,    39,   nil,    30,    32,   nil,    44,    34,
    45,    34,   nil,   nil,   nil,    39,    29,    39,   nil,    30,
    32,   nil,    45,   nil,    45,   nil,   nil,    30,    32,    34,
    29,   nil,   nil,   nil,   nil,    39,    30,    32,    29,    30,
    32,   nil,    45,    34,    30,    32,   nil,    29,   nil,    39,
    29,    34,   nil,   nil,   nil,    29,    45,    39,   nil,   nil,
    34,    30,    32,    34,    45,   nil,    39,   nil,    34,    39,
   nil,   nil,    29,    45,    39,   nil,    45,    59,    61,    62,
    64,    45,   nil,   nil,   nil,    34,   140,   141,   nil,    60,
   nil,    39,   144,   nil,   146,   138,     4,   139,    45,    59,
    61,    62,    64,    66,    67,    69,   140,   141,   nil,   142,
   nil,    60,   144,    12,   146,   138,     4,   139,   nil,    15,
   nil,    18,     9,   nil,    11,    65,    68,   nil,   nil,   142,
   nil,   140,   141,   nil,   nil,    63,    13,   144,    12,   146,
   138,   nil,   139,   nil,    15,   nil,    18,     9,   nil,    11,
   nil,   nil,   nil,   nil,   142,   nil,   140,   141,   nil,   nil,
   nil,    13,   144,    12,   146,   138,     4,   139,   nil,    15,
   nil,    18,     9,   nil,    11,   nil,   nil,   nil,   nil,   142,
   nil,   140,   141,   nil,   nil,   nil,    13,   144,   nil,   146,
   138,     4,   139,   nil,   140,   141,   nil,   nil,   nil,   nil,
   144,   nil,   146,   138,   142,   139,   nil,   140,   141,    59,
    61,    62,    64,   144,    12,   146,   138,   142,   139,   nil,
    15,    60,    18,     9,   nil,    11,   nil,    12,   nil,   nil,
   142,   nil,   nil,    15,   nil,    18,     9,    13,    11,    59,
    61,    62,    64,    59,    61,    62,    64,   nil,   nil,   nil,
    13,    60,   nil,   nil,   nil,    60,    59,    61,    62,    64,
    59,    61,    62,    64,    59,    61,    62,    64,    60,   nil,
   nil,   nil,    60,   nil,   nil,   nil,    60,    59,    61,    62,
    64,    59,    61,    62,    64,    59,    61,    62,    64,    60,
   nil,   nil,   nil,    60,   nil,   nil,   nil,    60,    59,    61,
    62,    64,    59,    61,    62,    64,   nil,   nil,   nil,   nil,
    60,   nil,   nil,   nil,    60 ]

racc_action_check = [
   138,   138,    81,    81,    89,   117,    55,    75,    96,   156,
   168,   138,    34,    81,   117,   156,    75,   144,   144,    83,
    83,    83,    83,    39,   138,   138,    81,    81,   144,    89,
   138,    83,    81,    96,   138,   168,    81,   138,    75,    81,
    95,   144,   144,    55,    15,    15,   138,   144,    81,   128,
    46,   144,     8,   151,   144,    15,    46,    83,    24,   163,
   163,    76,    76,   144,     8,   151,   131,     2,    15,    15,
   163,   128,    76,    21,    15,     8,    77,    77,    15,     2,
    26,    15,    52,   163,   163,    76,    76,    77,    52,   163,
    15,    76,    26,   163,    53,    76,   163,    40,    76,    30,
    77,    77,    10,    37,    37,   163,    77,    76,    10,    40,
    77,   103,    53,    77,    37,    98,    53,   103,    35,    35,
     9,     9,    77,   120,   120,   120,   120,    37,    37,    35,
    41,     9,   146,    37,   146,   120,    41,    37,    41,    41,
    37,    41,    35,    35,     9,     9,   104,   104,    35,    37,
     9,   129,    35,    41,     9,    35,   104,     9,    92,    92,
    92,    92,    94,   120,    35,    58,     9,   159,   159,    57,
    92,    58,    86,    58,    58,    57,    58,    49,   159,    49,
    74,    74,    74,    74,    74,    74,    74,    85,    58,    50,
    50,   159,    74,   106,   106,    14,    47,   159,    92,    14,
    50,   139,   139,   106,   159,   159,    74,    74,   100,    61,
    61,    32,   139,    50,     7,     4,    74,     0,    74,    50,
    61,    62,    62,    59,    59,   139,    50,    50,   158,     0,
   158,   139,    62,    61,    59,    18,   139,    18,   139,    61,
     0,    60,    60,    63,    63,    62,    61,    59,    38,     3,
    54,    62,    60,    59,    63,   123,   123,    38,    62,    38,
    59,   152,   118,   122,   122,    60,   123,    63,   nil,   nil,
   152,    60,   152,    63,   122,    64,    64,   nil,    60,   123,
    63,   nil,   nil,    11,    11,   123,    64,   122,    22,   nil,
    22,   nil,   123,   122,    11,    69,    69,    51,    51,    64,
   122,   nil,   nil,   nil,   nil,    64,    69,    11,    51,   nil,
   nil,   nil,    64,    11,   nil,    66,    66,   nil,    11,    69,
    11,    51,   nil,   nil,   nil,    69,    66,    51,   nil,    67,
    67,   nil,    69,   nil,    51,   nil,   nil,    45,    45,    66,
    67,   nil,   nil,   nil,   nil,    66,    79,    79,    45,    68,
    68,   nil,    66,    67,    48,    48,   nil,    79,   nil,    67,
    68,    45,   nil,   nil,   nil,    48,    67,    45,   nil,   nil,
    79,    65,    65,    68,    45,   nil,    79,   nil,    48,    68,
   nil,   nil,    65,    79,    48,   nil,    68,    87,    87,    87,
    87,    48,   nil,   nil,   nil,    65,   130,   130,   nil,    87,
   nil,    65,   130,   nil,   130,   130,   130,   130,    65,    28,
    28,    28,    28,    28,    28,    28,   137,   137,   nil,   130,
   nil,    28,   137,    25,   137,   137,   137,   137,   nil,    25,
   nil,    25,    25,   nil,    25,    28,    28,   nil,   nil,   137,
   nil,   140,   140,   nil,   nil,    28,    25,   140,    78,   140,
   140,   nil,   140,   nil,    78,   nil,    78,    78,   nil,    78,
   nil,   nil,   nil,   nil,   140,   nil,   147,   147,   nil,   nil,
   nil,    78,   147,    12,   147,   147,   147,   147,   nil,    12,
   nil,    12,    12,   nil,    12,   nil,   nil,   nil,   nil,   147,
   nil,   150,   150,   nil,   nil,   nil,    12,   150,   nil,   150,
   150,   150,   150,   nil,   164,   164,   nil,   nil,   nil,   nil,
   164,   nil,   164,   164,   150,   164,   nil,   165,   165,   114,
   114,   114,   114,   165,     1,   165,   165,   164,   165,   nil,
     1,   114,     1,     1,   nil,     1,   nil,    19,   nil,   nil,
   165,   nil,   nil,    19,   nil,    19,    19,     1,    19,   113,
   113,   113,   113,   154,   154,   154,   154,   nil,   nil,   nil,
    19,   113,   nil,   nil,   nil,   154,   112,   112,   112,   112,
   111,   111,   111,   111,    90,    90,    90,    90,   112,   nil,
   nil,   nil,   111,   nil,   nil,   nil,    90,    43,    43,    43,
    43,   110,   110,   110,   110,   108,   108,   108,   108,    43,
   nil,   nil,   nil,   110,   nil,   nil,   nil,   108,   134,   134,
   134,   134,   135,   135,   135,   135,   nil,   nil,   nil,   nil,
   134,   nil,   nil,   nil,   135 ]

racc_action_pointer = [
   206,   500,    56,   217,   183,   nil,   nil,   214,    41,   118,
    92,   281,   449,   nil,   180,    42,   nil,   nil,   196,   513,
   nil,    34,   273,   nil,    58,   399,    69,   nil,   407,   nil,
    86,   nil,   198,   nil,   -20,   116,   nil,   101,   239,   -18,
    66,   106,   nil,   585,   nil,   335,    40,   164,   352,   134,
   187,   295,    72,    72,   218,    -6,   nil,   159,   141,   221,
   239,   207,   219,   241,   273,   369,   313,   327,   347,   293,
   nil,   nil,   nil,   nil,   178,    -2,    59,    74,   424,   344,
   nil,     0,   nil,    17,   nil,   172,   131,   385,   nil,   -11,
   572,   nil,   156,   nil,   130,     8,    -7,   nil,    94,   nil,
   162,   nil,   nil,   101,   142,   nil,   189,   nil,   593,   nil,
   589,   568,   564,   547,   517,   nil,   nil,    -4,   253,   nil,
   121,   nil,   261,   253,   nil,   nil,   nil,   nil,    27,   130,
   372,    53,   nil,   nil,   606,   610,   nil,   392,    -2,   199,
   417,   nil,   nil,   nil,    15,   nil,    93,   442,   nil,   nil,
   467,    22,   252,   nil,   551,   nil,    -1,   nil,   185,   165,
   nil,   nil,   nil,    57,   480,   493,   nil,   nil,    -5,   nil,
   nil,   nil,   nil,   nil ]

racc_action_default = [
   -80,   -80,   -80,   -80,   -80,    -6,   -12,   -80,   -80,   -80,
   -80,   -80,   -80,   -23,   -80,   -80,   -22,   -24,   -48,   -80,
   -11,   -80,   -80,   -10,   -80,   -80,   -80,    -5,   -80,   -63,
   -80,   -78,   -80,   -77,   -80,   -80,   -51,   -80,   -80,   -65,
   -80,   -80,    -4,   -30,   -31,   -80,   -80,   -80,   -80,   -80,
   -80,   -80,   -80,   -80,   -80,   -80,   174,   -80,   -80,   -80,
   -80,   -80,   -80,   -80,   -80,   -80,   -80,   -80,   -80,   -80,
   -62,   -61,   -64,   -76,   -80,   -80,   -80,   -80,   -80,   -80,
   -25,   -80,   -21,   -80,   -27,   -80,   -48,   -47,   -26,   -80,
   -45,   -29,   -80,    -3,   -80,   -80,   -80,   -18,   -80,    -9,
   -80,    -7,    -2,   -80,   -56,   -58,   -57,   -59,   -68,   -60,
   -72,   -69,   -71,   -70,   -73,   -67,   -79,   -75,   -74,   -52,
   -80,   -50,   -80,   -80,   -28,   -49,   -20,   -19,   -80,   -80,
   -80,   -80,    -1,   -66,   -46,   -44,   -17,   -80,   -80,   -80,
   -80,   -43,   -34,   -16,   -80,   -35,   -48,   -80,    -8,   -14,
   -80,   -80,   -80,   -54,   -41,   -42,   -80,   -33,   -80,   -80,
   -15,   -13,   -36,   -80,   -80,   -80,   -38,   -37,   -80,   -40,
   -53,   -55,   -32,   -39 ]

racc_goto_table = [
    43,    27,     8,    85,    89,    73,    97,    75,    82,    10,
     2,    20,     7,    40,   156,   151,    96,   121,    26,    49,
    46,   158,    22,   170,   nil,   nil,    74,    52,   nil,   nil,
   nil,   nil,   nil,    57,    83,    20,   nil,    87,   nil,    90,
    92,   nil,   nil,   nil,   nil,   119,   117,   118,   104,   105,
   106,   107,   108,   109,   110,   111,   112,   113,   114,   nil,
   143,   nil,   nil,   nil,   nil,   nil,   103,   149,   120,   nil,
   157,   nil,   nil,   nil,   nil,   nil,   nil,   160,   nil,   nil,
   161,   136,   nil,   nil,   nil,   nil,   145,   nil,   nil,   nil,
   nil,   nil,   nil,   145,   171,   172,   145,   nil,   nil,   nil,
   nil,   nil,   nil,   145,   nil,   nil,   145,   nil,   152,   nil,
   nil,   134,   135,   168,   152,   nil,   nil,   nil,   nil,   nil,
   145,   145,   nil,   nil,   nil,   nil,   nil,   nil,   154,   nil,
   nil,   nil,   147,   152,   nil,   nil,   nil,   nil,   nil,   150,
    27,   nil,   nil,    27,   nil,   nil,   nil,   nil,    90 ]

racc_goto_check = [
    15,     5,     2,    12,    14,    20,    10,    20,    11,     4,
     3,     7,     1,    13,    16,    17,     8,    19,     3,    13,
     4,    17,     6,    21,   nil,   nil,    15,     4,   nil,   nil,
   nil,   nil,   nil,     4,    15,     7,   nil,    15,   nil,    15,
    15,   nil,   nil,   nil,   nil,    11,    20,    20,    15,    15,
    15,    15,    15,    15,    15,    15,    15,    15,    15,   nil,
     9,   nil,   nil,   nil,   nil,   nil,     4,     9,    15,   nil,
     9,   nil,   nil,   nil,   nil,   nil,   nil,     9,   nil,   nil,
     9,    10,   nil,   nil,   nil,   nil,    12,   nil,   nil,   nil,
   nil,   nil,   nil,    12,     9,     9,    12,   nil,   nil,   nil,
   nil,   nil,   nil,    12,   nil,   nil,    12,   nil,    20,   nil,
   nil,    15,    15,    14,    20,   nil,   nil,   nil,   nil,   nil,
    12,    12,   nil,   nil,   nil,   nil,   nil,   nil,    15,   nil,
   nil,   nil,     2,    20,   nil,   nil,   nil,   nil,   nil,     2,
     5,   nil,   nil,     5,   nil,   nil,   nil,   nil,    15 ]

racc_goto_pointer = [
   nil,    12,     2,    10,     8,    -7,    18,     9,   -37,   -70,
   -47,   -33,   -44,     4,   -46,   -11,  -126,  -123,   nil,   -64,
   -30,  -140 ]

racc_goto_default = [
   nil,   nil,   nil,   nil,   nil,     5,   nil,     6,   nil,   nil,
   nil,    16,    17,   nil,   nil,    28,   nil,   nil,    14,    36,
    38,   153 ]

racc_token_table = {
 false => 0,
 Object.new => 1,
 TkSuma => 2,
 TkResta => 3,
 TkProducto => 4,
 TkDivision => 5,
 TkMenorIgual => 6,
 TkMayorIgual => 7,
 TkNoIgual => 8,
 TkAnd => 9,
 TkEnd => 10,
 TkMain => 11,
 TkArray => 12,
 TkNum => 13,
 TkResiduo => 14,
 TkComa => 15,
 TkSeq => 16,
 TkDosPuntos => 17,
 TkOr => 18,
 TkAsignacion => 19,
 TkGuardia => 20,
 TkAs => 21,
 TkOut => 22,
 TkProc => 23,
 TkBegin => 24,
 TkReturn => 25,
 TkDolar => 26,
 TkNot => 27,
 TkIgual => 28,
 TkMayor => 29,
 TkDo => 30,
 TkFi => 31,
 TkId => 32,
 TkIf => 33,
 TkVar => 34,
 TkShow => 35,
 TkFalse => 36,
 TkStr => 37,
 TkMenor => 38,
 TkPAbre => 39,
 TkPCierra => 40,
 TkCAbre => 41,
 TkCCierra => 42,
 TkPipe => 43,
 TkIn => 44,
 TkOd => 45,
 TkOf => 46,
 TkSkip => 47,
 TkTrue => 48,
 TkValue => 49,
 :UMINUS => 50,
 :UPLUS => 51 }

racc_use_result_var = true

racc_nt_base = 52

Racc_arg = [
 racc_action_table,
 racc_action_check,
 racc_action_default,
 racc_action_pointer,
 racc_goto_table,
 racc_goto_check,
 racc_goto_default,
 racc_goto_pointer,
 racc_nt_base,
 racc_reduce_table,
 racc_token_table,
 racc_shift_n,
 racc_reduce_n,
 racc_use_result_var ]

Racc_token_to_s_table = [
'$end',
'error',
'"+"',
'"-"',
'"*"',
'"/"',
'"<="',
'">="',
'"!="',
'"&&"',
'"end"',
'"main"',
'"array"',
'"num"',
'"%"',
'","',
'";"',
'":"',
'"||"',
'"<-"',
'"->"',
'"as"',
'"out"',
'"proc"',
'"begin"',
'"return"',
'"$"',
'"~"',
'"="',
'">"',
'"do"',
'"fi"',
'"id"',
'"if"',
'"var"',
'"show"',
'"false"',
'"string"',
'"<"',
'"("',
'")"',
'"["',
'"]"',
'"|"',
'"in"',
'"od"',
'"of"',
'"skip"',
'"true"',
'"value"',
'UMINUS',
'UPLUS',
'$start',
'Programa',
'Definiciones',
'Procedimientos',
'MInstrucciones',
'Definicion',
'IDs',
'Procedimiento',
'Parametros',
'PInstruccion',
'Parametro',
'MInstruccion',
'Asignaciones',
'MCasos',
'Expresiones',
'Expresion',
'PInstrucciones',
'PCasos',
'LValue',
'MCaso',
'Predicado',
'PCaso']

Racc_debug_parser = true

##### racc system variables end #####

 # reduce 0 omitted

module_eval <<'.,.,', 'Parser2.y', 74
  def _reduce_1( val, _values, result )
 result =            ASTProg::new(val[0], val[1], val[3])                                         ; r "      Programa -> Definiciones Procedimientos main MInstrucciones end"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 75
  def _reduce_2( val, _values, result )
 result =            ASTProg::new(val[0], []    , val[2])                                         ; r "      Programa -> Definiciones main MInstrucciones end"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 76
  def _reduce_3( val, _values, result )
 result =            ASTProg::new([]    , val[0], val[2])                                         ; r "      Programa -> Procedimientos main MInstrucciones end"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 77
  def _reduce_4( val, _values, result )
 result =            ASTProg::new([]    , []    , val[1])                                         ; r "      Programa -> main MInstrucciones end"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 79
  def _reduce_5( val, _values, result )
 result = val[0] + val[1]                                                                         ; r "  Definiciones -> Definiciones Definicion"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 80
  def _reduce_6( val, _values, result )
 result =          val[0]                                                                         ; r "  Definiciones -> Definicion"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 82
  def _reduce_7( val, _values, result )
 result = val[1].map { |ident| ASTDefValue::new(ident.code, ident.line, ident.col)              } ; r "    Definicion -> var IDs : value"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 83
  def _reduce_8( val, _values, result )
 result = val[1].map { |ident| ASTDefArray::new(ident.code, ident.line, ident.col, val[5].code) } ; r "    Definicion -> var IDs : array of TkNum(#{val[5].code})"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 85
  def _reduce_9( val, _values, result )
 result = val[0] + [val[2]]                                                                       ; r "           IDs -> IDs , TkId(#{val[2].code})"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 86
  def _reduce_10( val, _values, result )
 result =          [val[0]]                                                                       ; r "           IDs -> TkId(#{val[0].code})"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 88
  def _reduce_11( val, _values, result )
 result = val[0] + [val[1]]                                                                       ; r "Procedimientos -> Procedimientos Procedimiento"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 89
  def _reduce_12( val, _values, result )
 result =          [val[0]]                                                                       ; r "Procedimientos -> Procedimiento"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 91
  def _reduce_13( val, _values, result )
 result =         ASTProc::new(val[1].code, val[1].line, val[1].col, val[3], val[6], val[7])      ; r " Procedimiento -> proc TkId(#{val[1].code}) ( Parametros ) as Definiciones PInstruccion"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 92
  def _reduce_14( val, _values, result )
 result =         ASTProc::new(val[1].code, val[1].line, val[1].col, val[3], []    , val[6])      ; r " Procedimiento -> proc TkId(#{val[1].code}) ( Parametros ) as PInstruccion"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 93
  def _reduce_15( val, _values, result )
 result =         ASTProc::new(val[1].code, val[1].line, val[1].col, []    , val[5], val[6])      ; r " Procedimiento -> proc TkId(#{val[1].code}) ( ) as Definiciones PInstruccion"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 94
  def _reduce_16( val, _values, result )
 result =         ASTProc::new(val[1].code, val[1].line, val[1].col, []    , []    , val[5])      ; r " Procedimiento -> proc TkId(#{val[1].code}) ( ) as PInstruccion"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 96
  def _reduce_17( val, _values, result )
 result = val[0] + [val[2]]                                                                       ; r "    Parametros -> Parametros , Parametro"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 97
  def _reduce_18( val, _values, result )
 result =          [val[0]]                                                                       ; r "    Parametros -> Parametro"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 99
  def _reduce_19( val, _values, result )
 result =      ASTParamIn::new(val[1].code, val[1].line, val[1].col)                              ; r "     Parametro -> in  TkId(#{val[1].code})"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 100
  def _reduce_20( val, _values, result )
 result =     ASTParamOut::new(val[1].code, val[1].line, val[1].col)                              ; r "     Parametro -> out TkId(#{val[1].code})"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 102
  def _reduce_21( val, _values, result )
 result = val[0] + [val[2]]                                                                       ; r "MInstrucciones -> MInstrucciones ; MInstruccion"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 103
  def _reduce_22( val, _values, result )
 result =          [val[0]]                                                                       ; r "MInstrucciones -> MInstruccion"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 105
  def _reduce_23( val, _values, result )
 result =     ASTStmtSkip::new                                                                    ; r "  MInstruccion -> skip"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 106
  def _reduce_24( val, _values, result )
 result =      ASTStmtSet::new(val[0].transpose[0], val[0].transpose[1])                          ; r "  MInstruccion -> Asignaciones"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 107
  def _reduce_25( val, _values, result )
 result =       ASTStmtIf::new(val[1])                                                            ; r "  MInstruccion -> if MCasos fi"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 108
  def _reduce_26( val, _values, result )
 result =       ASTStmtDo::new(val[1])                                                            ; r "  MInstruccion -> do MCasos od"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 109
  def _reduce_27( val, _values, result )
 result =    ASTStmtBlock::new(val[1])                                                            ; r "  MInstruccion -> begin MInstrucciones end"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 110
  def _reduce_28( val, _values, result )
 result =     ASTStmtCall::new(val[0].code, val[0].line, val[0].col, val[2])                      ; r "  MInstruccion -> TkId(#{val[0].code}) ( Expresiones )"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 111
  def _reduce_29( val, _values, result )
 result =     ASTStmtCall::new(val[0].code, val[0].line, val[0].col, [])                          ; r "  MInstruccion -> TkId(#{val[0].code}) ( )"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 112
  def _reduce_30( val, _values, result )
 result = ASTStmtShowMath::new(val[1])                                                            ; r "  MInstruccion -> show Expresion"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 113
  def _reduce_31( val, _values, result )
 result =  ASTStmtShowStr::new(val[1].code)                                                       ; r "  MInstruccion -> show string"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 115
  def _reduce_32( val, _values, result )
 result = val[0] + [val[2]]                                                                       ; r "PInstrucciones -> PInstrucciones ; PInstruccion"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 116
  def _reduce_33( val, _values, result )
 result =          [val[0]]                                                                       ; r "PInstrucciones -> PInstruccion"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 118
  def _reduce_34( val, _values, result )
 result =     ASTStmtSkip::new                                                                    ; r "  PInstruccion -> skip"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 119
  def _reduce_35( val, _values, result )
 result =      ASTStmtSet::new(val[0].transpose[0], val[0].transpose[1])                          ; r "  PInstruccion -> Asignaciones"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 120
  def _reduce_36( val, _values, result )
 result =       ASTStmtIf::new(val[1])                                                            ; r "  PInstruccion -> if PCasos fi"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 121
  def _reduce_37( val, _values, result )
 result =       ASTStmtDo::new(val[1])                                                            ; r "  PInstruccion -> do PCasos od"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 122
  def _reduce_38( val, _values, result )
 result =    ASTStmtBlock::new(val[1])                                                            ; r "  PInstruccion -> begin PInstrucciones end"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 123
  def _reduce_39( val, _values, result )
 result =     ASTStmtCall::new(val[0].code, val[0].line, val[0].col, val[2])                      ; r "  PInstruccion -> TkId(#{val[0].code}) ( Expresiones )"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 124
  def _reduce_40( val, _values, result )
 result =     ASTStmtCall::new(val[0].code, val[0].line, val[0].col, [])                          ; r "  PInstruccion -> TkId(#{val[0].code}) ( )"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 125
  def _reduce_41( val, _values, result )
 result = ASTStmtShowMath::new(val[1])                                                            ; r "  PInstruccion -> show Expresion"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 126
  def _reduce_42( val, _values, result )
 result =  ASTStmtShowStr::new(val[1].code)                                                       ; r "  PInstruccion -> show string"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 127
  def _reduce_43( val, _values, result )
 result =      ASTStmtRet::new()                                                                  ; r "  PInstruccion -> return"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 129
  def _reduce_44( val, _values, result )
 result = val[0] + [val[2]]                                                                       ; r "   Expresiones -> Expresiones , Expresion"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 130
  def _reduce_45( val, _values, result )
 result =          [val[0]]                                                                       ; r "   Expresiones -> Expresion"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 132
  def _reduce_46( val, _values, result )
 result = val[2] + [[val[0], val[4]]]                                                             ; r "  Asignaciones -> LValue , Asignaciones , Expresion"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 133
  def _reduce_47( val, _values, result )
 result =          [[val[0], val[2]]]                                                             ; r "  Asignaciones -> LValue <- Expresion"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 135
  def _reduce_48( val, _values, result )
 result =  ASTLValueValue::new(val[0].code, val[0].line, val[0].col)                              ; r "        LValue -> TkId(#{val[0].code})"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 136
  def _reduce_49( val, _values, result )
 result =  ASTLValueArray::new(val[0].code, val[0].line, val[0].col, val[2])                      ; r "        LValue -> TkId(#{val[0].code}) [ Expresion ]"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 138
  def _reduce_50( val, _values, result )
 result = val[0] + [val[2]]                                                                       ; r "        MCasos -> MCasos MCaso"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 139
  def _reduce_51( val, _values, result )
 result =          [val[0]]                                                                       ; r "        MCasos -> MCaso"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 141
  def _reduce_52( val, _values, result )
 result =         ASTCaso::new(val[0], val[2])                                                    ; r "         MCaso -> Predicado -> MInstruccion"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 143
  def _reduce_53( val, _values, result )
 result = val[0] + [val[2]]                                                                       ; r "        PCasos -> PCasos PCaso"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 144
  def _reduce_54( val, _values, result )
 result =          [val[0]]                                                                       ; r "        PCasos -> PCaso"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 146
  def _reduce_55( val, _values, result )
 result =         ASTCaso::new(val[0], val[2])                                                    ; r "         PCaso -> Predicado -> PInstruccion"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 148
  def _reduce_56( val, _values, result )
 result =      ASTMathAdd::new(val[0], val[2])                                                    ; r "     Expresion -> Expresion + Expresion"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 149
  def _reduce_57( val, _values, result )
 result =      ASTMathSub::new(val[0], val[2])                                                    ; r "     Expresion -> Expresion - Expresion"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 150
  def _reduce_58( val, _values, result )
 result =      ASTMathMod::new(val[0], val[2])                                                    ; r "     Expresion -> Expresion % Expresion"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 151
  def _reduce_59( val, _values, result )
 result =     ASTMathProd::new(val[0], val[2])                                                    ; r "     Expresion -> Expresion * Expresion"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 152
  def _reduce_60( val, _values, result )
 result =      ASTMathDiv::new(val[0], val[2])                                                    ; r "     Expresion -> Expresion / Expresion"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 153
  def _reduce_61( val, _values, result )
 result =      ASTMathNeg::new(ASTMathNum::new(val[1].code))                                      ; r "     Expresion -> - TkNum(#{val[1].code})"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 154
  def _reduce_62( val, _values, result )
 result =      ASTMathNum::new(val[1].code)                                                       ; r "     Expresion -> + TkNum(#{val[1].code})"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 155
  def _reduce_63( val, _values, result )
 result =      ASTMathNum::new(val[0].code)                                                       ; r "     Expresion -> TkNum(#{val[0].code})"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 156
  def _reduce_64( val, _values, result )
 result =     ASTMathSize::new(val[1].code, val[1].line, val[1].col)                              ; r "     Expresion -> $ TkId(#{val[1].code})"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 157
  def _reduce_65( val, _values, result )
 result = ASTMathDefValue::new(val[0].code, val[0].line, val[0].col)                              ; r "     Expresion -> TkId(#{val[0].code})"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 158
  def _reduce_66( val, _values, result )
 result = ASTMathDefArray::new(val[0].code, val[0].line, val[0].col, val[2])                      ; r "     Expresion -> TkId(#{val[0].code}) [ Expresion ]"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 159
  def _reduce_67( val, _values, result )
 result = val[1]                                                                                  ; r "     Expresion -> ( Expresion )"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 161
  def _reduce_68( val, _values, result )
 result =        ASTBoolL::new(val[0], val[2])                                                    ; r "     Predicado -> Expresion <  Expresion"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 162
  def _reduce_69( val, _values, result )
 result =       ASTBoolLE::new(val[0], val[2])                                                    ; r "     Predicado -> Expresion <= Expresion"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 163
  def _reduce_70( val, _values, result )
 result =        ASTBoolG::new(val[0], val[2])                                                    ; r "     Predicado -> Expresion >  Expresion"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 164
  def _reduce_71( val, _values, result )
 result =       ASTBoolGE::new(val[0], val[2])                                                    ; r "     Predicado -> Expresion >= Expresion"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 165
  def _reduce_72( val, _values, result )
 result =        ASTBoolE::new(val[0], val[2])                                                    ; r "     Predicado -> Expresion  = Expresion"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 166
  def _reduce_73( val, _values, result )
 result =       ASTBoolNE::new(val[0], val[2])                                                    ; r "     Predicado -> Expresion != Expresion"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 167
  def _reduce_74( val, _values, result )
 result =      ASTBoolAnd::new(val[0], val[2])                                                    ; r "     Predicado -> Predicado && Predicado"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 168
  def _reduce_75( val, _values, result )
 result =       ASTBoolOr::new(val[0], val[2])                                                    ; r "     Predicado -> Predicado || Predicado"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 169
  def _reduce_76( val, _values, result )
 result =      ASTBoolNot::new(val[1])                                                            ; r "     Predicado -> ~ Predicado"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 170
  def _reduce_77( val, _values, result )
 result =     ASTBoolTrue::new                                                                    ; r "     Predicado -> true"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 171
  def _reduce_78( val, _values, result )
 result =    ASTBoolFalse::new                                                                    ; r "     Predicado -> false"
   result
  end
.,.,

module_eval <<'.,.,', 'Parser2.y', 172
  def _reduce_79( val, _values, result )
 result = val[1]                                                                                  ; r "     Predicado -> ( Predicado )"
   result
  end
.,.,

 def _reduce_none( val, _values, result )
  result
 end

  end   # class Parser

end   # module Yisiel