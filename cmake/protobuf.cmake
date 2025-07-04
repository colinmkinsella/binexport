# Protocol Buffers
include(FetchContent)

FetchContent_Declare(protobuf
  GIT_REPOSITORY     https://github.com/protocolbuffers/protobuf.git
  GIT_TAG            main
  FIND_PACKAGE_ARGS
)

set(protobuf_ABSL_PROVIDER "package" CACHE STRING "" FORCE)
set(protobuf_BUILD_TESTS OFF CACHE BOOL "" FORCE)
set(protobuf_BUILD_SHARED_LIBS OFF CACHE BOOL "" FORCE)
set(protobuf_INSTALL OFF CACHE BOOL "" FORCE)
set(protobuf_WITH_ZLIB OFF CACHE BOOL "" FORCE)
if(MSVC)
  # Link MSVCRT statically for protoc
  set(protobuf_MSVC_STATIC_RUNTIME ON CACHE BOOL "" FORCE)
endif()
FetchContent_MakeAvailable(protobuf)
binexport_check_target(protobuf::libprotobuf)
binexport_check_target(protobuf::protoc)
target_include_directories(utf8_validity PUBLIC
  "${BINEXPORT_BINARY_DIR}/src_include"
  "${protobuf_SOURCE_DIR}"
)
target_include_directories(libprotobuf PUBLIC
  "${protobuf_SOURCE_DIR}/third_party/utf8_range"
)
set(Protobuf_INCLUDE_DIR "${protobuf_SOURCE_DIR}/src" CACHE INTERNAL "")
set(Protobuf_LIBRARIES protobuf::libprotobuf CACHE INTERNAL "")
find_package(Protobuf REQUIRED CONFIG) # Make protobuf_generate_cpp available

include_directories(${protobuf_SOURCE_DIR}/src)