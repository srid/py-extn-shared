An example project demonstrating linking a Python extension module with another
shared library::

    $ cd mylib && make
    $ python setup.py build_ext --rpath=`pwd`/mylib build install
    $ python -c "import foo; foo.hello('Guy')"

On MacOSX - assuming it will be used in ActivePython (i386, ppc)::

    $ cd mylib && CC=/usr/bin/gcc-4.0 MACOSX_DEPLOYMENT_TARGET=10.4 \
    CFLAGS='-arch ppc -arch i386 -isysroot /Developer/SDKs/MacOSX10.4u.sdk' \
    make clean all
    $ # run the setup.py cmd with the same env vars as above
    $ # run the ``python -c`` command from within ./mylib/ directory 
    # otherwise, I don't know how to make rpath work on Mac :/ 

RPATH
-----

TODO: make RPATH work on OSX

Using ``--rpath`` ('runtime search path'), hardcodes the library search path in
the built Python module (foo.so)::

    $ ldd /home/sridharr/.virtualenvs/slenv/lib/python2.6/site-packages/foo.so 
    libmylib.so => /home/sridharr/code/py-extn-shared/mylib/libmylib.so (..)
    [...]

    $ strings build/lib.linux-x86_64-2.6/foo.so  | grep sridharr
    /home/sridharr/code/py-extn-shared/mylib/
    $

So relocation can be supported by rewriting the paths in the .so files to
``$sys.prefix/lib`` (ensuring that the original path is long enough).

PJE's solution
--------------

... is to use ``'.'`` in RPATH and change directories in a stub loader:
http://mail.python.org/pipermail/distutils-sig/2006-January/005833.html

Enthought
---------

What does EPD/enstaller use? Inspecting one of their .egg file showed the 
file "EGG-INFO/inst/ch_macho.py" which seems to be similar to this one:
https://svn.enthought.com/enthought/browser/Enstaller/trunk/egginst/object_code.py

They put a PLACEHOLDER string into the dylib/so file (note that EPD has minimum
OSX 10.5 requirement). And then replace that PLACEHOLDER with the actual
library location post-installation.

