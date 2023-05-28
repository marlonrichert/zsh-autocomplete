#compdef -command-

local -P ret=1
_autocd "$@" &&
    ret=0
return ret
