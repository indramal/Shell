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
echo -e "#### Chenge Grafana Port ####"
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
echo -e "#################################"
echo -e "PORTs:"
echo -e "Prometheus - 9090"
echo -e "Grafna - $desired_port"
echo -e "Node Exporter - 9100"
echo -e "WebMin - 10000"
echo -e "Openlitespeed - 7080"
echo -e "Cyberpanel - 8090"
echo -e "Push Gateway - 9091"
echo -e "Alert Manager - 9093"
echo -e "##################################\n"
