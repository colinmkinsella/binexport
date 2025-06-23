cmake_minimum_required(VERSION 3.20)

cmake_policy(VERSION 3.20..4.0)

project(binexport-binaryninja LANGUAGES CXX C)

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

set(bn_plugin_name BinExport${BINEXPORT_VERSION}-BinaryNinja)
add_library(${bn_plugin_name} SHARED ${SOURCES})

target_include_directories(${bn_plugin_name} PUBLIC
  ${CMAKE_BINARY_DIR}/src_include
  ${BN_API_PATH}
)

target_link_libraries(${bn_plugin_name} PRIVATE
  binaryninjaapi
  binexport_core
)