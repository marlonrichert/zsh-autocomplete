zmodload -i zsh/complist

setopt EXTENDED_GLOB
setopt GLOB_COMPLETE
setopt GLOB_DOTS
setopt NO_CASE_GLOB

unsetopt AUTO_CD
unsetopt BEEP

export FZF_COMPLETION_TRIGGER=''
export FZF_CTRL_R_OPTS="--height=40% --layout=default --no-multi"
export fzf_default_completion='list-more'
export FZF_TMUX_HEIGHT=$(( ${LINES} - 2 ))
export FZF_DEFAULT_OPTS="--height=$FZF_TMUX_HEIGHT -i --bind=ctrl-space:abort,ctrl-k:kill-line \
  --exact --info=inline --layout=reverse --multi --tiebreak=length,begin,end"

zstyle ':completion:*' add-space file
zstyle ':completion:*' completer _expand _complete _ignored
zstyle ':completion:*' ignored-patterns '(*/)#.*' '[_+]*' '[[:punct:]]zinit-*'
zstyle ':completion:*' matcher-list '' 'r:|?=**' '+m:{[:lower:]}={[:upper:]}'
zstyle ':completion:*:z:*' file-patterns '%p(-/):directories'
zstyle ':completion:*:options' ignored-patterns ''
zstyle ':completion:*:widgets' matcher 'l:?|=**'

zstyle ':completion:complete-word:*' menu 'auto select'

zstyle ':completion:correct-word:*' accept-exact true
zstyle ':completion:correct-word:*' completer _complete _correct
zstyle ':completion:correct-word:*' matcher-list ''
zstyle ':completion:correct-word:*:options' ignored-patterns '*'

zstyle ':completion:(correct-word|list-choices):*' \
  tag-order '! urls hosts repositories local-repositories remote-repositories' '-'
  zstyle ':completion:(correct-word|list-choices):*:brew:*' tag-order '-'

zstyle ':completion:list-choices:expand:*' glob false
zstyle -e ':completion:list-choices:*' tag-order '
  if [[ $PREFIX == "(-|--)" ]]; then
    reply=( "options argument-rest" "-" )
  else
    reply=( "" )
  fi'

zstyle ':completion:list-more:*' format '%F{yellow}%d%f'
zstyle ':completion:list-more:*' group-name ''
zstyle ':completion:list-more:*' matcher-list 'r:|?=** m:{[:lower:]}={[:upper:]}'
zstyle ':completion:list-more:*' menu 'select=long-list'

typeset -g -A key
#Application mode bindings
key[KeyUp]='^[OA'
key[KeyDown]='^[OB'
key[KeyRight]='^[OC'
key[KeyLeft]='^[OD'
#Raw mode bindings
key[CursorUp]='^[[A'
key[CursorDown]='^[[B'
key[CursorRight]='^[[C'
key[CursorLeft]='^[[D'
key[Return]='^M'
key[LineFeed]='^J'
key[Tab]='^I'
key[ShiftTab]='^[[Z'
key[ControlSpace]='^@'
key[DeleteList]='^D'
key[ListChoices]='^[^D'
key[Undo]='^_'
if [[ $( bindkey -lL main ) == *viins* ]]
then
  key[ListChoices]='^D'
  key[Undo]='u'
fi

bindkey ' ' magic-space
bindkey '^[ ' self-insert-unmeta
bindkey "${key[Tab]}" complete-word
bindkey "${key[ShiftTab]}" list-more
bindkey "${key[ControlSpace]}" expand-or-fuzzy-find

bindkey "${key[CursorUp]}" up-line-or-fuzzy-history
bindkey "${key[KeyUp]}" up-line-or-fuzzy-history
bindkey "^[${key[KeyUp]}" fzf-history-widget
bindkey "^[${key[CursorUp]}" fzf-history-widget
bindkey "${key[KeyDown]}" down-line-or-menu-select
bindkey "${key[CursorDown]}" down-line-or-menu-select
bindkey "^[${key[KeyDown]}" menu-select
bindkey "^[${key[CursorDown]}" menu-select

# Completion menu behavior
bindkey -M menuselect "${key[Tab]}" accept-and-hold
bindkey -M menuselect -s "${key[Return]}" "${key[LineFeed]}${key[ListChoices]}"
bindkey -M menuselect -s "${key[ShiftTab]}" "${key[DeleteList]}${key[Undo]}${key[ShiftTab]}"
bindkey -M menuselect -s "${key[ControlSpace]}" "${key[LineFeed]}${key[ControlSpace]}"

