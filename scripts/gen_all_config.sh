#!/bin/bash

. config.ini 

rm -rf backup/
mkdir -p backup/
mv -f /etc/nginx/conf.d/*.conf backup
mv -f $mainroot/* backup

for config in "${@:-rkn}"; do
	echo create /etc/nginx/conf.d/$config.conf
	./scripts/genconfig \
		conf=/etc/nginx/conf.d/$config.conf \
		tmplt=templates/nginx.conf.tmplt \
		root=$mainroot/$config \
		ip=${!config}
	mkdir -p $mainroot/$config/
	cp -v pages/$config.html $mainroot/$config/index.html
done
service nginx configtest
