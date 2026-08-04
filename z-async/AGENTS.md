# Agent Guidelines for z-async

This file provides guidance for AI coding agents (GitHub Copilot, Claude, etc.) working on this repository.


## Project overview

- `z-async` is a Zsh library that provides asynchronous job management for the Zsh Line Editor (ZLE).
- It uses `sysopen` and `zle -Fw` to watch file descriptors without blocking the interactive shell.
- It is not a plugin.


## Repository layout

```
z-async          # The entire library so far: one autoloadable Zsh function
LICENSE          # MIT license
README.md        # User-facing documentation
CONTRIBUTING.md  # Instructions for developers
AGENTS.md        # This file
.gitignore       # Excludes *.zwc (Zsh compiled files)
```


## Architecture

All state is held in module-private associative arrays (`_zasync_*`):

| Array | Key | Value |
|---|---|---|
| `_zasync_fd` | slot | current open fd for that slot |
| `_zasync_seq` | slot | sequence number of the last-started job |
| `_zasync_fd_slot` | fd | owning slot name |
| `_zasync_fd_seq` | fd | sequence number at launch |
| `_zasync_fd_pwd` | fd | `$PWD` at launch |
| `_zasync_fd_cb` | fd | callback ZLE widget name |
| `_zasync_reply` | slot | most-recent raw output from worker |

The internal counter `_zasync_n` (integer) is incremented each time a job is started and used as a sequence number to detect and discard stale results.

Public entry point: `z-async <command> [args]` — dispatches to `.zasync.<command>()`.


## Style guide

- Visually align table columns in Markdown code. Devs will often read the raw Markdown instead of the rendered page.


## Workflow — after any change

- Ensure your changes are covered by tests.
- Keep the `.md` files in the root in sync with each other and with the project state. Each file owns distinct content:
   - `AGENTS.md` — instructions for AI agents
   - `CONTRIBUTING.md` — instructions for human developers
   - `README.md` — instructions for end users
- Update `AGENTS.md` with any new pitfalls encountered during this session.


## Pitfalls to avoid

TODO
