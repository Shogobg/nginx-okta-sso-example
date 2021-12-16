FROM nginx:latest

# Substitute SSL and default.conf with an empty file to avoid errors
COPY ./nginx-config/emptyfile.conf /etc/nginx/conf.d/default.conf
COPY ./nginx-config/emptyfile.conf /etc/nginx/snippets/ssl-list.conf
# Default nginx configuration location
COPY ./nginx-config/nginx.conf /etc/nginx/nginx.conf

COPY ./public /var/www/html
