#!/bin/bash
set -e -x

cd /work/bindings/python

function repair_wheel {
    wheel="$1"
    if ! auditwheel show "$wheel"; then
        echo "Skipping non-platform wheel $wheel"
    else
        auditwheel repair "$wheel" --plat "$PLAT" -w /work/bindings/python/dist/
    fi
}


# Compile wheels
for PYBIN in /opt/python/*/bin; do
    "${PYBIN}/python" setup.py bdist_wheel -b wheelhouse
done

# Bundle external shared libraries into the wheels
for whl in wheelhouse/*.whl; do
    repair_wheel "$whl"
done

# Install packages and test
for PYBIN in /opt/python/*/bin/; do
    "${PYBIN}/pip" install unicorn --no-index -f /work/bindings/python/dist
    (cd "$HOME"; "${PYBIN}/nosetests" unicorn)
done
