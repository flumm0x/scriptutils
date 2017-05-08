###################################################################################################################
# take user input for username and temporary password on stdin, login to each host 
# defined in /root/scriptsshit/ugxhosts.txt and add that user. set the password to
# expire, add to sudoers.
###################################################################################################################
#!/bin/bash

FILE="/root/scriptshit/ugxhosts.txt"
username=$1
passwd=$2

#No changing root
if [[ $username == "root" ]]; then
	echo "Do not change the root password."
	exit 1
fi

#Needs 2 arguments 
if [[ $# -eq 0 || $# -eq 1 ]]
	then
		echo "This script requires 2 arguments. Usage: sh addugxusers.sh Username Password. Exiting."
	exit 1
fi

echo "Username:	" $username
echo "Password (Will be set to expire): " $passwd
echo "Reading from servers listed in: " $FILE

for HOST in $(cat /root/scriptshit/ugxhosts.txt )
		do ssh $HOST "useradd $username; echo $username:$passwd | chpasswd; passwd -e $username; echo '$username	ALL=(applmgr,oradevl,appldevl,applebst,oravcpt,applvcpt,oraebsd,applebsd,oravcpd,applvcpd,oraebsq,applebsq,oravcpq,applvcpq,oraebst,oraebss,applebss,oravcps,applvcps,oraebsp,applebsp,oravcpp,applvcpp,cvadmin,oraebsm,applebsm)       NOPASSWD: ALL' >> /etc/sudoers"
done
