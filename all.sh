 #!/bin/bash 

echo "#### Installation stating... ####"

sudo apt update && sudo apt upgrade -y

echo "#### Webmin Installation ####"

curl -o setup-repos.sh https://raw.githubusercontent.com/webmin/webmin/master/setup-repos.sh
sh setup-repos.sh

apt-get install webmin --install-recommends

service webmin start

sudo systemctl enable webmin

sudo /usr/share/webmin/changepass.pl /etc/webmin root 0776046720

echo "#### Cyberpanel Installation ####"

sh <(curl https://cyberpanel.net/install.sh || wget -O - https://cyberpanel.net/install.sh)

echo "#### Installation end ####"
