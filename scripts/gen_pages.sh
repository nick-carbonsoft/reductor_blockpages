#!/bin/bash

. config.ini 

mkdir -p backup/
mv -f $mainroot/* backup/

for config in "${@:-rkn}"; do
	mkdir -p $mainroot/$config/
	cp -v pages/$config.html $mainroot/$config/index.html
done
