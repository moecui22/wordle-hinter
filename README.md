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

- 🟩 **You just chat normally** → the word slips into the reply. In a sentence, an example,
  a variable name, a test fixture. Once per reply, never bolded, never winked at.

- 📈 **The day wears on** → hints get louder. Buried at first, twice per reply by hint
  three, in a heading by hint six, shameless by ten.

- ⏰ **Midnight gets close** → the clock beats the counter. Under three hours it jumps a
  tier, under one hour it goes straight to shameless. A hint after midnight is worthless.

- 🤐 **You ask outright** → the entire reply is one emoji. No words, no apology. And the
  next hint lands twice as hard. Begging costs you.

- 👀 **You use the word by accident** → no confetti, you didn't earn it. Just a nudge:
  *"You just used today's word and walked straight past it."* It still won't name it.

- 🎉 **You guess it properly** → confetti fills the terminal, and Claude finally shows you
  every place the word was hiding all day.

- 🌙 **Tomorrow** → new word, counter back to zero, subtle again. Yesterday's answer is
  dead to it.

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
