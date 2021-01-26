#!/bin/zsh
# By Vladimir Timofeenko

# Original authors:
# Purification
# by Matthieu Cneude
# https://github.com/Phantas0s/purification

# Based on:

# Purity
# by Kevin Lanni
# https://github.com/therealklanni/purity
# MIT License

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '%b%c%u'

# Determine if ripgrep is available
local GREP_CMD
if command -v rg &> /dev/null;	then
	GREP_CMD="rg"
else
	GREP_CMD="grep"
fi

typeset -gA ZSH_PROMPT_GIT_SETUP
ZSH_PROMPT_GIT_SETUP=(
	prefix "%F{yellow}λ:%f%F{blue}"
	suffix "%f"
	dirty ""
	clean ""
	added "%F{green}+%f"
	modified "%F{blue}Δ%f"
	deleted "%F{red}X%f"
	renamed "%F{magenta}→%f"
	unmerged "%F{yellow}═%f"
	untracked "%F{white}¬%f"
	stashed "%B%F{red}⊎%f%b"
	behind "%B%F{red}«%f%b"
	ahead "%B%F{green}»%f%b"
)

get_git_details_for_prompt() {
	local PREFIX INDEX STATUS

	# Check if in git repository
	if git rev-parse --git-dir 2>/dev/null 1>&2; then
		vcs_info 2>/dev/null
		PREFIX="${ZSH_PROMPT_GIT_SETUP[prefix]}${vcs_info_msg_0_}${ZSH_PROMPT_GIT_SETUP[suffix]}"

		INDEX=$(command git status --porcelain -b 2> /dev/null)

		STATUS=""

		# Untracked files
		local UNTRACKED_FILES=$(echo "$INDEX" | $GREP_CMD -c -e "^\?" 2>/dev/null)
		if [ ! -z $UNTRACKED_FILES ]; then
			STATUS="${ZSH_PROMPT_GIT_SETUP[untracked]} : $UNTRACKED_FILES $STATUS"
		fi

		# Added block
		local ADDED_FILES=$(echo $INDEX | $GREP_CMD -c -e '^A  ' -e '^M  ' -e '^MM ' 2>/dev/null)
		if [ ! -z $ADDED_FILES ]; then
			STATUS="${ZSH_PROMPT_GIT_SETUP[added]} : $ADDED_FILES $STATUS"
		fi

		# Modified block
		local MODIFIED_FILES=$(echo $INDEX | $GREP_CMD -c -e '^ M ' -e '^AM ' -e '^MM ' -e '^ T ' 2>/dev/null)
		if [ ! -z $MODIFIED_FILES ]; then
			STATUS="${ZSH_PROMPT_GIT_SETUP[modified]} : $MODIFIED_FILES $STATUS"
		fi

		# Renamed block
		local RENAMED_FILES=$(echo $INDEX | $GREP_CMD -c -e '^R  ' 2>/dev/null)
		if [ ! -z $RENAMED_FILES ]; then
			STATUS="${ZSH_PROMPT_GIT_SETUP[renamed]} : $RENAMED_FILES $STATUS"
		fi

		local DELETED_FILES=$(echo $INDEX | $GREP_CMD -c -e '^ D ' -e '^D  ' -e '^AD ' 2>/dev/null)
		if [ ! -z $DELETED_FILES ]; then
			STATUS="${ZSH_PROMPT_GIT_SETUP[deleted]} : $DELETED_FILES $STATUS"
		fi

		if $(command git rev-parse --verify refs/stash >/dev/null 2>&1); then
			STATUS="${ZSH_PROMPT_GIT_SETUP[stashed]} $STATUS"
		fi

		local UNMERGED_FILES=$(echo $INDEX | $GREP_CMD -c -e '^UU ' 2>/dev/null)
		if [ ! -z $UNMERGED_FILES ]; then
			STATUS="${ZSH_PROMPT_GIT_SETUP[unmerged]} $STATUS"
		fi

		if $(echo "$INDEX" | $GREP_CMD '^## [^ ]\+ .*ahead' &> /dev/null); then
			STATUS="${ZSH_PROMPT_GIT_SETUP[ahead]} $STATUS"
		fi

		if $(echo "$INDEX" | $GREP_CMD '^## [^ ]\+ .*behind' &> /dev/null); then
			STATUS="${ZSH_PROMPT_GIT_SETUP[behind]} $STATUS"
		fi

		if $(echo "$INDEX" | $GREP_CMD '^## [^ ]\+ .*diverged' &> /dev/null); then
			STATUS="${ZSH_PROMPT_GIT_SETUP[diverged]} $STATUS"
		fi

		if [[ ! -z "$STATUS" ]]; then
			echo "${PREFIX} [ $STATUS]"
		fi
	fi
}


_prompt_git_details_done (){
	local job=$1
	local return_code=$2
	local stdout=$3
	local more=$6
	if [[ $job == '[async]' ]]; then
		if [[ $return_code -eq 2 ]]; then
			# Need to restart the worker. Stolen from
			# https://github.com/mengelbrecht/slimline/blob/master/lib/async.zsh
			_git_rprompt_async_start
			return
		fi
	fi
	git_prompt_msg=$stdout
	[[ $more == 1 ]] || zle reset-prompt
}

_git_rprompt_async_start() {
	async_start_worker get_git_details_for_prompt
	async_register_callback get_git_details_for_prompt _prompt_git_details_done
}

_git_rprompt_info() {
	cd -q $1
	get_git_details_for_prompt
}

async_init
_git_rprompt_async_start

add-zsh-hook precmd (){
async_flush_jobs get_git_details_for_prompt
async_job get_git_details_for_prompt _git_rprompt_info $PWD
}

add-zsh-hook chpwd (){
git_prompt_msg=
}

setopt prompt_subst
RPROMPT='${git_prompt_msg}'$RPROMPT
