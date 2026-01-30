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

# Prevent accidental history navigation on scroll
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# SSH agent for Hyprland - reuse existing agent
if [ "$XDG_CURRENT_DESKTOP" = "Hyprland" ]; then
    SSH_AGENT_FILE="$HOME/.ssh/ssh-agent-env"
    
    # Check if agent is already running
    if [ -f "$SSH_AGENT_FILE" ]; then
        source "$SSH_AGENT_FILE" > /dev/null
    fi
    
    # Test if agent is responsive
    if ! ssh-add -l &>/dev/null; then
        # Start new agent if not running
        eval "$(ssh-agent -s)" > /dev/null
        echo "export SSH_AUTH_SOCK=$SSH_AUTH_SOCK" > "$SSH_AGENT_FILE"
        echo "export SSH_AGENT_PID=$SSH_AGENT_PID" >> "$SSH_AGENT_FILE"
        # Add key only once
        ssh-add ~/.ssh/id_ed25519 2>/dev/null
    fi
fi
