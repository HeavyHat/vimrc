#!/bin/bash

echo "Running .bash_profile"

if [[ -z $TMUX ]]; then
    tmux 
fi

#   Change Prompt
#   ------------------------------------------------------------

export PS2="| => "
export TERM=xterm-256color

# Aliases

# Color LS
colorflag="--color=auto"
alias ls="command ls ${colorflag}"
alias l="ls -lF ${colorflag}" # all files, in long format
alias la="ls -laF ${colorflag}" # all files inc dotfiles, in long format
alias lsd='ls -lF ${colorflag} | grep "^d"' # only directories

# Quicker navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias refresh="source ~/.bash_profile"
alias eclipse_wizard="~/scripts/eclipse_wizard.py"
alias vi="vim"

### Prompt Colors
# Modified version of @gf3’s Sexy Bash Prompt
# (https://github.com/gf3/dotfiles)
if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
    export TERM=gnome-256color
elif infocmp screen-256color >/dev/null 2>&1; then
    export TERM=screen-256color
fi

if tput setaf 1 &> /dev/null; then
    tput sgr0
    if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
        MAGENTA=$(tput setaf 9)
        ORANGE=$(tput setaf 172)
        GREEN=$(tput setaf 190)
        PURPLE=$(tput setaf 141)
    else
        MAGENTA=$(tput setaf 5)
        ORANGE=$(tput setaf 4)
        GREEN=$(tput setaf 2)
        PURPLE=$(tput setaf 1)
    fi
    BOLD=$(tput bold)
    RESET=$(tput sgr0)
else
    MAGENTA="\033[1;31m"
    ORANGE="\033[1;33m"
    GREEN="\033[1;32m"
    PURPLE="\033[1;35m"
    BOLD=""
    RESET="\033[m"
fi

export MAGENTA
export ORANGE
export GREEN
export PURPLE
export BOLD
export RESET


# Git branch details
function parse_git_dirty() {
    [[ $(git status 2> /dev/null | tail -n1) != *"working directory clean"* ]] && echo "*"
}
function parse_git_branch() {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)$(parse_merging)/" -e "s/.*/\[&\]/"  
}
function parse_merging() {
    git merge HEAD &> /dev/null
    result=$?
    if [ $result -ne 0 ]
    then
        echo -n "|MERGING"
    else
        echo -n ""
    fi
}


# Change this symbol to something sweet.
export PS1="[\[${GREEN}\]\u@\[${MAGENTA}\]\H \[$RESET\] \[$GREEN\]\w\[$RESET\]\$([[ -n \$(git branch 2> /dev/null) ]] && echo \" \")\[$PURPLE\]\$(parse_git_branch)\[$RESET\]] "
export PS2="\[$ORANGE\]→ \[$RESET\]"


### Misc

# Only show the current directory's name in the tab
export PROMPT_COMMAND='echo -ne "\033]0;${PWD##*/}\007"'
if [ ! -d ~/tmp ]; then
    mkdir ~/tmp
fi
rm -Rf ~/tmp/*

eval $(ssh-agent -s)
ssh-add ~/.ssh/id_rsa

clear

