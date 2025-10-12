function proj_create_python
    set project_dir $argv[1]
    set project_name $argv[2]

    mkdir -p $project_dir/src

    # main.py
    echo "#!/usr/bin/env python3

def main():
    print('Hello World from $project_name!')

if __name__ == '__main__':
    main()" > $project_dir/src/main.py
end
