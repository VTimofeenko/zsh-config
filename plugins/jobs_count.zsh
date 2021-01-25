jobs_count() {
	local JOBCOUNT=$(jobs | wc -l)
	if (( $JOBCOUNT > 0 )); then
		echo "[j: $JOBCOUNT]"
	fi
}

jobs_count() {
	autoload -Uz add-zsh-hook
	RPROMPT='$(jobs_count) ${RPROMPT}'
}
