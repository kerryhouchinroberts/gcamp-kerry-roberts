class Task < ActiveRecord::Base

  belongs_to :project

  has_many :comments, dependent: :destroy
  has_many :users, through: :comments

  validates :description, presence: true

  def change_date
    due_date.strftime('%-m/%d/%Y')
  end

end
