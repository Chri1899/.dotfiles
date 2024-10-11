#!bin/bash

repo="$1"
vis="$2"

echo "Creating a new directory"
mkdir ./$repo
cd $repo
git init

echo "Creating README.md"
touch README.md
git add README.md

echo "Commiting first time"
git commit -m "New Repository"

echo "Creating a new Remote Repository on github"
gh repo create
