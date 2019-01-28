#!/usr/bin/env ruby
# coding: utf-8
#  フォーム (1)
require "./WebPage.rb"

TEMPLATE = "./templates/form_1.html"


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
    @vars['message'] = "日付: " + getParam('date') + ", 金額:" + getParam('money')
  end
end

# 応答を返す。
page = Form1.new(TEMPLATE)
page.echo()
