module Yisiel
  $fail   = /\A(\{\#([^\#\{]|(\#[^\}])|(\{[^#]))*\{\#)/
  $blanks = /\A((\{\#([^\#\{]|(\#[^\}])|(\{[^\#]))*\#\})|(\#[^\n]*$)|\s)+/
  $tokens = {
    "Or" =>"||","Coma" =>",","Igual"  =>"=" ,"Residuo" =>"%",   "NoIgual"=>"!=",
    "And"=>"&&","Suma" =>"+","PAbre"  =>"(" ,"PCierra" =>")","Asignacion"=>"<-",
    "Not"=>"~" ,"CAbre"=>"[","CCierra"=>"]" ,"Division"=>"/","MayorIgual"=>">=",
    "Seq"=>";" ,"Dolar"=>"$","Guardia"=>"->","Producto"=>"*","MenorIgual"=>"<=",
    "Mayor"=>/\A(>)([^=]|$)/,"Menor"=>/\A(<)([^=-]|$)/,"Resta"=>/\A(-)([^>]|$)/,
    "Pipe"=>/\A(\|)([^\|]|$)/,"Num"=>/\A(\d+)/,
    "Id"=>/\A([a-zA-Z](\w*))/,"DosPuntos"=>":",
    "Str"=>/\A((\"([^\n\"\\]|(\\[n\\]))*\")|(\'([^\'\\]|(\\[n\\]))*\'))/
  }

  $tokens.each do |name, match|
    next if match.kind_of?(Regexp)
    $tokens[name] = Regexp::new("\\A(" + Regexp::escape(match) + ")")
  end

  $tokens = $tokens.invert

  %w{if fi do od of as in
     out var end
     main skip show true proc
     value array begin false
     return
    }.each do |w|
    $tokens[Regexp::new("\\A(#{w})(\\W|$)")] = w.capitalize
  end

  module TokenData
    attr_reader :line, :col, :code

    def initialize(line, col, code)
      @line = line
      @col  = col
      @code = process(code)
    end

    def pos_s
      "linea #{@line}, columna #{@col}"
    end

    def process(code)
      code
    end
  end

  class Token
    include TokenData

    def to_s
      if self.kind_of? TkId or self.kind_of? TkNum or self.kind_of? TkStr
        "#{self.class} #{@code} (#{pos_s.capitalize})"
      else
        "#{self.class} (#{pos_s.capitalize})"
      end
    end
  end

  $tokens.each do |regexp, name|
    tokenclass = case name
      when "Num" then Class::new(Token) do
        def process(code)
          code.to_i
        end
      end
      when "Str" then Class::new(Token) do
        def process(code)
          case code[0,1]
            when "'"
              code[1..-2].gsub(/\\\\/,"'").gsub(/\\n/,"\n").gsub(/'/,"\\")
            when '"'
              code[1..-2].gsub(/\\\\/,'"').gsub(/\\n/,"\n").gsub(/"/,"\\")
          end
        end
      end
      else Class::new(Token)
    end
    $tokens[regexp] = Object::const_set("Tk" + name, tokenclass)
  end
end

