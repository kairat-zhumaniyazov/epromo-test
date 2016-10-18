class SessionsController < ApplicationController
  def sign_out
    session[:yandex_access_token] = nil
    redirect_to root_path
  end
end