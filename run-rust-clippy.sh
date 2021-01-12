#!/usr/bin/env bash

set -euo pipefail

# Some sensible defaults:
# "-D rust_2018_idioms" 
# "-D missing_debug_implementations" 
# "-D unreachable_pub" 
# "-D missing_docs"
# "-A clippy::missing_docs_in_private_items" 
# "-D clippy::doc_markdown" 
# "-D clippy::todo" 
# "-D clippy::dbg_macro" 
# "-D clippy::unimplemented" 
# "-D clippy::await_holding_lock"
# "-D clippy::match-like-matches-macro" 

cargo clippy --all-targets --all-features --all -- -D warnings "$@"