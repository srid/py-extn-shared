CFLAGS := -arch i386 -arch ppc -isysroot /Developer/SDKs/MacOSX10.4u.sdk

all: build_and_install

build_and_install:
	CC=/usr/bin/gcc-4.0 MACOSX_DEPLOYMENT_TARGET=10.4 \
        python setup.py build_ext --rpath=`pwd`/mylib build install

fixlibpath:
	install_name_tool -change @rpath/lib/libmylib.dylib `pwd`/mylib/libmylib.dylib ${F}

test:
	python -c "import foo; foo.hello('Guy')"

clean:
	rm -rf build/
