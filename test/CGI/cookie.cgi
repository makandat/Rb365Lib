#!/usr/bin/env ruby
# coding: utf-8
#  クッキー
require "./WebPage.rb"

TEMPLATE = "./templates/cookie.html"


#  ウェブページクラス
class CookiePage < WebPage
  # コンストラクタ
  def initialize(template)
    super(template)
    if isCookie('count') then
      c = getCookie('count')
      n = c.to_i + 1
      setCookie('count', n.to_s)
      @vars['count'] = c.to_s
    else
      setCookie('count', '0')
      @vars['count'] = '0'
    end
  end
end

# 応答を返す。
page = CookiePage.new(TEMPLATE)
page.echo()
