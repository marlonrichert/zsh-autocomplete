#compdef -command-
local -P ret=1
_expand_alias "$@" &&
	  ret=0
_autocd "$@" &&
    ret=0
return ret
