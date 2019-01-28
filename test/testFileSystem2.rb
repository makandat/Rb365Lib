#!/usr/bin/ruby
# coding: utf-8
#  ファイルシステムのテスト (writeAllTexty)
require "../Common.rb"
require "../FileSystem.rb"


if Common.count_args() == 0 then
  Common.stop(9, "保存先のファイルを指定してください。")
end

filePath = Common.args()[0]
puts filePath

s = "testFileSystem2.rb\n"
s += Common.readline('> ')
s += "\nDone.\n"

if Common.is_windows() then
  FileSystem.writeAllText(filePath, s, false, "cp932")
else
  FileSystem.writeAllText(filePath, s, false, "utf-8")
end

puts 'Done.'

if Common.is_windows() then
  Common.exec("type " + filePath)
else
  Common.exec("cat " + filePath)
end
