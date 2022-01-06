#!bin/sh

if [ "$#" -eq 2 ]; then
    PKG_NAME=`adb shell dumpsys window windows | grep -E 'mFocusedApp'| cut -d / -f 1 | cut -d " " -f 7`
    `adb shell run-as $PKG_NAME cp /data/data/$PKG_NAME/app_flutter/$1 /sdcard/`
    `adb pull /sdcard/$1 ./lib/scripts/ && adb shell rm /sdcard/$1`
else
    exit 6
fi

