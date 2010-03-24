#!/usr/bin/env bash

set -e
# grab pico, for our users
apt-get install nano

apt-get clean

rm -f ~flint/initial_vm_config_done

rm -rf ~root/.ssh

rm -rf ~flint/.ssh

rm -f ~flint/.bash_history
rm -f ~root/.bash_history

rm -f ~flint/flint/app/app_secret.txt

# lock root account
passwd -l root

rm -f ~flint/prepvm.sh

# this zeros out the remainder of the FS, making it compress better
echo "Zeroing out remainder of disk, to make compression easier"
cat /dev/zero > zero.fill || true
sync
sleep 1
sync
rm -f zero.fill
sync
