

#platform huawei
set(PATH_HUAWEI_LIBS ${PROJ_MAIN_PATH}/platform/huawei/libs)
set(PATH_HUAWEI_INC ${PROJ_MAIN_PATH}/platform/huawei/include)

## securec library
set(LIBS_LIST_HUAWEI
        ${PATH_HUAWEI_LIBS}/libdopra.a
        ${PATH_HUAWEI_LIBS}/libsecurec.a)

## googleTest
set(GOOGLETEST_VERSION 3.15)
set(PATH_GTEST_MAIN ${PROJ_MAIN_PATH}/googletest/googletest)
set(PATH_GTEST_MOCK ${PROJ_MAIN_PATH}/googletest/googlemock)

set(LIBS_LIST_GTEST
        ${PROJ_MAIN_PATH}/platform/gtest/libgmockd.a
        ${PROJ_MAIN_PATH}/platform/gtest/libgmock_maind.a
        ${PROJ_MAIN_PATH}/platform/gtest/libgtest_maind.a
        ${PROJ_MAIN_PATH}/platform/gtest/libgtestd.a)

set(PATH_GTEST_INC_LIST
        ${PATH_GTEST_MAIN}/include
        ${PATH_GTEST_MAIN}/include/gtest
        ${PATH_GTEST_MOCK}/include
        ${PATH_GTEST_MOCK}/include/gmock)


set(SRC_INC_LIST
        ${PROJ_MAIN_PATH}/inc
        ${PROJ_MAIN_PATH}/src)


##define


add_compile_options(-Wall)

add_compile_definitions(__d00450703__)

# google test begin
include_directories(${PATH_GTEST_INC_LIST})
#############build googletest begin
#add_subdirectory(${PATH_GTEST_MOCK})
#link_directories(${PATH_GTEST_MOCK})
#set(GOOGLETESTLIB gtest gmock)
##############build googletest end
##gtest source files
set(GTEST_SRC_PATH_LIST ${PROJECT_SOURCE_DIR}/GTestLLT)
aux_source_directory(${GTEST_SRC_PATH_LIST} GTEST_SRC_LIST)
##google test end

##head files
include_directories(${SRC_INC_LIST})
include_directories(${PATH_HUAWEI_INC})

##souce files

aux_source_directory(${PROJECT_SOURCE_DIR} SRC_LIST_ROOT)
aux_source_directory(${PROJECT_SOURCE_DIR}/src SRC_LIST_MAIN)

set(SRC_LIST_ALL
        ${GTEST_SRC_LIST}
        ${SRC_LIST_ROOT}
        ${SRC_LIST_MAIN})

link_libraries(${LIBS_LIST_HUAWEI})
link_libraries(${LIBS_LIST_GTEST})


set(LEETCODE_COMPILE_OPTIONS
    --param=ssp-buffer-size=4
    -mtune=cortex-a9
    ${SYSROOT_OPTIONS}
    -DVOS_OS_VER=4
    -DVOS_CPU_TYPE=31
    -DVOS_HARDWARE_PLATFORM=8
    )
function(glob_dir_all_source_files DIR_LIST)
  foreach(dir ${DIR_LIST})
    file(GLOB_RECURSE SRC_C_LIST "${dir}/*.c")
    file(GLOB_RECURSE SRC_CXX_LIST "${dir}/*.cpp")
    list(APPEND FILE_LIST ${SRC_C_LIST} ${SRC_CXX_LIST})
  endforeach()
  set(LEETCODE_OBJ_SRC_LIST ${FILE_LIST} PARENT_SCOPE)
endfunction()

glob_dir_all_source_files("${DIR_TRAN_SRC_LIST}")
list(SORT LEETCODE_OBJ_SRC_LIST COMPARE FILE_BASENAME)
add_library(test_leetcode SHARED ${LEETCODE_OBJ_SRC_LIST})
target_compile_options(test_leetcode PRIVATE ${LEETCODE_COMPILE_OPTIONS})
target_link_options(test_leetcode PRIVATE ${LEETCODE_LINK_OPTIONS})

# stripµô·ûºÅ
add_custom_command(
    TARGET test_leetcode POST_BUILD
    COMMAND ${STRIP} $<TARGET_FILE:test_leetcode>
)

install(TARGETS test_leetcode
    ARCHIVE DESTINATION ${OUTPUT_PATH}/lib/${BOARD_TYPE} OPTIONAL
    LIBRARY DESTINATION ${OUTPUT_PATH}/lib/${BOARD_TYPE} OPTIONAL
    RUNTIME DESTINATION ${OUTPUT_PATH}/bin/${BOARD_TYPE} OPTIONAL
)

if(${BUILD_MAIN_SRC} MATCHES "ON")
    aux_source_directory(${PROJECT_SOURCE_DIR}/src SRC_LIST_MAINSRC)
endif()

if(${BUILD_SORTLIB} MATCHES "ON")
    aux_source_directory(${PROJECT_SOURCE_DIR}/sortlib SRC_LIST_SORTLIBSRC)
endif()

# ON or OFF





