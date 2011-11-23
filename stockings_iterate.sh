#!/usr/bin/bash


for i in {1..10000}
do
	RESULT=`/home/Douglas/bin/stockings_iterate.pl`
	echo $RESULT;
	NUM_FAILURES=`echo $RESULT | awk '{print $1}'`
	if [ $NUM_FAILURES -eq 0 ]; then
		echo "DONE"
		break
	fi

done

echo "SCRIPT FINISHED"
