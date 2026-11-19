
#pragma once
#include <string>
#include <fstream>

struct Symbol {
    std::string value;
    std::string type;
};

class SymbolTable {
private:
    Symbol* data;
    int count;
    int capacity;

    void resize();

public:
    SymbolTable();
    ~SymbolTable();

    SymbolTable(const SymbolTable&) = delete;
    SymbolTable& operator=(const SymbolTable&) = delete;

    void insert(const std::string& value, const std::string& type);
    int findPosition(const std::string& value) const;
    int size() const;
    const Symbol& at(int index) const;
    void save(std::ofstream& out) const;
};
