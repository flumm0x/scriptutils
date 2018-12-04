#!/bin/bash
######################################################################################################################
#Location: Currently running on HOSTS OMITTED
#Filename: /root/loginaudit.sh
#Behavior: On the first day of the month, it will get the previous month's failed and successful logins and sudo attempts.
#Notes: ignoring oraots/oraauxr. they are service accounts that spam the logs. ignore cimserver. acknowledged and spam. secure.* works fine but we need to sort the dates.
######################################################################################################################
#LASTMONTH="$(date +%Y%m -d "$(date +%d) day ago")"
LASTMONTH=$(date +%b --date '1 month ago')
printf "HAVE YOUR OUTLOOK REMOVE EXTRA LINE BREAKS TO RENDER THIS EMAIL\n==========================Successful Logins======================\n" > /root/loginaudit$LASTMONTH.txt
for (( i = 4; i > 0; i--))
{
grep -i accept /var/log/secure.$i | grep -i $LASTMONTH | grep -v oraots | grep -v oraauxr | grep -v cimserver >> /root/loginaudit$LASTMONTH.txt
}
grep -i accept /var/log/secure | grep -i $LASTMONTH | grep -v oraots | grep -v oraauxr | grep -v cimserver >> /root/loginaudit$LASTMONTH.txt

printf "\n============================Failed Logins========================\n" >> /root/loginaudit$LASTMONTH.txt

for (( i = 4; i > 0; i--))
{
grep -i fail /var/log/secure.$i | grep -i $LASTMONTH | grep -v oraots | grep -v oraauxr | grep -v cimserver >> /root/loginaudit$LASTMONTH.txt
}
grep -i fail /var/log/secure | grep -i $LASTMONTH | grep -v oraots | grep -v oraauxr | grep -v cimserver >> /root/loginaudit$LASTMONTH.txt

printf "\n===========================Sudoers Activity======================\n" >> /root/loginaudit$LASTMONTH.txt

grep -i sudo /var/log/secure.* >> /root/loginaudit$LASTMONTH.txt
mail -s "HOSTNAME $LASTMONTH Login Report" kristopher.kahn@highpointsolutions.com < /root/loginaudit$LASTMONTH.txt
mv /root/loginaudit$LASTMONTH.txt /root/logins

#crontab. runs first of the month at 5 AM
#0 5 1 * * /root/loginaudit.sh 
