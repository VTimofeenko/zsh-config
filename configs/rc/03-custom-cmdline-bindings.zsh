# Enable fzf bindings for history and navigation. May be Gentoo-specific.
# Loads only if "fzf" is truly a command
if command -v fzf > /dev/null 2>&1 ; then
	source_if_exists ${ZSH_FZF_BINDINGS_PATH:-/usr/share/fzf/key-bindings.zsh}
else
	# Fall back to default ctrl+R
	bindkey "^R" history-incremental-pattern-search-backward
fi

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
