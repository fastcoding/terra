#!/bin/sh
# generator="-G Xcode"
if [ -z "$generator" ]; then 
   bld_type=Release
   build_dir=build
else
   bld_type=Debug
   build_dir=build-xcode
fi
llvm_dir=/opt/homebrew/opt/llvm
mkdir -p $build_dir
rm -rf build/*Cache.txt
if [ "$1" = "xcode" ]; then 
   gopt="-G Xcode"
fi
export PKG_CONFIG_PATH=/opt/lib/pkgconfig LLVM_DIR=$llvm_dir
if cmake $gopt -B$build_dir \
$generator \
-DTERRA_LUA=system \
-DCMAKE_BUILD_TYPE=$bld_type \
-DCMAKE_INSTALL_PREFIX=/opt \
-DCMAKE_PREFIX_PATH=/opt:$llvm_dir\
$@ . ; then 
  if [ -z "$generator" ]; then 
       cmake --build $build_dir --config Release --target install 
   fi
fi
