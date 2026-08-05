# Configuration
The following are the most commonly requested ways to configure Autocomplete's behavior. To use
these, add the code shown to your `.zshrc` file and modify it there, then restart your shell.

## Colored completions
You can use [Z Colors](https://github.com/marlonrichert/zcolors) for this.

## Pass arguments to `compinit`
If necessary, you can let Autocomplete pass arguments to `compinit` as follows:
```sh
zstyle '*:compinit' arguments -D -i -u -C -w
```

## Start each command line in history search mode
You can make Autocomplete behave as if you pressed <kbd>Ctrl</kbd><kbd>R</kbd> at the start of
each new command line:
```zsh
zstyle ':autocomplete:*' default-context history-incremental-search-backward
```

### Change the order of completions
You can make Autocomplete list specific types of completions before all other completions, for
example:
```zsh
zstyle ':completion:*:' group-order \
  options executables directories suffix-aliases aliases functions builtins reserved-words
```
These will then be listed in the order you specify them, followed by all other completions.

## Excluding completions
There are two ways available to prevent certain completions from being shown.

### Don't show completions if the current word matches a pattern
For example, this will stop completions from showing whenever the current word consists of two or
more dots:
```zsh
zstyle ':autocomplete:*' ignored-input '..##'  # Don't complete when the word is 2 or more dots.
```

### Don't suggest certain words as completions
For example, to exclude `ls`, `cd` and `pwd` from command completions, you can use this:
```zsh
zstyle ':completion:*:-command-:*:commands' ignored-patterns 'ls' 'cat' 'grep'
```
Conversely, to get _only_ `curl`, `git`, `docker` and `kubectl` as command
completions, you can use this:
```zsh
zstyle ':completion:*:-command-:*:commands' ignored-patterns '^(curl|docker|git|kubectl)'
```

## Completion suffixes
Some completions automatically have a specific character inserted after them.

### Add or don't add a space after certain completions
When inserting a completion, a space is added after certain types of completions. The default list
is as follows:
```zsh
zstyle ':autocomplete:*' add-space \
    executables aliases functions builtins reserved-words commands
```
Modifying this list will change when a space is inserted. If you change the list to `'*'`, a space
is always inserted. If you put no elements in the list, then a space is never inserted.

### Don't add a semicolon after history completions
By default, Autocomplete adds a semicolon to each history line to allow adding another line with
<kbd>Ctrl</kbd><kbd>Space</kbd>. You can deactivate this feature as follows:
```zsh
zstyle ':autocomplete:*' add-semicolon no
```

## Response timing
Autocomplete's timing can be tuned with the settings below.

### Wait for a minimum amount of input
To suppress autocompletion until a minimum number of characters have been typed:
```zsh
zstyle ':autocomplete:*' min-input 3
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

## Recent directories/files
Autocomplete can automatically complete recent directories. If you provide a backend for it, it can
also complete recent files.

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

## Listing length
The settings below adjust how many completion lines are shown at once.

### Real-time completion lines
By default, Autocomplete limits all real-time listings to a maximum of 16 lines. You can change
these limits as follows:

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

### History menu lines
For performance reasons and to prevent the prompt from jumping around, the history menu loads only
just enough lines to fill half of the screen by default. If you don't mind waiting a bit longer for
it to open and your prompt jumping to the top of the screen, you can increase this as follows:
```zsh
zstyle ':autocomplete:history-search-backward:*' list-lines 2000
```

However, if you truly need to go back in history that far, I recommend activating history completion
instead. See [_Keyboard Shortcuts_](README.md#keyboard-shortcuts) in README.md.

## First insert the common substring
You can make any completion widget first insert the longest sequence of characters that will
complete to all completions shown, if any, before inserting actual completions:
```zsh
# all Tab widgets
zstyle ':autocomplete:*complete*:*' insert-unambiguous yes

# all history widgets
zstyle ':autocomplete:*history*:*' insert-unambiguous yes

# ^S
zstyle ':autocomplete:menu-search:*' insert-unambiguous yes
```

### Insert longest common prefix
When using the above, if you want each widget to first try to insert only the longest _prefix_ that
will complete to all completions shown, if any, then add the following:
```zsh
zstyle ':completion:*:*' matcher-list 'm:{[:lower:]-}={[:upper:]_}' '+r:|[.]=**'
```
Note, though, that this will also slightly change what completions are listed initially. This is a
limitation of the underlying implementation in Zsh.

### Common substring presentation
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

## Keybindings
You can use [Zsh's `bindkey`
command](https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html#Zle-Builtins), _after_ loading
Autocomplete, to customize your keybindings. Below are some examples of what you can do with this.

### Make <kbd>Tab</kbd> and <kbd>Shift</kbd><kbd>Tab</kbd> cycle completions on the command line
This makes <kbd>Tab</kbd> and <kbd>Shift</kbd><kbd>Tab</kbd>, when pressed on the command line,
cycle through listed completions, without changing what's listed in the menu:
```sh
bindkey              '^I'         menu-complete
bindkey "$terminfo[kcbt]" reverse-menu-complete
```

### Make <kbd>Tab</kbd> and <kbd>Shift</kbd><kbd>Tab</kbd> go to the menu
This makes <kbd>Tab</kbd> and <kbd>Shift</kbd><kbd>Tab</kbd>, when pressed on the command line,
enter the menu instead of inserting a completion:
```sh
bindkey              '^I' menu-select
bindkey "$terminfo[kcbt]" menu-select
```

### Make <kbd>Tab</kbd> and <kbd>Shift</kbd><kbd>Tab</kbd> change the selection in the menu
This makes <kbd>Tab</kbd> and <kbd>Shift</kbd><kbd>Tab</kbd> move the selection in the menu right
and left, respectively, instead of exiting the menu:
```sh
bindkey -M menuselect              '^I'         menu-complete
bindkey -M menuselect "$terminfo[kcbt]" reverse-menu-complete
```

### Make <kbd>←</kbd> and <kbd>→</kbd> always move the cursor on the command line
This makes <kbd>←</kbd> and <kbd>→</kbd> always move the cursor on the command line, even when you
are in the menu:
```sh
bindkey -M menuselect  '^[[D' .backward-char  '^[OD' .backward-char
bindkey -M menuselect  '^[[C'  .forward-char  '^[OC'  .forward-char
```

### Make <kbd>Enter</kbd> always submit the command line
This makes <kbd>Enter</kbd> always submit the command line, even when you are in the menu:
```sh
bindkey -M menuselect '^M' .accept-line
```

### Restore Zsh-default history shortcuts
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
