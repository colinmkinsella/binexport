# Copyright 2011-2025 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

cmake_minimum_required(VERSION 3.20)

cmake_policy(VERSION 3.20..4.0)

# Getting the BinExport Version Number from a local file that is generated
# during the GitHub workflow. This can be manually updated. It is in the format
# 12-20250619 where 12 is the major version and the date is the latest commit
# that is being built.
file(READ ../../VERSION_BINEXPORT_LIB.txt binexport_lib_version)
set(BINEXPORT_VERSION_COMMIT_DATE ${binexport_lib_version} CACHE INTERNAL "" FORCE)
string(REGEX MATCH "[0-9]+" extracted_number "${BINEXPORT_VERSION_COMMIT_DATE}")
set(BINEXPORT_MAJOR_VERSION ${extracted_number} CACHE INTERNAL "" FORCE)

project(binexport VERSION ${BINEXPORT_MAJOR_VERSION})  # Only major version is used

include(abseil)
include(protobuf)

# BinExport settings
set(BINEXPORT_BINARY_DIR ${PROJECT_BINARY_DIR} CACHE INTERNAL "" FORCE)
set(BINEXPORT_SOURCE_DIR ${PROJECT_SOURCE_DIR} CACHE INTERNAL "" FORCE)

set(Boost_INCLUDE_DIR "${BINEXPORT_SOURCE_DIR}/src/boost_parts")

# Make Google-style includes work
create_directory_symlink(
  "${BINEXPORT_SOURCE_DIR}/src"
  "${CMAKE_BINARY_DIR}/src_include/third_party/zynamics/binexport"
)
create_directory_symlink(
  "${absl_SOURCE_DIR}/absl"
  "${CMAKE_BINARY_DIR}/src_include/third_party/absl"
)

configure_file(src/version.cc.in
  "${CMAKE_BINARY_DIR}/src_include/third_party/zynamics/binexport/version.cc"
  ESCAPE_QUOTES @ONLY
)

# Interface library with include paths used by BinExport
add_library(binexport_base INTERFACE)
target_include_directories(binexport_base INTERFACE
  "${PROJECT_SOURCE_DIR}/src"
  "${CMAKE_BINARY_DIR}/src_include"
  "${Boost_INCLUDE_DIR}"
  "${Protobuf_INCLUDE_DIR}"
)
target_link_libraries(binexport_base INTERFACE
  ${Protobuf_LIBRARIES}  # Same as protobuf::libprotobuf
)

# Utility library code shared with BinDiff
add_library(binexport_shared STATIC
  "${binexport2_proto_h}"
  "${binexport2_proto}"
  src/architectures.h
  src/binexport.cc
  src/binexport.h
  src/util/filesystem.cc
  src/util/filesystem.h
  src/util/format.cc
  src/util/format.h
  src/util/hash.cc
  src/util/hash.h
  src/util/idb_export.cc
  src/util/idb_export.h
  src/util/logging.cc
  src/util/logging.h
  src/util/nested_iterator.h
  src/util/process.cc
  src/util/process.h
  src/util/range.h
  src/util/status_macros.h
  src/util/timer.h
  src/util/types.h
)
target_link_libraries(binexport_shared PUBLIC
  absl::check
  absl::flat_hash_map
  absl::flat_hash_set
  absl::log
  absl::log_initialize
  absl::optional
  absl::status
  absl::statusor
  absl::str_format
  absl::strings
  absl::time
  absl::variant
  binexport_base
)
if(WIN32)
  target_link_libraries(binexport_shared PUBLIC
    shlwapi.lib
  )
endif()

# Non-plugin code shared with BinDiff/the Binary Ninja plugin
add_library(binexport_core
  src/address_references.cc
  src/address_references.h
  src/base_types.cc
  src/base_types.h
  src/basic_block.cc
  src/basic_block.h
  src/binexport2_writer.cc
  src/binexport2_writer.h
  src/call_graph.cc
  src/call_graph.h
  src/comment.cc
  src/comment.h
  src/dump_writer.cc
  src/dump_writer.h
  src/edge.cc
  src/edge.h
  src/entry_point.cc
  src/entry_point.h
  src/expression.cc
  src/expression.h
  src/flow_analysis.cc
  src/flow_analysis.h
  src/flow_graph.cc
  src/flow_graph.h
  src/function.cc
  src/function.h
  src/instruction.cc
  src/instruction.h
  src/library_manager.cc
  src/library_manager.h
  src/operand.cc
  src/operand.h
  src/statistics_writer.cc
  src/statistics_writer.h
  src/version.h
  ${CMAKE_BINARY_DIR}/src_include/third_party/zynamics/binexport/version.cc
  src/virtual_memory.cc
  src/virtual_memory.h
  src/x86_nop.cc
  src/x86_nop.h
)
target_link_libraries(binexport_core PUBLIC
  absl::btree
  absl::check
  absl::flat_hash_map
  absl::flat_hash_set
  absl::hash
  absl::node_hash_map
  absl::node_hash_set
  absl::log
  absl::optional
  absl::strings
  absl::time
  binexport_shared
)

# BinExport format version 2 proto library
protobuf_generate(
  TARGET binexport_shared
  IMPORT_DIRS ${PROJECT_SOURCE_DIR}/src/
  LANGUAGE cpp
  PROTOS ${PROJECT_SOURCE_DIR}/src/binexport2.proto
  PROTOC_OUT_DIR ${CMAKE_BINARY_DIR}/src_include/third_party/zynamics/binexport
)