# Enable fzf bindings for history and navigation. May be Gentoo-specific.
source_if_exists ${ZSH_FZF_BINDINGS_PATH:-/usr/share/fzf/key-bindings.zsh}

bindkey "^A" vi-beginning-of-line
bindkey "^E" vi-end-of-line
bindkey "^F" end-of-line

# ctrl+arrow for word jupming
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# alt+f forward a word
bindkey "^[f" forward-word

# alt+b back a word
bindkey "^[b" backward-word
# working backspace
bindkey -v '^?' backward-delete-char

# ctrl+d to close the shell
exit_zsh() { exit }
zle -N exit_zsh
bindkey '^D' exit_zsh
