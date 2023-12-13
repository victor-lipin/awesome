#!/bin/bash
tp () {
RELEASE=$(grep "^active-opacity" ~/.config/awesome/picom.conf | awk '{print $3}')
if [ $RELEASE == "0.9;" ]; then sed -i 's\^active-opacity = 0.9\active-opacity = 1\' ~/.config/awesome/picom.conf;fi
if [ $RELEASE == "1;" ]; then sed -i 's\^active-opacity = 1\active-opacity = 0.9\' ~/.config/awesome/picom.conf;fi
}

if [ $1 == tp ]; then tp;fi
