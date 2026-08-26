#!/usr/bin/env bash
#
# The Vercel build entry point.
#
# Vercel's build image ships neither Flutter nor Dart, so this installs the
# SDK before building. That is the whole reason this file exists — everything
# below the install is one line, and it is the same line CI runs.
#
# PATH cannot be shared between Vercel's `installCommand` and `buildCommand`
# (separate shells), so the install lives here, in the build, guarded by a
# check so a warm cache skips it.
set -euo pipefail

FLUTTER_DIR="${FLUTTER_DIR:-$PWD/.flutter}"
FLUTTER_CHANNEL="${FLUTTER_CHANNEL:-stable}"

if [ ! -x "$FLUTTER_DIR/bin/flutter" ]; then
  echo "==> Installing Flutter ($FLUTTER_CHANNEL) into $FLUTTER_DIR"
  # --depth 1: the full history is ~1 GB and nothing here reads it.
  git clone --depth 1 --branch "$FLUTTER_CHANNEL" \
    https://github.com/flutter/flutter.git "$FLUTTER_DIR"
else
  echo "==> Reusing cached Flutter at $FLUTTER_DIR"
fi

export PATH="$FLUTTER_DIR/bin:$FLUTTER_DIR/bin/cache/dart-sdk/bin:$PATH"

# Vercel's image runs as a user without a writable default pub cache in some
# configurations; keeping both caches inside the workspace avoids that and
# lets Vercel cache them between builds.
export PUB_CACHE="${PUB_CACHE:-$PWD/.pub-cache}"

flutter --version
flutter precache --web

# The one line CI also runs. Everything about origin, base href, registry
# staging and validation lives in there, not here — see
# `tool/deploy_site/lib/build_site.dart` and `.env.example`.
dart pub get
dart run tool/deploy_site/bin/build_site.dart
