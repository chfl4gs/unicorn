#!/bin/bash
set -e -x

cd bindings/python

# Compile wheels
if [ -f dist/unicorn-*.tar.gz ]; then
   /opt/python/cp36-cp36m/bin/python setup.py sdist
fi
if [ -f /opt/python/cp36-cp36m/bin/python ];then
  /opt/python/cp36-cp36m/bin/python setup.py bdist_wheel
else
  python setup.py bdist_wheel
fi
cd /work && make clean
