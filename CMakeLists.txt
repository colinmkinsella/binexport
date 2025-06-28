cmake_minimum_required(VERSION 3.20)

cmake_policy(VERSION 3.20..4.0)

# Getting the version numbers from local files.
# VERSION_BINARYNINJA_LIB.txt and VERSION_BINEXPORT_LIB.txt are generated from
# the GitHub workflow, and should be manually updated on local builds if you care
# about the generated version numbers and file names built.
# VERSION_PLUGIN.txt is a manually updated file for this specific plugin.
file(READ VERSION_PLUGIN.txt BINEXPORT_PLUGIN_VERSION_NUMBER)
file(READ VERSION_BINARYNINJA_LIB.txt BINARYNINJA_API_VERSION)

project(binexport-binaryninja VERSION ${BINEXPORT_PLUGIN_VERSION_NUMBER} LANGUAGES CXX C)

set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH})

include(util)
include(compile_options)

find_path(
    BINEXPORT_PATH
    NAMES src/binexport.h
    PATHS ./third-party/binexport
    REQUIRED
)
add_subdirectory(${BINEXPORT_PATH} binexport)

message(STATUS ${BINARYEXPORT_VERSION_COMMIT_DATE})

file(GLOB SOURCES
  src/*.cpp
  src/*.cc
  src/*.c
  src/*.h)

set(HEADLESS TRUE)
find_path(
    BN_API_PATH
    NAMES binaryninjaapi.h
    PATHS ./third-party/binaryninja-api binaryninjaapi $ENV{BN_API_PATH}
    REQUIRED
)
add_subdirectory(${BN_API_PATH} binaryninja-api)

message(STATUS "BinExport Plugin Version: ${BINEXPORT_PLUGIN_VERSION_NUMBER}")
message(STATUS "BinExport Lib Version: ${BINEXPORT_VERSION_COMMIT_DATE}")
message(STATUS "BinaryNinja Lib Version: ${BINARYNINJA_API_VERSION}")

set(bn_plugin_name BinExport${BINEXPORT_VERSION_COMMIT_DATE}_BinaryNinja-${BINARYNINJA_API_VERSION}_Plugin-${BINEXPORT_PLUGIN_VERSION_NUMBER})
add_library(${bn_plugin_name} SHARED ${SOURCES})

target_include_directories(${bn_plugin_name} PUBLIC
  ${CMAKE_BINARY_DIR}/src_include
  ${BN_API_PATH}
)

target_link_libraries(${bn_plugin_name} PRIVATE
  binaryninjaapi
  binexport_core
)