# lt — Linear Ticket: create a worktree and launch Claude for a Linear ticket
# Usage: lt <TEAM-123 | https://linear.app/...>
#
# This is a zsh function (not a script) so that `wt switch` can cd in the
# current shell — iTerm picks up the directory change before claude launches.
#
# Requires: LINEAR_API_KEY env var, wt (worktrunk), claude

function lt() {
  if [[ $# -lt 1 ]]; then
    echo "Usage: lt <TICKET-ID | URL>" >&2
    return 1
  fi

  local ticket identifier title description labels state_type prefix slug branch prompt

  echo "Fetching ticket..."
  ticket=$(/Users/tam/bin/linear get "$1") || return 1

  _ltjq() { python3 -c "import sys,json; d=json.load(sys.stdin); print($1)" <<< "$ticket"; }

  identifier=$(_ltjq "d['identifier']")
  title=$(_ltjq "d['title']")
  description=$(_ltjq "d.get('description') or ''")
  labels=$(_ltjq "','.join(n['name'].lower() for n in d.get('labels',{}).get('nodes',[]))")
  state_type=$(_ltjq "d.get('state',{}).get('type','')")

  unfunction _ltjq

  # Map Linear labels to a branch prefix
  prefix="feature"
  for label in ${(s:,:)labels}; do
    case "$label" in
      *hotfix*)                                        prefix="hotfix"  ; break ;;
      *bug*|*fix*)                                     prefix="bugfix"  ; break ;;
      *release*)                                       prefix="release" ; break ;;
      *chore*|*maintenance*|*tech*|*debt*|*refactor*|\
      *cleanup*|*infra*)                               prefix="chore"   ; break ;;
    esac
  done

  # Build branch name: prefix/identifier-title-slug
  slug=$(echo "$title" \
    | tr '[:upper:]' '[:lower:]' \
    | sed 's/[^a-z0-9]/-/g' \
    | sed 's/--*/-/g' \
    | sed 's/^-//;s/-$//' \
    | cut -c1-50)
  branch="${prefix}/${identifier:l}-${slug}"

  # Build the initial Claude prompt
  prompt="${identifier}: ${title}"
  if [[ -n "$description" ]]; then
    prompt="${prompt}

${description}"
  fi

  echo "Ticket:  ${identifier} — ${title}"
  echo "Branch:  ${branch}"

  if [[ "$state_type" == "backlog" ]]; then
    echo "Status:  marking as in-progress..."
    /Users/tam/bin/linear start "$identifier" || true
  fi

  echo ""

  # wt switch (no -x) so the cd happens in the current shell before claude launches
  wt switch --create "$branch" && claude "$prompt"
}
