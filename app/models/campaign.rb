class Campaign < ActiveRecord::Base
  has_many :keywords, dependent: :destroy

  validates :name, presence: true

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
      create!(id: id, name: data['Name'])
    end
  end

  private

  def self.update_old(exists_ids, yad_list)
    exists_ids.each do |id|
      data = get_campaigns_hash_from_list(yad_list, id)
      find(id).update(name: data['Name']) if data
    end
  end

  def self.get_campaigns_hash_from_list(list, requred_id)
    list.select{ |c| c['Id'] == requred_id }.first
  end
end
