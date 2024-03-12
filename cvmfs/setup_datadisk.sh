#!/bin/bash

DEV=${1:-/dev/sdc}
PART=${DEV}1
MOUNT=/data0

if [ -d $MOUNT ]; then
  echo $MOUNT already exists
  exit 0
fi

if [ ! -b $DEV ]; then
  echo Expected $MOUNT disk as $DEV
  exit 1
fi

sudo parted $DEV --script mklabel gpt mkpart xfspart xfs 0% 100%
sudo mkfs.xfs $PART
sudo partprobe $PART

UUID=$(lsblk -n -o UUID $PART)
mkdir -p $MOUNT

echo "UUID=$UUID       $MOUNT  xfs     defaults,nofail 0 0" >> /etc/fstab

mount -a

ln -s 