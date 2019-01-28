#!/usr/bin/env ruby
# coding: utf-8
#   テキストファイルの読み込みと書き込み
require "../Common.rb"
require "../FileSystem.rb"


if Common.count_args() == 0 then
  Common.stop(9, "ファイルのパス名を指定してください。")
end

filePath = Common.args[0]

# Windows の場合はファイルの文字コードは Shift_JIS とみなす。
s1 = ""
if Common.is_windows() then
  s1 = FileSystem.readAllText(filePath, "cp932")
else
  s1 = FileSystem.readAllText(filePath)
end

# ファイル内容を表示する。
puts s1


a = Common.readline('continue?')
if a == 'n' then
  Common.stop(9, "aborted.")
end

# readAllLines のテスト
if Common.is_windows() then
  FileSystem.readAllLines(filePath, "cp932") {|line|
    Common.esc_print("green", line)
  }
else
  FileSystem.readAllLines(filePath) {|line| puts line}
end

puts "Done."
