FROM nginx:latest

# Install some tools
RUN apt-get update &&\
    apt-get install \
    git \
	default-mysql-client \
    -y

WORKDIR /var/www/app