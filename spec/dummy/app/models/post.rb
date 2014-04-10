class Post < ActiveRecord::Base
  before_create :set_id

  private

  def set_id
    self.id = SecureRandom.uuid
  end
end
