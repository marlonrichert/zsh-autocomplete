Setup:
```zsh
% autoload -Uz zmathfunc && zmathfunc
% autoload -Uz .autocomplete.complete-word.post
% typeset -gA key=( Shift-Tab BACKTAB ) compstate=() _lastcomp=()
% zstyle ':autocomplete:*' add-space 'FOO' 'TAG' 'BAR'
%
```

Only `menu-select` widget sets `$MENUSELECT`:
```zsh
% WIDGET=menu-select .autocomplete.complete-word.post
% print -r - ${(q+)compstate[insert]} $+MENUSELECT
1 1
%
```

Only `Shift-Tab` key sets `$compstate[insert]` to `*:0`:
```zsh
% KEYS='BACKTAB' .autocomplete.complete-word.post
% print -r - ${(q+)compstate[insert]} $+MENUSELECT
0 0
%
```

`add-space` tag in current completion adds space:
```zsh
% _comp_tags='LOREM TAG IPSUM' _lastcomp[tags]='OTHER' .autocomplete.complete-word.post
% print -r - ${(q+)compstate[insert]} $+MENUSELECT
'1 ' 0
%
```

`add-space` tag in previous completion adds space, if current completion is not used:
```zsh
% _comp_tags= _lastcomp[tags]='LOREM TAG IPSUM' .autocomplete.complete-word.post
% print -r - ${(q+)compstate[insert]} $+MENUSELECT
'1 ' 0
%
```

`add-space` tag in previous completion does NOT add space, if current completion is used:
```zsh
% _comp_tags='OTHER' _lastcomp[tags]='TAG' .autocomplete.complete-word.post
% print -r - ${(q+)compstate[insert]} $+MENUSELECT
1 0
%
```
