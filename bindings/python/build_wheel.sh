#!/bin/bash
set -e -x

cd bindings/python

# Compile wheels
if [ ! -f dist/unicorn-*.tar.gz ]; then
   /opt/python/cp36-cp36m/bin/python setup.py sdist
fi
if [ -f /opt/python/cp36-cp36m/bin/python ];then
  /opt/python/cp36-cp36m/bin/python setup.py bdist_wheel
else
  python setup.py bdist_wheel
fi
cd dist
auditwheel repair *.whl

if [ ! -d /work/release ]; then
   mkdir /work/release
fi
mv -f wheelhouse/*.whl /work/release/
cd .. && rm -rf dist
cd /work && make clean
