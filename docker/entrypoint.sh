#!/bin/sh
set -e

cd /var/www/html

# 1) Si le projet Symfony n'existe pas, on le crée
#if [ ! -f ./app/composer.json ] && [ 1 -eq 2 ]; then
if [ ! -f ./app/composer.json ]; then
	echo "▶ No Symfony project found, creating it..."
	composer create-project symfony/skeleton:"8.0.*" app --no-interaction


	cd /var/www/html/app

	# 2) Installer les dépendances si vendor absent
	echo "▶ Installing composer dependencies..."
	composer install --no-interaction


	# 3) Installer le webapp-pack si absent
	echo "▶ Installing symfony/webapp-pack..."
	composer require symfony/webapp-pack --no-interaction
fi

# 4) Lancer Apache
exec apache2-foreground

