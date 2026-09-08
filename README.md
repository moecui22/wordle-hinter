<p align="center">
  <img src="./logo.svg" alt="Wordle Hinter" width="140" />
</p>
<p align="center">
  <strong>Claude hints by using the Wordle word of the day, whenever you need one.</strong>
</p>
<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/github/license/moecui22/wordle-hinter?style=flat" alt="License"></a>
  <img src="https://img.shields.io/badge/Claude%20Code-skill-6aaa64?style=flat" alt="Claude Code skill">
</p>

# Wordle Hinter

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

Claude keeps doing your real work. The hints ride along.

- 🟩 **Hints** — the word appears once per reply, used normally. Never bolded, never
  pointed at. Ask for a hint outright and you also get emoji clues — 🌫️ at first,
  ⛈️ ⚡ 🌊 once you're clearly struggling. Hints get louder through the day.

- 🤐 **Refuses** — ask for the answer and you get one emoji. No words. The next hint is
  louder still.

- 🎉 **Celebrates** — guess right and confetti fills the terminal. Use the word by
  accident and you get a nudge instead.

In the last hour before the puzzle changes, hints stop being subtle. At midnight
everything resets: new word, count back to zero.

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
