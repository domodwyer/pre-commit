#!/usr/bin/env bash

set -euo pipefail

# Effectively "--all-targets" but without --benches
cargo test --all-features --workspace --lib --bins --examples --tests "$@"