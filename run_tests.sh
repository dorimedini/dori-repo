#!/bin/bash

# TO USE:
# This script (run_tests.sh) expects this hierarchy:
# ./run_tests.sh
# ./ex5.exe
# ./tests/arithmetic
# ./tests/example
# And so on. You can change "tests/" to something else by changing $testdir.
#
# To run a specific test (for example, arithmetic18.matrix) just call the script like so:
# ./run_tests.sh arithmetic 18

# Testing directory
testdir="tests"

# Define custom test types
test_types=(
	"example"
	"declarations" 
	"declaration_scoping"
	"other_scoping"
	"arithmetic"
	"stack_reuse"
	"conditionals"
	"loops"
)

# Rebuild the program
make clean
make

# Unixify the test files
find $testdir/ -type f -exec dos2unix -q {} \;

# Run one test
function do_test {
	echo -n "Running $2 ... "
	./ex5.exe < $testdir/$1/$2.matrix > $testdir/$1/$2.quads
	# If the tests should output an error, the 'quads' file is the output file.
	# Don't try to run it through bvm.pl, it'll just output an empty file.
	if [ 0 -lt `cat $testdir/$1/$2.quads | grep ERROR | wc -l` ]; then
		cat $testdir/$1/$2.quads > $testdir/$1/$2.our_out
	else
		# There may be input. Look for $2.input file
		if [ 0 -lt `ls $testdir/$1/$2* | grep input | wc -l` ]; then
			./bvm.pl $testdir/$1/$2.quads < $testdir/$1/$2.input > $testdir/$1/$2.our_out
		else
			./bvm.pl $testdir/$1/$2.quads > $testdir/$1/$2.our_out
		fi
	fi
	if diff $testdir/$1/$2.our_out $testdir/$1/$2.out > /dev/null; then
		echo "PASSED"
	else
		echo -e "\n====================================================================================="
		echo "FAILED:"
		echo "-------------------------------------------------------------------------------------"
		echo "INPUT:"
		echo "-------------------------------------------------------------------------------------"
		cat $testdir/$1/$2.matrix
		echo -e "\n-------------------------------------------------------------------------------------"
		echo "QUAD OUTPUT:"
		echo "-------------------------------------------------------------------------------------"
		cat $testdir/$1/$2.quads | nl
		echo "-------------------------------------------------------------------------------------"
		echo "SDIFF:"
		echo "-------------------------------------------------------------------------------------"
		sdiff $testdir/$1/$2.our_out $testdir/$1/$2.out
		echo "-------------------------------------------------------------------------------------"
		echo "====================================================================================="
	fi
}

# Run example tests
function run_test {
	echo "Running $1 tests:"
	for i in `ls $testdir/$1/ | grep -iP "$1\d+.matrix" | sort -n -t_ -k2 | cut -d. -f1`; do
		do_test $1 $i
	done
}

# If asked by the user, run only a specific test:
if [ -n "$1" ]; then
	echo "*************************************************************************************"
	do_test $1 "$1$2"
	echo "*************************************************************************************"
# Otherwise, run custom tests
else
	for test in ${test_types[@]}; do
		echo "*************************************************************************************"
		echo "*************************************************************************************"
		echo "*************************************************************************************"
		run_test $test
	done
fi

