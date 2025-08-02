class ProjectUserNotNull < ActiveRecord::Migration[8.0]
  def change
    change_column_null :projects, :user_id, false
  end
end
