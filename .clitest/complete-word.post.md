Setup:
```zsh
% autoload -Uz zmathfunc && zmathfunc
% autoload -Uz $PWD/functions/widget/.autocomplete.complete-word.post
% unset terminfo
% typeset -gA terminfo=() compstate=( [old_list]=shown ) _lastcomp=()
% terminfo[kcbt]=BACKSPACE
% zstyle ':autocomplete:*' add-space 'FOO' 'TAG' 'BAR'
%
```

Only `menu-select` widget sets `$MENUSELECT`:
```zsh
% WIDGET=menu-select .autocomplete.complete-word.post
% print -r -- ${(q+)compstate[insert]} ${(q+)compstate[list]} $+MENUSELECT
1 '' 1
%
```

Only `Shift-Tab` key sets `$compstate[insert]` to `*:0`:
```zsh
% KEYS=BACKSPACE .autocomplete.complete-word.post
% print -r -- ${(q+)compstate[insert]} ${(q+)compstate[list]} $+MENUSELECT
0 '' 0
%
```

`add-space` tag in current completion adds space:
```zsh
% _comp_tags='LOREM TAG IPSUM' _lastcomp[tags]='OTHER' .autocomplete.complete-word.post
% print -r -- ${(q+)compstate[insert]} ${(q+)compstate[list]} $+MENUSELECT
'1 ' '' 0
%
```

`add-space` tag in previous completion adds space, if current completion is not used:
```zsh
% _comp_tags= _lastcomp[tags]='LOREM TAG IPSUM' .autocomplete.complete-word.post
% print -r -- ${(q+)compstate[insert]} ${(q+)compstate[list]} $+MENUSELECT
'1 ' '' 0
%
```

`add-space` tag in previous completion does NOT add space, if current completion is used:
```zsh
% _comp_tags='OTHER' _lastcomp[tags]='TAG' .autocomplete.complete-word.post
% print -r -- ${(q+)compstate[insert]} ${(q+)compstate[list]} $+MENUSELECT
1 '' 0
%
```

If list is not yet shown, then insert unambiguous and show list:
```zsh
% compstate[old_list]= _comp_tags= _lastcomp[tags]= .autocomplete.complete-word.post
% print -r -- ${(q+)compstate[insert]} ${(q+)compstate[list]} $+MENUSELECT
unambiguous 'list force packed rows' 0
%
```
