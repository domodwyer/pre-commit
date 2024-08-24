#!/usr/bin/env bash

# Find comments with empty backtick pairs (`thing``).
#
# Expects filenames to validate as script arguments.

set -euo pipefail

srgn -j --fail-no-files -G "$@" \
	--rust doc-comments \
	--rust comments \
	'[^`]`{2}[^`]+'
