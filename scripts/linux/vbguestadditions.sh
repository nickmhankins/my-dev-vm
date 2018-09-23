echo "==> VirtualBox Guest Additions"
yum -y install gcc make bzip2 kernel-headers kernel-devel dkms "kernel-headers-$(uname -r)"
#yum -y install "kernel-headers-$(uname -r)"
#yum -y install "kernel-devel"
#yum -y install "kernel-devel-$(uname -r)"
# for some reason the vb guest additions needed this particular version below...
#yum -y install "kernel-devel-3.10.0-862.11.6.el7"
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