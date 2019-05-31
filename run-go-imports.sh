#!/usr/bin/env bash

set -euo pipefail

# THanks to Kshitiz Sharma
# 
# https://stackoverflow.com/questions/3578584/bash-how-to-delete-elements-from-an-array-based-on-a-pattern
filter_arr() {  
    arr=($@)
    arr=(${arr[@]:1})
    dirs=($(for i in ${arr[@]}
        do echo $i
    done | grep -v $1))
    echo ${dirs[@]}
}

goimports -l -w $(filter_arr "vendor/" $@)