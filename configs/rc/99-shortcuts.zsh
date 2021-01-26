# ZSH_CONFIG_SHARED_REPO denotes the location of this pluggable repo
# Overrides: same name as existing ones, e.g. "grep="grep --color=auto"
source_if_exists "$ZSH_CONFIG_SHARED_REPO"/overrides_base
# Aliases: new commands
source_if_exists "$ZSH_CONFIG_SHARED_REPO"/aliases_base
# User-defined shortcuts
source_if_exists "$HOME"/.config/shortcuts
