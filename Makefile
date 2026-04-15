CC = gcc
LEX = flex
YACC = bison
CFLAGS = -Wall

all: mini_compiler

mini_compiler: lex.yy.c parser.tab.c
	$(CC) $(CFLAGS) parser.tab.c lex.yy.c -o mini_compiler

lex.yy.c: scanner.l parser.tab.h
	$(LEX) scanner.l

parser.tab.c parser.tab.h: parser.y
	$(YACC) -d parser.y

clean:
	rm -f mini_compiler lex.yy.c parser.tab.c parser.tab.h
