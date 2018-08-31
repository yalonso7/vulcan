class RemoveRepoFromProjects < ActiveRecord::Migration[5.1]
  def change
    remove_column :projects, :repo, :string
  end
end
