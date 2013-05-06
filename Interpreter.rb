require 'Parser'

# TODO: use Symbol/SymTable (generate it statically)
# TODO: make exceptions instead of throwing strings

$values = Hash::new
$arrays = Hash::new
$procs  = Hash::new

module Yisiel
  class ReturnException < RuntimeError; end

  class Programa
    def run
      @definiciones.each do |definicion|
        definicion.run
      end
      $globalvalues = $values
      $globalarrays = $arrays
      @procedimientos.each do |procedimiento|
        procedimiento.run
      end
      @instrucciones.each do |instruccion|
        instruccion.run
      end
    end
  end

  class DefinicionValue
    def run
      if $values.has_key? @ident or $arrays.has_key? @ident
        raise "La variable #{@ident} ya está definida :-("
      end
      $values[@ident] = false
      return
    end
  end

  class DefinicionArray
    def run
      if $values.has_key? @ident or $arrays.has_key? @ident
        raise "La variable #{@ident} ya está definida :-("
      end
      $arrays[@ident] = [false]*@size
      return
    end
  end

  class InstruccionAsignacion
    def run
      valores = @expresiones.map { |e| e.run }
      @lvalues.each_with_index do |lvalue, i|
        if lvalue.kind_of? LValueValue
          if not $values.has_key? lvalue.ident
            raise "La variable #{lvalue.ident}, usada en la línea #{lvalue.line}, columna #{lvalue.col}, no está definida :-("
          end
          $values[lvalue.ident] = valores[i]
          return
        elsif lvalue.kind_of? LValueArray
          if not $arrays.has_key? lvalue.ident
            raise "El arreglo #{lvalue.ident} no está definido :-("
          end
          j = lvalue.expresion.run
          if 0 <= j && j < $arrays[lvalue.ident].size
            $arrays[lvalue.ident][j] = valores[i]
            return
          end
          raise "El índice #{i} no le sirve al arreglo #{lvalue.ident} :-("
        end
      end
    end
  end

  class InstruccionSeleccion
    def run
      @casos.each do |caso|
        if caso.predicado.run
          caso.instruccion.run
          return
        end
      end
  #   raise "Ningún caso sirvió :-("
    end
  end

  class InstruccionRepeticion
    def run
      @casos.each do |caso|
        if caso.predicado.run
          caso.instruccion.run
          redo
        end
      end
      return
    end
  end

  class InstruccionBloque
    def run
      @instrucciones.each do |instruccion|
        instruccion.run
      end
      return
    end
  end

  class Procedimiento
    def run
      if $procs.has_key? @ident
        raise "El procedimiento #{@ident} ya está definido :-("
      end
      $procs[ident] = [@parametros, @definiciones, @instruccion]
      return
    end
  end

  class InstruccionInvocar
    def run
      if not $procs.has_key? @ident
        raise "El procedimiento #{@ident} no está definido :-("
      end
      tupla = $procs[@ident]
      parametros   = tupla[0]
      definiciones = tupla[1]
      instruccion  = tupla[2]
      if parametros.size != expresiones.size
        raise "Se llamó al procedimiento #{@ident} con #{@expresiones.size} parámetros, debiendo ser #{parametros.size} :-("
      end
      i = 0
      evaluadas = [false]*(parametros.size)
      [parametros, @expresiones].transpose.each do |parametro, expresion|
        if parametro.is_a? ParametroIn
          evaluadas[i] = expresion.run
        end
        i = i + 1
      end
      savedvalues = $values.clone
      savedarrays = $arrays.clone
      $values = $globalvalues.clone
      $arrays = $globalarrays.clone
      parametros.each do |parametro|
        $values.delete(parametro.ident)
      end
      definiciones.each do |definicion|
        if definicion.is_a? DefinicionValue
          $values.delete(definicion.ident)
        elsif definicion.is_a? DefinicionArray
          $arrays.delete(definicion.ident)
        end
      end
      i = 0
      [parametros, @expresiones].transpose.each do |parametro, expresion|
        if parametro.is_a? ParametroOut
          if not expresion.is_a? ExpresionDefinidoValue
            raise "El parámetro #{parametro.ident} del procedimiento #{@ident} es un parámetro de salida y debe pasársele un identificador de una variable de tipo value, pero se le pasó otra cosa al ser llamado en la línea #{@line}, columna #{col} :-("
          end
          DefinicionValue::new(parametro.ident, parametro.line, parametro.col).run
        elsif parametro.is_a? ParametroIn
          DefinicionValue::new(parametro.ident, parametro.line, parametro.col).run
          InstruccionAsignacion::new(
            [LValueValue::new(parametro.ident, parametro.line, parametro.col)],
            [ExpresionNumero::new(evaluadas[i])]
          ).run
        end
        i = i + 1
      end
      definiciones.each { |definicion| definicion.run }
      begin
        instruccion.run
      rescue ReturnException => e
      end
      results = []
      [parametros, @expresiones].transpose.each do |parametro, expresion|
        if parametro.is_a? ParametroOut
          raise "No se asignó ningún valor al parámetro de salida #{parametro.ident} del procedimiento #{@ident} luego de ser llamado en la línea #{@line}, columna #{@col} :-(" unless $values[parametro.ident]
          results << InstruccionAsignacion::new(
                       [LValueValue::new(expresion.ident, expresion.line, expresion.col)],
                       [ExpresionNumero::new($values[parametro.ident])]
                     )
        end
      end
      $values = savedvalues
      $arrays = savedarrays
      results.each { |i| i.run }
    end
  end

  class ExpresionLongitud
    def run
      if $arrays.has_key? @ident
        return $arrays[@ident].size
      end
      raise "El arreglo #{@ident} no está definido :-("
    end
  end

  class ExpresionDefinidoValue
    def run
      if not $values.has_key? @ident
        raise "El valor #{@ident} no está definido en la línea #{@line}, columna #{@col} :-("
      end
      if $values[@ident] == false
        raise "El valor #{@ident} no ha sido inicializado :-("
      end
      return $values[@ident]
    end
  end

  class ExpresionDefinidoArray
    def run
      if not $arrays.has_key? @ident
        raise "El arreglo #{@ident} no existe :-("
      end
      i = @expresion.run
      if i < 0 && $array[@ident].size <= i
        raise "El índice #{i} no le sirve al arreglo #{@ident} :-("
      end
      if $arrays[@ident][i] == false
        raise "El valor #{@ident}[#{i}] no ha sido inicializado :-("
      end
      return $arrays[@ident][i]
    end
  end

  class InstruccionReturn       ; def run; raise ReturnException::new ; end; end

  class InstruccionVacia        ; def run;                      return; end; end
  class InstruccionShowExpresion; def run; print @expresion.run;return; end; end
  class InstruccionShowString   ; def run; print @string       ;return; end; end

  class ExpresionSuma           ; def run; return @lhs.run +  @rhs.run; end; end
  class ExpresionResta          ; def run; return @lhs.run -  @rhs.run; end; end
  class ExpresionResiduo        ; def run; return @lhs.run %  @rhs.run; end; end
  class ExpresionProducto       ; def run; return @lhs.run *  @rhs.run; end; end
  # TODO: check div by 0
  class ExpresionDivision       ; def run; return @lhs.run /  @rhs.run; end; end
  class ExpresionNumero         ; def run; return @numero             ; end; end
  class ExpresionNegativo       ; def run; return -@expresion.run     ; end; end

  class PredicadoMenor          ; def run; return @lhs.run <  @rhs.run; end; end
  class PredicadoMenorIgual     ; def run; return @lhs.run <= @rhs.run; end; end
  class PredicadoMayor          ; def run; return @lhs.run >  @rhs.run; end; end
  class PredicadoMayorIgual     ; def run; return @lhs.run >= @rhs.run; end; end
  class PredicadoIgual          ; def run; return @lhs.run == @rhs.run; end; end
  class PredicadoNoIgual        ; def run; return @lhs.run != @rhs.run; end; end
  class PredicadoAnd            ; def run; return @lhs.run && @rhs.run; end; end
  class PredicadoOr             ; def run; return @lhs.run || @rhs.run; end; end
  class PredicadoNot            ; def run; return !@predicado.run     ; end; end
  class PredicadoTrue           ; def run; return true                ; end; end
  class PredicadoFalse          ; def run; return false               ; end; end
end

