#!/bin/sh

CONFIG=$HOME/.config/sway/config
FILE=$HOME/.config/sway/typing_mode
IN_MODE=0

if [ -f $FILE ]; then
	IN_MODE=$(cat $FILE)
fi

if [ "$IN_MODE" == "1" ]; then
	sed -i '10s/.*/set \$mod Control/' $CONFIG
	echo 0 > $FILE
elif [ "$IN_MODE" == "0" ]; then
	sed -i '10s/.*/set \$mod Mod1/' $CONFIG
	echo 1 > $FILE
fi

