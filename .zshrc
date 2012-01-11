setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_ALLOW_CLOBBER 
setopt HIST_IGNORE_DUPS
setopt HIST_REDUCE_BLANKS
setopt EXTENDED_HISTORY   # puts timestamps in the history

setopt CORRECT            # command correction
setopt CORRECT_ALL        # correct all arguments in a line
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

# Autoload zsh modules when they are referenced
zmodload -a zsh/stat stat
autoload -U zcalc zmv
autoload -U compinit && compinit

setopt ALL_EXPORT         # export declared variables

HISTFILE=$HOME/.zhistory
HISTSIZE=1000
SAVEHIST=1000
HOSTNAME="`hostname`"
PAGER='less'
EDITOR='vim'
LC_ALL='en_US.UTF-8'
LANG='en_US.UTF-8'
LC_CTYPE=C
DISPLAY=:0

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
if [ -n `which git` ]; then
  parse_git_branch() {
    git branch --no-color 2> /dev/null |  sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
  }
fi

# prompt
#   - if the previous command returned nonzero, show that
#   - show the user name
#   - shows the git branch, if any
#   - shows the current directory
PS1='[\
%(0?.. $PR_RED%?$PR_NO_COLOR )\
$PR_CYAN%n$PR_NO_COLOR:\
$PR_GREEN$(parse_git_branch)$PR_NO_COLOR:\
$PR_BLUE%~$PR_NO_COLOR\
]%(!.#.$) '
RPS1='$PR_MAGENTA(%D{%b %d %H:%M})$PR_NO_COLOR'

unsetopt ALL_EXPORT

alias f=finger
alias grep='grep --color=auto'
alias j=jobs
alias ll='ls -al'
alias ls='ls -G'
alias man='LC_ALL=C LANG=C man'
alias vim='vim -O'

bindkey '^r' history-incremental-search-backward
bindkey "^[[5~" up-line-or-history
bindkey "^[[6~" down-line-or-history
bindkey "^[[H" beginning-of-line
bindkey "^[[1~" beginning-of-line
bindkey "^[[F"  end-of-line
bindkey "^[[4~" end-of-line
bindkey ' ' magic-space    # also do history expansion on space
bindkey '^I' complete-word # complete on tab, leave expansion to _expand

# Use the prefix of what you have typed already to search backwards when
# pressing up/down to navigate history
bindkey "\e[A" history-search-backward
bindkey "\e[B" history-search-forward

# map caps lock to escape - this will make you way more productive
# in VIM - but prevents you from using caps lock
#CAPS=`eval "xmodmap -pke | grep 'Caps'"`
#if [ -n "$CAPS" ]; then
#  xmodmap ~/.speedswapper
#fi

# completion wizardry
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' menu select=1 _complete _ignored _approximate
zstyle -e ':completion:*:approximate:*' max-errors \
    'reply=( $(( ($#PREFIX+$#SUFFIX)/2 )) numeric )'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*:processes' command 'ps -axw'
zstyle ':completion:*:processes-names' command 'ps -awxho command'

# Completion Styles
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
# list of completers to use
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate

# allow one error for every three characters typed in approximate completer
zstyle -e ':completion:*:approximate:*' max-errors \
    'reply=( $(( ($#PREFIX+$#SUFFIX)/2 )) numeric )'
    
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
