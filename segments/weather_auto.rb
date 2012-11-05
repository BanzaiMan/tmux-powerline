#! /usr/bin/env ruby
# encoding: utf-8

require 'geoip'
require 'nokogiri'
require 'open-uri'

unit='f' # or 'c'

# see comments at the bottom for description
ICONS=%w(
  ⚠
  ⚠
  ⚠
  ⚡
  ⚡

  ☃
  ☃
  ☃
  ☂
  ☂

  ☂
  ☂
  ☂
  ☃
  ☃

  ☃
  ☃
  ☃
  ☃
  ☁

  🌁
  🌁
  🌁
  ⚐
  ⚐

  ☁
  ☁
  ☁
  ☁
  ☁

  ☁
  🌙
  ☀
  🌙
  ☀

  ☔
  ☀
  ☈
  ☈
  ☈

  ☔
  ⛄
  ⛄
  ⛄
  ⛅

  ☔
  ☔
  ☔
  ⛄
)

code=0
temp='?'

begin
  ip = open('http://whatismyip.akamai.com/').read
  db = GeoIP::City.new '/usr/local/share/GeoIP/GeoLiteCity.dat'
  geo = db.look_up ip
  doc = Nokogiri::XML(open("http://where.yahooapis.com/geocode?q=#{geo[:latitude]},#{geo[:longitude]}&gflags=R$"))
  woeid = doc.xpath('//Result/woeid').first.text

  data = Nokogiri::XML(open("http://weather.yahooapis.com/forecastrss?w=#{woeid}&u=#{unit}"))
  condition = data.xpath('//yweather:condition').first
  temp = condition.attributes["temp"].value
  code = condition.attributes["code"].value.to_i

rescue
end

puts "#{ICONS[code]} #{temp}°#{unit.upcase}"

#Code Description
#0  tornado
#1  tropical storm
#2  hurricane
#3  severe thunderstorms
#4  thunderstorms
#5  mixed rain and snow
#6  mixed rain and sleet
#7  mixed snow and sleet
#8  freezing drizzle
#9  drizzle
#10 freezing rain
#11 showers
#12 showers
#13 snow flurries
#14 light snow showers
#15 blowing snow
#16 snow
#17 hail
#18 sleet
#19 dust
#20 foggy
#21 haze
#22 smoky
#23 blustery
#24 windy
#25 cold
#26 cloudy
#27 mostly cloudy (night)
#28 mostly cloudy (day)
#29 partly cloudy (night)
#30 partly cloudy (day)
#31 clear (night)
#32 sunny
#33 fair (night)
#34 fair (day)
#35 mixed rain and hail
#36 hot
#37 isolated thunderstorms
#38 scattered thunderstorms
#39 scattered thunderstorms
#40 scattered showers
#41 heavy snow
#42 scattered snow showers
#43 heavy snow
#44 partly cloudy
#45 thundershowers
#46 snow showers
#47 isolated thundershowers
#3200 not available
