#!/bin/zsh
# OPTIONS
setopt sh_word_split # Do not quote expanded vars
#setopt transient_rprompt # Delete previous Rprompt when prompting

function precmd {
    local TERMWIDTH
    (( TERMWIDTH = ${COLUMNS} - 4))
    ###
    # Truncate the path if it's too long.
    PR_FILLBAR=""
    PR_PWDLEN=""

    local promptsize=${#${(%):---(%n@%m:%l)---()--}}
    local pwdsize=${#${(%):-%~}}

    if [[ "$promptsize + $pwdsize" -gt $TERMWIDTH ]]; then
	((PR_PWDLEN=$TERMWIDTH - $promptsize))
    else
	PR_FILLBAR="\${(l.(($TERMWIDTH - ($promptsize + $pwdsize)))..${PR_HBAR}.)}"
    fi
}

setopt extended_glob
preexec () {
    if [[ "$TERM" == "screen" ]]; then
	local CMD=${1[(wr)^(*=*|sudo|-*)]}
	echo -n "\ek$CMD\e\\"
    fi
}

setprompt () {
    ###
    # Need this so the prompt will work.

    setopt prompt_subst


    ###
    # See if we can use colors.

    autoload colors zsh/terminfo
    colors
    for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
	eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
	eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
	(( count = $count + 1 ))
    done
    PR_NO_COLOUR="%{$terminfo[sgr0]%}"

    red="%{[33;01;31m%}"
    green="%{[33;01;32m%}"
    blue="%{[33;01;36m%}"
    yellow="%{[33;01;33m%}"
    purple="%{[33;01;34m%}"

    lred="%{[33;01;31m%}"
    lgreen="%{[33;01;32m%}"
    lblue="%{[33;01;36m%}"
    lyellow="%{[33;01;33m%}"
    lpurple="%{[33;01;34m%}"

    white="%{[0m%}"




    ###
    # See if we can use extended characters to look nicer.

    typeset -A altchar
    set -A altchar ${(s..)terminfo[acsc]}

# french charset
    export LESSCHARSET="utf-8"

# customize time builtin

    TIMEFMT="time: %*E real  %*U user  %*S system (%P)"

# bindings

    bindkey '[H' beginning-of-line
    bindkey '[F' end-of-line
    bindkey '[3~' delete-char             # Del
    bindkey '[2~' overwrite-mode          # Insert
    bindkey '[5~' history-search-backward # PgUp
    bindkey '[6~' history-search-forward  # PgDn

# ALIASES

    LSOPTS="--tabsize=0 --literal --color --show-control-chars --human-readable"


    PR_SET_CHARSET="%{$terminfo[enacs]%}"
    PR_SHIFT_IN=''
#"%{$terminfo[smacs]%}"
    PR_SHIFT_OUT=''
#"%{$terminfo[rmacs]%}"
    PR_HBAR='-'
#${altchar[q]:--}
    PR_ULCORNER='+'
#${altchar[l]:--}
    PR_LLCORNER='+'
#${altchar[m]:--}
    PR_LRCORNER='+'
#${altchar[j]:--}
    PR_URCORNER='+'
#${altchar[k]:--}


    ###
    # Decide if we need to set titlebar text.

    case $TERM in
	xterm*)
	    PR_TITLEBAR=$'%{\e]0;%(!.-=*[ROOT]*=- | .)%n@%m:%~ | ${COLUMNS}x${LINES} | %y\a%}'
	    ;;
	screen)
	    PR_TITLEBAR=$'%{\e_screen \005 (\005t) | %(!.-=[ROOT]=- | .)%n@%m:%~ | ${COLUMNS}x${LINES} | %y\e\\%}'
	    ;;
	*)
	    PR_TITLEBAR=''
	    ;;
    esac


    ###
    # Decide whether to set a screen title
    if [[ "$TERM" == "screen" ]]; then
	PR_STITLE=$'%{\ekzsh\e\\%}'
    else
	PR_STITLE=''
    fi


    ###
    # Finally, the prompt.
    PROMPT="$yellow%D{%H:%M}$white - Logged as $lgreen$USER$white on $red$HOST$white $lpurple%~$white
