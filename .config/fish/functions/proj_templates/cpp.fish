function proj_create_cpp
    set project_dir $argv[1]
    set project_name $argv[2]

    mkdir -p $project_dir/src $project_dir/include $project_dir/tests $project_dir/build

    # CMakeLists.txt
    echo "cmake_minimum_required(VERSION 3.15)
project($project_name VERSION 1.0 LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 17)
file(GLOB_RECURSE SRC_FILES \"src/*.cpp\" \"src/*.h\")
add_executable(\${PROJECT_NAME} \${SRC_FILES})" > $project_dir/CMakeLists.txt

    # main.cpp
    echo '#include <iostream>
int main() {
    std::cout << "Hello World from '"$project_name"'!" << std::endl;
    return 0;
}' > $project_dir/src/main.cpp
end
