---
title: "My daily software setup"
date: 2026-07-31
authors:
  - admin
summary: >
  A tour of the laptop, shell, and terminal tools I actually use every day:
  a Windows XPS 17, WSL, WezTerm, tmux, Atuin, and yadm for dotfiles.
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
Windows home directory, not the Linux one.

## tmux for persistence

tmux keeps sessions alive independent of the terminal window, which matters
most for long-running or remote work: a grid job monitor, an SSH session to a
gpvm, or a long build that I don't want to lose if WezTerm closes. Prefix is
remapped from the default Ctrl-b to Ctrl-a, panes split with `|` and `-`
instead of the default bindings, and Alt+arrow switches panes without needing
the prefix at all, which turns out to be the single biggest quality-of-life
change once it's muscle memory.

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
taped together.

## Why bother writing this down

Partly so I have somewhere to point collaborators and students who ask "wait,
how do you have your terminal set up," and partly because dotfiles rot if
nobody explains the reasoning behind them, only the syntax. A future me
re-reading `.tmux.conf` in two years will at least know why the prefix key
is remapped.
