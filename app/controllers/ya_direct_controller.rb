class YaDirectController < ApplicationController
  def index
    return if session[:yandex_access_token].nil? || session[:yandex_access_token].blank?

    headers = {
      "Authorization": "Bearer #{session[:yandex_access_token]}",
      'Accept-Language': 'en'
    }

    query = {
      "method": "get",
      "params": {
        "SelectionCriteria": {},
        "FieldNames": [ "Id", "Name" ], #{"DailyBudget", "Funds", "Statistics", "Type" ],
        "TextCampaignFieldNames": ["RelevantKeywords" ],
      }
    }

    @campaigns = HTTParty.post(
      "https://api-sandbox.direct.yandex.com/json/v5/campaigns",
      body: query.to_json,
      headers: headers
    ).parsed_response['result']['Campaigns']

    kw_query = {
      "method": "get",
      'params': {
        'SelectionCriteria': {
          "CampaignIds": @campaigns.map{|c| c['Id']}
        },
        "FieldNames": ["Id", "CampaignId", "Keyword", "Bid", "ContextBid", "Productivity", 'StatisticsSearch']
      }
    }

    @kw = HTTParty.post(
      "https://api-sandbox.direct.yandex.com/json/v5/keywords",
      body: kw_query.to_json,
      headers: headers
    ).parsed_response['result']['Keywords']


    @res = {}
    @campaigns.each do |c|
      @res.merge!(c['Id'] => c)
      @res[c['Id']]['keywords'] = {}
    end
    @kw.each do |kw|
     @res[kw['CampaignId']]['keywords'][kw['Id']] = kw
    end
  end
end


