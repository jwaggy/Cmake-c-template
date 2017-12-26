cmake_minimum_required(VERSION 3.7.2)

project(example)

set (CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/CMake")

include(cotire)

if(EXISTS "${CMAKE_SOURCE_DIR}/.git")
  execute_process(
    COMMAND git rev-parse --abbrev-ref HEAD
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    OUTPUT_VARIABLE GIT_COMMIT_BRANCH
    OUTPUT_STRIP_TRAILING_WHITESPACE
  )

  execute_process(
    COMMAND git rev-parse -q HEAD
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    OUTPUT_VARIABLE GIT_COMMIT_HASH
    OUTPUT_STRIP_TRAILING_WHITESPACE
  )

  execute_process(
    COMMAND git log -1 --format=%an
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    OUTPUT_VARIABLE GIT_COMMIT_AUTHOR
    OUTPUT_STRIP_TRAILING_WHITESPACE
  )

  execute_process(
  COMMAND git log -1 --format=%ad --date=local
  WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
  OUTPUT_VARIABLE GIT_COMMIT_DATE
  ERROR_QUIET OUTPUT_STRIP_TRAILING_WHITESPACE
  )

  execute_process(
  COMMAND git log -1 --format=%s
  WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
  OUTPUT_VARIABLE GIT_COMMIT_MESSAGE
  ERROR_QUIET OUTPUT_STRIP_TRAILING_WHITESPACE
  )

  execute_process(
  COMMAND git rev-list HEAD COMMAND wc -l
  WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
  OUTPUT_VARIABLE GIT_COMMIT_NUMBER
  ERROR_QUIET OUTPUT_STRIP_TRAILING_WHITESPACE
  )

else(EXISTS "${CMAKE_SOURCE_DIR}/.git")
  set(GIT_COMMIT_BRANCH "")
  set(GIT_COMMIT_HASH "")
  set(GIT_COMMIT_DATE "")
  set(GIT_COMMIT_AUTHOR "")
  set(GIT_COMMIT_MESSAGE "")
  set(GIT_COMMIT_NUMBER "")
endif(EXISTS "${CMAKE_SOURCE_DIR}/.git")

message(STATUS "Git current branch: ${GIT_COMMIT_BRANCH}")
message(STATUS "Git commit hash: ${GIT_COMMIT_HASH}")
message(STATUS "Git date:   ${GIT_COMMIT_DATE}")
message(STATUS "Git author:   ${GIT_COMMIT_AUTHOR}")
message(STATUS "Git message:   ${GIT_COMMIT_MESSAGE}")
message(STATUS "Git number:   ${GIT_COMMIT_NUMBER}")


message(STATUS "Generating version.h")

configure_file(
  ${CMAKE_SOURCE_DIR}/include/version.h.in
  ${CMAKE_BINARY_DIR}/generated/version.h
)


if( NOT CMAKE_BUILD_TYPE )
  set( CMAKE_BUILD_TYPE Debug CACHE STRING
       "Choose the type of build, options are: Debug Release."
       FORCE )
endif()
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wextra -Wpedantic")
set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -Werror")
set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -O")

include_directories(${CMAKE_BINARY_DIR}/generated)
include_directories(include)

file(GLOB SOURCES "src/*.c")

add_executable(example ${SOURCES})

cotire(example)
