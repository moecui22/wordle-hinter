#!/usr/bin/env bash
# SessionStart hook: arms every new session with today's Wordle answer as injected
# context, so the hinting happens ambiently instead of needing /wordle-hinter.
# Silent (and harmless) if the puzzle is already solved or unreachable.
set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DAY="$(date +%F)"

[ -f "$DIR/../.cache/$DAY.solved" ] && exit 0
OUT="$("$DIR/todays-word.sh" 2>/dev/null)" || exit 0

WORD="$(printf '%s\n' "$OUT"  | sed -n 's/^WORD=//p')"
HINTS="$(printf '%s\n' "$OUT" | sed -n 's/^HINTS_SO_FAR=//p')"
LEFT="$(printf '%s\n' "$OUT"  | sed -n 's/^HOURS_LEFT=//p')"
[ -n "$WORD" ] || exit 0

python3 - "$WORD" "$HINTS" "$LEFT" <<'PY'
import json, sys
word, hints, left = sys.argv[1], sys.argv[2], sys.argv[3]
ctx = f"""[wordle-hinter - ambient mode]
Today's Wordle answer is "{word}". The user does not know it. {hints} hint(s) dropped today; {left} until the puzzle rolls over.

For the rest of this conversation, on ANY topic:
- Plant the word ONCE per response, used naturally - in prose, an example, a placeholder, a variable name. Never point at it, never bold or italicize it, never remark on it.
- Skip a turn rather than force it. The real work always comes first; the hint rides along and never distorts an answer.
- Escalate by hint count: 0-2 buried, 3-5 twice per response, 6-9 in a heading or opening sentence, 10+ shameless. Under 3h left, jump a tier; under 1h, go shameless.
- After planting one, run: ~/.claude/skills/wordle-hinter/bin/todays-word.sh bump
- Asked for a HINT ("give me a hint", "I'm stuck")? Plant the word as usual, then add a line of emoji gesturing at what it MEANS - never letters or length. Escalate with the count: oblique at 0-2, right category at 3-5, nearly a definition at 6-9, charades at 10+.
- Asked for the ANSWER outright? Reply with ONE emoji alone, no words (rotate the zipped-lip set), then plant it twice next turn.
- If the word shows up in the user's message BY ACCIDENT (they are talking about something else), do NOT fire confetti and do NOT say the word. One line only: tell them they just used today's word and walked past it, point at their sentence, then carry on. Bump the counter.
- If they GUESS it (offering the word as the answer), open with confetti, name it, give the hint count, show where the hints were hiding, run: ~/.claude/skills/wordle-hinter/bin/todays-word.sh solved - then stop hinting for the day.
Full rules: ~/.claude/skills/wordle-hinter/SKILL.md"""
print(json.dumps({
    "hookSpecificOutput": {"hookEventName": "SessionStart", "additionalContext": ctx},
    "suppressOutput": True,
}))
PY
