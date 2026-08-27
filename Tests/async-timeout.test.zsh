#!/bin/zsh -f
# Simulates a completion attempt that never finishes (the async worker times
# out), and checks that:
# (1) the timed-out state's cooldown suppresses retrying that same
#     completion attempt, but
# (2) completion for a different command-line state is unaffected.
#
# This runs as a plain zsh script, not a clitest transcript, because it
# exercises timing-based state transitions (start an attempt, let it "time
# out", assert on what happens after), rather than a fixed sequence of
# commands with literal expected output.

cd -- ${0:A:h:h}
source Tests/__init__.zsh > /dev/null

typeset -gi failures=0
fail() {
  print -u2 -- "FAIL: $1"
  (( failures++ ))
}

.autocomplete__async

typeset -gi _autocomplete__started=0
typeset -g _autocomplete__started_reply=

# Mock out `zasync`: `start complete ...` just records that a completion
# attempt started, and `reply complete` returns whatever the test primed as the
# (simulated) worker's result.
zasync() {
  case $1 in
  start )
    [[ $2 == complete ]] && (( _autocomplete__started++ ))
  ;;
  reply )
    [[ $2 == complete ]] && print -r -- $_autocomplete__started_reply
  ;;
  cancel ) ;;
  esac
}

typeset -gi YANK_ACTIVE=0 KEYS_QUEUED_COUNT=0 PENDING=0
typeset -ga _autocomplete__ctxt_opts=( completealiases completeinword )
typeset -g _autocomplete__ps4=
typeset -g _autocomplete__log=/dev/null
typeset -ga _autocomplete__region_highlight=()
_lastcomp[list]=

# --- A completion attempt that never ends must not be retried while its
# cooldown is active. ---

curcontext='foo:::' LBUFFER='comp' RBUFFER=''
.autocomplete__async-save-state

.autocomplete:async:wait:callback
(( _autocomplete__started == 1 )) ||
    fail "first attempt for a new state should start completion (started=$_autocomplete__started)"

# Simulate the worker never finishing: `zasync reply complete` reports the
# `timeout` sentinel, same as `.autocomplete:async:start:inner` prints when its
# pty deadline expires.
_autocomplete__started_reply=timeout
.autocomplete:async:complete:callback

# Retrying the exact same command-line state must be suppressed by the
# cooldown recorded above, so completion must never be reattempted for it.
.autocomplete:async:wait:callback
(( _autocomplete__started == 1 )) ||
    fail "retrying the same, still-cooling-down state should not start completion again (started=$_autocomplete__started)"

.autocomplete:async:wait:callback
(( _autocomplete__started == 1 )) ||
    fail "repeated retries of the same state should still be suppressed (started=$_autocomplete__started)"

# Other completion attempts, for different command-line state, must still work.

curcontext='bar:::' LBUFFER='other' RBUFFER=''
.autocomplete__async-save-state

.autocomplete:async:wait:callback
(( _autocomplete__started == 2 )) ||
    fail "a different command-line state must still start completion (started=$_autocomplete__started)"

_autocomplete__started_reply=3
.autocomplete:async:complete:callback

curcontext='bar:::' LBUFFER='other' RBUFFER=''
.autocomplete__async-save-state
.autocomplete:async:wait:callback
(( _autocomplete__started == 3 )) ||
    fail "a state that previously completed normally (not timed out) must still be retried (started=$_autocomplete__started)"

if (( failures )); then
  print -u2 -- "$failures failure(s)"
  exit 1
fi
print ok
