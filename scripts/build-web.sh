#!/usr/bin/env bash
# Builds the Flutter web app and copies it into api/public so the Express
# server can serve everything from a single origin (Option A deploy).
#
# No app token is baked into the build: the web app fetches it at runtime from
# the API's /app-config endpoint, so it always matches the server's
# APP_CLIENT_TOKEN. No BEACH_TALK_API_URL is passed either: the web build talks
# to the same origin it is served from (see defaultRealtimeApiBaseUri).
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$repo_root"

echo "Building Flutter web..."
flutter build web --release

echo "Copying build/web -> api/public..."
rm -rf api/public
cp -r build/web api/public

# Serve the loop video as a plain static file (NOT a Flutter asset) so the
# service worker does not cache it and break HTTP Range requests on web.
# VideoOrb loads it from the same origin as /raquete.mp4.
echo "Copying raquete.mp4 -> api/public..."
cp raquete.mp4 api/public/raquete.mp4

echo "Done. api/public is ready to be served by the API."
