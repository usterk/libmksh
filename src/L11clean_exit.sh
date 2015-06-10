#!/bin/bash
MKSH_CLEAN_EXIT_TRASH=''
function add_trash(){
	MKSH_CLEAN_EXIT_TRASH="$MKSH_CLEAN_EXIT_TRASH $1"
}

function clean_exit(){
		EXIT_CODE=$1
		CLEAN_EXIT_IFS_BACK=$IFS
		IFS=' '
	    local PLIK_SMIEC=''
	    if [ ! -z "$MKSH_CLEAN_EXIT_TRASH" ]
	    	then
        		debug "Uruchomiono clean_exit $EXIT_CODE aby wyczyscic: $MKSH_CLEAN_EXIT_TRASH"
        	else
        		debug "Uruchomiono clean_exit $EXIT_CODE, brak plików do usunięcia."
        fi
        for PLIK_SMIEC in $MKSH_CLEAN_EXIT_TRASH;
                do
                        debug "Sprawdzam czy istnieje $PLIK_SMIEC"
                        if [ -f $PLIK_SMIEC ]
                                then
                                        debug "Kasuje plik $PLIK_SMIEC"
                                        rm $PLIK_SMIEC
                        fi
                        if [ -d $PLIK_SMIEC ]
                                then 
                                        debug "Kasuje katalog $PLIK_SMIEC"
                                        rm -rf $PLIK_SMIEC
                        fi
        done
        IFS=$CLEAN_EXIT_IFS_BACK
        debug "Kończę program z kodem błędu $EXIT_CODE"
   		exit $EXIT_CODE
}

L11clean_exit.shCheckDependencies(){
	is_function log 
	if [ $? -ne 0 ] 
		then
			return 1;
	fi
	is_function debug
	if [ $? -ne 0 ] 
		then
			return 1;
	fi
}