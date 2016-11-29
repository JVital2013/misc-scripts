#!/bin/bash

#2016 JVital2013
#A quick and dirty ramdisk creator and manager
#WARNING: Uses ramfs. Don't try to store something huge!

if [ `id -u` != 0 ]
then
	echo "This script must be run as root"
	exit 1
fi

running=true
mountCount=0

while [ $running == true ]
do
	read -p "Ramdisk>" input
	params=($input)

	case ${params[0]} in
	"help")
		echo "mkfs	Create a ramfs"
		echo "rmfs	Destroy a ramfs"
		echo "ls	List all ramfs"
		echo "exit	Close this script"
	;;	
	"mkfs")
		if [ -z ${params[1]} ]
		then
			echo "You must specify a directory to store the ramfs"
		elif [ -d ${params[1]} ]
		then
			echo "Directory ${params[1]} already exists"
		else
			mkdir ${params[1]}
			mount -t ramfs -o size=8192 ext4 ./${params[1]}
			chmod -R 0777 ./${params[1]}
			mounted[$mountCount]=${params[1]}
			((mountCount++))
			echo "Ramfs ${params[1]} created"
		fi
	;;
	"rmfs")
		if [ -z ${params[1]} ]
		then
			echo "Please specify a ramfs to unmount"
		else
			success=false
			thisLoc=0
			for fss in ${mounted[@]}
			do
				if [ $fss == ${params[1]} ]
				then
					success=true
					umount ./${params[1]}
					if [ $? != 0 ]
					then
						echo "There was an error unmounting the ${params[1]}"
					else
						rmdir ./${params[1]}
						unset mounted[$thisLoc]
						echo "${params[1]} destroyed"
					fi
				fi
				((thisLoc++))
			done
			if [ $success == false ] ; then
				echo "${params[1]} is not a ramfs created by this script" ; fi
		fi
	;;
	"ls")
		echo ${mounted[@]}
	;;
	"exit")
		if [ -z ${mounted[@]} ]
		then
			running=false
		else
			echo "You cannot exit until the following filesystems are unmounted: ${mounted[@]}"
		fi
	;;
	*)
		if [ ! -z ${params[0]} ] ; then
			echo "${params[0]} is not a valid command" ; fi
	;;
	esac
done

echo "Be seeing you..."
