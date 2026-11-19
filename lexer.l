
%option noyywrap nodefault

%x COMMENT

%{
#include <iostream>
#include <fstream>
#include <string>

#include "FIP.h"
#include "SymbolTable.h"

SymbolTable symbols;
FIP fip;
std::ofstream errors;

int currentLine = 1;
int currentColumn = 1;
int tokenLine = 1;
int tokenColumn = 1;
int commentStartLine = 1;
int errorCount = 0;

void addToken(int code, const char* text, const char* type = "") {
    std::string lexeme(text);

    if (code == 100 || code == 101) {
        symbols.insert(lexeme, type);
    }

    fip.add(code, lexeme, tokenLine, tokenColumn);
}

void reportError(const std::string& message) {
    errors << "Lexical error at line " << tokenLine
           << ", column " << tokenColumn << ": "
           << message << '\n';
    errorCount++;
}

#define YY_USER_ACTION                                      \
    tokenLine = currentLine;                                \
    tokenColumn = currentColumn;                             \
    for (int i = 0; i < yyleng; i++) {                       \
        if (yytext[i] == '\n') {                             \
            currentLine++;                                   \
            currentColumn = 1;                               \
        } else {                                              \
            currentColumn++;                                 \
        }                                                    \
    }
%}

DIGIT       [0-9]
LETTER      [a-zA-Z_]
ID          {LETTER}[a-zA-Z0-9_]*
INTEGER     ({DIGIT}+|0[xX][0-9a-fA-F]+)
REAL        (({DIGIT}+\.{DIGIT}*|\.{DIGIT}+)([eE][+-]?{DIGIT}+)?|{DIGIT}+[eE][+-]?{DIGIT}+)
STRING      \"([^\\\"\n]|\\.)*\"
CHAR        \'([^\\'\n]|\\.)\'

%%

[ \t\r]+                { }
\n                      { }

"//"[^\n]*              { }

"/*"                    {
                            commentStartLine = tokenLine;
                            BEGIN(COMMENT);
                        }

<COMMENT>"*/"           { BEGIN(INITIAL); }
<COMMENT>\n             { }
<COMMENT>.              { }

<COMMENT><<EOF>>        {
                            tokenLine = commentStartLine;
                            reportError("Unterminated block comment");
                            return 0;
                        }

"int"                   { addToken(1, yytext); }
"float"                 { addToken(2, yytext); }
"double"                { addToken(3, yytext); }
"char"                  { addToken(4, yytext); }
"bool"                  { addToken(5, yytext); }
"void"                  { addToken(6, yytext); }
"if"                    { addToken(7, yytext); }
"else"                  { addToken(8, yytext); }
"while"                 { addToken(9, yytext); }
"for"                   { addToken(10, yytext); }
"do"                    { addToken(11, yytext); }
"return"                { addToken(12, yytext); }
"break"                 { addToken(13, yytext); }
"continue"              { addToken(14, yytext); }
"const"                 { addToken(15, yytext); }
"using"                 { addToken(16, yytext); }
"namespace"             { addToken(17, yytext); }
"std"                   { addToken(18, yytext); }
"class"                 { addToken(19, yytext); }
"public"                { addToken(20, yytext); }
"private"               { addToken(21, yytext); }
"static"                { addToken(22, yytext); }
"endl"                  { addToken(25, yytext); }
"auto"                  { addToken(26, yytext); }
"long"                  { addToken(27, yytext); }
"short"                 { addToken(28, yytext); }
"unsigned"              { addToken(29, yytext); }

"switch"                { addToken(120, yytext); }
"case"                  { addToken(121, yytext); }
"default"               { addToken(122, yytext); }
"struct"                { addToken(123, yytext); }
"enum"                  { addToken(124, yytext); }
"new"                   { addToken(125, yytext); }
"delete"                { addToken(126, yytext); }
"this"                  { addToken(127, yytext); }
"try"                   { addToken(128, yytext); }
"catch"                 { addToken(129, yytext); }
"throw"                 { addToken(130, yytext); }
"string"                { addToken(10001, yytext); }

"true"|"false"          { addToken(101, yytext, "constant"); }

{REAL}                  { addToken(101, yytext, "constant"); }
{INTEGER}               { addToken(101, yytext, "constant"); }
{STRING}                { addToken(101, yytext, "constant"); }
{CHAR}                  { addToken(101, yytext, "constant"); }

{ID}                    { addToken(100, yytext, "identifier"); }

"..."                   { addToken(103, yytext); }
"<<="                   { addToken(104, yytext); }
">>="                   { addToken(105, yytext); }
"->*"                   { addToken(106, yytext); }
"<=>"                   { addToken(107, yytext); }

"++"                    { addToken(30, yytext); }
"--"                    { addToken(31, yytext); }
"=="                    { addToken(32, yytext); }
"!="                    { addToken(33, yytext); }
"<="                    { addToken(34, yytext); }
">="                    { addToken(35, yytext); }
"&&"                    { addToken(36, yytext); }
"||"                    { addToken(37, yytext); }
"+="                    { addToken(38, yytext); }
"-="                    { addToken(39, yytext); }
"*="                    { addToken(40, yytext); }
"/="                    { addToken(41, yytext); }
"%="                    { addToken(42, yytext); }
"<<"                    { addToken(43, yytext); }
">>"                    { addToken(44, yytext); }
"->"                    { addToken(45, yytext); }
"::"                    { addToken(46, yytext); }
".*"                    { addToken(47, yytext); }
"&="                    { addToken(48, yytext); }
"|="                    { addToken(49, yytext); }
"^="                    { addToken(50, yytext); }
"##"                    { addToken(51, yytext); }

"+"                     { addToken(52, yytext); }
"-"                     { addToken(53, yytext); }
"*"                     { addToken(54, yytext); }
"/"                     { addToken(55, yytext); }
"%"                     { addToken(56, yytext); }
"="                     { addToken(57, yytext); }
"<"                     { addToken(58, yytext); }
">"                     { addToken(59, yytext); }
"!"                     { addToken(60, yytext); }
"&"                     { addToken(61, yytext); }
"|"                     { addToken(62, yytext); }
"^"                     { addToken(63, yytext); }
"~"                     { addToken(64, yytext); }
"?"                     { addToken(65, yytext); }
":"                     { addToken(66, yytext); }
";"                     { addToken(67, yytext); }
","                     { addToken(68, yytext); }
"("                     { addToken(69, yytext); }
")"                     { addToken(70, yytext); }
"{"                     { addToken(71, yytext); }
"}"                     { addToken(72, yytext); }
"["                     { addToken(73, yytext); }
"]"                     { addToken(74, yytext); }
"."                     { addToken(75, yytext); }
"#"                     { addToken(76, yytext); }

\"([^\\\"\n]|\\.)*     { reportError("Unterminated string constant"); }
\'([^\\'\n]|\\.)*      { reportError("Unterminated character constant"); }

.                       {
                            reportError(std::string("Unknown character: ") + yytext);
                        }

%%
