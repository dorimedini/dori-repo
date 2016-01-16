To compare the output of your program with the expected output, run the following:

./ex5.exe   <  example1.matrix  >  example1.quads
./bvm.pl   example1.quads  >   example1.myOut
diff   example1.myOut   example1.out


./ex5.exe   <  example2.matrix  >  example2.quads
./bvm.pl   example2.quads  >   example2.myOut
diff   example2.myOut   example2.out


./ex5.exe   <  example3.matrix  >  example3.quads
./bvm.pl   example3.quads  < example3.input   >   example3.myOut
diff   example3.myOut   example3.out


./ex5.exe   <  example4.matrix  >  example4.myOut
diff   example4.myOut   example4.out