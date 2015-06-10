#!/bin/bash
function mksh_print_version(){
	if [ -f $_load_mksh_list_dir/VERSION ]
		then
			echo "Wersja: $(cat $_load_mksh_list_dir/VERSION)"
		else
			log "Brak pliku z wersją oprogramowania"
			debug "Plik powinien znajdować się w $_load_mksh_list_dir/VERSION"
	fi
}

# Do funkcji podajemy wymagana wersje w postaci x.x.x gdzie x jest [0-9]+
# Funkcja zwraca 0 jesli spelnione sa wymagania, != 0 jesli nie są spełnione. 
function mksh_check_version(){
	_mksh_check_version_ver=$1
	echo $_mksh_check_version_ver | grep -q '[0-9]\+.[0-9]\+.[0-9]\+'
	if [ $? -ne 0 ]
		then 
			return 2
	fi
	mksh_print_version | grep -q "$_mksh_check_version_ver"
	if [ $? -eq 0 ]
		then
			return 0
	fi
	_mksh_check_version_accual=$(mksh_print_version|awk '{print $2}')
	echo -ne "$_mksh_check_version_accual\n$_mksh_check_version_ver"|sort -r> /tmp/_mksh_mksh_check_version$$
	_mksh_check_version_head=$(head -n 1 /tmp/_mksh_mksh_check_version$$)
	rm /tmp/_mksh_mksh_check_version$$
	if [ $_mksh_check_version_head = $_mksh_check_version_ver ]
		then
			return 1
		else
			return 0
	fi
}

L90version.shCheckDependencies(){
        if  [ ! -f $_load_mksh_list_dir/VERSION ]
        	then
        		return 1
        fi
}
