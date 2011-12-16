# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

PAGER=less
EDITOR=vim
PATH=~/bin:$PATH
export PYTHONPATH=~/dev/py:$PYTHONPATH

# Finished adapting your PATH environment variable for use with MacPorts.
# don't put duplicate lines in the history.
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000

# Prevent accidentally overwriting files when piping output
# echo hello >out.txt will fail if out.txt already exists
set -o noclobber

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

if [ -n `which git` ]; then
# Sometimes __git_ps1 is unavailable, so roll our own
  parse_git_branch() {
    git branch 2> /dev/null |  sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
  }

# make prompt show current git branch
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]$(parse_git_branch "%s")\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
fi

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    export PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias j=jobs

# if vim opens more than one file, vsplit them
alias vim='vim -O'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# map caps lock to escape - this will make you way more productive
# in VIM - but prevents you from using caps lock
#CAPS=`eval "xmodmap -pke | grep 'Caps'"`
#if [ -n "$CAPS" ]; then
#  xmodmap ~/.speedswapper
#fi

# PATH for MacPorts
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
