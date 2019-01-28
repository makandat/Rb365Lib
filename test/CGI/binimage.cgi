#!/usr/bin/env ruby
#  Binaries テーブルの画像データを返す。
require './WebPage.rb'
require './MySQL.rb'
require 'logger'

LOGFILE = '/home/user/log/ruby.log'
APPCONF = "AppConf.ini"

class BinariesImage < WebPage

  # コンストラクタ
  def initialize(template="")
    super(template)
    #@@logger = Logger.new(LOGFILE)
    client = MySQL.new(@conf['uid'], @conf['pwd'], @conf['db'])
    #@@logger.info('initialize ' + @conf['uid'] + "," + @conf['db'])
    id = getParam('id')
    header(id, client)
    #@@logger.info(@headers[0])
    readBindata(id, client)
  end


  private
  # HTTPヘッダを設定する。
  def header(id, client)
    @headers = Array.new
    sql = "SELECT datatype FROM Binaries WHERE id=" + id.to_s
    datatype = client.getValue(sql)
    if datatype == '.jpg' then
      @headers.push("Content-Type: image/jpeg")
    elsif datatype == ".png" then
      @headers.push("Content-Type: image/png")
    else
      @headers.push("Content-Type: image/gif")
    end
  end

  # Binaries テーブルから id で指定される画像データを得る。
  def readBindata(id, client)
    sql = "SELECT hex(data) AS hdata FROM Binaries WHERE id=" + id.to_s
    rows = client.query(sql)
    row = rows.first
    hdata = row['hdata']
    n = hdata.size() / 2 - 1
    #@@logger.info(n.to_s)
    for i in 0..n
      sb = hdata[2*i, 2]
      hx = sb.hex
      @binbuff.push(hx)
      #@@logger.info("%02x" % hx)
    end
  end
end


p = BinariesImage.new()
p.echo()
