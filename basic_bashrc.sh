# Only configure interactive shells.
case $- in
    *i*) ;;
    *) return ;;
esac

# Keep Fedora's normal interactive shell defaults.
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

alias rm='rm -I --preserve-root=all'
alias cp='cp -iv'
alias mv='mv -iv'
alias ll='ls -alh --color=auto'

shopt -s failglob

shopt -s checkjobs

HISTSIZE=10000
HISTFILESIZE=80000

shopt -s histappend

export EDITOR=vim


eval "$(starship init bash)"
