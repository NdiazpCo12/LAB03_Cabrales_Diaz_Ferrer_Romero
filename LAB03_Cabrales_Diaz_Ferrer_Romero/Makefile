PROYECTO = LAB03_Cabrales_Diaz_Ferrer_Romero
LEXER    = $(PROYECTO).l
PARSER   = $(PROYECTO).y

all: $(PROYECTO)

$(PROYECTO): $(PROYECTO).tab.c lex.yy.c
	gcc -o $(PROYECTO) $(PROYECTO).tab.c lex.yy.c -lfl

$(PROYECTO).tab.c: $(PARSER)
	bison -d $(PARSER) -o $(PROYECTO).tab.c

lex.yy.c: $(LEXER) $(PROYECTO).tab.h
	flex $(LEXER)

clean:
	rm -f $(PROYECTO) $(PROYECTO).tab.c $(PROYECTO).tab.h lex.yy.c salida.txt
