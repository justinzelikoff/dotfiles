# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH


export ZSH="$HOME/.oh-my-zsh"

#ZSH_THEME=""

plugins=(
    git
    archlinux
    zsh-autosuggestions
    zsh-autocomplete
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Check archlinux plugin commands here
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/archlinux

# fastfetch. Will be disabled if above colorscript was chosen to install
#fastfetch -c $HOME/.config/fastfetch/config-compact.jsonc

# Set-up icons for files/directories in terminal using lsd
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

# Alias for syncing codex branch for one-click-cma-site
alias git-codex-sync='
  git fetch origin &&
  git checkout main &&
  git pull origin main &&
  (git checkout codex || git checkout -b codex origin/codex) &&
  git reset --hard main &&
  git push --force-with-lease origin codex
'

# Set-up FZF key bindings (CTRL R for fuzzy history finder)
source <(fzf --zsh)

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

#update alias
alias update="sudo -v && echo -e '\033[1;34m:: Updating Flatpak packages...\033[0m' && flatpak update -y && echo -e '\n\033[1;34m:: Updating Docker stack...\033[0m' && docker compose -f /opt/docker-apps/docker-compose.yml pull && docker compose -f /opt/docker-apps/docker-compose.yml up -d && docker image prune -f && echo -e '\n\033[1;34m:: Updating system and AUR packages...\033[0m' && yay -Syu"

#Starship
eval "$(starship init zsh)"

# Random wallpaper change alias
alias wallpaper="$HOME/.local/bin/set-random-wallpaper.sh"

# Redirect vi and vim to launch neovim
alias vi='nvim'
alias vim='nvim'

# Tell system tools to use Neovim as defualt editor
export EDITOR='nvim'
export VISUAL='nvim'

fastfetch

#autoclick function
click() {
    # Strips the '--' from the argument (e.g., --754 becomes 754)
    local count="${1#--}"

    # Safety check: Validate that the input is a clean number
    if [[ -z "$count" || ! "$count" =~ ^[0-9]+$ ]]; then
        echo "Error: Please provide a number. Example: click --754"
        return 1
    fi

    echo "Starting $count clicks in 5 seconds... Position your mouse!"
    sleep 5
    
    # Efficient native Zsh loop structure
    for ((i=1; i<=count; i++)); do
        ydotool click 0xC0
        echo "Click $i/$count"
        sleep 0.1
    done
    
    echo "Campaign complete! Done."
}

export PATH="$HOME/.cargo/bin:$PATH"
