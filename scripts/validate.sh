#!/usr/bin/env bash
# Checks Casey's packaging before a build or push. No network, no Docker needed.
# Usage: ./scripts/validate.sh   (from anywhere; exits non-zero on any failure)
# Works with macOS bash 3.2 and BSD tools as well as Linux.
set -uo pipefail
cd "$(dirname "$0")/.." || exit 2

fail=0; warn=0
ok()   { printf '  ok    %s\n' "$1"; }
bad()  { printf '  FAIL  %s\n' "$1"; fail=$((fail+1)); }
note() { printf '  warn  %s\n' "$1"; warn=$((warn+1)); }

echo "Dockerfile"
df=Dockerfile
if [[ ! -f $df ]]; then bad "Dockerfile missing"; else
  from=$(grep -m1 -E '^FROM ' "$df" | awk '{print $2}')
  if [[ $from =~ ^public\.ecr\.aws/e1h7x4a2/plow-cloud-agents:base-[0-9a-f]{40}@sha256:[0-9a-f]{64}$ ]]; then
    ok "FROM is the Plow base pinned by tag and digest"
  else bad "FROM must be public.ecr.aws/e1h7x4a2/plow-cloud-agents:base-<40-hex>@sha256:<64-hex> (got: $from)"; fi
  [[ $(grep -c -E '^FROM ' "$df") -eq 1 ]] && ok "single stage" || bad "expected exactly one FROM"
  agent_id=$(grep -oE 'AGENT_ID=[^ "]+' "$df" | head -1 | cut -d= -f2)
  if [[ $agent_id =~ ^[a-z0-9][a-z0-9-]{1,62}$ && $agent_id != your-agent-id ]]; then ok "AGENT_ID=$agent_id"
  else bad "AGENT_ID missing or invalid (got: ${agent_id:-none})"; fi
  name=$(grep -oE 'AGENT_NAME="[^"]*"' "$df" | head -1 | sed -E 's/AGENT_NAME="(.*)"/\1/')
  [[ -n $name ]] && ok "AGENT_NAME=\"$name\"" || bad "AGENT_NAME missing"
  blurb=$(grep -oE 'AGENT_BLURB="[^"]*"' "$df" | head -1 | sed -E 's/AGENT_BLURB="(.*)"/\1/')
  if [[ -z $blurb ]]; then bad "AGENT_BLURB missing"
  elif (( ${#blurb} > 140 )); then bad "AGENT_BLURB is ${#blurb} chars (max 140)"
  else ok "AGENT_BLURB ${#blurb} chars"; fi
  grep -q 'AGENT_RUNTIME=OpenClaw' "$df" && ok "AGENT_RUNTIME=OpenClaw" || note "AGENT_RUNTIME not set (older bases fall back to the Hermes placeholder)"
  grep -qE '^COPY prompt/AGENTS\.md /opt/plow/prompt/AGENTS\.md$' "$df" && ok "COPY prompt/AGENTS.md" || bad "missing: COPY prompt/AGENTS.md /opt/plow/prompt/AGENTS.md"
  grep -qE '^COPY skills/ /opt/plow/skills/$' "$df" && ok "COPY skills/" || bad "missing: COPY skills/ /opt/plow/skills/"
  grep -qE '^(CMD|ENTRYPOINT|USER) ' "$df" && bad "variant must not override CMD/ENTRYPOINT/USER (the base boot does usage reporting)" || ok "inherits base boot and reporter"
fi

echo "Build context"
if [[ -f .dockerignore ]]; then
  grep -qx '!skills/\*\*' .dockerignore && grep -qx '!prompt/AGENTS.md' .dockerignore && ok ".dockerignore lets prompt and skills in" || bad ".dockerignore must allow prompt/AGENTS.md and skills/**"
else note ".dockerignore missing"; fi
grep -qx 'plow-credentials' .gitignore 2>/dev/null && ok "plow-credentials is git-ignored" || bad "add plow-credentials to .gitignore"
[[ -e plow-credentials ]] && note "plow-credentials exists locally (fine; never commit it)"

echo "Prompt"
p=prompt/AGENTS.md
if [[ -s $p ]]; then
  ok "$p ($(wc -c < "$p") bytes)"
  for must in plow_start_thread plow-owner NO_REPLY first_contact; do
    grep -q "$must" "$p" && ok "prompt mentions $must" || bad "prompt never mentions $must"
  done
else bad "$p missing or empty"; fi

echo "Skills"
shopt -s nullglob
dirs=(skills/*/)
(( ${#dirs[@]} >= 1 )) || bad "no skills found"
seen=" "
for d in "${dirs[@]}"; do
  dir=$(basename "$d"); f="$d/SKILL.md"
  if [[ ! -f $f ]]; then bad "$dir: SKILL.md missing"; continue; fi
  if [[ $(head -1 "$f") != '---' ]]; then bad "$dir: frontmatter must start on line 1 with ---"; continue; fi
  fm=$(awk 'NR==1{next} /^---$/{exit} {print}' "$f")
  closes=$(awk 'NR>1 && /^---$/{print NR; exit}' "$f")
  [[ -n $closes ]] || { bad "$dir: frontmatter not closed"; continue; }
  sname=$(printf '%s\n' "$fm" | sed -nE 's/^name:[[:space:]]*(.*)$/\1/p' | head -1)
  desc=$(printf '%s\n' "$fm" | sed -nE 's/^description:[[:space:]]*(.*)$/\1/p' | head -1)
  [[ $sname == "$dir" ]] && ok "$dir: name matches folder" || bad "$dir: name '$sname' must equal folder name"
  [[ $sname =~ ^[a-z0-9]([a-z0-9-]{0,62}[a-z0-9])?$ ]] || bad "$dir: name must be 1-64 lowercase letters, digits, hyphens"
  if [[ -z $desc ]]; then bad "$dir: description missing"
  elif (( ${#desc} < 40 )); then bad "$dir: description too short to trigger reliably"
  elif (( ${#desc} > 1024 )); then bad "$dir: description over 1024 chars"
  else ok "$dir: description ${#desc} chars"; fi
  body=$(awk -v c="$closes" 'NR>c' "$f")
  [[ $(printf '%s' "$body" | wc -w) -ge 80 ]] && ok "$dir: body has substance" || bad "$dir: body under 80 words"
  [[ $seen == *" $sname "* ]] && bad "duplicate skill name $sname"; seen="$seen$sname "
  grep -qw -- "$dir" "$p" 2>/dev/null && ok "$dir: referenced from AGENTS.md" || note "$dir: not referenced from AGENTS.md"
done

echo "Repo files"
grep -q '^MIT License' LICENSE 2>/dev/null && grep -q 'Copyright (c) 2026 Jack Lin' LICENSE && ok "LICENSE is MIT, 2026 Jack Lin" || bad "LICENSE must be MIT, Copyright (c) 2026 Jack Lin"
if [[ -f README.md && -n ${agent_id:-} ]]; then
  grep -q "Set this up for me: aiworthusing.com/agent-index/$agent_id" README.md && ok "README install line uses $agent_id" || bad "README install line must use slug $agent_id"
fi
if [[ -f assets/logo.svg ]]; then
  if command -v python3 >/dev/null; then
    python3 -c 'import sys,xml.dom.minidom as m; m.parse(sys.argv[1])' assets/logo.svg 2>/dev/null && ok "assets/logo.svg is well-formed XML" || bad "assets/logo.svg is not well-formed"
  else ok "assets/logo.svg present"; fi
else bad "assets/logo.svg missing"; fi

echo "Secrets"
hits=$(grep -rInE '(ghp_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}|sk-[A-Za-z0-9]{20,}|PLOW_AGENT_TOKEN=[A-Za-z0-9._-]{12,}|-----BEGIN [A-Z ]*PRIVATE KEY-----)' \
  --exclude-dir=.git --exclude=plow-credentials --exclude=validate.sh . || true)
[[ -z $hits ]] && ok "no token-shaped strings" || { bad "possible secret:"; printf '%s\n' "$hits"; }

echo
if (( fail )); then echo "FAILED: $fail check(s), $warn warning(s)"; exit 1; fi
echo "PASSED with $warn warning(s)"
