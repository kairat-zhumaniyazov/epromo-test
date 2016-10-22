class YaDirectController < ApplicationController
  def index
    return unless authenticated?

    @res = YadAPI.get_yadirect_data(session[:yandex_access_token])
  end
end


