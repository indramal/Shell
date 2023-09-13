 #!/bin/bash 

echo -e "\n##################################"
echo -e "#### Installation starting... ####"
echo -e "##################################\n"

sudo apt update && sudo apt upgrade -y

sudo timedatectl set-timezone Asia/Colombo

timedatectl

echo -e "\n################################"
echo -e "#### Cyberpanel Installation ####"
echo -e "#################################\n"

# Link - https://community.cyberpanel.net/t/01-installing-cyberpanel/82/4

sh <(curl https://cyberpanel.net/install.sh || wget -O - https://cyberpanel.net/install.sh)

echo -e "\n############################"
echo -e "#### Webmin Installation ####"
echo -e "#############################\n"

# Link - https://webmin.com/download/

curl -o setup-repos.sh https://raw.githubusercontent.com/webmin/webmin/master/setup-repos.sh
sh setup-repos.sh

apt-get install webmin --install-recommends

service webmin start

sudo systemctl enable webmin

read -s -p "Enter the new WebMin password: " password

sudo /usr/share/webmin/changepass.pl /etc/webmin root "$password"

unset password

echo -e "\n################################"
echo -e "#### Prometheus Installation ####"
echo -e "#################################\n"

# Link - https://antonputra.com/monitoring/install-prometheus-and-grafana-on-ubuntu/

sudo useradd \
    --system \
    --no-create-home \
    --shell /bin/false prometheus

wget https://github.com/prometheus/prometheus/releases/download/v2.47.0/prometheus-2.47.0.linux-amd64.tar.gz

tar -xvf prometheus-2.47.0.linux-amd64.tar.gz

sudo mkdir -p /data /etc/prometheus

cd prometheus-2.47.0.linux-amd64

sudo mv prometheus promtool /usr/local/bin/

sudo mv consoles/ console_libraries/ /etc/prometheus/

sudo mv prometheus.yml /etc/prometheus/prometheus.yml

sudo chown -R prometheus:prometheus /etc/prometheus/ /data/

cd
rm -rf prometheus*

wget https://raw.githubusercontent.com/indramal/Shell/main/prometheus.service

sudo mv prometheus.service /etc/systemd/system/prometheus.service

sudo systemctl enable prometheus

sudo systemctl start prometheus

#sudo systemctl status prometheus

echo -e "\n###################################"
echo -e "#### Node Exporter Installation ####"
echo -e "####################################\n"

# Link - https://antonputra.com/monitoring/install-prometheus-and-grafana-on-ubuntu/

sudo useradd \
    --system \
    --no-create-home \
    --shell /bin/false node_exporter

wget https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.linux-amd64.tar.gz

tar -xvf node_exporter-1.6.1.linux-amd64.tar.gz

sudo mv \
  node_exporter-1.6.1.linux-amd64/node_exporter \
  /usr/local/bin/

rm -rf node_exporter*

wget https://raw.githubusercontent.com/indramal/Shell/main/node_exporter.service

sudo mv node_exporter.service /etc/systemd/system/node_exporter.service

sudo systemctl enable node_exporter

sudo systemctl start node_exporter

## prometheus.yml update point
## promtool check config /etc/prometheus/prometheus.yml
## curl -X POST http://localhost:9090/-/reload

echo -e "\n#############################"
echo -e "#### Grafana Installation ####"
echo -e "##############################\n"

# Link - https://antonputra.com/monitoring/install-prometheus-and-grafana-on-ubuntu/

sudo apt-get install -y apt-transport-https software-properties-common

wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -

echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list

sudo apt-get update
sudo apt-get -y install grafana

sudo systemctl enable grafana-server

sudo systemctl start grafana-server

#sudo systemctl status grafana-server

wget https://raw.githubusercontent.com/indramal/Shell/main/datasources.yaml

sudo mv datasources.yaml /etc/grafana/provisioning/datasources/datasources.yaml

sudo systemctl restart grafana-server

echo -e "\n###########################"
echo -e "#### Chenage Grafana Port ####"
echo -e "############################\n"

# Set the desired port number
desired_port=5000

# Set the path to the Grafana configuration file
grafana_config_file="/etc/grafana/grafana.ini"

# Check if the configuration file exists
if [ -f "$grafana_config_file" ]; then
  # Use grep and awk to extract the port number, allowing for both formats
  grafana_port=$(grep -E "^(;)?http_port" "$grafana_config_file" | awk -F= '{print $2}' | tr -d ' ')

  if [ -n "$grafana_port" ]; then
    if [ "$grafana_port" -eq "$desired_port" ]; then
      echo "Grafana is already running on port $desired_port."
    else
      if [[ "$grafana_port" == ";$desired_port" ]]; then
        # Remove the semicolon from the port number if it's present
        sed -i -E "s/;http_port = .*/http_port = $desired_port/" "$grafana_config_file"
        echo "Changed port from ;$desired_port to $desired_port."
      else
        echo "Grafana is running on port $grafana_port. Changing to port $desired_port..."
        # Use sed to replace the port number in the configuration file, allowing for both formats
        sed -i -E "s/^;?http_port = .*/http_port = $desired_port/" "$grafana_config_file"
        echo "Port has been changed to $desired_port."
      fi
    fi
  else
    echo "Unable to determine the Grafana port."
  fi
else
  echo "Grafana configuration file not found: $grafana_config_file"
fi

sudo systemctl restart grafana-server

echo -e "\n###########################"
echo -e "#### Installation ended ####"
echo -e "############################\n"

echo -e "\n#################################"
echo -e "#### add prometheus.yml codes ####"
echo -e "##################################\n"
