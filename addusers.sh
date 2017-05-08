#!/bin/bash
#script to ssh to host, take text file, perform useradds and edit sudoers
#will be run as root:
#sh addusers.sh username ugxservers.txt
#
#this will ssh to the hosts in ugxservers, run useradd $username, and echo that users into /etc/sudoers 
#
##############################################################################

#echo 'username	ALL=(ALL:ALL) ALL' >> /etc/sudoers
#	      ^^
#	      tab

#while [[ -n $1 ]]; do
#	echo "$1	ALL=(ALL:ALL) ALL"; #>> /etc/sudoers;
#	shift #shift parameters
#done

	newuser=$1
for HOST in $(cat /root/scriptshit/ugxhosts.txt ) 
	#newuser=$1 #get user from stdin
	randompw=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1) ##get random pass
	#do ssh ${HOST}.ugnx.local ""
	do
		ssh $HOST "useradd $newuser; echo $newuser:$randompw | chpasswd; echo $newuser; $randompw"
done 


#ALL=(applmgr,oradevl,appldevl,applebst,oravcpt,applvcpt,oraebsd,applebsd,oravcpd,applvcpd,oraebsq,applebsq,oravcpq,applvcpq,oraebst,oraebss,applebss,oravcps,applvc
#ps,oraebsp,applebsp,oravcpp,applvcpp,cvadmin,oraebsm,applebsm)       NOPASSWD: ALL
