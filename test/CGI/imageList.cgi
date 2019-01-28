#!/usr/bin/env ruby
#  Binaries テーブルの画像リスト

require './WebPage.rb'
require './MySQL.rb'
require 'logger'


LOGFILE ="/home/user/log/imageList.log"
TEMPLATE = "./templates/imageList.html"


class BinImage < WebPage
  # コンストラクタ
  def initialize(template="")
    super(template)
    #@@logger = Logger.new(LOGFILE)
    #@@logger.info('BinImage class')
    if isPostback() then
      id = getParam('id')
      #@@logger.info('id=' + id)
      showData(id.to_i)
    else
      showData()
    end
  end

  private
  # テーブルのデータ一覧を表示
  def showData(id = -1)
    content = ""
    client = MySQL.new(@conf['uid'], @conf['pwd'], @conf['db'])
    rows = client.query("SELECT * FROM VW_Images")
    rows.each {|row|
      htrow = "<tr><td>"
      id2 = row['id'].to_s
      htrow << id2
      htrow << "</td><td><a href=\"imageList.cgi?id=#{id2}\">"
      htrow << (row['title'].to_s)
      htrow << "</a></td><td>"
      htrow << (row['original'].nil? ? "" : row['original'].to_s)
      htrow << "</td><td>"
      htrow << (row['info'].nil? ? "" : row['info'].to_s)
      htrow << "</td><tr>\n"
      content << htrow
    }
    @vars['content'] = content
    # id が指定されていたら画像を表示する。
    if id < 0 then
      @vars['title'] = ""
      @vars['id'] = id.to_s
    else
      @vars['id'] = id.to_s
      #@@logger.info(@vars['id'])
      @vars['title'] = client.getValue("SELECT title FROM VW_Images WHERE id=" + id.to_s)
      #@@logger.info(@vars['title'])
    end
  end
end

p = BinImage.new(TEMPLATE)
p.echo
