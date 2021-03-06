cmake_minimum_required(VERSION 3.0.2)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_SOURCE_DIR}/cmake ${CMAKE_SOURCE_DIR}/cmake/3rdparty)

find_package( PythonInterp 3.0 REQUIRED )

set(CMAKE_PREFIX_PATH "${CMAKE_SOURCE_DIR}/dependencies" CACHE PATH "Path to the dependencies")

# WIN32: remove MinSizeRel, Debug builds : unsupported
if (WIN32)
    set(CMAKE_CONFIGURATION_TYPES "RelWithDebInfo;Release" CACHE STRING "" FORCE)
endif ()


################################################################################
# Project definition
################################################################################
set(PROJECT_NAME_SHORT "RoR")
set(PROJECT_NAME_LONG "Rigs of Rods")

project(${PROJECT_NAME_SHORT} VERSION 0.4.8.0)

################################################################################
# Available build options
################################################################################
option(BUILD_DEV_VERSION "Disable this for official releases" ON)
option(BUILD_CUSTOM_VERSION "Specify a custom version" OFF)
option(BUILD_DOC_DOXYGEN "Build documentation from sources with Doxygen" OFF)
option(BUILD_SHOW_WARNINGS "Show build warnings" ON)

if (BUILD_CUSTOM_VERSION)
    set(CUSTOM_VERSION "0.4.8.0-dev" CACHE STRING "Custom version")
endif ()


include(Macros)


# check 64 bit
set(ARCH_DIR "")
if (WIN32)
    message(STATUS "CMAKE_GENERATOR: ${CMAKE_GENERATOR}")
    message(STATUS "CMAKE_CL_64: ${CMAKE_CL_64}")
    if (CMAKE_CL_64)
        set(ARCH_DIR "x64")
        message(STATUS "using 64 bit libraries")
    else ()
        set(ARCH_DIR "x86")
        message(STATUS "using 32 bit libraries")
    endif ()
endif ()

#setup the default build mode

# global cmake options
SET(BUILD_SHARED_LIBS ON)
SET(CMAKE_USE_RELATIVE_PATHS OFF)

# setup paths
SET(RUNTIME_OUTPUT_DIRECTORY "${RoR_BINARY_DIR}/bin/")
SET(LIBRARY_OUTPUT_DIRECTORY "${RoR_BINARY_DIR}/lib/")
SET(ARCHIVE_OUTPUT_DIRECTORY "${RoR_BINARY_DIR}/lib/")
SET(EXECUTABLE_OUTPUT_PATH ${RUNTIME_OUTPUT_DIRECTORY})
SET(LIBRARY_OUTPUT_PATH ${RUNTIME_OUTPUT_DIRECTORY})

# set the tools binary directory accordingly to the used platform
IF (WIN32)
    SET(ROR_BINTOOL_DIR ${RoR_SOURCE_DIR}/tools/windows/binaries)
ELSEIF (UNIX)
    SET(ROR_BINTOOL_DIR ${RoR_SOURCE_DIR}/tools/linux/binaries)
ELSEIF (APPLE)
    SET(ROR_BINTOOL_DIR ${RoR_SOURCE_DIR}/tools/linux/binaries)
ENDIF (WIN32)

set(CMAKE_DEBUG_POSTFIX _d)

# hide some settings
mark_as_advanced(
        CMAKE_DEBUG_POSTFIX
        CMAKE_BACKWARDS_COMPATIBILITY
        EXECUTABLE_OUTPUT_PATH
        LIBRARY_OUTPUT_PATH
)

