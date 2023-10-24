# Practica.-3
# Despliegue de una aplicación web LAMP en Ubuntu server.
### Pero,¿De que consta una pila LAMP?
Muy simple, con esto describimos un sistema de infraestructura de internet, lo que estamos buscando es desplegar una serie de aplicaciones en la web, desde un unico sistema operativo, esto quiere decir que, buscamos desplegar aplicaciones en la web de forma cómoda y rápida ejecutando un único script, el cual hay que configurar previamente.

### 1. Que representa cada letra de la palabra --> LAMP.

#### L --> Linux (Sistema operativo).
#### A --> Apache (Servidor web).
#### M --> MySQL/MariaDB (Sistema gestor de base de datos).
#### P --> PHP (Lenguaje de programación).

### Con esto, buscamos hacer un despligue de aplicaciones.

# Muestra todos los comandos que se han ejeutado.

set -x

# Actualización de repositorios
 sudo apt update

# Actualización de paquetes
# sudo apt upgrade  

# Instalamos el servidor Web apache
```
apt install apache2 -y
```
### Con esto instalamos el servidor web apache2.

### Estructura de directorios del servicio apache2.

```
 1. Directorios
  1.1 conf-available --> donde se aplican los hosts virtuales.
  1.2 conf-enabled --> donde se encuentran enlaces simbolicos a los archivos de configuracion           
  de conf-available.
  1.3 mods-available --> para añadir funcionalidades al servidor.
  1.4 mods-enabled --> enlaces simbolicos a esas funcionalidades.
  1.5 sites-available --> archivos de configuración de hosts virtuales.
  1.6 sites-enabled --> enlaces simbolicos a sites-available.
 2. Ficheros
  2.1 apache2.conf --> Archivo de configuración principal.
  2.3 envvars --> Define las variables de entorno, que se usan en el archivo principal.
  2.3 magic --> Para determinar el tipo de contenido, por defecto es MIME.
  2.4 ports.conf --> archivo donde se encuentran los puertos de escucha de apache.
```

### En /etc/apache2 se almacenan los archivos y directorios de apache2.

## Contenido del fichero /conf/000-default.conf.
Este archivo contiene la configuración del host virtual el cual debe contener las siguientes directivas para que funcione la aplicación web.

En la ruta del repositorio ``/conf/000-default.conf``, encontramos la configuración que se emplea para este despliegue.

```python
ServerSignature Off
ServerTokens Prod
<VirtualHost *:80>
    #ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html
    DirectoryIndex index.php index.html 
    
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```
Aquí podemos comprobar lo que contiene el fichero de configuración del ``VirtualHost``, donde todas las conexiones pasaran por el puerto 80, el ``DocumentRoot``, donde mostrará el contenido será desde ``/var/www/html`` y podemos ver los archivos de error y acceso para comprobar errores y ver quien ha accedido, Tambien, tenemos la directiva ``Directory index`` la cual establece una prioridad en el orden que se establezca.

### También se hace uso de las siguientes directivas 
``ServerSignature OFF `` --> Esto es por si nos interesa incorporar la versión de apache, en páginas de error e indice de directorios, lo dejamos en OFF por seguridad. Se debe aplicar a todo el servidor.

``ServerTokens Prod `` --> Esta se puede aplicar a un único servidor virtual. Aquí se muestran información sobre las cabeceras, es decir, respuestas que se mandan al cliente, es conveniente tenerlo quitado.

# Instalar mysql server
```
apt install mysql-server -y
```

### Con esto instalamos mysql-server.

# Instalar php
```
apt install php libapache2-mod-php php-mysql -y
```
### Instalamos php junto con unos modulos necesarios.
<------------------------------------------------------>
### ``libapache2-mod-php`` --> para mostrar paginas web desde un servidor web apache y ``php-mysql``, nos permite conectar una base de datos de MySQL desde PHP.

# Copiar el archivo de configuracion de apache.
```
cp ../conf/000-default.conf /etc/apache2/sites-available
```
### En este caso, no haría falta emplear el comando ``a2ensite``, ya que se habilita por defecto debido a que apache2 toma por defecto la configuración de ese archivo para desplegar las opciones que hemos hecho en la web.

### Este script posee un archivo de configuración en la carpeta ``conf `` por el cual configura el host virtual que muestra el contenido de la aplicación web.

