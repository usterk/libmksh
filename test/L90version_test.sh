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

testStdOutVersion1()
{
  mksh_print_version >${stdoutF} 2>${stderrF}
  cat "${stdoutF}" | grep -q 'Wersja: [0-9]\+.[0-9]\+.[0-9]\+'
  _retr=$?
  assertSame "Komunikat na stdout `cat ${stdoutF}` jest inny niż oczekiwano" "0" "$_retr"
}

testStdOutVersion2()
{
  mksh_print_version >${stdoutF} 2>${stderrF}
  _retr=$(wc -l < "${stdoutF}"|awk '{print $1}')
  assertSame "Ilosc linii na wyjsciu jest inna niz oczekiwano" "1" "$_retr"
}

testStdOutVersion3()
{
  _load_mksh_list_dir=${testDir}
  echo 6.5.3 > ${testDir}/VERSION
  mksh_print_version >${stdoutF} 2>${stderrF}
  _retr=$(cat "${stdoutF}")
  assertSame "Ilosc linii na wyjsciu jest inna niz oczekiwano" "Wersja: 6.5.3" "$_retr"
}

testStdErrVersion1()
{
  mksh_print_version >${stdoutF} 2>${stderrF}
  assertSame "Wyjscie na stderr jest inne niz pczekiwano" "$(cat ${stderrF})" ""
}

testCheckVersion1()
{
  _load_mksh_list_dir=${testDir}
  echo 2.0.0 > ${testDir}/VERSION
  _retr=$?
  assertSame "Kod wyjscia inny niz oczekiwano $(cat ${stdoutF})" "0" "$_retr"
}

testCheckVersion2()
{
  _load_mksh_list_dir=${testDir}
  echo 2.0.0 > ${testDir}/VERSION
  mksh_check_version 2.1.0 >${stdoutF} 2>${stderrF}
  _retr=$?
  assertSame "Kod wyjscia inny niz oczekiwano $(cat ${stdoutF})" "1" "$_retr"
}

testCheckVersion3()
{
  _load_mksh_list_dir=${testDir}
  echo 2.0.0 > ${testDir}/VERSION
  mksh_check_version 1.0.0 >${stdoutF} 2>${stderrF}
  _retr=$?
  assertSame "Kod wyjscia inny niz oczekiwano $(cat ${stdoutF})" "0" "$_retr"
}

testCheckVersion4()
{
  _load_mksh_list_dir=${testDir}
  echo 2.0.0 > ${testDir}/VERSION
  mksh_check_version 1.asd0.0 >${stdoutF} 2>${stderrF}
  _retr=$?
  assertSame "Kod wyjscia inny niz oczekiwano $(cat ${stdoutF})" "2" "$_retr"
}

testCheckVersion5()
{
  _load_mksh_list_dir=${testDir}
  echo 0.0.0 > ${testDir}/VERSION
  mksh_check_version 1.asd0.0 >${stdoutF} 2>${stderrF}
  _retr=$?
  assertSame "Kod wyjscia inny niz oczekiwano $(cat ${stdoutF})" "2" "$_retr"
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