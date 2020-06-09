() {
  emulate -LR zsh -o noshortloops -o warncreateglobal -o extendedglob

  autoload +X -Uz add-zsh-hook

  # In case we're sourced _after_ `zsh-autosuggestions`
  add-zsh-hook -d precmd _zsh_autosuggest_start

  # In case we're sourced _before_ `zsh-autosuggestions`
  functions[_autocomplete.add-zsh-hook]=$functions[add-zsh-hook]
  add-zsh-hook() {
    emulate -LR zsh -o noshortloops -o warncreateglobal -o extendedglob

    # Prevent `_zsh_autosuggest_start` from being added.
    if [[ ${@[(ie)_zsh_autosuggest_start]} -gt ${#@} ]]; then
      _autocomplete.add-zsh-hook "$@" > /dev/null
    fi
  }

  typeset -g ZSH_AUTOSUGGEST_USE_ASYNC=1
  typeset -g ZSH_AUTOSUGGEST_MANUAL_REBIND=1

  zmodload -i zsh/parameter # `functions` array
  autoload -Uz zmathfunc && zmathfunc # `min` function
  autoload -Uz add-zle-hook-widget
  [[ ! -v ZLE_REMOVE_SUFFIX_CHARS ]] && export ZLE_REMOVE_SUFFIX_CHARS=$' \t\n;&'

  [[ ! -v _autocomplete__options ]] && export _autocomplete__options=(
    ALWAYS_TO_END COMPLETE_ALIASES GLOB_COMPLETE GLOB_DOTS LIST_PACKED
    no_CASE_GLOB no_COMPLETE_IN_WORD no_LIST_BEEP
  )

  # Workaround for issue #43
  # https://github.com/marlonrichert/zsh-autocomplete/issues/43
  zle -N zle-line-finish azhw:zle-line-finish

  # Make `terminfo` codes work.
  add-zle-hook-widget line-init _autocomplete.application-mode.hook
  _autocomplete.application-mode.hook() {
    echoti smkx
  }
  add-zle-hook-widget line-finish _autocomplete.raw-mode.hook
  _autocomplete.raw-mode.hook() {
    echoti rmkx
  }

  add-zsh-hook precmd _autocomplete.main.hook
}

_autocomplete.main.hook() {
  emulate -LR zsh -o noshortloops -o warncreateglobal -o extendedglob

  # Remove itself after being called.
  add-zsh-hook -d precmd _autocomplete.main.hook

  zmodload -i zsh/zutil # `zstyle` builtin
  local -a option_tags=( '(|*-)argument-* (|*-)option[-+]* values' 'options' )

  # Remove incompatible styles.
  zstyle -d ':completion:*' format
  zstyle -d ':completion:*:descriptions' format
  zstyle -d ':completion:*' group-name
  zstyle -d ':completion:*:functions' ignored-patterns
  zstyle -d '*' single-ignored
  zstyle -d ':completion:*' special-dirs

  zstyle ':zle:up-line-or-beginning-search' leave-cursor no
  zstyle ':zle:down-line-or-beginning-search' leave-cursor no

  zstyle ':completion:*' completer _list _expand _complete _complete:-fuzzy _correct _ignored
  zstyle ':completion:*' menu 'yes select=long-list'

  if zstyle -m ":autocomplete:tab:" completion 'insert'; then
    zstyle ':completion:*:complete:*' matcher-list ''
    zstyle ':completion:*:complete:*' show-ambiguity '07'
  else
    zstyle ':completion:*:complete:*' matcher-list 'l:|=*'
  fi

  zstyle -e ':completion:*:complete:*' ignored-patterns '
    local word=$PREFIX$SUFFIX
    local prefix=${(M)word##*/}
    local suffix=${word##*/}
    if (( ${#suffix} == 0 )); then
      reply=( "${prefix}[[:punct:]]*" )
    else
      local punct=${(M)suffix##[[:punct:]]##}
      suffix=${suffix##[[:punct:]]##}
      reply=( "[[:punct:]]*~${punct}[^[:punct:]]*"
              "[[:upper:]]*~${suffix[1]}*")
    fi'
  zstyle ':completion:*:complete-fuzzy:*' matcher-list 'm:{[:lower:]-}={[:upper:]_} r:|?=**'
  zstyle -e ':completion:*:complete-fuzzy:*' ignored-patterns '
    local word=$PREFIX$SUFFIX
    local prefix=${(M)word##*/}
    local suffix=${word##*/}
    if (( ${#suffix} == 0 )); then
      reply=( "${prefix}[[:punct:]]*" )
    else
      if [[ $suffix == .* ]]; then
        reply=( "^(${prefix}*${suffix[1,2]}*)" )
      else
        local punct=${(M)suffix##[[:punct:]]##}
        suffix=${suffix##[[:punct:]]##}
        reply=( "^(${prefix}${punct}${suffix[1]}*)" )
      fi
    fi'
  zstyle -e ':completion:*' glob '
    [[ $PREFIX$SUFFIX == *[\*\(\|\<\[\?\^\#]* ]] && reply=( "true" ) || reply=( "false" )'

  zstyle -e ':completion:*' tag-order '
    reply=( '${(qq@)option_tags}' )
    if [[ $PREFIX$SUFFIX == [-+]* ]]; then
      reply+=( "-" )
    else
      reply+=( "! *remote*" )
    fi'
  zstyle ':completion:*:(-command-|cd|z):*' tag-order '! users' '-'

  zstyle ':completion:*:expand:*' tag-order '! all-expansions original'

  zstyle -e ':completion:*:correct:*' max-errors '
    reply=( $(( min(2, (${#PREFIX} + ${#SUFFIX}) / 2 - 1) )) numeric )'
  zstyle -e ':completion:*:approximate:*' max-errors '
    reply=( $(( min(7, (${#PREFIX} + ${#SUFFIX}) / 2 - 1) )) numeric )'

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
  zstyle ':completion:*:(-command-|cd|z):*' group-order globbed-files directories all-files
  zstyle ':completion:*:(all-files|globbed-files)' group-name ''
  zstyle ':completion:*:cd|z:*:globbed-files' group-name 'directories'
  zstyle ':completion:*:('${(j:|:)directory_tags}')' group-name 'directories'
  zstyle ':completion:*:('${(j:|:)directory_tags}')' matcher 'm:{[:lower:]}={[:upper:]}'

  if zstyle -t ':autocomplete:' groups 'always'; then
    zstyle ':completion:*' format '%F{yellow}%d:%f'
    zstyle ':completion:*' group-name ''
  fi

  zstyle ':completion:*:corrections' format '%F{green}%d:%f'
  zstyle ':completion:*:expansions' format '%F{yellow}%d:%f'
  zstyle ':completion:*:expansions' group-name ''
  zstyle ':completion:*:messages' format '%F{blue}%d%f'
  zstyle ':completion:*:original' format '%F{yellow}%d:%f'
  zstyle ':completion:*:warnings' format '%F{red}%d%f'
  zstyle ':completion:*' auto-description '%F{yellow}%d%f'

  zstyle ':completion:*' add-space true
  zstyle ':completion:*' list-separator ''
  zstyle ':completion:*' use-cache true

  zstyle ':completion:correct-word:*' accept-exact true
  zstyle ':completion:correct-word:*' glob false
  zstyle ':completion:correct-word:*' matcher-list ''
  zstyle ':completion:correct-word:*:git-*:argument-*:*' tag-order '-'

  zstyle ':completion:list-choices:*' glob false
  zstyle ':completion:list-choices:*' menu ''

  zstyle ':completion:expand-word:*' completer _expand_alias _expand

  zstyle ':completion:list-expand:*' completer _expand _complete:-fuzzy _approximate _ignored
  zstyle -e ':completion:*:complete-fuzzy:*' ignored-patterns '
    local word=$PREFIX$SUFFIX
    local prefix=${(M)word##*/}
    local suffix=${word##*/}
    local punct=${(M)suffix##[[:punct:]]##}
    if (( ${#punct} == 0 )); then
      reply=( "${prefix}[[:punct:]]*" )
    else
      reply=( "${prefix}([[:punct:]]*~${punct}*)" )
    fi'
  zstyle ':completion:list-expand:*' tag-order '*'
  zstyle ':completion:list-expand:*' list-suffixes true
  zstyle ':completion:list-expand:*' path-completion true
  zstyle ':completion:list-expand:*' format '%F{yellow}%d:%f'
  zstyle ':completion:list-expand:*' group-name ''
  zstyle ':completion:list-expand:*' extra-verbose true
  zstyle ':completion:list-expand:*' list-separator '-'

  # Initialize completion system, if it hasn't been done yet.
  # `zsh/complist` should be loaded _before_ `compinit`.
  if ! (zle -l menu-select && bindkey -l menuselect > /dev/null); then
    zmodload -i zsh/complist
    autoload -Uz compinit
    compinit
  elif ! [[ -v compprefuncs && -v comppostfuncs ]]; then
    autoload -Uz compinit
    compinit
  fi

  if [[ ! -v key ]]; then
    # This file can be generated interactively with `autoload -Uz zkbd && zkbd`.
    # See http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#Keyboard-Definition
    if [[ -r ${ZDOTDIR:-$HOME}/.zkbd/${TERM}-${VENDOR} ]]; then
      source ${ZDOTDIR:-$HOME}/.zkbd/${TERM}-${VENDOR}
    fi

    if [[ ! -v key ]]; then
      typeset -g -A key
    fi
  fi

  zmodload -i zsh/terminfo
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

  # Hard-code these values, because they are not generated by `zkbd` nor defined in `terminfo`.
  if [[ -z $key[Return] ]]; then key[Return]='^M'; fi
  if [[ -z $key[LineFeed] ]]; then key[LineFeed]='^J'; fi
  if [[ -z $key[ControlSpace] ]]; then key[ControlSpace]='^@'; fi
  if [[ -z $key[DeleteList] ]]; then key[DeleteList]='^D'; fi

  if zle -l fzf-completion && zle -l fzf-cd-widget; then
    bindkey $key[ControlSpace] expand-or-complete
    zle -N expand-or-complete _autocomplete.expand-or-complete.zle-widget
    bindkey -M menuselect -s $key[ControlSpace] $key[LineFeed]$key[ControlSpace]
  else
    bindkey $key[ControlSpace] expand-word
  fi
  zle -C expand-word menu-select _autocomplete.expand-word.completion-widget

  if zle -l fzf-history-widget; then
    bindkey $key[Up] up-line-or-history-search
    zle -N up-line-or-history-search _autocomplete.up-line-or-history-search.zle-widget

    bindkey '^['$key[Up] history-search
    zle -N history-search _autocomplete.history-search.zle-widget

    bindkey $key[Down] down-line-or-menu-select
    zle -N down-line-or-menu-select _autocomplete.down-line-or-menu-select.zle-widget

    bindkey '^['$key[Down] menu-select
  else
    bindkey $key[ControlSpace] menu-select
  fi
  zle -C menu-select menu-select _autocomplete.menu-select.completion-widget

  bindkey -M menuselect '^['$key[Up] vi-backward-blank-word
  bindkey -M menuselect '^['$key[Down] vi-forward-blank-word

  if zstyle -t ":autocomplete:space:" magic expand-history; then
    bindkey ' ' magic-space
    zle -N magic-space
    magic-space() {
      zle .expand-history
      zle .self-insert
    }
  fi
  zle -C correct-word complete-word _autocomplete.correct-word.completion-widget
  bindkey '^[ ' self-insert-unmeta
  
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
    'insert')
      bindkey $key[Tab] menu-complete
      zle -C menu-complete menu-complete menu-complete
      bindkey $key[BackTab] reverse-menu-complete
      zle -C reverse-menu-complete reverse-menu-complete menu-complete
      menu-complete() {
        [[ -v compstate[old_list] ]] && compstate[old_list]='keep'
        _main_complete
        local word=$PREFIX$SUFFIX
        if (( ${#compstate[exact_string]} > 0 )); then
          case $WIDGETSTYLE in
            menu-complete)
              compstate[insert]='menu:2'
              ;;
            reverse-menu-complete)
              compstate[insert]='menu:-1'
              ;;
          esac
        elif (( ${compstate[unambiguous_cursor]} > (${#word} + 1) )); then
          compstate[insert]='unambiguous'
        else
          compstate[insert]='menu'
        fi
      }
      ;;
    'accept')
      zstyle ':autocomplete:tab:*' completion accept
      if [[ -v functions[_zsh_autosuggest_invoke_original_widget] ]]; then
        bindkey $key[Tab] _complete_word
        zle -N _complete_word _autocomplete.complete-word.zle-widget
      else
        bindkey $key[Tab] complete-word
      fi
      zle -C complete-word complete-word _autocomplete.complete-word.completion-widget
      bindkey $key[BackTab] list-expand
      zle -C list-expand menu-select _autocomplete.list-expand.completion-widget

      local keymap_main=$( bindkey -lL main )
      if [[ $keymap_main == *emacs* ]]; then
        if [[ ! -v key[Undo] ]]; then key[Undo]='^_'; fi
      elif [[ $keymap_main == *viins* ]]; then
        if [[ ! -v key[Undo] ]]; then key[Undo]='^[u'; fi
      fi
      if [[ -v key[Undo] ]]; then
        bindkey -M menuselect $key[Tab] accept-and-hold
        bindkey -M menuselect -s $key[BackTab] $key[DeleteList]$key[Undo]$key[BackTab]
        bindkey -M menuselect -s $key[Undo] $key[DeleteList]$key[Undo]
      fi
      ;;
  esac

  [[ -v ZSH_AUTOSUGGEST_IGNORE_WIDGETS ]] && ZSH_AUTOSUGGEST_IGNORE_WIDGETS+=(
    prompt_\*
    user:_zsh_highlight_widget_\*-zle-line-finish 
  )
  [[ -v ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS ]] && ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS+=(
    forward-char 
    vi-forward-char
  )

  _autocomplete.no-op() { :; }
  if [[ ! -v functions[_zsh_highlight] ]]; then 
    functions[_zsh_highlight]=$functions[_autocomplete.no-op]
  fi
  if [[ ! -v functions[_zsh_autosuggest_highlight_apply] ]]; then 
    functions[_zsh_autosuggest_highlight_apply]=$functions[_autocomplete.no-op]
  fi

  [[ -v functions[_zsh_autosuggest_bind_widgets] ]] && _zsh_autosuggest_bind_widgets

  zmodload -i zsh/system # `sysparams` array
  zmodload -i zsh/zpty
  typeset -g _autocomplete__last_buffer _autocomplete__async_fd
  typeset -gaU _autocomplete__child_pids=( )
  zle -N _autocomplete.async_callback
  zle -C _list_choices list-choices _autocomplete.list-choices.completion-widget
  add-zle-hook-widget line-pre-redraw _autocomplete.list-choices.hook
  add-zsh-hook preexec _autocomplete.cancel_async
  add-zsh-hook zshexit _autocomplete.cancel_async
}

_autocomplete.list-choices.hook() {
  setopt localoptions noshortloops warncreateglobal extendedglob $_autocomplete__options

  if (( (PENDING + KEYS_QUEUED_COUNT) > 0 )); then
    return
  fi
  if zstyle -m ":autocomplete:tab:" completion 'accept' && [[ $KEYS == *${key[BackTab]} ]]; then
    return
  fi
  _autocomplete.async-list-choices ${KEYS} ${LBUFFER} ${RBUFFER}
}

_autocomplete.cancel_async() {
  emulate -LR zsh -o noshortloops -o warncreateglobal -o extendedglob

	# If we've got a pending request, cancel it.
  if [[ -n "$_autocomplete__async_fd" ]] && { true <&$_autocomplete__async_fd } 2> /dev/null; then
		# Close the file descriptor and remove the handler.
    exec {_autocomplete__async_fd}<&-
    zle -F $_autocomplete__async_fd
  fi

  # Zsh will make a new process group for the child process only if job control is enabled.
  local group='-' && [[ -o MONITOR ]] || group=''

  # Kill all processes we spawned.
  local pid
  for pid in ${(A)_autocomplete__child_pids}
  do
    # Kill the process or process group.
    kill -TERM $group$pid 2> /dev/null
  done
  _autocomplete__child_pids=( )
}

_autocomplete.async-list-choices() {
  setopt localoptions noshortloops warncreateglobal extendedglob $_autocomplete__options
  setopt nobanghist

  _autocomplete.cancel_async

  {
    # Fork a process and open a pipe to read from it.
  	exec {_autocomplete__async_fd}< <(
      # Tell parent process our process ID.
      echo $sysparams[pid]

      {
        local REPLY
        zpty _autocomplete__zpty _autocomplete.query-list-choices "\$1" "\$2" "\$3"
        zpty -w _autocomplete__zpty $'\t'

        local line
        zpty -r _autocomplete__zpty line '*'$'\0'$'\0'
        zpty -r _autocomplete__zpty line '*'$'\0'$'\0'
        echo -nE $line
      } always {
        zpty -d _autocomplete__zpty
      }
  )
  } always {
    # Read the process ID from the child process
    local pid
  	read pid <&$_autocomplete__async_fd
    _autocomplete__child_pids+=( $pid )

	# Install a widget to handle input from the fd
  	zle -F -w "$_autocomplete__async_fd" _autocomplete.async_callback
  }
}

_autocomplete.query-list-choices() {
  typeset -g __keys=${1} __lbuffer=${2} __rbuffer=${3}
  zle-widget() {
    RBUFFER=$__rbuffer
    zle completion-widget 2>&1
  }
  completion-widget() {
    echo -nE $'\0'$'\0'

    print_comp_mesg() {
      echo -nE "${(qq)_comp_mesg}"$'\0'
      compstate[insert]=''
      compstate[list_max]=0
      compstate[list]=''
    }

    local curcontext
    local -a +h comppostfuncs=( print_comp_mesg )
    unset 'compstate[vared]'
    _autocomplete._main_complete list-choices 2>&1
    compstate[insert]=''
    compstate[list_max]=0
    compstate[list]=''

    echo -nE "${(q)__keys}"$'\0'"${(q)__lbuffer}"$'\0'"${(q)__rbuffer}"$'\0'
    echo -nE "${compstate[nmatches]}"$'\0'"${compstate[list_lines]}"$'\0'$'\0'
  }
  zle -N zle-widget
  zle -C completion-widget list-choices completion-widget
  bindkey '^I' zle-widget
  vared __lbuffer 2>&1
}

# Called when new data is ready to be read from the pipe
# First arg will be fd ready for reading
# Second arg will be passed in case of error
_autocomplete.async_callback() {
  setopt localoptions noshortloops warncreateglobal extendedglob $_autocomplete__options
  setopt nobanghist

  {
  	if [[ -z "$2" || "$2" == "hup" ]]; then

      (( $#BUFFER == 0 )) && return

      local null comp_mesg keys lbuffer rbuffer
      local nmatches list_lines
      IFS=$'\0' read -r -u $1 comp_mesg keys lbuffer rbuffer nmatches list_lines null
      # echo -E "comp_mesg=$comp_mesg keys=$keys lbuffer=$lbuffer rbuffer=$rbuffer nmatches=$nmatches list_lines=$list_lines null=$null"

      if [[ "${LBUFFER}" != "${(Q)lbuffer}" || "${RBUFFER}" != "${(Q)rbuffer}" ]]; then
        return
      fi

      case ${(Q)keys} in
        ' ')
          if zstyle -T ":autocomplete:space:" magic correct-word && [[ ${LBUFFER[-1]} == ' ' ]]; then
            zle .backward-delete-char
            zle correct-word
            if [[ ${LBUFFER[-1]} != ' ' ]]; then
              LBUFFER=$LBUFFER' '
            fi
          fi
          ;;
        '/')
          if zstyle -T ":autocomplete:slash:" magic correct-word && [[ ${LBUFFER[-1]} == '/' ]]; then
            zle .backward-delete-char
            zle correct-word
            zle .auto-suffix-remove
            LBUFFER=$LBUFFER'/'
          fi
          ;;
      esac

      # If a widget can't be called, ZLE always returns 0.
      # Thus, we return 1 on purpose, so we can check if our widget got called.
      zle _list_choices $nmatches $list_lines $comp_mesg
      if (( ? == 1 )); then
        unset _ZSH_HIGHLIGHT_PRIOR_BUFFER
        _zsh_highlight
        _zsh_autosuggest_highlight_apply
        zle -R
      fi
  	fi
  } always {
    if [[ -n "$1" ]] && { true <&$1 } 2>/dev/null; then
      # Close the fd
      exec {1}<&-

    	# Remove the handler
    	zle -F "$1"
    fi
  }
}

_autocomplete.list-choices.completion-widget() {
  setopt localoptions noshortloops warncreateglobal extendedglob $_autocomplete__options
  setopt noglobcomplete

  local curcontext
  _autocomplete.curcontext list-choices
  _autocomplete.max_lines
  local max_lines=REPLY

  local min_input
  zstyle -s ":autocomplete:$curcontext" min-input min_input || min_input=1

  local word=$PREFIX$SUFFIX
  if (( CURRENT == 1 && ${#word} < min_input )); then
    :
  elif [[ -v 1 ]] && (( $1 == 0 )); then
    if [[ $word == '' ]]; then
      if [[ $3 == 'yes' ]] && (( $2 > 0 )); then
        _autocomplete._main_complete list-choices
      else
        local reply _comp_mesg
        _message "Type more..."
      fi
    else
      _autocomplete.warning "No matching completions found."
    fi
  elif [[ -v 2 ]] && (( ($2 + BUFFERLINES + 1) > max_lines )); then
    local warning='Too many completions to fit on screen. Type more to filter or press '
    if zle -l fzf-history-widget; then
      warning+='Down Arrow'
    else
      warning+='Ctrl-Space'
    fi
    warning+=' to open the menu.'
    _autocomplete.warning $warning
  else
    _autocomplete._main_complete list-choices
  fi
  compstate[list]='list force'
  compstate[insert]=''

  # If a widget can't be called, ZLE always returns 0.
  # Thus, we return 1 on purpose, so we can check if our widget got called.
  return 1
}

_autocomplete.warning() {
  setopt localoptions noshortloops nowarncreateglobal extendedglob $_autocomplete__options

  local format
  zstyle -s ":completion:${curcontext}:warnings" format format
  _setup warnings
  local mesg
  zformat -f mesg "$format" "d:$1" "D:$1"
  compadd -x "$mesg"
}

_autocomplete.correct-word.completion-widget() {
  setopt localoptions noshortloops warncreateglobal extendedglob $_autocomplete__options
  unsetopt GLOB_COMPLETE

  if [[ ${LBUFFER[-1]} != [[:IDENT:]] || ${RBUFFER[1]} != [[:IFS:]]# ]]; then
    return 1
  fi

  local curcontext
  _autocomplete.curcontext correct-word
  _main_complete _correct
  if (( compstate[nmatches] > 0 )); then
    _main_complete _complete
    compstate[exact]='accept'
  fi
  compstate[list]=''
}

_autocomplete.list-expand.completion-widget() {
  setopt localoptions noshortloops warncreateglobal extendedglob $_autocomplete__options

  local curcontext
  _autocomplete._main_complete list-expand
}

_autocomplete.complete-word.zle-widget() {
  setopt localoptions noshortloops warncreateglobal extendedglob $_autocomplete__options

  local lbuffer="$LBUFFER"
  if (( $#RBUFFER == 0 && $#POSTDISPLAY > 0 )); then
    zle forward-word
  fi
  if [[ "$lbuffer" == "$LBUFFER" ]]; then
    zle complete-word
  fi
}

_autocomplete.complete-word.completion-widget() {
  setopt localoptions noshortloops warncreateglobal extendedglob $_autocomplete__options

  if [[ -v compstate[old_list] ]]; then
    compstate[old_list]='keep'
    compstate[insert]='1'
    if [[ ${compstate[context]} == (command|redirect) ]]; then
      compstate[insert]+=' '
    fi
  else
    local curcontext
    _autocomplete._main_complete complete-word
  fi
}

_autocomplete.down-line-or-menu-select.zle-widget() {
  setopt localoptions noshortloops warncreateglobal extendedglob $_autocomplete__options

  local curcontext
  _autocomplete.curcontext down-line-or-menu-select

  if (( BUFFERLINES == 1 )); then
    zle menu-select
  else
    zle .down-line || zle .end-of-line
  fi
}

_autocomplete.menu-select.completion-widget() {
  setopt localoptions noshortloops warncreateglobal extendedglob $_autocomplete__options

  [[ -v compstate[old_list] ]] && compstate[old_list]='keep'
  local curcontext
  _autocomplete._main_complete menu-select
  compstate[insert]='menu'
}

_autocomplete.up-line-or-history-search.zle-widget() {
  setopt localoptions extendedglob $_autocomplete__options

  local curcontext
  _autocomplete.curcontext up-line-or-history-search

  if (( BUFFERLINES == 1 )); then
    zle history-search
  else
    zle .up-line || zle .beginning-of-line
  fi
}

_autocomplete.history-search.zle-widget() {
  setopt localoptions extendedglob $_autocomplete__options

  local FZF_COMPLETION_TRIGGER=''
  local fzf_default_completion='list-expand'
  local FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --bind=ctrl-space:abort,ctrl-k:kill-line"

  zle fzf-history-widget
}

_autocomplete.expand-or-complete.zle-widget() {
  setopt localoptions extendedglob $_autocomplete__options

  local FZF_COMPLETION_TRIGGER=''
  local fzf_default_completion='list-expand'
  local FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --bind=ctrl-space:abort,ctrl-k:kill-line"

  local curcontext
  _autocomplete.curcontext expand-or-complete

  if [[ $BUFFER == [[:IFS:]]# ]]; then
    zle fzf-cd-widget
    return
  fi

  if [[ ${LBUFFER[-1]} != [[:IFS:]]# || ${RBUFFER[1]} != [[:IFS:]]# ]]; then
    zle .select-in-shell-word
    local lbuffer=$LBUFFER
    if ! zle expand-word && [[ $lbuffer != $LBUFFER ]]; then
      zle .auto-suffix-remove
    fi
    return 0
  fi

  zle fzf-completion
}

_autocomplete.expand-word.completion-widget() {
  setopt localoptions noshortloops warncreateglobal extendedglob $_autocomplete__options

  local curcontext
  _autocomplete._main_complete expand-word
  (( compstate[nmatches] == 1)) && compstate[insert]='1'
  (( compstate[nmatches] > 0))
}

_autocomplete.curcontext() {
  emulate -LR zsh -o noshortloops -o warncreateglobal -o extendedglob

  typeset -g curcontext
  curcontext="${curcontext:-}"
  if [[ -z "$curcontext" ]]; then
    curcontext="$1:::"
  else
    curcontext="$1:${curcontext#*:}"
  fi
}

_autocomplete._main_complete() {
  setopt localoptions noshortloops warncreateglobal extendedglob $_autocomplete__options

  _autocomplete.curcontext $1
  shift
  (( $#comppostfuncs == 0 )) && local +h -a comppostfuncs=( _autocomplete.handle_long_list )
  _main_complete "$@"
}

_autocomplete.handle_long_list() {
  emulate -LR zsh -o noshortloops -o warncreateglobal -o extendedglob

  compstate[insert]=''
  compstate[list_max]=0
  _autocomplete.max_lines
  local max_lines=REPLY
  if (( (compstate[list_lines] + BUFFERLINES + 1) > max_lines )); then
    compstate[list]=''
    if [[ $WIDGET != list-choices ]]; then
      compstate[insert]='menu'
    fi
  fi
  return 0
}

_autocomplete.max_lines() {
  emulate -LR zsh -o noshortloops -o warncreateglobal -o extendedglob

  typeset -g REPLY
  zstyle -s ":autocomplete:$curcontext" max-lines REPLY || REPLY=$LINES
  [[ $REPLY == *% ]] && (( REPLY=(LINES * ${REPLY%%\%} / 100) ))
  (( REPLY=min(LINES, REPLY) ))
}
