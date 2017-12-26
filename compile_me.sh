#!/bin/bash
if command -v nproc &>/dev/null; then
    PROCS=$(nproc)
else
    PROCS=$(grep -c ^processor /proc/cpuinfo)
fi

BOOTUP=color
RES_COL=60
MOVE_TO_COL="echo -en \\033[${RES_COL}G"
SETCOLOR_SUCCESS="echo -en \\033[1;32m"
SETCOLOR_FAILURE="echo -en \\033[1;31m"
SETCOLOR_NORMAL="echo -en \\033[0;39m"


echo_success()
{
    [ "$BOOTUP" = "color" ] && $MOVE_TO_COL
    echo -n "["
    [ "$BOOTUP" = "color" ] && $SETCOLOR_SUCCESS
    echo -n $"  OK  "
    [ "$BOOTUP" = "color" ] && $SETCOLOR_NORMAL
    echo -n "]"
    echo -ne "\r"
    return 0
}

echo_failure()
{
    [ "$BOOTUP" = "color" ] && $MOVE_TO_COL
    echo -n "["
    [ "$BOOTUP" = "color" ] && $SETCOLOR_FAILURE
    echo -n $"FAILED"
    [ "$BOOTUP" = "color" ] && $SETCOLOR_NORMAL
    echo -n "]"
    echo -ne "\r"
    echo -e "\n"
    exit 1
}

FLIP=0
while [[ $FLIP -eq 0 ]]; do
    echo "Please select one of the following options."
    echo -e "\n"
    echo "1.    Debug compile"
    echo "2.    Release compile"
    echo "3.    Exit"
    read -n1 -r -p ">    " VAR
    if [[ $VAR -eq 1 ]]; then
        COMPVAR="DEBUG"
        FLIP=1
    elif [[ $VAR -eq 2 ]]; then
        COMPVAR="RELEASE"
        FLIP=1
    elif [[ $VAR -eq 3 ]]; then
        echo -e "\n"
        echo "Exiting"
        exit 0
    else
        clear
        echo -e "\n"
        echo "Incorrect selection, please try again."
        sleep 2
        clear
    fi
done

cd build || echo_failure
echo -e "\n"
cmake .. -DCMAKE_BUILD_TYPE=$COMPVAR
EXITSTATUS=$?
if [[ $EXITSTATUS -eq 0 ]]; then
    echo_success
else
    echo_failure
fi
echo -e "\n"
make -j$PROCS
EXITSTATUS=$?
if [[ $EXITSTATUS -eq 0 ]]; then
    echo_success
else
    echo_failure
fi
echo -e "\n"
echo "Success!"
echo -e "\n"
exit 0
