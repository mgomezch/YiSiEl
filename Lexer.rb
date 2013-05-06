require 'Token'

module Yisiel
  class LexerException < RuntimeError
    include TokenData

    def process(code)
      code
    end

    def to_s
      "Caracter inesperado '#{@code}' encontrado en #{pos_s}."
    end
  end

  class FatalException < LexerException
    def to_s
      "Secuencia inesperada encontrada en #{pos_s}:\n#{@code}"
    end
  end

  class Lexer
    def initialize(code)
      @byte  = 0
      @line  = 1
      @col   = 1
      @code  = code
      @input = @code
    end

    def yylex
      skip($&)   if @input =~ $blanks
      return nil if @input == ""
      raise FatalException::new(@line, @col, $~) if @input =~ $fail

      hits = []
      $tokens.each do |regexp, type|
        hits << {:type => type, :code => $1} if @input =~ regexp
      end
      raise LexerException::new(@line, @col, @input[0,1]) if hits.empty?

      hits = hits.select { |hit| hit[:type] != TkId } if hits.size == 2
      ret  = hits[0][:type]::new(@line, @col, hits[0][:code])
      skip(hits[0][:code])
      return ret
    end

    def skip(code)
      lines  = code.scan(/^.*$/)
      lines << "" if code[-1,1] == "\n"
      @line += lines.size - 1
      @col   = (if lines.size == 1 then @col else 1 end) + lines[-1].size
      @byte += code.size
      @input = @code[@byte..(-1)]
    end
  end
end

