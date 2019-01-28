# coding: utf-8
=begin

  WebPage.rb WebPage クラス
     Ver. 0.50

=end

require "cgi"
require "cgi/escape"
require "json"
require 'logger'


# 構成ファイル
APPCONF = "AppConf.ini"
CGILOG = "/home/user/log/RubyCGI.log"


# WebPage クラス
class WebPage

  attr_accessor :html, :binbuff, :conf, :headers, :params, :vars

  # コンストラクタ
  #   template: テンプレートファイル
  def initialize(template=nil)
    @@logger = Logger.new(CGILOG)
    @mime = ""              # MIME タイプ
    @html = ""              # テキストバッファ
    @binbuff = Array.new    # バイナリーデータバッファ
    @conf = Hash.new        # 構成ファイルの内容
    @params = Hash.new      # HTTP パラメータの連想配列
    @cookies = Hash.new     # HTTP クッキーの連想配列
    @headers = Array.new    # HTTP ヘッダーの配列
    @vars = Hash.new        # 埋め込み変数を初期化する。
    @cgi = CGI.new          # CGI を初期化
    # AppConf.ini ファイルを読み込んで @conf に格納する。
    if File.exists?(APPCONF) then
      readConf()
    end
    # HTTP パラメータを取得して @params に格納する。
    @params = @cgi.params
    # HTTP クッキーを取得して @cookies に格納する。
    @cookies = @cgi.cookies
    # HTTP ヘッダーの内容を定義する。
    setHeader(template)
    # template で指定されたファイルを読み込んで @html または @binbuff に格納する。
    if File.exists?(template) then
       loadFile(template)
    end
  end


  # 構成ファイルを読む。
  def readConf()
    # AppConf.ini を読み込む。
    File.open(APPCONF, "r") {|f|
      f.each_line {|line|
        line.strip!
        ps = line.split('=')
        if ps.size() == 2 then
          key = ps[0].strip
          value = ps[1].strip
          @conf[key] = value
        end
      }
    }
  end

  # 応答を返す。
  def echo()
    #@@logger.info('echo()')
    sendHeaders()
    if @mime.start_with?('text') or @mime.include?('xml') or @mime.include?('json') then
      @vars.each_key {|key|
        rep = "(*" + key + "*)"
        text = @vars[key]
        @html.gsub!(rep, text)
      }
      print @html
    else
      #@@logger.info('echo() binbuff')
      @binbuff.each {|b|
        #@@logger.info("%02x" % b)
        putc(b)
      }
    end
  end

  # パラメータを得る。キーが存在しない場合は "" を返す。
  def getParam(key)
    if @params.has_key?(key) then
       @params[key][0]
    else
       ""
    end
  end

  # キー key のパラメータの有無を返す。存在すれば true。
  def isParam(key)
    @cgi.params.has_key?(key)
  end

  # ポストバックか？
  def isPostback()
    @params.size() > 0
  end

  # クッキーがあるか？
  def isCookie(key)
    @cookies.has_key?(key)
  end

  # キー key、値 value であるクッキーを設定する。
  def setCookie(key, value)
    @headers.push(%"Set-Cookie: #{key}=#{value}")
  end

  # setCookie のシノニム
  def cookie(key, value)
    setCookie(key, value)
  end

  # キー key であるクッキーの値を得る。存在しない場合は "" を返す。
  def getCookie(key)
    if @cookies.has_key?(key) then
      @cookies[key][0]
    else
      ""
    end
  end

  # HTML タグを作成する。
  def tag(name, str)
  #  %"<#{name}>#{str}</#{name}>"
    t = "<" + name + ">"
    t += str.to_s  
    t += "</" + name + ">"
    return t
  end

  # HTML テーブル行を作成する。
  def table_row(row)
    line = "<tr>"
    if row.kind_of?(Array) then
      row.each {|c|
        line << tag('td', c)
      }
    else
       row.each_value {|v|
         line << tag('td', v)
       }
    end
    line << "</tr>"
  end

  # アップロードされた key で指定されるファイルを savedir というディレクトリに保存する。
  def saveFile(key, savedir)
    fileobj = @params[key][0]
    filename = savedir + '/' + fileobj.original_filename
    open(filename, "wb") do |f|
      f.binmode
      f.write fileobj.read
    end
  end

  # HTML の特殊文字をエスケープする。
  def escape(text)
    CGI.escapeHTML(text)
  end

  # 指定された画像ファイルを応答として返す。
  def self.sendImage(filePath)
    ext = File.extname(filePath).downcase
    if ext == ".jpg" then
      print "Content-Type: image/jpeg\n\n"
    elsif ext == ".png" then
      print "Content-Type: image/png\n\n"
    else
      print "Content-Type: image/gif\n\n"
    end
    open(filePath, "rb") {|f|
      f.binmode
      buff = f.read
      STDOUT.write buff
    }
  end

  # json で指定された JSON 文字列を応答として返す。
  def self.sendJson(json)
    print "Content-Type: application/json\n\n"
    print json
  end

  # text で指定されたプレーン文字列を応答として返す。
  def self.sendText(text)
    print "Content-Type: plain/text\n\n"
    print text
  end

  # 指定された URL にリダイレクトする。
  def self.redirect(url)
    html = <<-EOS
