#!/bin/bash

. config.ini 

mkdir -p backup/

for blockpage in "$@"; do
    [ -f $mainroot/"$blockpage" ] && mv -f $mainroot/"$blockpage" backup/
done

for config in "${@:-rkn}"; do
	mkdir -p $mainroot/$config/
	cp -v pages/$config.html $mainroot/$config/index.html
done
