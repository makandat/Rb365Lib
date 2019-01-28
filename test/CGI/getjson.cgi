#!/usr/bin/env ruby
# coding: utf-8
#  AJAX getjson
require "./WebPage.rb"

TEMPLATE = "./templates/getjson.html"


#  ウェブページクラス
class GetJSONPage < WebPage
  # コンストラクタ
  def initialize(template)
    super(template)
  end
end

# 応答を返す。
page = GetJSONPage.new(TEMPLATE)
page.echo()
