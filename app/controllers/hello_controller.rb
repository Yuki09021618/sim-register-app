#コントローラ
class HelloController < ApplicationController

  #アクションメソッド「view」
  def helloworld
    #インスタンス変数
    @msg = "Hello World!!!!!!!!!!!!!"
  end

end
