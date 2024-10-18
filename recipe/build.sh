#!/bin/bash

set -ex

export GO111MODULE=on
export CGO_ENABLED=1

if [ "$(uname -m)" = "ppc64le" ]; then
    export CFLAGS="${CFLAGS//-O3/-O2}"
    export CXXFLAGS="${CXXFLAGS//-O3/-O2}"
    # -fno-lto -flto -fno-tree-vectorize
    # export CGO_CFLAGS="-mcmodel=large"
    # export CGO_LDFLAGS="-mcmodel=large"
fi

env | sort

cd $SRC_DIR
go build -ldflags "-s -w -X main.revision=conda-forge -X github.com/gohugoio/hugo/common/hugo.vendorInfo=conda-forge" -tags extended -trimpath -v -x -o $PREFIX/bin/hugo
go-licenses save . --save_path ./library_licenses
chmod -R u+w $(go env GOPATH) && rm -r $(go env GOPATH)
