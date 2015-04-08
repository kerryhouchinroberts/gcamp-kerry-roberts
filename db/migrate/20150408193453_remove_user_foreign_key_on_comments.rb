class RemoveUserForeignKeyOnComments < ActiveRecord::Migration
  def change
    change_table :comments do |t|
      remove_foreign_key :comments, :users
    end
  end
end
