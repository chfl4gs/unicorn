#!/bin/bash
set -e -x

run_docker() {
  cd `dirname $0`
  docker pull $1
  docker run --rm -ti --name unicorn \
    -v `pwd`/../../:/unicorn -w /unicorn/bindings/python \
    -td $1 /bin/bash
  docker exec unicorn bash -c "./build_unix_wheel.sh build $2"
  docker stop unicorn
}

build() {
  ARCH=$1
  cd /unicorn && make clean
  cd bindings/python
  /opt/python/cp36-cp36m/bin/python setup.py bdist_wheel
  cd dist
  for i in *${ARCH}.whl
  do
    auditwheel repair $i
  done
  mv -f wheelhouse/*${ARCH}.whl .
}

if [ "$1" = "build" ]; then
  build $2
elif [ "$#" -eq 1 ]; then
  run_docker quay.io/pypa/manylinux1_${1}  ${1}
else
  run_docker quay.io/pypa/manylinux1_i686 i686
  run_docker quay.io/pypa/manylinux1_x86_64 x86_64
  run_docker dockcross/windows-shared-x86 x86
  run_docker dockcross/windows-shared-x64 x64
fi
