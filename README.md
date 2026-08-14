# gavinsdavies.com

[![Netlify Status](https://api.netlify.com/api/v1/badges/c2c54b70-be07-468c-b9ab-cd88eeeb8ae6/deploy-status)](https://app.netlify.com/projects/gavinsdavies/deploys)

Personal website of [Gavin S. Davies](https://gavinsdavies.com), Associate Professor of Physics & Astronomy at the University of Mississippi.

Built with [Hugo](https://gohugo.io/) and [PaperMod](https://github.com/adityatelange/hugo-PaperMod) (a Hugo Module, pinned in `go.mod`).

## Local development

Requires [pixi](https://pixi.sh):

```bash
pixi install
pixi run dev
```

`pixi run dev` installs the npm-side tooling, syncs the CV PDF, and starts
`hugo server`. Other tasks:

```bash
pixi run build     # production build (what Netlify runs)
pixi run sync-cv   # just re-sync the CV PDF
```

The CV link is generated at build time. `scripts/sync-cv.sh` downloads the
published PDF from `gavinsdavies/cv`'s `orphan/lualatex` branch and fails the
build if the download is missing, empty, or not a real PDF. Set
`CV_PDF_URL` to override the source URL.

## Adding a blog post

Posts live under `content/blog/<slug>/index.md` as page bundles (see
`content/blog/welcome/` or `content/blog/software-setup/` for examples).
Front matter needs at least `title`, `date`, and `authors: [admin]`; `summary`
and `tags` are optional but used on the listing page. New posts are picked up
automatically, no menu or index changes needed.

## Multilingual setup

English is the default/canonical language (served at `/`, no prefix).
Translated homepages live at `content/_index.<lang>.md` (`es`, `fr`, `da`,
`de`), currently short drafts rather than full translations. A few things to
know if you touch this:

- Every translation of a page must share the same `translationKey` in its
  front matter (the English homepage and its four translations all use
  `translationKey: home`) so Hugo links them together for the language
  switcher and `hreflang` tags. A page missing the shared key is treated as
  untranslated.
- Nav menus are per-language: `config/_default/menus.yaml` is English's menu,
  and `config/_default/menus.<lang>.yaml` fully replaces it for that
  language (there's no merging with the default, each file is self
  contained). Anchor links (e.g. `/#research`) must match that language's
  actual Goldmark-generated heading id, not the English one, since heading
  text differs per language.
- `content/search.<lang>.md` and `content/blog/_index.md` (English only, no
  blog translations yet) follow the same `translationKey` pattern.

## Layout overrides

`layouts/` only contains project-specific overrides of the vendored
PaperMod theme (in `_vendor/` after `hugo mod vendor`, or resolved from the
Hugo module cache otherwise):

- `layouts/index.html` — the homepage template (hero profile image with a
  generated srcset, then the `_index.md` content sections).
- `layouts/404.html` — the not-found page.
- `layouts/_partials/social_icons.html` — overrides PaperMod's social icon
  partial to fix accessible names/casing and add the INSPIRE-HEP icon.
- `layouts/_partials/extend_footer.html` — PaperMod's footer extension hook.
- `layouts/shortcodes/byline.html` — the `{{< byline >}}` shortcode used in
  blog posts, so the author byline markup isn't duplicated per post.

Everything else (header, search, list/single templates, etc.) comes
unmodified from the theme.

## Updating the PaperMod theme

PaperMod is pinned as a Hugo Module in `go.mod`. To bump it:

```bash
pixi run hugo mod get -u
pixi run hugo mod tidy
```

Then run `pixi run build` and check the diff before committing, since a
theme update can change template output or partial names our overrides
depend on.

## Known gaps

There's no CI in this repo yet. A `.github/workflows/` job running a link
checker (e.g. [lychee](https://github.com/lycheeverse/lychee) or
[htmltest](https://github.com/wjdp/htmltest)) over the built `public/`
output, on a schedule as well as on push, would catch dead links and broken
assets automatically (a scheduled run in particular would have caught the
`ichep2024.org` domain going dead) instead of relying on manual review. Not
set up yet; worth adding as a follow-up.
