#!/bin/bash

set -ex

cd $SRC_DIR
go build -ldflags "-s -w -X main.revision=conda-forge -X github.com/gohugoio/hugo/common/hugo.vendorInfo=conda-forge" -tags withdeploy -trimpath -v -o $PREFIX/bin/hugo
# Chroma's COPYING contains MIT plus OFL text, which go-licenses reports as unknown.
go-licenses save . --save_path ./library_licenses --ignore github.com/alecthomas/chroma/v2
mkdir -p ./library_licenses/github.com/alecthomas/chroma/v2
cp "$(go list -m -f '{{ .Dir }}' github.com/alecthomas/chroma/v2)/COPYING" ./library_licenses/github.com/alecthomas/chroma/v2/COPYING
chmod -R u+w $(go env GOPATH) && rm -r $(go env GOPATH)
