#!/bin/bash

#2016 JVital2013
#A simple script to launch a task silently in the background
#Run like ". ./lch.sh to run job in parent shell"

cmd=""
for flag in $@
do
	cmd=$cmd" "$flag
done
$cmd &>/dev/null &
