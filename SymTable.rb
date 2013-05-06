module Yisiel
  class SymTable
    def initialize
      @vars = Hash::new
    end

    def insert(symbol)
      return nil unless find(symbol.id)
      @vars[symbol.id] = symbol
    end

    def find(id)
      return @vars[id]
    end

    def delete(id)
      @vars.delete(id)
    end
  end
end