if (WIN32)
    #set(ROR_USING_VISUAL_STUDIO_PROFESSIONAL "FALSE" CACHE BOOL "if you use VS professional, enable this. DO NOT enable this when using express versions")

    if (BUILD_SHOW_WARNINGS)
        set(warnings /W3 /D_CRT_SECURE_NO_WARNINGS /wd4005 /wd4996 /wd4251 /wd4275 /wd4099 /nologo)
    else ()
        set(warnings /w)
    endif ()
    add_definitions(${warnings})

    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE}        /MP /GL /Ox /Ob2 /Oi /Ot /Oy /fp:fast /GS- /MP /Zi")
    set(CMAKE_CXX_FLAGS_MINSIZEREL "${CMAKE_CXX_FLAGS_MINSIZEREL}     /MP /Zi")
    set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} /MP /Od /Zi /Gy /fp:except /GF- /GS /Ob0")
    #if(ROR_USING_VISUAL_STUDIO_PROFESSIONAL)
    #  set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} /analyze") # /analyze only available when using VS professional
    #endif(ROR_USING_VISUAL_STUDIO_PROFESSIONAL)
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG}          /MP /Od /Zi /RTC1 /Gy /fp:except /GF- /RTCc /GS /Ob0")
    # some general flags
    add_definitions("-D_CRT_SECURE_NO_WARNINGS")
    include_directories(${DirectX_INCLUDE_DIR})

    set(CMAKE_EXE_LINKER_FLAGS_DEBUG "${CMAKE_EXE_LINKER_FLAGS_DEBUG}          /DEBUG /LARGEADDRESSAWARE ")
    set(CMAKE_EXE_LINKER_FLAGS_RELEASE "${CMAKE_EXE_LINKER_FLAGS_RELEASE}        /DEBUG /LARGEADDRESSAWARE /OPT:REF /LTCG /RELEASE")
    set(CMAKE_EXE_LINKER_FLAGS_MINSIZEREL "${CMAKE_EXE_LINKER_FLAGS_MINSIZEREL}     /DEBUG /LARGEADDRESSAWARE /OPT:REF /LTCG ")
    set(CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO "${CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO} /DEBUG /LARGEADDRESSAWARE /OPT:NOREF /MAP /DYNAMICBASE:NO /FIXED /NXCOMPAT:NO")

    # fix executable paths for windows
    #SET(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${RUNTIME_OUTPUT_DIRECTORY})
    #SET(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${RUNTIME_OUTPUT_DIRECTORY})
    #SET(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELWITHDEBINFO ${RUNTIME_OUTPUT_DIRECTORY})
    #SET(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG ${RUNTIME_OUTPUT_DIRECTORY})

ELSEIF (UNIX)
    set(CMAKE_CXX_FLAGS "-std=c++11 ${CMAKE_CXX_FLAGS}")
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG}          -Og -g -Wall")
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE}        -O2 -ffast-math -DNDEBUG -Wno-deprecated-declarations -Wno-terminate")
    set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} -O2 -ffast-math -g -fno-omit-frame-pointer -Wno-deprecated-declarations -Wno-terminate")
    set(CMAKE_CXX_FLAGS_MINSIZEREL "${CMAKE_CXX_FLAGS_MINSIZEREL}     -Os -ffast-math -DNDEBUG")

    set(CMAKE_EXE_LINKER_FLAGS_DEBUG "${CMAKE_EXE_LINKER_FLAGS_DEBUG}")
    set(CMAKE_EXE_LINKER_FLAGS_RELEASE "${CMAKE_EXE_LINKER_FLAGS_RELEASE}")
    set(CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO "${CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO}")

    # add additional gdb debugging stuff
    set(CMAKE_SHARED_LINKER_FLAGS_DEBUG "${CMAKE_SHARED_LINKER_FLAGS_DEBUG} -Og -ggdb")
    set(CMAKE_MODULE_LINKER_FLAGS_DEBUG "${CMAKE_MODULE_LINKER_FLAGS_DEBUG} -Og -ggdb")
endif (WIN32)


################################################################################
# Check for dependencies
################################################################################
include(DependenciesConfig)


################################################################################
# Recurse into subdirectories
################################################################################
add_subdirectory(source)
add_subdirectory(doc)

################################################################################
# Include install script and CPack configuration
################################################################################
include(Install)

include(FeatureSummary)
feature_summary(WHAT ALL)
