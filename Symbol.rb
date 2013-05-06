module Yisiel
  class Symbol
    attr_reader :ident, :line, :col

    def initialize(ident, line, col)
      @ident = ident
      @line  = line
      @col   = col
    end
  end

  class SymValue < Symbol
    attr_accessor :value

    def initialize(ident, line, col)
      super(ident, line, col)
      @value = nil
    end

    def get_value
      self.value
    end

    def set_value(x)
      self.value = x
    end
  end

  class SymParametroIn  < SymValue; end
  class SymParametroOut < SymValue; end

  class SymArray < Symbol
    def initialize(ident, line, col, size)
      super(ident, line, col)
      @size  = size
      @array = Array::new(@size)
    end

    def [](i)
      @array[i]
    end

    def []=(i, value)
      @array[i] = value
    end

    def size
      @array.size
    end

    def get_value(i)
      self[i]
    end

    def set_value(i,x)
      self[i] = x
    end
  end

  class SymProc < Symbol
    attr_reader :tabla, :instruccion

    def initialize(ident, line, col, parametros, definiciones, instruccion)
      super(ident, line, col)
      @tabla = SymTable::new
      parametros.each do |parametro|
        if parametro.kind_of? ParametroIn
          @tabla.insert(SymParametroIn::new(parametro.ident))
        elsif parametro.kind_of? ParametroOut
          @tabla.insert(SymParametroOut::new(parametro.ident))
        end
      end
      @definiciones = definiciones
      @instruccion  = instruccion
    end
  end
end

