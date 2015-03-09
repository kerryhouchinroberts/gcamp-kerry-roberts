class Project < ActiveRecord::Base
  has_many :tasks, dependent: :destroy

  has_many :memberships
  has_many :users, through: :memberships

  validates :name, presence: true
end
