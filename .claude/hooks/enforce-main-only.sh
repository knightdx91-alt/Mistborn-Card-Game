#!/usr/bin/env bash
# Enforce the main-only workflow policy.
# Blocks git commands that create branches or open PRs unless the human has
# explicitly authorized the action in the current turn.
#
# The permission override is opt-in per command: prefix the git command with
#   ALLOW_BRANCH=1
# to bypass this guard when you have been explicitly told to branch/PR.

set -euo pipefail

input=$(cat)
cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // ""')

# Escape hatch: explicit human authorization for this one command.
if printf '%s' "$cmd" | grep -qE '(^|[[:space:]])ALLOW_BRANCH=1([[:space:]]|$)'; then
  exit 0
fi

deny() {
  jq -n --arg reason "$1" '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: $reason
    }
  }'
  exit 0
}

# Normalize whitespace for matching.
norm=$(printf '%s' "$cmd" | tr -s '[:space:]' ' ')

# Block branch creation: git branch <name>, git checkout -b, git switch -c, git switch --create
if printf '%s' "$norm" | grep -qE '\bgit\b[^|;&]*\bcheckout\b[^|;&]*(-b|-B)\b'; then
  deny "POLICY: main-only workflow. Creating a branch is not allowed unless explicitly told. Prefix with ALLOW_BRANCH=1 if the human authorized it."
fi
if printf '%s' "$norm" | grep -qE '\bgit\b[^|;&]*\bswitch\b[^|;&]*(-c\b|-C\b|--create\b)'; then
  deny "POLICY: main-only workflow. Creating a branch is not allowed unless explicitly told. Prefix with ALLOW_BRANCH=1 if the human authorized it."
fi
# git branch <name> (creating). Allow read-only forms: git branch, -a, -l, --list, --show-current, -v, -r, -d/-D (delete), --merged, etc.
if printf '%s' "$norm" | grep -qE '\bgit\b[^|;&]*\bbranch\b'; then
  if printf '%s' "$norm" | grep -qE '\bgit\b[^|;&]* branch +([^-][^ ]*)'; then
    deny "POLICY: main-only workflow. Creating a branch is not allowed unless explicitly told. Prefix with ALLOW_BRANCH=1 if the human authorized it."
  fi
fi

# Block pushing to a non-main branch.
if printf '%s' "$norm" | grep -qE '\bgit\b[^|;&]*\bpush\b'; then
  # HEAD:<branch> refspec pointing at anything other than main
  if printf '%s' "$norm" | grep -qE '\bpush\b[^|;&]* HEAD:(refs/heads/)?[^ ]+' \
     && ! printf '%s' "$norm" | grep -qE '\bpush\b[^|;&]* HEAD:(refs/heads/)?main( |$)'; then
    deny "POLICY: main-only workflow. Pushing to a non-main branch is not allowed unless explicitly told. Prefix with ALLOW_BRANCH=1 if the human authorized it."
  fi
  # Explicit branch refspec e.g. `git push origin foo` (foo != main)
  if printf '%s' "$norm" | grep -qE '\bpush\b +(-u |--set-upstream )?[^ -][^ ]* +([^ -][^ :]*)( |$)' \
     && ! printf '%s' "$norm" | grep -qE '\bpush\b[^|;&]* main( |$)' \
     && ! printf '%s' "$norm" | grep -qE '\bpush\b[^|;&]* HEAD:' ; then
    deny "POLICY: main-only workflow. Pushing to a non-main branch is not allowed unless explicitly told. Prefix with ALLOW_BRANCH=1 if the human authorized it."
  fi
fi

exit 0
