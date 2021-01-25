get_jobs_count() {
	local JOBCOUNT=$(jobs | wc -l)
	if (( $JOBCOUNT > 0 )); then
		echo "[j: $JOBCOUNT]"
	fi
}

jobs_count() {
	setopt prompt_subst
	RPROMPT='$(get_jobs_count) '$RPROMPT
}

jobs_count
