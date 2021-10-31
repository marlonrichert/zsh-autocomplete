#!/bin/zsh
zmodload -F zsh/parameter p:funcfiletrace p:functions

# Workaround for https://github.com/zdharma/zinit/issues/366
# NOTE: Needs to come before _everything_ else!
[[ -v functions[.zinit-shade-off] ]] &&
    .zinit-shade-off "${___mode:-load}"
[[ -v functions[.zinit-tmp-subst-off] ]] &&
    .zinit-tmp-subst-off "${___mode:-load}"

zmodload zsh/param/private
setopt NO_flowcontrol NO_listbeep NO_singlelinezle
typeset -gHa _autocomplete__funcfiletrace=( $funcfiletrace[2,-2] )
builtin autoload +X -Uz ${${(%):-%x}:P:h}/scripts/.autocomplete.__init__
{
  .autocomplete.__init__ "$@"
} always {
  unfunction .autocomplete.__init__
}
