#!/sbin/sh

target_dir=/data/luneos
backup_dir=/data/luneos_bak

tmp_extract=/data/luneos_tmp_extract

backup() {
    mkdir -p $backup_dir
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

cleanup_artifacts() {
    # Before we switched to LuneOS as distro name it was simply webOS and therefore remove
    # the old directory to not take too much of the internal memory for unused things.
    if [ -d /data/webos ] ; then
        rm -rf /data/webos
    fi
}

deploy_luneos() {
    echo "Cleaning up left over artifacts ..."
    cleanup_artifacts

    echo "Deploying LuneOS ..."
    if [ -d $tmp_extract ]; then
        rm -rf $tmp_extract
    fi
    mkdir $tmp_extract
    tar --numeric-owner -xzf /data/webos-rootfs.tar.gz -C $tmp_extract
    if [ $? -ne 0 ] ; then
        echo "ERROR: Failed to extract LuneOS on the internal memory. Propably not enough free space left to install LuneOS?"
        exit 1
    fi

    rm /data/webos-rootfs.tar.gz
    if [ -d $target_dir ]; then
        rm -rf $target_dir
    fi
    mv $tmp_extract $target_dir
    rm -rf $tmp_extract

    echo "Done with deploying LuneOS!!!"
}

deploy_luneos

rm -rf $backup_dir
