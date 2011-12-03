#!/bin/sh

if [ ! $(gem --version | grep 1.7) ] 
then
    cd /tmp
    wget http://production.cf.rubygems.org/rubygems/rubygems-1.7.2.tgz
    tar zxf rubygems-1.7.2.tgz
    cd rubygems-1.7.2
    sudo ruby setup.rb --no-format-executable
fi
