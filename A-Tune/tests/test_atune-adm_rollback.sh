#!/bin/sh
# Copyright (c) 2019 Huawei Technologies Co., Ltd.
#
# A-Tune is licensed under the Mulan PSL v2.
# You can use this software according to the terms and conditions of the Mulan PSL v2.
# You may obtain a copy of Mulan PSL v2 at:
#     http://license.coscl.org.cn/MulanPSL2
# THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND, EITHER EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT, MERCHANTABILITY OR FIT FOR A PARTICULAR
# PURPOSE.
# See the Mulan PSL v2 for more details.
# Create: 2020-01-09
# Author: zhangtaibo <sonice1755@163.com>

export TCID="atune-adm rollback cmd test"

. ./test_lib.sh

init()
{
    echo "init the system"
    check_service_started atuned
}

cleanup()
{
    echo "===================="
    echo "Clean the System"
    echo "===================="
    rm -rf temp.log
}

test01()
{
    tst_resm TINFO "atune-adm rollback cmd test"
    # Check rollback function
    atune-adm rollback
    check_result $? 0

    # There is no activated profile
    atune-adm list > temp.log
    cat temp.log | awk -F '|' '{print $4}' | grep true
    check_result $? 1

    # Help info
    atune-adm rollback -h > temp.log
    grep "rollback the system config to the init state" temp.log
    check_result $? 0

    # Extra input
    atune-adm rollback extra_input > temp.log
    grep "Incorrect Usage." temp.log
    check_result $? 0

    if [ $EXIT_FLAG -ne 0 ];then
        tst_resm TFAIL
    else
        tst_resm TPASS
    fi
}

TST_CLEANUP=cleanup

init

test01

tst_exit
