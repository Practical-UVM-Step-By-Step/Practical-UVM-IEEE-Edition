#!/bin/sh
for file in `cat filelist`
do
	#echo "Doing $file"
#		sed -f sedfile $file > a 
#		mv a $file	
echo $file ":" `egrep drain_time $file`



done

