#!/bin/sh
lip4=`cat /home/debian/.config/.otvl/ci_env | grep CI_LIP4 | cut -d= -f2`
ip -4 -o ad | grep $lip4 | cut -d' ' -f2