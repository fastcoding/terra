#!/bin/sh
if [ -f build ]; then 
  build_dir=_b
else
  build_dir=build
fi
llvm_dir=/opt/homebrew/opt/llvm
mkdir -p $build_dir
rm -rf build/*Cache.txt
if [ "$1" = "xcode" ]; then 
   gopt="-G Xcode"
fi
export PKG_CONFIG_PATH=/opt/lib/pkgconfig LLVM_DIR=$llvm_dir
if cmake $gopt -B$build_dir \
-DTERRA_LUA=system \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_INSTALL_PREFIX=/opt \
-DCMAKE_PREFIX_PATH=/opt:$llvm_dir\
$@ . ; then 
   if [ -z "$gopt" ]; then 
cmake --build $build_dir --config Release --target install 
   fi
fi
