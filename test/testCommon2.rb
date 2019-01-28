#!/usr/bin/ruby
# coding: utf-8

require '../Common.rb'

LOGFILE = Common.is_windows() ? 'C:\temp\rubylogger.log' : '/home/user/temp/rubylogger.log'

puts "ログファイル：" + LOGFILE
Common.init_log(LOGFILE)
Common.log('Start log')
Common.error('エラーです。')
Common.log('ログを終了します。')

Common.esc_print('yellow', 'Done.')
if Common.is_windows() then
  Common.exec('type ' + LOGFILE)
else
  Common.exec('cat ' + LOGFILE)
end

