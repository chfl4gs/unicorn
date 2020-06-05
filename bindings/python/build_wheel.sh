#!/bin/bash
set -e -x

cd bindings/python

# Compile wheels
/opt/python/cp36-cp36m/bin/python setup.py bdist_wheel

cd dist
for i in *.whl
  do
    auditwheel repair $i
done
mv -f wheelhouse/*.whl .
cd /work && make clean
