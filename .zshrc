#!/bin/zsh

setopt NO_BEEP
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_ALLOW_CLOBBER
setopt HIST_IGNORE_DUPS
setopt HIST_REDUCE_BLANKS
setopt EXTENDED_HISTORY   # puts timestamps in the history

setopt NOCORRECT            # command correction
setopt NOCORRECT_ALL        # correct all arguments in a line
setopt AUTO_LIST          # list menu on ambiguous expansion
setopt REC_EXACT          # recognize exact matches, even if ambiguous

setopt AUTO_PUSHD         # every cd is like a pushd
setopt PUSHD_TO_HOME      # pushd with no args defaults to home
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT       # don't print pushd stack
setopt AUTO_CD            # if first argument is a directory and not a command,
                          # cd into it

setopt GLOB_DOTS          # dot files show up in * expansion
setopt EXTENDED_GLOB      # can use #, ~, ^ in filename patterns
setopt RC_QUOTES          # use '' in single-quoted strings for '

setopt NO_BG_NICE         # don't nice bg commands
setopt LONG_LIST_JOBS     # list jobs in long format in completion
setopt NOTIFY             # notify status of bg jobs immediately

setopt IGNORE_EOF         # EOF does not close shell
setopt PROMPT_SUBST       # allows executing functions in prompt
setopt NOCLOBBER          # can't clobber existing files
setopt MULTIOS            # allows multiple redirection of output
setopt CDABLE_VARS        # if var holds a directory, then cd var works

# Enables Ctrl-S for forward history search
stty -ixon

# Autoload zsh modules when they are referenced
zmodload -a zsh/stat stat
autoload -Uz zcalc zmv
autoload -Uz compinit && compinit

setopt ALL_EXPORT         # export declared variables

HISTFILE=$HOME/.zhistory
HISTSIZE=100000
SAVEHIST=100000
HOSTNAME="$(hostname)"
PAGER='less'
EDITOR='vim'
LC_ALL='en_US.UTF-8'
LANG='en_US.UTF-8'
LANGUAGE='en_US.UTF-8'
LC_CTYPE=C
DISPLAY=:0

# better which
bwhich() {
  if [ -n "$(alias $1)" ]; then
    whence -ca $1
  else
    whence -c $1
  fi
}
alias which='bwhich'

# blame
gbp() {
  FILE="$(pop $1)"
  git blame $FILE
}

# colors
autoload colors zsh/terminfo
if [[ "$terminfo[colors]" -ge 8 ]]; then
  colors
fi
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
  eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
  eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
done
PR_NO_COLOR="%{$terminfo[sgr0]%}"

# get the git branch
parse_git_branch() {
  if [ -n "$(which git)" ]; then
    git branch --no-color 2> /dev/null |  sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
  else
    echo ''
  fi
}
print_git_branch() {
  RET="$(parse_git_branch)"
  if [ -n "$RET" ]; then
    echo "$PR_GREEN$RET$PR_NO_COLOR:"
  else
    echo "$PR_NO_COLOR"
  fi
}

prompt_hostname() {
  if [ -n "${SSH_CONNECTION}" ]; then
    echo '$PR_NO_COLOR@$PR_WHITE%m'
  else
    echo ''
  fi
}

# prompt
#   - if the previous command returned nonzero, show that
#   - show the user name @ hostname
#   - shows the git branch, if any
#   - shows the current directory
#   - warns me with red text if running as root
PS1='['
PS1+='%(0?.. $PR_RED%?$PR_NO_COLOR )'
# PS1+='%(!.$PR_RED.$PR_BLUE)%n$(prompt_hostname)$PR_NO_COLOR:'
PS1+='$(print_git_branch)'
PS1+='$PR_CYAN%~$PR_NO_COLOR'
PS1+='] '
RPS1='$PR_MAGENTA(%D{%b %d %H:%M})$PR_NO_COLOR'

unsetopt ALL_EXPORT

alias gg="git grep"
#function gg {
  #git submodule foreach "git grep \"$@\"; true"
  #git grep $@
  #true
#}

alias codemod='codemod -a -g'
alias ff='find . | xargs grep 2>/dev/null'
alias gcaa='git ci -a --amend -C HEAD'
alias glm='git l --author patrick'
alias grep='grep --color=auto'
alias j=jobs
alias man='LC_ALL=C LANG=C man'
alias mkdir='mkdir -p'
alias shorten="shorten $BIN_HOME/private/shorten_credentials"
alias vim='vim -O'
alias vit='vim -t'

# colorizing ls output is different on different platforms
ls --color=auto >/dev/null 2>/dev/null
if [ "$?" -eq 0 ]; then
  alias ls='ls --color=auto'
  alias ll='ls --color=auto -Alh'
  # Generated from 'dircolors -b .dircolors'
  export LS_COLORS='no=00:fi=00:di=00;34:ln=00;36:or=07;31:mi=07;31:pi=00;35:so=00;35:do=00;35:bd=00;35:cd=00;35:ex=00;31:'
else
  alias ls='ls -G'
  alias ll='ls -G -Alh'
  export LSCOLORS='exgxfxfxbxfxfxababacac'
fi

# pyenv
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then source /usr/local/bin/virtualenvwrapper.sh; fi

# ctrl-z toggles vim
fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

bindkey '^r' history-incremental-search-backward
bindkey "^[[5~" up-line-or-history
bindkey "^[[6~" down-line-or-history
bindkey ' ' magic-space    # also do history expansion on space

# Use the prefix of what you have typed already to search backwards when
# pressing up/down to navigate history
bindkey "\e[A" history-search-backward
bindkey "\e[B" history-search-forward

# completion wizardry
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' menu select=1 _complete _ignored _approximate
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*:processes' command 'ps -axw'
zstyle ':completion:*:processes-names' command 'ps -awxho command'

# Completion Styles
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
# list of completers to use
zstyle ':completion:*::::' completer _expand _complete _ignored #_approximate

# allow one error for every three characters typed in approximate completer
  # this is so annoying
#zstyle -e ':completion:*:approximate:*' max-errors \
#    'reply=( $(( ($#PREFIX+$#SUFFIX)/2 )) numeric )'

# insert all expansions for expand completer
zstyle ':completion:*:expand:*' tag-order all-expansions

#NEW completion:
# 1. All /etc/hosts hostnames are in autocomplete
# 2. If you have a comment in /etc/hosts like #%foobar.domain,
#    then foobar.domain will show up in autocomplete!
zstyle ':completion:*' hosts $(awk '/^[^#]/ {print $2 $3" "$4" "$5}' /etc/hosts | grep -v ip6- && grep "^#%" /etc/hosts | awk -F% '{print $2}')
# formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''

# match uppercase from lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# command for process lists, the local web server details and host completion
zstyle '*' hosts $hosts

# Filename suffixes to ignore during completion (except after rm command)
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~' \
    '*?.old' '*?.pro'

# ignore completion functions (until the _ignored completer)
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*:scp:*' tag-order \
   files users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:scp:*' group-order \
   files all-files users hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' tag-order \
   users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:ssh:*' group-order \
   hosts-domain hosts-host users hosts-ipaddr
zstyle '*' single-ignored show

# Plugins
source $HOME/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
