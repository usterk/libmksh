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
testSetLockFileStdOut1(){
  set_lock_file >${stdoutF} 2>${stderrF}
  rtrn=$?
  assertEquals "Nieoczekiwany komunikat na stdout" "" "$(cat ${stdoutF})"
}

testSetLockFileStdErr1(){
  set_lock_file >${stdoutF} 2>${stderrF}
  rtrn=$?
  assertEquals "Nieoczekiwany komunikat na stderr" "" "$(cat ${stderrF})"
}

testSetLockFileStdOut2(){
  DEBUG=false
  set_lock_file
  set_lock_file >${stdoutF} 2>${stderrF}
  rtrn=$?
  assertEquals "Nieoczekiwany komunikat na stdout" "" "$(cat ${stdoutF})"
}

testSetLockFileStdErr2(){
  DEBUG=false
  set_lock_file
  set_lock_file >${stdoutF} 2>${stderrF}
  rtrn=$?
  assertEquals "Nieoczekiwany komunikat na stderr" "" "$(cat ${stderrF})"
}

testSetLockFileStdOutDebug(){
  DEBUG=true
  set_lock_file
  set_lock_file >${stdoutF} 2>${stderrF}
  rtrn=$?
  assertEquals "Nieoczekiwany komunikat na stdout" "DEBUG: Znalazłem plik lock $MKSH_LOCKS_LOCK_DIR/$MKSH_LOCKS_LOCK_FILE" "$(cat ${stdoutF})"
}

testSetLockFileStdErrDebug(){
  DEBUG=true
  set_lock_file
  set_lock_file >${stdoutF} 2>${stderrF}
  rtrn=$?
  assertEquals "Nieoczekiwany komunikat na stderr" "" "$(cat ${stderrF})"
}

testSetLockFileStdOutDebugOldLock(){
  DEBUG=true
  MKSH_LOCKS_LOCK_MAX_TIME=0
  set_lock_file
  sleep 1
  set_lock_file >${stdoutF} 2>${stderrF}
  rtrn=$?
  assertEquals "Nieoczekiwany komunikat na stdout" "Kasuję stary plik lock $MKSH_LOCKS_LOCK_DIR/$MKSH_LOCKS_LOCK_FILE" "$(cat ${stdoutF})"
}

testSetLockFileStdErrDebugOldLock(){
  DEBUG=true
  MKSH_LOCKS_LOCK_MAX_TIME=0
  set_lock_file
  sleep 1  
  set_lock_file >${stdoutF} 2>${stderrF}
  rtrn=$?
  assertEquals "Nieoczekiwany komunikat na stderr" "" "$(cat ${stderrF})"
}

testSetLockFileNew(){
  set_lock_file >${stdoutF} 2>${stderrF}
  rtrn=$?
  assertSame "Funkcja powinna zakończyć się odpowiednim kodem błędu" 0 $rtrn
}

testSetLockExists(){
  set_lock_file
  set_lock_file >${stdoutF} 2>${stderrF}
  rtrn=$?
  assertSame "Funkcja powinna zakończyć się odpowiednim kodem błędu" 1 $rtrn
}

testSetLockFileTestExists(){
  set_lock_file >${stdoutF} 2>${stderrF}
  rtrn=$?
  assertTrue "Plik lock nie istnieje" "[ -f $MKSH_LOCKS_LOCK_DIR/$MKSH_LOCKS_LOCK_FILE ]"
}

testDelLockFileStdErrDebug(){
  DEBUG=true
  set_lock_file
  del_lock_file >${stdoutF} 2>${stderrF}
  rtrn=$?
  assertTrue "Plik lock nie istnieje" "[ ! -f $MKSH_LOCKS_LOCK_DIR/$MKSH_LOCKS_LOCK_FILE ]"
}

testDelLockFileNotExistingStdOutDebug(){
  DEBUG=true
  del_lock_file >${stdoutF} 2>${stderrF}
  rtrn=$?
  assertEquals "Nieoczekiwany komunikat na stderr" "DEBUG: Plik lock ${MKSH_LOCKS_LOCK_DIR}/${MKSH_LOCKS_LOCK_FILE} nie istnieje." "$(cat ${stdoutF})"
}

testDelLockFileNotExistingStdErrDebug(){
  DEBUG=true
  del_lock_file >${stdoutF} 2>${stderrF}
  rtrn=$?
  assertEquals "Nieoczekiwany komunikat na stderr" "" "$(cat ${stderrF})"
}

testCheckLockDebugTrue(){
  DEBUG=true
  set_lock_file 
  check_lock_file >${stdoutF} 2>${stderrF}
  rtrn=$?
  assertEquals "Nieoczekiwany kod błędu" "1" "$rtrn"
  assertEquals "Nieoczekiwany komunikat na stdout" "DEBUG: Znalazłem plik lock ${MKSH_LOCKS_LOCK_DIR}/${MKSH_LOCKS_LOCK_FILE}" "$(cat ${stdoutF})"
  assertEquals "Nieoczekiwany komunikat na stderr" "" "$(cat ${stderrF})"
  del_lock_file
  check_lock_file >${stdoutF} 2>${stderrF}
  rtrn=$?
  assertEquals "Nieoczekiwany kod błędu" "0" "$rtrn"
  assertEquals "Nieoczekiwany komunikat na stdout" "" "$(cat ${stdoutF})"
  assertEquals "Nieoczekiwany komunikat na stderr" "" "$(cat ${stderrF})"  
}
testCheckLockDebugFalse(){
  DEBUG=false
  set_lock_file 
  check_lock_file >${stdoutF} 2>${stderrF}
  rtrn=$?
  assertEquals "Nieoczekiwany kod błędu" "1" "$rtrn"
  assertEquals "Nieoczekiwany komunikat na stdout" "" "$(cat ${stdoutF})"
  assertEquals "Nieoczekiwany komunikat na stderr" "" "$(cat ${stderrF})"
  del_lock_file
  check_lock_file >${stdoutF} 2>${stderrF}
  rtrn=$?
  assertEquals "Nieoczekiwany kod błędu" "0" "$rtrn"
  assertEquals "Nieoczekiwany komunikat na stdout" "" "$(cat ${stdoutF})"
  assertEquals "Nieoczekiwany komunikat na stderr" "" "$(cat ${stderrF})"  
}

#-----------------------------------------------------------------------------
# suite functions
#

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
	MKSH_LOG_THIS_SCRIPT_NAME=locks_test
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
