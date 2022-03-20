#include "library.hpp"

int main()
{
    Calculator c;
    c.turnOn();
    c.add(5);
    c.add(4);
    return c.getResult();
}