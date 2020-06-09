# Bat Configuration
set -x BAT_THEME "Dracula"
# set -x MANROFFOPT "-c"
# set -x MANPAGER "sh -c 'col -bx | bat -l man -p'" # use bat to format man pages
set -x MANPAGER "most" # use bat to format man pages
set -x MANPAGER "nvim -u NORC +Man!"

# Path
# set -x PATH $PATH /usr/local/opt/ruby/bin /usr/local/lib/ruby/gems/2.6.0/bin
set -x PATH $PATH ~/go/bin
set -x PATH $PATH ~/bin
set -x PATH $PATH ~/.cargo/bin
set -x PATH $PATH ~/.local/bin
set -x PATH $PATH ~/.config/folke/bin
set -x PATH $PATH ~/.config/scripts/bin
set -x PATH /usr/local/sbin $PATH
set -x PATH ~/.pnpm-global/bin $PATH

if test -n "$DESKTOP_SESSION"
    set (gnome-keyring-daemon --start | string split "=")
end

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
alias dot 'hub --git-dir=$HOME/.dot --work-tree=$HOME'
alias tn "npx --no-install ts-node --transpile-only"
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
    sudo dnf upgrade --refresh

    echo "[fix] Brave"
    fix-brave

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

function dot.untracked
    dot ls-files -t --other --exclude-standard $argv[1]
end


function dot.all
    dot status -s -unormal
end

function dot.status
    dot status -s ~
    for d in ~/.config/*
        if dot ls-files --error-unmatch $d &>/dev/null
            dot.untracked $d
        end
    end
    dot.untracked ~/.SpaceVim.d/
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

if test -e ~/.cache/wal/colors.fish
    builtin source ~/.cache/wal/colors.fish
end

function sudo
    if functions -q $argv[1]
        set argv fish -c "$argv"
    end
    command sudo $argv
end

function fix-brave
    set regex "/brave-browser --password-store/! s/brave-browser /brave-browser --password-store=gnome /"
    for desktop in Desktop/brave*.desktop .local/share/applications/*.desktop
        set tmpfile (mktemp /tmp/fix-brave.XXXXXX)
        sed "$regex" "$desktop" >$tmpfile
        cmp --silent "$desktop" "$tmpfile" >/dev/null
        or begin
            echo "[brave:fix] $desktop"
            cat "$tmpfile" >"$desktop"
        end
        rm "$tmpfile"
    end
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

function color-test
    set scripts square crunch panes hex-block alpha spectrum unowns.py zwaves space-invaders
    set script "$HOME/projects/color-scripts/color-scripts/"(random choice $scripts)
    $script
end

function fish_greeting
    color-test
end

abbr coredump-last "coredumpctl gdb (coredumpctl list | tail -1 | awk '{print \$5}')"

# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/fish/__tabtab.fish ]; and . ~/.config/tabtab/fish/__tabtab.fish; or true

starship init fish | source

# fnm
set PATH ~/.fnm $PATH
fnm env --multi | source
