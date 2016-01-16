make clean
make

echo "Running example tests:"
for i in `ls tests/examples/ | grep -iP 'example\d+.matrix' | sort -n -t_ -k2 | cut -d. -f1`; do
    echo -n "Running $i ... "
	./ex5.exe < tests/examples/$i.matrix > tests/examples/$i.quads
	./bvm.pl   tests/examples/$i.quads  >   tests/examples/$i.our_out
    if diff tests/examples/$i.our_out tests/examples/$i.out > /dev/null; then
        echo "PASSED"
    else
		echo "====================================================================================="
        echo "FAILED:"
		echo "-------------------------------------------------------------------------------------"
		echo "INPUT:"
		echo "-------------------------------------------------------------------------------------"
		cat tests/examples/$i.matrix
		echo "-------------------------------------------------------------------------------------"
		echo "QUAD OUTPUT:"
		echo "-------------------------------------------------------------------------------------"
        cat tests/examples/$i.quads | nl
		echo "-------------------------------------------------------------------------------------"
		echo "SDIFF:"
		echo "-------------------------------------------------------------------------------------"
        sdiff tests/examples/$i.our_out tests/examples/$i.out
		echo "-------------------------------------------------------------------------------------"
		echo "====================================================================================="
    fi
done

# Define custom test types.
types=[
	"declarations",
	"matrix_declarations",
	"declaration_scoping",
	"other_scoping",
	"arithmetic",
	"stack_reuse"
]


#echo ""
#echo "Running our tests:"
#for i in `ls tests/ | grep -iP 'test_\d+.in' | sort -n -t_ -k2 | cut -d. -f1`; do
#    echo -n "Running $i ... "
#    if ./ex4.exe < tests/$i.in | diff - tests/$i.out > /dev/null; then
#        echo "PASSED"
#    else
#        echo "FAILED:"
#        ./ex4.exe < tests/$i.in | diff -y - tests/$i.out
#    fi
#done
