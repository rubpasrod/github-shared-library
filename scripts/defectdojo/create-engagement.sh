#!/bin/bash

API_TOKEN="${API_TOKEN}"
BASE_URL="${BASE_URL}"
ENGAGEMENT_NAME="${ENGAGEMENT_NAME}"


TODAY=$(date +'%Y-%m-%d')
TOMORROW=$(date -d "$TODAY + 1 day" +'%Y-%m-%d' 2>/dev/null || date -v+1d +'%Y-%m-%d')

RESPONSE=$(curl -s -X GET "$BASE_URL/api/v2/engagements/?name=$ENGAGEMENT_NAME" \
  -H "Authorization: Token $API_TOKEN")

EXISTING_ID=$(echo "$RESPONSE" | jq -r '.results[0].id // empty')

if [[ -n "$EXISTING_ID" ]]; then
    echo "$EXISTING_ID"
    exit 0
fi

RESPONSE=$(curl -s -X POST "$BASE_URL/api/v2/engagements/" \
    -H "Authorization: Token $API_TOKEN" \
    -H "Content-Type: application/json" \
    -d "{
      \"name\": \"$ENGAGEMENT_NAME\",
      \"product\": 100,
      \"target_start\": \"$TODAY\",
      \"target_end\": \"$TOMORROW\",
      \"status\": \"In Progress\",
      \"engagement_type\": \"Interactive\",
      \"lead\": 1
    }")

echo "Response: $RESPONSE"

ENGAGEMENT_ID=$(echo "$RESPONSE" | jq -r '.id')

if [[ "$ENGAGEMENT_ID" == "null" || -z "$ENGAGEMENT_ID" ]]; then
    echo "Failed to create engagement."
    exit 1
fi

echo "$ENGAGEMENT_ID" 