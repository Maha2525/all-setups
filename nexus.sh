#create amazonlinux ec2 with t2.micro and 30 gb of ebs with port 8081 

sudo yum update -y
sudo yum install wget -y
sudo yum install java-17-amazon-corretto-jmods -y
sudo mkdir /app && cd /app
sudo wget https://download.sonatype.com/nexus/3/nexus-unix-x86-64-3.79.0-09.tar.gz
sudo tar -xvf nexus-unix-x86-64-3.79.0-09.tar.gz
sudo mv nexus-unix* nexus
sudo adduser nexus
sudo chown -R nexus:nexus /app/nexus-3.79.0-09
sudo chown -R nexus:nexus /app/sonatype-work
sudo echo "run_as_user="nexus"" > /app/nexus-3.79.0-09/bin/nexus.rc
sudo tee /etc/systemd/system/nexus.service > /dev/null << EOL
[Unit] 
Description=nexus service
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
User=nexus
Group=nexus
ExecStart=/app/nexus-3.79.0-09/bin/nexus start
ExecStop=/app/nexus-3.79.0-09/bin/nexus stop
User=nexus
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOL
sudo chkconfig nexus on
sudo systemctl start nexus
sudo systemctl status nexus
