class User < ActiveRecord::Base
  validates_presence_of :username
  validates_uniqueness_of :username

### this works

  has_many :slinks
  has_many :links, through: :slinks

###

 # has_many :links, through: :slinks, :class_name => 'Link', :foreign_key => 'user_id'
 # has_many :links, through: :slinks, :class_name => 'Link', :foreign_key => 'receiver_id'

  def rlinks
   rlinks = Slink.where(receiver_id: self.id)
   rlinks.map { |r| Link.find_by(id: r.link_id) }
  end

  def user_profile
    self.as_json.merge({"saved_links" => self.links.pluck(:url)})
  end

end
