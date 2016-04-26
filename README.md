# Веб-сервер для страниц-заглушек
Страницы заглушки + конфиги nginx для быстрого развёртывания веб-сервера со страницами-заглушками

## Создание виртуальной машины и настройка сети

Создаём виртуалку и настраиваем на ней сеть (абстрактный vmsh в вакууме, замените на vzctl и вместо названия виртуалки используйте CTID)

    vmsh create nginx_block --memsize=1G --diskspace=2G --ip=10.50.140.73

если нужны заглушки кроме РКН добавляем дополнительные IP адреса

    vmsh set nginx_block --ipadd 10.50.140.74 --save
    vmsh set nginx_block --ipadd 10.50.140.75 --save
    vmsh set nginx_block --ipadd 10.50.140.76 --save
    
стартуем её

    vmsh start nginx_block

## Настройка с помощью ansible

генерируем ssh-ключи, (нужно только если они отсутствуют!).

    ssh-keygen

закидываем публичные ssh-ключи со своего хоста, где установлен ansible

    ssh-copy-id root@10.50.140.73
    
добавляем группу и хост в inventory
    
    cd ~/git/ansible/work/
    cat >> inventory << EOF
    [nginx_block]
    10.50.140.73
    EOF
    
создаём задачу по подготовке сервера к работе

    curl https://raw.githubusercontent.com/carbonsoft/reductor_blockpages/master/nginx_block.yml -o tasks/nginx_block.yml
    ansible-playbook tasks/nginx_block.yml

## Если ansible использовать не выходит

    ssh root@10.50.140.73
    yum -y install epel-release
    yum -y install nginx git
    git clone https://github.com/carbonsoft/reductor_blockpages.git

## Немного ручной работы (в любом случае)

    ssh root@10.50.140.73
    cd reductor_blockpages/
    
указываем нужные ip адреса

    vim config.ini

создаём сертификаты (там будет несколько вопросов)

    make cert

генерируем конфиг nginx и заглушку для запросов РКН

    make rkn
    
если редуктор используется для ограничения доступа для неавторизованных/заблокированных/неплатильщиков, то вдобавок:

    make billing
    
при желании используем конфиг nginx с небольшими поправками для улучшения производительности

    make nginx.conf

применяем настройки    

    service nginx restart
