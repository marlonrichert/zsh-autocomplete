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
* Easy to [configure](CONFIGURATION.md)

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
    * Install the AUR package
      [zsh-autocomplete-git](https://aur.archlinux.org/packages/zsh-autocomplete-git)<sup>AUR</sup>
      from the Arch User Repository (for example, using [yay](https://github.com/Jguer/yay), an AUR
      helper):
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
  * running [`bindkey` commands](CONFIGURATION.md#reassign-keys) in your dotfiles _after_ you source your plugins.

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
See [CONFIGURATION.md](CONFIGURATION.md) for the most commonly requested ways to configure
Autocomplete's behavior.

## Troubleshooting
Try the steps in the [bug report template](.github/ISSUE_TEMPLATE/bug-report.md).

## Author & License
See the [LICENSE](LICENSE) file for details.
