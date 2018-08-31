class AddMasterProjectToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :parent_id, :integer
  end
end
