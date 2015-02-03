class Task < ActiveRecord::Base
  def change_date
    due_date.strftime('%Y/%m/%d')
  end
end
