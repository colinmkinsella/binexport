# Abseil
include(FetchContent)

FetchContent_Declare(absl
  GIT_REPOSITORY     https://github.com/abseil/abseil-cpp.git
  GIT_TAG            master
  FIND_PACKAGE_ARGS
)

set(ABSL_CXX_STANDARD ${CMAKE_CXX_STANDARD} CACHE STRING "" FORCE)
set(ABSL_PROPAGATE_CXX_STD ON CACHE BOOL "" FORCE)
set(ABSL_USE_EXTERNAL_GOOGLETEST OFF CACHE BOOL "" FORCE)
set(ABSL_FIND_GOOGLETEST OFF CACHE BOOL "" FORCE)
if(MSVC)
  # Link MSVCRT statically for abseil
  set(ABSL_MSVC_STATIC_RUNTIME ON CACHE BOOL "" FORCE)
endif()
FetchContent_MakeAvailable(absl)
binexport_check_target(absl::core_headers)

include_directories(${absl_SOURCE_DIR})