# coding: utf-8
=begin

  FileSystem.rb ファイル関連モジュール
     Ver. 1.00

=end

require 'fileutils'
require 'etc'
require 'tempfile'
require 'csv'
require 'json'


#
#  FileSystem モジュール
#  =====================
module FileSystem

# ファイル(filePath)内容を読み込んで文字列として返す。
#   SJIS ファイルの場合は encoding は "cp932" を指定する。
def self.readAllText(filePath, encoding="utf-8")
  s = ""
  mode = "r:" + encoding
  File.open(filePath, mode) {|f|
    s = f.read
  }
  return s
end


# ファイル(filePath)に文字列(text)を書く。append=true の場合は、追加書き込みを行う。
def self.writeAllText(filePath, text, append=false, encoding="utf-8")
  mode = (append ? "a" : "w") + ":" + encoding
  File.open(filePath, mode) {|f|
    f.write text
  }
end


# ファイルを１行づつ読んで、その行を callback に渡す。
#   SJIS ファイルの場合は encoding は "cp932" を指定する。
def self.readAllLines(filePath, encoding="utf-8", &callback)
  mode = "r:" + encoding
  File.foreach(filePath, mode) {|line|
    callback.call(line.chomp)
  }
end

# ファイル(filePath)内容を読み込んでバイナリー配列として返す。
def self.readBinary(filePath)
  mode = "rb:ASCII-8BIT"
  buff = []
  File.foreach(filePath, mode) {|b| buff.push(b) }
  return buff
end

# ファイル(filePath)内容を読み込んで、バイトデータを callback に渡す。
def self.readBytes(filePath, &callback)
  mode = "rb:ASCII-8BIT"
  File.foreach(filePath, mode) {|b| callback.call(b) }
end

# バイナリー配列 data をファイル filePath に書き込む。
def self.writeBinary(filePath, data)
  mode = "wb:ASCII-8BIT"
  File.open(filePath, mode) {|f|
    data.each {|b| f.write b}
  }
end


# INI ファイルを読んで連想配列として返す。(セクションはコメント扱い)
def self.readIni(filePath, encoding='utf-8')
  mode = "r:" + encoding
  result = Hash.new
  File.foreach(filePath, mode) {|line|
    line.strip!
    if line.include?('=') then
      ps = line.split('=')
      if ps.size() >= 2 and ps[0] =~ /\w.*/ then
        key = ps[0].strip
        value = ps[1].strip
        result[key] = value
      end
    end
  }
  return result
end


# ファイルをコピーする。
def self.copy(src, dest)
  FileUtils.copy(src, dest)
end


# ファイルを移動(リネーム)する。
def self.move(src, dest)
  FileUtils.move(src, dest)
end

# ファイルの属性を変更する。
def self.chmod(filePath, mode)
  FileUtils.chmod(mode, filePath)
end

# ファイルやリンクを削除する。
def self.unlink(filePath)
  FileUtils.safe_unlink(filePath)
end


# ファイルやディレクトリが存在する場合は、true を返す。
def self.exists(filePath)
  FileTest.exist?(filePath)
end


# 指定したパスがディレクトリなら true を返す。
def self.isDirectory(dirPath)
  FileTest.directory?(dirPath)
end


# 指定したパスがファイルなら true を返す。
def self.isFile(filePath)
  FileTest.file?(filePath)
end


# 指定したパスがリンクなら true を返す。
def self.isLink(filePath)
  FileTest.symlink?(filePath)
end

# ファイルサイズを得る。
def self.getFileSize(filePath)
  FileTest.size?(filePath)
end


# 指定したパスの属性を得る。
def self.getAttr(filePath)
  File.stat(filePath)
end


# 指定したパスの所有者を得る。
def self.getOwner(filePath)
  uid = File.stat(filePath).uid
  Etc.getpwuid(uid).name
end


# 指定したパスのグループを得る。
def self.getGroup(filePath)
  gid = File.stat(filePath).gid
  Etc.getgrgid(gid)
end


# 現在の場所(ディレクトリ)を移動する。
def self.chdir(dirPath)
  FileUtils.chdir(dirPath)
end


# ディレクトリを作成する。
def self.mkdir(dirPath)
  FileUtils.mkdir(dirPath)
end

# ディレクトリを削除する。
def self.rmdir(dirPath, recursive=false)
  if recursive then
    FileUtils.remove_entry(dirPath, true)
  else
    FileUtil.remove_dir(dirPath)
  end
end


# 指定したディレクトリのファイル一覧を取得する。
def self.listFiles(dirPath, wildcard="*")
  result = []
  Dir.glob(dirPath + "/" + wildcard).each{|e|
    if FileTest.file?(e) then
      result.push(e)
    end
  }
  return result
end


# 指定したディレクトリのサブディレクトリ一覧を取得する。
def self.listDirectories(dirPath)
  result = []
  Dir.glob(dirPath + "/" + wildcard).each{|e|
    if FileTest.directory?(e) then
      result.push(e)
    end
  }
  return result
end


# 指定したパスのファイル名部分を返す。
def self.getFileName(filePath)
  File.basename(filePath)
end


# 指定したパスのディレクトリ部分を返す。(最後に / は付かない)
def self.getDirectoryName(filePath)
  File.dirname(filePath)
end

# 指定したパスの拡張子を返す。(先頭に . が付く)
def self.getExtension(filePath)
  File.extname(filePath)
end


# 指定した相対パスの絶対パスを返す。
def self.getAbsolutePath(filePath)
  File.absolute_path(filePath)
end


# 指定したパスの親ディレクトリを返す。
def self.getParentDirectory(filePath)
  ps = filePath.split("/")
  if ps.size() == 1 then
    ps = filePath.split("\\")
  end
  n = ps.size()
  if n < 2 then
    return ""
  end
  if File.file?(filePath) then
    return ps[n-2]
  else
    return ps[n-1]
  end
end


# 現在のディレクトリを返す。
def self.getCurrentDirectory()
  Dir.getwd
end


# 一時ファイルのパス名を返す。
def self.getTempFile()
  Tempfile.new
end


# 指定したパスの拡張子を変更する。
def self.changeExt(filePath, ext)
  oldext = File.extname(filePath)
  filePath.gsub(oldext, ext)
end

# CSV ファイルを読んで配列として返す。
def self.readCsv(filePath, header=True, delim=",", lterm="\n")
  result = Array.new
  Fileopen(filePath) {|f|
    data = CSV.read(f, headers:header, col_sep:delim, rowsep:lterm)
    data.each {|r| result.push(r) }
  }
  return result
end


# JSON ファイルを読んでオブジェクトとして返す。
def self.readJson(filePath)
  s = ""
  File.open(filePath, "r") {|f|
    s = f.read
  }
  JSON.parse(s)
end


# データ(オブジェクト)を JSON 文字列に変換してファイル保存する。
def self.writeJson(filePath, data)
  JSON.unparse(data)
end

end # module FileSystem
