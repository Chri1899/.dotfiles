#!/bin/bash

# Interactive Git Commit + Push Script

# Define commit types
types=("feat" "fix" "chore" "docs" "refactor" "style" "test" "perf")

echo "Select commit type:"
select type in "${types[@]}"; do
	if [[ -n "$type" ]]; then
		break
	fi
done

# Ask for commit message
echo "Enter commit message:"
read message

# Build commit string
commit_msg="$type: $message"

# Add, commit, and push
echo "Staging changes..."
git add .

echo "Committing: '$commit_msg'"
git commit -m "$commit_msg"

# Ask whether to push or not
read -p "Do you want to push now? [y/n]: " should_push
if [[ "$should_push" == "y" || "$should_push" == "Y" ]]; then
	echo "Pushing to current branch..."
	git push
else
	echo "Skipping push. You can push later with gp"
fi
