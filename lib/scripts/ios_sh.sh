#!bin/sh

if [ "$#" -eq 1 ]; then
    IOS_PATH=`xcrun simctl get_app_container booted com.wrench.app2 data`
    if [ -f $IOS_PATH/Documents/$1]; then
        cp $IOS_PATH/Documents/$1 ./lib/scripts/
    else
        echo "Invalid BoxName"
    fi
else
    echo "HiveBoxName is missing"
fi