```
ServerSignature Off
ServerTokens Prod
<VirtualHost *:80>
    #ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html
    DirectoryIndex index.php index.html
    
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

# Reiniciamos el servicio apache
```
systemctl restart apache2
```
### Reiniciamos apache para que obtenga los cambios.

# Copiamos el arhivo de prueba de php
### La finalidad de esto va a ser que muestre el contenido de la página index.php la cual se inserta en la carpeta html, con objetivo de que muestre el contenido de esa página, por defecto, si vemos el archivo de configuración de 000-default.conf veremos que:
 <p> DocumentRoot ``/var/www/html`` --> Toma como raiz, los archivos en html.</p>
 <p> ``DirectoryIndex`` --> index.php index.html --> Muestra en orden los archivo situados.</p>    

```
cp ../php/index.php /var/www/html
```
### Sabiendo lo anterior copiamos el archivo index.php a ``/var/www/html``.

# Modificamos el propietario y el grupo del directo /var/www/html
```
chown -R www-data:www-data /var/www/html
```
### Lo que estamos haciendo es que el usuario de apache tenga permisos de propietario sobre, el directorio html con objetivo de que pueda desplegar el **sitio web**.

# Conexiones
<p>Ahora podriamos conectarnos a traves de nuestro navegador a nuestra pagina index.php</p>

```
En el navegador --> http://nuestraipservidor/index.php, y debería salirnos.
```

# Configuración del script **deploy.sh**.

```
#!/bin/bash
```
<p>Con esto, decimos que use el interprete de comandos bash, en el script.</p>

# Muestra todos los comandos que se han ejeutado.
```
set -x
```
<p>Esto muestra todo lo que se está ejecutando.</p>

# Incluimos las variables.
```
source .env
```
### Para ello, tenemos el archivo source .env, que incluye las siguientes variables.
```
DB_NAME=aplicacion
DB_USER=lamp_user
DB_PASSWORD=lamp_password
```
**Se explica mas adelante la finalidad de este archivo**, lo que si puedo decir es que se le dará uso para crear automaticamente, usuarios y bases de datos de MySQL sin crearlas de forma manual.

# Actualización de repositorios.
 sudo apt update

### Actualizamos repositorios para evitar, conflictos por repositorios sin actualizar. 

# Eliminamos descargas previas del repositorio.
### Que es lo que pasa aquí, nosotros estamos trabajando con un repositorio que nos han proporcionado por parte de github, siempre que ejecutemos este script, en caso de que lo hayamos ejecutado una vez, luego necesitariamos que borrase esa información que se ha generado.

```
rm -rf /tmp/iaw-practica-lamp
```
### Donde r significa que lo borra de forma recursiva, y f lo borra a la fuerza, tanto directorios completos como vacios.

# Clonamos el repositorio del codigo fuente de la aplicación.
### Con esto clonamos el repositorio de **github** empleando _git clone_.

git clone https://github.com/josejuansanchez/iaw-practica-lamp.git /tmp/iaw-practica-lamp

<p>Eligiendo como destino el directorio tmp con el nombre, iaw-practica-lamp<p>.

# Movemos el código fuente de la aplicación a /var/www/html
```
mv /tmp/iaw-practica-lamp/src/* /var/www/html
```
### Con esto movemos todo el contenido de la aplicación a html que es el directorio donde se muestran los contenidos del sitio web en el navegador, es decir por internet, empleando la ip pública.

# Configuramos el archivo config.php de la aplicación
```
sed -i "s/database_name_here/$DB_NAME/" /var/www/html/config.php
-----------------------------------------------------------------
sed -i "s/username_here/$DB_USER/" /var/www/html/config.php
-----------------------------------------------------------------
sed -i "s/password_here/$DB_PASSWORD/" /var/www/html/config.php
```

# Mostramos el contenido de la ruta.
cat /var/www/html/config.php

### Esto es lo que contiene dicho archivo si realizamos un cat.



# Modificamos el script de base de datos.
sed -i "s/lamp_db/$DB_NAME/" /tmp/iaw-practica-lamp/db/database.sql


# Importamos el script de base de datos.
mysql -u root < /tmp/iaw-practica-lamp/db/database.sql

# Creamos el susuario de la base de datos y le asingamos privilegios
mysql -u root <<< "DROP USER IF EXISTS $DB_USER@'%'"
mysql -u root <<< "CREATE USER $DB_USER@'%' IDENTIFIED BY '$DB_PASSWORD'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $DB_NAME.* TO $DB_USER@'%'"

