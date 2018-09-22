yum -y groups install "GNOME Desktop"
yum -y remove gnome-getting-started-docs
echo "X-GNOME-Autostart-enabled=false" >> /etc/xdg/autostart/gnome-initial-setup-first-login.desktop 
systemctl set-default graphical.target