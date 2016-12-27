#!/bin/bash

. config.ini 

rm -rf backup/
mkdir -p backup/

for app in "$@"; do
    [ -f ./nginx/"$app".conf ] && mv -f /etc/nginx/conf.d/"$app".conf backup
done

for config in "${@:-rkn}"; do
	echo create /etc/nginx/conf.d/$config.conf
	./scripts/genconfig \
		conf=/etc/nginx/conf.d/$config.conf \
		tmplt=templates/nginx.conf.tmplt \
		root=$mainroot/$config \
		ip=${!config}
done
service nginx configtest
