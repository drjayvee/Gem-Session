class AddReferenceFromProjectToUser < ActiveRecord::Migration[8.0]
  def change
    add_reference :projects, :user, foreign_key: true
  end
end
