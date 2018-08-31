class Repo < ApplicationRecord
  has_many :projects
  
  has_many :children, class_name: "Repo",
                      foreign_key: "parent_id"
                  
  belongs_to :parent, class_name: "Repo",
                      foreign_key: "parent_id", 
                      optional: true
  
  attribute :name
  attribute :repo_url
  attribute :repo_type

  
  attr_encrypted :name, key: Rails.application.secrets.db
  attr_encrypted :repo_url, key: Rails.application.secrets.db
  attr_encrypted :repo_type, key: Rails.application.secrets.db
  
  def commit
    g = Git.open(self.repo_url, :log => Logger.new(STDOUT))
    # require 'pry'
    # binding.pry
    g.index.path = "#{Rails.root}/.git/modules/git/#{self.projects[0].name}/#{self.projects[0].branch}/#{self.projects[0].name}/index"
    g.add
    g.gcommit('')
    g.push
  end
end
