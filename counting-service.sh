#!/bin/bash

sudo apt update -y
sudo apt-get install net-tools zip curl jq tree unzip wget siege apt-transport-https ca-certificates software-properties-common gnupg lsb-release -y
curl -LO https://github.com/hashicorp/demo-consul-101/releases/download/v0.0.5/counting-service_linux_arm64.zip
sudo unzip counting-service_linux_arm64.zip
sudo rm -rf counting-service_linux_arm64.zip
sudo mv counting-service_linux_arm64 counting
sudo mv counting /usr/bin
sudo chmod 755 /usr/bin/counting
sudo chown vagrant:vagrant /usr/bin/counting 

sudo su
sudo cat > /usr/lib/systemd/system/counting-api.service << 'EOF'
[Unit]
Description=Counting API service
After=syslog.target network.target
 
[Service]
Environment=PORT="9003"
ExecStart=/usr/bin/counting
User=vagrant
Group=vagrant
ExecStop=/bin/sleep 5
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sleep 1
sudo systemctl enable counting-api.service
sudo systemctl start counting-api.service
sleep 1
sudo systemctl status counting-api.service
sudo lsof -i -P | grep counting