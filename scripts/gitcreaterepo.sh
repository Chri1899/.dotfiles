#!bin/bash

repo="$1"

echo "Creating a new directory"
mkdir ./$repo
cd $repo

echo "Creating a new remote repository on github"
curl -u Chri1899 https://api.github.com/user/repos -d "{\"name\":\"$repo\"}"
git init

echo "Add README Content" > README.md
git add README.md
git commit -m "New Repository"

git remote add origin git@github.com:Chri1899/$repo.git
git push -u origin main
