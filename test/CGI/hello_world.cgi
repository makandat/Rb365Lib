#!/usr/bin/env ruby
#  hello_world
require './WebPage.rb'

class HelloWorld < WebPage
  # コンストラクタ
  def initialize(template)
    super(template)

  end

end

cgi = HelloWorld.new('templates/hello_world.html')
cgi.echo()
