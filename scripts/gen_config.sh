#!/bin/bash

. config.ini 

rm -rf backup/
mkdir -p backup/
mv -f /etc/nginx/conf.d/*.conf backup

for config in "${@:-rkn}"; do
	echo create /etc/nginx/conf.d/$config.conf
	./scripts/genconfig \
		conf=/etc/nginx/conf.d/$config.conf \
		tmplt=templates/nginx.conf.tmplt \
		root=$mainroot/$config \
		ip=${!config}
done
service nginx configtest
