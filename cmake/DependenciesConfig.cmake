# components
set(ROR_USE_OPENAL       "TRUE" CACHE BOOL "use OPENAL")
set(ROR_USE_SOCKETW      "TRUE" CACHE BOOL "use SOCKETW")
set(ROR_USE_PAGED        "TRUE" CACHE BOOL "use paged geometry")
set(ROR_USE_CAELUM       "TRUE" CACHE BOOL "use caelum sky")
set(ROR_USE_ANGELSCRIPT  "TRUE" CACHE BOOL "use angel script")
set(ROR_USE_CURL         "TRUE" CACHE BOOL "use curl, required for communication with online services")
set(ROR_USE_JSONCPP      "TRUE" CACHE BOOL "use jsoncpp")
set(ROR_USE_CRASHRPT 	 "FALSE" CACHE BOOL "use crash report tool")


# some obsolete options:
# disabled some options for now
#set(ROR_FEAT_TIMING     "FALSE" CACHE BOOL "enable beam statistics. For core development only")
set(ROR_BUILD_UPDATER   OFF)
set(ROR_FEAT_TIMING     OFF)
set(ROR_BUILD_SIM       ON)

# set some defaults
IF(WIN32)
macro(importLib libName dirName)
	message(STATUS "adding imported lib: ${libName} : ${ROR_DEPENDENCIES_DIR}/libs/${ARCH_DIR}/${dirName}/Release/${libName}.lib")
	add_library(${libName} STATIC IMPORTED)

	# default is release mode:
	SET_PROPERTY(TARGET ${libName} PROPERTY  IMPORTED_LOCATION ${ROR_DEPENDENCIES_DIR}/libs/${ARCH_DIR}/${dirName}/Release/${libName}.lib)

	# then the special config
	if(EXISTS ${ROR_DEPENDENCIES_DIR}/libs/${ARCH_DIR}/${dirName}/Release/${libName}.lib)
		SET_PROPERTY(TARGET ${libName} PROPERTY  IMPORTED_LOCATION_RELEASE        ${ROR_DEPENDENCIES_DIR}/libs/${ARCH_DIR}/${dirName}/Release/${libName}.lib)
	endif()
	if(EXISTS ${ROR_DEPENDENCIES_DIR}/libs/${ARCH_DIR}/${dirName}/RelWithDebInfo/${libName}.lib)
		SET_PROPERTY(TARGET ${libName} PROPERTY  IMPORTED_LOCATION_RELWITHDEBINFO ${ROR_DEPENDENCIES_DIR}/libs/${ARCH_DIR}/${dirName}/RelWithDebInfo/${libName}.lib)
	else()
		# fallback to release
		SET_PROPERTY(TARGET ${libName} PROPERTY  IMPORTED_LOCATION_RELWITHDEBINFO ${ROR_DEPENDENCIES_DIR}/libs/${ARCH_DIR}/${dirName}/Release/${libName}.lib)
	endif()
	if(EXISTS ${ROR_DEPENDENCIES_DIR}/libs/${ARCH_DIR}/${dirName}/Debug/${libName}_d.lib)
		SET_PROPERTY(TARGET ${libName} PROPERTY  IMPORTED_LOCATION_DEBUG          ${ROR_DEPENDENCIES_DIR}/libs/${ARCH_DIR}/${dirName}/Debug/${libName}_d.lib)
	else()
		# fallback to release
		SET_PROPERTY(TARGET ${libName} PROPERTY  IMPORTED_LOCATION_RELWITHDEBINFO ${ROR_DEPENDENCIES_DIR}/libs/${ARCH_DIR}/${dirName}/Release/${libName}.lib)
	endif()
	if(EXISTS ${ROR_DEPENDENCIES_DIR}/libs/${ARCH_DIR}/${dirName}/Debug/${libName}.lib)
		SET_PROPERTY(TARGET ${libName} PROPERTY  IMPORTED_LOCATION_DEBUG          ${ROR_DEPENDENCIES_DIR}/libs/${ARCH_DIR}/${dirName}/Debug/${libName}.lib)
	else()
		# fallback to release
		SET_PROPERTY(TARGET ${libName} PROPERTY  IMPORTED_LOCATION_RELWITHDEBINFO ${ROR_DEPENDENCIES_DIR}/libs/${ARCH_DIR}/${dirName}/Release/${libName}.lib)
	endif()
	if(EXISTS ${ROR_DEPENDENCIES_DIR}/libs/${ARCH_DIR}/${dirName}/MinSizeRel/${libName}.lib)
		SET_PROPERTY(TARGET ${libName} PROPERTY  IMPORTED_LOCATION_MINSIZEREL     ${ROR_DEPENDENCIES_DIR}/libs/${ARCH_DIR}/${dirName}/MinSizeRel/${libName}.lib)
	else()
		# fallback to release
		SET_PROPERTY(TARGET ${libName} PROPERTY  IMPORTED_LOCATION_RELWITHDEBINFO ${ROR_DEPENDENCIES_DIR}/libs/${ARCH_DIR}/${dirName}/Release/${libName}.lib)
	endif()
