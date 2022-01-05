#!bin/sh

echo "$1 $2"
function checkFileExists () {
    if [ "$#" -eq 2 ]; then
        IOS_PATH=`xcrun simctl get_app_container booted $2 data`
        echo IOS_PATH
        if [ -f $IOS_PATH/Documents/$1 ]; then
            cp $IOS_PATH/Documents/$1 ./lib/scripts/
        else
            return "Invalid PackageName or BoxName"
        fi
    else
        return "PackageName or BoxName is missing"
    fi
}

checkFileExists
echo $?

