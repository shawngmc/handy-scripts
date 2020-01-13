#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: ./chown-acl-to-bucket-owner-by-prefix.sh BUCKET_NAME PREFIX"
fi

bucket=$1
prefix=$2

# Get all the S3 object keys, excluding folders.
keys=($(aws s3api list-objects --bucket ${bucket} --prefix ${prefix} --query 'Contents[].{Key: Key}' --output text | grep -v 'folder'))

# Update acl for each key.
for key in "${keys[@]}"; do
	echo "Updating permissions for ${key}"
	echo $(aws s3api put-object-acl --key ${key} --bucket ${bucket} --acl bucket-owner-full-control)
done
