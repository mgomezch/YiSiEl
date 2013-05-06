RACC_FLAGS=-g -v # DEBUG
#RACC_FLAGS=
RACC=racc
RDOC=rdoc

all: entrega3

entrega1:
	rm -f yisiel.rb informe.pdf
	ln -s yisiel1.rb yisiel.rb
	ln -s informe1.pdf informe.pdf

entrega2: Parser.rb
	rm -f yisiel.rb informe.pdf
	ln -s yisiel2.rb yisiel.rb
	ln -s informe2.pdf informe.pdf

entrega3: Parser.rb
	rm -f yisiel.rb informe.pdf
	ln -s yisiel3.rb yisiel.rb
	ln -s informe3.pdf informe.pdf

entrega32: Parser2.rb
	rm -f yisiel.rb informe.pdf
	ln -s yisiel32.rb yisiel.rb
	ln -s informe32.pdf informe.pdf

Parser.rb: Parser.y
	${RACC} ${RACC_FLAGS} -o Parser.rb Parser.y

Parser2.rb: Parser2.y
	${RACC} ${RACC_FLAGS} -o Parser2.rb Parser2.y

clean:
	rm -rf Parser.rb Parser.output doc yisiel.rb informe.pdf

doc: Token.rb Lexer.rb AST.rb yisiel.rb
	${RDOC} --charset utf-8

