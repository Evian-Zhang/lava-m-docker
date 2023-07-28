#!/usr/bin/env bash
set -eu

PROJECT_DIR="$( cd "$( dirname "$0" )" && pwd )"
MY_USER=${MY_USERNAME:-"evian"}

apt-get update
apt-get install -y \
    automake \
    autoconf \
    build-essential \
    clang \
    curl \
    gperf \
    libacl1-dev \
    libcap-dev \
    libgmp-dev \
    libselinux-dev \
    tar \
    texinfo
cp /usr/bin/aclocal /usr/bin/aclocal-1.15
cp /usr/bin/automake /usr/bin/automake-1.15

# Download LAVA-M dataset
curl http://panda.moyix.net/~moyix/lava_corpus.tar.xz -o lava_corpus.tar.xz
# Decompress into ./lava_corpus
tar -xvf lava_corpus.tar.xz

LAVA_M_DIR="${PROJECT_DIR}/lava_corpus/LAVA-M"

# Modify the coreutils dir for mordern architecture
function prepare_coreutils_dir {
    pushd coreutils-8.24-lava-safe
    # See http://t.csdn.cn/rCg2J
    sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' lib/*.c
    echo "#define _IO_IN_BACKUP 0x100" >> lib/stdio-impl.h
    mv lib/mountlist.c lib/mountlist.c.old
    echo "#include <sys/sysmacros.h>" > lib/mountlist.c
    cat lib/mountlist.c.old >> lib/mountlist.c
    rm lib/mountlist.c.old

    chmod +x configure
    chmod +x build-aux/git-version-gen
    popd
    chmod +x validate.sh
}

pushd "${LAVA_M_DIR}/base64"
    prepare_coreutils_dir
popd

pushd "${LAVA_M_DIR}/md5sum"
    prepare_coreutils_dir
popd

pushd "${LAVA_M_DIR}/uniq"
    prepare_coreutils_dir
popd

pushd "${LAVA_M_DIR}/who"
    prepare_coreutils_dir
popd

# Create user since the build script cannot be runned as root
useradd "$MY_USER"
mkdir "/home/$MY_USER"
cp -r "${PROJECT_DIR}/lava_corpus" "/home/$MY_USER"

USER_LAVA_M_DIR="/home/$MY_USER/lava_corpus/LAVA-M"

chown -R "$MY_USER:$MY_USER" "$USER_LAVA_M_DIR"

# Building dataset
pushd "$USER_LAVA_M_DIR/base64"
su -c "./validate.sh" "$MY_USER"
popd

pushd "$USER_LAVA_M_DIR/md5sum"
su -c "./validate.sh" "$MY_USER"
popd

pushd "$USER_LAVA_M_DIR/uniq"
su -c "./validate.sh" "$MY_USER"
popd

pushd "$USER_LAVA_M_DIR/who"
su -c "./validate.sh" "$MY_USER"
popd
