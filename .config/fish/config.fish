# Bat Configuration
set -x BAT_THEME "Dracula"
set -x MANPAGER "sh -c 'bat -l man -p'" # use bat to format man pages

# Path
# set -x PATH $PATH /usr/local/opt/ruby/bin /usr/local/lib/ruby/gems/2.6.0/bin
set -x PATH $PATH /home/folke/go/bin
set -x PATH $PATH /home/folke/bin
set -x PATH $PATH /home/folke/.cargo/bin
set -x PATH $PATH /home/folke/.local/bin
set -x PATH $PATH ~/.config/scripts
set -x PATH /usr/local/sbin $PATH
set -x PATH /home/folke/.pnpm-global/bin $PATH

# Tmux
abbr ta 'tmux attach -t'
abbr tad 'tmux attach -d -t'
abbr ts 'tmux new-session -s'
abbr tl 'tmux list-sessions'
abbr tksv 'tmux kill-server'
abbr tkss 'tmux kill-session -t'
abbr mux 'tmuxinator'
abbr suod sudo

# Changing Directories
alias ls="ls --group-directories-first --color=always"
alias grep 'grep --color'
alias la 'exa --all --icons --group-directories-first'
alias ll 'exa --all --icons --group-directories-first --long'
abbr l 'll'

# Editor
abbr vim 'nvim'
abbr vi 'nvim'
set -x EDITOR nvim

# Dev
abbr git 'hub'
abbr g 'git'
abbr gl 'git l --color | devmoji --log --color | less -rXF'
abbr push "git push"
abbr pull "git pull"
alias dot 'git --git-dir=$HOME/.dot --work-tree=$HOME'
abbr tn "npx --no-install ts-node --transpile-only"
abbr tt "tn src/tt.ts"
abbr code "code-insiders"
abbr todo "ag --color-line-number '1;36' --color-path '1;36' --print-long-lines --silent '((//|#|<!--|;|/\*|^)\s*(TODO|FIXME|FIX|BUG|UGLY|HACK|NOTE|IDEA|REVIEW|DEBUG|OPTIMIZE)|^\s*- \[ \])'"
abbr ntop "ultra --monitor"

abbr helpme "bat ~/HELP.md"
abbr weather "curl -s wttr.in/Ghent | grep -v Follow"

# Github Completions
# gh completion -s fish | source

# Fedora
abbr dnfs "sudo dnf search"
abbr dnfi "sudo dnf install"
abbr dnfu "sudo dnf update --refresh"

# Navi
navi widget fish | source

# Update
function update -d "Update homebrew, fish, pnpm"
  echo "[update] Fedora"
  sudo dnf upgrade

  echo "[update] nodejs"
  pnpm update -g

  echo "[update] tldr"
  tldr -u

  echo "[update] fish"
  fisher self-update
  fisher
  fish_update_completions
end

abbr system "neofetch --source ~/Pictures/Cyberpunk/connected-wallpaper-1920x1080.jpg"

function corona
  tput civis
  while true
    set stats (curl "https://corona-stats.online/Belgium?source=2" --silent | head -n 7)
    clear
    for line in $stats
      echo $line
    end
    tput cuu1
    sleep 30
  end
end

function fixwifi
  sudo modprobe -r brcmfmac
  and sudo modprobe brcmfmac rambase_addr=0x160000
  and sudo systemctl restart NetworkManager
end

function audio-headphones
  pacmd set-card-profile (pacmd list-cards | grep -B6 'alsa.card_name = "Apple T2 Audio"' | head -n1 | cut -d':' -f 2) output:codec-output+input:codec-input
end

function audio-speakers
  pacmd set-card-profile (pacmd list-cards | grep -B6 'alsa.card_name = "Apple T2 Audio"' | head -n1 | cut -d':' -f 2) output:builtin-speaker+input:builtin-mic
end

abbr show-cursor "tput cnorm"
abbr hide-cursor "tput civis"

set -g fish_emoji_width 2

# Dracula Theme
if test -e ~/.config/fish/functions/dracula.fish
  builtin source ~/.config/fish/functions/dracula.fish
end

. ~/.cache/wal/colors.fish

function sudo
    if functions -q $argv[1]
        set argv fish -c "$argv"
    end
    command sudo $argv
end

function polybar-theme
  exit
  set theme ~/projects/polybar-themes/polybar-$argv[1]
  echo "[theme] $theme"
  rm -rf ~/.config/polybar/*
  cp -rva $theme/fonts/* ~/.local/share/fonts/
  fc-cache -v
  cp -rva $theme/* ~/.config/polybar/
  sh ~/.config/polybar/launch.sh
end

function wunsplash
  set keywords (echo -s ,$argv | cut -b 2-)
  set wal (echo ~/.cache/unsplash/(date +"%Y-%m-%d_%H:%M:%S")-$keywords.jpg)
  notify-send "Wal Unsplash" "Downloading image for $keywords" 
  curl "https://source.unsplash.com/featured/2560x1600/?$keywords" -L -s -o $wal
  or exit 1
  mywal -i "$wal"
  notify-send "Wal Unsplash" "Done!" 
end

function brightness
  echo $argv[1] | sudo tee /sys/class/backlight/acpi_video0/brightness
end

# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/fish/__tabtab.fish ]; and . ~/.config/tabtab/fish/__tabtab.fish; or true

starship init fish | source

# fnm
set PATH /home/folke/.fnm $PATH
fnm env --multi | source
