#!/bin/bash
set -e -x

run_docker() {
  cd `dirname $0`
  docker pull $1
  docker run --rm -ti --name unicorn \
    -v `pwd`/../:/unicorn -w /unicorn/bindings/python \
    -td $1 /bin/bash
  docker exec unicorn bash -c "./build_unix_wheel.sh build $2"
  docker stop unicorn
}

build() {
  rm -rf ../build
  rm -rf ../unicorn/lib
  rm -rf ../unicorn/include
  /opt/python/cp36-cp36m/bin/python setup.py bdist_wheel
  cd dist
  auditwheel repair *.whl
  mv -f wheelhouse/*.whl .
}

if [ "$1" = "build" ]; then
  build $2
elif [ "$#" -eq 1 ]; then
  run_docker quay.io/pypa/manylinux1_${1}  ${1}
else
  run_docker quay.io/pypa/manylinux1_i686 i686
  run_docker quay.io/pypa/manylinux1_x86_64 x86_64
fI
