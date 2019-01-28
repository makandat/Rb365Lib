#!/usr/bin/env ruby
# coding: utf-8
#  フォーム (1)
require "./WebPage.rb"

TEMPLATE = "./templates/form_2.html"


#  ウェブページクラス
class Form1 < WebPage
  # コンストラクタ
  def initialize(template)
    super(template)
    if isPostback() then
      showData()
    else
      @vars['message'] = ""
    end
  end

  private
  def showData()
    @vars['message'] = "check1: " + getParam('check1') + ", radio:" + getParam('radio') + ", select:" + getParam('select')
  end
end

# 応答を返す。
page = Form1.new(TEMPLATE)
page.echo()
