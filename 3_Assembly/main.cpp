int globalDefinedVar = 56;
int globalUndefinedVar;

double prototype();

int defined() {
    return 6;
}

extern int VAL;

int main()
{
    return globalDefinedVar + 
           globalUndefinedVar + 
           prototype() + 
           defined() +
           VAL;
}