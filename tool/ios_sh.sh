#!bin/sh

if [ "$#" -eq 2 ]; then
    if test -d "$TMPDIR"; then
        TEMP=$TMPDIR
    elif test -d "$TMP"; then
        TEMP=$TMP
    elif test -d /var/tmp; then
        TEMP=/var/tmp
    else
        TEMP=/tmp
    fi
    echo $TEMP
    IOS_PATH=`xcrun simctl get_app_container booted $2 data`
    echo "$IOS_PATH"
    if [ -f $IOS_PATH/Documents/$1 ]; then
        cp $IOS_PATH/Documents/$1 $TEMP
    else
        exit 1
    fi
else
    exit 1
fi


