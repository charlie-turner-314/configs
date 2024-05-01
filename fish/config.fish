set -x N_PREFIX ~/.n
# pyenv init - | source


if status is-interactive
    fish_add_path /opt/homebrew/bin
    # Commands to run in interactive sessions can go here
    # >> Aliases
    alias vim "nvim"
    alias c "clear"
    alias lg "lazygit"
    # >> Abbreviations
    abbr py "python3.11"
    abbr odocs "cd ~/OneDrive\ -\ Queensland\ University\ of\ Technology/Documents/"
    abbr lg "lazygit"
    # >> Theme
    function fish_greeting
      set_color $fish_color_autosuggestion
      echo "Welcome to fish"
      set_color normal
    end
    # Terminal initialization
    function starship_transient_rprompt_func
        # display the time in the right prompt
        starship module time
        # display the duration fo the last command in the right prompt
        starship module cmd_duration
    end
    starship init fish | source
    enable_transience

    zoxide init fish | source

    # Conda Based On Architecture
    # <<<<<< Added by TR 20220405 <<
    set arch_name "$(uname -m)"

    if test "$arch_name" = "x86_64"
        echo "Running on Rosetta using miniconda3"
        source ./.config/fish/.start_miniconda.fish
    else if test "$arch_name" = "arm64"
        echo "Running on ARM64 using miniforge3"
        source ~/.config/fish/.start_miniforge.fish
    else
        echo "Unknown architecture: $arch_name"
    end
end












