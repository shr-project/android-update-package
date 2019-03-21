#!/sbin/sh

# Based on
# https://forum.xda-developers.com/showthread.php?t=1023150
# Changed the binary name, because in our case the update binary isn't called
# update_binary as on the forum, nor update-binary as in our .zip file, but
# just /tmp/updater, that's why the ps call never catched the right line and
# correct FD
# Also fix the test for empty OUTFD to use -n, otherwise it fails with
# sh: : unknown operand
# when it was really empty (because of missing quotes around $OUTFD)
OUTFD=$(ps | grep -v "grep" | grep -o -E "updater(.*)" | cut -d " " -f 3)

/sbin/sh $* 2>&1 | while read -r line; do
    if [ -n "$OUTFD" ] ; then
        echo "ui_print $line" >&$OUTFD;
        echo "ui_print " >&$OUTFD;
    else
        echo "$line"
    fi
done
