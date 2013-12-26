#! /usr/bin/env ruby
# encoding: utf-8

require 'open-uri'
require 'logger'
require 'json'

unit='c' # 'f' or 'c'
@verbose = ENV['DEBUG']
if @verbose
  @log = Logger.new(STDERR)
end

def debug(msg, level = Logger::INFO)
  return unless @log
  @log.add(level) { msg } if @verbose
end

class Float
  def to_c
    self - 273.15
  end

  def to_fahrenheit
    to_c * (9/5.0) + 32.0
  end
end

ICONS = [
  nil,
  nil,
  "☈",
  "☔",
  nil,
  "☂",
  "☃",
  "🌁",
  nil,
  "⚠"
]

CLEAR = {
  800 => "☀",
  801 => "⛅",
  802 => "☁",
  803 => "☁",
  804 => "☁"
}

code=900
temp='?'

begin
  lon, lat = `#{File.join(File.dirname(__FILE__), 'whereami')}`.chomp.split ','
  debug "latitude: #{lon} longitude: #{lat}"
  url = "http://openweathermap.org/data/2.5/weather?lat=#{lon}&lon=#{lat}&cnt=1".tap {|x| debug "URL: #{x}"}
  data = JSON.parse(open(url).read).tap {|x| debug "data: #{x}"}
  weather = data["weather"].first.tap {|x| debug "weather: #{x}"} # look at only the first set
  code = weather["id"]
  temp_k  = data["main"]["temp"] rescue 0 # in Kelvin
  temp = unit.upcase == 'F' ? temp_k.to_fahrenheit : temp_k.to_c

rescue => e
  debug e
  debug e.backtrace.to_s
end

icon = (code / 100 == 8) ? CLEAR[code] : ICONS[code / 100] rescue '?'


puts "#{icon} #{"%3.1f" % temp rescue '?'}°#{unit.upcase}"


# Codes: http://openweathermap.org/wiki/API/Weather_Condition_Codes
# 200  thunderstorm with light rain
# 201  thunderstorm with rain
# 202  thunderstorm with heavy rain
# 210  light thunderstorm
# 211  thunderstorm
# 212  heavy thunderstorm
# 221  ragged thunderstorm
# 230  thunderstorm with light drizzle
# 231  thunderstorm with drizzle
# 232  thunderstorm with heavy drizzle
#
# 300  light intensity drizzle
# 301  drizzle
# 302  heavy intensity drizzle
# 310  light intensity drizzle rain
# 311  drizzle rain
# 312  heavy intensity drizzle rain
# 321  shower drizzle
#
# 500  light rain
# 501  moderate rain
# 502  heavy intensity rain
# 503  very heavy rain
# 504  extreme rain
# 511  freezing rain
# 520  light intensity shower rain
# 521  shower rain
# 522  heavy intensity shower rain
#
# 600  light snow
# 601  snow
# 602  heavy snow
# 611  sleet
# 621  shower snow
#
# 701  mist
# 711  smoke
# 721  haze
# 731  Sand/Dust Whirls
# 741  Fog
#
# 800  sky is clear
# 801  few clouds
# 802  scattered clouds
# 803  broken clouds
# 804  overcast clouds
#
# 900  tornado
# 901  tropical storm
# 902  hurricane
# 903  cold
# 904  hot
# 905  windy
# 906  hail
