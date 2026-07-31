#!/usr/bin/env sh
set -eu

site_root="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
target="$site_root/static/uploads/cv.pdf"
remote_cv="${CV_PDF_URL:-https://raw.githubusercontent.com/gavinsdavies/cv/orphan/lualatex/gavinsdavies.pdf}"

mkdir -p "$(dirname "$target")"

if command -v curl >/dev/null 2>&1; then
  tmp="$target.tmp"
  if curl --fail --location --silent --show-error "$remote_cv" --output "$tmp"; then
    mv "$tmp" "$target"
    echo "Synced CV from $remote_cv"
    exit 0
  fi
  rm -f "$tmp"
fi

echo "warning: CV PDF was not synced; $target will be absent" >&2
