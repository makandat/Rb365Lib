#!/usr/bin/env ruby
#  動的なHTML要素
require "./WebPage.rb"

TEMPLATE = "./templates/dynamicVars.html"


#  ウェブページクラス
class DynVars < WebPage
  # コンストラクタ
  def initialize(template)
    super(template)
    @vars['template'] = template
    @vars['host'] = @conf['host']
    @vars['uid'] = @conf['uid']
    @vars['pwd'] = @conf['pwd']
    @vars['db'] = @conf['db']
  end

end

# 応答を返す。
page = DynVars.new(TEMPLATE)
page.echo()
