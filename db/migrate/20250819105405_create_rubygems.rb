class CreateRubygems < ActiveRecord::Migration[8.0]
  def change
    create_table :rubygems do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.string :homepage_url, null: false

      t.timestamps
    end
  end
end
