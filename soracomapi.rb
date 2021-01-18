require 'faraday'
require 'oj'
require 'active_support/all'
require 'pry'

# クラス定義
class SoracomApi
  def initialize(user_id:, password:)
    @url = 'https://api.soracom.io'
    @user_id = user_id
    @password = password
    set_http_client
  end

  def set_http_client
    @http_client = Faraday.new(
      url: @url,
      headers: {'Content-Type' => ' application/json', 'Accept' => 'application/json'}
    )
    get_token
  end

  def get_token
    resp = post(endpoint: '/v1/auth', body: {email: @user_id, password: @password,}, headers: {'Content-Type' => 'application/json', 'Accept' => 'application/json'})
    if resp.status == 200
      @token = Oj.load(resp.body)['token']
      @apiKey = Oj.load(resp.body)['apiKey']
      @postHeaders = {'Content-Type' => 'application/json', 'Accept' => 'application/json', 'X-Soracom-API-Key' => @apiKey, 'X-Soracom-Token' => @token}
      @putHeaders = {'Content-Type' => 'application/json', 'Accept' => 'application/json', 'X-Soracom-API-Key' => @apiKey, 'X-Soracom-Token' => @token}
      @getHeaders = {'Accept' => 'application/json', 'X-Soracom-API-Key' => @apiKey, 'X-Soracom-Token' => @token}
    else
      raise ERROR_API_CALL_AUTHENTICATE
    end
  end

  def get(endpoint:, body: nil, headers: @getHeaders)
    @http_client.get(endpoint) do |req|
      req.body = Oj.dump(body, mode: :compat) if body.present?
      if headers.present?
        headers.each{|key, value| req.headers[key.to_s] = value}
      end
    end
  end

  def post(endpoint:, body:, headers: @postHeaders)
    @http_client.post(endpoint) do |req|
      req.body = Oj.dump(body, mode: :compat) if body.present?
      if headers.present?
        headers.each{|key, value| req.headers[key.to_s] = value}
      end
    end
  end

  def put(endpoint:, body:, headers: @putHeaders)
    @http_client.put(endpoint) do |req|
      req.body = Oj.dump(body) if body.present?
      if headers.present?
        headers.each{|key, value| req.headers[key.to_s] = value}
      end
    end
  end
end

class ERROR_API_CALL_AUTHENTICATE < StandardError; end

