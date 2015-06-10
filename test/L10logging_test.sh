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
# _logging_check_dir_exists
testCheckNoSoftLogDirMsg(){
  rmdir ${MKSH_LOG_FILE%/*}
  _logging_check_dir_exists >${stdoutF} 2>${stderrF}
  rtrn=$?
  assertEquals "Brak obsługi nieistniejącego katalogu z logami" \
                  "Błąd funkcji log. Brak katalogu ${MKSH_LOG_FILE%/*}" \
                  "$(cat ${stderrF})"
}

testCheckNoSoftLogDirErrCode(){
  rmdir ${MKSH_LOG_FILE%/*}
  _logging_check_dir_exists >${stdoutF} 2>${stderrF}
  rtrn=$?
  assertSame "Funkcja powinna zakończyć się odpowiednim kodem błędu" 7 $rtrn
}

# log()
testNormalLoggingErrCode()
{
  log Testowy ciag znakow >${stdoutF} 2>${stderrF}
  rtrn=$?
  assertSame "Funkcja zwróciła kod błędu $rtrn" 0 $rtrn
}

testNormalLoggingLogFileExists()
{
  log Testowy ciag znakow >${stdoutF} 2>${stderrF}
  assertTrue "Plik logu nie istnieje" "[ -f ${MKSH_LOG_FILE} ]"
}

testNormalLoggingLogFileNotEmpty()
{
  log Testowy ciag znakow >${stdoutF} 2>${stderrF}
  assertTrue "Plik logu jest pusty" "[ -s $MKSH_LOG_FILE ]"
}

testNormalLoggingLogFileContent()
{
  log Testowy ciag znakow >${stdoutF} 2>${stderrF}
  grep -q "[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\} [0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\} ${MKSH_LOG_THIS_SCRIPT_NAME}: Testowy ciag znakow" $MKSH_LOG_FILE
  rtrn=$?
  assertSame "Wpis w pliku z logami różny z zamierzonym" 0 $rtrn
}

testNormalLoggingStdoutMsg1()
{
  log Testowy ciag znakow >${stdoutF} 2>${stderrF}
  assertSame "Komunikat na stdout jest inny niż oczekiwano" "Testowy ciag znakow" "$(cat ${stdoutF})"
}

testNormalLoggingStdoutMsg2()
{
  log "logujemy | wc -l" >${stdoutF} 2>${stderrF}
  assertSame "Komunikat na stdout jest inny niż oczekiwano" "logujemy | wc -l" "$(cat ${stdoutF})"
}

testNormalLoggingStdoutMsg3()
{
  log "logujemy " "| wc -l" >${stdoutF} 2>${stderrF}
  assertSame "Komunikat na stdout jest inny niż oczekiwano" "logujemy | wc -l" "$(cat ${stdoutF})"
}

testNormalLoggingStdoutMsg4()
{
  ZMIENNA_ASD=TEST
  log "logujemy ;" "ps aux" '$ZMIENNA_ASD' >${stdoutF} 2>${stderrF}
  assertSame "Komunikat na stdout jest inny niż oczekiwano" "logujemy ; ps aux \$ZMIENNA_ASD" "$(cat ${stdoutF})"
}

testNormalLoggingStderrMsg()
{
  log Testowy ciag znakow >${stdoutF} 2>${stderrF}
  touch ${stderrF}.chown.err
  if [ "`whoami`" != "root" ]
    then
      grep -v chown ${stderrF} > ${stderrF}.chown.err
  fi
  assertFalse "Pojawił się komunikat na stderr: `cat ${stderrF}.chown.err`" "[ -s '${stderrF}.chown.err' ]"
}

#stdin_log()
testStdinLoggingErrCode()
{
  echo Testowy ciag znakow | stdin_log >${stdoutF} 2>${stderrF}
  rtrn=$?
  assertSame "Funkcja zwróciła kod błędu $rtrn" 0 $rtrn
}

testStdinLoggingLogFileExists()
{
  echo Testowy ciag znakow | stdin_log >${stdoutF} 2>${stderrF}
  assertTrue "Plik logu nie istnieje" "[ -f $MKSH_LOG_FILE ]"
}

testStdinLoggingLogFileNotEmpty()
{
  echo Testowy ciag znakow | stdin_log >${stdoutF} 2>${stderrF}
  assertTrue "Plik logu jest pusty" "[ -s $MKSH_LOG_FILE ]"
}

testStdinLoggingLogFileContent()
{
  echo Testowy ciag znakow | stdin_log >${stdoutF} 2>${stderrF}
  grep -q "[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\} [0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\} ${MKSH_LOG_THIS_SCRIPT_NAME}: Testowy ciag znakow" $MKSH_LOG_FILE
  rtrn=$?
  assertSame "Wpis w pliku z logami różny z zamierzonym $(cat $MKSH_LOG_FILE)" 0 $rtrn
}

testStdinParamLoggingLogFileContent()
{
  echo Testowy ciag znakow | stdin_log test >${stdoutF} 2>${stderrF}
  grep -q "[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\} [0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\} ${MKSH_LOG_THIS_SCRIPT_NAME}(test): Testowy ciag znakow" $MKSH_LOG_FILE
  rtrn=$?
  assertSame "Wpis w pliku z logami różny z zamierzonym $(cat $MKSH_LOG_FILE)" 0 $rtrn
}

testStdinLoggingStdoutMsg()
{
  echo Testowy ciag znakow | stdin_log >${stdoutF} 2>${stderrF}
  assertSame "Komunikat na stdout jest inny niż oczekiwano" "Testowy ciag znakow" "$(cat ${stdoutF})"
}

testStdinParamLoggingStdoutMsg()
{
  echo Testowy ciag znakow | stdin_log test >${stdoutF} 2>${stderrF}
  assertSame "Komunikat na stdout jest inny niż oczekiwano" "(test): Testowy ciag znakow" "$(cat ${stdoutF})"
}

testStdinLoggingStderrMsg()
{
  echo Testowy ciag znakow | stdin_log >${stdoutF} 2>${stderrF}
  if [ "`whoami`" != "root" ]
    then
      grep -v chown ${stderrF} > ${stderrF}.chown.err
  fi
  assertFalse "Pojawił się komunikat na stderr: `cat ${stderrF}.chown.err`" "[ -s '${stderrF}.chown.err' ]"
}

testStdinLoggingNounsetChange1()
{
  _set=`printNounset`
  set -u
  echo Testowy ciag znakow | stdin_log test >${stdoutF} 2>${stderrF}
  assertSame "Komunikat na stdout jest inny niż oczekiwano" "set -u" "$(printNounset)"
  $_set
}

testStdinLoggingNounsetChange2()
{
  _set=`printNounset`
  set +u
  echo Testowy ciag znakow | stdin_log test >${stdoutF} 2>${stderrF}
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

#debug()
testNormalDebugFalseStdoutMsg()
{
  DEBUG=false
  debug Testowy ciag debug znakow >${stdoutF} 2>${stderrF}
  assertSame "Komunikat na stdout jest inny niż oczekiwano" "" "$(cat ${stdoutF})"
}

testNormalDebugTrueStdoutMsg()
{
  DEBUG=true
  debug Testowy ciag debug znakow >${stdoutF} 2>${stderrF}
  assertSame "Komunikat na stdout jest inny niż oczekiwano" "DEBUG: Testowy ciag debug znakow" "$(cat ${stdoutF})"
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
	testDir="${SHUNIT_TMPDIR}/MKSH_LOG_test_dir"
	mkdir "${testDir}"
}

setUp()
{
	MKSH_LOG_FILE=${testDir}/file.log
        mkdir -p ${MKSH_LOG_FILE%/*}
	MKSH_LOG_APPLY_USER=www-data
	APPLY_GROUP=www-data
	MKSH_LOG_THIS_SCRIPT_NAME=MKSH_LOG_test
}

tearDown()
{
  rm -fr "${testDir}"
}

# load and run shUnit2
[ -n "${ZSH_VERSION:-}" ] && SHUNIT_PARENT=$0
#. ../src/shunit2
. test/shunit2-2.1.6/src/shunit2
