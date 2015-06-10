#!/bin/bash
_module_nounset_save=$(print_nounset)
set +u
if [ -z $MKSH_LOCKS_LOCK_DIR ]
        then
                MKSH_LOCKS_LOCK_DIR=/tmp
fi

if [ -z $MKSH_LOCKS_LOCK_FILE ]
        then
                MKSH_LOCKS_LOCK_FILE=mksh_default.lock
fi

if [ -z $MKSH_LOCKS_LOCK_MAX_TIME ]
        then
                MKSH_LOCKS_LOCK_MAX_TIME=1440
fi
set -u

function check_lock_file(){
        _check_MKSH_LOCKS_LOCK_FILE_OLD=$(find $MKSH_LOCKS_LOCK_DIR/ -maxdepth 1 -name $MKSH_LOCKS_LOCK_FILE -cmin +$MKSH_LOCKS_LOCK_MAX_TIME|wc -l|awk '{print $1}')
        if [ $_check_MKSH_LOCKS_LOCK_FILE_OLD -ne 0 ]
                then
                        log "Kasuję stary plik lock ${MKSH_LOCKS_LOCK_DIR}/${MKSH_LOCKS_LOCK_FILE}"
                        del_lock_file
        fi

        MKSH_LOCKS_LOCK_FILES_NUM=$(find $MKSH_LOCKS_LOCK_DIR/ -maxdepth 1 -name $MKSH_LOCKS_LOCK_FILE -cmin -$MKSH_LOCKS_LOCK_MAX_TIME|wc -l|awk '{print $1}')

        if [ $MKSH_LOCKS_LOCK_FILES_NUM -ne 0 ]
                then
                        debug "Znalazłem plik lock ${MKSH_LOCKS_LOCK_DIR}/${MKSH_LOCKS_LOCK_FILE}"
                        return 1
        fi
}

function set_lock_file(){
        check_lock_file
        if [ $? -eq 1 ]
        	then
        		# Istnieje lock
        		return 1
        	else
        		touch ${MKSH_LOCKS_LOCK_DIR}/${MKSH_LOCKS_LOCK_FILE}
        fi
}

function del_lock_file(){
	if [ -f ${MKSH_LOCKS_LOCK_DIR}/${MKSH_LOCKS_LOCK_FILE} ]
		then
			rm -f ${MKSH_LOCKS_LOCK_DIR}/${MKSH_LOCKS_LOCK_FILE}
		else
			debug "Plik lock ${MKSH_LOCKS_LOCK_DIR}/${MKSH_LOCKS_LOCK_FILE} nie istnieje."
	fi
}

L11locks.shCheckDependencies()
{
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
$_module_nounset_save