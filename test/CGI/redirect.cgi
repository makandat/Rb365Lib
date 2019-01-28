#!/usr/bin/env ruby
# coding: utf-8
#  クッキー
require "./WebPage.rb"

TEMPLATE = "./templates/redirect.html"


#  ウェブページクラス
class RedirectPage < WebPage
  # コンストラクタ
  def initialize(template)
    super(template)
    if isPostback() then
      url = getParam('url')
      WebPage.redirect(url)
    else
      echo()
    end
  end
end

# 応答を返す。
RedirectPage.new(TEMPLATE)
# すでに応答を返しているので、echo は不要
# page.echo()
