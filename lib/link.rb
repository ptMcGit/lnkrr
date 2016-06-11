class Link < ActiveRecord::Base
  # validates_presence_of :list_id, :name
  # validates_uniqueness_of :name, scope: :list_id
  # validate :due_date_is_in_the_future

  has_many :slinks
  has_many :users, through: :slinks

  def mark_time
    # WARNING: not `done_at = Time.now`
    self.timestamp = Time.now
    save!
  end
end
