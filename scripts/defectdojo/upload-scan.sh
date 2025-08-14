#!/bin/bash

API_TOKEN="${API_TOKEN}"
BASE_URL="${BASE_URL}"
ENGAGEMENT_ID="${ENGAGEMENT_ID}"
REPORTS_DIR="${GITHUB_WORKSPACE}/REPORTS_DIR/temp-reports"
REPORTS_FILE="$REPORTS_DIR/report_names.txt"
SCAN_TYPES_FILE="$REPORTS_DIR/scan_types.txt"

if [[ ! -f "$REPORTS_FILE" || ! -f "$SCAN_TYPES_FILE" ]]; then
    echo "Faltan report_names.txt o scan_types.txt en la ruta $REPORTS_DIR"
    exit 1
fi

paste "$REPORTS_FILE" "$SCAN_TYPES_FILE" | while IFS=$'\t' read -r REPORT_NAME SCAN_TYPE; do
    FILE_PATH="$REPORTS_DIR/$REPORT_NAME"

    if [[ ! -f "$FILE_PATH" ]]; then
        echo "Report not found: $FILE_PATH"
        continue
    fi

    echo "Uploading report: $REPORT_NAME (Scan Type: $SCAN_TYPE)"

    RESPONSE=$(curl -s -X GET "$BASE_URL/api/v2/tests/?engagement=$ENGAGEMENT_ID" \
    -H "Authorization: Token $API_TOKEN")

    EXISTING_TEST=$(echo "$RESPONSE" | jq -r --arg scan_type "$SCAN_TYPE" '.results[] | select(.test_type_name == $scan_type) | .id')

    TEST_ID=$(echo "$EXISTING_TEST" | head -n 1)

    if [[ -n "$EXISTING_TEST" ]]; then
        echo "$EXISTING_TEST tests found , doing reimport..."
        curl -s -X POST "$BASE_URL/api/v2/reimport-scan/" \
            -H "Authorization: Token $API_TOKEN" \
            -F "file=@$FILE_PATH" \
            -F "scan_type=$SCAN_TYPE" \
            -F "minimum_severity=Low" \
            -F "active=True" \
            -F "verified=True" \
            -F "engagement=$ENGAGEMENT_ID" \
            -F "test=$TEST_ID"
    else
        echo "Importing new test..."
        curl -s -X POST "$BASE_URL/api/v2/import-scan/" \
            -H "Authorization: Token $API_TOKEN" \
            -F "file=@$FILE_PATH" \
            -F "scan_type=$SCAN_TYPE" \
            -F "minimum_severity=Low" \
            -F "active=True" \
            -F "verified=True" \
            -F "engagement=$ENGAGEMENT_ID"
    fi

    echo "Report uploaded: $REPORT_NAME"
    echo
done