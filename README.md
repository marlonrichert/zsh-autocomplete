# Autocomplete for Zsh
This plugin for Zsh adds real-time type-ahead autocompletion to your command line, similar to what
you find in desktop apps. While you type on the command line, available completions are listed
automatically; no need to press any keyboard shortcuts. Press <kbd>Tab</kbd> to insert the top
completion or <kbd>↓</kbd> to select a different one.

Additional features:
* Out-of-the-box configuration of Zsh's completion system
* Multi-line history search
* Completion of recent directories
* Useful [keyboard shortcuts](#keyboard-shortcuts)
* Easy to [configure](#configuration)

> Enjoy using this software? [Become a sponsor!](https://github.com/sponsors/marlonrichert) 💝

## Requirements
Recommended:
* Tested to work with [Zsh](http://zsh.sourceforge.net) 5.8 and newer.

Minimum:
* Should theoretically work with Zsh 5.4, but I'm unable to test that.

## Installation & setup
> Note: In this manual, `%` represents the command line prompt. If you see it in front of a command,
> it means you should run it on the command line, not put it in a script.

First, install Autocomplete itself. Here are some way to do so:
  * To use only releases (instead of the `main` branch), install `zsh-autocomplete` with a package
    manager. As of this writing, this package is available through Homebrew, Nix, `pacman`, Plumage,
    and (as `app-shells/zsh-autocomplete`) Portage.
  * To always use the latest commit on the `main` branch, do one of the following:
    * Use `pacman` to install `zsh-autocomplete-git`.
    * Use a Zsh plugin manager to install `marlonrichert/zsh-autocomplete`. (If you don't have a
      plugin manager yet, I recommend using [Znap](https://github.com/marlonrichert/zsh-snap).)
    * Clone the repo directly:
      ```sh
      % git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git
      ```

After installing, make the following modifications to your shell config:
* In your `.zshrc` file:
  * Remove any calls to `compinit`.
  * Add near the top, _before_ any calls to `compdef`:
     ```sh
     source /path/to/zsh-autocomplete/zsh-autocomplete.plugin.zsh
     ```
* When using **Ubuntu,** add to your `.zshenv` file:
  ```sh
  skip_global_compinit=1
  ```
* When using **Nix,** add to your `home.nix` file:
  ```
  programs.zsh.enableCompletion = false;
  ```

Finally, restart your shell. Here's two ways to do so:
* Open a new tab or window in your terminal.
* Replace the current shell with a new one:
  ```sh
  % exec zsh
  ```

### Updating
If you installed manually, run:
```sh
% git -C ~autocomplete pull
```
Otherwise, simply use your package manager or plugin manager's update mechanisms.

### Uninstalling
 1. Revert the actions you took to [install](#installation).
 1. Restart your shell.

## Keyboard shortcuts
| `main` | `emacs` | `vicmd` | On the command line | In the menus
| ---: | ---: | ---: | :--- | :---
| <kbd>Enter</kbd><br><kbd>Return</kbd> | | | | Exit menu text search or exit  menu
| <kbd>Tab</kbd> | | | Insert first listed menu item | Next completion
| <kbd>Shift</kbd><kbd>Tab</kbd> | | | Expand the current word | Previous completion
| <kbd>↓</kbd> | <kbd>Ctrl</kbd><kbd>N</kbd> | <kbd>J</kbd> | Cursor down or enter completion menu | Change selection
| <kbd>↑</kbd> | <kbd>Ctrl</kbd><kbd>P</kbd> | <kbd>K</kbd> | Cursor up or enter [history menu](#history-menu) | Change selection
| <kbd>Alt</kbd><kbd>↓</kbd> | <kbd>Alt</kbd><kbd>N</kbd> | <kbd>Ctrl</kbd><kbd>N</kbd> | Enter completion menu | Next section
| <kbd>Alt</kbd><kbd>↑</kbd> | <kbd>Alt</kbd><kbd>P</kbd> | <kbd>Ctrl</kbd><kbd>P</kbd> | Enter history menu | Previous section
| <kbd>PgDn</kbd> | | | | Page down
| <kbd>PgUp</kbd> | | | | Page up
| | <kbd>Ctrl</kbd><kbd>X</kbd> <kbd>/</kbd> | | Toggle recent path search |
| | <kbd>Ctrl</kbd><kbd>R</kbd> | <kbd>/</kbd> | Toggle history search | Start menu text search or go to previous match
| | <kbd>Ctrl</kbd><kbd>S</kbd> | <kbd>?</kbd> | Start menu text search | Start menu text search or go to next match
| | <kbd>Ctrl</kbd><kbd>Space</kbd> | <kbd>V</kbd> | Toggle selection mode | Add another item
| | <kbd>Ctrl</kbd><kbd>-</kbd><br><kbd>Ctrl</kbd><kbd>/</kbd> | <kbd>U</kbd> | | Undo last item
| | <kbd>Ctrl</kbd><kbd>G</kbd> | | | Undo all added items

### Caveats
* `main` is whichever keymap was aliased to `main` when Autocomplete was sourced.
  * By default, this is `emacs`.
  * If you run `bindkey -v` _before_ sourcing Autocomplete, then `main` will be `viins` when
     Autocomplete installs keybindings.
* Plugins or other scripts that you load _after_ loading Autocomplete may override these bindings.
  If you find that some shortcuts don't work as expected, then you can fix them by
  * changing the order in which you source your plugins or by
  * running [`bindkey` commands](#reassign-keys) in your dotfiles _after_ you source your plugins.
* Depending on your terminal, not all keybindings might be available to you.
* Instead of <kbd>Alt</kbd>, your terminal might require you to press <kbd>Escape</kbd>,
  <kbd>Option</kbd> or <kbd>Meta</kbd>.
* In the menus, the bindings listed under `vicmd` require you to press <kbd>Alt</kbd> for each,
  instead of just once.
* The bindings listed under `emacs` and `vicmd` are always both active in the menus, no matter which
  keymap you actually use. This is a limitation of Zsh.
* What any other keys do while you're in a menu depends on the keymap from which you opened the
  menu. See the Zsh manual section on [menu
  selection](https://zsh.sourceforge.io/Doc/Release/Zsh-Modules.html#Menu-selection) for more info.

## Configuration
The following are the most commonly requested ways to configure Autocomplete's behavior. To use any
of these, add the code shown to your `.zshrc` file and modify it there, then restart you shell.

### Reassign keys
You can use [Zsh's `bindkey`
command](https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html#Zle-Builtins), _after_ loading
Autocomplete, to customize your keybindings. Below are some examples of what you can do with this.

#### Make <kbd>Tab</kbd> and <kbd>Shift</kbd><kbd>Tab</kbd> cycle completions on the command line
This makes <kbd>Tab</kbd> and <kbd>Shift</kbd><kbd>Tab</kbd>, when pressed on the command line,
cycle through listed completions, without changing what's listed in the menu:
```sh
bindkey              '^I'         menu-complete
bindkey "$terminfo[kcbt]" reverse-menu-complete
```

#### Make <kbd>Tab</kbd> and <kbd>Shift</kbd><kbd>Tab</kbd> go to the menu
This makes <kbd>Tab</kbd> and <kbd>Shift</kbd><kbd>Tab</kbd>, when pressed on the command line,
enter the menu instead of inserting a completion:
```sh
bindkey              '^I' menu-select
bindkey "$terminfo[kcbt]" menu-select
```

#### Make <kbd>Tab</kbd> and <kbd>Shift</kbd><kbd>Tab</kbd> change the selection in the menu
This makes <kbd>Tab</kbd> and <kbd>Shift</kbd><kbd>Tab</kbd> move the selection in the menu right
and left, respectively, instead of exiting the menu:
```sh
bindkey -M menuselect              '^I'         menu-complete
bindkey -M menuselect "$terminfo[kcbt]" reverse-menu-complete
```

#### Make <kbd>←</kbd> and <kbd>→</kbd> always move the cursor on the command line
This makes <kbd>←</kbd> and <kbd>→</kbd> always move the cursor on the command line, even when you
are in the menu:
```sh
bindkey -M menuselect  '^[[D' .backward-char  '^[OD' .backward-char
bindkey -M menuselect  '^[[C'  .forward-char  '^[OC'  .forward-char
```

#### Make <kbd>Enter</kbd> always submit the command line
This makes <kbd>Enter</kbd> always submit the command line, even when you are in the menu:
```sh
bindkey -M menuselect '^M' .accept-line
```

#### Restore Zsh-default history shortcuts
This restores the default Zsh keybindings for history control:
```sh
bindkey -M emacs \
    "^[p"   .history-search-backward \
    "^[n"   .history-search-forward \
    "^P"    .up-line-or-history \
    "^[OA"  .up-line-or-history \
    "^[[A"  .up-line-or-history \
    "^N"    .down-line-or-history \
    "^[OB"  .down-line-or-history \
    "^[[B"  .down-line-or-history \
    "^R"    .history-incremental-search-backward \
    "^S"    .history-incremental-search-forward \
    #
bindkey -a \
    "^P"    .up-history \
    "^N"    .down-history \
    "k"     .up-line-or-history \
    "^[OA"  .up-line-or-history \
    "^[[A"  .up-line-or-history \
    "j"     .down-line-or-history \
    "^[OB"  .down-line-or-history \
    "^[[B"  .down-line-or-history \
    "/"     .vi-history-search-backward \
    "?"     .vi-history-search-forward \
    #
```

### Pass arguments to `compinit`
If necessary, you can let Autocomplete pass arguments to `compinit` as follows:
```sh
zstyle '*:compinit' arguments -D -i -u -C -w
```

### First insert the common substring
You can make any completion widget first insert the longest sequence of characters
that will complete to all completions shown, if any, before inserting actual completions:
```zsh
# all Tab widgets
zstyle ':autocomplete:*complete*:*' insert-unambiguous yes

# all history widgets
zstyle ':autocomplete:*history*:*' insert-unambiguous yes

# ^S
zstyle ':autocomplete:menu-search:*' insert-unambiguous yes
```

#### Insert prefix instead of substring
When using the above, if you want each widget to first try to insert only the longest _prefix_ that
will complete to all completions shown, if any, then add the following:
```zsh
zstyle ':completion:*:*' matcher-list 'm:{[:lower:]-}={[:upper:]_}' '+r:|[.]=**'
```
Note, though, that this will also slightly change what completions are listed initially. This is a
limitation of the underlying implementation in Zsh.

### Customize common substring message
You can customize the way the common substring is presented. The following sets the presentation to
the default:
```zsh
builtin zstyle ':autocomplete:*:unambiguous' format \
    $'%{\e[0;2m%}%Bcommon substring:%b %0F%11K%d%f%k'
```
`%d` will be replaced with the common substring. Additionally, the following [Zsh prompt escape
sequences](https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html#Visual-effects) are
supported for adding visual effects:
* `%B`: bold
* `%F`: foreground color
* `%K`: background color
* `%S`: `terminfo` "standout"
* `%U`: underline
* `%{...%}`: arbitrary [ANSI escape
   sequence](https://en.wikipedia.org/wiki/ANSI_escape_code#Select_Graphic_Rendition_parameters)

### Make <kbd>Enter</kbd> submit the command line straight from the menu
By default, pressing <kbd>Enter</kbd> in the menu search exits the search and
pressing it otherwise in the menu exits the menu.  If you instead want to make
<kbd>Enter</kbd> _always_ submit the command line, use the following:
```zsh
bindkey -M menuselect '\r' .accept-line
```

### Add or don't add a space after certain completions
When inserting a completion, a space is added after certain types of
completions.  The default list is as follows:
```zsh
zstyle ':autocomplete:*' add-space \
    executables aliases functions builtins reserved-words commands
```
Modifying this list will change when a space is inserted.  If you change the
list to `'*'`, a space is always inserted.  If you put no elements in the list,
then a space is never inserted.

### Start each command line in history search mode
This will make Autocomplete behave as if you pressed <kbd>Ctrl</kbd><kbd>R</kbd> at the start of
each new command line:
```zsh
zstyle ':autocomplete:*' default-context history-incremental-search-backward
```

### Wait with autocompletion until typing stops for a certain amount of seconds
Normally, Autocomplete fetches completions after you stop typing for about 0.05 seconds. You can
change this as follows:
```zsh
zstyle ':autocomplete:*' delay 0.1  # seconds (float)
```

### Wait longer before timing out autocompletion
Slow autocompletion can make the command line hang. Therefore, by default, Autocomplete waits at
most 1 second for completion to finish. You can change this value as follows:
```zsh
zstyle ':autocomplete:*' timeout 2.0  # seconds (float)
```
Note, though, that increasing this value can make your command line feel less responsive.

### Wait for a minimum amount of input
To suppress autocompletion until a minimum number of characters have been typed:
```zsh
zstyle ':autocomplete:*' min-input 3
```

### Don't show completions if the current word matches a pattern
For example, this will stop completions from showing whenever the current word consists of two or
more dots:
```zsh
zstyle ':autocomplete:*' ignored-input '..##'
```

## Change the max number of lines shown
By default, Autocomplete lets the history menu fill half of the screen, and limits all real-time
listings to a maximum of 16 lines. You can change these limits as follows:

```zsh
# Note: -e lets you specify a dynamically generated value.

# Override default for all listings
# $LINES is the number of lines that fit on screen.
zstyle -e ':autocomplete:*:*' list-lines 'reply=( $(( LINES / 3 )) )'

# Override for recent path search only
zstyle ':autocomplete:recent-paths:*' list-lines 10

# Override for history search only
zstyle ':autocomplete:history-incremental-search-backward:*' list-lines 8

# Override for history menu only
zstyle ':autocomplete:history-search-backward:*' list-lines 2000
```

Note that for all real-time listings, the maximum number of lines is additionally capped to the
number of lines that fit on screen. However, there is no such limit for the history menu. If that
generates more lines than fit on screen, you can simply use <kbd>PgUp</kbd> and <kbd>PgDn</kbd> to
scroll through the excess lines. (Note: On some terminals, you have to additionally hold
<kbd>Shift</kbd> or, otherwise, it will scroll the terminal buffer instead.)

### Use a custom backend for recent directories
Autocomplete comes with its own backend for keeping track of and listing recent directories (which
uses part of
[`cdr`](https://zsh.sourceforge.io/Doc/Release/User-Contributions.html#Recent-Directories) under the
hood). However, you can override this and supply Autocomplete with recent directories from any
source that you like. To do so, define a function like this:

```sh
+autocomplete:recent-directories() {
  <code>
  typeset -ga reply=( <any number of absolute paths> )
}
```

#### Add a backend for recent files
Out of the box, Autocomplete doesn't track or offer recent files. However, it will do so if you add
a backend for it:

```sh
+autocomplete:recent-files() {
  <code>
  typeset -ga reply=( <any number of absolute paths> )
}
```

## Troubleshooting
Try the steps in the
[bug report template](.github/ISSUE_TEMPLATE/bug-report.md).

## Author & License
See the [LICENSE](LICENSE) file for details.
