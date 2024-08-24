#!/usr/bin/env bash

# Find comments with empty backtick pairs (`thing``).
#
# Expects filenames to validate as script arguments.

set -euo pipefail

STDOUT=$(srgn -j --fail-no-files \
	--rust doc-comments \
	--rust comments \
	'[^`]`{2}[^`]+')

if [[ -n $STDOUT ]]
then
    printf -- "%s\n" "$STDOUT"
	exit 1;
fi
