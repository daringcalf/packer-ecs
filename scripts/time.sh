#!/usr/bin/env bash
set -e

# Configure host to use timezone
# http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/set-time.html
echo "### Setting timezone to $TIMEZONE ###"
#sudo tee /etc/sysconfig/clock << EOF > /dev/null
#ZONE="$TIMEZONE"
#UTC=true
#EOF

#sudo ln -sf /usr/share/zoneinfo/"$TIMEZONE" /etc/localtime

# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/set-time.html
sudo timedatectl set-timezone "${TIMEZONE}"

# Use AWS NTP Sync service
#echo "server 169.254.169.123 prefer iburst" | sudo tee -a /etc/ntp.conf

# Enable NTP
#sudo chkconfig ntpd on
# redundant in linux 2 ami
# sudo sed -i '1s/^/server 169.254.169.123 prefer iburst minpoll 4 maxpoll 4\n/' /etc/chrony.conf
# sudo sed -i '1s/^/# use the Amazon Time Sync Service (if available)\n/' /etc/chrony.conf

# sudo systemctl restart chronyd 
sudo systemctl enable chronyd 
