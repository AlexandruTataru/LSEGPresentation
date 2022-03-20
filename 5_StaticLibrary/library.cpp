#include "library.hpp"

Calculator::Calculator() : working(false), currentResult(0) {}

void Calculator::turnOn()
{
    working = true;
}

void Calculator::add(unsigned short number)
{
    if (working)
    {
        currentResult += number;
    }
}

int Calculator::getResult()
{
    return working ? currentResult : -1;
}