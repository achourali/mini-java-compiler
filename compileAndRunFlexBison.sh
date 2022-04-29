flex -o ./build/lex.yy.c ./src/lexicalAnalyser.lex  && \
bison -d -o ./build/syntaxiqueAnalyser.tab.c ./src/syntaxiqueAnalyser.y && \
gcc -o ./build/a.out ./build/lex.yy.c  ./build/syntaxiqueAnalyser.tab.c  && \
./build/a.out
