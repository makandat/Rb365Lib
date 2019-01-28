#!/usr/bin/ruby
# coding: utf-8
#  ファイルシステムのテスト (Binary file)
require "../Common.rb"
require "../FileSystem.rb"


if Common.count_args() == 0 then
  Common.stop(9, "保存先のファイルを指定してください。")
end

filePath = Common.args()[0]
puts filePath

buff = [48, 49, 50, 51, 52]

FileSystem.writeBinary(filePath, buff)

rbuff = FileSystem.readBinary(filePath)
rbuff.each {|b| print "%#d" % b}
puts

FileSystem.readBytes(filePath) {|b|
  print "%#d" % b
}
puts "\nDone."
