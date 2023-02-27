#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias HOME="cd"
alias DOCUMENTS="cd ~/Documents"
alias UPDATE=update_all
alias open=linux_open
alias autoremove=arch_autoremove
alias windowname=get_windowname

#function _update_ps1() {
#	PS1=$(powerline-shell $?)
#}

#if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then
#	PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
#fi

PS1='\W >> '

export PATH=/home/rob/.local/bin:/home/rob/bin:$PATH
export DOCKER_HOST=unix:///run/user/1000/docker.sock

export _JAVA_AWT_WM_NONREPARENTING=1

function update_all() {
	sudo pacman -Syu
	dotnet tool update -g amazon.lambda.tools
	pip3 install awscli --upgrade --user
	yay -Syu
}

function linux_open() {
	xdg-open $1
}

function arch_autoremove() {
	sudo pacman -R $(sudo pacman -Qdtq)
	yay -R $(yay -Qdtq)
}

function get_windowname() {
	echo "Click on the window you want"
	xprop | grep -i 'class'
}

source /usr/share/git/completion/git-completion.bash

figlet "Make cool shit..." | lolcat

