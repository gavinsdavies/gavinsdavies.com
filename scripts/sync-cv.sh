#!/usr/bin/env sh
set -eu

site_root="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
target="$site_root/static/uploads/cv.pdf"
remote_cv="${CV_PDF_URL:-https://raw.githubusercontent.com/gavinsdavies/cv/orphan/lualatex/gavinsdavies.pdf}"

mkdir -p "$(dirname "$target")"

if ! command -v curl >/dev/null 2>&1; then
  echo "error: curl is required to sync the CV PDF" >&2
  exit 1
fi

tmp="$target.tmp"

if ! curl --fail --location --silent --show-error "$remote_cv" --output "$tmp"; then
  rm -f "$tmp"
  echo "error: failed to download CV PDF from $remote_cv" >&2
  exit 1
fi

# Sanity-check the download: it must be a non-empty, genuine PDF, not an
# empty file or an HTML error page (e.g. a GitHub 404/redirect response).
if [ ! -s "$tmp" ]; then
  rm -f "$tmp"
  echo "error: downloaded CV PDF from $remote_cv is empty" >&2
  exit 1
fi

if ! head -c 5 "$tmp" | grep -q '^%PDF-'; then
  rm -f "$tmp"
  echo "error: downloaded file from $remote_cv does not look like a PDF" >&2
  exit 1
fi

mv "$tmp" "$target"
echo "Synced CV from $remote_cv"
