#!/bin/bash
set -e -x

# Compile wheels
for PYBIN in /opt/python/*/bin; do
    ${PYBIN}/pip wheel . -w wheelhouse/
done

# Bundle external shared libraries into the wheels
for whl in wheelhouse/*.whl; do
    auditwheel repair $whl -w ./wheelhouse/
done

# Install packages and test
for PYBIN in /opt/python/*/bin/; do
    sudo ${PYBIN}/pip install unicorn --no-index -f ./wheelhouse
done
