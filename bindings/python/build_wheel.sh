#!/bin/bash
set -e -x

cd bindings/python

if [ ! -d /work/release ]; then
   mkdir /work/release
fi
# Compile wheels
if [ ! -f /work/release/unicorn-*.tar.gz ]; then
   python setup.py sdist
fi
if [ -f /opt/python/cp36-cp36m/bin/python ];then
  /opt/python/cp36-cp36m/bin/python setup.py bdist_wheel
else
  python setup.py bdist_wheel
fi
cd dist
auditwheel repair *.whl
mv -f wheelhouse/*.whl /work/release/

cd .. && rm -rf dist
cd /work && make clean
