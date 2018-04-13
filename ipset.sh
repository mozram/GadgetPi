#!/bin/sh
#
# GadgetPi
#  by mozram
#  https://github.com/mozram/GadgetPi/
#  14/01/2017
#

# Set fixed Link-Local IP for USB0
# ifconfig usb0 169.254.100.100

# ifconfig|grep "169.254.100.100"

# ip=$?

# while [ $? -ne 0]; do
#     ifconfig usb0 169.254.100.100
#     ifconfig|grep "169.254.100.100"
# done

n=0
until [ $n -ge 5 ]
do
    ifconfig usb0 169.254.100.100 
    ifconfig|grep "169.254.100.100" && break  # substitute your command here
    n=$((n+1))
    sleep 1
done