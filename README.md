# gavinsdavies.com

[![Netlify Status](https://api.netlify.com/api/v1/badges/c2c54b70-be07-468c-b9ab-cd88eeeb8ae6/deploy-status)](https://app.netlify.com/projects/gavinsdavies/deploys)

Personal website of [Gavin S. Davies](https://gavinsdavies.com), Associate Professor of Physics & Astronomy at the University of Mississippi.

Built with [Hugo](https://gohugo.io/) and [PaperMod](https://github.com/adityatelange/hugo-PaperMod).

## Local development

Requires [pixi](https://pixi.sh):

```bash
pixi install
npm install
npm run sync:cv
pixi run hugo server
```

The CV link is generated at build time. `scripts/sync-cv.sh` downloads the
published PDF from `gavinsdavies/cv`'s `orphan/lualatex` branch. Set
`CV_PDF_URL` to override the source URL.
