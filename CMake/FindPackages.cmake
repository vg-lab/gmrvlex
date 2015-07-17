
include(System)
list(APPEND FIND_PACKAGES_DEFINES ${SYSTEM})
find_package(PkgConfig)

# Find package ZEQ which is optional
find_package(zeq REQUIRED)
if(ZEQ_FOUND)
  set(zeq_name ZEQ)
  set(zeq_FOUND TRUE)
elseif(zeq_FOUND)
  set(zeq_name zeq)
  set(zeq_FOUND TRUE)
endif()

if(zeq_name) 
  list(APPEND GMRVZEQ_DEPENDENT_LIBRARIES zeq)
  list(APPEND FIND_PACKAGES_DEFINES GMRVZEQ_WITH_ZEQ)
  set(FIND_PACKAGES_FOUND "${FIND_PACKAGES_FOUND} zeq")
  link_directories(${${zeq_name}_LIBRARY_DIRS})
  if(NOT "${${libzeq_name}_INCLUDE_DIRS}" MATCHES "-NOTFOUND")
    include_directories(${${zeq_name}_INCLUDE_DIRS})
  endif()   
endif()


# Find package FLATBUFFERS which is optional
find_package(FlatBuffers REQUIRED)
if(FLATBUFFERS_FOUND)
  set(FlatBuffers_name FLATBUFFERS)
  set(FlatBuffers_FOUND TRUE)
elseif(FlatBuffers_FOUND)
  set(FlatBuffers_name FlatBuffers)
  set(FlatBuffers_FOUND TRUE)
endif()

if(FlatBuffers_name) 
  list(APPEND GMRVZEQ_DEPENDENT_LIBRARIES FlatBuffers)
  list(APPEND FIND_PACKAGES_DEFINES GMRVZEQ_WITH_FLATBUFFERS)
  set(FIND_PACKAGES_FOUND "${FIND_PACKAGES_FOUND} FlatBuffers")
  link_directories(${${FlatBuffers_name}_LIBRARY_DIRS})
  if(NOT "${${FlatBuffers_name}_INCLUDE_DIRS}" MATCHES "-NOTFOUND")
    include_directories(BEFORE SYSTEM ${${FlatBuffers_name}_INCLUDE_DIRS})
  endif()   
endif()



# Write defines.h and options.cmake
if(NOT PROJECT_INCLUDE_NAME)
  message(WARNING 
    "PROJECT_INCLUDE_NAME not set, old or missing Common.cmake?")
  set(PROJECT_INCLUDE_NAME ${PROJECT_NAME})
endif()
if(NOT OPTIONS_CMAKE)
  set(OPTIONS_CMAKE ${CMAKE_CURRENT_BINARY_DIR}/options.cmake)
endif()
set(DEFINES_FILE "${CMAKE_CURRENT_BINARY_DIR}/include/${PROJECT_INCLUDE_NAME}/defines${SYSTEM}.h")
list(APPEND COMMON_INCLUDES ${DEFINES_FILE})
set(DEFINES_FILE_IN ${DEFINES_FILE}.in)
file(WRITE ${DEFINES_FILE_IN}
  "// generated by CMake/FindPackages.cmake, do not edit.\n\n"
  "#ifndef ${PROJECT_NAME}_DEFINES_${SYSTEM}_H\n"
  "#define ${PROJECT_NAME}_DEFINES_${SYSTEM}_H\n\n")
file(WRITE ${OPTIONS_CMAKE} "# Optional modules enabled during build\n")
foreach(DEF ${FIND_PACKAGES_DEFINES})
  add_definitions(-D${DEF}=1)
  file(APPEND ${DEFINES_FILE_IN}
  "#ifndef ${DEF}\n"
  "#  define ${DEF} 1\n"
  "#endif\n")
if(NOT DEF STREQUAL SYSTEM)
  file(APPEND ${OPTIONS_CMAKE} "set(${DEF} ON)\n")
endif()
endforeach()
if(CMAKE_MODULE_INSTALL_PATH)
  install(FILES ${OPTIONS_CMAKE} DESTINATION ${CMAKE_MODULE_INSTALL_PATH}
    COMPONENT dev)
else()
  message(WARNING 
    "CMAKE_MODULE_INSTALL_PATH not set, old or missing Common.cmake?")
endif()
file(APPEND ${DEFINES_FILE_IN}
  "\n#endif\n")

include(UpdateFile)
configure_file(${DEFINES_FILE_IN} ${DEFINES_FILE} COPYONLY)

if(FIND_PACKAGES_FOUND)
  if(MSVC)
    message(STATUS 
      "Configured ${PROJECT_NAME} with ${FIND_PACKAGES_FOUND}")
  else()
    message(STATUS 
      "Configured ${PROJECT_NAME} with ${CMAKE_BUILD_TYPE}${FIND_PACKAGES_FOUND}")
  endif()
endif()


