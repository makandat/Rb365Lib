#!/usr/bin/env ruby
#  MySQL クラスのテスト execute, getValue
require "../MySQL.rb"

# AppConf.ini の内容に基づいて接続する。
#mysql = MySQL.new('user', 'ust62kjy', 'user')
mysql = MySQL.new

puts mysql.userid
puts mysql.password
puts mysql.database
puts mysql.host

if mysql.execute("INSERT INTO colors(code, color) VALUES('faf0e6', 'Linen')") then
  puts "NG"
else
  puts "OK"
end

n = mysql.getValue("SELECT count(*) AS count FROM colors")
puts n.to_s

if mysql.execute("DELETE FROM colors WHERE color='Linen'") then
  puts "NG"
else
  puts "OK"
end

n = mysql.getValue("SELECT count(*) AS count FROM colors")
puts n.to_s


puts "Done."