endmacro(importLib)


	set(ROR_USE_OIS_G27      "FALSE" CACHE BOOL "use OIS With G27 patches")
	set(ROR_USE_MOFILEREADER "TRUE" CACHE BOOL "use mofilereader")

	# check if dependencies dir is in here
	set(DEPENDENCIES_DIR_CHECK "${RoR_SOURCE_DIR}/dependencies")
	set(DEPENDENCIES_DIR "")
	if(IS_DIRECTORY ${DEPENDENCIES_DIR_CHECK})
		set(DEPENDENCIES_DIR ${DEPENDENCIES_DIR_CHECK})
	endif(IS_DIRECTORY ${DEPENDENCIES_DIR_CHECK})

	set(ROR_DEPENDENCIES_DIR "${DEPENDENCIES_DIR}" CACHE PATH "The ROR dependency path to use")

	if(NOT ROR_DEPENDENCIES_DIR)
		message(FATAL_ERROR "Rigs of Rods dependency dir not set properly!")
	endif(NOT ROR_DEPENDENCIES_DIR)

	#### REQUIRED COMPONENTS

	set(ROR_OGRE_VERSION_18     "FALSE" CACHE BOOL "Enable this if you are building with ogre 1.8")

	if(ROR_OGRE_VERSION_18)

		set(Ogre_INCLUDE_DIRS
			"${ROR_DEPENDENCIES_DIR}/includes/${ARCH_DIR}/Ogre/;"
			"${ROR_DEPENDENCIES_DIR}/includes/${ARCH_DIR}/Ogre/Terrain;"
			"${ROR_DEPENDENCIES_DIR}/includes/${ARCH_DIR}/Ogre/Paging;"
			"${ROR_DEPENDENCIES_DIR}/includes/${ARCH_DIR}/Ogre/RTShaderSystem;"
			"The ogre include path to use")
		importLib(OgreMain Ogre)
		importLib(OgreTerrain Ogre)
		importLib(OgrePaging Ogre)
		importLib(OgreRTShaderSystem Ogre)
		set(Ogre_LIBRARIES "OgreMain;OgreTerrain;OgrePaging;OgreRTShaderSystem" CACHE STRING "The Ogre libs to link against")

	else()

		set(Ogre_INCLUDE_DIRS
			"${ROR_DEPENDENCIES_DIR}/includes/${ARCH_DIR}/Ogre/;"
			"${ROR_DEPENDENCIES_DIR}/includes/${ARCH_DIR}/Ogre/Terrain;"
			"${ROR_DEPENDENCIES_DIR}/includes/${ARCH_DIR}/Ogre/Paging;"
			"${ROR_DEPENDENCIES_DIR}/includes/${ARCH_DIR}/Ogre/RTShaderSystem;"
			"${ROR_DEPENDENCIES_DIR}/includes/${ARCH_DIR}/Ogre/Overlay;"
			"The ogre include path to use")

		importLib(OgreMain Ogre)
		importLib(OgreTerrain Ogre)
		importLib(OgrePaging Ogre)
		importLib(OgreRTShaderSystem Ogre)
		importLib(OgreOverlay Ogre)
		set(Ogre_LIBRARIES "OgreMain;OgreTerrain;OgrePaging;OgreRTShaderSystem;OgreOverlay" CACHE STRING "The Ogre libs to link against")

	endif()

	set(Ois_INCLUDE_DIRS "${ROR_DEPENDENCIES_DIR}/includes/${ARCH_DIR}/ois" CACHE PATH "The OIS include path to use")
	importLib(ois_static OIS)
	set(Ois_LIBRARIES "ois_static" CACHE STRING "The OIS libs to link against")

	# directX
	set(DirectX_INCLUDE_DIRS "$ENV{DXSDK_DIR}/Include" CACHE PATH "The DirectX include path to use")
	set(DirectX_LIBRARY_DIRS "$ENV{DXSDK_DIR}/lib/${ARCH_DIR}/" CACHE PATH "The DirectX lib path to use")
	include_directories(${DirectX_INCLUDE_DIRS})
	link_directories   (${DirectX_LIBRARY_DIRS})

	set(MYGUI_INCLUDE_DIRS "${ROR_DEPENDENCIES_DIR}/includes/${ARCH_DIR}/MyGUI" CACHE PATH "The mygui include path to use")
	importLib(MyGUIEngineStatic MyGUI)
	importLib(MyGUI.OgrePlatform MyGUI)
	importLib(freetype MyGUI)
	set(MYGUI_LIBRARIES "MyGUI.OgrePlatform;MyGUIEngineStatic;freetype" CACHE STRING "The mygui libs to link against")


	#### OPTIONAL COMPONENTS

	# special include path for curl ...
	if(ROR_USE_CURL)
		set(CURL_INCLUDE_DIRS "${ROR_DEPENDENCIES_DIR}/includes/${ARCH_DIR}/curl" CACHE PATH "The curl include path to use")
		set(CURL_LIBRARIES "libcurl_imp" CACHE STRING "The curl lib to link against")
		importLib(libcurl_imp curl)
	endif(ROR_USE_CURL)

	if(ROR_USE_OPENAL)
		set(OPENAL_INCLUDE_DIRS "${ROR_DEPENDENCIES_DIR}/includes/${ARCH_DIR}/OpenALSoft" CACHE PATH "The openal include path to use")
		importLib(OpenAL32 OpenALSoft)
		set(OPENAL_LIBRARIES "OpenAL32" CACHE STRING "The openal libs to link against")
	endif(ROR_USE_OPENAL)

	if(ROR_USE_SOCKETW)
		set(SOCKETW_INCLUDE_DIRS "${ROR_DEPENDENCIES_DIR}/includes/${ARCH_DIR}/SocketW" CACHE PATH "The socketw include path to use")
		importLib(SocketW SocketW)
		set(SOCKETW_LIBRARIES    "SocketW;Ws2_32.lib" CACHE STRING "The socketw lib to link against")
	endif(ROR_USE_SOCKETW)

	if(ROR_USE_MOFILEREADER)
		set(MOFILEREADER_INCLUDE_DIRS "${ROR_DEPENDENCIES_DIR}/includes/${ARCH_DIR}/mofilereader" CACHE PATH "The mofilereader include path to use")
		importLib(moFileReader.static MoFileReader)
		set(MOFILEREADER_LIBRARIES    "moFileReader.static" CACHE STRING "The mofilereader lib to link against")
	endif(ROR_USE_MOFILEREADER)

	if(ROR_USE_PAGED)
		set(PAGED_INCLUDE_DIRS "${ROR_DEPENDENCIES_DIR}/includes/${ARCH_DIR}/PagedGeometry" CACHE PATH "The paged include path to use")
		importLib(PagedGeometry PagedGeometry)
		set(PAGED_LIBRARIES    "PagedGeometry" CACHE STRING "The paged lib to link against")
	endif(ROR_USE_PAGED)

	if(ROR_USE_CAELUM)
		set(CAELUM_INCLUDE_DIRS "${ROR_DEPENDENCIES_DIR}/includes/${ARCH_DIR}/Caelum" CACHE PATH "The caelum include path to use")
		importLib(Caelum Caelum)
		set(CAELUM_LIBRARIES    "Caelum" CACHE STRING "The caelum lib to link against")
	endif(ROR_USE_CAELUM)

	if(ROR_USE_CRASHRPT)
		set(CRASHRPT_INCLUDE_DIRS "${ROR_DEPENDENCIES_DIR}/includes/${ARCH_DIR}/CrashRpt" CACHE PATH "The CrashRpt include path to use")
		importLib(CrashRpt CrashRpt)
		set(CRASHRPT_LIBRARIES    "CrashRpt" CACHE STRING "The CrashRpt lib to link against")
	endif(ROR_USE_CRASHRPT)

	if(ROR_USE_ANGELSCRIPT)
		set(ANGELSCRIPT_INCLUDE_DIRS "${ROR_DEPENDENCIES_DIR}/includes/${ARCH_DIR}/AngelScript;${RoR_SOURCE_DIR}/source/angelscript_addons" CACHE PATH "The AngelScript include path to use")
		importLib(angelscript angelscript)
		set(ANGELSCRIPT_LIBRARIES    "angelscript" CACHE STRING "The AngelScript libs to link against")
	endif(ROR_USE_ANGELSCRIPT)

	if(ROR_USE_JSONCPP)
		set(JSONCPP_INCLUDE_DIRS "${ROR_DEPENDENCIES_DIR}/includes/${ARCH_DIR}/JsonCpp" CACHE PATH "The JsonCpp include path to use")
		importLib(JsonCpp JsonCpp)
		set(JSONCPP_LIBRARIES    "JsonCpp" CACHE STRING "The JsonCpp lib to link against")
	endif(ROR_USE_JSONCPP)

