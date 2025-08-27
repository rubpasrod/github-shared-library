#!/usr/bin/env bash
set -euo pipefail

: "${API_TOKEN:?API_TOKEN is required}"
: "${BASE_URL:?BASE_URL is required}"
: "${ENGAGEMENT_NAME:?ENGAGEMENT_NAME is required}"
BASE_URL="${BASE_URL%/}"

command -v jq >/dev/null || { echo "jq is required"; exit 1; }

# Dates (GNU/BSD compatible)
TODAY=$(date +'%Y-%m-%d')
if TOMORROW=$(date -d 'tomorrow' +'%Y-%m-%d' 2>/dev/null); then
  :
else
  TOMORROW=$(date -v+1d +'%Y-%m-%d')
fi

# --- Check if engagement already exists (URL-encoded name) ---
GET_BODY="$(mktemp)"
GET_CODE=$(
  curl -sS -f -L -G \
    -H "Authorization: Token ${API_TOKEN}" \
    -H "Accept: application/json" \
    --data-urlencode "name=${ENGAGEMENT_NAME}" \
    -w "%{http_code}" \
    -o "$GET_BODY" \
    "${BASE_URL}/api/v2/engagements/" \
  || echo "000"
)

if [[ "$GET_CODE" = "200" ]]; then
  EXISTING_ID=$(jq -r '.results[0].id // empty' < "$GET_BODY" || true)
  if [[ -n "$EXISTING_ID" ]]; then
    echo "$EXISTING_ID"
    exit 0
  fi
elif [[ "$GET_CODE" != "000" ]]; then
  echo "GET /engagements failed with HTTP $GET_CODE"
  cat "$GET_BODY" || true
  exit 1
fi

# --- Create engagement ---
POST_BODY="$(mktemp)"
read -r -d '' PAYLOAD <<JSON
{
  "name": "$ENGAGEMENT_NAME",
  "product": 100,
  "target_start": "$TODAY",
  "target_end": "$TOMORROW",
  "status": "In Progress",
  "engagement_type": "Interactive",
  "lead": 1
}
JSON

POST_CODE=$(
  curl -sS -f -L \
    -H "Authorization: Token ${API_TOKEN}" \
    -H "Accept: application/json" \
    -H "Content-Type: application/json" \
    -d "$PAYLOAD" \
    -w "%{http_code}" \
    -o "$POST_BODY" \
    "${BASE_URL}/api/v2/engagements/" \
  || echo "000"
)

if [[ "$POST_CODE" != "201" ]]; then
  echo "POST /engagements failed with HTTP $POST_CODE"
  echo "Response:"
  cat "$POST_BODY" || true
  exit 1
fi

ENGAGEMENT_ID=$(jq -r '.id // empty' < "$POST_BODY")
if [[ -z "$ENGAGEMENT_ID" ]]; then
  echo "POST succeeded but response did not include an id. Raw response:"
  cat "$POST_BODY"
  exit 1
fi

echo "$ENGAGEMENT_ID"
