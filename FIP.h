
#pragma once
#include <string>
#include <fstream>

class SymbolTable;

struct FIPEntry {
    int code;
    std::string lexeme;
    int line;
    int column;
};

class FIP {
private:
    FIPEntry* data;
    int count;
    int capacity;

    void resize();

public:
    FIP();
    ~FIP();

    FIP(const FIP&) = delete;
    FIP& operator=(const FIP&) = delete;

    void add(int code, const std::string& lexeme,
        int line, int column);

    int size() const;
    const FIPEntry& at(int index) const;

    void save(std::ofstream& out,
        const SymbolTable& symbols) const;
};
