#!/bin/bash
: ' 
Script for hardening the vps server. 
1. remove the unwanted software and installtions 
2. Script to create new user with encrypted password and add to sudo group
3. will stop network listerners
4. create a cron job to update the machine every
'
echo 1. remove the unwanted software and installtions 
#sudo apt-get --purge remove xinetd nis yp-tools tftpd atftpd tftpd-hpa telnetd rsh-server rsh-redone-server

echo 2. Script to create new user with encrypted password and add to sudo group

if [ $(id -u) -eq 0 ]; then
	read -p "Create new user please enter username: " username
	read -s -p "Enter password : " password
	egrep "^$username" /etc/passwd >/dev/null
	if [ $? -eq 0 ]; then
		echo "$username exists!"
		exit 1
	else
		pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
		useradd -m -p $pass $username
		./addtosudo.sh $username
		[ $? -eq 0 ] && echo "User has been added to system!" || echo "Failed to add a user!"
	fi
else
	echo "Only root may add a user to the system"
	exit 2
fi

#3. will stop network listerners



echo 4. Create a cron job to update the machine

echo "45 21 * * * root apt-get -y update" >> /etc/crontab
echo "45 22 * * * root apt-get -y upgrade" >> /etc/crontab
