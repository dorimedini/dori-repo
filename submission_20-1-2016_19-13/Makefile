all: ex5.exe

matrixer.tab.cpp matrixer.tab.hpp:	matrixer.ypp
	bison -d matrixer.ypp

bp.o:	bp.hpp bp.cpp
	g++ -g -c -o bp.o bp.cpp

attributes.o:	attributes.h attributes.cpp
	g++ -g -c -o attributes.o attributes.cpp

lex.yy.c: matrixer.lex matrixer.tab.hpp bp.o attributes.o
	flex matrixer.lex

ex5.exe: lex.yy.c matrixer.tab.cpp matrixer.tab.hpp bp.hpp
	g++ -g -o ex5.exe matrixer.tab.cpp lex.yy.c bp.o attributes.o

clean:
	rm -f matrixer matrixer.tab.cpp lex.yy.c matrixer.tab.hpp bp.o attributes.o
