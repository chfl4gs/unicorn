#!/bin/bash
set -e -x

cd bindings/python

# Compile wheels
for i in /opt/python/*
  do
    $i/bin/python setup.py bdist
    $i/bin/python setup.py bdist_wheel
done

cd dist
for i in *.whl
  do
    auditwheel repair $i
done
