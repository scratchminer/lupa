PYTHON?=python3
VERSION?=$(shell sed -ne "s|^VERSION\s*=\s*'\([^']*\)'.*|\1|p" setup.py)
WITH_CYTHON?=$(shell $(PYTHON)  -c 'import Cython.Build.Dependencies' >/dev/null 2>/dev/null && echo " --with-cython" || true)
PYTHON_BUILD_VERSION?=*

.PHONY: all local test clean realclean

all: local

local:
	${PYTHON} setup.py bdist_wheel $(WITH_CYTHON) --no-lua-jit --use-bundle

test: local
	PYTHONPATH=. $(PYTHON) -m unittest lupa.tests.test

clean:
	rm -fr build lupa/_lupa*.so lupa/lua*.pyx lupa/*.c
	@for dir in third-party/*/; do $(MAKE) -C $${dir} clean; done

realclean: clean
	rm -fr lupa/_lupa.c
