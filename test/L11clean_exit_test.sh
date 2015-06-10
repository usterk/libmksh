#!/bin/bash
# vim:et:ft=sh:sts=2:sw=2
#
# Copyright 2008 Kate Ward. All Rights Reserved.
# Released under the LGPL (GNU Lesser General Public License)
#
# Author: kate.ward@forestent.com (Kate Ward)
#
# Example unit test for the mkdir command.
#
# There are times when an existing shell script needs to be tested. In this
# example, we will test several aspects of the the mkdir command, but the
# techniques could be used for any existing shell script.

#-----------------------------------------------------------------------------
# suite tests
#

# set_MKSH_LOCKS_LOCK_FILE
testAddTrash1(){
  add_trash 1 >${stdoutF} 2>${stderrF}
  rtrn=$?
  MKSH_CLEAN_EXIT_TRASH=''
  assertEquals "Nieoczekiwany kod błędu" "0" "$rtrn"
}

testAddTrash2(){
  add_trash 2 >${stdoutF} 2>${stderrF}
  rtrn=$?
  MKSH_CLEAN_EXIT_TRASH=''
  assertEquals "Nieoczekiwany stdout " "" "$(cat ${stdoutF})"
}

testAddTrash3(){
  add_trash 3 >${stdoutF} 2>${stderrF}
  rtrn=$?
  MKSH_CLEAN_EXIT_TRASH=''
  assertEquals "Nieoczekiwany stderr " "" "$(cat ${stderrF})"
}

testAddTrash4(){
  MKSH_CLEAN_EXIT_TRASH=''
  add_trash 1
  add_trash 2
  add_trash 3
  assertEquals "Nieoczekiwana wartosc MKSH_CLEAN_EXIT_TRASH " "$MKSH_CLEAN_EXIT_TRASH" " 1 2 3"
  retr=$?
  MKSH_CLEAN_EXIT_TRASH=''
  return $retr
}

testCleanExit1(){
	MKSH_CLEAN_EXIT_TRASH=''
	DEBUG=false
	mkdir ${testDir}/smiec
	mkdir ${testDir}/smiec2
	mkdir ${testDir}/smiec3
	touch ${testDir}/smiec/plik1
	touch ${testDir}/smiec/plik2
	touch ${testDir}/smiec2/plik3
	touch ${testDir}/smiec2/plik4
	add_trash ${testDir}/smiec/plik1
	add_trash ${testDir}/smiec/plik2
	mkshScriptRunner clean_exit 1 >${stdoutF} 2>${stderrF}
	assertEquals "Nieoczekiwany stdout " "" "$(cat ${stdoutF})"
}

testCleanExit2(){
	MKSH_CLEAN_EXIT_TRASH=''
	DEBUG=false
	mkdir ${testDir}/smiec
	mkdir ${testDir}/smiec2
	mkdir ${testDir}/smiec3
	touch ${testDir}/smiec/plik1
	touch ${testDir}/smiec/plik2
	touch ${testDir}/smiec2/plik3
	touch ${testDir}/smiec2/plik4
	add_trash ${testDir}/smiec/plik1
	add_trash ${testDir}/smiec/plik2
	mkshScriptRunner clean_exit 1 >${stdoutF} 2>${stderrF}
	assertEquals "Nieoczekiwany stderr " "" "$(cat ${stderrF})"
}

testCleanExit3(){
	MKSH_CLEAN_EXIT_TRASH=''
	DEBUG=false
	mkdir ${testDir}/smiec
	mkdir ${testDir}/smiec2
	mkdir ${testDir}/smiec3
	touch ${testDir}/smiec/plik1
	touch ${testDir}/smiec/plik2
	touch ${testDir}/smiec2/plik3
	touch ${testDir}/smiec2/plik4
	mkshScriptRunner "
	add_trash ${testDir}/smiec/plik1;
	add_trash ${testDir}/smiec/plik2;
	clean_exit 1" >${stdoutF} 2>${stderrF}
	test -f ${testDir}/smiec/plik1
	retr=$?
	assertEquals "Nieoczekiwany stdout " "1" "$retr"
}


