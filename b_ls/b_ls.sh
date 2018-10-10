#!/bin/bash

# open directory and check makefile

yourtest="b_ls/main.c"
reftest="b_ls/refmain.c"
dirName="$1"
if [ -e "$dirName" ] ; then
    cp -- "$yourtest" "$dirName"
    cp -- "$reftest" "$dirName"
    cd -- "$dirName"
    rm -f refLog yourLog
    norminette -R CheckForbiddenSourceHeader
    if [ -e "author" ] ; then
        echo "found author file"
    else
        echo "missing author file!"
    fi
    if make re >/dev/null ; then
        if make fclean >/dev/null ; then
            echo "passed makefile test"
            make re >/dev/null && make clean >/dev/null
        else
            echo "make fclean error!"
        fi
    else
        echo "make re error!"
        exit 1
    fi
else
    echo "Project not found! Use ./run [projName] [projPath]"
fi

# tests

if ./b_ls | awk {'print $1,$2,$3,$4,$5,$6,$7,$8,$9'} >> yourLog; then
    ls | awk {'print $1,$2,$3,$4,$5,$6,$7,$8,$9'} >> refLog
else
    echo "runtime error!"
    exit 1
fi

if ./b_ls -atl| cat -e | awk {'print $1,$2,$3,$4,$5,$6,$7,$8,$9'} >> yourLog; then
    ls -atl | cat -e | awk {'print $1,$2,$3,$4,$5,$6,$7,$8,$9'} >> refLog
else
    echo "runtime error!"
    exit 1
fi

if ./b_ls -atlr| cat -e | awk {'print $1,$2,$3,$4,$5,$6,$7,$8,$9'} >> yourLog; then
    ls -atlr | cat -e | awk {'print $1,$2,$3,$4,$5,$6,$7,$8,$9'} >> refLog
else
    echo "runtime error!"
    exit 1
fi

if ./b_ls -- -| cat -e | awk {'print $1,$2,$3,$4,$5,$6,$7,$8,$9'} >> yourLog; then
    ls -- -| cat -e | awk {'print $1,$2,$3,$4,$5,$6,$7,$8,$9'} >> refLog
else
    echo "runtime error!"
    exit 1
fi

# compare your output to the standard functions

DIFF=$(diff yourLog refLog)
if [ "$DIFF" == "" ] ; then
    echo "pass!"
else
    echo "Outputs don't match! Check log files in project directory"
fi