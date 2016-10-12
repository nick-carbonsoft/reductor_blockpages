# Веб-сервер для страниц-заглушек

**Внимание: запрещено делать действия из этой статьи на сервере с установленным Carbon Reductor. Это может привести к его неработоспособности.**

Страницы заглушки + конфиги nginx для быстрого развёртывания веб-сервера со страницами-заглушками.

Ддля фильтрации по DNS нужно чтобы при открытии https://ip-адрес:443/ открывалась заглушка. Будут варнинги про SSL-сертификат.

Этот гайд расчитан для использования в OpenVZ, но можно использовать и в KVM, VMWare, на железном сервере итд, с небольшими отличиями в установке и настройке сети. Данный репозиторий можно также рассматривать как набор примеров конфигов (см. папки ./pages/, ./templates/).

Также предполагается использование CentOS 6. В случае с другими операционными системами необходимо вносить изменения в конфигурации файрволов, возможно в других местах располагаются конфиг-файлы веб-серверов.

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

### Возможные проблемы и способы их исправления

#### Включен selinux и ssh по ключу не проходит

    restorecon -R -v /root/.ssh

## Если ansible использовать не выходит

    ssh root@10.50.140.73
    yum -y install epel-release
    sed -i /etc/yum.repos.d/epel.repo -e 's/https/http/g'
    yum -y install nginx git
    git clone https://github.com/carbonsoft/reductor_blockpages.git

## Немного ручной работы (в любом случае)

    ssh root@10.50.140.73
    cd reductor_blockpages/
    
указываем нужные ip адреса

    vim config.ini

создаём сертификаты (там будет несколько вопросов)

    make cert

редактируем страницу:
    
    vim pages/rkn.html
    
генерируем конфиг nginx и заглушку для запросов РКН

    make rkn
    
если редуктор используется для ограничения доступа для неавторизованных/заблокированных/неплатильщиков, то вдобавок (можно предварительно по аналогии с РКН отредактировать blocked.html, negbal.html, noauth.html):

    make billing
    
при желании используем конфиг nginx и sysctl с небольшими поправками для улучшения производительности

    make nginx.conf
    make sysctl
    sysctl -p

применяем настройки    

    service nginx restart

разрешаем 80 и 443 порт в файрволе:

    cp /etc/sysconfig/iptables{,.bk}
    curl https://raw.githubusercontent.com/carbonsoft/reductor_blockpages/master/templates/iptables > /etc/sysconfig/iptables
    service iptables restart
