@echo on

set GO111MODULE=on
set CGO_ENABLED=1

cd %SRC_DIR%
go build -buildmode=exe -ldflags "-s -w -X main.revision=conda-forge -X github.com/gohugoio/hugo/common/hugo.vendorInfo=conda-forge -extldflags '-static'" -tags extended,withdeploy -trimpath -v -o %LIBRARY_PREFIX%\bin\hugo.exe || exit 1
go-licenses save . --save_path .\library_licenses || exit 1
