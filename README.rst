An example project demonstrating linking a Python extension module with another
shared library::

    $ (cd mylib && make -f make.unix clean all)
    $ make
    $ make test # should pass, because of using rpath in distutils

On MacOSX - assuming it will be used in ActivePython (i386, ppc)::

    $ (cd mylib && make -f make.osx clean all)
    $ make
    $ make test # this should fail
    $ make fixlibpath F=~/.virtualenvs/slenv/lib/python2.6/site-packages/foo.so 
    $ make test # should pass now

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

On OSX, rpath can be supported using the ``install_name`` feature (see this 
`blog post <http://blog.onesadcookie.com/2008/01/installname-magic.html>`__).
We do automatically this in the makefiles::

	$ otool -L build/lib.macosx-10.4-fat-2.6/foo.so 
	build/lib.macosx-10.4-fat-2.6/foo.so:
			@rpath/lib/libmylib.dylib (...)
	$ otool -L mylib/libmylib.dylib 
	mylib/libmylib.dylib:
			@rpath/lib/libmylib.dylib (...)
	$

OSX provides ``install_name_tool`` to modify this path::

    $ install_name_tool -change @rpath/lib/libmylib.dylib `pwd`/mylib/libmylib.dylib build/lib.macosx-10.4-fat-2.6/foo.so 

Enthough does this manually, I suppose (see object_code.py below)}

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

