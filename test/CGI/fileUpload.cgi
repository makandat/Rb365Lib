#!/usr/bin/env ruby
#  ファイルアップロード fileUpload.cgi
require "./WebPage.rb"

TEMPLATE = "templates/fileUpload.html"
SAVEDIR = "/var/www/data"


# FileUpload ページ
class FileUpload < WebPage
  # コンストラクタ
  def initialize(template)
    super(template)
    if isPostback() then
      saveFile('fileName', SAVEDIR)
      @vars['message'] = "アップロードされたファイルを " + SAVEDIR + " に保存しました。"
    else
      @vars['message'] = ""
    end
  end
end

# 応答を返す。
page = FileUpload.new(TEMPLATE)
page.echo()
