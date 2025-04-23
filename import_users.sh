#!/bin/bash

INPUT_FILE="output/users.csv"

tail -n +2 "$INPUT_FILE" | while IFS=',' read -r email hash; do
    username=$(echo $email | cut -d@ -f1)
    sudo useradd -m -s /bin/bash "$username"
    echo "$username:$hash" | sudo chpasswd -e
    echo "[+] User $username created"
done
