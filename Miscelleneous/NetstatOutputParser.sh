#!/bin/bash

#To get uniq foregin addresses from netstat output
netstat -plantu | awk '/[0-9]/{print $5}' | cut -d ":" -f1 | grep -v "^$"| sort | uniq -c

#To get the process id and the processname from netstat output
netstat -plantu | awk '//{print $7}' | grep -v "^$" | awk -F'/' '{print $1 "\t" $2}'

#To print the output line where foreign and local address is same

