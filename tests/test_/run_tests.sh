TESTS_DIR=aviv_tomer_tests
EXAMPLES_DIR=examples

function run_test {
    if [[ $# -lt 2 ]]; then
        echo "Usage: $0 INPUT_C_MATRIX_FILE OBJECT_QUADS_FILE [INPUT_FOR_PROGRAM]"
        echo "Runs the program with the input file, outputs the quads output to the object"
        echo "quads file, and prints the output of bvm run with the quads file."
        echo "If a program input file is provided, its contents are supplied to the program."
        exit 1
    fi

    PROGRAM_FILE="$1"
    QUADS_FILE="$2"
    INPUT_FOR_PROGRAM="$3"

    cat "${PROGRAM_FILE}" | ./ex5.exe > ${QUADS_FILE}
    if [[ $? -eq 0 ]]; then
        if [ -e "${INPUT_FOR_PROGRAM}" ]; then
            ./bvm.pl ${QUADS_FILE} < ${INPUT_FOR_PROGRAM}
        else
            ./bvm.pl ${QUADS_FILE}
        fi
    else
        cat ${QUADS_FILE}
    fi
}


echo "Running example tests:"
for i in `ls ${EXAMPLES_DIR}/ | grep -iP 'example_\d+.matrix' | sort -n -t_ -k2 | cut -d. -f1`; do
    input_file=""
    if [ -e ${EXAMPLES_DIR}/$i.input ]; then
        input_file="${EXAMPLES_DIR}/$i.input"
    fi

    echo -n "Running $i ... "

    if run_test ${EXAMPLES_DIR}/$i.matrix ${EXAMPLES_DIR}/$i.quads ${input_file} | diff - ${EXAMPLES_DIR}/$i.out > /dev/null; then
        echo "PASSED"
    else
        echo "FAILED:"
        run_test ${EXAMPLES_DIR}/$i.matrix ${EXAMPLES_DIR}/$i.quads ${input_file} | diff -y - ${EXAMPLES_DIR}/$i.out
    fi
done

echo ""
echo "Running our tests:"
for i in `ls ${TESTS_DIR}/ | grep -iP 'test_\d+.matrix' | sort -n -t_ -k2 | cut -d. -f1`; do
    input_file=""
    if [ -e ${TESTS_DIR}/$i.input ]; then
        input_file="${TESTS_DIR}/$i.input"
    fi

    echo -n "Running $i ... "

    if run_test ${TESTS_DIR}/$i.matrix ${TESTS_DIR}/$i.quads ${input_file} | diff - ${TESTS_DIR}/$i.out > /dev/null; then
        echo "PASSED"
    else
        echo "FAILED:"
        run_test ${TESTS_DIR}/$i.matrix ${TESTS_DIR}/$i.quads ${input_file} | diff -y - ${TESTS_DIR}/$i.out
    fi
done
