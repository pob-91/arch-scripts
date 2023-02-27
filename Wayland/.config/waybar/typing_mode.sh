#!/bin/bash

FILE=$HOME/.config/sway/typing_mode

IN_MODE=0
if [ -f $FILE ]; then
	IN_MODE=$(cat $FILE)
fi

if [ "$IN_MODE" == "0" ]; then
	echo ""
elif [ "$IN_MODE" == "1" ]; then
	echo "typing mode"
fi
