flex lexer.l
g++ -std=c++17 lex.yy.c main.cpp FIP.cpp SymbolTable.cpp -o Lexer
./Lexer Program.txt
