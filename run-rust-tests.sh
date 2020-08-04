#!/usr/bin/env bash

set -euo pipefail

cargo test --all-features --all --bins --tests --examples --benches --all-targets "$@"