#!/bin/bash

#2016 JVital2013
#Quick and dirty script to mount all VMWare Shared folders using open-vm-tols

if [ "$1" == '-m' ] || [ "$1" == '--mount' ]
then
	if [ -d "Shared" ]
	then
		echo "Cannot create directry for mount point: Shared exists"
		exit 1
	fi
	mkdir Shared
	sudo mount -t vmhgfs .host:/ ./Shared/
	echo "Mounted shared folders"
elif [ "$1" == '-u' ] || [ "$1" = '--umount' ]
then
	sudo umount ./Shared
	if [ $? != 0 ]
	then
		echo "There was an error unmounting the shared folders"
		exit 2
	fi
	rmdir  Shared
	echo "Unmounted shared folder"
else
	echo "Quick and dirty script to mount all VMWare Shared folders"
	echo "Must specify --mount or --umount"
fi
