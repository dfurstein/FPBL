# Describes an owner in the league
class Owner < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name

  has_many :teams

  def self.add_owner(first_name, last_name, email)
    owner = Owner.new

    owner.first_name = first_name
    owner.last_name = last_name
    owner.email = email

    owner.save
  end

  def name
    first_name + ' ' + last_name
  end
end
