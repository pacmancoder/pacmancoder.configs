export PATH=$HOME/bin:/usr/local/bin:$HOME/core/scripts:$PATH
export ZSH=/home/sauron/.oh-my-zsh

# force set cyrilic font in tty
tty | grep "/dev/tty[0-9]" && setfont cyr-sun16

ZSH_THEME="agnoster"
plugins=(git)

source $ZSH/oh-my-zsh.sh
