#! /usr/local/bin/bash
update_period=600
if [[ -s $HOME/.rvm/scripts/rvm ]]; then
  source $HOME/.rvm/scripts/rvm
fi
cd `dirname $0`
rvm 1.9.3 do bundle exec $PWD/weather_auto.rb
