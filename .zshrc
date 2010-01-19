. /usr/libexec/mc/mc.sh
#export AWT_TOOLKIT=MToolkit
export LC_ALL="pl_PL.utf8"
###########################################################        
# Options for zsh

export HISTFILE=~/.zsh_history
export HISTSIZE=50000
export SAVEHIST=50000
#eval `dircolors -z` # This generates an error. Please see the discussion above.

## new style completion system
autoload -U compinit; compinit
# list of completers to use
zstyle ':completion:*' completer _complete _match _approximate
# allow approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
# selection prompt as menu
zstyle ':completion:*' menu select=1
# menuselection for pid completion
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:processes' command 'ps -au$USER'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;32'
# cd don't select parent dir
zstyle ':completion:*:cd:*' ignore-parents parent pwd
# complete with colors
zstyle ':completion:*' list-colors ''
# }}}


setopt autopushd pushdminus pushdsilent pushdtohome
setopt autocd
setopt cdablevars
setopt ignoreeof
setopt interactivecomments
setopt nobanghist
setopt noclobber
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt SH_WORD_SPLIT
setopt nohup
#Colors
#GREEN=`tput setaf 2`
#BRIGHTGREEN=`tput bold; tput setaf 2`
#YELLOW=`tput setaf 3`
#BRIGHTYELLOW=`tput bold; tput setaf 3`
#BLACK=`tput setaf 0`
#RED=`tput setaf 1`
#BRIGHTRED=`tput bold; tput setaf 1`
#BLUE=`tput setaf 4`
#MAGENTA=`tput setaf 5`
#CYAN=`tput setaf 6`
#WHITE=`tput bold; tput setaf 7`
#NORM=`tput sgr0`

# PS1 and PS2
#export PS1="$(print '%{\e[1;34m%}%n%{\e[0m%}'):$(print '%{\e[0;34m%}%~%{\e[0m%}')$ "
#export PS2="$(print '%{\e[0;34m%}>%{\e[0m%}')"
#prompt  adam2
#PS1="%{$BRIGHTYELLOW%}[%{$YELLOW%}%n]%{$BRIGHTGREEN%}::%{$BLUE%}[%{$BLUE%}%m]%{$NORM%}%~%(!.#.%{$CYAN%}<%{$GREEN%}*%{$CYAN%}> ) % %{$NORM%}"
#PS1='\[\033[1;36m\]\t \[\033[1;37m\]\u\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\ '

#PS1="[$BLUE%n$WHITE@$GREEN%U%m%u$NORM:$RED %2c$NORM]%(!.#.$) "
#RPS1="$PR_LIGHT_YELLOW(%D{%d-%m %H:%M})$PR_NO_COLOR"

#To odkomentowac
#autoload colors zsh/terminfo
#    if [[ "$terminfo[colors]" -ge 8 ]]; then
#   colors
#    fi
#    for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
#   eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
#   eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
#   (( count = $count + 1 ))
#    done
#    PR_NO_COLOR="%{$terminfo[sgr0]%}"
#PS1="[$PR_BLUE%n$PR_WHITE@$PR_GREEN%U%m%u$PR_NO_COLOR:$PR_RED%2c$PR_NO_COLOR]%(!.#.$) "
#RPS1="$PR_LIGHT_YELLOW(%D{%d-%m %H:%M})$PR_NO_COLOR"

# Prompt gentoo
autoload -U compinit promptinit
compinit
promptinit; prompt gentoo
setopt autocd

# Vars used later on by zsh
export EDITOR="vim"
export BROWSER=elinks
export XTERM="urxvt"

##################################################################
##################################################################
# Stuff to make my life easier
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
# allow approximate
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
eval $(dircolors)
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# tab completion for PID :D
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

# cd not select parent dir. 
zstyle ':completion:*:cd:*' ignore-parents parent pwd

##################################################################
##################################################################
# Key bindings
# http://mundy.yazzy.org/unix/zsh.php
# http://www.zsh.org/mla/users/2000/msg00727.html

