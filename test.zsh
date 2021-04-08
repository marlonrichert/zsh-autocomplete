# https://opensource.apple.com/source/zsh/zsh-65/zsh/Doc/help/

# local -A just_values
typeset -A values_sorted
typeset -A history_my
just_values=(a b c)
history_my=(d e f)
print "$s" ${(@)just_values}
for key val in "${(@kv)history_my}"; do
  print $val
  values[$val]=$key
  just_values+=$val
done
for val in "${(@vu)just_values}"; do
  values_sorted[$val]=$key
done
print "$s" ${(@)just_values}