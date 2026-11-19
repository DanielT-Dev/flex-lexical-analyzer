# Flex Lexical Analyzer

A C++ lexical analyzer implemented using **Flex (Fast Lexical Analyzer Generator)** for a university compiler design laboratory.

## Features

- Recognition of keywords, identifiers, constants, operators and separators.
- Regular expressions for lexical token definitions.
- Generation of the **Form of Internal Representation (FIP)**.
- Symbol Table generation.
- Lexical error detection with line and column reporting.
- Support for single-line and multiline comments.

## Requirements

- Flex
- g++
- Linux / Ubuntu

## Compilation

```bash
flex lexer.l
g++ -std=c++17 lex.yy.c main.cpp FIP.cpp SymbolTable.cpp -o Lexer
```

## Usage

```bash
./Lexer Program.txt
```

The analyzer generates:
- `FIP.txt` – Internal representation of recognized tokens.
- `TS.txt` – Symbol Table.
- `errors.txt` – Lexical errors, including their line and column numbers.
