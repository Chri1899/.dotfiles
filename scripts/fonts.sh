#!/bin/zsh

declare -a fonts=(
	InconsolataGo
	FiraMono
	JetBrainsMono
	Hack
)

fonts_dir="${HOME}/.local/share/fonts"

if [[ ! -d "$fonts_dir" ]]; then
	mkdir -p "$fonts_dir"
fi

cd "$fonts_dir"

for font in "${fonts[@]}"; do
	tar_file="${font}.tar.xz"
	curl_url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${tar_file}"
	echo "Curling Font Archive from github"
	curl -OL "$curl_url"
	echo "Extracting Tarball"
	sudo tar -xf "$tar_file"
	echo "Removing tarball"
	rm "$tar_file"
done

sudo apt install fonts-font-awesome
