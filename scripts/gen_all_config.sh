#!/bin/bash

. config.ini 
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
