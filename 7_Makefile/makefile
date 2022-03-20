CC=g++

IDIR=.
CFLAGS=-I$(IDIR)

%.o: %.cpp
	$(CC) -c -o $@ $< $(CFLAGS)

clean:
	rm -rf ./*.o ./*.so ./*.a ./a.out ./bin_*

lib_static: library.o
	ar crv libcalc.a library.o 

lib_dynamic: library.o
	$(CC) -shared -o libcalc.so library.o

all_static: lib_static main.o
	$(CC) main.o -I. -L. -lcalc -o bin_static

all_dynamic: lib_dynamic main.o
	$(CC) main.o -I. -L. -lcalc -o bin_dynamic