# From Source to Executable

#### Preprocessing
```mermaid
gantt

section Compiler
Preprocessing :crit, pre, 2022-03-21, 10m
Compilation :active, comp, after pre, 10m
Assembly :active, assm, after comp, 10m

section Linker
Linking :active, link, after assm, 10m
```

The result of preprocessing is a single file which is then passed to the actual compiler.
To get the proprocessed output of the entry file we have to do the following
```bash
$ g++ -E main.cpp
```

<table>
<tr>
<th>User Code</th>
<th>Preprocessed</th>
</tr>
<tr>
<td>

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
    return __TIME__;
}
```

</td>
<td>

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



    return "14:08:18";
}
```

</td>
</tr>
</table>

#### Compilation
```mermaid
gantt

section Compiler
Preprocessing :active, pre, 2022-03-21, 10m
Compilation :crit, comp, after pre, 10m
Assembly :active, assm, after comp, 10m

section Linker
Linking :active, link, after assm, 10m
```

To get the compiler output (assembly language) output from the preprocessed file we need to issue the below command
```zsh
$ g++ -S main.cpp
```

Below table examples are obtained using the optimization `-O3` when compiling so that the output is reduced significantly.
<table>
<tr>
<th>User Code</th>
<th>Compiled arm64e</th>
<th>Compiled x86_64</th>
</tr>
<tr>
<td>

```c++
template<typename T>
T sum(T a, T b) {
    return a + b;
};             

int main() {
    int iRes = sum<int>(1, 2);
    int dRes = sum<double>(1.0, 2.0);
    return iRes + dRes;
}
```

</td>
<td>

```c++
        .section        __TEXT,__text,regular,pure_instructions
        .build_version macos, 12, 0     sdk_version 12, 3
        .globl  _main                           ; -- Begin function main
        .p2align        2
_main:                                  ; @main
        .cfi_startproc
; %bb.0:
        mov     w0, #6
        ret
        .cfi_endproc
                                        ; -- End function
.subsections_via_symbols
```

</td>
<td>

```c++
        .section        __TEXT,__text,regular,pure_instructions
        .build_version macos, 12, 0     sdk_version 12, 3
        .globl  _main                           ## -- Begin function main
        .p2align        4, 0x90
_main:                                  ## @main
        .cfi_startproc
## %bb.0:
        pushq   %rbp
        .cfi_def_cfa_offset 16
        .cfi_offset %rbp, -16
        movq    %rsp, %rbp
        .cfi_def_cfa_register %rbp
        movl    $6, %eax
        popq    %rbp
        retq
        .cfi_endproc
                                        ## -- End function
.subsections_via_symbols
```

</td>
</tr>
</table>

#### Assembly
```mermaid
gantt

section Compiler
Preprocessing :active, pre, 2022-03-21, 10m
Compilation :active, comp, after pre, 10m
Assembly :crit, assm, after comp, 10m

section Linker
Linking :active, link, after assm, 10m
```

The compiled code (machine code) is still text based however the computer works best with binary data so that is why we must put the output through an assembler and generate an `object file`.
The instructions to do this are below
```bash
$ g++ -c main.cpp
```

From this point on the output files are no longer readable and for analyzing them we will be using a series of tools such as `nm` and `objdump`.

<table>
<tr>
<th>User Code</th>
<th>Object file (shown using nm)</th>
</tr>
<tr>
<td>

```c++
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
```

</td>
<td>

```c++
                 U _VAL
0000000000000000 T __Z7definedv
                 U __Z9prototypev
0000000000000084 D _globalDefinedVar
00000000000000c8 S _globalUndefinedVar
0000000000000008 T _main
0000000000000000 t ltmp0
0000000000000084 d ltmp1
00000000000000c8 s ltmp2
0000000000000088 s ltmp3
```

</td>
</tr>
</table>

#### Linking
```mermaid
gantt

section Compiler
Preprocessing :active, pre, 2022-03-21, 10m
Compilation :active, comp, after pre, 10m
Assembly :active, assm, after comp, 10m

section Linker
Linking :crit, link, after assm, 10m
```

This is something to have in mind. All the processes before have worked on a single translation unit while the linker, due to the above shown undefined symbols, needs to take in multiple input files as to solve the undefined symbols by looking at things such as other object files, static libraries and dynamic libraries.

As such trying to link the previous file in the Assembly example will throw explicit linker errors like below:
```bash
Undefined symbols for architecture arm64:
  "_VAL", referenced from:
      _main in main.o
  "__Z9prototypev", referenced from:
      _main in main.o
ld: symbol(s) not found for architecture arm64
```
We can see the errors are exactly related to the two `undefined` symbols in the object file for which now the linker cannot move forward until it gets informations about them.

For ilustrating linking we will start from the below project. A simple application which uses a function from a different C++ source file exposed via a header file.

```c++
// utils.hpp
int sum(int, int);
```

```c++
// utils.cpp
#include "utils.hpp"

int sum(int a, int b) {
    return a + b;
}
```

```c++
// main.cpp
#include "utils.hpp"

int main() {
    return sum(4, 5);
}
```

We can generate object files from both translation units just fine but we won't be able to provide any single object file independently to the linker to generate an executable for the reasons below:

```bash
$ ld utils.o
Undefined symbols for architecture arm64:
  "_main", referenced from:
     implicit entry/start for main executable
ld: symbol(s) not found for architecture arm64
$ ld main.o
Undefined symbols for architecture arm64:
  "__Z3sumii", referenced from:
      _main in main.o
ld: symbol(s) not found for architecture arm64
```


