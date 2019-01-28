#!/usr/bin/env ruby
# coding: utf-8
#  AJAX gettext
require "./WebPage.rb"

TEMPLATE = "./templates/gettext.html"


#  ウェブページクラス
class GetTextPage < WebPage
  # コンストラクタ
  def initialize(template)
    super(template)
    @vars['message'] = ""
  end
end

# 応答を返す。
page = GetTextPage.new(TEMPLATE)
page.echo()
