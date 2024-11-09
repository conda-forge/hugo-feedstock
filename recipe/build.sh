#!/bin/bash

set -ex

GO_VERSION="1.23.3"

# Determine OS and architecture for Go download
# Set empty GOROOT for Linux builds based on
# https://stackoverflow.com/a/57892698
case "$target_platform" in
    linux-64)
        GO_TARBALL="go${GO_VERSION}.linux-amd64.tar.gz"
        export GOROOT=""
        ;;
    linux-aarch64)
        GO_TARBALL="go${GO_VERSION}.linux-arm64.tar.gz"
        export GOROOT=""
        ;;
    linux-ppc64le)
        GO_TARBALL="go${GO_VERSION}.linux-ppc64le.tar.gz"
        export GOROOT=""
        ;;
    osx-64)
        GO_TARBALL="go${GO_VERSION}.darwin-amd64.tar.gz"
        ;;
    osx-arm64)
        GO_TARBALL="go${GO_VERSION}.darwin-arm64.tar.gz"
        ;;
    *)
        echo "Unsupported platform: $target_platform"
        exit 1
        ;;
esac

# Download and install external Go
curl -LJO "https://go.dev/dl/${GO_TARBALL}"
mkdir -p ${PREFIX}/go_installed
tar -C ${PREFIX}/go_installed -xzf ${GO_TARBALL}
export PATH=${PREFIX}/go_installed/go/bin:${PATH}
go version


# Build Hugo
export GO111MODULE=on
export CGO_ENABLED=1

cd $SRC_DIR
go build -ldflags "-s -w -X main.revision=conda-forge -X github.com/gohugoio/hugo/common/hugo.vendorInfo=conda-forge" -tags extended,withdeploy -trimpath -v -o $PREFIX/bin/hugo
go-licenses save . --save_path ./library_licenses
chmod -R u+w $(go env GOPATH) && rm -r $(go env GOPATH)

# Clean up Go installation files
rm -f "${GO_TARBALL}"