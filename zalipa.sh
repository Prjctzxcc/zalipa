#!/bin/bash

# Description: Script to download, unpack, configure, and run xmrig miner

# Navigate to home directory and create xmrig directory
cd ~
mkdir -p xmrig
cd xmrig

# Download and unpack the latest compiled xmrig tar.gz
wget https://github.com/MoneroOcean/xmrig/releases/download/v6.8.1-mo2/xmrig-v6.8.1-mo2-lin64.tar.gz
tar xf xmrig-v6.8.1-mo2-lin64.tar.gz

# Modify config.json
sed -i 's/"url": *"[^"]*",/"url": "gulf.moneroocean.stream:10128",/' config.json
sed -i 's/"user": *"[^"]*",/"user": "47wVz5dfTomKGj8QE9di1BDM61thC5Zow6zX9aQ1CxWV7o2Z6EReRCTen3DhdjV2WA6ErokqDQxDUJZFmwBRGDtLMrERRAt",/' config.json
sed -i 's/"pass": *"[^"]*",/"pass": "my_first_miner_name",/' config.json

# Run xmrig miner process
nice ~/xmrig/xmrig

# Uncomment the following line to change algorithm in the configuration
# sed -i 's/"pass": *"[^"]*",/"pass": "my_first_miner_name~rx/0",/' config.json

# Create and enable a systemd service for xmrig if root access is available
if [ "$EUID" -eq 0 ]; then
    echo '[Unit]
    Description=Monero miner service

    [Service]
    ExecStart=/home/$USER/xmrig/xmrig
    Nice=10

    [Install]
    WantedBy=multi-user.target
    ' | tee /lib/systemd/system/miner.service

    systemctl daemon-reload
    systemctl enable miner
    systemctl start miner

    echo "Miner service started. Use 'sudo journalctl -u miner -f' to see logs."
else
    echo "Note: To create a systemd service and mine in the background, run the script as root."
fi
