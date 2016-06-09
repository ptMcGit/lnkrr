class ItemTag < ActiveRecord::Base
  belongs_to :item
  belongs_to :tag, foreign_key: :category_id
end
