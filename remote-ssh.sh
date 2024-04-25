bash
#!/bin/bash

TELEGRAM_TOKEN="6903848119:AAGn9zxgTdDvoo4oj1n4azvWJXzDAP8w1Rs"
CHAT_ID="324500970"

if [ "$1" == "run" ]; then
  shift
  ssh user@host "$@"
else
  MESSAGE="Perintah SSH diterima: $*"
  curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage" -d chat_id="$CHAT_ID" -d text="$MESSAGE"
fi
