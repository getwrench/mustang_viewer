#!bin/sh

if [ "$#" -eq 2 ]; then
    IOS_PATH=`xcrun simctl get_app_container booted $2 data`
    if [ -f $IOS_PATH/Documents/$1 ]; then
        cp $IOS_PATH/Documents/$1 ./lib/scripts/
    else
        exit 5
    fi
else
    exit 6
fi


