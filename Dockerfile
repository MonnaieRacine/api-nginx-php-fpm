FROM richarvey/nginx-php-fpm:latest

LABEL maintainer="M-3000 & Ilone <ilonemail2@protonmail.com>"

WORKDIR "/usr/src"

RUN apk update && apk upgrade &&\
    apk add --no-cache \
	libuv-dev \
	make \
    cmake \
	g++ \
#	openssl-dev \ #conflict with libressl
	gmp-dev \
	php7-dev \
	pcre-dev \
	git

RUN	git clone https://github.com/datastax/php-driver.git && \
	cd php-driver && \
	git submodule update --init lib/cpp-driver && \
	mkdir lib/cpp-driver/build && \
	cd lib/cpp-driver/build && \
	cmake .. && \
	make && \
	make install

RUN	mkdir -p php/ext/cassandra && \
	cp -r php-driver/ext/* php/ext/cassandra

RUN	docker-php-ext-install cassandra && \
    docker-php-source delete

# Must delete as much as possible from those to be ligthweight and minimalistic as possible
# But when removing all cassandra fails to work
RUN apk del \
	libuv-dev \
	make \
	cmake \
	g++ \
	gmp-dev \
	php7-dev \
	pcre-dev

WORKDIR "/var/www/html"
