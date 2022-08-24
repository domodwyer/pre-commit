#!/usr/bin/env bash

set -euo pipefail

README=($(git diff --cached --name-only | grep -Ei '^README\.[R]?md$'))

if [[ ${#README[@]} == 0 ]]; then
  exit 0
fi

if [[ README.Rmd -nt README.md ]]; then
  echo -e "README.md is out of date; please re-knit README.Rmd"
  exit 1
elif [[ ${#README[@]} -lt 2 ]]; then
  echo -e "README.Rmd and README.md should be both staged"
  exit 1
fi