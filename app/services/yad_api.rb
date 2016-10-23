class YadAPI
  def self.get_yadirect_data(token)
    set_requests_headers(token)

    campaigns = get_campaigns
    keywords = get_keywords(campaigns.map{ |c| c['Id'] })

    # Операци с кампаниями
    Campaign.data_proccesing(campaigns)
    Keyword.data_proccesing(keywords)

    # собираем в 1 хеш
    res = {}
    campaigns.each do |c|
      res.merge!(c['Id'] => c)
      res[c['Id']]['keywords'] = {}
    end
    keywords.each do |kw|
     res[kw['CampaignId']]['keywords'][kw['Id']] = kw
    end

    # подсчитываем суммы
    res.each do |c|
      c[1]['TotalBid'] = c[1]['keywords'].map{|h| h[1]['Bid']}.reduce(:+)
      c[1]['TotalClicks'] = c[1]['keywords'].map{|h| h[1]['StatisticsSearch']['Clicks']}.reduce(:+)
      c[1]['TotalImpressions'] = c[1]['keywords'].map{|h| h[1]['StatisticsSearch']['Impressions']}.reduce(:+)
    end
    res
  end

  def self.get_campaigns
    query = {
      "method": "get",
      "params": {
        "SelectionCriteria": {},
        "FieldNames": [ "Id", "Name" ],
        "TextCampaignFieldNames": ["RelevantKeywords" ],
      }
    }

    res = HTTParty.post(
      "https://api-sandbox.direct.yandex.com/json/v5/campaigns",
      body: query.to_json,
      headers: @requests_headers
    ).parsed_response['result']['Campaigns']
  end

  def self.get_keywords(campaigns_ids_arr)
    query = {
      "method": "get",
      'params': {
        'SelectionCriteria': {
          "CampaignIds": campaigns_ids_arr
        },
        "FieldNames": ["Id", "CampaignId", "Keyword", "Bid", "ContextBid", "Productivity", 'StatisticsSearch']
      }
    }

    keywords = HTTParty.post(
      "https://api-sandbox.direct.yandex.com/json/v5/keywords",
      body: query.to_json,
      headers: @requests_headers
    ).parsed_response['result']['Keywords']
  end

  private

  def self.set_requests_headers(token)
    @requests_headers = {
      "Authorization": "Bearer #{token}",
      'Accept-Language': 'en'
    }
  end
end