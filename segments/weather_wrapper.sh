#! /usr/bin/env bash
if [[ -s $HOME/.rvm/scripts/rvm ]]; then
  source $HOME/.rvm/scripts/rvm
fi

tmp_file="${tp_tmpdir}/weather.txt"

if [ -f $tmp_file ]; then
  if [ "$PLATFORM" == 'mac' ]; then
    last_update=$(stat -f "%m" $tmp_file)
  else
    last_update=$(stat -c "%Y" $tmp_file)
  fi
  time_now=$(date +%s)
  update_period=900 #15 minutes
  
  up_to_date=$(echo "(${time_now}-${last_update}) < ${update_period}" | bc)
  if [ "$up_to_date" -eq 1 ]; then
    weather=$(cat ${tmp_file})
  fi
fi

if [ -z "$weather" ]; then
  cd `dirname $0`
  weather=$(rvm 1.9.3 do bundle exec $PWD/weather_openweathermap.rb)
  if [ "$?" -eq "0" ]; then
    echo "${weather}" > $tmp_file
  elif [ -f "${tmp_file}" ]; then
    weather=$(cat "${tmp_file}")
  fi
fi

if [ -n "$weather" ]; then
  echo "$weather"
fi
