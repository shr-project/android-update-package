#!/sbin/sh

webos=/data/webos
webos_bak=/data/webos_bak

phablet_home=$webos/home/phablet
phablet_home_bak=$webos_bak/home

timezone=$webos/etc/timezone
timezone_bak=$webos_bak/timezone

ofono=$webos/var/lib/ofono
ofono_bak=$webos_bak/ofono

connman=$webos/var/lib/connman
connman_bak=$webos_bak/connman

luna=$webos/var/luna
luna_bak=$webos_bak/luna

tmp_extract=/data/webos_tmp_extract

backup() {
    mkdir -p $webos_bak
    if [ -d $2 ]; then
        echo "Removing previous backout of $1"
        rm -rf $2
    fi
    if [ -d $1 ]; then
        echo "Backing up $1 to $2"
        mv $1 $2
    fi
}

restore() {
    if [ -d $2 ]; then
        echo "Restoring $1 from $2"
        rm -rf $1
        mv $2 $1
    fi
}

deploy_webos() {
    echo "Deploying webOS"
    if [ -d $tmp_extract ]; then
        rm -rf $tmp_extract
    fi
    mkdir $tmp_extract
    tar --numeric-owner -xzf /data/webos-rootfs.tar.gz -C $tmp_extract
    rm /data/webos-rootfs.tar.gz
    if [ -d $webos ]; then
        rm -rf $webos
    fi
    mv $tmp_extract $webos
    rm -rf $tmp_extract
}

backup $phablet_home $phablet_home_bak
backup $connman $connman_bak
backup $ofono $ofono_bak
backup $timezone $timezone_bak
backup $luna $luna_bak

deploy_webos

restore $phablet_home $phablet_home_bak
restore $connman $connman_bak
restore $ofono $ofono_bak
restore $timezone $timezone_bak
restore $luna $luna_bak
