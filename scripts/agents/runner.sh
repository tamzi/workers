#!/usr/bin/env bash
set -euo pipefail

output=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --output)
      output="$2"
      shift 2
      ;;
    --agent|--workflow|--input)
      shift 2
      ;;
    *)
      shift
      ;;
  esac
 done

if [[ -z "$output" ]]; then
  echo "Missing --output" >&2
  exit 1
fi

perl -0pi -e 's/^Status:.*$/Status: done/m; s/\[ \]/[x]/g' "$output"
