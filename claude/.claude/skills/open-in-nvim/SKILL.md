---
name: open-in-nvim
description: Open a file in neovim in a new kitty panel (vertical split) at a specific line number. Use when the user asks to "open X in vim", "pop open a file", "show me line N of X in a new panel", or otherwise wants to jump to a file/line in a side editor while staying in the Claude Code session.
metadata:
  scope: user
  category: workflow
---

# Open in nvim (kitty panel)

Opens a file in neovim inside a new kitty window (vertical split of the current tab), optionally jumping to a specific line.

## Requirements (already set up)

- `allow_remote_control yes` in `~/.config/kitty/kitty.conf`
- `listen_on unix:/tmp/mykitty-{kitty_pid}` in `~/.config/kitty/kitty.conf`
- `$KITTY_LISTEN_ON` is set in the environment Claude Code is running in (kitty exports this automatically when `listen_on` is configured)

If `$KITTY_LISTEN_ON` is unset, the user hasn't restarted kitty since the config change — tell them to restart kitty and retry.

## Command

Run via the Bash tool:

```bash
kitty @ launch --type=window --location=vsplit --cwd=current --no-response nvim "+<LINE>" "<ABSOLUTE_FILE_PATH>"
```

If no line number is requested, omit the `+<LINE>` arg:

```bash
kitty @ launch --type=window --location=vsplit --cwd=current --no-response nvim "<ABSOLUTE_FILE_PATH>"
```

## Rules

- **Always pass an absolute path** to the file. `--cwd=current` sets the new window's cwd, but nvim resolves the file arg against the spawned shell's cwd, so absolute paths avoid surprises.
- **Quote the file path** (it may contain spaces).
- Use `--no-response` so the command returns immediately.
- Do not use `--type=tab` or `--type=os-window` — the default is `vsplit` in the current tab, per the user's preference.
- If the command exits non-zero, read stderr and report it. The most common failures:
  - `$KITTY_LISTEN_ON` unset → kitty needs to be restarted after the config change
  - `Permission denied` on the socket → another user's kitty, or stale socket; reconnect

## Examples

User says: *"open src/foo.py at line 42"*
→ `kitty @ launch --type=window --location=vsplit --cwd=current --no-response nvim "+42" "/Users/rgeary/src/.../src/foo.py"`

User says: *"pop open the config file"*
→ `kitty @ launch --type=window --location=vsplit --cwd=current --no-response nvim "/Users/rgeary/.../config.yaml"`