ELSEIF(UNIX)
   find_package(PkgConfig)
   PKG_CHECK_MODULES  (GTK gtk+-2.0 REQUIRED)
   PKG_CHECK_MODULES  (GTK_PIXBUF gdk-pixbuf-2.0 REQUIRED)
   include_directories(${GTK_INCLUDE_DIRS})
   include_directories(${GTK_PIXBUF_INCLUDE_DIRS})

   # Ogre basics
   PKG_CHECK_MODULES  (Ogre OGRE REQUIRED)

   # Ogre components
   PKG_CHECK_MODULES  (Ogre_Terrain  OGRE-Terrain         REQUIRED)
   PKG_CHECK_MODULES  (Ogre_Paging   OGRE-Paging          REQUIRED)
   if(NOT (Ogre_VERSION VERSION_LESS 1.9.0))
	PKG_CHECK_MODULES  (Ogre_Overlay  OGRE-Overlay         REQUIRED)
   endif()
   PKG_CHECK_MODULES  (Ogre_RTShader OGRE-RTShaderSystem  REQUIRED)


   PKG_CHECK_MODULES  (Ois OIS REQUIRED)

   # using pkg-config
   # MyGUI
   PKG_CHECK_MODULES(MYGUI MYGUI REQUIRED)
   find_library(MYGUI_OGRE_PLATFORM MyGUI.OgrePlatform)
   set(MYGUI_LIBRARIES ${MYGUI_LIBRARIES} ${MYGUI_OGRE_PLATFORM})
   # add our mygui BaseLayout
   set(MYGUI_INCLUDE_DIRS ${MYGUI_INCLUDE_DIRS})

   find_package(CURL)
   if(CURL_FOUND)
	set(CURL_INCLUDE_DIRS ${CURL_INCLUDE_DIR})
	set(CURL_LIBRARIES ${CURL_LIBRARY})
	set(ROR_USE_CURL ON)
   else()
	set(ROR_USE_CURL OFF)
   endif(CURL_FOUND)


   # using cmake fingd modules
   # Open-AL
   find_package(OpenAL)
   if(OPENAL_FOUND)
      set(OPENAL_INCLUDE_DIRS ${OPENAL_INCLUDE_DIR})
      set(OPENAL_LIBRARIES ${OPENAL_LIBRARY})
      set(ROR_USE_OPENAL ON)
   else()
      set(ROR_USE_OPENAL OFF)
   endif(OPENAL_FOUND)

   # JsonCpp
   find_path(JSONCPP_INCLUDE_DIRS "json/json.h")
   if(JSONCPP_INCLUDE_DIRS)
      find_library(JSONCPP_LIBRARIES "jsoncpp")
      set(ROR_USE_JSONCPP ON)
   else()
      set(ROR_USE_JSONCPP OFF)
   endif(JSONCPP_INCLUDE_DIRS)

   # SocketW
   find_path(SOCKETW_INCLUDE_DIRS "SocketW.h")
   if(SOCKETW_INCLUDE_DIRS)
      find_library(SOCKETW_LIBRARIES "SocketW")
      set(ROR_USE_SOCKETW ON)
   else()
      set(ROR_USE_SOCKETW OFF)
   endif(SOCKETW_INCLUDE_DIRS)

   # Paged Geometry
   find_path(PAGED_INCLUDE_DIRS "PagedGeometry/PagedGeometry.h" PATHS /usr/include/OGRE)
   if(PAGED_INCLUDE_DIRS)
      set(PAGED_INCLUDE_DIRS "${PAGED_INCLUDE_DIRS};${PAGED_INCLUDE_DIRS}/PagedGeometry")
      find_library(PAGED_LIBRARIES "PagedGeometry" PATHS /usr/lib/OGRE /usr/lib64/OGRE)
      set(ROR_USE_PAGED ON)
   else()
      set(ROR_USE_PAGED OFF)
   endif(PAGED_INCLUDE_DIRS)

   # Caelum
   find_path(CAELUM_INCLUDE_DIRS "Caelum/Caelum.h")
   if(CAELUM_INCLUDE_DIRS)
      set(CAELUM_INCLUDE_DIRS "${CAELUM_INCLUDE_DIRS}/Caelum")
      find_library(CAELUM_LIBRARIES "Caelum")
      set(ROR_USE_CAELUM ON)
   else()
      set(ROR_USE_CAELUM OFF)
   endif(CAELUM_INCLUDE_DIRS)

   # Angelscript
   find_path(ANGELSCRIPT_INCLUDE_DIRS "angelscript.h")
   if(ANGELSCRIPT_INCLUDE_DIRS)
      find_library(ANGELSCRIPT_LIBRARIES "angelscript")
      # add our addons to the include path
      set(ANGELSCRIPT_INCLUDE_DIRS "${ANGELSCRIPT_INCLUDE_DIRS};${RoR_SOURCE_DIR}/source/angelscript_addons")
      set(ROR_USE_ANGELSCRIPT ON)
   else()
      set(ROR_USE_ANGELSCRIPT OFF)
   endif(ANGELSCRIPT_INCLUDE_DIRS)

   set(ROR_USE_CRASHRPT FALSE)
   set(ROR_USE_OIS_G27 FALSE)
ENDIF(WIN32)
