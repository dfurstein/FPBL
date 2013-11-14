class Player < ActiveRecord::Base
  attr_accessible :dmb_id, :first_name, :last_name, :position

  has_many :contracts

  def full_name
    first_name + " " + last_name
  end
end
