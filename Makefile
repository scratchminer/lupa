PYTHON?=python
USE_BUNDLE?=true
VERSION?=$(shell sed -ne "s|^VERSION\s*=\s*'\([^']*\)'.*|\1|p" setup.py)
WITH_CYTHON?=$(shell $(PYTHON)  -c 'import Cython.Build.Dependencies' >/dev/null 2>/dev/null && echo " --with-cython" || true)
PYTHON_BUILD_VERSION?=*

MANYLINUX_IMAGES= \
	manylinux1_x86_64 \
	manylinux1_i686 \
	manylinux_2_24_x86_64 \
	manylinux_2_24_i686 \
	manylinux2014_aarch64 \
	manylinux_2_24_aarch64 \
	manylinux_2_28_aarch64 \
	manylinux_2_24_ppc64le \
	manylinux_2_24_s390x \
	musllinux_1_1_x86_64 \
	musllinux_1_1_aarch64

.PHONY: all local sdist test clean realclean

all:  local

local:
	${PYTHON} setup.py build_ext --inplace $(WITH_CYTHON)

sdist dist/lupa-$(VERSION).tar.gz:
	${PYTHON} setup.py sdist

test: local
	PYTHONPATH=. $(PYTHON) -m unittest lupa.tests.test

clean:
	rm -fr build lupa/_lupa*.so lupa/lua*.pyx lupa/*.c
	@for dir in third-party/*/; do $(MAKE) -C $${dir} clean; done

realclean: clean
	rm -fr lupa/_lupa.c

wheel:
	$(PYTHON) setup.py bdist_wheel $(WITH_CYTHON)
