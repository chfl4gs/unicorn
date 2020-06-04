#!/bin/bash
set -e -x

# Compile wheels
for i in /opt/python/*
  do
    $i/bin/python setup.py bdist
    strip build/*/*.so
    $i/bin/python setup.py bdist_wheel
done

cd dist
for i in *.whl
  do
    auditwheel repair $i
done
