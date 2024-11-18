#!/usr/bin/env bash

theme="${1:-default}"

while [ "abc" ]; do
    ./bin/app-ps1 -e $? --256 -t "${theme}"
    ./bin/app-ps1 -e $? --16 -t "${theme}"
    ./bin/app-ps1 -e $? --bw -t "${theme}"
    echo
    echo
    echo Last command errors
    ./bin/app-ps1 -e 1 --256 -t "${theme}"
    ./bin/app-ps1 -e 1 --16 -t "${theme}"
    ./bin/app-ps1 -e 1 --bw -t "${theme}"

    if [ "$(which colour-test 2>/dev/null)" ]; then
        colour-test --16
        colour-test compare1
    fi

    sleep 5
    clear
done
