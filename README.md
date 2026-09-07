# Wordle Hinter 🟩

Claude looks up today's Wordle answer, then hides it in normal conversation about
whatever you're actually working on — until you notice.

It never tells you the word. It just keeps using it.

## Install

```bash
git clone https://github.com/moecui22/wordle-hinter.git ~/.claude/skills/wordle-hinter
```

Start a new session and run `/wordle-hinter`, or just ask for a hint.

Needs `bash`, `curl`, and `python3`.

## What it does

**Hints** — once per reply, used naturally, never pointed at. Gets louder as the day goes:
buried at first, shameless by hint ten. Under an hour left? Straight to shameless.

**Refuses** — ask it outright and the entire reply is `🤐`. No words. Then the next hint
lands twice as hard.

**Nudges** — if the word turns up in *your* sentence by accident, no confetti. Just:

> 👀 You just used today's word and walked straight past it. Read that sentence again.

**Celebrates** — guess it properly and the terminal fills with confetti.

## Every conversation, not just this one

A skill only wakes up when it looks relevant. For all-day hinting, add a hook to
`~/.claude/settings.json`:

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

Delete the block to turn it off. It's global — it follows you into every project.

## Commands

| Command | What it does |
|---|---|
| `bin/todays-word.sh` | The word, hints so far, time until rollover |
| `bin/todays-word.sh bump` | Log a hint — this is what makes it escalate |
| `bin/todays-word.sh prefetch` | Cache today and the next two days |
| `bin/todays-word.sh solved` | Confetti, then silence until tomorrow |

## Don't peek

Claude reads the word through a shell command, and you can expand that output if you
really want to. Nothing stops you. That's between you and your conscience.

MIT
