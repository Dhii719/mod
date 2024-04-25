bash
#!/bin/bash

TELEGRAM_TOKEN="TOKEN_BOT_KAMU"
CHAT_ID="ID_CHAT_TELEGRAM_KAMU"

if [ "$1" == "run" ]; then
  shift
  ssh user@host "$@"
else
  MESSAGE="Perintah SSH diterima: $*"
  curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage" -d chat_id="$CHAT_ID" -d text="$MESSAGE"
fi
