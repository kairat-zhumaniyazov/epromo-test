class YaDirectController < ApplicationController
  def index
    return if session[:yandex_access_token].nil? || session[:yandex_access_token].blank?

    # ya_params = {
    #   "method": "GetCampaignsList",
    #   "locale": "ru",
    #   "token": session[:yandex_access_token]
    # }
    #
    # conn = Faraday.new(:url => 'https://api-sandbox.direct.yandex.ru')
    #
    # # post payload as JSON instead of "www-form-urlencoded" encoding:
    # @res = conn.post do |req|
    #   req.url '/v4/json/'
    #   req.headers['Content-Type'] = 'application/json'
    #   req.body = ya_params.to_json
    # end
  end
end