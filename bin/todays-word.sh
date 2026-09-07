#!/usr/bin/env bash
# Today's Wordle solution, cached, with rollover timing.
#   todays-word.sh          -> today's word, hint count, hours left in the day
#   todays-word.sh bump     -> record a dropped hint, then print
#   todays-word.sh prefetch -> cache today + the next 2 days, print nothing
#   todays-word.sh solved   -> mark today solved; the session hook then goes quiet
#
# Wordle rolls over at LOCAL midnight on the player's device, and the endpoint is keyed by
# print_date rather than a timezone, so the local date is always the right key. Future
# dates are served freely, so prefetch: at midnight the next word is already on disk.
set -euo pipefail

CACHE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/.cache"
mkdir -p "$CACHE"

day_offset()   { date -v+"$1"d +%F 2>/dev/null || date -d "+$1 days" +%F; }
next_midnight(){ date -v+1d -v0H -v0M -v0S +%s 2>/dev/null || date -d "tomorrow 00:00" +%s; }

fetch_day() { # $1=YYYY-MM-DD -> echoes word (cached), empty if unreachable
  local d="$1" f="$CACHE/$1.word" json word
  if [ -s "$f" ]; then cat "$f"; return 0; fi
  json="$(curl -sf --max-time 15 "https://www.nytimes.com/svc/wordle/v2/$d.json" </dev/null || true)"
  word="$(printf '%s' "$json" | sed -n 's/.*"solution":"\([a-z]*\)".*/\1/p')"
  [ -n "$word" ] || return 0
  printf '%s\n' "$word" > "$f"
  printf '%s\n' "$word"
}

DAY="$(date +%F)"

if [ "${1:-}" = "solved" ]; then
  touch "$CACHE/$DAY.solved"
  "$(dirname "${BASH_SOURCE[0]}")/confetti.sh" "$(fetch_day "$DAY")"
  exit 0
fi

if [ "${1:-}" = "prefetch" ]; then
  for i in 0 1 2; do fetch_day "$(day_offset $i)" >/dev/null; done
  find "$CACHE" -type f -mtime +7 -delete 2>/dev/null || true
  exit 0
fi

WORD="$(fetch_day "$DAY")"
if [ -z "$WORD" ]; then
  echo "WORD=UNAVAILABLE" >&2
  echo "Endpoint unreachable and nothing prefetched. No hints today." >&2
  exit 1
fi

HINT_FILE="$CACHE/$DAY.hints"
[ -s "$HINT_FILE" ] || echo 0 > "$HINT_FILE"
[ "${1:-}" = "bump" ] && echo $(( $(cat "$HINT_FILE") + 1 )) > "$HINT_FILE"

SECS_LEFT=$(( $(next_midnight) - $(date +%s) ))
echo "WORD=$WORD"
echo "HINTS_SO_FAR=$(cat "$HINT_FILE")"
echo "PUZZLE_DATE=$DAY"
echo "HOURS_LEFT=$(( SECS_LEFT / 3600 ))h$(( (SECS_LEFT % 3600) / 60 ))m"
