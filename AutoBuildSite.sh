#!/bin/bash
set -e

## Update these with your code.
DISTRIBUTION_ID=E26LKJ862YPY4E
BUCKET_NAME=ownthe.cloud
PROFILE=default # Keep as "default" unless you use Profiles.

## Build hugo site in hugo working directory.
hugo -v

## Copy over pages - not static js/img/css/downloads
## Add --exclude 'img' --exclude 'js' --exclude 'downloads' --exclude 'css', to the top command to control cache behaivor.
aws s3 sync --profile ${PROFILE} --acl "public-read" --sse "AES256" public/ s3://${BUCKET_NAME}/

## Ensure static files are set to cache forever - cache for a month --cache-control "max-age=2592000"
# aws s3 sync --profile ${PROFILE} --cache-control "max-age=2592000" --acl "public-read" --sse "AES256" public/img/ s3://${BUCKET_NAME}/img/
# aws s3 sync --profile ${PROFILE} --cache-control "max-age=2592000" --acl "public-read" --sse "AES256" public/css/ s3://${BUCKET_NAME}/css/
# aws s3 sync --profile ${PROFILE} --cache-control "max-age=2592000" --acl "public-read" --sse "AES256" public/js/ s3://${BUCKET_NAME}/js/

##  Downloads binaries, not part of repo - cache at edge for a year --cache-control "max-age=31536000"
# aws s3 sync --profile ${PROFILE} --cache-control "max-age=31536000" --acl "public-read" --sse "AES256"  static/downloads/ s3://${BUCKET_NAME}/downloads/

## Invalidate landing page so everything sees new post - warning, first 1K/mo free, then 1/2 cent each
aws cloudfront create-invalidation --profile ${PROFILE} --distribution-id ${DISTRIBUTION_ID} --paths "/*"
