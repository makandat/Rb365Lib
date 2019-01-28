#!/usr/bin/env ruby
#  複素数の極形式変換 complex.cgi
require './WebPage.rb'

class MyPage < WebPage
  def initialize(template="")
    super(template)
    sz = getParam('complex')
    z = Complex(sz)
    pz = z.polar
    json = "[" + pz[0].to_s + "," + pz[1].to_s + "]"
    MyPage.sendJson(json)
  end
end

MyPage.new

