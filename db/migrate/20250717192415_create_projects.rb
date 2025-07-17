class CreateProjects < ActiveRecord::Migration[8.0]
  def change
    create_table :projects do |t|
      t.text :prompt, null: false
      t.string :repo_url

      t.timestamps
    end
  end
end
