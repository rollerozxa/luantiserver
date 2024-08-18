#!/bin/bash -eu

apply_patch() {
	patch -Np1 -i $1
}

# Build LuaJIT
pushd luajit
make amalg -j4
popd

# Build Minetest
pushd minetest

apply_patch ../001-silence-dirty.patch
apply_patch ../002-expose-player-ver-info.patch

mkdir -p build; cd build
cmake .. \
	-DCMAKE_BUILD_TYPE=RelWithDebInfo \
	-DBUILD_CLIENT=0 \
	-DBUILD_SERVER=1 \
	-DRUN_IN_PLACE=1 \
	-DBUILD_UNITTESTS=0 \
	-DENABLE_SYSTEM_GMP=OFF \
	-DENABLE_SYSTEM_JSONCPP=OFF \
	-DLUA_INCLUDE_DIR=../../luajit/src/ \
	-DLUA_LIBRARY=../../luajit/src/libluajit.a \
	-G Ninja

ninja

# Strip server binary and create debug symbol file
objcopy --only-keep-debug ../bin/minetestserver minetestserver.debug
objcopy --strip-debug --add-gnu-debuglink=minetestserver.debug ../bin/minetestserver minetestserver

# Package it up
mkdir -p minetest/bin
cp minetestserver minetest/bin/
cp -r ../builtin minetest/
cp ../minetest.conf.example minetest/
tar czf minetestserver.tar.gz minetest
