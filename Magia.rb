module Magia
  # Define las jerarquías de tipos especificadas por cada elemento de "trees".
  #
  # El argumento "trees" debe ser un arreglo cuyos elementos deben ser arreglos
  # de la forma [name, args, children], donde
  # - "name" es una cadena de caracteres con el nombre de la clase a ser creada.
  #   Ésta debe ser una cadena válida para un identificador constante en Ruby.
  # - "args" es un arreglo de cadenas de caracteres, cada una de las cuales debe
  #   ser un identificador válido para un método de una clase en Ruby.  Cada una
  #   de estas cadenas representará una de las variables de instancia de la
  #   nueva clase; se definirán, adicionalmente, métodos con los mismos nombres
  #   para realizar la lectura y asignación a estas variables de instancia, y el
  #   método inicializador de la clase inicializará estas variables de instancia
  #   con los valores suministrados como argumentos al método inicializador en
  #   el mismo orden en que aparecen en este arreglo.
  # - "children" es un arreglo cuyos elementos cumplen con este mismo patrón,
  #   especificando, cada uno, una jerarquía de subclases para la clase que está
  #   siendo descrita.  A los nombres de las subclases se les agrega como
  #   prefijo el nombre de su superclase (el contenido de la cadena "name").
  #   Note que esto reduce las restricciones sobre las cadenas de caracteres que
  #   especificarán los nombres de las subclases (por ejemplo, no será necesario
  #   que comienzen con una letra mayúscula, ya que el prefijo agregado asegura
  #   que se cumpla con esta restricción); sin embargo, se considera preferible
  #   que los nombres de las subclases sean, por sí solos, nombres válidos para
  #   identificadores constantes en Ruby.
  #   Los métodos inicializadores de las subclases tomarán como argumentos todos
  #   los valores necesarios para inicializar las variables de instancia de su
  #   superclase y para inicializar las variables de instancia propias de la
  #   subclase, en ese órden.  Como las subclases tendrán variables de instancia
  #   cuyos nombres serán iguales a los de las variables correspondientes en su
  #   superclase, las palabras en el arreglo "args" no deben ocurrir en los
  #   arreglos análogos de ninguna de sus subclases.
  #
  # Las clases en la raíz de las jerarquías de clases creadas heredadán de la
  # clase Object (como (casi) todo lo demás en Ruby).
  #
  # El argumento "context" especifica el módulo en el que deben ser definidas
  # las nuevas jerarquías de clase.  Si no se desea usar un módulo particular,
  # puede usarse el módulo Object, con el que se obtendrán definiciones en el
  # namespace principal.
  #
  # Ejemplo:
  # Supongamos que se definió
  # >> module Context; end
  # >> context = Context
  # >> trees = [
  # ?>  [
  # ?>    "A",
  # ?>    "a1 a2",
  # ?>    [
  # ?>      ["B", "b", []],
  # ?>      ["C", ""  , []]
  # ?>    ]
  # ?>  ],
  # ?>  ["D", "d1", []]
  # ?> ]
  #
  # Evaluar
  # >> Magia::define_types(trees, context)
  # será equivalente a evaluar el siguiente código:
  # module Context
  #   class A
  #     attr_accessor :a1, :a2
  #     def initialize(a1, a2)
  #       @a1 = a1
  #       @a2 = a2
  #     end
  #   end
  #   class AB < A
  #     attr_accessor :b
  #     def initialize(a1, a2, b)
  #       super(a1, a2)
  #       @b = b
  #     end
  #   end
  #   class AC < A
  #     def initialize(a1, a2)
  #       super(a1, a2)
  #     end
  #   end
  #   class D
  #     attr_accessor :d
  #     def initialize(d)
  #       @d = d
  #     end
  #   end
  # end
  #
  def Magia::define_types(trees, context)
    define_types_r(Object, [], trees, context)
  end

  # Procesa recursivamente una lista de árboles de tipos utilizando técnicas de
  # metaprogramación para producir las clases especificadas.  Basado en ideas de
  # http://olabini.com/blog/2006/09/ruby-metaprogramming-techniques/ y
  # http://olabini.com/blog/2008/05/dynamically-created-methods-in-ruby/
  def Magia::define_types_r(parent, p_attrs, trees, context)
    # Se procesa cada elemento de la jerarquía actual.
    trees.each do |name, attrs, children|
      # Herencia de atributos
      attrs = p_attrs + attrs

      # Creación de la clase.
      newclass = Class::new(parent)

      # Definición de la clase.
      if parent != Object
        context::const_set(parent.name.match(/[A-Z]\w*$/).to_s + name, newclass)
      else
        context::const_set(name, newclass)
      end

      # Clausura para el código del método de inicialización de la clase.
      block = lambda do |*args|
        raise ArgumentError::new(
          "wrong number of arguments (#{args.size} for #{attrs.size})"
        ) unless args.size == attrs.size
        [attrs,args].transpose.map do |attr, arg|
          self.instance_variable_set("@" + attr, arg)
        end
      end

      # Definición del método de inicialización de la clase.
      newclass.class_eval do
        define_method("initialize", block)
      end

      # Definición de los accesores para los atributos de la clase.
      attrs.each do |attr|
        newclass.class_eval do
          block = lambda {       instance_variable_get("@" + attr     ) }
          define_method(attr, block)
          block = lambda { |arg| instance_variable_set("@" + attr, arg) }
          define_method(attr + "=", block)
        end
      end

      # Llamada recursiva para crear todas las clases que deben heredar de ésta.
      Magia::define_types_r(newclass, attrs, children, context)
    end
  end
end

