#!/bin/bash

# Using this docker image arm64v8/debian:bullseye, for bild python for RPi4.

# Installing dependencies.
set -eux
apt-get update && apt-get -y --allow-change-held-packages upgrade
apt-get install -y --no-install-recommends \
    ca-certificates \
    wget \
    build-essential \
    checkinstall \
    libbluetooth-dev \
    uuid-dev \
    libffi-dev \
    libbz2-dev \
    liblzma-dev \
    libsqlite3-dev \
    libncurses5-dev \
    libgdbm-dev \
    zlib1g-dev \
    libreadline-dev \
    libssl-dev \
    tk-dev \
    libncursesw5-dev \
    libc6-dev \
    openssl \
    git
rm -rf /var/lib/apt/lists/*

# Downloading Python and compiling
GPG_KEY=A035C8C19219BA821ECEA86B64E628F8D684696D
PYTHON_VERSION=3.11.2

set -eux
wget -O python.tar.xz "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz"
wget -O python.tar.xz.asc "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz.asc"
GNUPGHOME="$(mktemp -d)"
#gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys "$GPG_KEY"
#gpg --batch --verify python.tar.xz.asc python.tar.xz
#command -v gpgconf > /dev/null && gpgconf --kill all || :
#rm -rf "$GNUPGHOME" python.tar.xz.asc; \
mkdir -p /usr/src/python
tar --extract --directory /usr/src/python --strip-components=1 --file python.tar.xz
rm python.tar.xz

mkdir -p /usr/local/python-${PYTHON_VERSION%%[a-z]*}

cd /usr/src/python
gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
./configure \
    --build="$gnuArch" \
    --enable-loadable-sqlite-extensions \
    --enable-optimizations \
    --enable-option-checking=fatal \
    --enable-shared \
    --with-lto \
    --with-system-expat \
    --without-ensurepip \
    --prefix=/usr/local/python-${PYTHON_VERSION%%[a-z]*}

nproc="$(nproc)"
make -j "$nproc" \
    "EXTRA_CFLAGS=${EXTRA_CFLAGS:-}" \
    "LDFLAGS=${LDFLAGS:-}" \
    "PROFILE_TASK=${PROFILE_TASK:-}"

# Installing
make install
mkdir /artifact

tar cJf /artifact/${PYTHON_VERSION%%[a-z]*} .tar.xz /usr/local/python-${PYTHON_VERSION%%[a-z]*}
