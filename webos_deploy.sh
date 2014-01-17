#!/sbin/sh

webos=/data/webos
webos_bak=/data/webos_bak

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
    if [ $? -ne 0 ] ; then
        echo "ERROR: Failed to extract webOS on the internal memory. Propably not enough free space left to install webOS?"
        exit 1
    fi

    rm /data/webos-rootfs.tar.gz
    if [ -d $webos ]; then
        rm -rf $webos
    fi
    mv $tmp_extract $webos
    rm -rf $tmp_extract

    echo "Done with deploying webOS!!!"
}

deploy_webos

rm -rf /data/webos_bak
