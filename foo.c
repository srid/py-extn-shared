#include <Python.h>

static PyObject *
foo_hello(PyObject *self, PyObject *args)
{
	const char *name;
	if (!PyArg_ParseTuple(args, "s", &name))
		return NULL;
	print_hello(name);
	return Py_BuildValue("i", 1);
}

static PyMethodDef FooMethods[] = {
	{"hello", foo_hello, METH_VARARGS,
	 "Say hello!"}
};

PyMODINIT_FUNC
initfoo(void)
{
	(void) Py_InitModule("foo", FooMethods);
}


