#!/bin/bash

echo "==> Remove persisent interface rules"
rm -f /etc/udev/rules.d/70*
echo "==> Remove histfile and KS files"
rm -f ~root/.bash_history
unset HISTFILE
rm -f ~root/anaconda-ks.cfg
# Cleanup temp
rm -rf /tmp/* ||:
# Cleanup logs
find /var/log -type f | while read f; do echo -ne '' > $f; done;

yum -y clean all
rm -rf /var/cache/yum
echo '==> Zeroing out empty area to save space in the final image'
# Zero out the free space to save space in the final image.  Contiguous
# zeroed space compresses down to nothing.
dd if=/dev/zero of=/EMPTY bs=1M || echo "dd exit code $? is suppressed"
rm -f /EMPTY
# Block until the empty file has been removed
sync
