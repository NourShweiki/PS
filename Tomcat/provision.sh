#!/bin/bash
set -e

VER=9.0.98

# Java 8
apt-get update
apt-get install -y openjdk-8-jdk

# Tomcat 9
useradd -r -s /usr/sbin/nologin tomcat || true
mkdir -p /opt/tomcat
wget -q https://archive.apache.org/dist/tomcat/tomcat-9/v$VER/bin/apache-tomcat-$VER.tar.gz -O /tmp/tomcat.tar.gz
tar xzf /tmp/tomcat.tar.gz -C /opt/tomcat --strip-components=1
chown -R tomcat:tomcat /opt/tomcat

# Change port 8080 -> 7070
sed -i 's/port="8080"/port="7070"/' /opt/tomcat/conf/server.xml

# Run Tomcat as a service
cat > /etc/systemd/system/tomcat.service <<'EOF'
[Unit]
Description=Apache Tomcat 9
After=network.target

[Service]
Type=forking
User=tomcat
Environment=JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
Environment=CATALINA_HOME=/opt/tomcat
ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now tomcat