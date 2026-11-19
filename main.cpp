
#include <iostream>
#include <fstream>
#include <cstdio>

#include "FIP.h"
#include "SymbolTable.h"

extern FILE* yyin;
int yylex();

extern SymbolTable symbols;
extern FIP fip;
extern std::ofstream errors;
extern int errorCount;

int main(int argc, char* argv[]) {
    if (argc < 2) {
        std::cerr << "Usage: ./Lexer <input_file>\n";
        return 1;
    }

    yyin = fopen(argv[1], "r");

    if (!yyin) {
        std::cerr << "Cannot open input file: " << argv[1] << '\n';
        return 1;
    }

    errors.open("errors.txt");

    yylex();

    fclose(yyin);
    errors.close();

    std::ofstream fipFile("FIP.txt");
    fip.save(fipFile, symbols);
    fipFile.close();

    std::ofstream symbolFile("TS.txt");
    symbols.save(symbolFile);
    symbolFile.close();

    std::cout << "Lexical analysis completed.\n";
    std::cout << "Tokens: " << fip.size() << '\n';
    std::cout << "Errors: " << errorCount << '\n';

    return errorCount > 0 ? 1 : 0;
}
