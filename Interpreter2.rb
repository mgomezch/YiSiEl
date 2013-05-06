require 'Parser2'

# TODO: use Symbol/SymTable (generate it statically)
# TODO: make exceptions instead of throwing strings

$values = Hash::new
$arrays = Hash::new
$procs  = Hash::new

module Yisiel
  class ReturnException < RuntimeError; end

  class ASTProg
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

  class ASTDefValue
    def run
      if $values.has_key? @ident or $arrays.has_key? @ident
        raise "La variable #{@ident} ya está definida :-("
      end
      $values[@ident] = false
      return
    end
  end

  class ASTDefArray
    def run
      if $values.has_key? @ident or $arrays.has_key? @ident
        raise "La variable #{@ident} ya está definida :-("
      end
      $arrays[@ident] = [false]*@size
      return
    end
  end

  class ASTStmtSet
    def run
      valores = @expresiones.map { |e| e.run }
      @lvalues.each_with_index do |lvalue, i|
        if lvalue.kind_of? ASTLValueValue
          if not $values.has_key? lvalue.ident
            raise "La variable #{lvalue.ident}, usada en la línea #{lvalue.line}, columna #{lvalue.col}, no está definida :-("
          end
          $values[lvalue.ident] = valores[i]
          return
        elsif lvalue.kind_of? ASTLValueArray
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

  class ASTStmtIf
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

  class ASTStmtDo
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

  class ASTStmtBlock
    def run
      @instrucciones.each do |instruccion|
        instruccion.run
      end
      return
    end
  end

  class ASTProc
    def run
      if $procs.has_key? @ident
        raise "El procedimiento #{@ident} ya está definido :-("
      end
      $procs[ident] = [@parametros, @definiciones, @instruccion]
      return
    end
  end

  class ASTStmtCall
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
        if parametro.is_a? ASTParamIn
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
        if definicion.is_a? ASTDefValue
          $values.delete(definicion.ident)
        elsif definicion.is_a? ASTDefArray
          $arrays.delete(definicion.ident)
        end
      end
      i = 0
      [parametros, @expresiones].transpose.each do |parametro, expresion|
        if parametro.is_a? ASTParamOut
          if not expresion.is_a? ASTMathDefValue
            raise "El parámetro #{parametro.ident} del procedimiento #{@ident} es un parámetro de salida y debe pasársele un identificador de una variable de tipo value, pero se le pasó otra cosa al ser llamado en la línea #{@line}, columna #{col} :-("
          end
          ASTDefValue::new(parametro.ident, parametro.line, parametro.col).run
        elsif parametro.is_a? ASTParamIn
          ASTDefValue::new(parametro.ident, parametro.line, parametro.col).run
          ASTStmtSet::new(
            [ASTLValueValue::new(parametro.ident, parametro.line, parametro.col)],
            [ASTMathNum::new(evaluadas[i])]
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
        if parametro.is_a? ASTParamOut
          raise "No se asignó ningún valor al parámetro de salida #{parametro.ident} del procedimiento #{@ident} luego de ser llamado en la línea #{@line}, columna #{@col} :-(" unless $values[parametro.ident]
          results << ASTStmtSet::new(
                       [ASTLValueValue::new(expresion.ident, expresion.line, expresion.col)],
                       [ASTMathNum::new($values[parametro.ident])]
                     )
        end
      end
      $values = savedvalues
      $arrays = savedarrays
      results.each { |i| i.run }
    end
  end

  class ASTMathSize
    def run
      if $arrays.has_key? @ident
        return $arrays[@ident].size
      end
      raise "El arreglo #{@ident} no está definido :-("
    end
  end

  class ASTMathDefValue
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

  class ASTMathDefArray
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

  class ASTStmtRet     ; def run; raise ReturnException::new ; end; end
  class ASTStmtSkip    ; def run;                      return; end; end
  class ASTStmtShowMath; def run; print @expresion.run;return; end; end
  class ASTStmtShowStr ; def run; print @string       ;return; end; end

  class ASTMathAdd     ; def run; return @lhs.run +  @rhs.run; end; end
  class ASTMathSub     ; def run; return @lhs.run -  @rhs.run; end; end
  class ASTMathMod     ; def run; return @lhs.run %  @rhs.run; end; end
  class ASTMathProd    ; def run; return @lhs.run *  @rhs.run; end; end
  # TODO: check div by 0
  class ASTMathDiv     ; def run; return @lhs.run /  @rhs.run; end; end
  class ASTMathNum     ; def run; return @numero             ; end; end
  class ASTMathNeg     ; def run; return -@expresion.run     ; end; end

  class ASTBoolL       ; def run; return @lhs.run <  @rhs.run; end; end
  class ASTBoolLE      ; def run; return @lhs.run <= @rhs.run; end; end
  class ASTBoolG       ; def run; return @lhs.run >  @rhs.run; end; end
  class ASTBoolGE      ; def run; return @lhs.run >= @rhs.run; end; end
  class ASTBoolE       ; def run; return @lhs.run == @rhs.run; end; end
  class ASTBoolNE      ; def run; return @lhs.run != @rhs.run; end; end
  class ASTBoolAnd     ; def run; return @lhs.run && @rhs.run; end; end
  class ASTBoolOr      ; def run; return @lhs.run || @rhs.run; end; end
  class ASTBoolNot     ; def run; return !@predicado.run     ; end; end
  class ASTBoolTrue    ; def run; return true                ; end; end
  class ASTBoolFalse   ; def run; return false               ; end; end
end