typeset -g -A key
bindkey '^?' backward-delete-char
bindkey '^[[1~' beginning-of-line
bindkey '^[[5~' up-line-or-history
bindkey '^[[3~' delete-char
bindkey '^[[4~' end-of-line
bindkey '^[[6~' down-line-or-history
bindkey '^[[A' up-line-or-search
bindkey '^[[D' backward-char
bindkey '^[[B' down-line-or-search
bindkey '^[[C' forward-char 

##################################################################
# My aliases

# Set up auto extension stuff
alias -s html=$BROWSER
alias -s org=$BROWSER
alias -s php=$BROWSER
alias -s com=$BROWSER
alias -s net=$BROWSER
alias -s png=display
alias -s jpg=display
alias -s gif=display
alias -s sxw=soffice
alias -s doc=soffice
alias -s gz=tar -xzvf
alias -s bz2=tar -xjvf
alias -s java=$EDITOR
alias -s txt=$EDITOR
alias -s PKGBUILD=$EDITOR
# ssh aliases
alias ssh1='ssh1 '
alias ssh2='ssh2'
alias ssh_repo='2'
# Normal aliases
alias ls='ls --color=auto -F'
alias lsd='ls -ld *(-/DN)'
alias lsa='ls -ld .*'
alias f='find |grep'
alias c="clear"
alias dir='ls -1'
#alias vim='vim -geom 82x35'
#alias mc="mc -b; clear"
alias ..='cd ..'
alias hist="grep '$1' /home/dziq/.zsh_history"
#alias irssi="irssi -c irc.freenode.net -n yyz"
#alias sc="LANG=pl_PL.ISO-8859-2 screen"
alias mem="free -m"
alias iso="mkisofs -r -J -D -o"
##Arch specific
#alias tu="tupac"
#alias pa="sudo pacman"
#alias po="sudo powerpill"
#alias jo="yaourt"
alias mocp="mocp -T T"
alias ll='ls -lh --color=auto'
alias du="du -h"
alias DU="du -sh *"
alias rapid="aria2c -s4 --http-user=juzer --http-passwd=pass"
# command L equivalent to command |less
alias -g L='|less' 

# command S equivalent to command &> /dev/null &
alias -g S='&> /dev/null &'

# type a directory's name to cd to it.
compctl -/ cd



#extra
extract () {
     if [ -f $1 ] ; then
         case $1 in
             *.tar.bz2)   tar xjf $1        ;;
             *.tar.gz)    tar xzf $1     ;;
             *.bz2)       bunzip2 $1       ;;
             *.rar)       unrar x $1     ;;
             *.gz)        gunzip $1     ;;
             *.tar)       tar xf $1        ;;
             *.tbz2)      tar xjf $1      ;;
             *.tgz)       tar xzf $1       ;;
             *.zip)       unzip $1     ;;
             *.Z)         uncompress $1  ;;
             *.7z)        7z x $1    ;;
             *)           echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

#myip - finds your current IP if your connected to the internet
myip ()
{
lynx -dump -hiddenlinks=ignore -nolist http://checkip.dyndns.org:8245/ | awk '{ print $4 }' | sed '/^$/d; s/^[ ]*//g; s/[ ]*$//g' 
}

#netinfo - shows network information for your system
netinfo ()
{
echo "--------------- Network Information ---------------"
/sbin/ifconfig | awk /'inet addr/ {print $2}'
/sbin/ifconfig | awk /'Bcast/ {print $3}'
/sbin/ifconfig | awk /'inet addr/ {print $4}'
/sbin/ifconfig | awk /'HWaddr/ {print $4,$5}'
myip=`lynx -dump -hiddenlinks=ignore -nolist http://checkip.dyndns.org:8245/ | sed '/^$/d; s/^[ ]*//g; s/[ ]*$//g' `
echo "${myip}"
echo "---------------------------------------------------"
}

#clock - A bash clock that can run in your terminal window.
clock ()
{
while true;do clear;echo "===========";date +"%r";echo "===========";sleep 1;done
}

#shot - takes a screenshot of your current window
shot ()
{
import -frame -strip -quality 75 "$HOME/$(date +%s).png"
}

#bu - Back Up a file. Usage "bu filename.txt" 
bu () { cp $1 ${1}-`date +%Y%m%d%H%M`.backup ; }

export OOO_FORCE_DESKTOP=gnome soffice
export MOZ_DISABLE_PANGO=1
