#!/bin/bash
######################################################################################################################
#Location: Currently running on OTSUATERP64.hps-ots.local and OTSPRDDB.hps-ots.local
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
mail -s "OTSPRDDB $LASTMONTH Login Report" kristopher.kahn@highpointsolutions.com anand.valluri-cw@otsuka-us.com < /root/loginaudit$LASTMONTH.txt
mv /root/loginaudit$LASTMONTH.txt /root/logins

#30 15 * * * /opt/VRTSralus/bin/VRTSralus.init restart >/dev/null 2>&1
