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

# _log_check_dir_exists

testLoadMkshModulesStdOutStdErr()
{
  source src/load_mksh.sh src >${stdoutF} 2>${stderrF}
  _ret_testLoadMkshModulesStdOut=0

  assertSame "Pojawiło się coś na stderr a nie powinno" "" "$(cat ${stderrF})"
  _ret_testLoadMkshModulesStdOut=$?
  if [ $_ret_testLoadMkshModulesStdOut -ne 0 ]
    then 
      testSkipping=true
      return ${_ret_testLoadMkshModulesStdOut}
  fi

  assertSame "Pojawiło się coś na stdout a nie powinno" "" "$(cat ${stdoutF})"
  _ret_testLoadMkshModulesStdOut=$?
  if [ $_ret_testLoadMkshModulesStdOut -ne 0 ]
    then 
      testSkipping=true
      return ${_ret_testLoadMkshModulesStdOut}
  fi 
}

testLoadMkshModulesErrorCode()
{
  if [ $testSkipping = true ]
    then
      startSkipping
  fi
  src/load_mksh.sh src >${stdoutF} 2>${stderrF}
  rtrn=$?
  assertSame "Ładowanie programu zwróciło $rtrn" 0 $rtrn
}

testSampleTestCheckNoSoftLogDirMsg(){
  if [ $testSkipping = true ]
    then
      startSkipping
  fi
  rmdir ${MKSH_LOG_FILE%/*}
  _logging_check_dir_exists >${stdoutF} 2>${stderrF}
  rtrn=$?
  assertEquals "Brak obsługi nieistniejącego katalogu z logami" \
                  "Błąd funkcji log. Brak katalogu ${MKSH_LOG_FILE%/*}" \
                  "$(cat ${stderrF})"
}

testSampleTestCheckNoSoftLogDirErrCode(){
  if [ $testSkipping = true ]
    then
      startSkipping
  fi
  rmdir ${MKSH_LOG_FILE%/*}
  _logging_check_dir_exists >${stdoutF} 2>${stderrF}
  rtrn=$?
  assertSame "Funkcja powinna zakończyć się odpowiednim kodem błędu" 7 $rtrn
}

# log()
testSampleTestNormalLoggingErrCode()
{
  if [ $testSkipping = true ]
    then
      startSkipping
  fi
  log Testowy ciag znakow >${stdoutF} 2>${stderrF}
  rtrn=$?
  assertSame "Funkcja zwróciła kod błędu $rtrn" 0 $rtrn
}

testSampleTestNormalLoggingLogFileExists()
{
  if [ $testSkipping = true ]
    then
      startSkipping
  fi
  log Testowy ciag znakow >${stdoutF} 2>${stderrF}
  assertTrue "Plik logu nie istnieje" "[ -f $MKSH_LOG_FILE ]"
}

testSampleTestNormalLoggingLogFileNotEmpty()
{
  if [ $testSkipping = true ]
    then
      startSkipping
  fi
  log Testowy ciag znakow >${stdoutF} 2>${stderrF}
  assertTrue "Plik logu jest pusty" "[ -s $MKSH_LOG_FILE ]"
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
  testSkipping=false
	outputDir="${SHUNIT_TMPDIR}/output"
	mkdir "${outputDir}"
	stdoutF="${outputDir}/stdout"
	stderrF="${outputDir}/stderr"
	testDir="${SHUNIT_TMPDIR}/logs_test_dir"
	mkdir "${testDir}"
}

setUp()
{
	MKSH_LOG_FILE=${testDir}/var/log/test.log
        mkdir -p ${MKSH_LOG_FILE%/*}
	APPLY_USER=www-data
	APPLY_GROUP=www-data
	THIS_SCRIPT_NAME=logs_test
}

tearDown()
{
  rm -fr "${testDir}"
}

# load and run shUnit2
[ -n "${ZSH_VERSION:-}" ] && SHUNIT_PARENT=$0
#. ../src/shunit2
. test/shunit2-2.1.6/src/shunit2
