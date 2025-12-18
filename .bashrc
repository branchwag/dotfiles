# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/whiterabbit/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/whiterabbit/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/whiterabbit/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/whiterabbit/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

. "$HOME/.cargo/env"
export PATH="$HOME/.npm-global/bin:$PATH"
source /usr/share/nvm/init-nvm.sh


export PATH="$HOME/.local/bin:$PATH"


# Having nvim as default editor
export EDITOR=nvim
# test
