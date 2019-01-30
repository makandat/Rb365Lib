# coding: utf-8
=begin

  Text.rb テキストモジュール

     Ver. 1.00  2019-01-29

=end


# Text モジュール
module Text

# 文字列の長さ
def len(s)
  s.size()
end

# 引数(char c)が数字なら true を返す。
def isdigit(c)
  v = c[0].ord
  v >= '0'.ord and v <= '9'.ord
end

# 引数(char c)が英字なら true を返す。
def isalpha(c)
  cu = c.upcase
  v = cu[0].ord
  v >= 'A'.ord and v <= 'Z'.ord
end


# 引数が区切り文字なら true を返す。
def isdelim(c)
  not (isdigit(c) or isalpha(c))
end


# 引数が表示可能文字なら true を返す。
def isprint(c)
  c[0].ord >= 0x20
end


# 引数に含まれる英大文字をすべて小文字にする。
def self.tolower(s)
  s.downcase
end


# 引数に含まれる英小文字をすべて大文字にする。
def self.toupper(s)
  s.upcase
end


# 引数の文字列に前後に空白文字があれば削除する。
def self.trim(s)
  s.strip
end


# 文字列の後ろに CR , LF があれば削除する。
def self.chomp(s)
  s.chomp
end


# 区切り文字で文字列を分割して配列として返す。
def self.split(c, s)
  s.split(c)
end


# 結合文字で文字列配列を結合して1つの文字列として返す。
def self.join(c, array)
  array.join(c)
end

# 文字列に検索文字列が含まれていたら true を返す。
def contain(search, s)
  s.include?(search)
end


# 文字列に検索文字列が含まれていたらその位置を返す。
def self.indexOf(search, s)
  s.index(search)
end


# 文字列 s の部分文字列 old を new で置き換える。(old はパターンでもよい)
def self.replace(olds, news, s)
  s.gsub(olds, news)
end


# 値を書式化する。
def self.format(f, *a)
  f % a
end


# 数値を金額(文字列)に変換する。
def self.money(v)
  v.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\1,').reverse
end


# 文字列 s の位置 start から長さ length の部分文字列を返す。
def self.substring(s, start, length)
  s[start, length]
end


# 文字列 s の位置 start から位置 endp までの部分文字列を返す。
def self.substr(s, start, endp)
  length = endp - start + 1
  s[start, length]
end


# 文字列 s の先頭から長さ length の部分文字列を返す。
def self.left(s, length)
  s[0, length]
end


# 文字列 s の最後から長さ length の部分文字列を返す。
def self.right(s, length)
  p = 0 - (s.size() - length + 1)
  s[p, -1]
end

# 文字列 s を整数文字列としてその値を返す。
def self.parseInt(s)
  s.to_i
end


# 文字列 s を浮動小数点数文字列としてその値を返す。
def self.parseDouble(s)
  s.to_f
end


# 正規表現 pattern が文字列 s に含まれていれば、true を返す。
def self.re_contain(pattern, s)
  re = Regexp.new(pattern)
  not re.match(str).nil?
end


# 正規表現 pattern が文字列 s に含まれていれば、その位置(start, end)を返す。
def self.re_search(pattern, s)
  Regexp.new(pattern).match(pattern)
end


# 正規表現 pattern により文字列 s を分割して配列として返す。
def self.re_split(pattern, s)
  s.split(pattern)
end


# 正規表現 pattern により文字列 s を検索してマッチした文字列を news に置き換える。
def self.re_replace(pattern, s, news)
  s.gsub(pattern, news)
end

module_function :len, :isdigit, :isalpha, :isdelim, :isprint

end # module
