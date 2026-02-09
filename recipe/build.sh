#!/bin/bash

set -ex

cd $SRC_DIR
go build -ldflags "-s -w -X main.revision=conda-forge -X github.com/gohugoio/hugo/common/hugo.vendorInfo=conda-forge" -tags extended,withdeploy -trimpath -v -o $PREFIX/bin/hugo
go-licenses save . --save_path ./library_licenses
chmod -R u+w $(go env GOPATH) && rm -r $(go env GOPATH)
