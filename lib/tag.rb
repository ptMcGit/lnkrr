class Tag < ActiveRecord::Base
  has_many :item_tags, foreign_key: :category_id
  has_many :items, through: :item_tags
end
