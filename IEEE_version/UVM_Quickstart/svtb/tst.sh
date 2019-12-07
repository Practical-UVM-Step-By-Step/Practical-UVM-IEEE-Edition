#!/bin/sh
for file in `cat list`
do 
	sed -f sedfile $file > a
	mv a $file
done
