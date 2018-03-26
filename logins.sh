#!/bin/bash

MONTH="$(date +%b)"
YEAR="$(date +%Y)"
echo "Logins for: " "${MONTH}" "${YEAR}"

/root/clast | grep "${MONTH}" | grep "${YEAR}"
#mail -s "test title" krkahn@gmail.com < /file.txt
