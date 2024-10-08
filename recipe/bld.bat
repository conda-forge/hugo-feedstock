@echo on

set GO111MODULE=on

cd %SRC_DIR%
go build -buildmode=exe -ldflags "-s -w -X main.revision=conda-forge -X github.com/gohugoio/hugo/common/hugo.vendorInfo=conda-forge" -tags extended -trimpath -v -o %LIBRARY_PREFIX%\bin\hugo.exe || exit 1
go-licenses save . --save_path .\library_licenses || exit 1
