#!/bin/bash

# variables

architecture=$(uname -a)
CPU_Physical=$(grep "cpu cores" /proc/cpuinfo | awk 'END {print $4}')
vCPU=$(grep -c processor /proc/cpuinfo)
total_memory=$(free -m | grep Mem | awk '{print $2}')
used_memory=$(free -m | grep Mem | awk '{print $3}')
percentage_memory=$(echo 'scale=4;'$used_memory/$total_memory | bc | xargs -I res echo 'scale=2;'res*100/1 | bc)
total_disk=$(df -Bg | grep -E '/home$|/$'| awk '!($1 in duplicate){total_disk += $2; duplicate[$1]} END {print total_disk}')
used_disk=$(df -Bm | grep -E '/home$|/$' | awk '!($1 in duplicate){used_disk += $3; duplicate[$1]} END {print used_disk}')
percentage_disk=$(echo 'scale=4;'$used_disk/1000/$total_disk | bc | xargs -I res echo res*100/1 | bc)
cpu_load=$(top -bn1 | grep "^%Cpu(s)" | awk '{print $2 + $4}')
last_boot=$(who -b | awk '{print $3,$4}')
LVM_use=$(lsblk | grep -c lvm | xargs -I nlvm [ nlvm -gt 0 ] && echo yes || echo no)
connexions_TCP=$(ss -t state established | tail -n +2 | wc -l)
user_log=$(who | wc -l)
ip=$(ip a | grep -A 2 "state UP" | grep "^    inet" | awk '{print $2}' | sed 's/\/24//')
mac=$(ip a | grep -A 2 "state UP" | grep "^    link/ether" | awk '{print $2}')
sudo=$(journalctl _COMM=sudo | grep -c COMMAND)

# affichage

wall "	#Architecture: $architecture
		#CPU Physical : $CPU_Physical
		#vCPU : $vCPU
		#Memory Usage: $used_memory/${total_memory}MB ($percentage_memory%)
		#Disk Usage: ${used_disk}MB/${total_disk}GB ($percentage_disk%)
		#CPU load: $cpu_load%
		#Last boot: $last_boot
		#LVM use: $LVM_use
		#Connexions TCP : $connexions_TCP ESTABLISHED
		#User log: $user_log
		#Network: IP $ip ($mac)
		#Sudo : $sudo cmd"