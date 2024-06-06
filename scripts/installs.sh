#!bin/zsh

# APT Packages
declare -a packages=(
	stow
	tar
	gcc
	make
	bzip2
	curl
	i3
	alacritty
	zsh
	neovim
	python3
	openjdk-17-jdk
	gradle
	fzf
	feh
)

for package in "${packages[@]}"; do
	echo "Installing ${package}"
	sudo apt install "${package}"

	if [ $package == "zsh" ]
	then
		echo "Setting ZSH as Default Terminal"
		chsh -s $(which zsh)
	fi
done

# Install Brave
sudo apt install curl

sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

sudo apt update

sudo apt install brave-browser
