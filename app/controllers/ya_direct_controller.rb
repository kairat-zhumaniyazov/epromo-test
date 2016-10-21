class YaDirectController < ApplicationController
  def index
    return unless authenticated?

    @res = YadAPI.get_campaigns(session[:yandex_access_token])
  end
end


