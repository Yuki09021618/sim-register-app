require './soracomapi'

class DevicesController < ApplicationController
  def index
    @devices = Device.all.order(:imsi) #imsiで昇順ソート
  end

  def getinfo
  end

  def soracom
    @sora = SoracomApi.new(user_id: 'dev@suimin.co.jp', password: 'Exee2dTzht7Y4DV')
    @sim_list = Oj.load(@sora.get(endpoint: '/v1/subscribers?tag_value_match_mode=exact').body)
    for num in 0...@sim_list.length do
      #すでにあるSIMは上書きする。
#      @device = nil
      if @device = Device.find_by(imsi:@sim_list[num]['imsi']) then
         @device.devicesn = @sim_list[num]['tags']['name']
         @device.save
      #IMSIのないSIMは新規データ作成
      else
        @device = Device.new
        @device.imsi = @sim_list[num]['imsi']
        @device.devicesn = @sim_list[num]['tags']['name']
        @device.save
      end
    end
    redirect_to '/devices/index'
  end

end
