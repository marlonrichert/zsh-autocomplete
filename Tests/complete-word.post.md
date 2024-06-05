Setup:
```zsh
% source Tests/__init__.zsh
% typeset -gA compstate=() _lastcomp=()
% typeset -ga comptags=()
% typeset -g curcontext=
% zstyle ':autocomplete:*' add-space 'FOO' 'BAR'
% zstyle ':autocomplete:*' insert-unambiguous yes
%
```

If there is a common substring, insert it (if enabled).
```zsh
% compstate[old_list]=keep _lastcomp[tags]=
% compstate[nmatches]=0 _lastcomp[nmatches]=1
% WIDGETSTYLE= WIDGET=
% _autocomplete__unambiguous=FOO
% .autocomplete__complete-word__post
% print -r -- ${(q+)compstate[insert]} $+MENUSELECT $MENUMODE
unambiguous 0
%
```

When using a menu widget, add automenu.
```zsh
% compstate[old_list]=keep _lastcomp[tags]=
% compstate[nmatches]=0 _lastcomp[nmatches]=1
% WIDGETSTYLE=menu-select WIDGET=
% _autocomplete__unambiguous=FOO
% .autocomplete__complete-word__post
% print -r -- ${(q+)compstate[insert]} $+MENUSELECT $MENUMODE
automenu-unambiguous 0
%
```

Default inserts first match.
```zsh
% compstate[old_list]=keep _lastcomp[tags]=
% compstate[nmatches]=0 _lastcomp[nmatches]=2
% WIDGETSTYLE= WIDGET=
% _autocomplete__unambiguous=
% .autocomplete__complete-word__post
% print -r -- ${(q+)compstate[insert]}
1
%
```

Add a space for certain tags.
```zsh
% compstate[old_list]=keep _lastcomp[tags]='BAR BAZ'
% compstate[nmatches]=0 _lastcomp[nmatches]=1
% WIDGETSTYLE= WIDGET=
% _autocomplete__unambiguous=
% comptags=( BAR ) .autocomplete__complete-word__post
% print -r -- ${(q+)compstate[insert]}
'1 '
%
```

`menu-` widgets insert `menu:`.
```zsh
% compstate[old_list]=keep _lastcomp[tags]='BAR BAZ'
% compstate[nmatches]=0 _lastcomp[nmatches]=2
% WIDGETSTYLE=menu-complete WIDGET=
% _autocomplete__unambiguous=
% .autocomplete__complete-word__post
% print -r -- ${(q+)compstate[insert]} $+MENUSELECT $MENUMODE
'menu:1 ' 0
%
```

`menu-select` widgets add `MENUSELECT`
```zsh
% compstate[old_list]=keep _lastcomp[tags]='BAR BAZ'
% compstate[nmatches]=0 _lastcomp[nmatches]=2
% WIDGETSTYLE=menu-select WIDGET=
% _autocomplete__unambiguous=
% .autocomplete__complete-word__post
% print -r -- ${(q+)compstate[insert]} $+MENUSELECT $MENUMODE
'menu:1 ' 1
%
```

`menu-select` widgets with `search` in name add `MENUMODE=search-forward`.
```zsh
% compstate[old_list]=keep _lastcomp[tags]='BAR BAZ'
% compstate[nmatches]=0 _lastcomp[nmatches]=2
% WIDGETSTYLE=menu-select WIDGET=incremental-history-search-forward
% _autocomplete__unambiguous=
% .autocomplete__complete-word__post
% print -r -- ${(q+)compstate[insert]} $+MENUSELECT $MENUMODE
'menu:1 ' 1 search-forward
%
```

Reverse inserts the last match.
```zsh
% compstate[old_list]=keep _lastcomp[tags]='BAR BAZ'
% compstate[nmatches]=0 _lastcomp[nmatches]=2
% WIDGETSTYLE=reverse-menu-complete WIDGET=
% _autocomplete__unambiguous=
% .autocomplete__complete-word__post
% print -r -- ${(q+)compstate[insert]}
'menu:0 '
%
```
