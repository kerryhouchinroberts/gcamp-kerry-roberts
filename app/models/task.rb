class Task < ActiveRecord::Base

  belongs_to :project

  validates :description, presence: true

  def change_date
    due_date.strftime('%-m/%d/%Y')
  end

end
