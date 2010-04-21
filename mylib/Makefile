
all: libmylib.so

libmylib.so: mylib.o
	gcc ${CFLAGS} -shared mylib.o -o libmylib.so

libmylib.dylib: mylib.o
	gcc ${CFLAGS} -shared mylib.o -o libmylib.dylib

mylib.o: mylib.c
	gcc ${CFLAGS} -fPIC -c mylib.c

clean:
	rm -rf *.o *.so *.dylib
