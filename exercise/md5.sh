#!/bin/bash
PIDARRAY=()
for file in FILE1.iso FILE2.iso
do
	md5sum $file &
	PIDARRAY+=("$!")
done
wait ${PIDARRAY[@]}
