# Linux

## 1- System Info Script

Create a file called `sysinfo.sh`:

```bash
#!/bin/bash

echo "System Information"
echo "Executed By: $(whoami)"
echo "Hostname: $(hostname)"
echo "Server IP: $(hostname -I | awk '{print $1}')"
echo "Public IP: $(curl -s ifconfig.me)"
echo "OS Type and Version: $(lsb_release -ds)"
echo "Kernel Version: $(uname -r)"
echo "Architecture: $(uname -m)"
echo "Server Time: $(date)"
echo "Timezone: $(timedatectl | grep "Time zone")"
echo "Uptime: $(uptime -p)"

echo ""
echo "Resource Usage"
free -h
echo "CPU Cores: $(nproc)"
```

Run it:

```bash
chmod +x sysinfo.sh
./sysinfo.sh
```

## 2- Create User PS

```bash
sudo groupadd PSgroup
sudo groupadd dba
sudo useradd -g PSgroup -G dba PS
```

## 3- Modify Root Password

```bash
sudo passwd root
```

## 4- Install MySQL and HAProxy

```bash
sudo apt update
sudo apt install mysql-server -y
sudo apt install haproxy -y
```

## 5- Allow Traffic Only on Port 3306

```bash
sudo ufw allow 3306/tcp
sudo ufw allow 3306/udp
sudo ufw enable
```

## 6- Copy a File to the VM (FTP)

Install an FTP server on the VM:

```bash
sudo apt install vsftpd -y
sudo systemctl start vsftpd
sudo systemctl enable vsftpd
```

From my local machine, copy the file to the VM:

```bash
ftp <VM_IP>
```

Log in with the VM user, then:

```
put localfile.txt
```

