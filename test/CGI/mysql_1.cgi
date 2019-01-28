#!/usr/bin/env ruby
#  MySQL の利用例
require "./WebPage.rb"
require "./MySQL.rb"

TEMPLATE = "templates/mysql_1.html"


# MySQL_1 ページ
class MySQL_1 < WebPage
  # コンストラクタ
  def initialize(template)
    super(template)
    showData()
  end

  private
  def showData()
    content = ""
    client = MySQL.new(@conf['uid'], @conf['pwd'], @conf['db'])
    rows =client.query("SELECT * FROM m_tables")
    rows.each {|row|
      content << table_row(row)
    }
    @vars['content'] = content
  end
end

# 応答を返す。
page = MySQL_1.new(TEMPLATE)
page.echo()
