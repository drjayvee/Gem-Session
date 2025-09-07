class CreateProjectLikes < ActiveRecord::Migration[8.0]
  def change
    create_table :project_likes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end

    add_index :project_likes, [ :user_id, :project_id ], unique: true
  end
end
