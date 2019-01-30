# coding: utf-8
=begin

  MySQL.rb MySQL クラス
     Ver. 1.01  2019-01-30

=end

require 'mysql2'

# 構成ファイル
APPCONF = 'AppConf.ini'


# MySQL クラス
class MySQL

  attr_accessor :userid, :password, :database, :host

  # コンストラクタ
  def initialize(uid=nil, pwd=nil, db=nil, host='localhost')
    # 接続パラメータ
    @userid = uid
    @password = pwd
    @database = db
    @host = host

    # パラメータの指定なし？
    if uid.nil? then
      # AppConf.ini を読み込む。
      File.open(APPCONF, "r") {|f|
        f.each_line {|line|
          line.strip!
          if line[0] == '#' or line[0] == '[' then
            next
          else
            ps = line.split('=')
            if ps.size() == 2 then
              key = ps[0].strip
              value = ps[1].strip
              @userid = key == 'uid' ? ps[1] : @userid
              @password = key == 'pwd' ? ps[1] : @password
              @database = key == 'db' ? ps[1] : @database
              @host = key == 'host' ? ps[1] : @host
            end
          end
        }
      }
    end
    # サーバに接続する。
    @client = Mysql2::Client.new(:host => @host, :username => @userid, :password => @password, :database => @database)
  end

  # Statement を得る。
  def getStatement(sql)
    @stmt = @client.prepare(sql)
  end

  # Statement を閉じる。
  def closeStatement()
    @stmt.close()
  end

  # クエリー結果をEnumerableとして返す。
  def query(sql)
    @client.query(sql)
  end

  # 結果セットを返さないクエリーを行う。(コマンドを実行する)
  # result : false(OK) or true(NG)
  def execute(sql)
    @client.query(sql)
  end

  # 値を1つだけ返すクエリーを実行し、１つの値を返す。
  def getValue(sql)
    result = @client.query(sql)
    if result.count > 0 then
      f = result.fields[0]
      result.each {|row| return row[f]}
    else
      nil
    end
  end

end # module
