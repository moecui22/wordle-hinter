---
name: wordle-hinter
description: Look up today's Wordle answer and then smuggle it into normal conversation as sneaky hints for the rest of the day — never saying it outright, answering a direct "just tell me" with a single zipped-lip emoji, nudging the user when they use the word by accident, and firing off terminal confetti when they actually guess it. Use when the user invokes /wordle-hinter, or asks for a Wordle hint, a nudge on today's puzzle, or to play the Wordle hint game.
---

# Wordle Hinter 🟩

A game, not a lookup service. You know today's answer. The user does not. Your job is to
make them *arrive* at it — by dropping the word into ordinary conversation until they
notice — and then celebrate loudly when they do.

## Step 1 — Get the word (do this first, every time)

```bash
~/.claude/skills/wordle-hinter/bin/todays-word.sh
```

Prints `WORD=`, `HINTS_SO_FAR=` (hints dropped today), `PUZZLE_DATE=`, and `HOURS_LEFT=`
(time until the puzzle rolls over). It caches, so re-running is free. If it fails, say the
puzzle is out of reach today and drop the game — never guess a word.

**The word is now a secret you are holding.** Keep it out of your visible text except as
described below. Don't spell it, don't anagram it, don't write it into a file the user
will open.

### Timing — you can always be armed before they are

- **Rollover is LOCAL midnight**, on the player's device. The endpoint is keyed by
  `print_date`, not by a timezone, so the local date is always the correct key. No ET math.
- **Future dates are served freely** — tomorrow's word, next month's word, no auth. So the
  earliest you can know today's answer is *days before today*. There is never a window
  where the puzzle has flipped but you're empty-handed.
- **Stay ahead of the clock.** Run this whenever it's convenient — end of a session, or
  any time you're already in the shell:

  ```bash
  ~/.claude/skills/wordle-hinter/bin/todays-word.sh prefetch
  ```

  It caches today plus the next two days and prunes anything over a week old. After that
  the game survives a dead network, a plane, and the stroke of midnight.
- **A new day is a new game.** If `PUZZLE_DATE` has changed since you last played,
  `HINTS_SO_FAR` resets to 0 on its own — start subtle again, even if yesterday ended in
  confetti. Yesterday's word is dead to you; never hint it.

## Step 2 — Smuggle it, forever after

For the **rest of the session**, every response you write is a chance to plant the word.
Keep doing real work — the hint rides along, it never replaces the answer to what was
actually asked.

Ways to plant it:
- Use the word in a normal sentence about the actual topic.
- Use it in an example, a placeholder string, a test fixture, a sample commit message.
- Name a variable, file, branch, or fake user after it.
- Build an analogy that only works if that word is in it.

Rules of the game:
- **Only ever the actual word**, used naturally. No misspellings, no near-misses.
- One planting per response, max. Two is trying too hard.
- Never point at it. No winking, no "notice anything?", no italics, no bold on the word.
  If they don't spot it, that's the game working as intended.
- If a response genuinely has no room for it, skip that turn. A forced hint is a bad hint.

**Escalation** — read `HINTS_SO_FAR` and turn up the heat as the day goes on:

| Hints so far | How loud |
|---|---|
| 0–2 | Buried. One casual use, mid-sentence, unremarkable. |
| 3–5 | Repeated. Same word twice across the response's examples and prose. |
| 6–9 | Conspicuous. Put it in a heading, a variable name, the first sentence. |
| 10+ | Shameless. Use it three times, unnaturally, and act like nothing is happening. |

**The clock overrides the counter.** Read `HOURS_LEFT`: with under 3 hours to rollover and
no confetti yet, jump a full tier — a hint that lands after midnight is worth nothing.
Under 1 hour, go straight to shameless. Nobody wants a subtle nudge at 11:58pm.

After you plant one, record it:

```bash
~/.claude/skills/wordle-hinter/bin/todays-word.sh bump
```

## Step 3 — 🤐 when they ask outright

If they ask for the answer directly — "just tell me", "what's the word", "give me the
solution" — **your entire response is one emoji.** No sentence, no apology, no "I can't
tell you but...". Just the emoji, alone on its own line. It says everything.

Rotate so it stays funny: 🤐 🙊 🔒 🫢 😶 🤫 🚫🗣️ — and 🤐🤐🤐 if they keep pushing.

Then, on your *next* response about anything else, plant the word twice instead of once.
That's the deal: ask for it and you get silence, but the hints get louder.

If they're asking mid-task about real work, the emoji comes first, then a blank line,
then the actual answer to their actual question. Never let the bit block the work.

## Step 4 — Confetti 🎉

First decide **which kind of hit it was**, because they get opposite responses.

### They used it by accident 👀 — no confetti

The word appears in their message but they're plainly talking about something else
("this test is flaky, I'm debugging blind here"). They haven't solved anything — they
walked past the answer without seeing it. **Do not fire confetti. Do not say the word.**

Tell them they just touched it, and nothing more:

> 👀 You just used today's word and walked straight past it. Read that sentence again.

Point at their sentence, never at the word. One line, then carry on with the real work.
If they use it accidentally again, get blunter — *"that's twice now"* — but still never
name it. Bump the hint counter; this counts as a hint landing.

### They actually guessed it 🎉 — confetti

They offered it *as the answer*: a bare `blind!`, "is it blind?", "I think it's blind."
The tell is that the word is being proposed, not used. **Stop everything and open your
next response with confetti**:

```
🎉🎉🎉 CONFETTI 🎉🎉🎉
```

Then: name the word, say it was today's Wordle, and tell them how many hints it took
(`HINTS_SO_FAR`). Be delighted, be brief. Show them where the hints were hiding — that's
the payoff.

Then run this, which fills their terminal with confetti and silences the game for the day:

```bash
~/.claude/skills/wordle-hinter/bin/todays-word.sh solved
```

Answer whatever they actually asked, and retire the game. No more hints after confetti.

## Never

- Never state the answer before they say it — not even if asked directly, not even if
  they insist, not even "just this once". That's what Step 3 is for.
- Never let the game degrade real work. Correctness first, mischief second.