testCleanExit4(){
	MKSH_CLEAN_EXIT_TRASH=''
	DEBUG=false
	mkdir ${testDir}/smiec
	mkdir ${testDir}/smiec2
	mkdir ${testDir}/smiec3
	touch ${testDir}/smiec/plik1
	touch ${testDir}/smiec/plik2
	touch ${testDir}/smiec2/plik3
	touch ${testDir}/smiec2/plik4
	mkshScriptRunner "
	add_trash ${testDir}/smiec/plik1
	add_trash ${testDir}/smiec/plik2
	clean_exit 1" >${stdoutF} 2>${stderrF}
	test -f ${testDir}/smiec/plik2
	retr=$?
	assertEquals "Nieoczekiwany stdout " "1" "$retr"
}

testCleanExit5(){
	MKSH_CLEAN_EXIT_TRASH=''
	DEBUG=false
	mkdir ${testDir}/smiec
	mkdir ${testDir}/smiec2
	mkdir ${testDir}/smiec3
	touch ${testDir}/smiec/plik1
	touch ${testDir}/smiec/plik2
	touch ${testDir}/smiec/plik3
	touch ${testDir}/smiec2/plik3
	touch ${testDir}/smiec2/plik4
	mkshScriptRunner "
	add_trash ${testDir}/smiec/plik1
	add_trash ${testDir}/smiec/plik2
	clean_exit 1" >${stdoutF} 2>${stderrF}
	test -f ${testDir}/smiec/plik3
	retr=$?
	assertEquals "Nieoczekiwany stdout " "0" "$retr"
}

testCleanExit6(){
	MKSH_CLEAN_EXIT_TRASH=''
	DEBUG=false
	mkdir ${testDir}/smiec
	mkdir ${testDir}/smiec2
	mkdir ${testDir}/smiec3
	touch ${testDir}/smiec/plik1
	touch ${testDir}/smiec/plik2
	touch ${testDir}/smiec/plik3
	touch ${testDir}/smiec2/plik3
	touch ${testDir}/smiec2/plik4
	mkshScriptRunner "
	add_trash ${testDir}/smiec
	add_trash ${testDir}/smiec3
	clean_exit 1" >${stdoutF} 2>${stderrF}
	test -d ${testDir}/smiec
	retr=$?
	assertEquals "Nieoczekiwany stdout " "1" "$retr"
}

testCleanExit7(){
	MKSH_CLEAN_EXIT_TRASH=''
	DEBUG=false
	mkdir ${testDir}/smiec
	mkdir ${testDir}/smiec2
	mkdir ${testDir}/smiec3
	touch ${testDir}/smiec/plik1
	touch ${testDir}/smiec/plik2
	touch ${testDir}/smiec/plik3
	touch ${testDir}/smiec2/plik3
	touch ${testDir}/smiec2/plik4
	mkshScriptRunner "
	add_trash ${testDir}/smiec
	add_trash ${testDir}/smiec3
	clean_exit 1" >${stdoutF} 2>${stderrF}
	test -d ${testDir}/smiec3
	retr=$?
	assertEquals "Nieoczekiwany stdout " "1" "$retr"
}

testCleanExit8(){
	MKSH_CLEAN_EXIT_TRASH=''
	DEBUG=false
	mkdir ${testDir}/smiec
	mkdir ${testDir}/smiec2
	mkdir ${testDir}/smiec3
	touch ${testDir}/smiec/plik1
	touch ${testDir}/smiec/plik2
	touch ${testDir}/smiec/plik3
	touch ${testDir}/smiec2/plik3
	touch ${testDir}/smiec2/plik4
	mkshScriptRunner "
	add_trash ${testDir}/smiec
	add_trash ${testDir}/smiec3
	clean_exit 1" >${stdoutF} 2>${stderrF}
	test -d ${testDir}/smiec2
	retr=$?
	assertEquals "Nieoczekiwany stdout " "0" "$retr"
}

