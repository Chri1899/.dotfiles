#!bin/bash

project="$1"

echo "Creating new Project Directory"
mkdir $project

echo "Initializing new Project Structure"
cd $project
mkdir src

touch .clangd
cat >> .clangd << EOF
CompileFlags:
  CompilationDatabase: "cmake"
EOF

touch CMakeLists.txt
cat >> CMakeLists.txt << EOF 
# TODO 1 Set the minimum cmake version
cmake_minimum_required(VERSION 3.10)
# TODO 2 Create a project
cmake_path(GET CMAKE_CURRENT_SOURCE_DIR FILENAME ProjectName)
string(REPLACE " " "_" ProjectId ${ProjectName})
project(${ProjectName})

# For command_compile.json
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Set the SRC path
file(GLOB_RECURSE sources
    "${CMAKE_SOURCE_DIR}/src/*.c"
    "${CMAKE_SOURCE_DIR}/src/*.cpp"
)


# TODO 3 Add an executable called Tutorial to the project
add_executable(${ProjectName} ${sources})
EOF
