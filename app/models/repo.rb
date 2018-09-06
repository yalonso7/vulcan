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
  
  def commit_push(message)
    # g = Git.open(self.repo_url, :log => Logger.new(STDOUT))
    # require 'pry'
    # binding.pry
    Dir.chdir("#{Rails.root}/git/#{self.projects[0].name}/#{self.projects[0].branch}/#{self.projects[0].name}")
    system("git add .")
    system("git commit -m '#{message}'")
    system("git push")
  end
  
  def create_pull_request
    Dir.chdir("#{Rails.root}/git/#{self.projects[0].name}/#{self.projects[0].branch}/#{self.projects[0].name}")
    system("git request-pull . ")
  end
end
