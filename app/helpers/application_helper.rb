module ApplicationHelper
  def authorize_with_yandex_link(params = {})
    uri = URI('https://oauth.yandex.ru/authorize')
    uri.query = params.merge({ client_id: Rails.application.secrets.ya_app_id }).to_query
    link_to 'Авторизироваться через Яндекс', uri.to_s
  end

  def user_authorized?
    !(session[:yandex_access_token].nil? || session[:yandex_access_token].blank?)
  end
end
