#!/usr/bin/ruby
#   Rb365Lib インストーラ
require "./Common.rb"
require "./FileSystem.rb"
require "./Text.rb"

$ins_path = ""
$is_link = ""
$is_env = ""
$the_files = ["Common.rb", "FileSystem.rb", "Text.rb", "DateTime.rb", "MySQL.rb", "WebPage.rb"]

# モジュールファイルの置き場所(環境により異なるなので場合によっては修正する)
ORGPATH = "/home/user/workspace/ruby/Rb365Lib"


# インストール
def install()
    # ディレクトリがあるかチェック
    if FileSystem.isDirectory($ins_path) then
      # ある場合は上書きメッセージを表示
      puts "コピー先にモジュールがある場合は上書きされます。"
      if FileSystem.isLink($ins_path + "/Common.rb") then
         $the_files.each {|p| FileSystem.unlink($ins_path + "/" + p)}
      end
    else
      # 無い場合は作成する。
      FileSystem.mkdir($ins_path)
    end

    # $is_link によりモジュールのコピーまたはリンク作成
    if $is_link then
      $the_files.each {|p| FileSystem.createSymlink(ORGPATH + "/" + p, $ins_path + "/" + p)}
    else
      $the_files.each {|p| FileSystem.copy("../" + p, $ins_path + "/" + p)}
    end
    
    # 環境変数 RUBYLIB の設定を .profile に追加する。
    profile = FileSystem.getHome() + "/.profile"
    flag = false
    FileSystem.readAllLines(profile, "utf-8") {|line|
       if line =~ /^export\sRUBYLIB=\w+/ then
         Common.esc_print("yellow", "RUBYLIB は .profile にすでに含まれているので手動で修正してください。")
         flag = true
         break
       end
    }
    if flag == false then
       home = FileSystem.getHome()
       puts "vim で ~/.profile を開き \"export RUBYLIB=" + $ins_path + " を最終行に追加してください。"
    end
    
    puts "正常終了"
end

# メインプログラム
def main()
  Common.esc_print(ESC_BOLD, "=== Rb365Lib インストーラ ===")

  # Install path
  $ins_path = Common.readline("インストール先をフルパスで入力してください。> ")
  if $ins_path == '' then
    Common.stop(1, "処理を中止しました。")
  end

  # Copy  or Link
  ans = Common.readline("モジュールをインストール先にコピーしますか？ リンクを作成しますか？ (C/L) > ")
  if Text.toupper(ans) == 'C' then
    $is_link = false
  elsif Text.toupper(ans) == 'L' then
    $is_link = true
  else
    Common.stop(1, "処理を中止しました。")
  end

  # RUBYPATH
  ans = Common.readline("環境変数 RUBYLIB を追加または変更しますか？ (y/n) > ") 
  if ans == 'y' then
    $is_env = true
  elsif ans == 'n' then
    $is_env = false
  else
    Common.stop(1, "処理を中止しました。")
  end

  # Confirmation
  Common.esc_print("green", "\nインストール先：" + $ins_path)
  if $is_link then
    Common.esc_print("green", "インストール先にモジュールのリンクを作成する。")
  else
    Common.esc_print("green", "インストール先にモジュールをコピーする。")
  end
  if $is_env then
    Common.esc_print("green", "環境変数 RUBYLIB を作成または変更する。")
  else
    Common.esc_print("green", "環境変数 RUBYLIB について何もしない。")
  end
  ans = Common.readline("以上でよいですか？ 'y' を入力すると実行します。")

  # 実行
  if ans == 'y' then
     install()
  else
    Common.stop(1, "処理を中止しました。")   
  end
end


# 実行開始
main()
