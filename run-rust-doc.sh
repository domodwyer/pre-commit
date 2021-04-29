#!/usr/bin/env bash

set -euo pipefail

# Requires:
#![deny(broken_intra_doc_links)]
cargo doc --no-deps --all-features --workspace --document-private-items