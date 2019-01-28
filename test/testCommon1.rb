#!/usr/bin/ruby
# coding: utf-8

require '../Common.rb'


if Common.count_args() == 0 then
  Common.stop(9, "No parameters.")
end


Common.args().each{|a| puts a}

Common.esc_print('yellow', 'Done.')
