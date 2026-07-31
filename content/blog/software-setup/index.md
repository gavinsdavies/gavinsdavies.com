---
title: "My daily software setup"
date: 2026-07-31
authors:
  - admin
summary: >
  A tour of the laptop, shell, and terminal tools I actually use every day:
  a Windows XPS 17, WSL, WezTerm, tmux, zsh, Atuin, yadm, VS Code, and a trio
  of AI coding CLIs.
tags:
  - meta
  - tools
---

<div class="post-byline">
  <img src="/img/gsd-memoji.svg" alt="" width="32" height="32">
  <span>Gavin S. Davies</span>
</div>

Following up on the [intro post](/blog/welcome/), here's the setup I actually
work in day to day. None of this is exotic, but it's stable, it's synced
across machines, and it's the kind of thing I wish someone had written down
for me when I was assembling it.

## The hardware

I run a Windows Dell XPS 17. Windows is the host OS, but almost none of my
actual work happens there. It's a shell for WSL.

## WSL as the real environment

[WSL2](https://learn.microsoft.com/en-us/windows/wsl/about) runs Ubuntu, and
that's where the research computing happens: analysis code, grid job
submission, git, everything. The split works well in practice. Windows
handles hardware, drivers, and anything that wants a native GUI; Ubuntu
handles the actual software environment, which matters when your
collaborations assume a Linux-like target (novagpvm, emphaticgpvm, dunegpvm,
and the like all expect that world).

## WezTerm as the terminal

[WezTerm](https://wezterm.org/) is the terminal emulator on the Windows side,
configured to launch straight into WSL Ubuntu on startup rather than opening a
Windows shell first. A couple of details make the WSL boundary less annoying:

- Shift+Enter is remapped to send a plain carriage return, which is what
  Claude Code and most shells expect for a soft newline instead of submitting
  the line.
- A `gui-startup` hook maximizes the window automatically, so every new
  WezTerm launch starts full screen without me touching it.

The config lives at `~/.wezterm.lua` inside WSL and gets copied out to the
Windows side after edits, since WezTerm on Windows reads its config from the
Windows home directory, not the Linux one. The color scheme is
[Dracula](https://draculatheme.com/) (Tokyo Night is sitting commented out
right next to it as the backup option), and that same palette carries through
to the prompt below, so more on it there.

## tmux for persistence

tmux keeps sessions alive independent of the terminal window, which matters
most for long-running or remote work: a grid job monitor, an SSH session to a
gpvm, or a long build that I don't want to lose if WezTerm closes. Prefix is
remapped from the default Ctrl-b to Ctrl-a, panes split with `|` and `-`
instead of the default bindings, and Alt+arrow switches panes without needing
the prefix at all, which turns out to be the single biggest quality-of-life
change once it's muscle memory. `tmux-resurrect` and `tmux-continuum` (via
[TPM](https://github.com/tmux-plugins/tpm)) handle the actual persistence:
sessions get saved automatically and restored on the next tmux start, so a
reboot doesn't mean losing the panes I had open.

## zsh, plugins, and fzf

The shell itself is zsh, with a couple of plugins sourced directly rather
than through a full framework: `zsh-syntax-highlighting` for as-you-type
command coloring, and `zsh-autosuggestions` for fish-style history
completions as I type. [fzf](https://github.com/junegunn/fzf) adds fuzzy
file and history search on top of that. A small `ls` wrapper function
translates familiar flags (`-l`, `-t`, `-r`) onto
[eza](https://github.com/eza-community/eza) so directory listings get icons
and git status without having to relearn a new command.

## Atuin for shell history

[Atuin](https://atuin.sh/) replaces plain shell history with a searchable,
synced database of every command I've run, tagged with the directory and
exit code. The value isn't really the sync (though it's nice having the same
history on every machine); it's that searching history by content, not just
recency, turns "what was that command I ran last month to fix the CVMFS
mount" from a scrollback hunt into a two-second lookup.

## yadm for dotfiles

[yadm](https://yadm.io/) manages the dotfiles themselves: `.zshrc`,
`.tmux.conf`, `.wezterm.lua`, `.config/starship.toml`, and the various
`CLAUDE.md`/`AGENTS.md` agent instruction files that now live alongside them.
It's a thin wrapper around git, which means the whole home-directory config is
just a repo I can clone onto a new machine and be back to a working
environment in minutes, encrypted secrets included via `yadm encrypt`.

## The rest of the prompt

[Starship](https://starship.rs/) renders the actual prompt: current
directory, git branch and status, command duration, and the active Python
environment, all on a Dracula-themed palette that matches the WezTerm color
scheme, so the whole stack looks like one thing rather than four tools duct
taped together. The actual palette, straight out of `starship.toml`:

<div class="palette-swatch">
  <figure><span style="background:#282a36"></span><figcaption>background<br>#282a36</figcaption></figure>
  <figure><span style="background:#44475a"></span><figcaption>current line<br>#44475a</figcaption></figure>
  <figure><span style="background:#f8f8f2"></span><figcaption>foreground<br>#f8f8f2</figcaption></figure>
  <figure><span style="background:#6272a4"></span><figcaption>comment<br>#6272a4</figcaption></figure>
  <figure><span style="background:#8be9fd"></span><figcaption>cyan<br>#8be9fd</figcaption></figure>
  <figure><span style="background:#50fa7b"></span><figcaption>green<br>#50fa7b</figcaption></figure>
  <figure><span style="background:#ffb86c"></span><figcaption>orange<br>#ffb86c</figcaption></figure>
  <figure><span style="background:#ff79c6"></span><figcaption>pink<br>#ff79c6</figcaption></figure>
  <figure><span style="background:#bd93f9"></span><figcaption>purple<br>#bd93f9</figcaption></figure>
  <figure><span style="background:#ff5555"></span><figcaption>red<br>#ff5555</figcaption></figure>
  <figure><span style="background:#f1fa8c"></span><figcaption>yellow<br>#f1fa8c</figcaption></figure>
</div>

```toml
palette = "dracula"

[palettes.dracula]
background = "#282a36"
current_line = "#44475a"
foreground = "#f8f8f2"
comment = "#6272a4"
cyan = "#8be9fd"
green = "#50fa7b"
orange = "#ffb86c"
pink = "#ff79c6"
purple = "#bd93f9"
red = "#ff5555"
yellow = "#f1fa8c"
```

WezTerm runs the same [Dracula](https://draculatheme.com/) scheme, so moving
from a prompt to a diff to a man page never involves a jarring color shift.

## VS Code, for the GUI moments

<div class="tool-icons">
  <a class="tool-icon" href="https://code.visualstudio.com/" target="_blank" rel="noopener noreferrer" title="Visual Studio Code">
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M23.15 2.587L18.21.21a1.494 1.494 0 0 0-1.705.29l-9.46 8.63-4.12-3.128a.999.999 0 0 0-1.276.057L.327 7.261A1 1 0 0 0 .326 8.74L3.899 12 .326 15.26a1 1 0 0 0 .001 1.479L1.65 17.94a.999.999 0 0 0 1.276.057l4.12-3.128 9.46 8.63a1.492 1.492 0 0 0 1.704.29l4.942-2.377A1.5 1.5 0 0 0 24 20.06V3.939a1.5 1.5 0 0 0-.85-1.352zm-5.146 14.861L10.826 12l7.178-5.448v10.896z"/></svg>
    <span>VS Code</span>
  </a>
</div>

Most day-to-day work happens in the terminal, but VS Code covers everything
that benefits from a real editor: the [Remote - WSL
extension](https://code.visualstudio.com/docs/remote/wsl) connects straight
into the Ubuntu filesystem, so it's editing the same files the terminal
tools see, not a separate Windows-side copy. The config is intentionally
thin. A couple of keybinding tweaks so the terminal's copy/paste behaves the
way every other terminal on the machine does:

```json
[
  {
    "key": "ctrl+shift+c",
    "command": "workbench.action.terminal.copySelection",
    "when": "terminalFocus && terminalTextSelected"
  },
  {
    "key": "ctrl+shift+v",
    "command": "workbench.action.terminal.paste",
    "when": "terminalFocus"
  }
]
```

and an Emacs keybinding extension for anyone (like me) whose fingers learned
`C-x C-s` before they learned Ctrl+S.

## AI coding assistants

I run three different AI coding CLIs side by side, mostly because they're
each strongest in different places: Anthropic's Claude Code for the bulk of
day-to-day coding and agentic work (including most of the work behind this
site and the legwork to get configs and setup for this post), OpenAI's Codex CLI as a second opinion, and Google's
Antigravity, whose CLI is invoked as `agy` and whose config still lives
under `~/.gemini/`, a naming trail left over from its Gemini-model roots
that hasn't fully settled yet.

<div class="tool-icons">
  <a class="tool-icon" href="https://claude.com/product/claude-code" target="_blank" rel="noopener noreferrer" title="Claude Code">
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M17.3041 3.541h-3.6718l6.696 16.918H24Zm-10.6082 0L0 20.459h3.7442l1.3693-3.5527h7.0052l1.3693 3.5528h3.7442L10.5363 3.5409Zm-.3712 10.2232 2.2914-5.9456 2.2914 5.9456Z"/></svg>
    <span>Claude Code</span>
  </a>
  <a class="tool-icon" href="https://openai.com/codex/" target="_blank" rel="noopener noreferrer" title="OpenAI Codex">
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M22.2819 9.8211a5.9847 5.9847 0 0 0-.5157-4.9108 6.0462 6.0462 0 0 0-6.5098-2.9A6.0651 6.0651 0 0 0 4.9807 4.1818a5.9847 5.9847 0 0 0-3.9977 2.9 6.0462 6.0462 0 0 0 .7427 7.0966 5.98 5.98 0 0 0 .511 4.9107 6.051 6.051 0 0 0 6.5146 2.9001A5.9847 5.9847 0 0 0 13.2599 24a6.0557 6.0557 0 0 0 5.7718-4.2058 5.9894 5.9894 0 0 0 3.9977-2.9001 6.0557 6.0557 0 0 0-.7475-7.0729zm-9.022 12.6081a4.4755 4.4755 0 0 1-2.8764-1.0408l.1419-.0804 4.7783-2.7582a.7948.7948 0 0 0 .3927-.6813v-6.7369l2.02 1.1686a.071.071 0 0 1 .038.052v5.5826a4.504 4.504 0 0 1-4.4945 4.4944zm-9.6607-4.1254a4.4708 4.4708 0 0 1-.5346-3.0137l.142.0852 4.783 2.7582a.7712.7712 0 0 0 .7806 0l5.8428-3.3685v2.3324a.0804.0804 0 0 1-.0332.0615L9.74 19.9502a4.4992 4.4992 0 0 1-6.1408-1.6464zM2.3408 7.8956a4.485 4.485 0 0 1 2.3655-1.9728V11.6a.7664.7664 0 0 0 .3879.6765l5.8144 3.3543-2.0201 1.1685a.0757.0757 0 0 1-.071 0l-4.8303-2.7865A4.504 4.504 0 0 1 2.3408 7.872zm16.5963 3.8558L13.1038 8.364 15.1192 7.2a.0757.0757 0 0 1 .071 0l4.8303 2.7913a4.4944 4.4944 0 0 1-.6765 8.1042v-5.6772a.79.79 0 0 0-.407-.667zm2.0107-3.0231l-.142-.0852-4.7735-2.7818a.7759.7759 0 0 0-.7854 0L9.409 9.2297V6.8974a.0662.0662 0 0 1 .0284-.0615l4.8303-2.7866a4.4992 4.4992 0 0 1 6.6802 4.66zM8.3065 12.863l-2.02-1.1638a.0804.0804 0 0 1-.038-.0567V6.0742a4.4992 4.4992 0 0 1 7.3757-3.4537l-.142.0805L8.704 5.459a.7948.7948 0 0 0-.3927.6813zm1.0976-2.3654 2.602-1.4998 2.6069 1.4998v2.9994l-2.5974 1.4997-2.6067-1.4997Z"/></svg>
    <span>OpenAI Codex</span>
  </a>
  <a class="tool-icon" href="https://antigravity.google/" target="_blank" rel="noopener noreferrer" title="Google Antigravity">
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M12.48 10.92v3.28h7.84c-.24 1.84-.853 3.187-1.787 4.133-1.147 1.147-2.933 2.4-6.053 2.4-4.827 0-8.6-3.893-8.6-8.72s3.773-8.72 8.6-8.72c2.6 0 4.507 1.027 5.907 2.347l2.307-2.307C18.747 1.44 16.133 0 12.48 0 5.867 0 .307 5.387.307 12s5.56 12 12.173 12c3.573 0 6.267-1.173 8.373-3.36 2.16-2.16 2.84-5.213 2.84-7.667 0-.76-.053-1.467-.173-2.053H12.48z"/></svg>
    <span>Antigravity</span>
  </a>
</div>

<div class="callout">
  <span class="callout-title">Note</span>
  Icons via <a href="https://simpleicons.org/">simple-icons</a>, whose SVG
  shapes are released under CC0. The trademarks and brand identities they
  represent still belong to Anthropic, OpenAI, and Google respectively.
</div>

## The other half: notes in Obsidian

Everything above is the software side. There's an equally load-bearing
second brain sitting next to it: a git-tracked [Obsidian](https://obsidian.md/)
vault holding research notes, project logs, and daily journal entries, which
is where most of this post actually started as a scratch note before it
became a blog post.

<div class="callout">
  <span class="callout-title">Note</span>
  That vault, how it's organized, and how it fits together with the AI
  tools above is a big enough topic for its own post. More on that soon.
</div>

<div class="tool-icons">
  <a class="tool-icon" href="https://obsidian.md/" target="_blank" rel="noopener noreferrer" title="Obsidian">
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M19.355 18.538a68.967 68.959 0 0 0 1.858-2.954.81.81 0 0 0-.062-.9c-.516-.685-1.504-2.075-2.042-3.362-.553-1.321-.636-3.375-.64-4.377a1.707 1.707 0 0 0-.358-1.05l-3.198-4.064a3.744 3.744 0 0 1-.076.543c-.106.503-.307 1.004-.536 1.5-.134.29-.29.6-.446.914l-.31.626c-.516 1.068-.997 2.227-1.132 3.59-.124 1.26.046 2.73.815 4.481.128.011.257.025.386.044a6.363 6.363 0 0 1 3.326 1.505c.916.79 1.744 1.922 2.415 3.5zM8.199 22.569c.073.012.146.02.22.02.78.024 2.095.092 3.16.29.87.16 2.593.64 4.01 1.055 1.083.316 2.198-.548 2.355-1.664.114-.814.33-1.735.725-2.58l-.01.005c-.67-1.87-1.522-3.078-2.416-3.849a5.295 5.295 0 0 0-2.778-1.257c-1.54-.216-2.952.19-3.84.45.532 2.218.368 4.829-1.425 7.531zM5.533 9.938c-.023.1-.056.197-.098.29L2.82 16.059a1.602 1.602 0 0 0 .313 1.772l4.116 4.24c2.103-3.101 1.796-6.02.836-8.3-.728-1.73-1.832-3.081-2.55-3.831zM9.32 14.01c.615-.183 1.606-.465 2.745-.534-.683-1.725-.848-3.233-.716-4.577.154-1.552.7-2.847 1.235-3.95.113-.235.223-.454.328-.664.149-.297.288-.577.419-.86.217-.47.379-.885.46-1.27.08-.38.08-.72-.014-1.043-.095-.325-.297-.675-.68-1.06a1.6 1.6 0 0 0-1.475.36l-4.95 4.452a1.602 1.602 0 0 0-.513.952l-.427 2.83c.672.59 2.328 2.316 3.335 4.711.09.21.175.43.253.653z"/></svg>
    <span>Obsidian</span>
  </a>
</div>

## Why bother writing this down

Partly so I have somewhere to point collaborators and students who ask "wait,
how do you have your terminal set up," and partly because dotfiles rot if
nobody explains the reasoning behind them, only the syntax. A future me
re-reading `.tmux.conf` in two years will at least know why the prefix key
is remapped.
