#!/bin/sh
set -eu

workspace=$1
document=$2

case "$document" in
  "$workspace"/*) relative_document=${document#"$workspace"/} ;;
  *)
    printf 'Document is outside the workspace: %s\n' "$document" >&2
    exit 2
    ;;
esac

relative_directory=${relative_document%/*}
if [ "$relative_directory" = "$relative_document" ]; then
  relative_directory=.
fi

auxiliary_directory=$workspace/build/$relative_directory
tex_cache_directory=$workspace/build/.texlive-cache
mkdir -p "$auxiliary_directory" "$tex_cache_directory"

document_directory=${document%/*}
document_name=${document##*/}
TEXMFCACHE=$tex_cache_directory
TEXMFVAR=$tex_cache_directory
export TEXMFCACHE TEXMFVAR
cd "$document_directory"

exec latexmk \
  -pdf \
  -interaction=nonstopmode \
  -synctex=1 \
  -auxdir="$auxiliary_directory" \
  -outdir="$document_directory" \
  "$document_name"
