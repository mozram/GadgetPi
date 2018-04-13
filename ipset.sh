#!/bin/sh
#
# GadgetPi
#  by mozram
#  https://github.com/mozram/GadgetPi/
#  14/01/2017
#
#  Set ip addres to usb0

n=0
until [ $n -ge 5 ]
do
    ifconfig usb0 169.254.100.100 
    ifconfig|grep "169.254.100.100" && break  # substitute your command here
    n=$((n+1))
    sleep 1
done