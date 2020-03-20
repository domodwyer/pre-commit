#!/usr/bin/env bash
LC_ALL=C

# Searches all files in the repo for TODO comments tagged with a ticket
# reference taken from the branch name.
#
# Any TODO comments tagged as:
#
#       TODO(CP-1234): some text
#
# Will be printed to screen for any branch name that contains CP-1234. If the
# tag cannot be extracted from the branch name, nothing happens.
#
# If present, ripgrep will be used - it's much faster and makes this hook
# execute practically instantly: https://github.com/BurntSushi/ripgrep

# Fetch the current branch name
local_branch="$(git rev-parse --abbrev-ref HEAD)"

# Read the ticket reference regex from the first argument, or default to ours.
#
# The first match of this pattern in local_branch is used for the TODO search.
ticket_ref_regex=${1:-"CP-[0-9]+"}

if [[ ! "$local_branch" =~ $ticket_ref_regex ]]
then
	# echo "===> Unable to find ticket reference ${ticket_ref_regex} in branch name ${local_branch}"
	exit 0
fi

ticket_ref=${BASH_REMATCH[0]}

# Prefer ripgrep if installed.
# 
# The exit code of both commands is negated causing the presence of tagged TODOs
# to be printed, and no TODOs returns 0.
if [ -x "$(command -v rg)" ]; then
	! rg -F "TODO(${ticket_ref})" .
else
	! grep \
		-F "TODO(${ticket_ref})" \
		-R \
		--exclude="*/vendor/*" \
		--binary-files="without-match" \
		.
fi
