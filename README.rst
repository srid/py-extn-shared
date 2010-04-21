An example project demonstrating linking a Python extension module with another
shared library::

    $ cd mylib && make
    $ python setup.py build_ext --rpath=`pwd`/mylib build install
    $ python -c "import foo; foo.hello('Guy')"

RPATH
-----

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


