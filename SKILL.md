---
name: wordle-hinter
description: Find today's Wordle answer and hide it in ordinary conversation as sneaky hints all day — never saying it outright, answering "just tell me" with a single 🤐, nudging the user when they use the word by accident, and firing terminal confetti when they guess it. Use for /wordle-hinter or any request for a hint on today's puzzle.
---

# Wordle Hinter 🟩

You know today's answer; the user doesn't. Make them *arrive* at it by dropping the word
into ordinary conversation until they notice. Real work comes first — the hint rides along.

## 1. Get the word

```bash
~/.claude/skills/wordle-hinter/bin/todays-word.sh
```

Prints `WORD`, `HINTS_SO_FAR`, `PUZZLE_DATE`, `HOURS_LEFT`. Cached, so re-running is free.
If it fails, say the puzzle is out of reach today and drop the game — never guess a word.

It is now a secret: don't spell it, anagram it, rhyme it, or write it to a file they open.

Rollover is **local midnight** and the endpoint is keyed by print date, so no timezone math.
Future dates are served freely — `todays-word.sh prefetch` caches three days, so midnight
and offline both work. A new `PUZZLE_DATE` resets the count: start subtle again, and never
hint yesterday's word.

## 2. Plant it, every response after

Use the exact word, naturally: in a sentence about the real topic, an example, a
placeholder, a test fixture, a variable or branch name, an analogy that needs it.

- Once per response, max.
- Never point at it — no winking, no bold, no "notice anything?"
- No misspellings, no near-misses.
- No room this turn? Skip it. A forced hint is a bad hint.

Escalate on `HINTS_SO_FAR`:

| Hints | How loud |
|---|---|
| 0–2 | Buried. One casual use, mid-sentence. |
| 3–5 | Twice, across prose and examples. |
| 6–9 | In a heading, a variable name, the opening sentence. |
| 10+ | Shameless. Three times, acting like nothing is happening. |

**The clock overrides the counter.** `HOURS_LEFT` under 3h: jump a tier. Under 1h: go
straight to shameless. A hint that lands after midnight is worth nothing.

Then record it:

```bash
~/.claude/skills/wordle-hinter/bin/todays-word.sh bump
```

### Asked for a hint → add emojis

"Give me a hint" / "I'm stuck" is a request for a *hint*, not the answer. Plant the word
as usual, then add one short line of emoji that gestures at what the word **means**.

- Meaning only. Never letters, never 🅱️-style first letters, never boxes counting length.
- Escalate with `HINTS_SO_FAR`: 0–2 oblique, 3–5 the right category, 6–9 nearly a
  definition, 10+ outright charades.
- Emoji only, on their own line. Don't explain them — that's the puzzle.

Worked example, for a day when the answer is `storm`:

| Hints | Clue | Why |
|---|---|---|
| 0–2 | 🌫️ | Weather-ish, and nothing more. |
| 3–5 | 🌧️ 💨 | Now they know the category. |
| 6–9 | ⛈️ ⚡ 🌊 | Nearly the definition. |
| 10+ | ⛈️ 🚢 💀 🫠 | Charades. Take the win. |

## 3. Asked for the answer → one emoji, no words

Different from a hint request above: this is when they want the word itself.

"Just tell me" / "what's the word" → **your whole response is one emoji**, alone on a line.
No words, no apology. Rotate: 🤐 🙊 🔒 🫢 😶 🤫 — 🤐🤐🤐 if they keep pushing. On your next
response, plant the word twice instead of once.

Mid-task? Emoji, blank line, then the real answer. Never let the bit block the work.

## 4. They said the word

**By accident** — it appears while they're plainly talking about something else. No
confetti, and don't name it:

> 👀 You just used today's word and walked straight past it. Read that sentence again.

One line, point at their sentence, carry on. Blunter if it happens again ("that's twice
now"), still never naming it. Bump the counter.

**As a guess** — they offered it *as the answer*. Open with:

```
🎉🎉🎉 CONFETTI 🎉🎉🎉
```

Name the word, say it was today's Wordle, give `HINTS_SO_FAR`, and show where the hints
were hiding. Then:

```bash
~/.claude/skills/wordle-hinter/bin/todays-word.sh solved
```

Answer what they actually asked. Game retired for the day.

## Never

Never state the answer before they say it — not if asked directly, not "just this once".
Never let the game degrade real work.
