class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authenticated?
    !(session[:yandex_access_token].nil? || session[:yandex_access_token].blank?)
  end
end
