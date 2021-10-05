Setup:
```zsh
% zmodload zsh/param/private
% autoload -Uz zmathfunc && zmathfunc
% autoload -Uz $PWD/functions/widget/.autocomplete.complete-word.post
% unset terminfo
% typeset -gA compstate=() _lastcomp=() terminfo=()
% zstyle ':autocomplete:*' add-space 'FOO' 'TAG' 'BAR'
% zstyle ':autocomplete:(|shift-)tab:' widget-style complete-word
% KEYS=$'\t' WIDGET=complete-word terminfo[kcbt]=BACKTAB
% compstate[old_list]=keep compstate[nmatches]=0 _lastcomp[nmatches]=2
%
```

If we have only 1 match, just insert it:
```zsh
% _lastcomp[nmatches]=1
% .autocomplete.complete-word.post
% print -r -- ${(q+)compstate[insert]} $+compstate[list] $+MENUSELECT
1 0 0
% _lastcomp[nmatches]=2
%
```

If we have more than 1 match, but there's no old list, then show the list and don't insert:
```zsh
% compstate[old_list]= compstate[nmatches]=2
% .autocomplete.complete-word.post
% print -r -- ${(q+)compstate[insert]} $+compstate[list] $+MENUSELECT
'' 1 0
% compstate[old_list]=keep compstate[nmatches]=0
%
```

`menu-*` widgets set `$compstate[insert]` to `menu:*`:
```zsh
% zstyle ':autocomplete:shift-tab:' widget-style reverse-menu-complete
% KEYS=$terminfo[kcbt]
% .autocomplete.complete-word.post
% print -r -- ${(q+)compstate[insert]} $+compstate[list] $+MENUSELECT
menu:0 0 0
% zstyle ':autocomplete:shift-tab:' widget-style complete-word
% KEYS=$'\t'
%
```

Widgets default to `menu-select`, which sets `$MENUSELECT`, even without old list:
```zsh
% KEYS=OTHER  compstate[old_list]= compstate[nmatches]=2
% .autocomplete.complete-word.post
% print -r -- ${(q+)compstate[insert]} $+compstate[list] $+MENUSELECT
menu:1 0 1
% KEYS=$'\t' compstate[old_list]=keep compstate[nmatches]=0
%
```

`Shift-Tab` key sets `$compstate[insert]` to `*0`:
```zsh
% KEYS=$terminfo[kcbt]
% .autocomplete.complete-word.post
% print -r -- ${(q+)compstate[insert]} $+compstate[list] $+MENUSELECT
0 0 0
% KEYS=$'\t'
%
```

If the list is showing and there's an `add-space` tag in the last completion, then add a space:
```zsh
# % functions -T .autocomplete.complete-word.post
% _comp_tags='OTHER' _lastcomp[tags]='LOREM TAG IPSUM'
% .autocomplete.complete-word.post
% print -r -- ${(q+)compstate[insert]} $+compstate[list] $+MENUSELECT
'1 ' 0 0
% compstate[old_list]= _lastcomp[tags]=
%
```

If the list is not showing and there's an `add-space` tag in the new completion, then add a space:
```zsh
% compstate[old_list]= _comp_tags='LOREM TAG IPSUM' _lastcomp[tags]='OTHER'
% .autocomplete.complete-word.post
% print -r -- ${(q+)compstate[insert]} $+compstate[list] $+MENUSELECT
'1 ' 0 0
% compstate[old_list]=keep _comp_tags= _lastcomp[tags]=
%
```
