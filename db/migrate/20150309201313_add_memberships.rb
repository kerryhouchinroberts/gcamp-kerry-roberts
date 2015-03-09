class AddMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.integer :role, default: 0
      t.belongs_to :project, index: true
      t.belongs_to :user, index: true
    end
    add_foreign_key :memberships, :projects
    add_foreign_key :memberships, :users
  end
end
