class AddNameToUser < ActiveRecord::Migration[8.0]
  def up
    add_column :users, :name, :string

    User.all.find_each do
      it.update! name: it.email_address.split("@")[0].capitalize
    end

    change_column :users, :name, :string, null: false
  end

  def down
    remove_column :users, :name
  end
end