# Wrap existing widgets to provide auto-completion.
local widget
for widget in vi-add-eol vi-add-next backward-delete-char vi-backward-delete-char \
  backward-delete-word backward-kill-line backward-kill-word vi-backward-kill-word \
  capitalize-word vi-change vi-change-eol vi-change-whole-line copy-region-as-kill copy-prev-word \
  copy-prev-shell-word vi-delete delete-char vi-delete-char delete-word down-case-word \
  vi-down-case kill-word gosmacs-transpose-chars vi-indent vi-insert vi-insert-bol vi-join \
  kill-line vi-kill-line vi-kill-eol kill-region kill-buffer kill-whole-line vi-match-bracket \
  vi-open-line-above vi-open-line-below vi-oper-swap-case overwrite-mode vi-put-before \
  vi-put-after put-replace-selection quoted-insert vi-quoted-insert quote-line quote-region \
  vi-replace vi-repeat-change vi-replace-chars self-insert self-insert-unmeta vi-substitute \
  vi-swap-case transpose-chars transpose-words vi-unindent vi-up-case up-case-word yank yank-pop \
  vi-yank vi-yank-whole-line vi-yank-eol
do
  eval "zle -N $widget
  $widget() {
    zle .$widget
    zle list-choices
  }"
done

zle -N magic-space
magic-space() {
  zle correct-word
  zle .magic-space
  zle list-choices
}

zle -N complete-word
complete-word() {
  local buffer=$BUFFER
  zle _complete_word
  if [[ $buffer != $BUFFER ]]
  then
    zle .auto-suffix-retain
    zle list-choices
  fi
}

zle -N down-line-or-menu-select
down-line-or-menu-select() {
  zle -M ''
  if (( ${#RBUFFER} > 0 && BUFFERLINES > 1 )); then
    zle .down-line || zle .end-of-line
  else
    zle menu-select
  fi
}

zle -N up-line-or-fuzzy-history
up-line-or-fuzzy-history() {
  zle -M ''
  if (( ${#LBUFFER} > 0 && BUFFERLINES > 1 )); then
    zle .up-line || zle .beginning-of-line
  else
    if zle -l fzf-history-widget
    then
      fzf-history-widget
    else
      zle .history-search-backward
    fi
  fi
}

zle -N expand-or-fuzzy-find
expand-or-fuzzy-find() {
  zle -M ''
  local buffer=$BUFFER
  zle _expand_alias
  zle _expand_word
  if [[ $buffer == $BUFFER ]]
  then
    if zle -l fzf-completion
    then
      while [[ $RBUFFER[1] == [[:graph:]] ]]
      do
        zle .forward-word
      done
      FZF_TMUX_HEIGHT=$(( ${LINES} - 2 ))
      FZF_DEFAULT_OPTS=${(S)FZF_DEFAULT_OPTS/--height=* /--height=${FZF_TMUX_HEIGHT} }
      fzf-completion
    else
      zle list-more
    fi
  fi
}

zle -C _complete_word complete-word _complete_word
_complete_word() {
  local curcontext=$( _context complete-word )
  _keep_old_list
  _main_complete $@
  _force_list
}

zle -C menu-select menu-select _menu_select
_menu_select() {
  local curcontext=$( _context menu-select )
  _keep_old_list
  _main_complete $@
  _force_list
}

_keep_old_list() {
  if [[ -v compstate[old_list] ]]
  then
    compstate[old_list]=keep
  fi
}

_force_list() {
  if (( ${#compstate[old_list]} == 0 ))
  then
    compstate[insert]=''
    compstate[list]='list force'
  fi
}

zle -C correct-word complete-word _correct_word
_correct_word() {
  local current_word=$SUFFIX$PREFIX
  if (( CURRENT > 1 || ${#words[1]} > 0 || ${#current_word} > 0 ))
  then
    local curcontext=$( _context correct-word )
    _main_complete $@
  fi
}

zle -C list-choices list-choices _list_choices
_list_choices() {
  if (( PENDING == 0 && KEYS_QUEUED_COUNT == 0 ))
  then
    local current_word=$SUFFIX$PREFIX
    if (( CURRENT > 1 || ${#words[1]} > 0 || ${#current_word} > 0 ))
    then
      local curcontext=$( _context list-choices )
      _main_complete $@
      if (( (compstate[list_lines] + BUFFERLINES + 1) > LINES
         || ( compstate[list_max] != 0 && compstate[nmatches] > compstate[list_max] ) ))
      then
        compstate[list]=
      fi
    fi
    if (( ${#compstate[list]} == 0 ))
    then
      zle -M ''
    fi
    # zle -M "$CURRENT ${#words[1]} ${#current_word} ${compstate[list_lines]} ${compstate[nmatches]}"
  fi
}

zle -C list-more list-choices list_more
list_more() {
  local curcontext=$( _context list-more )
  _main_complete $@
}

_context() {
  local curcontext="${curcontext:-}"
  if [[ -z "$curcontext" ]]; then
    curcontext="$1:::"
  else
    curcontext="$1:${curcontext#*:}"
  fi
  echo $curcontext
}
