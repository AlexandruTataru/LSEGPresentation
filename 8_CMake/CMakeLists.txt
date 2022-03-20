cmake_minimum_required(VERSION 3.10)

project(LSEGPresentation)

add_library(CalculatorStatic STATIC library.cpp)
add_library(CalculatorDynamic SHARED library.cpp)

add_executable(bin_static main.cpp)
add_executable(bin_dynamic main.cpp)

target_link_libraries(bin_static CalculatorStatic)
target_link_libraries(bin_dynamic CalculatorDynamic)