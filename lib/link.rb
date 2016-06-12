class Link < ActiveRecord::Base
  validates_presence_of :title, :url
  validates_uniqueness_of :url

  has_many :slinks
  has_many :users, through: :slinks

  def mark_time
    # WARNING: not `done_at = Time.now`
    self.timestamp = Time.now
    save!
  end
end
