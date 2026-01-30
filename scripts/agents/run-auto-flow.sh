#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  run-auto-flow.sh --request "text" [--out-dir path] [--runner cmd]
  run-auto-flow.sh --request-file path [--out-dir path] [--runner cmd]

Notes:
  - Picks a workflow based on keywords in the request.
  - Keyword order (highest to lowest): implement/code/build -> break down/epics/stories/tasks -> research/requirements -> plan.
USAGE
}

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/../.." && pwd)"

request=""
request_file_src=""
out_dir="${AGENT_RUN_DIR:-${repo_root}/build/agentRuns}"
runner="${AGENT_RUNNER:-}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --request)
      request="$2"
      shift 2
      ;;
    --request-file)
      request_file_src="$2"
      shift 2
      ;;
    --out-dir)
      out_dir="$2"
      shift 2
      ;;
    --runner)
      runner="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      if [[ -z "$request" && -z "$request_file_src" ]]; then
        request="$1"
        shift
      else
        request="${request} $1"
        shift
      fi
      ;;
  esac
done

if [[ -z "$request" && -z "$request_file_src" ]]; then
  usage
  exit 1
fi

if [[ -n "$request_file_src" ]]; then
  if [[ ! -f "$request_file_src" ]]; then
    echo "Request file not found: ${request_file_src}" >&2
    exit 1
  fi
fi

text_source=""
if [[ -n "$request_file_src" ]]; then
  text_source="$(cat "$request_file_src")"
else
  text_source="$request"
fi

lower_text="$(printf '%s' "$text_source" | tr '[:upper:]' '[:lower:]')"

has() {
  printf '%s' "$lower_text" | grep -Eiq "$1"
}

score_agile=0
score_feature=0
score_product=0
score_delivery=0
score_tech_debt=0
score_spike=0
force_product=false

if has '\\b(implement|code|build|ship|deliver|release)\\b'; then
  score_agile=$((score_agile + 3))
fi
if has '^\\s*(do|make|create|add|update|fix|change)\\b'; then
  score_agile=$((score_agile + 2))
fi
if has '\\b(plan|planning)\\b'; then
  score_delivery=$((score_delivery + 2))
fi
if has '\\b(research|discover|investigate|explore|analy[sz]e)\\b'; then
  score_product=$((score_product + 2))
fi
if has '\\b(spike|time[- ]?box|timeboxed|exploration)\\b'; then
  score_spike=$((score_spike + 3))
fi
if has '\\b(requirement|requirements|prd)\\b'; then
  score_product=$((score_product + 2))
fi
if has '\\b(undocumented|nonexistent)\\b|not documented|no documentation|not in docs|missing docs|missing documentation|unknown feature|does not exist|doesnt exist|not exist|new feature|from scratch|greenfield'; then
  force_product=true
  score_product=$((score_product + 5))
fi
if has 'break down|breakdown|\\b(epic|epics|story|stories|task|tasks)\\b'; then
  score_feature=$((score_feature + 3))
fi
if has '\\b(refactor|refactoring|tech debt|technical debt|cleanup|hardening|stabilize|stabilisation|stabilization)\\b'; then
  score_tech_debt=$((score_tech_debt + 3))
fi
if has '\\b(sprint|backlog)\\b'; then
  score_product=$((score_product + 1))
fi

workflow="agileDeliveryFlow"
max_score=$score_agile

if [[ $score_feature -gt $max_score ]]; then
  workflow="featureBreakdownFlow"
  max_score=$score_feature
fi
if [[ $score_spike -gt $max_score ]]; then
  workflow="researchSpikeFlow"
  max_score=$score_spike
fi
if [[ $score_tech_debt -gt $max_score ]]; then
  workflow="techDebtFlow"
  max_score=$score_tech_debt
fi
if [[ $score_product -gt $max_score ]]; then
  workflow="productFlow"
  max_score=$score_product
fi
if [[ $score_delivery -gt $max_score ]]; then
  workflow="deliveryFlow"
  max_score=$score_delivery
fi

if [[ "$force_product" == "true" ]]; then
  workflow="productFlow"
fi

args=( "$workflow" "--out-dir" "${out_dir}" )

if [[ -n "$runner" ]]; then
  args+=( "--runner" "$runner" )
fi

if [[ -n "$request_file_src" ]]; then
  args+=( "--request-file" "$request_file_src" )
else
  args+=( "--request" "$request" )
fi

"${script_dir}/run-workflow.sh" "${args[@]}"
