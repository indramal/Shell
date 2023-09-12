 #!/bin/bash 

echo -e "\n##################################"
echo -e "#### Installation starting... ####"
echo -e "##################################\n"

sudo apt update && sudo apt upgrade -y

echo -e "\n############################"
echo -e "#### Webmin Installation ####"
echo -e "#############################\n"

curl -o setup-repos.sh https://raw.githubusercontent.com/webmin/webmin/master/setup-repos.sh
sh setup-repos.sh

apt-get install webmin --install-recommends

service webmin start

sudo systemctl enable webmin

sudo /usr/share/webmin/changepass.pl /etc/webmin root 0776046720

echo -e "\n################################"
echo -e "#### Cyberpanel Installation ####"
echo -e "#################################\n"

sh <(curl https://cyberpanel.net/install.sh || wget -O - https://cyberpanel.net/install.sh)

echo -e "\n#########################"
echo -e "#### Installation end ####"
echo -e "##########################\n"
