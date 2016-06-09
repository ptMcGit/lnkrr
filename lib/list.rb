class List < ActiveRecord::Base
  validates_presence_of :title, :user_id
  validates_uniqueness_of :title, scope: :user_id

  belongs_to :user
  has_many :items

  def add_item name, due_date: nil
    items.create! name: name, due_date: due_date
  end
end
