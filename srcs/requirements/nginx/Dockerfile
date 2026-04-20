FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y && \
	apt-get install -y nginx openssl && \
	rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl

COPY conf/nginx.conf /etc/nginx/conf.d/nginx.conf
COPY tools/setup.sh /usr/local/bin/setup.sh

RUN chmod +x /usr/local/bin/setup.sh

RUN rm -f /etc/nginx/sites-enabled/default \
          /etc/nginx/conf.d/default.conf \
          /etc/nginx/sites-available/default

ENTRYPOINT ["/usr/local/bin/setup.sh"]