#!/bin/bash

# Muestra todos los comandos que se han ejeutado.

set -x

# Incluimos las variables
source .env

# Actualización de repositorios
apt update

 

# Eliminamos descargas previas del repositorio.
rm -rf /tmp/iaw-practica-lamp

# Clonamos el repositorio del codigo fuente de la aplicación
git clone https://github.com/josejuansanchez/iaw-practica-lamp.git /tmp/iaw-practica-lamp

# Movemos el código fuente de la aplicación a /var/www/html

mv /tmp/iaw-practica-lamp/src/* /var/www/html

# Configuramos el archivo config.php de la aplicación

sed -i "s/database_name_here/$DB_NAME/" /var/www/html/config.php
sed -i "s/username_here/$DB_USER/" /var/www/html/config.php
sed -i "s/password_here/$DB_PASSWORD/" /var/www/html/config.php

# Mostramos el contenido de la ruta.
cat /var/www/html/config.php

# Modificamos el script de base de datos.
sed -i "s/lamp_db/$DB_NAME/" /tmp/iaw-practica-lamp/db/database.sql


# Importamos el script de base de datos.
mysql -u root < /tmp/iaw-practica-lamp/db/database.sql

# Creamos el susuario de la base de datos y le asingamos privilegios
mysql -u root <<< "DROP USER IF EXISTS $DB_USER@'%'"
mysql -u root <<< "CREATE USER $DB_USER@'%' IDENTIFIED BY '$DB_PASSWORD'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $DB_NAME.* TO $DB_USER@'%'"

# Modificamos el propietario y el grupo del directo /var/www/html
sudo chown -R www-data:www-data /var/www/html
