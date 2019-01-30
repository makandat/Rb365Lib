#!/usr/bin/ruby
#  Ajax / CGI ウィザード
require "Common"
require "FileSystem"
require "MySQL"
require "Text"
require "WebPage"

TEMPLATE ="./templates/AjaxMain.html"

# UI CGI
progcode = <<-EOS
#!/usr/bin/env ruby
require "./Common.rb"
require "./FileSystem.rb"
require "./Text.rb"
require "./DateTime.rb"
require "./MySQL.rb"
require "./WebPage.rb"

TEMPLATE = "./templates/project_name.html"


# WebPage 派生クラス
class CGIMain < WebPage
  # コンストラクタ
  def initialize(template="")
    super(template)
    @vars['result'] = ""
  end
end

# 応答を返す。
cgi = CGIMain.new(TEMPLATE)
cgi.echo()

EOS


# HTML TEMPLATE
htmlcode = <<-EOS
<!doctype html>
<html>
<head>
 <meta charset="utf-8" />
 <title>Ajax</title>
 <link rel="stylesheet" href="/css/default.css" />
 <script src="/js/jquery.min.js"></script>
 <script>
$(function() {
  $('button').click(function() {
    text1 = $('input[name="text1"]').val();
    $.getJSON('/cgi-bin/B/ajax_B.cgi', {"text1":text1}, function(data) { $('#result').text(data['text1']); });
  });
});
 </script>
</head>

<body>
<h1>AjaxTitle</h1>
<div style="text-align:center;"><a href="/">HOME</a></div>
<br />
<form method="POST" style="margin-left:30%;">
 <div><label>Text1 <input type="text" name="text1" /></label></div>
 <div><button type="button">送信</button>
</form>
<br />
<div id="result" style="text-align:center;color:magenta;"></div>
<p>&nbsp;</p>
</body>
</html>
EOS


# AJAX CGI
ajaxfile = <<-EOS
#!/usr/bin/env ruby
require "WebPage"

class AjaxResponse < WebPage
  # コンストラクタ
  def initialize(template="")
    super(template)
    resp = '{"text1":0}'
    if isParam('text1') then
      resp = '{"text1":' + getParam('text1') + "}"
    end
    AjaxResponse.sendJson(resp)
  end
end

AjaxResponse.new
EOS


# AppConf.ini
conffile = <<-EOS
uid=user
pwd=??????
db=user
host=localhost
EOS


# ユーザに質問
Common.esc_print(ESC_FG_CYAN + ESC_BOLD, "\nRb365 AJAX/CGI ウィザード (ruby v2.5 以上が必要)\n")
copy_modules = Common.readline("Q1 Rb365Lib モジュールをインストール先にコピーしますか？ (y/n) ")
use_mysql = Common.readline("Q2 MySQL を使用しますか？ (y/n) ")
project_name = Common.readline("Q3 プロジェクトの名前を入力します。(半角英字・数字、_ のみとする) ")
if project_name == "" then
  project_name = "CGIMain"
end
parent_folder = Common.readline("Q4 インストール先の親フォルダをフルパスで入力します。(書き込み許可が必要)")
if parent_folder == "" then
  if FileSystem.exists("parent_folder.txt") then
    parent_folder = FileSystem.readAllText("./parent_folder.txt").chomp
    puts "%s を親フォルダとします。この場所は parent_folder.txt で設定します。" % parent_folder
  else
    Common.stop(3, "インストール先の親フォルダは有効なディレクトリでなければなりません。")
  end
end

# ユーザに条件を確認
puts
if copy_modules == "y" then
  puts "Rb365Lib モジュールをコピーする。"
  copy_modules = true
else
  puts "Rb365Lib モジュールをコピーしない。"
  copy_modules = false
end
if use_mysql == "y" then
  puts "MySQL モジュールを使用する。"
  use_mysql = true
else
  puts "MySQL モジュールを使用しない。"
  use_mysql = false
end
puts "プロジェクト名 %s" % project_name
puts "インストール先のフォルダ %s" % parent_folder


Common.esc_print("yellow", "\n以上のの条件で CGI プロジェクトを作成します。\n中止する場合は \"S\" を、続行する場合は、Enter を押してください。")

# 実行
begin
  c = Common.readline("> ")
  if c.downcase == 's' then
    exit 9
  end

  if not FileSystem.isDirectory(parent_folder) then
    Common.stop(1, (ESC_FG_RED + "親フォルダ %s が存在しません。\n" + ESC_NORMAL) % parent_folder)
  end

  if not (project_name =~ /^[a-zA-Z]([a-zA-Z0-9]|_)*/) then
    Common.stop(2, ESC_FG_RED + "プロジェクト名が不正です。\n" + ESC_NORMAL)
  end

  the_folder = parent_folder + "/" + project_name
  puts "ディレクトリ %s を作成します。" % the_folder
  if FileSystem.isDirectory(the_folder) then
    puts the_folder + " は上書きされます。"
  else
    FileSystem.mkdir(the_folder)
  end

  puts "必要なファイルをコピーします。"
  # モジュールファイル類
  if copy_modules then
    FileSystem.copy("Common.rb", the_folder)
    FileSystem.copy("Text.rb", the_folder)
    FileSystem.copy("FileSystem.rb", the_folder)
    FileSystem.copy("DateTime.rb", the_folder)
    FileSystem.copy("WebPage.rb", the_folder)
  end
  if use_mysql then
    FileSystem.copy("MySQL.rb", the_folder)
  end

  # プログラムファイル
  filePath = the_folder + "/" + project_name + ".cgi"
  File.open(filePath, "w") {|f|
    lines = progcode.split("\n")
    lines.each {|line|
      line.gsub!("project_name", project_name)
      if use_mysql then
        f.puts line
        #puts line
      else
        if line =~ /MySQL/ then
          # pass
        else
          f.puts line
          #puts line
        end
      end
    }
  }

  # テンプレートファイル
  templatesPath = the_folder + "/templates"
  if not FileSystem.exists(templatesPath) then
    FileSystem.mkdir(templatesPath)
  end
  filePath2 = templatesPath + "/" + project_name + ".html"
  File.open(filePath2, "w") {|f|
    lines = htmlcode.split("\n")
    lines.each {|line|
      line.gsub!('CGIWiz', project_name)
      f.puts line
    }
  }

  # AJAX CGI ファイル
  ajaxCgiPath = the_folder + "/ajax_" + project_name + ".cgi"
  File.open(ajaxCgiPath, "w") {|f|
    lines = ajaxfile.split("\n")
    lines.each {|line|
      f.puts line
    }
  }

  # CGI を実行可能にする。
  FileSystem.chmod(filePath, 0755)
  FileSystem.chmod(ajaxCgiPath, 0755)

  # その他のファイル
  if use_mysql then
    FileSystem.writeAllText(the_folder + "/AppConf.ini", conffile)
  end

  # 終了メッセージ
  Common.esc_print("green", "成功しました。AppConf.ini の内容を編集してください。")

  # parent_folder.txt を更新する。
  File.open("parent_folder.txt", "w") {|f|
    f.print parent_folder
  }

  # カレントディレクトリを変更
  puts the_folder
  FileSystem.chdir(the_folder)
  Common.exec("ls")
rescue => e
  Common.esc_print("red", "失敗しました。" + e.message)
end

