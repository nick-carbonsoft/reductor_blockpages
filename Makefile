rkn: rkn_pages rkn_config
billing: billing_pages billing_config
rkn_pages:
	./scripts/gen_pages.sh rkn
rkn_config:
	./scripts/gen_config.sh rkn
billing_pages:
	./scripts/gen_pages.sh noauth negbal blocked
billing_config:
	./scripts/gen_config.sh noauth negbal blocked
cert:
	mkdir -p /etc/nginx/ssl
	chmod 700 /etc/nginx/ssl
	echo "Common name лучше установить в виде IP адреса машины:"
	ip -4 a
	openssl req -new -x509 -days 9999 -nodes -newkey rsa:2048 -out /etc/nginx/ssl/cert.pem -keyout /etc/nginx/ssl/cert.key
nginx.conf:
	cp -v templates/nginx.conf /etc/nginx/nginx.conf
sysctl:
	./scripts/patch_sysctl.sh
