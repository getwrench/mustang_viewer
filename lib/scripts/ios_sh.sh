#!bin/sh

if [ "$#" -eq 1 ]; then
    IOS_PATH=`xcrun simctl get_app_container booted com.wrench.app2 data`
    cp $IOS_PATH/Documents/$1.hive ./lib/scripts/
else
    echo "Argument missing."
fi


