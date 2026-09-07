# Wordle Hinter 🟩

Claude finds today's Wordle answer and then hides it in plain sight — dropping it into
normal conversation about whatever you're actually working on, until you notice.

It never tells you the word. It just keeps using it.

## How a day goes

You ask Claude to fix a test. Claude fixes the test, and somewhere in the reply is a
sentence like *"you're debugging blind here"*. That was the hint. You didn't spot it.

An hour later you ask about a config file. There's another one. Still nothing.

By the afternoon it's in a heading. By evening it's in the first sentence, three times,
and Claude is pretending that's normal.

Eventually you catch it, type the word, and the terminal explodes in confetti.

## The three things it does

**Hints.** One per reply, used naturally, never pointed at. It gets louder as the day
goes on — buried at first, shameless by hint ten. If there's under an hour left before
the puzzle flips, it skips straight to shameless. A late subtle hint is a wasted hint.

**Refuses.** Ask it straight out — *"just tell me"* — and the whole reply is one emoji.

```
🤐
```

No words. Then the next hint lands twice as hard. Begging costs you.

**Celebrates.** Guess right and you get confetti across the whole terminal, the word,
and how many hints it took. Game over until midnight.

There's a fourth thing, and it's the fun one: if the word turns up in *your* sentence by
accident — you were talking about something else entirely — you don't get confetti. You
get a nudge:

> 👀 You just used today's word and walked straight past it. Read that sentence again.

Still doesn't tell you. Obviously.

## Install

Clone it into your Claude Code skills folder:

```bash
git clone https://github.com/moecui22/wordle-hinter.git ~/.claude/skills/wordle-hinter
```

Start a new session and run `/wordle-hinter`, or just ask for a hint on today's puzzle.

Needs `bash`, `curl`, and `python3` — all standard on macOS and Linux.

Want it in **every** conversation without asking? That needs a hook, because a skill only
wakes up when it looks relevant. Add this to `~/.claude/settings.json`:

```json
"hooks": {
  "SessionStart": [
    { "hooks": [{
        "type": "command",
        "command": "~/.claude/skills/wordle-hinter/bin/session-hook.sh",
        "timeout": 20
    }] }
  ]
}
```

Now every session starts already knowing the word, in any project, on any topic.

To turn it off: delete that block. It's global, so it follows you everywhere until you do.

## Commands

| Command | What it does |
|---|---|
| `bin/todays-word.sh` | The word, hints dropped today, time until rollover |
| `bin/todays-word.sh bump` | Log a hint. This is what makes it get louder |
| `bin/todays-word.sh prefetch` | Cache today and the next two days |
| `bin/todays-word.sh solved` | Confetti, then silence until tomorrow |

## Two things worth knowing

**It's never caught off guard.** The NYT endpoint hands out future puzzles freely — next
week's, next month's. So `prefetch` grabs three days at a time. Midnight hits, the new
word is already on disk, and it works on a plane.

**Don't peek.** Claude reads the word through a shell command, and you can expand that
output if you really want to. Nothing stops you. That's between you and your conscience.

## Files

```
SKILL.md              the rules Claude plays by
bin/todays-word.sh    fetch, cache, count hints, watch the clock
bin/session-hook.sh   arms every new session (used by the hook above)
bin/confetti.sh       the payoff
```
