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

#RUN	mkdir -p php/ext/cassandra && \
#	cp -r php-driver/ext/* php/ext/cassandra

#RUN	docker-php-ext-install cassandra && \
#    docker-php-source delete

RUN cd php-driver/ext && \
	phpize && \
	mkdir ../build && \
	cd ../build && \
	../ext/configure && \
	make && \
	make install

RUN echo $'\n[cassandra]\n; DataStax PHP Driver for Apache Cassandra\nextension=cassandra.so' >> ${php_vars}

WORKDIR "/var/www/html"