#### Static libraries
A static library is just a collection of object files archived for easier integration and storage or modularization.
For this section we will be using the below files

```c++
// library.hpp
class Calculator
{
    bool working;
    unsigned int currentResult;
    public:
        Calculator();
        void turnOn();
        void add(unsigned short);
        int getResult();
};
```

```c++
// library.cpp
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
```

```c++
// main.cpp
#include "library.hpp"

int main()
{
    Calculator c;
    c.turnOn();
    c.add(5);
    c.add(4);
    return c.getResult();
}
```

To create the library and have it linked we will use the following commands
```bash
$ ls
library.cpp     library.hpp     main.cpp
$ g++ -c -O3 library.cpp
$ ls
library.cpp     library.hpp     library.o     main.cpp
$ g++ -c -O3 main.cpp
$ ls
library.cpp     library.hpp     library.o       main.cpp        main.o
$ ar cvr libcalc.a library.o
a - library.o
$ ls
libcalc.a       library.cpp     library.hpp     library.o       main.cpp        main.o
$ g++ main.o -I. -L. -lcalc
$ ./a.out
$ echo $?
9
```

#### Dynamic libraries
We can start of by using the exact same code from the static library chapter.
Only that this time we will create a shared library instead of a static one. Here are the commands;
```bash
$ g++ -c -O3 library.cpp
$ g++ -c -O3 main.cpp
$ g++ -shared -o libcalc.so library.o
$ g++ main.o -I. -L. -lcalc
$2 ./a.out
9
```

The main different between this process and the static one asside from the creating of the library is that if we do changes to the library we do not need to recreate the executable, we only need to recreate the dynamic library.

<table>
<tr>
<th>Binary built using static library</th>
<th>Binary build using dynamic library</th>
</tr>
<tr>
<td>

```c++
0000000100003f80 T __ZN10Calculator3addEt
0000000100003f74 T __ZN10Calculator6turnOnEv
0000000100003f98 T __ZN10Calculator9getResultEv
0000000100003f68 T __ZN10CalculatorC1Ev
0000000100003f5c T __ZN10CalculatorC2Ev
0000000100000000 T __mh_execute_header
0000000100003f14 T _main
```

</td>
<td>

```c++
                 U __ZN10Calculator3addEt
                 U __ZN10Calculator6turnOnEv
                 U __ZN10Calculator9getResultEv
                 U __ZN10CalculatorC1Ev
0000000100000000 T __mh_execute_header
0000000100003f40 T _main
```

</td>
</tr>
</table>

#### Makefiles
Building large project with manual commands is time consuming and grouping them in a script is error prone so to make things automatic Makefile system was created.
Below is an example of such a `makefile`
```makefile
CC=g++

IDIR=.
CFLAGS=-I$(IDIR)

%.o: %.cpp
	$(CC) -c -o $@ $< $(CFLAGS)

clean:
	rm -rf ./*.o ./*.so ./*.a

lib_static: library.o
	ar crv libcalc.a library.o 

lib_dynamic: library.o
	$(CC) -shared -o libcalc.so library.o

all_static: lib_static main.o
	$(CC) main.o -I. -L. -lcalc -o bin_static

all_dynamic: lib_dynamic main.o
	$(CC) main.o -I. -L. -lcalc -o bin_dynamic
```

Here are some of the commands you can run on this file
```bash
$ make clean
rm -rf ./*.o ./*.so ./*.a ./a.out ./bin_*
$ make all_static
g++ -c -o library.o library.cpp -I.
ar crv libcalc.a library.o 
a - library.o
g++ -c -o main.o main.cpp -I.
g++ main.o -I. -L. -lcalc -o bin_static
$ make all_dynamic
g++ -shared -o libcalc.so library.o
g++ main.o -I. -L. -lcalc -o bin_dynamic
$ ./bin_static 
$ echo $?
19
$ ./bin_dynamic 
$ echo $?
19
```

#### CMake
Makefile is a build system created for UNIX based systems. So what happens when you want to create a C++ project and want to deploy it on all kinds of operting systems and arhitctures?
Whell the answer for this is a higher level abstraction build system which is able to generate the necessary project structure specific to your deploy system.

A `CMakeLists.txt` file doing the exact same thing as the Makefile created above can be seen below:
```cmake
cmake_minimum_required(VERSION 3.10)

project(LSEGPresentation)

add_library(CalculatorStatic STATIC library.cpp)
add_library(CalculatorDynamic SHARED library.cpp)

add_executable(bin_static main.cpp)
add_executable(bin_dynamic main.cpp)

target_link_libraries(bin_static CalculatorStatic)
target_link_libraries(bin_dynamic CalculatorDynamic)
```

#### Other resource
[Godbolt](https://godbolt.org/) - `A very nice tool to look at machine code`
[CMake Documentation](https://cmake.org/documentation/) - `Lots of IDE's support CMake as a project type so there is a lot of value in learning it and integrating it even in your simplest projects`
[Using LD, the GNU linker](https://ftp.gnu.org/old-gnu/Manuals/ld-2.9.1/html_mono/ld.html) - `A useful reference for in-depth understanding of the linker`
[Phases of translation](https://en.cppreference.com/w/cpp/language/translation_phases) - `Overview of all translation phases`