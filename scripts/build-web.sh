#!/usr/bin/env bash
# Builds the Flutter web app and copies it into api/public so the Express
# server can serve everything from a single origin (Option A deploy).
#
# The app token is read from api/.env so it stays in sync with the server's
# APP_CLIENT_TOKEN. No BEACH_TALK_API_URL is passed: the web build talks to the
# same origin it is served from (see defaultRealtimeApiBaseUri).
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$repo_root"

if [[ ! -f api/.env ]]; then
  echo "api/.env not found. Copy api/.env.example and fill it in first." >&2
  exit 1
fi

app_token="$(grep '^APP_CLIENT_TOKEN=' api/.env | cut -d= -f2-)"
if [[ -z "$app_token" ]]; then
  echo "APP_CLIENT_TOKEN is empty in api/.env." >&2
  exit 1
fi

echo "Building Flutter web..."
flutter build web --release \
  --dart-define=BEACH_TALK_APP_TOKEN="$app_token"

echo "Copying build/web -> api/public..."
rm -rf api/public
cp -r build/web api/public

echo "Done. api/public is ready to be served by the API."
