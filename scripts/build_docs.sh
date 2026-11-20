#!/usr/bin/env bash
set -euo pipefail

nvim --headless --clean -u scripts/build_docs.lua
