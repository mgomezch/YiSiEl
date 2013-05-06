#!/usr/bin/env ruby
require 'Interpreter2'

case ARGV.size
  when 0
    print "Archivo a interpretar: "
    filename = gets[0..-2]
  when 1
    filename = ARGV[0]
  else
    puts "USO: #{$0} [archivo]"
    exit -1
end

begin
  ast = Yisiel::Parser::new.parse(Yisiel::Lexer.new(File::read(filename)))
  ast.run if ast # TODO: check exceptions
rescue Yisiel::ParseError => e
  puts e
end

