#!/usr/bin/env ruby
#  Text モジュールのテスト: is..., to..., trim, chomp
require '../Text.rb'


puts "isdigit"
p Text.isdigit('1')
p Text.isdigit('.')

puts "isalpha"
p Text.isalpha('a')
p Text.isalpha('1')

puts "isdelim"
p Text.isdelim('a')
p Text.isdelim('/')

puts "isprint"
p Text.isprint('a')
p Text.isprint("\t")

puts "tolower"
p Text.tolower('aBcD')
puts "toupper"
p Text.toupper('aBcD')


p Text.trim("\ta = 100\r\n")
p Text.chomp("\ta = 100\r\n")
