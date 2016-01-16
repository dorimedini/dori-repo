#!/bin/bash

# Testing directory
testdir="tests"

# Rebuild the program
make clean
make

# Unixify the test files
find $testdir/ -type f -exec dos2unix -q {} \;

# Run example tests
echo "Running example tests:"
for i in `ls $testdir/examples/ | grep -iP 'example\d+.matrix' | sort -n -t_ -k2 | cut -d. -f1`; do
    echo -n "Running $i ... "
	./ex5.exe < $testdir/examples/$i.matrix > $testdir/examples/$i.quads
	# If the tests should output an error, the 'quads' file is the output file.
	# Don't try to run it through bvm.pl, it'll just output an empty file.
	if [ 0 -lt `cat $testdir/examples/$i.quads | grep ERROR | wc -l` ]; then
		cat $testdir/examples/$i.quads > $testdir/examples/$i.our_out
	else
		# There may be input
		if [ 0 -lt `ls $testdir/examples/$i.input | wc -l` ]; then
			./bvm.pl $testdir/examples/$i.quads < $testdir/examples/$i.input > $testdir/examples/$i.our_out
		else
			./bvm.pl $testdir/examples/$i.quads > $testdir/examples/$i.our_out
		fi
	fi
    if diff $testdir/examples/$i.our_out $testdir/examples/$i.out > /dev/null; then
        echo "PASSED"
    else
		echo -e "\n====================================================================================="
        echo "FAILED:"
		echo "-------------------------------------------------------------------------------------"
		echo "INPUT:"
		echo "-------------------------------------------------------------------------------------"
		cat $testdir/examples/$i.matrix
		echo -e "\n-------------------------------------------------------------------------------------"
		echo "QUAD OUTPUT:"
		echo "-------------------------------------------------------------------------------------"
        cat $testdir/examples/$i.quads | nl
		echo "-------------------------------------------------------------------------------------"
		echo "SDIFF:"
		echo "-------------------------------------------------------------------------------------"
        sdiff $testdir/examples/$i.our_out $testdir/examples/$i.out
		echo "-------------------------------------------------------------------------------------"
		echo "====================================================================================="
    fi
done

# Define custom test types
test_types=(
	"declarations" 
	"matrix_declarations"
	"declaration_scoping"
	"other_scoping"
	"arithmetic"
	"stack_reuse"
)


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
