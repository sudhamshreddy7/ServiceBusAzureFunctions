#!/bin/bash
# ===============================================================
# Azure Service Bus Queue Message Sender
# Generates a SAS token and sends a message to a Service Bus queue
# ===============================================================

# --- CONFIGURATION ---
NAMESPACE="test-service-bus-azure-functions"     # your Service Bus namespace
QUEUE="testqueue"                                # your queue name
KEY_NAME="testing"             # shared access policy name
KEY_VALUE=""                      # shared access key (from Azure portal)
MESSAGE='{"data":"hello"}'                       # message body (JSON)

# --- SETUP ---
ENDPOINT="https://${NAMESPACE}.servicebus.windows.net/${QUEUE}/messages"
EXPIRY=$(( $(date +%s) + 3600 )) # valid for 1 hour

# --- URL ENCODE ENDPOINT ---
ENCODED_URI=$(python3 -c "import urllib.parse; print(urllib.parse.quote('''$ENDPOINT''', safe=''))")

# --- GENERATE SIGNATURE ---
STRING_TO_SIGN="${ENCODED_URI}\n${EXPIRY}"
SIGNATURE=$(echo -n -e $STRING_TO_SIGN | openssl dgst -sha256 -hmac $KEY_VALUE -binary | base64)
ENCODED_SIGNATURE=$(python3 -c "import urllib.parse; print(urllib.parse.quote('''$SIGNATURE''', safe=''))")

# --- BUILD SAS TOKEN ---
SAS_TOKEN="SharedAccessSignature sr=${ENCODED_URI}&sig=${ENCODED_SIGNATURE}&se=${EXPIRY}&skn=${KEY_NAME}"

echo "==============================================================="
echo "Generated SAS Token:"
echo "$SAS_TOKEN"
echo "==============================================================="
echo "Sending message to queue '${QUEUE}' ..."
echo "==============================================================="

# --- SEND MESSAGE ---
az rest \
  --method post \
  --url $ENDPOINT \
  --headers "Authorization=$SAS_TOKEN" "Content-Type=application/json" \
  --body "$MESSAGE"

STATUS=$?

if [ $STATUS -eq 0 ]; then
  echo "✅ Message sent successfully!"
else
  echo "❌ Failed to send message (status code: $STATUS)"
fi
