#!/bin/bash -e

DATABASE_HOST=${DATABASE_HOST:-"localhost"}

# mandatory packages and distribution upgrade
apt-get update && apt-get dist-upgrade
apt-get install -y wget sudo

# ruby
echo "==== Installation de Ruby 2.3"
cat > /etc/apt/sources.list.d/bearstech.list <<EOF
deb http://deb.bearstech.com/debian jessie-bearstech main
EOF

wget -q -O - http://deb.bearstech.com/bearstech-archive.gpg | apt-key add -
apt-get update
apt-get install -y ruby2.3 ruby2.3-dev
apt-get install -y libsqlite3-dev libproj-dev libpq-dev
gem2.3 install bundler

# Apache / Passenger
echo "==== Installation de Apache 2.4 et Passenger"
apt-get install -y apache2 libapache2-mod-passenger

cp stif-boiv.conf /etc/apache2/sites-available/

a2enmod expires
a2ensite stif-boiv

# Redis

echo "==== Installation de Redis"

apt-get install -y redis-server

# Sidekiq

echo "==== Installation de Sidekiq comme service"
cp sidekiq-stif-boiv.service /etc/systemd/system/
systemctl enable sidekiq-stif-boiv


echo "==== Installation de PostgreSQL"
if [ "x$DATABASE_HOST" = "xlocalhost" ]; then
apt-get install -y postgresql-9.4 postgresql-9.4-postgis-2.1 postgresql-contrib-9.4
[ -d /usr/local/share/postgresql ] || mkdir -p /usr/local/share/postgresql/
cp template-stif-boiv.sql /usr/local/share/postgresql/
pushd .
cd /usr/local/share/postgresql
sudo -u postgres createdb --encoding UTF-8 template_stif_boiv < template-stif-boiv.sql
popd
echo "Saisissez le mot de passe de la base de données. Il vous sera redemandé ultérieurement"
sudo -u postgres createuser --pwprompt stif_boiv
sudo -u postgres createdb --owner stif_boiv --template template_stif_boiv stif_boiv
else
echo "W! Base de donnée externe : Pas d'installation"
fi

# NodeJS

echo "==== Installation de NodeJS 5.x"
apt-get install -y apt-transport-https

cat > /etc/apt/sources.list.d/nodesource.list <<EOF
deb https://deb.nodesource.com/node_5.x  jessie main
EOF

wget -q -O - https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
apt-get update

apt-get install -y nodejs

# Configuration de l'applicatif

echo "==== Paramétrage de l'applicatif"
echo -n "Veuillez saisir à nouveau le mot de passe d'accès à la base de données :"
read -s DATABASE_PASSWORD

export DATABASE_PASSWORD

PGPASSWORD=$DATABASE_PASSWORD PGHOST=$DATABASE_HOST PGUSER=stif_boiv psql -q -c 'select 1' stif_boiv >/dev/null 2>&1 && echo "Mot de passe correct" 
./deploy-helper.sh setup

echo "!!! Configuration intiale terminée. Vous pouvez maintenant déployer l'applicatif"
