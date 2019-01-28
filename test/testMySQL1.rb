#!/usr/bin/env ruby
#  MySQL クラスのテスト query
require "../MySQL.rb"

# AppConf.ini の内容に基づいて接続する。
#mysql = MySQL.new('user', 'ust62kjy', 'user')
mysql = MySQL.new

puts mysql.userid
puts mysql.password
puts mysql.database
puts mysql.host

rows = mysql.query('SELECT * FROM YJFX_Asset')
if rows.nil? then
  puts "rows is null."
  exit 1
end

rows.each {|row|
  p row
}

puts "Done."
