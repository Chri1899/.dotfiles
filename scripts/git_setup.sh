#!bin/zsh

echo "Installing Git"

sudo apt install git

echo "Configuring GIT"

git config --global user.name "Chri1899"
git config --global user.email "c.b-1@outlook.de"
git config --global init.defaultBranch "main"
git config --global --add --bool push.autoSetupRemote true
git config --global alias.st status
git config --global alias.ci commit
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.lg "log --oneline --graph --all --decorate"
