all: ex4.exe

matrixer.tab.cpp matrixer.tab.hpp:	matrixer.ypp
	bison -d matrixer.ypp

printError.o:	printError.h printError.cpp
	g++ -g -c -o printError.o printError.cpp

attributes.o:	attributes.h attributes.cpp
	g++ -g -c -o attributes.o attributes.cpp

lex.yy.c: matrixer.lex matrixer.tab.hpp printError.o attributes.o
	flex matrixer.lex

ex4.exe: lex.yy.c matrixer.tab.cpp matrixer.tab.hpp printError.h
	g++ -g -o ex4.exe matrixer.tab.cpp lex.yy.c printError.o attributes.o

clean:
	rm -f matrixer matrixer.tab.cpp lex.yy.c matrixer.tab.hpp printError.o attributes.o
