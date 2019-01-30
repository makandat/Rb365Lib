#!/usr/bin/ruby
#  コンソールアプリ・ウィザード
require "Common"
require "FileSystem"



# プログラム
progcode = <<-EOS
#!/usr/bin/env ruby
require "Common"
require "FileSystem"
require "Text"
require "DateTime"
require "MySQL"

if Common.count_args() < num_of_params then
  Common.stop(9, "必要なパラメータがありません。")
end

Common.esc_print("cyan", "project_name を開始します。")

client = MySQL.new

# TODO: ここにユーザのコードを記述します。

EOS


conffile = <<-EOS
# MySQL 接続設定
uid=user
pwd=??????
db=user
host=localhost
EOS


# ユーザに質問
Common.esc_print(ESC_FG_CYAN + ESC_BOLD, "\nRb365 コンソールアプリ・ウィザード (ruby v2.5 以上が必要)\n")
num_of_params = Common.readline("Q1 コマンドライン引数の数は？ (未定の場合は 1 を入力してください。) ")
copy_modules = Common.readline("Q2 Rb365Lib モジュールをインストール先にコピーしますか？ (y/n) ")
use_mysql = Common.readline("Q3 MySQL を使用しますか？ (y/n) ")
project_name = Common.readline("Q4 プロジェクトの名前を入力します。(半角英字・数字、_ のみとする) ")
if project_name == "" then
  project_name = "project_main"
end
parent_folder = Common.readline("Q5 インストール先の親フォルダをフルパスで入力します。")
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
if num_of_params == "" then
  num_of_params = 0
else
  num_of_params = num_of_params.to_i
end
puts "引数の数 %d" % num_of_params
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


Common.esc_print("yellow", "\n以上のの条件でコンソールアプリ・プロジェクトを作成します。\n中止する場合は \"S\" を、続行する場合は、Enter を押してください。")

# 実行
begin
  c = Common.readline("> ")
  if c.downcase == 's' then
    exit 9
  end

  if not FileSystem.isDirectory(parent_folder) then
    Common.stop(1, ESC_FG_RED + "親フォルダ %s が存在しません。\n" + ESC_NORMAL % parent_folder)
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
  end
  if use_mysql then
    FileSystem.copy("MySQL.rb", the_folder)
  end

  # プログラムファイル
  filePath = the_folder + "/" + project_name + ".rb"
  File.open(filePath, "w") {|f|
    lines = progcode.split("\n")
    lines.each {|line|
      line.gsub!("num_of_params", num_of_params.to_s)
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

  # 実行可能にする。
  FileSystem.chmod(filePath, 0755)

  # その他のファイル
  if use_mysql then
    FileSystem.writeAllText(the_folder + "/AppConf.ini", conffile)
  end

  # 終了メッセージ
  Common.esc_print("green", "成功しました。AppConf.ini の内容を編集してください。")

  # カレントディレクトリを変更
  FileSystem.chdir(the_folder)
  Common.exec("ls")
rescue => e
  Common.esc_print("red", "失敗しました。" + e.message)
end