$red%?$white$lblue > $white"

    RPROMPT="$lpurple($lyellow%D{%a%d %b}$lpurple)$white"

    PS2='$lpurple$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$lblue$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT(\
$lgreen%_$lblue)$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$lpurple$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT$lblue '
}

# PATH

export PATH="$HOME/local/bin:/usr/local/sbin:/usr/local/bin:$PATH:/sbin"

# HISTORY

HISTSIZE=5000
HISTFILE=~/conf/zsh/.zsh_history
SAVEHIST=5000

# CUSTOM WIDGETS

show-man ()
{
  man ${BUFFER%% *} 2> /dev/null;
}

my-accept-line ()
{

    targets="eclipse vim emacs firefox xpdf evince thunderbird"
    # FIXME: Do not disown in text mode!
    if ! (echo "$BUFFER" | grep -q '&!$'); then
        for p in $targets; do
            if echo "$BUFFER" | grep -q "^$p\b"; then
                BUFFER="$BUFFER&!"
                break
            fi
        done
    fi
    zle accept-line
}

zle -N my-accept-line
zle -N show-man # opens the man of the current command

bindkey "" my-accept-line

# COMPLETION

autoload -U compinit
compinit

# ENVIRONMENT

#export EDITOR='emacs -nw' # Or anything else
export EDITOR='vim'
export NAME='Berenguer Christophe'
export FULLNAME='Berenguer Christophe'
export EMAIL='bereng_c@yaka.epita.fr'
export REPLYTO=$EMAIL
#export MALLOC_OPTIONS=J # Mandatory
export CONFIG_SITE=path_to_the_config_site

# LOCALS

local=~/".zshrc.local"
[ -r "$local" ] && source "$local"
true

setprompt

# XSET

{
xset -b
xset b off # Better without beep
xset r rate 300 100 # Shell cursor speed
} 2> /dev/null
# EXPORT

export CLICOLOR=xterm-color

export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.rar=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35::*README=1;33:*TODO=33:*ChangeLog=33:*AUTHORS=33:*CONTRIBUTORS=33:*LICENSE=33:*PKG-INFO=33:*NEWS=33:*COPYING=33:*COPYRIGHT=33:*Makefile=95:*.o=36:*.h=33:*.c=93:*.hh=33:*.cc=93:*.hxx=93:*.tar=96:*.gz=96:*.bz2=96:*.tbz=96:*.tgz=96:*.7z=96'

#export LS_COLORS='di=1;34:ln=4;34:ex=91:*=36:*README=1;33:*TODO=33:*ChangeLog=33:*AUTHORS=33:*CONTRIBUTORS=33:*LICENSE=33:*PKG-INFO=33:*NEWS=33:*COPYING=33:*COPYRIGHT=33:*Makefile=95:*.o=36:*.h=33:*.c=93:*.\
#hh=33:*.cc=93:*.hxx=93:*.tar=96:*.gz=96:*.bz2=96:*.tbz=96:*.tgz=96:*.7z=96'

export LS_OPTIONS='-Fh --color=auto'

# ALIAS LS

alias ls="ls $LS_OPTIONS"
alias ll='ls -l'
alias l='ls -l'
alias la='ls -la'
alias rm='rm -i'
alias rmf='rm -rf'

# PERSO
[[ $EMACS = t ]] && export LS_OPTIONS='-Fh'

# Source the conf file
alias reload="source ~/.zshrc"
NNTPSERVER='news.epita.fr' && export NNTPSERVER
export PAGER=most
clone (){
    echo $1
    hg clone https://forge.acu.epita.fr/projects/$1
}
export http_proxy=
