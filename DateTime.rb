# coding: utf-8
=begin

  DateTime.rb 日付時刻モジュール
     Ver. 1.00  2019-01-24

=end

require 'date'


# DateTime1 クラス
class DateTime1

  attr_accessor :dtobj

  # コンストラクタ
  def initialize(s=nil)
    if s.nil? then
      @dtobj = DateTime.now
    else
      @dtobj = DateTime.parse(s)
    end
  end

  # 現在の時刻(JST)を得る。
  def self.now()
    DateTime.now
  end


  # 現在の時刻(UTC)を得る。
  def self.utc()
    DateTime.now.to_time.utc
  end


  # このオブジェクトの日付時刻を文字列として返す。
  def toString()
    @dtobj.to_s
  end


  # このオブジェクトの日付を文字列として返す。
  def toDateString()
    @dtobj.strftime("%Y-%m-%d")
  end


  # このオブジェクトの時刻を文字列として返す。
  def toTimeString()
    @dtobj.strftime("%T")
  end


  # このオブジェクトの月の日を整数(1..31)として返す。
  def day()
    @dtobj.day
  end


  # このオブジェクトの月を整数(1..12)として返す。
  def month()
    @dtobj.mon
  end


  # このオブジェクトの年を整数として返す。
  def year()
    @dtobj.year
  end

  # このオブジェクトの曜日を整数として返す。(0..6, 0=日曜)
  def dayOfWeek()
    @dtobj.wday
  end


  # このオブジェクトの秒を整数として返す。
  def second()
    @dtobj.second
  end


  # このオブジェクトの分を整数として返す。
  def minute()
    @dtobj.min
  end


  # このオブジェクトの時を整数として返す。
  def hour()
    @dtobj.hour
  end


  # このオブジェクトの日付に days を足す。
  def addDays(days)
    @dtobj.to_time + 60 * 60 * 24 * days
  end


  # このオブジェクトの時刻に seconds を足す。
  def addSeconds(seconds)
    @dtobj.to_time + seconds
  end

end # class
