# z-async

A minimal, correct async framework for [Zsh Line Editor (ZLE)](https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html).

`z-async` is an autoloadable functin that lets you run a shell command in the background and get notified via a ZLE widget when the output is ready — no subshells, no polling, no stale results.

## Features

- **Slot-based cancellation** — starting a new job for a slot automatically cancels any previous in-flight job for that slot.
- **Stale-result protection** — results are discarded if the directory changed between launch and delivery.
- **Sequence-number ordering** — only the most recently started job per slot can deliver results; earlier jobs that finish late are silently dropped.
- **Yank/kill-safe** — the ZLE flag passed at delivery time is compatible with active yank and kill widget sequences.


## Requirements

- Zsh 5.0 or later (uses `sysopen` and `zle -Fw`)


### Commands

| Command | Description |
|---|---|
| `start <slot> <worker> <cb>` | Run `<worker>` asynchronously; call ZLE widget `<cb>` when done. |
| `cancel <slot>` | Cancel any in-flight job for `<slot>`. |
| `reply <slot>` | Print the most recent output received for `<slot>`. |
| `help [command]` | Show help for all commands or a single `<command>`. |


### Parameters

| Parameter | Description |
|---|---|
| `slot` | A name that uniquely identifies this background job. Starting a new job with the same slot cancels the previous one. |
| `worker` | A command or function to run asynchronously. Its stdout is captured and stored. |
| `cb` | The name of a ZLE widget to invoke when the worker finishes. Inside the widget, call `z-async reply <slot>` to retrieve the output. |


### Example

```zsh
# Define a worker function
_my_worker() {
  git rev-parse --abbrev-ref HEAD 2>/dev/null
}

# Define a ZLE widget to receive the result
_my_callback() {
  local branch
  branch=$(z-async reply git-branch)
  # update your prompt, etc.
  zle reset-prompt
}
zle -N _my_callback

# Source z-async, then kick off the first job
z-async start git-branch _my_worker _my_callback

# Re-trigger on every prompt
precmd() {
  z-async start git-branch _my_worker _my_callback
}
```


### Global variables

`z-async` stores state in associative arrays prefixed with `_zasync_`. These are internal and subject to change; do not rely on them directly — use `z-async reply` instead.


## Author & License

See the [LICENSE](LICENSE) file for details.
