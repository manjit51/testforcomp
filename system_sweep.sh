#!/bin/bash

IP_RANGE=("10.4.10.254" "10.4.10.11" "10.4.10.21" "10.4.10.31" "10.4.10.41" "10.4.10.51" "10.4.10.61" "10.4.10.71" "10.4.10.81")

for ip in $(nmap -sL ${IP_RANGE[@]} | awk '/Nmap scan report for/{print $5}'); do
	nmap -Pn -r -T4 -d $ip -oN "Lscanrep_$ip.txt" >/dev/null
done

for ip in $(nmap -sL ${IP_RANGE[@]} | awk '/Nmap scan report for/{print $5}'); do
	nmap -Pn -sV -r -T4 -d $ip -oN "Mscanrep_$ip.txt" >/dev/null
done

for ip in $(nmap -sL ${IP_RANGE[@]} | awk '/Nmap scan report for/{print $5}'); do
	echo -e "\033[1;31mDEEP SCAN INITIATING AT "$ip" IN 10 SECONDS\033[0m"
	sleep 10
	nmap -Pn -sV -p- --script vuln -r -T4 -d $ip -oN "Dscanrep_$ip.txt" >/dev/null
done

echo "------------====SCAN COMPLETED====-------------"
