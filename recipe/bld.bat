@echo on

:: Download and install Go via MSI installer
curl -LJO https://go.dev/dl/go1.23.3.windows-amd64.msi || exit 1
start "Install Go MSI" /wait msiexec.exe /i go1.23.3.windows-amd64.msi TARGETDIR=%PREFIX% /quiet || exit 1
go version || exit 1

:: Build Hugo
set GO111MODULE=on
set CGO_ENABLED=1

cd %SRC_DIR%
go build -buildmode=exe -ldflags "-s -w -X main.revision=conda-forge -X github.com/gohugoio/hugo/common/hugo.vendorInfo=conda-forge -extldflags '-static'" -tags extended,withdeploy -trimpath -v -o %LIBRARY_PREFIX%\bin\hugo.exe || exit 1
go-licenses save . --save_path .\library_licenses || exit 1
