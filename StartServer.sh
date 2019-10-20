#!/bin/bash
# This script will start the hugo server on port 80
sudo hugo server --bind=0.0.0.0 --baseUrl=http://192.168.1.184/ --port=80 --appendPort=false -s /home/pi/GitHub/ownthecloud/
echo "The Hugo Server is started, surf to 192.168.1.184!"
