class RenameProjectRepoUrlToHomepageUrl < ActiveRecord::Migration[8.0]
  def change
    rename_column :projects, :homepage_url, :homepage_url
  end
end
