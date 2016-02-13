#!/bin/bash
foo='test'
read -p "Run command $foo? [yn]" answer
if [[ $answer = y ]]; 
	then
		# run the command
		echo 1
	# else
	# 	echo "no"
fi
