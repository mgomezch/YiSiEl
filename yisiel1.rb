#!/usr/bin/env ruby
require 'Lexer'

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
  lexer = Yisiel::Lexer::new(File::read(filename))
rescue Errno::ENOENT => e
  puts e
  exit -1
end

go = true
while go
  begin
    go = lexer.yylex
    puts go unless go == nil
  rescue Yisiel::FatalException => e
    puts e
    exit -1
  rescue Yisiel::LexerException => e
    puts e
    lexer.skip(" ")
  end
end

