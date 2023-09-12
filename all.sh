 #!/bin/bash 

echo -e "\n##################################"
echo -e "#### Installation starting... ####"
echo -e "##################################\n"

sudo apt update && sudo apt upgrade -y

sudo timedatectl set-timezone Asia/Colombo

timedatectl

echo -e "\n############################"
echo -e "#### Webmin Installation ####"
echo -e "#############################\n"

curl -o setup-repos.sh https://raw.githubusercontent.com/webmin/webmin/master/setup-repos.sh
sh setup-repos.sh

apt-get install webmin --install-recommends

service webmin start

sudo systemctl enable webmin

read -s -p "Enter the new WebMin password: " password

sudo /usr/share/webmin/changepass.pl /etc/webmin root "$password"

unset password

echo -e "\n################################"
echo -e "#### Cyberpanel Installation ####"
echo -e "#################################\n"

sh <(curl https://cyberpanel.net/install.sh || wget -O - https://cyberpanel.net/install.sh)

echo -e "\n#########################"
echo -e "#### Installation end ####"
echo -e "##########################\n"
