# coding: utf-8
=begin

  Common.rb 共通モジュール
     Ver. 1.00

=end

require 'logger'
require 'timeout'
require 'rbconfig'
require 'json'


# 端末エスケープシーケンス指定コード
ESC_NORMAL = "\x1b[0m"
ESC_BOLD = "\x1b[1m"
ESC_DIM = "\x1b[2m"
ESC_ITALIC = "\x1b[3m"
ESC_UNDERLINE = "\x1b[4m"
ESC_BLINK = "\x1b[5m"
ESC_HBLINK = "\x1b[6m"
ESC_REVERSE = "\x1b[6m"
ESC_FG_BLACK = "\x1b[30m"
ESC_BG_BLACK = "\x1b[40m"
ESC_FG_RED = "\x1b[31m"
ESC_BG_RED = "\x1b[41m"
ESC_FG_GREEN = "\x1b[32m"
ESC_BG_GREEN = "\x1b[42m"
ESC_FG_YELLOW = "\x1b[33m"
ESC_BG_YELLOW = "\x1b[43m"
ESC_FG_BLUE = "\x1b[34m"
ESC_BG_BLUE = "\x1b[44m"
ESC_FG_MAGENTA = "\x1b[35m"
ESC_BG_MAGENTA = "\x1b[45m"
ESC_FG_CYAN = "\x1b[36m"
ESC_BG_CYAN = "\x1b[46m"
ESC_FG_WHITE = "\x1b[37m"
ESC_BG_WHITE = "\x1b[47m"


# Common モジュール
module Common
  @@logger = nil

  # ログを初期化する。
  def self.init_log(filePath)
    @@logger = Logger.new(filePath)
  end

  # Assert
  def Assert(expr, message)
    if expr then
      # next
    else
      puts message;
      exit 1
    end
  end

  # コマンドライン引数(引数が負のときは配列)を返す。
  def args(i = -1)
    if i < 0 then
      return ARGV
    else
      return ARGV[i]
    end
  end

  # コマンドライン引数の数
  def count_args()
    return ARGV.size()
  end

  # プログラムを終了(中止)する。
  def self.stop(code, message)
    puts message
    exit code
  end

  # コマンドを実行し、成功・失敗を返す。
  def self.exec(cmd)
    system(cmd)
  end

  # コマンドを実行し、コマンドの出力(stdout)を返す。
  def self.shell(cmd)
    `#{cmd}`
  end

  # ログを出力する。
  def self.log(message)
    @@logger.info(message)
  end

  # エラーログを出力する。
  def self.error(message)
    @@logger.error(message)
  end

  # 値があれば true を返す。
  def self.isset(v)
    if v.nil? == true then
      return false
    else
      return true
    end
  end

  # nil (NULL) なら True を返す。
  def self.isnull(v)
    if v.nil? == true
      return true
    else
      return false
    end
  end

  # タイムアウト設定を行う。
  #   例外が発生するので実装しない。
  def self.set_timeout(sec, callback)

  end

  # スリープ
  #   例外が発生するので実装しない。
  def self.sleep(sec)

  end

  # 環境変数の値を得る。key がない場合は nil が返される。
  def get_env(key)
    ENV[key]
  end

  # 動作環境がウィンドウズなら True を返す。
  def is_windows()
    host_os = RbConfig::CONFIG['host_os']
    host_os =~ /mswin|msys|mingw|cygwin|bccwin|wince|emc/
  end

  # 文字列をバイト列に変換する。
  def self.to_bytes(s)
    s.bytes
  end

  # バイト列を文字列に変換する。
  def self.from_bytes(b)
    b.pack('c*').encode('utf-8')
  end

  # エスケープシーケンスを使って文字列を表示する。
  def self.esc_print(color, text)
    case color
      when "black"
        puts ESC_FG_BLACK + text + ESC_NORMAL
      when "red"
        puts ESC_FG_RED + text + ESC_NORMAL
      when "green"
        puts ESC_FG_GREEN + text + ESC_NORMAL
      when "blue"
        puts ESC_FG_BLUE + text + ESC_NORMAL
      when "yellow"
        puts ESC_FG_YELLOW + text + ESC_NORMAL
      when "cyan"
        puts ESC_FG_CYAN + text + ESC_NORMAL
      when "magenta"
        puts ESC_FG_MAGENTA + text + ESC_NORMAL
      when "white"
        puts ESC_FG_WHITE + text + ESC_NORMAL
      when "bold"
        puts ESC_BOLD + text + ESC_NORMAL
      when "italic"
        puts ESC_ITALIC + text + ESC_NORMAL
      when "underline"
        puts ESC_UNDERLINE + text + ESC_NORMAL
      when "blink"
        puts ESC_BLINK + text + ESC_NORMAL
      when "reverse"
        puts ESC_REVERSE + text + ESC_NORMAL
      else
        puts color + text + ESC_NORMAL
    end
  end

  # 文字列をキーボードから読む。
  def readline(message=nil)
    print message
    STDIN.gets.chomp
  end

  # JSON 文字列をオブジェクトに変換する。
  def self.from_json(text)
    JSON.parse(text)
  end

  # オブジェクトを JSON 文字列に変換する。
  def self.to_json(obj)
    obj.to_json
  end


  # モジュール関数を公開
  module_function :count_args
  module_function :args
  module_function :Assert
  module_function :readline
  module_function :get_env
  module_function :is_windows

end # module
