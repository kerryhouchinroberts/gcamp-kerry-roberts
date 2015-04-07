class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :task

  validates :comment_body, presence: true
end
