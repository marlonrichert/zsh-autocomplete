Setup:
```zsh
% source .clitest/__init__.zsh
% typeset -gA compstate=() _lastcomp=()
% typeset -ga comptags=()
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
% .autocomplete.complete-word.post
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
% .autocomplete.complete-word.post
% print -r -- ${(q+)compstate[insert]} $+MENUSELECT $MENUMODE
automenu-unambiguous 0
%
```

If we have only one match, always insert it.
```zsh
% compstate[old_list]=keep _lastcomp[tags]=
% compstate[nmatches]=0 _lastcomp[nmatches]=1
% WIDGETSTYLE=menu-select WIDGET=
% _autocomplete__unambiguous=
% .autocomplete.complete-word.post
% print -r -- ${(q+)compstate[insert]} $+MENUSELECT $MENUMODE
1 0
%
```

Add a space for certain tags.
```zsh
% compstate[old_list]=keep _lastcomp[tags]='BAR BAZ'
% compstate[nmatches]=0 _lastcomp[nmatches]=1
% WIDGETSTYLE=menu-select WIDGET=
% _autocomplete__unambiguous=
% comptags=( BAR ) .autocomplete.complete-word.post
% print -r -- ${(q+)compstate[insert]} $+MENUSELECT $MENUMODE
'1 ' 0
%
```

When there's more than one match, `menu-complete` inserts `menu:`.
```zsh
% compstate[old_list]=keep _lastcomp[tags]='BAR BAZ'
% compstate[nmatches]=0 _lastcomp[nmatches]=2
% WIDGETSTYLE=menu-complete WIDGET=
% _autocomplete__unambiguous=
% .autocomplete.complete-word.post
% print -r -- ${(q+)compstate[insert]} $+MENUSELECT $MENUMODE
'menu:1 ' 0
%
```

Reverse inserts the last match.
```zsh
% compstate[old_list]=keep _lastcomp[tags]='BAR BAZ'
% compstate[nmatches]=0 _lastcomp[nmatches]=2
% WIDGETSTYLE=reverse-menu-complete WIDGET=
% _autocomplete__unambiguous=
% .autocomplete.complete-word.post
% print -r -- ${(q+)compstate[insert]} $+MENUSELECT $MENUMODE
'menu:0 ' 0
%
```

`select` adds `MENUSELECT`
```zsh
% compstate[old_list]=keep _lastcomp[tags]='BAR BAZ'
% compstate[nmatches]=0 _lastcomp[nmatches]=2
% WIDGETSTYLE=menu-select WIDGET=
% _autocomplete__unambiguous=
% .autocomplete.complete-word.post
% print -r -- ${(q+)compstate[insert]} $+MENUSELECT $MENUMODE
'menu:1 ' 1
%
```

`search` adds `MENUMODE=search-forward`.
```zsh
% compstate[old_list]=keep _lastcomp[tags]='BAR BAZ'
% compstate[nmatches]=0 _lastcomp[nmatches]=2
% WIDGETSTYLE=menu-select WIDGET=incremental-history-search-forward
% _autocomplete__unambiguous=
% .autocomplete.complete-word.post
% print -r -- ${(q+)compstate[insert]} $+MENUSELECT $MENUMODE
'menu:1 ' 1 search-forward
%
```
