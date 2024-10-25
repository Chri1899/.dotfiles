#!bin/zsh

# Packages for all underlying systems

declare -a packages=(
	stow
	tar
	gcc
	make
	cmake
  ninja-build
  gettext
  unzip
  libtool-bin
	bzip2
	curl
	zsh
  nodejs
  npm
	python3
  python3.12-venv
	openjdk-17-jdk
  openjdk-21-jdk
  gradle
  maven
	fzf
  ripgrep
  gh
	tmux
  luarocks
  python3-pip
  fd-find
)

# If not on WSL

if [[ ! $(grep -i Microsoft /proc/version) ]]; then
	packages+=(feh i3 polybar picom alacritty)
	
	# Install Brave
	sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

	echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

	sudo apt update

	sudo apt install brave-browser

	# Install Emacs

	sudo apt-add remote universe

	sudo apt update

	sudo apt installe emacs-gtk
fi

# Install packages

for package in "${packages[@]}"; do
	echo "Installing ${package}"
	sudo apt install "${package}"

	if [ $package == "zsh" ]
	then
		echo "Setting ZSH as Default Terminal"
		chsh -s $(which zsh)
	fi
done

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install stable nvim branch
git clone https://github.com/neovim/neovim.git

cd neovim
git checkout stable
make CMAKE_BUILD_TYPE=Release
sudo make install

# Install LAZYGIT
LAZYGIT_VERSION=$curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep - Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
