# Describes an owner in the league
class Owner < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name

  def name
    first_name + ' ' + last_name
  end
end
