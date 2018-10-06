echo "==> VirtualBox Guest Additions"
yum -y install gcc make bzip2 kernel-headers-$(uname -r) kernel-devel-$(uname -r)
yum -y update
mkdir /tmp/virtualbox
VERSION=$(cat /home/vagrant/.vbox_version)
echo "==> Mounting VirtualBox Guest Additions ISO"
mount -o loop /home/vagrant/VBoxGuestAdditions_$VERSION.iso /tmp/virtualbox
echo "==> Building..."
sh /tmp/virtualbox/VBoxLinuxAdditions.run
echo "==> Unmounting"
umount /tmp/virtualbox
echo "==> Removing mount dir and ISO"
rmdir /tmp/virtualbox
rm /home/vagrant/*.iso