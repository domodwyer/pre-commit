#!/usr/bin/env bash

set -euo pipefail

cargo check --all-targets --all-features --workspace "$@"