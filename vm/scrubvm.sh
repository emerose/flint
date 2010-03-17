#!/usr/bin/env bash

set -e

# remove openssh server and re-install 
dpkg -P build-essential
dpkg -P linux-headers-$(uname -r)

# grab pico, for our lusers
apt-get install nano

apt-get clean

rm -f ~playbook/initial_vm_config_done

rm -rf ~root/.ssh

rm -f ~root/playbook*.deb

rm -rf ~playbook/.ssh

rm -f ~playbook/.bash_history
rm -f ~root/.bash_history

touch ~playbook/.password_needs_changing
chown playbook ~playbook/.password_needs_changing

# lock root account
passwd -l root

rm -f ~root/prepvm.sh

# this zeros out the remainder of the FS, making it compress better
echo "Zeroing out remainder of disk, to make compression easier"
cat /dev/zero > zero.fill || true
sync
sleep 1
sync
rm -f zero.fill
sync
