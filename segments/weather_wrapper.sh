#! /usr/bin/env bash
if [[ -s $HOME/.rvm/scripts/rvm ]]; then
  source $HOME/.rvm/scripts/rvm
fi
cd `dirname $0`
rvm 1.9.3 do bundle exec $PWD/weather_openweathermap.rb
