#!/bin/zsh

declare -a packages=(
	stow
	tar
	gcc
	make
	bzip2
	curl
)

for package in "${packages[@]}"; do
	echo "Installing ${package}"
	sudo apt install "$package"
done
