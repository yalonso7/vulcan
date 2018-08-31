class CreateRepos < ActiveRecord::Migration[5.1]
  def change
    create_table :repos do |t|
      t.string  :encrypted_name
      t.string  :encrypted_name_iv
      t.string  :encrypted_repo_url
      t.string  :encrypted_repo_url_iv
      t.string  :encrypted_repo_type
      t.string  :encrypted_repo_type_iv
      t.integer :parent_id
      t.timestamps
    end
    remove_column :projects, :encrypted_repo, :string
    remove_column :projects, :encrypted_repo_iv, :string
    add_column :projects, :repo_id, :integer
  end
end
