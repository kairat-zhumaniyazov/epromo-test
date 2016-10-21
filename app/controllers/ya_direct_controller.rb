class YaDirectController < ApplicationController
  def index
    return if session[:yandex_access_token].nil? || session[:yandex_access_token].blank?

    @res = YadAPI.get_campaigns(session[:yandex_access_token])
  end
end


