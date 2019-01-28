#!/usr/bin/env ruby
#  DateTime クラスのテスト: add.., now, utc

require "../DateTime.rb"

puts 'JST'
cur = DateTime1.now
p cur
p cur.year
p cur.month
p cur.day


puts 'UTC'
utc = DateTime1.utc
p utc
p utc.hour
p utc.min
p utc.sec


puts 'add'
dt = DateTime1.new
nd = dt.addDays(1)
p nd.day
nm = dt.addSeconds(60*5)
p nm.min
