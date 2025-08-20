class CreateJoinTableProjectRubygem < ActiveRecord::Migration[8.0]
  def change
    create_join_table :projects, :rubygems
  end
end
