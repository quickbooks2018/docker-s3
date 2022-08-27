#!/bin/bash
#Purpose: S3 Mount via Access Keys
#Maintainer: Muhammad Asim <quickbook2018@gmail.com>

BUCKET_NAME=${BUCKET_NAME}
ACCESS_KEY_ID=${ACCESS_KEY_ID}
SECRET_ACCESS_KEY=${SECRET_ACCESS_KEY}
mount_point=""$PWD"/"$BUCKET_NAME""



echo ""$ACCESS_KEY_ID":"$SECRET_ACCESS_KEY"" > ${HOME}/.passwd-s3fs
chmod 600 ${HOME}/.passwd-s3fs

mkdir -p $mount_point


/usr/local/bin/s3fs "$BUCKET_NAME" "$mount_point" -o passwd_file=${HOME}/.passwd-s3fs -o allow_other -o use_path_request_style -o nonempty

/usr/local/bin/s3fs "$BUCKET_NAME" "$mount_point" -o passwd_file=${HOME}/.passwd-s3fs -o allow_other -o use_path_request_style o dbglevel=info -f -o curldbg


#END