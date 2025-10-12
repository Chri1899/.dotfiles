function proj_tmux_layout
    set project_name $argv[1]
    set project_dir $argv[2]
    set lang $argv[3]

    tmux has-session -t $project_name >/dev/null 2>&1
    if test $status -ne 0
        tmux new-session -d -c $project_dir -s $project_name -n dummy

        switch $lang
            case "cpp"
                tmux new-window -t $project_name:1 -n editor -c $project_dir
                tmux split-window -v -p 20 -t $project_name:1
                tmux send-keys -t $project_name:1.1 "nvim" C-m
                tmux send-keys -t $project_name:1.2 "cd $project_dir/build && clear" C-m
                tmux new-window -t $project_name:2 -n shell -c $project_dir "fish"

            case "java"
                tmux new-window -t $project_name:1 -n editor -c $project_dir "nvim"
                tmux new-window -t $project_name:2 -n shell -c $project_dir "fish"

            case "python"
                tmux new-window -t $project_name:1 -n editor -c $project_dir "nvim"
                tmux new-window -t $project_name:2 -n shell -c $project_dir "fish"
        end

        tmux kill-window -t $project_name:dummy
        tmux select-window -t $project_name:1
    end

    tmux attach -t $project_name
end
