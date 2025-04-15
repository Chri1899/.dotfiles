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

echo "Pushing to current branch..."
git push
