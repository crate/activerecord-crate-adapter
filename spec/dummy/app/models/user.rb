class User < ActiveRecord::Base
  before_create :set_id

  serialize :address, Address

  private

  def set_id
    self.id = SecureRandom.uuid
  end
end
