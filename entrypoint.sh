#!/bin/sh
#Set Date and make /tmp backup folder
date=$(date +%m-%d-%Y_%H-%M)
mkdir -pv /tmp/backup-$date
checkKeys() {
    if [[ -f /keys/source.key && -f /keys/target.key ]];then
        echo "Target and Source keys found!"
    else    
        echo "No ssh keys found in /keys/source.key and /keys/target.key !"
        exit 1
    fi
}
retrieveFromSource() {
    if [[ -z "$SOURCE_BACKUP_PATH_LIST" || -z "$SOURCE_PORT" || -z "$SOURCE_HOST" || -z "$SOURCE_USERNAME" ]];then
        echo "ERROR: Source path, source username/host/port/key not given! Exiting."
        exit 1 
    else
        #Copy Files/Folders from source
        for path in $(echo ${SOURCE_BACKUP_PATH_LIST} | grep -v "#")
        do
            scp -r -O -o StrictHostKeyChecking=no -i /keys/source.key -P ${SOURCE_PORT} ${SOURCE_USERNAME}@${SOURCE_HOST}:${path} /tmp/backup-$date/
        done
    fi
}
archiveSourceFiles() {
    #Tar downloaded files/folders
    if `tar zcvf /tmp/backup-$date.tgz /tmp/backup-$date`;then
        echo "Tarring backup files succesful!"
    fi
}
sourceFilesToTarget() {
    if [[ -z "$TARGET_BACKUP_PATH" || -z "$TARGET_PORT" || -z "$TARGET_HOST" || -z "$TARGET_USERNAME" ]];then
        echo "ERROR: Target path, target username/host/port/key not given! Exiting."
        exit 1 
    else
        #Create target backup path and transfer .tgz to target path
        ssh -o StrictHostKeyChecking=no -i /keys/target.key -p ${TARGET_PORT} ${TARGET_USERNAME}@${TARGET_HOST} mkdir -pv ${TARGET_BACKUP_PATH}
        echo "Transferring backup-$date.tgz to ${TARGET_USERNAME}@${TARGET_HOST}:${TARGET_BACKUP_PATH}/backup-$date.tgz"
        scp -P ${TARGET_PORT} -o StrictHostKeyChecking=no -i /keys/target.key /tmp/backup-$date.tgz ${TARGET_USERNAME}@${TARGET_HOST}:${TARGET_BACKUP_PATH}/backup-$date.tgz
    fi
}

#Start script
checkKeys

retrieveFromSource   

archiveSourceFiles

sourceFilesToTarget