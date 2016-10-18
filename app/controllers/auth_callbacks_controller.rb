class AuthCallbacksController < ApplicationController
  def yandex
    render :auth_failed and return if params[:code].nil? || params[:code].blank?

    ya_params = {
      grant_type: 'authorization_code',
      code: params[:code],
      client_id: Rails.application.secrets.ya_app_id,
      client_secret: Rails.application.secrets.ya_app_secret_key
    }
    yandex_request = Net::HTTP.post_form(URI.parse('https://oauth.yandex.ru/token'), ya_params)
    access_token = JSON.parse(yandex_request.body)['access_token']

    render :auth_failed and return if access_token.nil? || access_token.blank?

    session[:yandex_access_token] = access_token
    redirect_to root_path
  end

  def auth_failed
  end
end