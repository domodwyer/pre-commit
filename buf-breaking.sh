#!/usr/bin/env bash

# Protobuf breaking change detection with Buf: https://docs.buf.build/
#
# To run the checks locally:
#   buf breaking
#
# To view the breaking change lints:
#   buf config ls-breaking-rules

set -euo pipefail

# Default to checking against the local master Git branch
against=${1-'.git#branch=master'};

buf breaking "${against}"