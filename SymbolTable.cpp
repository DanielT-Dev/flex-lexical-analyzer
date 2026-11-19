
#include "SymbolTable.h"
#include <stdexcept>

SymbolTable::SymbolTable()
    : data(new Symbol[8]), count(0), capacity(8) {
}

SymbolTable::~SymbolTable() {
    delete[] data;
}

void SymbolTable::resize() {
    int newCapacity = capacity * 2;
    Symbol* newData = new Symbol[newCapacity];

    for (int i = 0; i < count; ++i)
        newData[i] = data[i];

    delete[] data;
    data = newData;
    capacity = newCapacity;
}

int SymbolTable::findPosition(const std::string& value) const {
    int left = 0;


    int right = count - 1;

    while (left <= right) {
        int middle = left + (right - left) / 2;

        if (data[middle].value == value)
            return middle + 1; // 1-based TS line number

        if (data[middle].value < value)
            left = middle + 1;
        else
            right = middle - 1;
    }

    return -1;
}

void SymbolTable::insert(
    const std::string& value,
    const std::string& type
) {
    int left = 0;
    int right = count;

    // Find insertion point using binary search.
    while (left < right) {
        int middle = left + (right - left) / 2;

        if (data[middle].value < value)
            left = middle + 1;
        else
            right = middle;
    }

    // The symbol already exists.
    if (left < count&& data[left].value == value)
        return;

    if (count == capacity)
        resize();

    // Shift elements to preserve lexicographic order.
    for (int i = count; i > left; --i)
        data[i] = data[i - 1];

    data[left] = { value, type };
    ++count;
}

int SymbolTable::size() const {
    return count;
}

const Symbol& SymbolTable::at(int index) const {
    if (index < 0 || index >= count)
        throw std::out_of_range("Invalid symbol table index");

    return data[index];
}

void SymbolTable::save(std::ofstream& out) const {
    for (int i = 0; i < count; ++i) {
        out << i + 1 << " | "
            << data[i].value << " | "
            << data[i].type << '\n';
    }
}
