#!/usr/bin/env ruby
# coding: utf-8

require '../Common.rb'

x = 0
p Common.isset(x)
p Common.isnull(x)
x = nil
p Common.isset(x)
p Common.isnull(x)

Common.esc_print("blue", "Done.")

