#!/usr/bin/ruby
# coding: utf-8
#  Common モジュール: to_json, from_json

require '../Common.rb'

a = {'A'=>0, 'B'=>[1, 2, 3]}
t = Common.to_json(a)
p t

o = Common.from_json(t)
p o
