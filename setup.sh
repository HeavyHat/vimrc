#!/bin/bash

function install_bash() {
  echo "Changing shell to bash."
  chsh --shell bash
  echo "Copying config."
  cp -r .bash* ~/.
}

function install_zsh() {
  echo "Changing shell to zsh."
  chsh --shell zsh
  echo "Installing oh-my-zsh."
  (cd .oh-my-zsh && ./oh-my-zsh.sh)
  echo "Cloning zsh config."
  cp -r .zsh* ~/.
}

function binary_prompt() {
  read -p "$1 [y/n]`echo $'\n> '`" read_value
  [[ $read_value =~ ^[Yy]$ ]] && return 1
  return 0
}

function configure_git() {  
  echo "Configuring  git."
  read -p "Name: " name  
  read -p "Email: " email
  read -p "Username: " username
  cat .gitconfig | sed -e "s/\${name}/$name/g ; s/\${email}/$email/g ; s/\${username}/$username/g" > ~/.gitconfig
  echo "Cloned git config."
}

function upgrade_packages() {
  echo "Upgrading packages."
  apt-get clean
  apt-get update
  sudo apt-get upgrade
}

function configure_vim() {
  echo "Configuring vim setup."
  cp -r .vim* ~/.
  echo "Finished cloning vim config."
  echo "rm -Rf ~/.vim/swaps/.* && rm -Rf ~/.vim/swaps/*" > ~/.local/bin/vimclean
}

function install_packages() {
  apt-get update
  apt-get install $(grep -vE "^\s*#" packages | tr "\n" " ")
}

function url_exists() {
  curl --head  https://raw.githubusercontent.com/github/gitignore/master/\$1.gitignore | head -n 1 | grep "HTTP/1.[01] [23].." > dev/null
  return $?
}

binary_prompt "Would you like to clean current config (WARNING: This will delete all related dotfiles and config for shell setup including you're global git config.)?" || rm -Rf .vim* .*rc .*profile .*logout .*history .gitconfig .gitignore

echo "Configuring linux environment..."

while true; do
  read -p "Preferred Shell`echo $'\n 1)'` bash`echo $'\n 2)'` zsh`echo $'\n 3)'` Skip`echo $'\n> '`"  PSHELL
  case $PSHELL in
    [1]* ) install_bash; break;;
    [2]* ) install_zsh; break;;
    [3]* ) break;;
    * ) echo "Please answer 1 or 2.";;
  esac
done

echo "Changed shell to $SHELL."
binary_prompt "Do you want to clone the tmux config?" || cp .tmux.conf ~/.
binary_prompt "Do you want to configure git?" || configure_git
[[ -d ~/.local/bin ]] || mkdir ~/.local/bin
[[ -d ~/.ssh ]] || mkdir ~/.ssh


echo "#!/bin/bash

function url_exists() {
  curl -sf --head  'https://raw.githubusercontent.com/github/gitignore/master/\$1.gitignore'| head -n 1 | grep 'HTTP/1.[01] [23]..' > /dev/null
  return \$?
}

if [ \$# -lt '1' ]; then
  echo 'Please supply a gitignore config name.'
  exit
fi
URL='https://raw.githubusercontent.com/github/gitignore/master/\$1.gitignore'
if [ \$# -lt "2" ]; then
   url_exists \$URL ||  curl -sf \$URL > .gitignore && echo 'Failed to pull template \$1 config.'
  exit
fi
url_exists \$URL ||  curl -sf \$URL > "$2" && echo 'Failed to pull template \$1 config.'
" > ~/.local/bin/gen-gitignore


echo "#!/bin/bash

function url_exists() {
  curl -sf --head  'https://raw.githubusercontent.com/github/gitignore/master/\$1.gitignore' | head -n 1 | grep 'HTTP/1.[01] [23]..' > /dev/null
  return \$?
}

if [ \$# -lt '1' ]; then
  echo 'Please supply a gitignore config name.'
  exit
fi
URL='https://raw.githubusercontent.com/github/gitignore/master/\$1.gitignore'
if [ \$# -lt '2' ]; then
   url_exists \$URL ||  curl -sf \$URL >> .gitignore && echo 'Failed to pull template \$1 config.'
  exit
fi
url_exists \$URL || curl -sf $URL >> "\$2" && echo 'Failed to pull template \$1 config.'
" > ~/.local/bin/append-gitignore

binary_prompt "Do you want to install recommended packages?" || install_packages
binary_prompt "Do you want to upgrade all packages?" || upgrade_packages
binary_prompt "Do you want to configure Vim and appropriate plugins?" || configure_vim
chmod 744 ~/.local/bin/*