testCleanExit9(){
	MKSH_CLEAN_EXIT_TRASH=''
	DEBUG=false
	mkdir ${testDir}/smiec
	mkdir ${testDir}/smiec2
	mkdir ${testDir}/smiec3
	touch ${testDir}/smiec/plik1
	touch ${testDir}/smiec/plik2
	touch ${testDir}/smiec2/plik3
	touch ${testDir}/smiec2/plik4
	mkshScriptRunner "
	add_trash ${testDir}/smiec/plik1
	add_trash ${testDir}/smiec/plik2
	clean_exit 1" >${stdoutF} 2>${stderrF}
	test -d ${testDir}/smiec
	retr=$?
	assertEquals "Nieoczekiwany stdout " "0" "$retr"
}

testCleanExit10(){
	MKSH_CLEAN_EXIT_TRASH=''
	DEBUG=false
	mkdir ${testDir}/smiec
	mkdir ${testDir}/smiec2
	mkdir ${testDir}/smiec3
	touch ${testDir}/smiec/plik1
	touch ${testDir}/smiec/plik2
	touch ${testDir}/smiec2/plik3
	touch ${testDir}/smiec2/plik4
	mkshScriptRunner "
	add_trash ${testDir}/smiec/plik1
	add_trash ${testDir}/smiec/plik2
	IFS_BACK=\$IFS
	IFS=a
	clean_exit 1 
	IFS=\$IFS_BACK" >${stdoutF} 2>${stderrF}
	test -f ${testDir}/smiec/plik1
	retr=$?
	assertEquals "Nieoczekiwany stdout " "1" "$retr"
}

testCleanExit11(){
	MKSH_CLEAN_EXIT_TRASH=''
	DEBUG=false
	mkdir ${testDir}/smiec
	mkdir ${testDir}/smiec2
	mkdir ${testDir}/smiec3
	touch ${testDir}/smiec/plik1
	touch ${testDir}/smiec/plik2
	touch ${testDir}/smiec2/plik3
	touch ${testDir}/smiec2/plik4
	mkshScriptRunner "
	add_trash ${testDir}/smiec/plik1
	add_trash ${testDir}/smiec/plik2
	clean_exit 13" >${stdoutF} 2>${stderrF}
	retr=$?
	assertEquals "Nieoczekiwany stdout " "13" "$retr"
}


#Sprawdzac IFS


#-----------------------------------------------------------------------------
# suite functions
#

mkshScriptRunner(){
	echo "#!/bin/bash
	source src/load_mksh.sh src
	$*
	" > ${testDir}/$$.sh
	chmod +x ${testDir}/$$.sh
	${testDir}/$$.sh
	mkshScriptRunnerRet=$?
	rm ${testDir}/$$.sh
	return $mkshScriptRunnerRet
}

printNounset(){
        echo $SHELLOPTS | grep -q nounset
        if [ $? -eq 0 ]
                then
                        echo "set -u"
                else
                        echo "set +u"
        fi     
}

th_assertTrueWithNoOutput()
{
  th_return_=$1
  th_stdout_=$2
  th_stderr_=$3

  assertFalse "unexpected output to STDOUT `cat ${th_stdout_}`" "[ -s '${th_stdout_}' ]"
  assertFalse "unexpected output to STDERR `cat ${th_stderr_}`" "[ -s '${th_stderr_}' ]"

  unset th_return_ th_stdout_ th_stderr_
}

oneTimeSetUp()
{
	MKSH_UNIT_TEST=true
	source src/load_mksh.sh src
	outputDir="${SHUNIT_TMPDIR}/output"
	mkdir "${outputDir}"
	stdoutF="${outputDir}/stdout"
	stderrF="${outputDir}/stderr"
	testDir="${SHUNIT_TMPDIR}/test_dir"
	mkdir "${testDir}"
}

setUp()
{
	MKSH_LOCKS_LOCK_DIR=${testDir}/var/run/locks
	rm -rf $MKSH_LOCKS_LOCK_DIR
	mkdir -p $MKSH_LOCKS_LOCK_DIR
        MKSH_LOCKS_LOCK_MAX_TIME=60
}

tearDown()
{
  rm -fr "${testDir}"
}

# load and run shUnit2
[ -n "${ZSH_VERSION:-}" ] && SHUNIT_PARENT=$0
#. ../src/shunit2
. test/shunit2-2.1.6/src/shunit2
