FROM php:8.4-apache

# Extensions utiles (PDO MySQL, intl, opcache) — ajuste selon ton besoin
RUN apt-get update && apt-get install -y \
    libicu-dev libzip-dev unzip git \
 && docker-php-ext-install pdo pdo_mysql intl opcache \
 && rm -rf /var/lib/apt/lists/*

# Activer mod_rewrite (Symfony)
RUN a2enmod rewrite

# Définir la DocumentRoot vers /var/www/html/app/public
ENV APACHE_DOCUMENT_ROOT=/var/www/html/app/public
# Remplacer la docroot dans la conf par défaut
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/000-default.conf

# Autoriser .htaccess dans public/ (utile pour la réécriture)
RUN printf '<Directory ${APACHE_DOCUMENT_ROOT}>\n\tAllowOverride All\n</Directory>\n' \
    > /etc/apache2/conf-available/z-app.conf \
 && a2enconf z-app
 
# Installer Composer (binaire officiel)
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html
