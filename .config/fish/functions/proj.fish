function proj
    # Parameter prüfen
    if test (count $argv) -lt 1
        echo "Usage: proj <project-name> [--lang <cpp|java|python>] [--build <cmake|gradle|maven>]"
        return 1
    end

    set project_name $argv[1]
    set lang "cpp"
    set build ""

    for i in (seq 2 (count $argv))
        switch $argv[$i]
            case "--lang"
                set lang $argv[(math $i + 1)]
            case "--build"
                set build $argv[(math $i + 1)]
        end
    end

    # Basispfade
    set roots $HOME/Documents/Projects $HOME/.config
    set project_dir ""
    for root in $roots
        if test -d $root/$project_name
            set project_dir $root/$project_name
            break
        end
    end

    # Neues Projekt
    if test -z "$project_dir"
        set project_dir $roots[1]/$project_name
        mkdir -p $project_dir
        echo "Creating new project '$project_name' at $project_dir ..."

        # Sprache-spezifisches Modul laden
        switch $lang
            case "cpp"
                source ~/.config/fish/functions/proj_templates/cpp.fish
                proj_create_cpp $project_dir $project_name
            case "java"
                source ~/.config/fish/functions/proj_templates/java.fish
                proj_create_java $project_dir $project_name $build
            case "python"
                source ~/.config/fish/functions/proj_templates/python.fish
                proj_create_python $project_dir $project_name
            case "*"
                echo "Unknown language: $lang"
                return 1
        end
    end

    # -----------------------------
    # tmux Layout
    # -----------------------------
    source ~/.config/fish/functions/proj_templates/common.fish
    proj_tmux_layout $project_name $project_dir $lang
end

