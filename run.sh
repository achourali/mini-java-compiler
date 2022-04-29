
cp ./src/semanticAnalyser.c ./build/semanticAnalyser.c && \
cp ./src/semanticAnalyser.h ./build/semanticAnalyser.h && \
flex -o ./build/lex.yy.c ./src/lexicalAnalyser.lex  && \
bison -d -o ./build/syntaxiqueAnalyser.tab.c ./src/syntaxiqueAnalyser.y && \
gcc -o ./build/a.out ./build/lex.yy.c  ./build/syntaxiqueAnalyser.tab.c ./build/semanticAnalyser.c && \
./build/a.out