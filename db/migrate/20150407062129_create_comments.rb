class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.belongs_to :user, index: true
      t.belongs_to :task, index: true
      t.string :comment_body
      t.timestamps null: false
    end
      add_foreign_key :comments, :tasks
      add_foreign_key :comments, :users
  end
end
