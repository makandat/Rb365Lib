#!/usr/bin/env python3
#  華氏温度と摂氏温度変換 fahren.cgi
require './WebPage.rb'

class MyPage < WebPage
  def initialize(template)
    super(template)
    t = getParam('text1').to_f
    fahren = getParam('temp')
    if fahren == 'F' then
      # 華氏温度へ
      ct = 9.0 * t / 5.0 + 32.0
    else
      # 摂氏温度へ
      ct = 5.0 * (t - 32.0) / 9.0
    end
    MyPage.sendText(ct.to_s)
  end

MyPage.new

