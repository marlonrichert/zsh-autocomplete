#Define keys
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

#Bind keys
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

