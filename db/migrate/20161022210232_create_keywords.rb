class CreateKeywords < ActiveRecord::Migration
  def change
    create_table :keywords do |t|
      t.belongs_to :campaign, index: true, foreign_key: true
      t.string :keyword
      t.integer :clicks_count
      t.integer :views_count
      t.decimal :bid, precision: 12, scale: 2

      t.timestamps null: false
    end
  end
end
