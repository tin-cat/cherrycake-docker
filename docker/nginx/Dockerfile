FROM nginx:latest

# Install some tools
RUN apt-get update &&\
    apt-get install \
    git \
	default-mysql-client \
    -y

COPY nginx/default.conf /etc/nginx/conf.d/default.conf

WORKDIR /var/www/app