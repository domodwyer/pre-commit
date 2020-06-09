#!/usr/bin/env bash

set -euo pipefail

default_lints=( 
	"-D rust_2018_idioms" 
	"-D missing_debug_implementations" 
	"-D unreachable_pub" 
	"-W missing_docs"
	"-D clippy::doc_markdown" 
	"-D clippy::indexing_slicing" 
	"-D clippy::missing_docs_in_private_items" 
	"-D clippy::todo" 
	"-D clippy::unimplemented" 
	"-D clippy::await_holding_lock" 
)

# Use the lints passed as arguments, or the default above.
lints=${*:-${default_lints[*]}}

cargo clippy --all-targets --all-features -- -D warnings ${lints}