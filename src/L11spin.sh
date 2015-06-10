#!/bin/bash

MKSH_SPIN='-\|/'
MKSH_SPIN_I=0
MKSH_SPIN_ITER_START=0
MKSH_SPIN_ITER_STOP=0
MKSH_SPIN_ITER=0

spin_reset(){
	MKSH_SPIN_ITER=0
}

# 2 argumenty
# Pierwszy podaje liczbe iteracji aby policzyc procent
# Drugi jesli istnieje nie pokazuje wiatraka
spin(){
	MKSH_SPIN_ITER_STOP=0
	# Sprawdzamy czy to integer i czy wiekszy niz 0
	if [ -z "${1##[0-9]*}" ] && [ ! -z "$1" ]  && [ "$1" -gt 0 ]
		then
			MKSH_SPIN_ITER_STOP=$1
	fi
	MKSH_SPIN_ITER=$((MKSH_SPIN_ITER+1))
	MKSH_SPIN_I=$(( (MKSH_SPIN_I+1) %4 ))
	if [ -z "$2" ]
		then
			printf "\r${MKSH_SPIN:$MKSH_SPIN_I:1} "
	fi
	if [ $MKSH_SPIN_ITER_STOP -gt 0 ]
		then
			MKSH_SPIN_PROC=$(( (MKSH_SPIN_ITER*100)/MKSH_SPIN_ITER_STOP ))
			printf "${MKSH_SPIN_PROC}%%"
	fi
}

L11spin.shCheckDependencies(){
	return 0
}
