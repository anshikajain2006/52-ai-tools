#!/usr/bin/env bash
# Runs one outreach job headlessly with Claude Code.
# Usage: outreach/run.sh scrape | send
set -euo pipefail

job="${1:?usage: run.sh scrape|send}"
case "$job" in
  scrape|send) ;;
  *) echo "unknown job: $job" >&2; exit 2 ;;
esac

repo="$(cd "$(dirname "$0")/.." && pwd)"
log_dir="$repo/outreach/logs"
mkdir -p "$log_dir"
stamp="$(TZ=Asia/Kolkata date +%Y-%m-%d_%H%M)"

# Send only on weekdays (IST). Safe to trigger the send job every day.
if [ "$job" = "send" ] && [ "$(TZ=Asia/Kolkata date +%u)" -ge 6 ]; then
  echo "$stamp weekend, send skipped" >>"$log_dir/send-skipped.log"
  exit 0
fi

cd "$repo"
claude -p "/outreach-$job" \
  --allowedTools "mcp__Gmail,mcp__Google_Drive,ArtifactData,WebFetch,WebSearch,Bash(curl:*)" \
  >"$log_dir/$job-$stamp.log" 2>&1
