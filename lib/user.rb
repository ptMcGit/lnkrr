class User < ActiveRecord::Base
  validates_presence_of :username, :password
  validates_length_of :password, minimum: 4
  validates_uniqueness_of :username

  has_many :links
  # has_many :items, through: :lists

  # def make_link title
  #   # List.create! title: title, user_id: id
  #   # List.create! title: title, user: self
  #   link.create! title: title
  # end
end
