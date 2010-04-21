
all: libmylib.so

libmylib.so: mylib.o
	gcc -shared mylib.o -o libmylib.so

mylib.o: mylib.c
	gcc -fPIC -c mylib.c

clean:
	rm -rf *.o *.so
