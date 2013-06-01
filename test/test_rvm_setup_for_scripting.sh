#!/bin/bash




check_rvm()
{
    # we need to load this up
    source ~/.profile

    # make sure rvm is loaded correctly
    if [[ `type rvm | head -1`  =~ function ]]
    then
        echo rvm is a function ... ok
    else
        echo ERROR: RVM is not a function
        echo `type rvm | head -1`
        exit 5
    fi

    # check to see that we have a ruby 1.9 on the system
    rvm_num_rubies=$(rvm list | grep ruby-1.9.3 | wc -l)
    if [[ $rvm_num_rubies -gt 0 ]]
    then
        echo rvm has num rubies ... ok
    else
        echo ERROR: RVM is does not have a 1.9.3 ruby
        exit 5
    fi


    # check that we have a 1.9 rvm alias
    # todo this probably should be different...
    # script-1.9?
    rvm_alias_show_output=$()
    if [[ `rvm alias show 1.9` =~ Unknown ]]
    then
        echo ERROR: RVM does not have a 1.9 alias
        exit 5
    else
        echo rvm has 1.9 alias... ok
    fi
}


check_rvm_for_scripting()
{
    # make sure rvm is loaded correctly
    if [[ -n `which rvm` ]]
    then
        echo rvm command in path... ok
    else
        echo ERROR: RVM is not in path
        exit 5
    fi

    # check to see that we have a ruby 1.9 on the system
    rvm_num_rubies=$(rvm list | grep ruby-1.9.3 | wc -l)
    if [[ $rvm_num_rubies -gt 0 ]]
    then
        echo rvm has ruby 1.9.3... ok
    else
        echo ERROR: RVM is does not have a 1.9.3 ruby
        exit 5
    fi


    # check that we have a 1.9 rvm alias
    # todo this probably should be different...
    # script-1.9?
    rvm_alias_show_output=$()
    if [[ `rvm alias show 1.9` =~ Unknown ]]
    then
        echo ERROR: RVM does not have a 1.9 alias
        exit 5
    else
        echo rvm has 1.9 alias... ok
    fi
}


#check_rvm
check_rvm_for_scripting
