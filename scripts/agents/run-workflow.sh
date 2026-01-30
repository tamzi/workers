#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/../.." && pwd)"

usage() {
  cat <<'USAGE'
Usage:
  run-workflow.sh <workflow> --request "text" [--out-dir path] [--runner cmd]
  run-workflow.sh <workflow> --request-file path [--out-dir path] [--runner cmd]

Notes:
  - <workflow> must match a file in agents/workflows (e.g., deliveryFlow, productFlow).
  - The runner command is optional. If provided, it must accept:
      --agent <id> --workflow <id> --input <file> --output <file>
  - If no runner is provided, the script prepares a run folder and prints next steps.
USAGE
}

if [[ $# -lt 2 ]]; then
  usage
  exit 1
fi

workflow="$1"
shift

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

workflow_file="${repo_root}/agents/workflows/${workflow}.yaml"
if [[ ! -f "$workflow_file" ]]; then
  echo "Workflow not found: ${workflow_file}" >&2
  exit 1
fi

if [[ -n "$request_file_src" ]]; then
  if [[ ! -f "$request_file_src" ]]; then
    echo "Request file not found: ${request_file_src}" >&2
    exit 1
  fi
fi

if [[ -z "$request" && -z "$request_file_src" ]]; then
  usage
  exit 1
fi

run_stamp="$(date +%Y%m%d_%H%M%S)"
run_dir="${out_dir%/}/${run_stamp}_${workflow}"
mkdir -p "$run_dir"

request_file="${run_dir}/request.md"
if [[ -n "$request_file_src" ]]; then
  cp "$request_file_src" "$request_file"
else
  printf '%s\n%s\n' "# Request" "$request" > "$request_file"
fi

step_lines=()
while IFS= read -r line; do
  if [[ -n "$line" ]]; then
    step_lines+=("$line")
  fi
done < <(
  awk '
    function trim(s) {
      sub(/^[[:space:]]+/, "", s)
      sub(/[[:space:]]+$/, "", s)
      return s
    }
    function emit() {
      if (step != "") {
        print step "|" agent "|" deps
      }
    }
    BEGIN { step=""; agent=""; deps=""; in_depends=0 }
    /^[[:space:]]*- id:[[:space:]]*/ {
      emit()
      line=$0
      sub(/^[[:space:]]*- id:[[:space:]]*/, "", line)
      step=trim(line)
      agent=""
      deps=""
      in_depends=0
      next
    }
    /^[[:space:]]*agent:[[:space:]]*/ {
      line=$0
      sub(/^[[:space:]]*agent:[[:space:]]*/, "", line)
      agent=trim(line)
      next
    }
    /^[[:space:]]*dependsOn:[[:space:]]*$/ {
      in_depends=1
      next
    }
    in_depends && /^[[:space:]]*-[[:space:]]*/ {
      line=$0
      sub(/^[[:space:]]*-[[:space:]]*/, "", line)
      if (deps != "") {
        deps = deps "," trim(line)
      } else {
        deps = trim(line)
      }
      next
    }
    in_depends && /^[[:space:]]*[A-Za-z]/ {
      in_depends=0
    }
    END { emit() }
  ' "$workflow_file"
)

if [[ ${#step_lines[@]} -eq 0 ]]; then
  echo "No steps found in ${workflow_file}" >&2
  exit 1
fi

steps=()
agents=()
deps=()
files=()

idx=1
for line in "${step_lines[@]}"; do
  step="${line%%|*}"
  remainder="${line#*|}"
  agent="${remainder%%|*}"
  deps_csv="${remainder#*|}"
  deps_str="${deps_csv//,/ }"

  steps+=("$step")
  agents+=("$agent")
  deps+=("$deps_str")

  step_file="${run_dir}/$(printf "%02d_%s.md" "$idx" "$step")"
  files+=("$step_file")

  cat <<STEP_EOF > "$step_file"
# ${step}
Agent: ${agent}
Status: pending

Checklist:
  - [ ] Step complete

Issues:
  - (none)

Notes:
STEP_EOF

  idx=$((idx + 1))
done

find_index() {
  local target="$1"
  local i
  for i in "${!steps[@]}"; do
    if [[ "${steps[$i]}" == "$target" ]]; then
      echo "$i"
      return 0
    fi
  done
  return 1
}

read_status() {
  local file="$1"
  local status
  status="$(awk -F': *' '/^Status:/ {print $2; exit}' "$file" | tr '[:upper:]' '[:lower:]' | awk '{print $1}')"
  printf '%s' "${status}"
}

checklist_present() {
  local file="$1"
  grep -qE '^[[:space:]]*[-*][[:space:]]+\[[xX[:space:]]\]' "$file"
}

checklist_incomplete() {
  local file="$1"
  grep -qE '^[[:space:]]*[-*][[:space:]]+\[ \]' "$file"
}

is_step_done() {
  local file="$1"
  local status
  status="$(read_status "$file")"
  if [[ "$status" != "done" ]]; then
    return 1
  fi
  if ! checklist_present "$file"; then
    return 1
  fi
  if checklist_incomplete "$file"; then
    return 1
  fi
  return 0
}

set_status() {
  local file="$1"
  local status="$2"
  awk -v status="$status" '
    BEGIN {updated=0}
    /^Status:/ && !updated {
      print "Status: " status
      updated=1
      next
    }
    {print}
    END { if (!updated) print "Status: " status }
  ' "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"
}

append_issue() {
  local file="$1"
  local msg="$2"
  if grep -q '^Issues:' "$file"; then
    awk -v msg="$msg" '
      BEGIN {added=0}
      /^Issues:/ && !added {
        print
        print "  - " msg
        added=1
        next
      }
      {print}
    ' "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"
  else
    printf '\nIssues:\n  - %s\n' "$msg" >> "$file"
  fi
}

list_contains() {
  local list="$1"
  local item="$2"
  local word
  for word in $list; do
    if [[ "$word" == "$item" ]]; then
      return 0
    fi
  done
  return 1
}

deps_done() {
  local idx="$1"
  local dep
  for dep in ${deps[$idx]}; do
    local dep_idx
    dep_idx="$(find_index "$dep" || true)"
    if [[ -z "$dep_idx" ]]; then
      echo "Unknown dependency: ${dep} (required by ${steps[$idx]})" >&2
      exit 1
    fi
    if ! is_step_done "${files[$dep_idx]}"; then
      return 1
    fi
  done
  return 0
}

is_validation_step() {
  local step="$1"
  case "$step" in
    review|qa|productReview|supervisorReview)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

mark_pending_from() {
  local root="$1"
  local queue=()
  local seen_list=""
  queue+=("$root")
  while [[ ${#queue[@]} -gt 0 ]]; do
    local current="${queue[0]}"
    queue=("${queue[@]:1}")

    if list_contains "$seen_list" "$current"; then
      continue
    fi
    seen_list="${seen_list} ${current}"

    local current_idx
    current_idx="$(find_index "$current" || true)"
    if [[ -z "$current_idx" ]]; then
      continue
    fi

    local current_file="${files[$current_idx]}"
    local current_status
    current_status="$(read_status "$current_file")"
    if [[ "$current_status" != "needs_fix" ]]; then
      set_status "$current_file" "pending"
    fi

    local i
    for i in "${!steps[@]}"; do
      if list_contains "${deps[$i]}" "$current"; then
        queue+=("${steps[$i]}")
      fi
    done
  done
}

qa_commands=()
if [[ -n "${AGENT_QA_COMMANDS:-}" ]]; then
  IFS=';' read -r -a qa_commands <<< "${AGENT_QA_COMMANDS}"
else
  qa_commands+=("./scripts/qa.sh")
fi

run_qa_commands() {
  local step_file="$1"
  local log_dir="${run_dir}/qa_logs"
  mkdir -p "$log_dir"

  local idx=1
  local cmd
  local failed=0

  for cmd in "${qa_commands[@]}"; do
    local log_file="${log_dir}/$(printf "%02d" "$idx")_qa.log"
    echo "Running QA command: ${cmd}"
    if ! (cd "$repo_root" && eval "$cmd" > "$log_file" 2>&1); then
      append_issue "$step_file" "QA command failed: ${cmd} (log: ${log_file})"
      failed=1
    fi
    idx=$((idx + 1))
  done

  if [[ $failed -ne 0 ]]; then
    return 1
  fi
  return 0
}

implement_step=""
for i in "${!steps[@]}"; do
  if [[ "${agents[$i]}" == "implementer" || "${steps[$i]}" == "implement" ]]; then
    implement_step="${steps[$i]}"
    break
  fi
done

runner_cmd=""
if [[ -z "$runner" ]]; then
  local_runner="${repo_root}/scripts/agents/runner.sh"
  if [[ -x "$local_runner" ]]; then
    runner="$local_runner"
  fi
fi

if [[ -n "$runner" ]]; then
  if [[ -x "$runner" ]]; then
    runner_cmd="$runner"
  else
    runner_cmd="$(command -v "$runner" || true)"
  fi

  if [[ -z "$runner_cmd" ]]; then
    echo "Runner not found or not executable: ${runner}" >&2
    exit 1
  fi
fi

run_step() {
  local idx="$1"
  local step="${steps[$idx]}"
  local agent="${agents[$idx]}"
  local step_file="${files[$idx]}"

  set_status "$step_file" "in_progress"

  if [[ -n "$runner_cmd" ]]; then
    if ! "$runner_cmd" --agent "$agent" --workflow "$workflow" --input "$request_file" --output "$step_file"; then
      append_issue "$step_file" "Runner failed for ${step}"
      set_status "$step_file" "needs_fix"
    fi
  fi

  if [[ "$agent" == "qa" || "$step" == "qa" ]]; then
    if ! run_qa_commands "$step_file"; then
      set_status "$step_file" "needs_fix"
    fi
  fi

  if is_step_done "$step_file"; then
    set_status "$step_file" "done"
    return 0
  fi

  set_status "$step_file" "needs_fix"

  if is_validation_step "$step" && [[ -n "$implement_step" && "$step" != "$implement_step" ]]; then
    mark_pending_from "$implement_step"
  fi

  return 1
}

if [[ -n "$runner_cmd" ]]; then
  while true; do
    local_all_done=1
    local_next_idx=""

    for i in "${!steps[@]}"; do
      if is_step_done "${files[$i]}"; then
        continue
      fi
      local_all_done=0
      if deps_done "$i"; then
        local_next_idx="$i"
        break
      fi
    done

    if [[ $local_all_done -eq 1 ]]; then
      break
    fi

    if [[ -z "$local_next_idx" ]]; then
      echo "No runnable steps found. Check dependencies and statuses." >&2
      exit 1
    fi

    run_step "$local_next_idx" || true
  done
fi

echo "Run created: ${run_dir}"
echo "Request: ${request_file}"
echo "Workflow: ${workflow_file}"
echo "Steps:"
idx=1
for i in "${!steps[@]}"; do
  step="${steps[$i]}"
  agent="${agents[$i]}"
  step_file="${files[$i]}"
  echo "- ${step} (${agent}): ${step_file}"
  idx=$((idx + 1))
done

if [[ -z "$runner_cmd" ]]; then
  echo "Runner not set. To auto-run, pass --runner, set AGENT_RUNNER, or add scripts/agents/runner.sh."
fi
