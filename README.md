# BinExport Plugin For Binary Ninja

[BinExport](https://github.com/google/binexport) is Copyright 2011-2025 Google LLC.

Disclaimer for BinExport: This is not an official Google product (experimental
or otherwise), it is just code that happens to be owned by Google.

## Introduction

BinExport is the exporter component of
[BinDiff](https://www.zynamics.com/software.html). This project builds the
BinaryNinja C++ Plugin only.

As the API for BinaryNinja changes frequently with new improvements, it can
break the plugin. BinExport is not always trivial to build. This project aims
to automate the builds so that the user of the plugin is not responsible for
continual attempting to build the plugin.

## Using the Plugin

There is only minimal integration into the Binary Ninja UI at this time.

1.  Open or create a new analysis database
2.  Select `Tools`|`Plugins`|`BinExport`. This will start the export process.

The `.BinExport` file is placed next to the analysis database, in the same
directory.

## How to Build

If you would like to build a copy on your local host here are some instructions
to get you started.

### Preparing the build environment

There are just a few dependencies to satisfy:

*   Boost 1.83.0 or higher (a partial copy ships in `boost_parts`)
*   [CMake](https://cmake.org/download/) 3.20 or higher
*   Suggested: [Ninja](https://ninja-build.org/) for speedy builds
*   GCC 9 or a recent version of Clang on Linux/macOS. On Windows, use the
    Visual Studio 2019 or higher compiler and the Windows SDK for Windows 10.
*   Git 1.8 or higher
*   Dependencies that will be downloaded:
    *   Abseil
    *   Protocol Buffers
*   Dependencies that are sub modules:
    *   Binary Ninja SDK
    *   BinExport (pulling the whole project, but just using the library)

### Building

```Bash
# Get the source
git clone  https://github.com/colinmkinsella/binexport-binaryninja
cd binexport-binaryninja
git submodule update --init --recursive

# Configure an out-of-source build setup
cmake -S . -G Ninja -B build -DCMAKE_BUILD_TYPE=Release  # (additional arguments go here if needed)

# Compile
cmake --build build -j8
```