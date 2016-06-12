class Slink < ActiveRecord::Base
  validates_presence_of :user_id, :link_id

  belongs_to :user
  belongs_to :link

  def mark_time
    # WARNING: not `done_at = Time.now`
    self.timestamp = Time.now
    save!
  end
end