<html>
<head>
<meta charset="utf-8" />
<title>redirect</title>
<meta http-equiv="refresh" content="0;url=URL" />
<meta http-equiv="cache-control" content="no cache" />
</head>
<body>
<div style="margin-left:25%;margin-top:50px;">
<a href="URL">ジャンプしないときはここをクリックしてください。Click here</a>
</div>
</body>
</html>
EOS
    embed = html.gsub('URL', url)
    print "Content-Type: text/html\n\n" + embed
  end

  # キャッシュコントロールヘッダを追加する。
  def cacheControl(value)
    @headers.push("Cache-Control: #{value}")
  end

  # キャッシュ期限ヘッダを追加する。
  def cacheExpires(date)
    @headers.push("Expires: #{date}")
  end

  # ファイルを @html (テキスト) または @binbuff (バイナリー) に読み込む。
  def loadFile(filePath)
    if isBinaryFile(filePath) then
      # バイナリーファイルの場合
      open(filePath, "rb") {|f|
        f.binmode
        @binbuff = f.read
      }
    else
      # テキストファイルの場合
      open(filePath, "r") {|f|
        @html = f.read.force_encoding('utf-8')
      }
    end
  end

  # filePath がバイナリーファイルなら true を返す。(このメソッドは内部で使用する)
  def isBinaryFile(filePath)
    extlist = ['.jpg', '.png', '.gif', '.wav', '.mp3', '.oga', '.mp4', '.ogv', '.zip', '.gz', '.pdf']
    ext = File.extname(filePath).downcase
    extlist.include?(ext)
  end

  # @headers をすべて送信する。
  def sendHeaders()
    @headers.each {|header|
       ##@@logger.info(header)
       print header
       print "\n"
    }
    print "\n"
  end

  # ファイル名に基づいてHTTPヘッダを設定する。
  def setHeader(filePath)
    ext = File.extname(filePath).downcase
    case ext
      when '.html' then
        @headers.push("Content-Type: text/html; charset=utf8")
        @mime = "text/html"
      when '.txt' then
        @headers.push("Content-Type: text/plain; charset=utf8")
        @mime = "text/plain"
      when '.json' then
        @headers.push("Content-Type: application/json; charset=utf8")
        @mime = "application/json"
      when '.xml' then
        @headers.push("Content-Type: text/xml; charset=utf8")
        @mime = "text/xml"
      when '.svg' then
        @headers.push("Content-Type: image/svg+xml; charset=utf8")
        @mime = "image/svg+xml"
      when '.jpg' then
        @headers.push("Content-Type: image/jpeg")
        @mime = "image/jpeg"
      when '.png' then
        @headers.push("Content-Type: image/png")
        @mime = "image/png"
      when '.gif' then
        @headers.push("Content-Type: image/gif")
        @mime = "image/gif"
      when '.mp3' then
        @headers.push("Content-Type: audio/mp3")
        @mime = "audio/mp3"
      when '.wav' then
        @headers.push("Content-Type: audio/wav")
        @mime = "audio/wav"
      when '.oga' then
        @headers.push("Content-Type: audio/ogg")
        @mime = "audio/ogg"
      when '.mp4' then
        @headers.push("Content-Type: video/mp4")
        @mime = "video/mp4"
      when '.ogv' then
        @headers.push("Content-Type: video/ogg")
        @mime = "video/ogg"
      when '.zip' then
        @headers.push("Content-Type: application/zip")
        @mime = "application/zip"
      when '.gz' then
        @headers.push("Content-Type: application/x-gz")
        @mime = "application/x-gz"
      when '.pdf' then
        @headers.push("Content-Type: application/pdf")
        @mime = "application/pdf"
    end # case
  end

end # class
