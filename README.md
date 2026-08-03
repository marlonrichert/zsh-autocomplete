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
    * Install the AUR package [zsh-autocomplete-git](https://aur.archlinux.org/packages/zsh-autocomplete-git)<sup>AUR</sup> from the Arch User Repository (for example, using [yay](https://github.com/Jguer/yay), an AUR helper):
      ```sh
       yay -S zsh-autocomplete-git
      ```
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
The keyboard shortcuts below are available after installing Autocomplete in clean Zsh environment.
Other plugins or scripts might override these bindings. If you find that some shortcuts don't work
as expected, then you can fix them by
  * changing the order in which you source your plugins or by
  * running [`bindkey` commands](#reassign-keys) in your dotfiles _after_ you source your plugins.

Depending on your terminal, not all keybindings might work for you. Also, instead of <kbd>Alt</kbd>,
your terminal might require you to press <kbd>Escape</kbd>, <kbd>Option</kbd> or <kbd>Meta</kbd>.
Finally, for keys that otherwise navigate the terminal buffer, such as <kbd>PgDn</kbd> and
<kbd>PgUp</kbd>, your terminal will require you to additionally press <kbd>Shift</kbd> or another
modifier key.

### On the command line
The table below lists which keyboard shortcuts are available on the command line when a particular
keymap is active. The default keymap on the command line is `main`, which is not an actual keymap but
an alias for another one. When Autocomplete adds shortcuts to `main`, they will actually be added to
the keymap for which it at that point is an alias. If you run `bindkey -v`, then `main` becomes an
alias for `viins`.

| `main` | `emacs` | `vicmd` | Command
| ---: | ---: | ---: | :---
| <kbd>Tab</kbd> | | | Insert first listed completion
| <kbd>Shift</kbd><kbd>Tab</kbd> | | | Expand the current word
| <kbd>↓</kbd> | <kbd>Ctrl</kbd><kbd>N</kbd> | <kbd>J</kbd> | Cursor down or enter completion menu
| <kbd>Alt</kbd><kbd>↓</kbd> | <kbd>Alt</kbd><kbd>N</kbd> | <kbd>Ctrl</kbd><kbd>N</kbd> | Enter completion menu
| <kbd>↑</kbd> | <kbd>Ctrl</kbd><kbd>P</kbd> | <kbd>K</kbd> | Cursor up or enter [history menu](#history-menu)
| <kbd>Alt</kbd><kbd>↑</kbd> | <kbd>Alt</kbd><kbd>P</kbd> | <kbd>Ctrl</kbd><kbd>P</kbd> | Enter history menu
| | <kbd>Ctrl</kbd><kbd>X</kbd> <kbd>/</kbd> | | Toggle recent path completion
| | <kbd>Ctrl</kbd><kbd>R</kbd> | <kbd>/</kbd> | Toggle history completion
| | <kbd>Ctrl</kbd><kbd>S</kbd> | <kbd>?</kbd> | Enter completion menu and start text search

### Inside each menu
The shortcuts below are available inside both completion and history menus. They are defined in the
`menuselect` keymap and can be modified there. If a key is not bound in `menuselect`, then its
behavior depends on the keymap from which you opened the menu. See the Zsh manual's section on [menu
selection](https://zsh.sourceforge.io/Doc/Release/Zsh-Modules.html#Menu-selection) for more info.

| Key sequence | Command
| ---: | :---
| <kbd>Tab</kbd><br><kbd>Shift</kbd><kbd>Tab</kbd> | Next/previous item
| <kbd>→</kbd><br><kbd>←</kbd><br><kbd>↓</kbd><br><kbd>↑</kbd> | Item right/left/down/up
| <kbd>Alt</kbd><kbd>↓</kbd><br><kbd>Alt</kbd><kbd>↑</kbd> | Section down/up
| <kbd>PgDn</kbd><br><kbd>PgUp</kbd> | Page down/up
| <kbd>Ctrl</kbd><kbd>S</kbd><br><kbd>Ctrl</kbd><kbd>R</kbd> | Start menu text search or go to next/previous match
| <kbd>Enter</kbd><br><kbd>Return</kbd> | Stop text search or exit menu
| <kbd>Ctrl</kbd><kbd>Space</kbd> | Add another item
| <kbd>Ctrl</kbd><kbd>-</kbd><br><kbd>Ctrl</kbd><kbd>/</kbd> | Undo last added item
| <kbd>Ctrl</kbd><kbd>C</kbd><br><kbd>Ctrl</kbd><kbd>G</kbd> | Undo all added items and exit menu


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

#### Customize common substring message
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

### Don't add a semicolon after history completions
By default, Autocomplete adds a semicolon to each history line to allow adding another line with
<kbd>Ctrl</kbd><kbd>Space</kbd>. You can deactivate this feature as follows:
```zsh
zstyle ':autocomplete:*' add-semicolon no
```

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
zstyle ':autocomplete:*' timeout 2  # seconds (int)
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
zstyle ':autocomplete:*' ignored-input '..##'  # Don't complete when the word is 2 or more dots.
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
```

Note that for all real-time listings, the maximum number of lines is additionally capped to the
number of lines that fit on screen.

## Change the number of lines in the history menu
For performance reasons and prevent the prompt from jumping around, the history menu loads only
just enough lines to fill half of the screen by default. If you don't mind waiting a bit longer for
it to open and your prompt jumping to the top of the screen, you can increase this as follows:
```zsh
zstyle ':autocomplete:history-search-backward:*' list-lines 2000
```

However, if you truly need to go back in history that far, I recommend activating history completion
instead. See [_Keyboard Shortcuts_](#keyboard-shortcuts), above.

### Use a custom backend for recent directories/files
Autocomplete by default uses [`cdr`](
https://zsh.sourceforge.io/Doc/Release/User-Contributions.html#Recent-Directories)
to keeping track of and list recent directories (but not files). Override the following two
functions to supply Autocomplete with recent directories/files from any source that you like:

```zsh
# This function should populate an array $reply with a list of absolute paths. Path completions are
# listed in the same order as in this array.
chpwd_recent_filehandler() {
  reply=( '/first/recent/dir' '/recent/file' '/second/recent/dir' )
}

# Called whenever you change dirs, to give you a chance to write the new dir to file.
# NOTE: If you override the function above, then you are *required* to override this one, too. Can
# be left empty, though.
chpwd_recent_dirs() {}
```

### Auto-include recent directories
Instead of having to press a keyboard shortcut, you can automatically include recent directories
whenever directories are listed:
```zsh
# Show recent dirs unless the current word is empty or equal to an existing directory.
zstyle -e ':completion:*:directories' fake '
    [[ -z $PREFIX$SUFFIX || -d $PREFIX$SUFFIX ]] ||
        +autocomplete:recent-directories
'
zstyle ':completion:*:directories' sort no
```


## Troubleshooting
Try the steps in the [bug report template](.github/ISSUE_TEMPLATE/bug-report.md).

## Author & License
See the [LICENSE](LICENSE) file for details.
