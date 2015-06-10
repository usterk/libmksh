#!/bin/bash
function print_nounset(){
        # Przykład użycia print_nounset:
        # Zapisanie wartosci nounset w $_set
        # _set=`print_nounset`
        # set +u
        # <kod>
        # Przywrocenie wartosci nounset przez uruchomienie zawartosci zmiennej $_set:
        # $_set
        echo $SHELLOPTS | grep -q nounset
        if [ $? -eq 0 ]
                then
                        echo "set -u"
                else
                        echo "set +u"
        fi     
}

function is_function(){
        type $1 2>&1| grep -q 'is a function\|shell function\|jest funkcją' >/dev/null 2>&1 
        if [ $? -ne 0 ] 
                then
                        echo "Brak funkcji $1()";
                        return 1;
        fi
}

L00mksh_core.shCheckDependencies(){
        echo -ne ""
}