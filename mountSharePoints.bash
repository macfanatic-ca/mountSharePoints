#!/bin/bash
################## Variables ##################
# File with credentials
credFile="/var/root/server_backup_creds"
# Space-separated list of Mounting Points
mountPoints=("example1" "example2")
# DNS name of File Server
hostname=server.example.com
################ Do Not Modify ################
# Get the logged in user's name
userName=$(/usr/bin/stat -f%Su /dev/console)

# Get username and password
if [[ -f "$credFile" ]] && [[ -r "$credFile" ]]; then
    source "$credFile"
else
    echo "ERROR: No credentials found or file not readable"
    exit 1
fi

# Make sure server is reachable
ping -c 1 -t 2 $hostname > /dev/null 2>&1
if [ $? != 0 ]; then
echo "WARNING: Unable to ping $hostname"
exit 1
fi

# Functoin to check mounted share-points
checkSharePoints () {
    ls -l /Volumes/"$sharePoint"
}

# Function to mount share-point
mountSharePoint () {
    sudo -u $userName mkdir -p /Volumes/"$sharePoint"
    sudo -u $userName mount_afp -o automounted afp://$username:$password@$hostname/"$sharePoint" /Volumes/"$sharePoint"
}

# Function to unmount share-point
unmountSharePoint () {
    umount /Volumes/"$sharePoint"
}

# Check results in mount/unmount
checkMountResults () {
    if [ $? == 0 ]; then
        echo "Successfully mounted "$sharePoint""
    elif [ $? == 19 ]; then
        echo "Unable to mount "$sharePoint" because the server was not found or because the share-point does not exist"
    elif [ $? == 13 ]; then
        echo "Unable to mount "$sharePoint" because the user did not provide proper authentication credentials"
    else
        echo "Unknown error occured"
    fi
}

# Exit if no starting article given
if [[ -z "$1" ]]; then
        echo "Missing parameter! Use -h or --help for more info"
        exit 3
fi
# Mount all listed share-points
if [ $1 == "mount" ]; then
    for sharePoint in "${mountPoints[@]}"; do
        if [ ! -d /Volumes/"$sharePoint" ]; then
            mountSharePoint
            checkMountResults
        elif [ -d /Volumes/"$sharePoint" ]; then
            echo "Unable to mount $sharePoint because it's already mounted"
        fi
    done
# Unmount all listed share-points
elif [ $1 == "umount" ]; then
    for sharePoint in "${mountPoints[@]}"; do
        if [ -d /Volumes/"$sharePoint" ]; then
            unmountSharePoint
            echo "Successfully unmounted $sharePoint"
        elif [ ! -d /Volumes/"$sharePoint" ]; then
            echo "Unable to unmount $sharePoint because it's not mounted"
        fi
    done
# Display help
else
    echo "USAGE: mountSharePoint mount || umount
    mount: mounts all listed share points
    umount: unmounts all listed share points"
fi

# Exit cleanly
exit 0
