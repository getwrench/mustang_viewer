#!bin/sh

if [ "$#" -eq 1 ]; then
    if test -d "$TMPDIR"; then
        TEMP=$TMPDIR
    elif test -d "$TMP"; then
        TEMP=$TMP
    elif test -d /var/tmp; then
        TEMP=/var/tmp
    else
        TEMP=/tmp
    fi

    PKG_NAME=`adb shell dumpsys window windows | grep -E 'mFocusedApp'| cut -d / -f 1 | cut -d " " -f 7`
    `adb shell run-as $PKG_NAME cp /data/data/$PKG_NAME/app_flutter/$1 /sdcard/`
    `adb pull /sdcard/$1 $TEMP && adb shell rm /sdcard/$1`
else
    exit 1
fi

