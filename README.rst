An example project demonstrating linking a Python extension module with another
shared library::

    $ cd mylib && make
    $ python setup.py build_ext --rpath=`pwd`/mylib build install
    $ python -c "import foo; foo.hello('Guy')"

