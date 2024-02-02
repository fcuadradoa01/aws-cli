#!/bin/bash

# Instalar MariaDB Server
sudo apt update
sudo apt install mariadb-server -y

# Iniciar el servicio de MariaDB
sudo systemctl start mariadb

# Asegurar la instalación de MariaDB
sudo mysql_secure_installation
