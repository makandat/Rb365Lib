#!/usr/bin/env ruby
# coding: utf-8

require '../Common.rb'

puts Common.get_env('RUBYLIB').nil? ? 'nil' : Common.get_env('RUBYLIB')

puts Common.get_env('RUBYPATH').nil? ? 'nil' : Common.get_env('RUBYPATH')
puts Common.get_env('RUBYOPT').nil? ? 'nil' : Common.get_env('RUBYOPT')


s = Common.shell('ls /')
puts s

Common.esc_print('cyan', 'Done.')

