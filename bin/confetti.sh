#!/usr/bin/env bash
# Fills the whole terminal with falling confetti, then restores the screen.
# Called by `todays-word.sh solved`. Degrades to a single line if the terminal
# is not interactive (a hook, a pipe, CI) so it never garbles captured output.
set -uo pipefail

WORD="${1:-}"

# Not a real terminal? Say it in one line and leave.
if [ ! -t 1 ]; then
  echo "🎉 CONFETTI — ${WORD:-solved}!"
  exit 0
fi

COLS=$(tput cols 2>/dev/null || echo 80)
ROWS=$(tput lines 2>/dev/null || echo 24)
FRAMES=${FRAMES:-24}
DENSITY=$(( COLS / 6 + 3 ))

cleanup() { tput cnorm 2>/dev/null; tput rmcup 2>/dev/null; }
trap cleanup EXIT INT TERM

tput smcup 2>/dev/null   # alternate screen — the real screen comes back untouched
tput civis 2>/dev/null   # hide cursor

python3 - "$COLS" "$ROWS" "$FRAMES" "$DENSITY" "$WORD" <<'PY'
import random, sys, time

cols, rows, frames, density = (int(a) for a in sys.argv[1:5])
word = sys.argv[5].upper()

PIECES = ["🎉", "🎊", "✨", "🟩", "🟨", "⬜"]
# Each flake: [column, row, glyph, fall speed]
flakes = [[random.randrange(cols), random.uniform(-rows, 0),
           random.choice(PIECES), random.uniform(0.6, 1.6)]
          for _ in range(density * 3)]

banner = f"  {word}  " if word else "  🎉  "
b_row, b_col = rows // 2, max(0, (cols - len(banner)) // 2)

for f in range(frames):
    grid = [[" "] * cols for _ in range(rows)]
    for flake in flakes:
        c, r = flake[0], int(flake[1])
        if 0 <= r < rows and 0 <= c < cols:
            grid[r][c] = flake[2]
        flake[1] += flake[3]
        if flake[1] > rows:                 # recycle off the top
            flake[1] = random.uniform(-4, 0)
            flake[0] = random.randrange(cols)
            flake[2] = random.choice(PIECES)

    out = ["\x1b[H"]                        # home, no clear — avoids flicker
    for r, line in enumerate(grid):
        row = "".join(line)
        if r == b_row and word:
            row = row[:b_col] + f"\x1b[1;97;42m{banner}\x1b[0m" + row[b_col + len(banner):]
        out.append(row + "\x1b[K\n")
    sys.stdout.write("".join(out))
    sys.stdout.flush()
    time.sleep(0.055)
PY

cleanup
trap - EXIT INT TERM
echo "🎉 ${WORD:-The word} — solved."
