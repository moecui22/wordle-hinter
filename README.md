<p align="center">
  <img src="./logo.svg" alt="Wordle Hinter" width="140" />
</p>
<p align="center">
  <strong>Claude hides today's Wordle answer in ordinary conversation until you spot it.</strong>
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

All of this happens while Claude does your actual work. The game never gets in the way of
the answer.

- 🟩 **It hints** → the word slips into a normal reply, once each time, never bolded and
  never winked at. Gets louder as the day goes: buried at first, shameless by hint ten.

- 🤐 **It refuses** → ask outright and the entire reply is one emoji. No words, no apology.
  Then the next hint lands twice as hard. Begging costs you.

- 🎉 **It celebrates** → guess it and confetti fills the terminal. Use it by accident and
  you only get a nudge — you didn't earn confetti, and it still won't name the word.

The clock matters too. With under an hour before the puzzle flips, the hints stop being
subtle — a clever nudge at 11:58pm is a wasted one. Midnight resets everything: new word,
counter back to zero, and yesterday's answer is never mentioned again.

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
