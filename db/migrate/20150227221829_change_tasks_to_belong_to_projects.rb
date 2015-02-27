class ChangeTasksToBelongToProjects < ActiveRecord::Migration
  def change
    change_table :tasks do |t|
      t.belongs_to :project, index: true
    end
    add_foreign_key :tasks, :projects
  end
end
