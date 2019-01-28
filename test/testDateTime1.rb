#!/usr/bin/env ruby
#  DateTime クラスのテスト: コンストラクタとtoString() 系

require "../DateTime.rb"

#dtime = DateTime1.new()
dtime = DateTime1.new('1999-01-01 23:00:01')
puts dtime.toString()
puts dtime.toDateString()
puts dtime.toTimeString()
