class AddEmailConfirmationToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :confirmation_token, :string, null: true
    add_column :users, :confirmed_at, :datetime, null: true
  end
end
