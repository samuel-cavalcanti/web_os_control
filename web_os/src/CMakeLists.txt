# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(web_os_library VERSION 0.0.1 LANGUAGES C)

if (CMAKE_BUILD_TYPE STREQUAL "Release")
    set(CARGO_RELEASE_FLAG "--release" CACHE INTERNAL "")
    set(TARGET_DIR "release" CACHE INTERNAL "")
else ()
    set(CARGO_RELEASE_FLAG "" CACHE INTERNAL "")
    set(TARGET_DIR "debug" CACHE INTERNAL "")
endif ()

# Compile a Rust crate and copy the *.so into the current binary dir. This 
# also sets the LOCATION of the provided target to be the generated binary.
#
# A test target named ${target_name}_test is also generated.
function(cargo_library target_name project_dir)
    set(output_library ${CMAKE_CURRENT_BINARY_DIR}/${TARGET_DIR}/lib${target_name}.so)

    set(compile_message "Compiling ${target_name}")

    if(CARGO_RELEASE_FLAG STREQUAL "--release")
        set(compile_message "${compile_message} in release mode")
    endif()

    add_custom_target(${target_name} ALL 
        COMMENT ${compile_message}
        COMMAND env CARGO_TARGET_DIR=${CMAKE_CURRENT_BINARY_DIR} cargo build ${CARGO_RELEASE_FLAG}
        COMMAND cp ${output_library} ${CMAKE_CURRENT_BINARY_DIR}
        WORKING_DIRECTORY ${project_dir})

    set_target_properties(${target_name} PROPERTIES
     PUBLIC_HEADER ${target_name}.h
     OUTPUT_NAME ${target_name}
     LOCATION ${output_library})

   

    add_test(NAME ${target_name}_test 
        COMMAND env CARGO_TARGET_DIR=${CMAKE_CURRENT_BINARY_DIR} cargo test ${CARGO_RELEASE_FLAG}
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
endfunction()

cargo_library(web_os ${CMAKE_CURRENT_SOURCE_DIR}/../)