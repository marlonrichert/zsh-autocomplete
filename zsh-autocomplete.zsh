() {
  emulate -LR zsh -o noshortloops -o warncreateglobal

  typeset -g _autocomplete__lastwarning
  [[ ! -v _autocomplete__options ]] && export _autocomplete__options=(
    ALWAYS_TO_END COMPLETE_ALIASES EXTENDED_GLOB GLOB_COMPLETE GLOB_DOTS LIST_PACKED
    no_CASE_GLOB no_COMPLETE_IN_WORD no_LIST_BEEP
  )

  [[ ! -v functions ]] && zmodload -i zsh/parameter
  [[ ! -v functions[add-zsh-hook] ]] && autoload -Uz add-zsh-hook

  # Intercept `_zsh_autosuggest_start`.
  functions[_autocomplete.add-zsh-hook]=$functions[add-zsh-hook]
  add-zsh-hook() {
    emulate -LR zsh -o noshortloops -o warncreateglobal

    if [[ ${@[(ie)_zsh_autosuggest_start]} -gt ${#@} ]]
    then
      _autocomplete.add-zsh-hook "$@" > /dev/null
    fi
  }

  add-zsh-hook precmd _autocomplete.main.hook
}

_autocomplete.main.hook() {
  emulate -LR zsh -o noshortloops -o warncreateglobal

  # Remove itself after being called.
  add-zsh-hook -d precmd _autocomplete.main.hook

  # Intercept `zsh-autosuggestions` and syntax highlighting.
  add-zsh-hook -d precmd _zsh_autosuggest_start
  _autocomplete.no-op() {}
  if [[ -v functions[_zsh_highlight] ]]
  then
    functions[_autocomplete._zsh_highlight]=$functions[_zsh_highlight]
    functions[_zsh_highlight]=$functions[_autocomplete.no-op]
  else
    functions[_autocomplete._zsh_highlight]=$functions[_autocomplete.no-op]
  fi
  if [[ ! -v functions[_zsh_autosuggest_fetch] ]]
  then
    functions[_zsh_autosuggest_fetch]=$functions[_autocomplete.no-op]
  fi

  # Initialize completion system, if it hasn't been done yet.
  # `zsh/complist` should be loaded _before_ `compinit`.
  if ! (zle -l menu-select && bindkey -l menuselect > /dev/null)
  then
    zmodload -i zsh/complist
    autoload -Uz compinit
    compinit
  elif ! [[ -v compprefuncs && -v comppostfuncs ]]
  then
    autoload -Uz compinit
    compinit
  fi

  [[ ! -v ZLE_REMOVE_SUFFIX_CHARS ]] && export ZLE_REMOVE_SUFFIX_CHARS=$' \t\n;&'
  export ZSH_AUTOSUGGEST_USE_ASYNC=1
  export ZSH_AUTOSUGGEST_MANUAL_REBIND=1
  [[ ! -v ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS ]] \
  && typeset -g -a ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS=(
    forward-char vi-forward-char vi-find-next-char vi-find-next-char-skip
    forward-word emacs-forward-word
    vi-forward-word vi-forward-word-end vi-forward-blank-word vi-forward-blank-word-end
	)
  [[ ! -v FZF_COMPLETION_TRIGGER ]] && export FZF_COMPLETION_TRIGGER=''
  [[ ! -v fzf_default_completion ]] && export fzf_default_completion='list-expand'
  [[ ! -v FZF_DEFAULT_OPTS ]] && export FZF_DEFAULT_OPTS='--bind=ctrl-space:abort,ctrl-k:kill-line'

  [[ ! -v functions[zstyle] ]] && zmodload -i zsh/zutil

  local -a option_tags=( '(|*-)argument-* (|*-)option[-+]* values' 'options' )

  # Remove incompatible styles.
  zstyle -d '*' single-ignored

  zstyle ':completion:*' completer _oldlist _list _expand_alias _expand _complete _match _ignored
  zstyle ':completion:*' menu 'yes select=long-list'
  zstyle ':completion:*' matcher-list 'm:{[:lower:]-}={[:upper:]_} r:|?=**'
  zstyle -e ':completion:*:complete:*' ignored-patterns '
    local currentword=$PREFIX$SUFFIX
    if (( ${#currentword} == 0 ))
    then
      reply=( "[[:punct:]]*" )
    else
      if [[ $currentword == [[:punct:]]* ]]
      then
        local punct=${(M)currentword##[[:punct:]]##}
        local nextchar=${currentword[${#punct}+1]}
        reply=( "[[:punct:]]${punct}*" "^(*${punct}${nextchar}*)" )
      else
        reply=( "(?~${currentword[1]})*" )
      fi
    fi'
  zstyle -e ':completion:*' glob '
    [[ $PREFIX$SUFFIX == *[\*\(\|\<\[\?\^\#]* ]] && reply=( "true" ) || reply=( "false" )'

  zstyle -e ':completion:*' tag-order '
    reply=( '${(qq@)option_tags}' )
    if [[ $PREFIX$SUFFIX != [-+]* ]]
    then
      reply+=(
        "! commit-tags *remote*"
        "commit-tags" )
    fi
    reply+=( "-" )'
  zstyle ':completion:*:expand:*' tag-order '! all-expansions original'

  [[ ! -v functions[min] ]] && autoload -Uz zmathfunc && zmathfunc
  zstyle -e ':completion:*' max-errors '
    reply=( $(( min(2, (${#PREFIX} + ${#SUFFIX}) / 3) )) numeric )'

  zstyle ':completion:*' expand prefix suffix
  zstyle ':completion:*' list-suffixes false
  zstyle ':completion:*' path-completion false
  zstyle ':completion:*:(-command-|cd|z):*' list-suffixes true
  zstyle ':completion:*:(-command-|cd|z):*' path-completion true

  zstyle ':completion:*' file-patterns \
    '*(#q^-/):all-files:file *(-/):directories:directory' '%p:globbed-files:"file or directory"'
  zstyle ':completion:*:-command-:*' file-patterns \
    '*(-/):directories:directory %p(#q^-/):globbed-files:executable' '*:all-files:file'
  zstyle ':completion:*:z:*' file-patterns '%p(-/):directories:directory'

  local directory_tags=( local-directories directory-stack named-directories directories )
  zstyle ':completion:*' group-order all-files directories globbed-files
  zstyle ':completion:*:-command-:*' group-order globbed-files directories all-files
  zstyle ':completion:*:(all-files|globbed-files)' group-name ''
  zstyle ':completion:*:('${(j:|:)directory_tags}')' group-name 'directories'
  zstyle ':completion:*:('${(j:|:)directory_tags}')' matcher 'm:{[:lower:]}={[:upper:]}'

  if zstyle -t ':autocomplete:' groups 'always'
  then
    zstyle ':completion:*' format '%F{yellow}%d:%f'
    zstyle ':completion:*' group-name ''
  fi

  zstyle ':completion:*:aliases' format '%F{yellow}%d:%f'
  zstyle ':completion:*:aliases' group-name ''
  zstyle ':completion:*:corrections' format '%F{green}%d:%f'
  zstyle ':completion:*:expansions' format '%F{yellow}%d:%f'
  zstyle ':completion:*:expansions' group-name ''
  zstyle ':completion:*:messages' format '%F{yellow}%d%f'
  zstyle ':completion:*:original' format '%F{yellow}%d:%f'
  zstyle ':completion:*:warnings' format '%F{red}%D%f'
  zstyle ':completion:*' auto-description '%F{yellow}%d%f'

  zstyle ':completion:*' add-space true
  zstyle ':completion:*' list-separator ''
  zstyle ':completion:*' use-cache true

  zstyle ':completion:(complete-word|menu-select):*' old-list always

  zstyle ':completion:correct-word:*' accept-exact true
  zstyle ':completion:correct-word:*' glob false
  zstyle ':completion:correct-word:*' matcher-list ''
  zstyle ':completion:correct-word:*:git-*:argument-*:*' tag-order '-'

  zstyle ':completion:list-choices:*' old-list never
  zstyle ':completion:list-choices:*' glob false
  zstyle ':completion:list-choices:*' menu ''

  zstyle ':completion:expand-word:*' completer _expand_alias _expand

  zstyle ':completion:list-expand:*' completer _expand _complete _ignored _approximate
  zstyle ':completion:list-expand:complete:*' ignored-patterns ''
  zstyle ':completion:list-expand:*' tag-order ''
  zstyle -e ':completion:list-expand:*' max-errors '
    reply="$(( min(7, (${#PREFIX} + ${#SUFFIX}) / 3) )) numeric"'
  zstyle ':completion:list-expand:*' list-suffixes true
  zstyle ':completion:list-expand:*' path-completion true
  zstyle ':completion:list-expand:*' format '%F{yellow}%d:%f'
  zstyle ':completion:list-expand:*' group-name ''

  if [[ ! -v key ]]
  then
    # This file can be generated with `autoload -U zkbd && zkbd`.
    # See http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#Keyboard-Definition
    if [[ -r ${ZDOTDIR:-$HOME}/.zkbd/${TERM}-${VENDOR} ]]
    then
      source ${ZDOTDIR:-$HOME}/.zkbd/${TERM}-${VENDOR}
    fi

    if [[ ! -v key ]]
    then
      typeset -g -A key
    fi
  fi

  [[ ! -v terminfo ]] && zmodload -i zsh/terminfo
  if [[ -z $key[Up] ]]; then
    if [[ -n $terminfo[kcuu1] ]]; then key[Up]=$terminfo[kcuu1]; else key[Up]='^[OA'; fi
  fi
  if [[ -z $key[Down] ]]; then
    if [[ -n $terminfo[kcud1] ]]; then key[Down]=$terminfo[kcud1]; else key[Down]='^[OB'; fi
  fi
  if [[ -z $key[Tab] ]]; then
    if [[ -n $terminfo[ht] ]]; then key[Tab]=$terminfo[ht]; else key[Tab]='^I'; fi
  fi
  if [[ -z $key[BackTab] ]]; then
    if [[ -n $terminfo[kcbt] ]]; then key[BackTab]=$terminfo[kcbt]; else key[BackTab]='^[[Z'; fi
  fi

  # Make `terminfo` codes work.
  [[ ! -v functions[add-zle-hook-widget] ]] && autoload -Uz add-zle-hook-widget
  add-zle-hook-widget line-init _autocomplete.application-mode.hook
  add-zle-hook-widget line-finish _autocomplete.raw-mode.hook

  # Hard-code these values, because they are not generated by `zkbd` nor defined in `terminfo`.
  if [[ -z $key[Return] ]]; then key[Return]='^M'; fi
  if [[ -z $key[LineFeed] ]]; then key[LineFeed]='^J'; fi
  if [[ -z $key[ControlSpace] ]]; then key[ControlSpace]='^@'; fi
  if [[ -z $key[DeleteList] ]]; then key[DeleteList]='^D'; fi

  local magic

  bindkey ' ' magic-space
  zstyle -s ":autocomplete:space:" magic magic || magic='correct-word'
  case $magic in
    'correct-word')
  zle -N magic-space _autocomplete.magic-space.zle-widget
      ;;
    'expand-history')
      zle -N magic-space .magic-space
      ;;
    *)
      bindkey ' ' self-insert
      ;;
  esac

  bindkey '/' magic-slash
  zstyle -s ":autocomplete:slash:" magic magic || magic='correct-word'
  case $magic in
    'spelling')
  zle -N magic-slash _autocomplete.magic-slash.zle-widget
      ;;
    *)
      bindkey '/' .self-insert
      ;;
  esac

  zle -C correct-word menu-select _autocomplete.correct-word.completion-widget
  zle -C expand-word menu-select _autocomplete.expand-word.completion-widget

  if zle -l fzf-completion && zle -l fzf-cd-widget
  then
    bindkey $key[ControlSpace] expand-or-complete
    zle -N expand-or-complete _autocomplete.expand-or-complete.zle-widget
    bindkey -M menuselect -s $key[ControlSpace] $key[LineFeed]$key[ControlSpace]
  else
    bindkey $key[ControlSpace] expand-word
  fi

  zle -C menu-select menu-select _autocomplete.menu-select.completion-widget
  if zle -l fzf-history-widget
  then
    bindkey $key[Up] up-line-or-history-search
    zle -N up-line-or-history-search _autocomplete.up-line-or-history-search.zle-widget

    bindkey '^['$key[Up] history-search
    zle -N history-search fzf-history-widget

    bindkey $key[Down] down-line-or-menu-select
    zle -N down-line-or-menu-select _autocomplete.down-line-or-menu-select.zle-widget

    bindkey '^['$key[Down] menu-select
  else
    bindkey $key[ControlSpace] menu-select
  fi

  local tab_completion
  zstyle -s ":autocomplete:tab:" completion tab_completion || tab_completion='accept'
  case $tab_completion in
    'cycle')
      bindkey $key[Tab] menu-complete
      bindkey $key[BackTab] reverse-menu-complete
      ;;
    'select')
      bindkey $key[Tab] menu-select
      bindkey $key[BackTab] reverse-menu-complete
      zle -C reverse-menu-complete menu-select _main_complete
      ;;
    *)
  bindkey $key[BackTab] list-expand
  zle -C list-expand menu-select _autocomplete.list-expand.completion-widget

  local keymap_main=$( bindkey -lL main )
  if [[ $keymap_main == *emacs* ]]
  then
    if [[ ! -v key[Undo] ]]; then key[Undo]='^_'; fi
  elif [[ $keymap_main == *viins* ]]
  then
    if [[ ! -v key[Undo] ]]; then key[Undo]='^[u'; fi
  fi
  if [[ -v key[Undo] ]]
  then
    bindkey -M menuselect $key[Tab] accept-and-hold
    bindkey -M menuselect -s $key[BackTab] $key[DeleteList]$key[Undo]$key[BackTab]
  fi
      ;;
  esac

  [[ -v functions[_zsh_autosuggest_bind_widgets] ]] && _zsh_autosuggest_bind_widgets

  if [[ $tab_completion == 'accept' ]]
  then
  bindkey $key[Tab] complete-word
  if [[ -v functions[_zsh_autosuggest_invoke_original_widget] ]]
  then
    zle -N complete-word _autocomplete.complete-word.zle-widget
    zle -C _complete_word complete-word _autocomplete.complete-word.completion-widget
  else
    zle -C complete-word complete-word _autocomplete.complete-word.completion-widget
  fi
  fi

  zle -C list-choices list-choices _autocomplete.list-choices.completion-widget
  add-zle-hook-widget line-pre-redraw _autocomplete.list-choices.hook
}

_autocomplete.application-mode.hook() {
  emulate -LR zsh -o noshortloops -o warncreateglobal
  echoti smkx
}

_autocomplete.raw-mode.hook() {
  emulate -LR zsh -o noshortloops -o warncreateglobal
  echoti rmkx
}

_autocomplete.list-choices.hook() {
  setopt localoptions noshortloops warncreateglobal $_autocomplete__options

  if (( (PENDING + KEYS_QUEUED_COUNT) > 0 ))
  then
    return 0
  fi

  local buffer=$BUFFER
  zle list-choices 2> /dev/null
  [[ $buffer != $BUFFER ]] && zle .undo
  _zsh_autosuggest_fetch
  _autocomplete._zsh_highlight
}

_autocomplete.list-choices.completion-widget() {
  setopt localoptions noshortloops warncreateglobal $_autocomplete__options
  unsetopt GLOB_COMPLETE

  if [[ $_lastcomp[nmatches] -eq 0
     && -n $_lastcomp[prefix]$_lastcomp[suffix]
     && $PREFIX$SUFFIX == $_lastcomp[prefix][[:IDENT:]]#$_lastcomp[suffix] ]]
  then
    compadd -x "$_autocomplete__lastwarning"
    return 0
  fi

  _autocomplete__lastwarning=
  local +h -a comppostfuncs=( _autocomplete.save_warning )
  local curcontext
  _autocomplete._main_complete list-choices
}

_autocomplete.save_warning() {
  emulate -LR zsh -o noshortloops -o warncreateglobal

  if [[ nm -eq 0 && -z "$_comp_mesg" && $#_lastdescr -ne 0 && $compstate[old_list] != keep ]] \
     && zstyle -s ":completion:${curcontext}:warnings" format format
  then
    _autocomplete__lastwarning=$mesg
  fi
}

_autocomplete.list-expand.completion-widget() {
  setopt localoptions noshortloops warncreateglobal $_autocomplete__options

  local curcontext
  _autocomplete._main_complete list-expand
}

_autocomplete.complete-word.zle-widget() {
  setopt localoptions noshortloops warncreateglobal $_autocomplete__options

  local lbuffer=$LBUFFER
  if [[ $POSTDISPLAY != \0# ]]
  then
    {
      functions[_autocomplete.tmp]=$functions[_zsh_autosuggest_invoke_original_widget]
      _zsh_autosuggest_invoke_original_widget() {
        zle .forward-word
      }
      _zsh_autosuggest_partial_accept
    } always {
      unfunction _zsh_autosuggest_invoke_original_widget
      functions[_zsh_autosuggest_invoke_original_widget]=$functions[_autocomplete.tmp]
      return 0
    }
  fi
  if [[ $lbuffer == $LBUFFER ]]
  then
    zle _complete_word
  fi
}

_autocomplete.complete-word.completion-widget() {
  setopt localoptions noshortloops warncreateglobal $_autocomplete__options

  local curcontext
  local +h -a comppostfuncs=( _autocomplete.insert_first_match )
  _autocomplete._main_complete complete-word
}

_autocomplete.insert_first_match() {
  if [[ -v compstate[old_list] ]]
  then
    compstate[insert]='1'
    if [[ $compstate[context] == (command|redirect) ]]
    then
      compstate[insert]+=' '
    fi
  fi
}

_autocomplete.down-line-or-menu-select.zle-widget() {
  setopt localoptions noshortloops warncreateglobal $_autocomplete__options

  local curcontext
  _autocomplete.curcontext down-line-or-menu-select

  if (( BUFFERLINES == 1 ))
  then
    zle menu-select
  else
    zle .down-line || zle .end-of-line
  fi
}

_autocomplete.menu-select.completion-widget() {
  setopt localoptions noshortloops warncreateglobal $_autocomplete__options

  local curcontext
  _autocomplete._main_complete menu-select
  compstate[insert]='menu'
}

_autocomplete.up-line-or-history-search.zle-widget() {
  setopt localoptions noshortloops warncreateglobal $_autocomplete__options

  local curcontext
  _autocomplete.curcontext up-line-or-history-search

  if (( BUFFERLINES == 1 ))
  then
    zle history-search
  else
    zle .up-line || zle .beginning-of-line
  fi
}

_autocomplete.expand-or-complete.zle-widget() {
  setopt localoptions noshortloops warncreateglobal $_autocomplete__options

  local curcontext
  _autocomplete.curcontext expand-or-complete

  if [[ $BUFFER == [[:IFS:]]# ]]
  then
    zle fzf-cd-widget
    return
  fi

  if [[ $LBUFFER[-1] != [[:IFS:]]#
     || $RBUFFER[1] != [[:IFS:]]# ]]
  then
    zle .select-in-shell-word
    local lbuffer=$LBUFFER
    if zle expand-word
    then
      return 0
    elif [[ $lbuffer != $LBUFFER ]]
    then
      zle .auto-suffix-remove
      return 0
    fi
  fi

  zle fzf-completion
}

_autocomplete.expand-word.completion-widget() {
  setopt localoptions noshortloops warncreateglobal $_autocomplete__options

  local curcontext
  _autocomplete._main_complete expand-word
  (( compstate[nmatches] == 1)) && compstate[insert]='1'
  (( compstate[nmatches] > 0))
}

_autocomplete.magic-space.zle-widget() {
  setopt localoptions noshortloops warncreateglobal $_autocomplete__options

  local curcontext
  _autocomplete.curcontext magic-space

  zle .self-insert

  zle .split-undo

  zle .backward-delete-char
  zle correct-word
  if [[ $LBUFFER[-1] != ' ' ]]
  then
    zle .self-insert
  fi
}

_autocomplete.magic-slash.zle-widget() {
  setopt localoptions noshortloops warncreateglobal $_autocomplete__options

  local curcontext
  _autocomplete.curcontext magic-slash

  zle .self-insert

  zle .split-undo

  zle .backward-delete-char
  zle correct-word
  zle .auto-suffix-remove
  zle .self-insert
}

_autocomplete.correct-word.completion-widget() {
  setopt localoptions noshortloops warncreateglobal $_autocomplete__options
  unsetopt GLOB_COMPLETE

  local curcontext
  _autocomplete.curcontext correct-word

  if [[ $PREFIX[-1] != [[:IDENT:]] || $SUFFIX[1] != [[:IFS:]]# ]]
  then
    return 1
  fi

  _main_complete _correct
  if (( compstate[nmatches] == 0 ))
  then
    return
  fi

  _main_complete _complete
  compstate[exact]='accept'
}

_autocomplete.curcontext() {
  emulate -LR zsh -o noshortloops

  curcontext="${curcontext:-}"
  if [[ -z "$curcontext" ]]; then
    curcontext="$1:::"
  else
    curcontext="$1:${curcontext#*:}"
  fi
}

_autocomplete._main_complete() {
  setopt localoptions noshortloops warncreateglobal $_autocomplete__options

  _autocomplete.curcontext $1
  shift
  local +h -a comppostfuncs=( _autocomplete.handle_long_list $comppostfuncs )
  _main_complete "$@"

  (( compstate[nmatches] > 0 ))
}

_autocomplete.handle_long_list() {
  emulate -LR zsh -o noshortloops -o warncreateglobal

  compstate[insert]=''
  compstate[list_max]=0
  if (( (compstate[list_lines] + BUFFERLINES + 1) > LINES ))
  then
    compstate[list]=''
    if zstyle -m ":completion:${curcontext}" menu "*=long-list"
    then
      compstate[insert]='menu'
    else
      zle -M ''
      return 1
    fi
  fi
  return 0
}
