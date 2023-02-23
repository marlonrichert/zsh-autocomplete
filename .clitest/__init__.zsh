setopt localoptions extendedglob clobber NO_aliases localloops pipefail NO_shortloops NO_unset
zmodload zsh/param/private
autoload -Uz zmathfunc && zmathfunc
builtin autoload -UWz $PWD/functions{,/{completion,widget}}/[._]autocomplete.*~*.zwc(DN-.:P)
