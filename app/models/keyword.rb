class Keyword < ActiveRecord::Base
  belongs_to :campaign

  validates :keyword, :clicks_count, :views_count, :bid, presence: true
end
