#! /usr/bin/env bash
file_name=$1
./beautifier.pl $1 > $1"_b" && mv $1"_b" $1

