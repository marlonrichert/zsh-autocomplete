#compdef -command-
local -i ret=1
_autocd "$@" && ret=0
_expand_alias && ret=0
return ret
