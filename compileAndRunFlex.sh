
# arguments:
#     $1 : path to the java file  

flex -o ./build/lex.yy.c ./src/compiler.lex  && gcc -o ./build/a.out ./build/lex.yy.c  && ./build/a.out $1
