rkn:
	./scripts/gen_all_config.sh rkn
billing:
	./scripts/gen_all_config.sh rkn noauth negbal blocked
cert:
	mkdir /etc/nginx/ssl
	chmod 700 /etc/nginx/ssl
	openssl req -new -x509 -days 9999 -nodes -newkey rsa:2048 -out /etc/nginx/ssl/cert.pem -keyout /etc/nginx/ssl/cert.key
nginx.conf:
	cp -v templates/nginx.conf /etc/nginx/nginx.conf
