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
testStdinLoggingNounsetChange1()
{
  _set=`printNounset`
  set -u
  echo Testowy ciag znakow >${stdoutF} 2>${stderrF}
  assertSame "Komunikat na stdout jest inny niż oczekiwano" "set -u" "$(printNounset)"
  $_set
}

testStdinLoggingNounsetChange2()
{
  _set=`printNounset`
  set +u
  echo Testowy ciag znakow >${stdoutF} 2>${stderrF}
  assertSame "Komunikat na stdout jest inny niż oczekiwano" "set +u" "$(printNounset)"
  $_set
}

testPrintNounsetOn(){
  _set=`printNounset`
  set -u
  print_nounset >${stdoutF} 2>${stderrF}
  assertSame "Komunikat na stdout jest inny niż oczekiwano" "set -u" "$(cat ${stdoutF})"
  $_set
}

testPrintNounsetOff(){
  _set=`printNounset`
  set +u
  print_nounset >${stdoutF} 2>${stderrF}
  assertSame "Komunikat na stdout jest inny niż oczekiwano" "set +u" "$(cat ${stdoutF})"
  $_set
}

testIsFunctionErrCode1()
{
  is_function nieistnieje >${stdoutF} 2>${stderrF}
  rtrn=$?
  assertSame "Funkcja zwróciła kod błędu $rtrn" 1 $rtrn
}

testIsFunctionErrCode2()
{

  is_function testIsFunctionErrCode1 >${stdoutF} 2>${stderrF}
  rtrn=$?
  assertSame "Funkcja zwróciła kod błędu $rtrn" 0 $rtrn
}

testIsFunctionStdOut1(){
  is_function nieistnieje >${stdoutF} 2>${stderrF}
  assertSame "Komunikat na stdout jest inny niż oczekiwano" "Brak funkcji nieistnieje()" "$(cat ${stdoutF})"
}


testIsFunctionStdOut1(){
  is_function testIsFunctionErrCode1 >${stdoutF} 2>${stderrF}
  assertSame "Komunikat na stdout jest inny niż oczekiwano" "" "$(cat ${stdoutF})"
}

testIsFunctionStdErr1(){
  is_function nieistnieje >${stdoutF} 2>${stderrF}
  assertSame "Komunikat na stdout jest inny niż oczekiwano" "" "$(cat ${stderrF})"
}


testIsFunctionStdErr2(){
  is_function testIsFunctionErrCode1 >${stdoutF} 2>${stderrF}
  assertSame "Komunikat na stdout jest inny niż oczekiwano" "" "$(cat ${stderrF})"
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
	testDir="${SHUNIT_TMPDIR}/logs_test_dir"
	mkdir "${testDir}"
}

setUp()
{
	SOFT_LOG_DIR=${testDir}/var/log/
  mkdir -p $SOFT_LOG_DIR
	LOG_FILENAME1=test.log
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