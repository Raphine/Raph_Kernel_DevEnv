#!/bin/bash

function setup() {
    sed -e "s/HOST/$1/g" memdisk.cfg > load.cfg
}

if [ $1 = "remote" ]; then
    echo -n "Host? : "
    read host
    setup $host
fi

if [ $1 = "local" ]; then
    j=""
    num=0
    result=`ifconfig -a | sed 's/[ \t].*//;/^\(lo\|\)$/d'`
    for i in $result
    do
        tmp=`LANG=C ifconfig $i | awk '/inet addr/{print substr($2,6)}'`
        if [ -z "$tmp" ]; then
            continue
        fi
        j="$j $i"
        (( num++ ))
    done

    if [ $num -eq 0 ]; then
        echo "error: No network interface available"
        exit -1
    fi

    if [ $num -ne 1 ]; then
        echo "select network interface"
        select i in $j; do
            j=$i
            break
        done
    fi

    host=`LANG=C ifconfig $j | awk '/inet addr/{print substr($2,6)}'`
    setup $host
fi






