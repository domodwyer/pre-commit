#!/usr/bin/env bash

# Protobuf linting with Buf: https://docs.buf.build/
#
# To run the lints locally:
#   buf lint
#
# To view the available lints and their descriptions:
#   buf config ls-lint-rules

set -euo pipefail

buf lint "$@"