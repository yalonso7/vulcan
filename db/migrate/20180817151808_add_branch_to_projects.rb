class AddBranchToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :branch, :string
  end
end
