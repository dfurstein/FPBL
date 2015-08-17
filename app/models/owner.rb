# Describes an owner in the league
class Owner < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable,
         :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :first_name, :last_name

  has_many :teams

  def self.add_owner(first_name, last_name, email)
    owner = Owner.new

    owner.first_name = first_name
    owner.last_name = last_name
    owner.email = email

    owner.save
  end

  def most_recent_team
    teams.sort_by { |team| team.year }.last
  end

  def name
    first_name + ' ' + last_name
  end

  def points
    points = 0

    teams.each do |team|
      penalty = team.penalty
      standing = team.standing

      points += ((standing.wins - penalty) / 8.1)
      points += ((2**standing.playoff_round) * 4) unless standing.playoff_round.blank?
    end

    points
  end
end
