class Owner < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name

  def full_name
    self.first_name + " " + self.last_name
  end
end
