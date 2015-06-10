#!/bin/bash - 
#===============================================================================
#
#          FILE:  logs.sh
# 
#         USAGE:  source logging.sh
# 
#   DESCRIPTION:  skrypt odpowiedzialny za logowanie do plików i na ekran
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR: Paweł Guć, 
#       COMPANY: 
#       CREATED: 26.09.2012 21:41:37 CEST
#      REVISION:  ---
#===============================================================================

_module_nounset_save=`print_nounset`
set +u

# Czy zmieniac uprawnienia pliku z logami na MKSH_LOG_APPLY_USER i MKSH_LOG_APPLY_GROUP
if [ -z $MKSH_LOG_APPLY_USER_AND_GROUP ]
	then
		MKSH_LOG_APPLY_USER_AND_GROUP=false
fi

if [ -z $MKSH_LOG_APPLY_USER ]
	then
		MKSH_LOG_APPLY_USER=www-data
fi

if [ -z $MKSH_LOG_APPLY_GROUP ]
	then
		MKSH_LOG_APPLY_GROUP=www-data
fi

if [ -z $MKSH_LOG_THIS_SCRIPT_NAME ]
	then
		MKSH_LOG_THIS_SCRIPT_NAME=logs
fi

if [ -z $DEBUG ]
        then
                DEBUG=false
fi

if [ -z $MKSH_LOG_TIME_FORMAT ]
        then
                MKSH_LOG_TIME_FORMAT='%Y-%m-%d %H:%M:%S'
fi

if [ -z $MKSH_LOG_TIME_STDOUT ]
	then
		MKSH_LOG_TIME_STDOUT=false
fi

if [ -z $MKSH_LOG_FILE ]
	then
		MKSH_LOG_FILE=''
fi

################################################################################
set -u

function _logging_check_dir_exists(){
	if [ ! -z "$MKSH_LOG_FILE" ] && [ ! -d $(dirname $MKSH_LOG_FILE) ]
		then
			echo "Błąd funkcji log. Brak katalogu $(dirname $MKSH_LOG_FILE)" >&2
			return 7
	fi
}

function stdin_log(){
        # obsługa paraetru: (`data` parametr: tresc logu)
        if [ $# -eq 1 ]
                then
                        STDIN_LOG_SOFT="($1)"
                        STDIN_DELI=": "
                else
                        STDIN_LOG_SOFT=""
                        STDIN_DELI=""
        fi
        _logging_check_dir_exists
        _retr=$?
        if [ $_retr -ne 0 ]
                then
                        return $_retr
        fi
        _set=`print_nounset`
        set +u
        while read std_line;
                do
                        #local std_line=(${std_line});
			if [ $MKSH_LOG_TIME_STDOUT = true ]
				then
                        		echo "`date +\"$MKSH_LOG_TIME_FORMAT \"`${STDIN_LOG_SOFT}${STDIN_DELI}${std_line[*]}"
				else
					echo "${STDIN_LOG_SOFT}${STDIN_DELI}${std_line[*]}"
			fi
			if [ ! -z $MKSH_LOG_FILE ]
				then
                        		echo "`date +\"$MKSH_LOG_TIME_FORMAT \"`${MKSH_LOG_THIS_SCRIPT_NAME}${STDIN_LOG_SOFT}: ${std_line[*]}" >> $MKSH_LOG_FILE
			fi
	done
        $_set
}

function log(){
        _logging_check_dir_exists
        _retr=$?
        if [ $_retr -ne 0 ]
                then
                        return $_retr
        fi
	if [ $MKSH_LOG_TIME_STDOUT = true ]
		then
			"`date +\"$MKSH_LOG_TIME_FORMAT\"`: $*"
		else
        		echo $*
	fi
	if [ ! -z $MKSH_LOG_FILE ]
		then
        		echo "`date +\"$MKSH_LOG_TIME_FORMAT \"`${MKSH_LOG_THIS_SCRIPT_NAME}: $*" >> $MKSH_LOG_FILE
        		if [ "`whoami`" = "root" ] && [ $MKSH_LOG_APPLY_USER_AND_GROUP = true ]
                		then
                        		chown $MKSH_LOG_APPLY_USER:$MKSH_LOG_APPLY_GROUP $MKSH_LOG_FILE
        		fi
	fi
        return $?
}

function debug(){
        if [ "$DEBUG" = "true" ]
                then
                        log "DEBUG: $*"
        fi
}

L10logging.shCheckDependencies(){
        is_function print_nounset
        if [ $? -ne 0 ] 
                then
                        return 1
        fi
}

# Przywracanie ustawień 
$_module_nounset_save
