#!/bin/bash -eu

apply_patch() {
	patch -Np1 -i $1
}

# Build LuaJIT
pushd luajit
make amalg -j4
popd

# Build Luanti
pushd luanti

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
objcopy --only-keep-debug ../bin/luantiserver luantiserver.debug
objcopy --strip-debug --add-gnu-debuglink=luantiserver.debug ../bin/luantiserver luantiserver

# Package it up
mkdir -p luanti/bin
cp luantiserver luanti/bin/
# temporary symlink
ln -sf luantiserver luanti/bin/minetestserver
cp -r ../builtin luanti/
cp ../minetest.conf.example luanti/
tar czf luantiserver.tar.gz luanti
