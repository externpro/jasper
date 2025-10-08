include(xpcfg)
cmake_push_check_state(CONFIGURE_CMAKE)
########################################
xpcfgCheckIncludeFile(windows.h HAVE_WINDOWS_H)
xpcfgCheckIncludeFile(dlfcn.h HAVE_DLFCN_H)
xpcfgCheckIncludeFile(fcntl.h HAVE_FCNTL_H)
xpcfgCheckIncludeFile(inttypes.h HAVE_INTTYPES_H)
xpcfgCheckIncludeFile(io.h HAVE_IO_H)
xpcfgCheckIncludeFile(limits.h HAVE_LIMITS_H)
xpcfgCheckIncludeFile(memory.h HAVE_MEMORY_H)
xpcfgCheckIncludeFile(stdbool.h HAVE_STDBOOL_H)
xpcfgCheckIncludeFile(stddef.h HAVE_STDDEF_H)
xpcfgCheckIncludeFile(stdint.h HAVE_STDINT_H)
xpcfgCheckIncludeFile(stdlib.h HAVE_STDLIB_H)
xpcfgCheckIncludeFile(strings.h HAVE_STRINGS_H)
xpcfgCheckIncludeFile(string.h HAVE_STRING_H)
xpcfgCheckIncludeFile(sys/stat.h HAVE_SYS_STAT_H)
xpcfgCheckIncludeFile(sys/time.h HAVE_SYS_TIME_H)
xpcfgCheckIncludeFile(sys/types.h HAVE_SYS_TYPES_H)
xpcfgCheckIncludeFile(unistd.h HAVE_UNISTD_H)
xpcfgCheckLibraryExists(m log HAVE_LIBM)
xpcfgCheckSymFnExists(getrusage HAVE_GETRUSAGE)
xpcfgCheckSymFnExists(gettimeofday HAVE_GETTIMEOFDAY)
xpcfgCheckSymFnExists(vprintf HAVE_VPRINTF) #TODO: not used in code?
########################################
include(CheckTypeSize)
set(CMAKE_EXTRA_INCLUDE_FILES sys/types.h)
check_type_size(longlong SIZEOF_LONGLONG) # sets HAVE_SIZEOF_LONGLONG
check_type_size(size_t SIZEOF_SIZE_T) # sets HAVE_SIZEOF_SIZE_T
check_type_size(ssize_t SIZEOF_SSIZE_T) # sets HAVE_SIZEOF_SSIZE_T
check_type_size(uchar SIZEOF_UCHAR) # sets HAVE_SIZEOF_UCHAR
check_type_size(uint SIZEOF_UINT) # sets HAVE_SIZEOF_UINT
check_type_size(ulong SIZEOF_ULONG) # sets HAVE_SIZEOF_ULONG
check_type_size(ulonglong SIZEOF_ULONGLONG) # sets HAVE_SIZEOF_ULONGLONG
check_type_size(ushort SIZEOF_USHORT) # sets HAVE_SIZEOF_USHORT
set(CMAKE_EXTRA_INCLUDE_FILES)
##########
if(NOT HAVE_SIZEOF_LONGLONG)
  set(longlong "long long") # Define to `long long' if <sys/types.h> does not define.
else()
  set(longlong 0) # cmakedefine
endif()
if(NOT HAVE_SIZEOF_SIZE_T)
  set(size_t "unsigned") # Define to `unsigned' if <sys/types.h> does not define.
else()
  set(size_t 0) # cmakedefine
endif()
if(NOT HAVE_SIZEOF_SSIZE_T AND NOT WIN32) # TRICKY: don't define on Windows, see jas_config2.h
  set(ssize_t "int") # Define to `int' if <sys/types.h> does not define.
else()
  set(ssize_t 0) # cmakedefine
endif()
if(NOT HAVE_SIZEOF_UCHAR)
  set(uchar "unsigned char") # Define to `unsigned char' if <sys/types.h> does not define.
else()
  set(uchar 0) # cmakedefine
endif()
if(NOT HAVE_SIZEOF_UINT)
  set(uint "unsigned int") # Define to `unsigned int' if <sys/types.h> does not define.
else()
  set(uint 0) # cmakedefine
endif()
if(NOT HAVE_SIZEOF_ULONG)
  set(ulong "unsigned long") # Define to `unsigned long' if <sys/types.h> does not define.
else()
  set(ulong 0) # cmakedefine
endif()
if(NOT HAVE_SIZEOF_ULONGLONG)
  set(ulonglong "unsigned long long") # Define to `unsigned long long' if <sys/types.h> does not define.
else()
  set(ulonglong 0) # cmakedefine
endif()
if(NOT HAVE_SIZEOF_USHORT)
  set(ushort "unsigned short") # Define to `unsigned short' if <sys/types.h> does not define.
else()
  set(ushort 0) # cmakedefine
endif()
########################################
file(STRINGS jasper.spec PKG_NAME REGEX "^%define[\t ]+package_name[ \t]+.")
string(REGEX REPLACE "^%define[\t ]+package_name([ \t]+)" "" PKG_NAME ${PKG_NAME})
file(STRINGS jasper.spec PKG_VERSION REGEX "^%define[\t ]+ver[ \t]+([0-9]+)\\.([0-9]+)\\.([0-9]+)?")
string(REGEX REPLACE "^%define[\t ]+ver([ \t]+)" "" PKG_VERSION ${PKG_VERSION})
# JasPer version
set(JAS_VERSION "\"${PKG_VERSION}\"")
# Name of package
set(PACKAGE "\"${PKG_NAME}\"")
# Define to the address where bug reports for this package should be sent.
set(PACKAGE_BUGREPORT "\"https://github.com/jasper-software/jasper/issues\"")
# Define to the full name of this package.
set(PACKAGE_NAME "\"${PKG_NAME}\"")
# Define to the full name and version of this package.
set(PACKAGE_STRING "\"${PKG_NAME} ${PKG_VERSION}\"")
# Define to the one symbol short name of this package.
set(PACKAGE_TARNAME "\"${PKG_NAME}\"")
# Define to the version of this package.
set(PACKAGE_VERSION "\"${PKG_VERSION}\"")
# Version number of package
set(VERSION "\"${PKG_VERSION}\"")
########################################
option(DEBUG "Extra debugging support" FALSE)
option(DEBUG_MEMALLOC "Debugging memory allocator" FALSE)
option(DEBUG_OVERFLOW "Debugging overflow detection" FALSE)
########################################
# Define to 1 if you don't have `vprintf' but do have `_doprnt'.
if(NOT HAVE_VPRINTF)
  xpcfgCheck_doprnt(HAVE_DOPRNT)
else()
  set(HAVE_DOPRNT 0) # cmakedefine
endif()
########################################
xpcfgHaveVariableLengthArrays(HAVE_VLA)
set(JAS_CONFIGURE TRUE)
xpcfgStdcHeaders(STDC_HEADERS)
# Define to 1 if the X Window System is missing or not being used.
set(X_DISPLAY_MISSING FALSE) #TODO: determine if false, not used in code?
xpcfgConst(const)
set(inline 0) # cmakedefine
xpcfgDotinFile("src/libjasper/include/jasper/jas_config.h.in" "jasper/jas_config.h")
cmake_pop_check_state()
