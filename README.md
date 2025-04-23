# 🛠️ Zimbra Automation Internship Task
**By: Bhalchandra Chaudhari**

This project is part of the internship screening task for the role of System Administrator. It involves installing Zimbra Collaboration Suite (Open Source Edition) on a virtual machine and automating user extraction and import into a Linux system.

## ✅ Step 1: Environment Setup

**Chosen OS:** Ubuntu 22.04 LTS  
**System Requirements:**
- 4+ GB RAM (preferably 8 GB)
- 2+ CPUs
- Static IP
- FQDN (Fully Qualified Domain Name)

### 🔧 Host Configuration

sudo hostnamectl set-hostname vish.project.local
```
Edit `/etc/hosts` and add:
```
10.150.1.131 vish.project.local vish
```
Disable firewall temporarily:
```
sudo ufw disable

## ✅ Step 2: Zimbra Installation (Open Source Edition)
```
Install required dependencies:
```
sudo apt update
sudo apt install -y net-tools perl curl unzip wget tar libaio1 libtinfo5
```
Download and extract Zimbra:
```
wget https://github.com/maldua/zimbra-foss-builder/releases/download/zimbra-foss-build-ubuntu-22.04/10.1.6/zcs-10.1.6_GA_4200000.UBUNTU22_64.20250321114357.tgz
cd Downloads
tar -xvzf zcs-10.1.6_GA_4200000.UBUNTU22_64.20250321114357.tgz
cd zcs-10.1.6_GA_4200000.UBUNTU22_64.20250321114357
```
Run the installer:
```
sudo ./install.sh

**Installation Notes:**
- Accept the license
- Enable all core components (except `zimbra-imapd` and `zimbra-chat` - optional)
- Set admin password and domain as prompted

**Access Admin Console:**
```
https://<your-ip>:7071
```

## ✅ Step 3: Create Users via Admin Console

Create **10 random users** manually using the Admin Console.  
Use strong passwords and **store only the hashed form**.

## ✅ Step 4: Extract Users Script
```
📄 `scripts/extract_users.sh`
```
#!/bin/bash

OUTPUT_FILE="output/users.csv"
echo "Email,Password_Hash" > "$OUTPUT_FILE"

for user in $(su - zimbra -c "zmprov -l gaa"); do
    hash=$(su - zimbra -c "zmprov -l ga $user userPassword" | grep userPassword: | awk '{print $2}')
    echo "$user,$hash" >> "$OUTPUT_FILE"
done

echo "[+] User data saved to $OUTPUT_FILE"
```
Make it executable:
```
chmod +x scripts/extract_users.sh

## ✅ Step 5: Import Users to Linux
```
📄 `scripts/import_users.sh`
```
#!/bin/bash

INPUT_FILE="output/users.csv"

tail -n +2 "$INPUT_FILE" | while IFS=',' read -r email hash; do
    username=$(echo $email | cut -d@ -f1)
    sudo useradd -m -s /bin/bash "$username"
    echo "$username:$hash" | sudo chpasswd -e
    echo "[+] User $username created"
done


## 📂 Directory Structure

```
Downloads/
└── zcs-10.1.6_GA_4200000.UBUNTU22_64.20250321114357/
    ├── install.sh
    ├── other-zimbra-files...
    └── scripts/
        ├── extract_users.sh
        ├── import_users.sh
        └── output/
            └── users.csv
```

## 📌 Notes
- Ensure FQDN is correctly set up before Zimbra installation.
- Ensure user hashes from Zimbra are in a format compatible with Linux PAM modules.

## 📧 Contact
Feel free to reach out for any clarification or collaboration!

**Author:** Bhalchandra Chaudhari  
📍 Mumbai, India  
📧 bhalchandrachaudhari178@gmail.com
