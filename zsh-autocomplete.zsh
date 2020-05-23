_autocomplete.main() {
  emulate -LR zsh -o noshortloops -o warncreateglobal

 _autocomplete.completion-styles
 _autocomplete.key-bindings.init
}

() {
  emulate -LR zsh -o noshortloops -o warncreateglobal

  [[ ! -v _autocomplete__options ]] && export _autocomplete__options=(
    ALWAYS_TO_END COMPLETE_ALIASES EXTENDED_GLOB GLOB_COMPLETE GLOB_DOTS LIST_PACKED
    no_CASE_GLOB no_COMPLETE_IN_WORD no_LIST_BEEP
  )

  typeset -g ZSH_AUTOSUGGEST_USE_ASYNC=1
  typeset -g ZSH_AUTOSUGGEST_MANUAL_REBIND=1
  [[ ! -v ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS ]] \
  && typeset -g -a ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS=(
    forward-char vi-forward-char vi-find-next-char vi-find-next-char-skip
    forward-word emacs-forward-word
    vi-forward-word vi-forward-word-end vi-forward-blank-word vi-forward-blank-word-end
	)

  [[ ! -v FZF_COMPLETION_TRIGGER ]] && export FZF_COMPLETION_TRIGGER=''
  [[ ! -v fzf_default_completion ]] && export fzf_default_completion='menu-exand-or-complete'
  [[ ! -v FZF_DEFAULT_OPTS ]] && export FZF_DEFAULT_OPTS='--bind=ctrl-space:abort,ctrl-k:kill-line'

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

  [[ ! -v terminfo ]] && zmodload zsh/terminfo
  [[ ! -v functions[add-zle-hook-widget] ]] && autoload -Uz add-zle-hook-widget
  [[ ! -v functions[add-zsh-hook] ]] && autoload -Uz add-zsh-hook
  [[ ! -v functions[min] ]] && autoload -Uz zmathfunc && zmathfunc
  [[ ! -v functions[zstyle] ]] && zmodload zsh/zutil

  functions[_original.add-zsh-hook]=$functions[add-zsh-hook]
}

