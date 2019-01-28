#!/usr/bin/env ruby
#  MySQL クラスのテスト execute, getValue
require "../MySQL.rb"

# AppConf.ini の内容に基づいて接続する。
#mysql = MySQL.new('user', 'ust62kjy', 'user')
mysql = MySQL.new

stmt = mysql.getStatement("SELECT code, color FROM colors ORDER BY code")
result = stmt.execute
result.each {|row|
  puts row
}
mysql.closeStatement()
puts "Done."
