#!/bin/bash

OUTPUT_FILE="output/users.csv"
echo "Email,Password_Hash" > "$OUTPUT_FILE"

for user in $(su - zimbra -c "zmprov -l gaa"); do
    hash=$(su - zimbra -c "zmprov -l ga $user userPassword" | grep userPassword: | awk '{print $2}')
    echo "$user,$hash" >> "$OUTPUT_FILE"
done

echo "[+] User data saved to $OUTPUT_FILE"
