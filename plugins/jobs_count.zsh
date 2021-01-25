get_jobs_count() {
	local JOBCOUNT=$(jobs | wc -l)
	if (( $JOBCOUNT > 0 )); then
		echo "[j: $JOBCOUNT]"
	fi
}

jobs_count() {
	autoload -Uz add-zsh-hook
	RPROMPT='$(get_jobs_count) ${RPROMPT}'
}

jobs_count
