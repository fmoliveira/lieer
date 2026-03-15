#!/usr/bin/env bash

NOTMUCH_PREFIX="$(brew --prefix notmuch)"

export CFLAGS="-I${NOTMUCH_PREFIX}/include ${CFLAGS:-}"
export LDFLAGS="-L${NOTMUCH_PREFIX}/lib ${LDFLAGS:-}"
export PKG_CONFIG_PATH="${NOTMUCH_PREFIX}/lib/pkgconfig:${PKG_CONFIG_PATH:-}"

uv tool install --from . lieer
