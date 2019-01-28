#!/usr/bin/ruby
# coding: utf-8
#  readline のテスト: readline, to_bytes, from_bytes
require "../Common.rb"

Common.esc_print("cyan", "readline のテスト")
s = Common.readline('> ')
p s

Common.esc_print("cyan", "to_bytes, from_bytes のテスト")
b = Common.to_bytes(s)
p b

p Common.from_bytes(b)

puts 'Done.'
