class Keyword < ActiveRecord::Base
  belongs_to :campaign

  validates :keyword, :clicks_count, :views_count, :bid, presence: true

  def self.data_proccesing(yad_list)
    # все айди из ответа яндекса
    yad_ids = yad_list.map{ |c| c['Id'] }

    # удаляем не нужные
    where.not(id: yad_ids).destroy_all if yad_ids.any?

    # обновляем существующие
    exists_ids = all.pluck(:id)
    update_old(exists_ids, yad_list) if exists_ids.any?

    # добавляем отсутсвующие
    new_ids = yad_ids - exists_ids
    return unless new_ids.any?
    new_ids.each do |id|
      data = get_campaigns_hash_from_list(yad_list, id)
      create!(
          id: id,
          campaign_id: data['CampaignId'],
          keyword: data['Keyword'],
          bid: data['Bid'],
          clicks_count: data['StatisticsSearch']['Clicks'],
          views_count: data['StatisticsSearch']['Impressions']
        )
    end
  end

  private

  def self.update_old(exists_ids, yad_list)
    exists_ids.each do |id|
      data = get_campaigns_hash_from_list(yad_list, id)
      if data
        find(id).update(
            keyword: data['Keyword'],
            campaign_id: data['CampaignId'],
            bid: data['Bid'],
            clicks_count: data['StatisticsSearch']['Clicks'],
            views_count: data['StatisticsSearch']['Impressions']
          )
      end
    end
  end

  def self.get_campaigns_hash_from_list(list, requred_id)
    list.select{ |c| c['Id'] == requred_id }.first
  end
end
