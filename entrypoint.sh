#!/bin/sh
#Set Date and make /tmp backup folder
date=$(date +%m-%d-%Y_%H-%M)
mkdir -pv /tmp/backup-$date

#Copy Files/Folders from source
for path in $(echo ${SOURCE_BACKUP_PATH_LIST} | grep -v "#")
do
    scp -r -O -o StrictHostKeyChecking=no -i /keys/source.key -P ${SOURCE_PORT} ${SOURCE_USERNAME}@${SOURCE_HOST}:${path} /tmp/backup-$date/
done

#Tar downloaded files/folders
tar zcvf /tmp/backup-$date.tgz /tmp/backup-$date
#Create target backup path
ssh -o StrictHostKeyChecking=no -i /keys/target.key -p ${TARGET_PORT} ${TARGET_USERNAME}@${TARGET_HOST} mkdir -pv ${TARGET_BACKUP_PATH}
#Transfer .tgz to target
echo "Transferring backup-$date.tgz to ${TARGET_USERNAME}@${TARGET_HOST}:${TARGET_BACKUP_PATH}/backup-$date.tgz"
scp -P ${TARGET_PORT} -o StrictHostKeyChecking=no -i /keys/target.key /tmp/backup-$date.tgz ${TARGET_USERNAME}@${TARGET_HOST}:${TARGET_BACKUP_PATH}/backup-$date.tgz

