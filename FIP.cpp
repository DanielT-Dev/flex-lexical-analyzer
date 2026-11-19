
#include "FIP.h"
#include "SymbolTable.h"
#include <stdexcept>

FIP::FIP() : data(new FIPEntry[16]), count(0), capacity(16) {}

FIP::~FIP() {
    delete[] data;
}

void FIP::resize() {
    int newCapacity = capacity * 2;
    FIPEntry* newData = new FIPEntry[newCapacity];

    for (int i = 0; i < count; ++i)
        newData[i] = data[i];

    delete[] data;
    data = newData;
    capacity = newCapacity;
}

void FIP::add(int code, const std::string& lexeme,
    int line, int column) {
    if (count == capacity)
        resize();

    data[count++] = { code, lexeme, line, column };
}

int FIP::size() const {
    return count;
}

const FIPEntry& FIP::at(int index) const {
    if (index < 0 || index >= count)
        throw std::out_of_range("Invalid FIP index");

    return data[index];
}

void FIP::save(std::ofstream& out,
    const SymbolTable& symbols) const {
    for (int i = 0; i < count; ++i) {
        const FIPEntry& entry = data[i];
        int position = -1;

        if (entry.code == 100 || entry.code == 101)
            position = symbols.findPosition(entry.lexeme);

        out << "(" << entry.code << ", " << position << ")\n";
    }
}
