#!/bin/bash
sudo apt-get update
sudo apt-get install apache2 -y
sudo apt install php libapache2-mod-php php-mysql -y
# instalamos unzip para descomprimir paquete wp
sudo apt install unzip