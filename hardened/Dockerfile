# Base: latest WordPress on PHP 8.3 Apache (upgraded from 8.1)
FROM wordpress:6.7.2-php8.3-apache

LABEL maintainer="DevSecOps Lab"
LABEL description="Hardened WordPress image - vulnerabilities patched"

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        curl \
        less \
    && rm -rf /var/lib/apt/lists/*

RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x /usr/local/bin/wp

RUN a2enmod headers rewrite

COPY security.conf /etc/apache2/conf-available/security-hardening.conf
RUN a2enconf security-hardening

COPY hardening.sh /usr/local/bin/hardening.sh
RUN chmod +x /usr/local/bin/hardening.sh

RUN groupadd -r wpuser && useradd -r -g wpuser -s /bin/false wpuser

COPY entrypoint.sh /usr/local/bin/custom-entrypoint.sh
RUN chmod +x /usr/local/bin/custom-entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/custom-entrypoint.sh"]
CMD ["apache2-foreground"]
