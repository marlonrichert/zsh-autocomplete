# https://opensource.apple.com/source/zsh/zsh-65/zsh/Doc/help/
# https://gist.github.com/cinhtau/ea0bed82dfa8f996c3cd4149c2c31672

local -a just_values
typeset -A values_sorted
typeset -A history_my
typeset -A values
# just_values=(a b c)
history_my=([1]=d [2]=e  [3]=f [4]=e)
print ${(kv@)history_my}
# print "$s" ${(@)just_values}
for key val in "${(@kv)history_my}"; do
  # print $val
  values[$val]=$key
  just_values+=$val
done

for val in "${(@vu)just_values}"; do
  values_sorted[$values[$val]]=$val 
done
print ${(kv@)values_sorted}
#  print -f '%s:%s' "${(kv@)values_sorted}"