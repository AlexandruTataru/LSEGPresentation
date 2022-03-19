### From Source to Executable
#### About the author
My name is Tataru Alexandru Flavian, I am a software engineer for 12 years and an LSEG employee for over 3 years.

#### Preprocessing

```c++
#define POSITIVE_ERRORS

//#include "utilities.hpp"
#define RET_VAL_OK 0
#ifdef POSITIVE_ERRORS
    #define RET_VAL_ERR 1
#else
    #define RET_VAL_ERR -1
#endif

#define CONCAT(a, b) a##b

#define SUM(a, b) a + b + __cplusplus

int sum(int a, int b) {
    return SUM(a, b);
}

#define PROCESS_THE_ENTIRE_FILE

/*
 * This is a comment
 */
int main(int argc, char* argv[]) {
    #line 300 "program.cpp"
    if(CONCAT(arg, c) != 3) {
        return RET_VAL_ERR;
    }
    if(sum(4, 5) > __LINE__) {
        return RET_VAL_ERR;
    }
    #ifndef PROCESS_THE_ENTIRE_FILE
        #error "Flag set to not process entire file for demo purpose"
    #endif
    return RET_VAL_OK;
}
```
To get the proprocessed output of the above code we have to do the following
```zsh
$ g++ -E main.cpp
```
Which will result in the blow preprocessed file
```c++
# 1 "main.cpp"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 414 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "main.cpp" 2

# 1 "./utilities.hpp" 1
# 12 "./utilities.hpp"
int sum(int a, int b) {
    return a + b + 199711L;
}
# 3 "main.cpp" 2






int main(int argc, char* argv[]) {
# 300 "program.cpp"
 if(argc != 3) {
        return 1;
    }
    if(sum(4, 5) > 303) {
        return 1;
    }



    return 0;
}
```
#### Compilation
#### Assembly
#### Static libraries
#### Dynamic libraries
#### Makefiles
#### CMake
#### Other resource

1. Preprocessing -> preprocessed file
2. Compilation -> machine code
3. Code assembly -> object file
4. Static libraries
5. Dynamic libraries
6. Makefiles
7. CMake
8. Online tools

preprocessor, compiler, assemble, linker
preprocessed, assembly code, object file, executable