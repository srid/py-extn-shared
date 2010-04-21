from distutils.core import setup, Extension

foomod = Extension('foo', 
                   sources=['foo.c'],
                   libraries=['mylib'],
                   library_dirs=['./mylib']
                  )

setup(name='foo', version='1.0',
      description='Simple extension',
      ext_modules=[foomod])

