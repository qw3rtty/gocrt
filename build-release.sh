#!/bin/bash

VERSION="${1}" # Second CLI parameter
BINARY="gocrt"

if [[ -z "${VERSION}" ]]; then
    echo "Usage: ${0} <version>"
    exit 1
fi


for ARCH in "amd64" "386"; do
    for OS in "darwin" "linux" "windows" "freebsd"; do

        if [[ "${OS}" == "darwin" && "${ARCH}" == "386" ]]; then
            continue
        fi

        BINFILE="${BINARY}"

        if [[ "${OS}" == "windows" ]]; then
            BINFILE="${BINFILE}.exe"
        fi

        GOOS=${OS} GOARCH=${ARCH} go build -o ${BINFILE}

        if [[ "${OS}" == "windows" ]]; then
            ARCHIVE="${BINARY}-${OS}-${ARCH}-${VERSION}.zip"
            zip ${ARCHIVE} ${BINFILE}
            rm ${BINFILE}
        else
            ARCHIVE="${BINARY}-${OS}-${ARCH}-${VERSION}.tgz"
            tar --create --gzip --file=${ARCHIVE} ${BINFILE}
        fi

    done
done