add-zsh-hook() {
  emulate -LR zsh -o noshortloops -o warncreateglobal

  # Intercept `_zsh_autosuggest_start`.
  if [[ ${@[(ie)_zsh_autosuggest_start]} -gt ${#@} ]]
  then
    _original.add-zsh-hook $@ > /dev/null
  fi
}

_autocomplete.completion-styles() {
  emulate -LR zsh -o noshortloops -o warncreateglobal

  # Remove incompatible styles.
  zstyle -d ':completion:*' format
  zstyle -d ':completion:*:descriptions' format
  zstyle -d ':completion:*' group-name
  zstyle -d '*' single-ignored

  zstyle ':completion:*' completer _oldlist _list _expand _complete _ignored
  zstyle ':completion:*' menu 'yes select=long-list'
  zstyle ':completion:*' matcher-list \
    'm:{[-]}={[_]} l:?|=** r:|[.]=*' 'm:{[:lower:]}={[:upper:]} r:|?=**'
  zstyle ':completion:*:-command-:*' tag-order "! all-files"
  zstyle -e ':completion:*' max-errors '
    reply="$(( min(7, (${#PREFIX} + ${#SUFFIX}) / 3) )) numeric"'
  zstyle ':completion:*' tag-order "! all-expansions" "-"

  # Ignore completions starting with punctuation, unless that punctuation has been typed.
  zstyle -e ':completion:*' ignored-patterns '
    local currentword=$PREFIX$SUFFIX
    reply=(
      "($|*/)#([[:punct:]]~[${currentword[1]}])*"
      "([[:punct:]]~^[${currentword[1]}])([[:punct:]]~[${currentword[2]}])*"
    )'

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
  zstyle ':completion:*' group-order all-files ${(@)directory_tags} globbed-files
  zstyle ':completion:*:-command-:*' group-order globbed-files ${(@)directory_tags} all-files
  zstyle ':completion:*:(all-files|globbed-files)' group-name ''
  zstyle ':completion:*:('${(j:|:)directory_tags}')' group-name ''
  zstyle ':completion:*:('${(j:|:)directory_tags}')' matcher 'm:{[:lower:]}={[:upper:]}'

  zstyle ':completion:*:corrections' format '%F{green}%d:%f'
  zstyle ':completion:*:messages' format '%F{yellow}%d%f'
  zstyle ':completion:*:original' format '%F{yellow}%d:%f'
  zstyle ':completion:*:warnings' format '%F{red}%D%f'
  zstyle ':completion:*' auto-description '%F{yellow}%d%f'

  zstyle ':completion:*' add-space true
  zstyle ':completion:*' list-separator ''
  zstyle ':completion:*' use-cache true

  zstyle ':completion:(complete-word|menu-select):*' old-list always

  zstyle ':completion:(correct-word|list-choices):*:brew-*:argument-rest:*' tag-order \
    "! argument-rest" "-"

  zstyle ':completion:correct-word:*' accept-exact true
  zstyle ':completion:correct-word:*' completer _correct
  zstyle ':completion:correct-word:*' glob false
  zstyle ':completion:correct-word:*' matcher-list ''
  zstyle -e ':completion:correct-word:*' tag-order '
    if [[ $PREFIX == "-" ]]
    then
      reply=( "options" "-" )
    else
      reply=( "! *remote*" "-" )
    fi'

  zstyle ':completion:list-choices:*' _expand _complete _ignored
  zstyle ':completion:list-choices:*' glob false
  zstyle ':completion:list-choices:*' menu ''
  zstyle -e ':completion:list-choices:*' tag-order '
    if (( (${#PREFIX} + ${#SUFFIX} + CURRENT) == 1 ))
    then
      reply=( "-" )
    elif [[ $PREFIX == "-" ]]
    then
      reply=( "options" "-" )
    else
      reply=( "! commit-tags *remote*" )
    fi'

  zstyle ':completion:expand-word:*' completer _list _expand_alias _expand
  zstyle ':completion:expand-word:*' tag-order ''
  zstyle ':completion:expand-word:*' format '%F{yellow}%d:%f'
  zstyle ':completion:expand-word:*' group-name ''

  zstyle ':completion:menu-exand-or-complete:*' completer \
    _list _expand _complete _match _ignored _approximate
  zstyle ':completion:menu-exand-or-complete:*' matcher-list 'r:|?=** m:{[:lower:]}={[:upper:]}'
  zstyle ':completion:menu-exand-or-complete:*' list-suffixes true
  zstyle ':completion:menu-exand-or-complete:*' path-completion true
  zstyle ':completion:menu-exand-or-complete:*' group-name ''
  zstyle ':completion:menu-exand-or-complete:*' format '%F{yellow}%d:%f'
  zstyle ':completion:menu-exand-or-complete:*' menu 'select'

  zstyle -e ':completion:menu-exand-or-complete:*' ignored-patterns '
    local currentword=$PREFIX$SUFFIX
    reply=( "(*/)#([[:punct:]]~[${currentword[1]}])*" )'

}

_autocomplete.key-bindings.init() {
  emulate -LR zsh -o noshortloops -o warncreateglobal

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

  # These are not generated by `zkbd` nor defined in `terminfo`.
  if [[ -z $key[Return] ]]; then key[Return]='^M'; fi
  if [[ -z $key[LineFeed] ]]; then key[LineFeed]='^J'; fi
  if [[ -z $key[ControlSpace] ]]; then key[ControlSpace]='^@'; fi
  if [[ -z $key[DeleteList] ]]; then key[DeleteList]='^D'; fi

  zle -C correct-word menu-select _autocomplete.correct-word.completion-widget

  bindkey ' ' magic-space
  zle -N magic-space _autocomplete.magic-space.zle-widget

  bindkey '/' magic-slash
  zle -N magic-slash _autocomplete.magic-slash.zle-widget

  bindkey $key[ControlSpace] expand-word
  zle -C expand-word complete-word _autocomplete.expand-word.completion-widget
  bindkey -M menuselect -s $key[ControlSpace] $key[LineFeed]$key[ControlSpace]

  # Make `terminfo` codes work.
  add-zle-hook-widget line-init _autocomplete.application-mode.zle-hook-widget
  add-zle-hook-widget line-finish _autocomplete.raw-mode.zle-hook-widget

  add-zsh-hook precmd _autocomplete.key-bindings.zsh-hook
}

_autocomplete.key-bindings.zsh-hook() {
  emulate -LR zsh -o noshortloops -o warncreateglobal

  local keymap_main=$( bindkey -lL main )
  if [[ $keymap_main == *emacs* ]]
  then
    if [[ ! -v key[ListChoices] ]]; then key[ListChoices]='^[^D'; fi
    if [[ ! -v key[Undo] ]]; then key[Undo]='^_'; fi
  elif [[ $keymap_main == *viins* ]]
  then
    [[ ! -v key[ListChoices] ]] || key[ListChoices]='^D'
    [[ ! -v key[Undo] ]] || key[Undo]='u'
  fi

  if [[ -v key[ListChoices] ]]
  then
    bindkey -M menuselect -s $key[Return] $key[LineFeed]$key[ListChoices]
  fi

  if zle -l fzf-history-widget
  then
    bindkey $key[BackTab] menu-exand-or-complete
    zle -C menu-exand-or-complete menu-select \
      _autocomplete.menu-expand-or-complete.completion-widget

    bindkey -M menuselect $key[Tab] accept-and-hold
    if [[ -v key[Undo] ]]
    then
      bindkey -M menuselect -s $key[BackTab] $key[DeleteList]$key[Undo]$key[BackTab]
    fi

    bindkey $key[Up] up-line-or-history-search
    zle -N up-line-or-history-search _autocomplete.up-line-or-history-search.zle-widget

    bindkey '^['$key[Up] fzf-history-widget

    bindkey $key[Down] down-line-or-menu-select
    zle -N down-line-or-menu-select _autocomplete.down-line-or-menu-select.zle-widget

    bindkey '^['$key[Down] menu-select
    zle -C menu-select menu-select _autocomplete.menu-select.completion-widget
  fi

  if zle -l fzf-completion && zle -l fzf-cd-widget
  then
    bindkey $key[ControlSpace] expand-or-complete
    zle -N expand-or-complete _autocomplete.expand-or-complete.zle-widget
  fi

  add-zsh-hook -d precmd _zsh_autosuggest_start
  [[ -v functions[_zsh_autosuggest_bind_widgets] ]] && _zsh_autosuggest_bind_widgets

  if zle -l fzf-history-widget
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
  _autocomplete.list-choices.init

  # Remove itself after being called.
  add-zsh-hook -d precmd _autocomplete.key-bindings.zsh-hook
}

_autocomplete.application-mode.zle-hook-widget() {
  echoti smkx
}

_autocomplete.raw-mode.zle-hook-widget() {
  echoti rmkx
}

_autocomplete.list-choices.init() {
  emulate -LR zsh -o noshortloops -o warncreateglobal

  typeset -g _autocomplete__lastbuffer _autocomplete__lastwarning

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

  zle -C list-choices list-choices _autocomplete.list-choices.completion-widget
  add-zle-hook-widget line-pre-redraw _autocomplete.list-choices.zle-hook-widget
}

_autocomplete.list-choices.zle-hook-widget() {
  setopt localoptions $_autocomplete__options

  if (( (PENDING + KEYS_QUEUED_COUNT) > 0 )) \
  || _autocomplete.zle.is_history_expansion
  then
    return 0
  fi

  zle list-choices 2> /dev/null
  _zsh_autosuggest_fetch
  _autocomplete._zsh_highlight
}

_autocomplete.list-choices.completion-widget() {
  setopt localoptions $_autocomplete__options
  unsetopt GLOB_COMPLETE

  if [[ $_lastcomp[nmatches] -eq 0
     && -n $_lastcomp[prefix]$_lastcomp[suffix]
     && $PREFIX$SUFFIX == $_lastcomp[prefix][[:IDENT:]]#$_lastcomp[suffix] ]]
  then
    compadd -x "$_autocomplete__lastwarning"
    return 1
  fi

  _autocomplete__lastwarning=
  local +h -a comppostfuncs=( _autocomplete.completion.save_warning )
  _autocomplete.completion.main_complete list-choices
  compstate[insert]=''
}

_autocomplete.no-op() {}

_autocomplete.complete-word.zle-widget() {
  setopt localoptions $_autocomplete__options

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

_autocomplete.down-line-or-menu-select.zle-widget() {
  setopt localoptions $_autocomplete__options

  local curcontext
  _autocomplete.completion.curcontext down-line-or-menu-select

  if (( ${#RBUFFER} == 0 || BUFFERLINES == 1 ))
  then
    zle menu-select
  else
    zle -M ''
    zle .down-line || zle .end-of-line
  fi
}

_autocomplete.menu-select.completion-widget() {
  setopt localoptions $_autocomplete__options
  _autocomplete.completion.main_complete menu-select
}

_autocomplete.expand-or-complete.zle-widget() {
  setopt localoptions $_autocomplete__options

  local curcontext
  _autocomplete.completion.curcontext expand-or-complete

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
  setopt localoptions $_autocomplete__options

  _autocomplete.completion.main_complete expand-word
  (( compstate[nmatches] > 0 ))
}

_autocomplete.magic-space.zle-widget() {
  setopt localoptions $_autocomplete__options

  local curcontext
  _autocomplete.completion.curcontext magic-space

  zle .self-insert

  zle .split-undo
  zle .backward-delete-char

  local lbuffer=$LBUFFER
  zle .expand-history
  if [[ $lbuffer != $LBUFFER ]]
  then
    zle .self-insert
    return
  fi

  zle correct-word
  if [[ $LBUFFER[-1] != ' ' ]]
  then
    zle .self-insert
  fi
}

_autocomplete.magic-slash.zle-widget() {
  setopt localoptions $_autocomplete__options

  local curcontext
  _autocomplete.completion.curcontext magic-slash

  zle .self-insert

  zle .split-undo
  zle .backward-delete-char

  zle correct-word
  zle .auto-suffix-remove
  zle .self-insert
}

_autocomplete.complete-word.completion-widget() {
  setopt localoptions $_autocomplete__options

  _autocomplete.completion.main_complete complete-word
  local ret=$?

  if [[ -v compstate[old_list] ]]
  then
    compstate[insert]='1'
    compstate[insert]+=' '
    return 0
  fi

  return ret
}

_autocomplete.correct-word.completion-widget() {
  setopt localoptions $_autocomplete__options
  unsetopt GLOB_COMPLETE

  local curcontext
  _autocomplete.completion.curcontext correct-word

  if (( ${#PREFIX} == 0 || ${#SUFFIX} > 0 ))
  then
    return 1
  fi

  _main_complete _match
  if (( compstate[nmatches] > 0 ))
  then
    compstate[insert]=''
    compstate[list]=''
    return 1
  fi

  _main_complete
  if (( compstate[nmatches] == 0 ))
  then
    return 1
  fi

  _main_complete _complete
  compstate[exact]='accept'
  if [[ ${compstate[unambiguous]} == $PREFIX$SUFFIX ]]
  then
    compstate[insert]=''
    compstate[list]=''
    return 1
  fi

  _autocomplete.completion.handle_long_list

  return 0
}

_autocomplete.menu-expand-or-complete.completion-widget() {
  setopt localoptions $_autocomplete__options
  _autocomplete.completion.main_complete menu-exand-or-complete
}

_autocomplete.up-line-or-history-search.zle-widget() {
  setopt localoptions $_autocomplete__options

  local curcontext
  _autocomplete.completion.curcontext up-line-or-history-search

  if (( ${#LBUFFER} == 0 || BUFFERLINES == 1 ))
  then
    zle fzf-history-widget
  else
    zle -M ''
    zle .up-line || zle .beginning-of-line
  fi
}

_autocomplete.completion.curcontext() {
  emulate -LR zsh -o noshortloops

  curcontext="${curcontext:-}"
  if [[ -z "$curcontext" ]]; then
    curcontext="$1:::"
  else
    curcontext="$1:${curcontext#*:}"
  fi
}

_autocomplete.completion.handle_long_list() {
  emulate -LR zsh -o noshortloops -o warncreateglobal

  compstate[list_max]=0
  if (( (compstate[list_lines] + BUFFERLINES + 1) > LINES ))
  then
    if zstyle -m ":completion:${curcontext}" menu "*=long-list"
    then
      compstate[insert]='menu'
    else
      compstate[list]=''
      zle -M ''
      return 1
    fi
  fi
  return 0
}

_autocomplete.completion.main_complete() {
  local curcontext
  _autocomplete.completion.curcontext $1
  _main_complete $@[2,-1]
  local ret=$?
  _autocomplete.completion.handle_long_list
  return ret
}

_autocomplete.completion.save_warning() {
  if [[ nm -eq 0 && -z "$_comp_mesg" && $#_lastdescr -ne 0 && $compstate[old_list] != keep ]] \
     && zstyle -s ":completion:${curcontext}:warnings" format format
  then
    _autocomplete__lastwarning=$mesg
  fi
}

_autocomplete.zle.is_history_expansion() {
  local safechars='\-\#\:'
  local histexpansion="[\\${(q)histchars[1]}][$safechars](#c0,1)[^$safechars][[:graph:]]#"

  [[ ${${(z)LBUFFER}[-1]}${${(z)RBUFFER}[1]} == ${~histexpansion}
  || $LBUFFER${${(z)RBUFFER}[1]} == *${~histexpansion}
  || ${${(z)LBUFFER}[-1]}$RBUFFER == ${~histexpansion}* ]]
}
