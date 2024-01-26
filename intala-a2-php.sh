#!/bin/bash
sudo apt-get update
sudo apt-get install apache2 -y
# Instalar PHP y módulos requeridos
sudo apt install php libapache2-mod-php php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip -y
# Reiniciar Apache para aplicar los cambios
sudo systemctl restart apache2


# instalamos unzip para descomprimir paquete wp
sudo apt install unzip
# Descargar e instalar WordPress
#wget https://wordpress.org/latest.zip
wget https://wordpress.org/wordpress-6.4.2.zip
unzip wordpress-6.4-2.zip
sudo mv wordpress /var/www/html/
sudo chown -R www-data:www-data /var/www/html/wordpress
sudo chmod -R 755 /var/www/html/wordpress
# Copiar el archivo de configuración de WordPress
sudo cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
# Limpiar archivos temporales
rm wordpress-6.4-2.zip

echo "Instalación completada.