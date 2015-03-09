class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  validates :user, presence: true
  validates_uniqueness_of :user, :message => "has already been added to this project" 

  enum role: {member: 0, owner: 1}
end
