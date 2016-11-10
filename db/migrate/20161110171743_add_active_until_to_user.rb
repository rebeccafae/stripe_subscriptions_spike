class AddActiveUntilToUser < ActiveRecord::Migration
  def change
    add_column :users, :active_until, :date
  end
end
