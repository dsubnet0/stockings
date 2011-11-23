#!/usr/bin/bash


for i in {1..10000}
do
	RESULT=`./stockings.pl`
	NUM_FAILURES=`echo $RESULT | awk '{print $1}'`
	if [ $NUM_FAILURES -eq 0 ]; then
		echo "DONE"
		echo $RESULT
		break
	fi

done

echo "SCRIPT FINISHED"
