#!/bin/bash
set -e -x

cd bindings/python

# Compile wheels
if [ -f dist/unicorn-*.tar.gz ]; then
   /opt/python/cp36-cp36m/bin/python setup.py sdist
fi
/opt/python/cp36-cp36m/bin/python setup.py bdist_wheel

cd dist
for i in *.whl
  do
    auditwheel repair $i
done
mv -f wheelhouse/*.whl .
cd /work && make clean
