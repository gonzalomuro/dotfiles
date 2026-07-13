if status is-interactive
    # Commands to run in interactive sessions can go here
    abbr -a -- gs git status
		set -g fish_key_bindings fish_vi_key_bindings
		eval (/opt/homebrew/bin/brew shellenv)

    set fish_color_valid_path normal
end
