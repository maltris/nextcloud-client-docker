#!/bin/sh

# allow image to be used with docker secrets
if [ -f /run/secrets/nc_user ]; then
	read NC_USER < /run/secrets/nc_user
fi

if [ -f /run/secrets/nc_pass ]; then
	read NC_PASS < /run/secrets/nc_pass
fi

# ensure, that the sync dir exists and is owned by the user
[ -d $NC_SYNC_DIR ] || mkdir -p $NC_SYNC_DIR
	

while true
do

	nextcloudcmd $( [ "$NC_HIDDEN" == true ] && echo "-h" ) $( [ "$NC_SILENT" == true ] && echo "--silent" ) $( [ "$NC_TRUST_CERT" == true ] && echo "--trust" ) --non-interactive -u $NC_USER -p $NC_PASS $NC_SOURCE_DIR $NC_URL
	
	#chown the files to the USER_UID:
	echo "chown -R $USER_UID:$USER_GID $NC_SOURCE_DIR";
	chown -R $USER_UID:$USER_GID $NC_SOURCE_DIR
	
	#check if exit!
		if [ "$NC_EXIT" = true ] ; then
			
			if [  ! "$NC_SILENT" == true ] ; then 
				echo "NC_EXIT is true so exiting... bye!"
			fi
			
			exit;
		fi
	sleep $NC_INTERVAL
done
