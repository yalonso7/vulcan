require 'inspec/objects'
require 'date'
require 'git'
###
# TODO: FORM VALIDATION
###
class Project < ApplicationRecord
  resourcify
  before_destroy :destroy_project_controls, :destroy_local_git
  after_commit :update_project_xml, if: :persisted?
  

  has_many  :project_controls
  has_many  :project_histories
  has_and_belongs_to_many :srgs
  has_and_belongs_to_many :users
  belongs_to :vendor, optional: true
  belongs_to :sponsor_agency, optional: true
  serialize :srg_ids
  accepts_nested_attributes_for :project_controls
  
  has_many :children, class_name: "Project",
                      foreign_key: "parent_id"
                  
  belongs_to :parent, class_name: "Project",
                      foreign_key: "parent_id", 
                      optional: true
                      
  belongs_to :repo, optional: true
  
  attribute :name
  attribute :title
  attribute :maintainer
  attribute :copyright 
  attribute :copyright_email
  attribute :license
  attribute :summary
  attribute :version
  attribute :status
  
  attr_encrypted :name, key: Rails.application.secrets.db
  attr_encrypted :title, key: Rails.application.secrets.db
  attr_encrypted :maintainer, key: Rails.application.secrets.db
  attr_encrypted :copyright, key: Rails.application.secrets.db
  attr_encrypted :copyright_email, key: Rails.application.secrets.db
  attr_encrypted :license, key: Rails.application.secrets.db
  attr_encrypted :summary, key: Rails.application.secrets.db
  attr_encrypted :version, key: Rails.application.secrets.db
  attr_encrypted :status, key: Rails.application.secrets.db
  attr_encrypted :branch, key: Rails.application.secrets.db

  
  # def to_csv
  #   attributes = %w{name title maintainer copyright copyright_email license summary version srg_ids}
  # 
  #   CSV.generate(headers: true) do |csv|
  #     csv << attributes
  # 
  #     csv << attributes.map{ |attr| self.send(attr) }
  #   end
  # end
  
  def create_local_git(user_email)
    create_master_git
    create_user_projects
  end
  
  def to_xccdf(params)
    inspec_profile = to_inspec_profile
    InspecTools::Inspec.new(inspec_profile.to_json).to_xccdf(benchmark_attributes(params))
  end
  
  def to_csv
    inspec_profile = to_inspec_profile
    InspecTools::Inspec.new(inspec_profile.to_json).to_csv
  end
  
  def to_inspec_profile
    inspec_json = {}
    inspec_json = insert_profile_data(inspec_json)
    inspec_json['controls'] = insert_controls
    inspec_json
  end
  
  def to_prof
    @controls = []
    @random = rand(1000..100000)
    @name = self.name.gsub(/\s/, '_')
    generate_controls
    create_skeleton
    write_controls
    create_json
    compress_profile
    File.read("tmp/#{@random}/#{@name}.zip")
  end
  
  def update_project_xml
    puts "HERE"
    File.open("#{Rails.root}/git/#{self.name}/#{self.branch}/#{self.name}/vulcan_project.xml", 'w') { |file| file.write(to_xml) }
  end
  
  private
  
  def create_user_projects
    self.users.each do |user|
      user_project = self.dup
      user_project.users = [user]
      user_project.parent = self
      user_project.branch = user.email

      user_project.repo = Repo.new({name: self.name, repo_url: "#{Rails.root}/git/#{user_project.name}/#{user.email}/#{user_project.name}", repo_type: 'local', parent_id: user_project.parent.repo.parent.id})
      user_project.users.each {|user| user.add_role(user.roles.first.name, user_project) }
      Dir.mkdir("#{Rails.root}/git/#{self.name}/#{user.email}")
      Dir.chdir("#{Rails.root}/git/#{self.name}/#{user.email}")
      # system("git submodule add -f #{Rails.root}/git/#{self.name}/srv/#{self.name}.git")
      system("git subtree add --prefix #{Rails.root}/git/#{self.name}/#{user.email} #{Rails.root}/git/#{self.name}/srv/#{self.name}.git master")
      Dir.chdir("#{Rails.root}/git/#{self.name}/#{user.email}/#{self.name}")
      system("git checkout -b #{user.email}")
      system('git commit -m "Initial Commit"')
      system("git push origin #{user.email}")
      
      user_project.save
    end
  end
  
  def create_master_git
    Dir.mkdir("#{Rails.root}/git/#{self.name}")
    Dir.mkdir("#{Rails.root}/git/#{self.name}/srv")
    Dir.mkdir("#{Rails.root}/git/#{self.name}/srv/#{self.name}.git")
    Dir.chdir("#{Rails.root}/git/#{self.name}/srv/#{self.name}.git")
    system("git init --bare")
    # Dir.mkdir("#{Rails.root}/git/#{self.name}/master")
    # Dir.chdir("#{Rails.root}/git/#{self.name}/master")
    require 'pry'
    binding.pry
    system("git subtree add --prefix #{Rails.root}/git/#{self.name}/master #{Rails.root}/git/#{self.name}/srv/#{self.name}.git master")
    Dir.chdir("#{Rails.root}/git/#{self.name}/master")
    system("touch README.md")
    File.open('vulcan_project.xml', 'w') { |file| file.write(to_xml) }
    system('git add .')
    system('git commit -m "Initial Commit"')
    system('git push origin master')
  end
  
  def to_xml
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.root {
        xml.id self.id
        xml.name self.name
        xml.title self.title
        xml.maintainer self.maintainer
        xml.copyright self.copyright
        xml.copyright_email self.copyright_email
        xml.license self.license
        xml.summary self.summary
        xml.version self.version
        xml.status self.status
        xml.repo self.repo
        xml.controls {
          self.project_controls.each do |control|
            xml.control {
              xml.id control.id
              xml.title control.title
              xml.description control.description
              xml.impact control.impact
              xml.control_id control.control_id
              xml.code control.code
              xml.checktext control.checktext
              xml.fixtext control.fixtext
              xml.justification control.justification
              xml.applicability control.applicability
              xml.status control.status
              xml.nist_controls {
                control.nist_controls.each do |nist|
                  xml.nist_control {
                    xml.id = nist.id
                    xml.index = nist.index
                    xml.version = nist.version
                    xml.ccis {
                      nist.ccis.each do |cci|
                        xml.cci {
                          xml.id = cci.id
                          xml.cci = cci.cci   
                        }
                      end
                    }  
                  }
                end
              }  
            }
          end
        }
        xml.srgs {
          self.srgs.each do |srg|
            xml.srg {
              xml.id = srg.id
              xml.title = srg.title
              xml.description =  srg.description
            }
          end
        }
      }
    end
    builder.to_xml
  end
  
  def benchmark_attributes(params)
    attributes = {}
    attributes["benchmark.id"] = params["benchmark_id"]
    attributes["benchmark.title"] = self.title
    attributes["benchmark.description"] = self.summary
    attributes["benchmark.version"] = self.version
    attributes["benchmark.status"] = params["benchmark_status"]
    attributes["benchmark.status.date"] = Date.today.to_s
    attributes["benchmark.notice"] = params["benchmark_notice"]
    attributes["benchmark.plaintext"] = params["benchmark_plaintext"]
    attributes["benchmark.plaintext.id"] = params["benchmark_plaintext_id"]
    attributes["reference.href"] = params["reference_href"]
    attributes["reference.dc.source"] = params["reference_dc_source"]
    attributes
  end
  
  def insert_profile_data(inspec_json)
    inspec_json['name'] = self.name
    inspec_json['title'] = self.title
    inspec_json['maintainer'] = self.maintainer
    inspec_json['copyright'] = self.copyright
    inspec_json['copyright_email'] = self.copyright_email
    inspec_json['license'] = self.license
    inspec_json['summary'] = self.summary
    inspec_json['version'] = self.version
    inspec_json
  end
  
  def insert_controls
    controls = []
    self.project_controls.each do |project_control|
      control = {}
      control['tags'] = {}
      control['id'] = project_control.control_id
      control['title'] = project_control.title
      control['desc'] = project_control.description
      control['impact'] = project_control.impact
      control['tags']['check'] = project_control.checktext
      control['tags']['fix'] = project_control.fixtext
      control['tags']['nist'] = project_control.nist_controls.collect {|nist| nist.family + '-' + nist.index }.push('Rev_4')
      control['tags']['gtitle'] = project_control.srg_title_id
      control['tags']['gid'] = project_control.control_id
      control['code'] = project_control.code    
      controls << control  
    end
    controls
  end
  
  def compress_profile
    Dir.chdir "tmp/#{@random}"
    system("zip -r #{Rails.root}/tmp/#{@random}/#{@name}.zip #{@name}")
    stdout, stderr, status = Open3.capture3("zip -r #{Rails.root}/tmp/#{@random}/#{@name}.zip #{@name}")
    Dir.chdir "#{Rails.root}"
  end
  
  # sets max length of a line before line break
  def wrap(s, width = WIDTH)
    s.gsub!("desc  \"\n    ", 'desc  "')
    s.gsub!(/\\r/, "\n")
    s.gsub!(/\\n/, "\n")

    WordWrap.ww(s.to_s, width)
  end

  
  # converts passed in data into InSpec format
  def generate_controls
    self.project_controls.select {|control| control.applicability == 'Applicable - Configurable'}.each do |contr|
      print '.'
      control = Inspec::Control.new
      control.id = contr.control_id
      control.title = contr.title
      control.desc = contr.description
      control.impact = control.impact
      control.add_tag(Inspec::Tag.new('nist', contr.nist_controls.collect{|nist| nist.family + '-' + nist.index})) unless contr.nist_controls.nil?  # tag nist: [AC-3, 4]  ##4 is the version
      control.add_tag(Inspec::Tag.new('audit text', contr.checktext)) unless contr.checktext.nil?
      control.add_tag(Inspec::Tag.new('fix', contr.fixtext)) unless contr.fixtext.nil?
      control.add_tag(Inspec::Tag.new('Related SRG', contr.srg_title_id)) unless contr.srg_title_id.nil?
      @controls << [control, contr.code]
    end
  end
  
  def create_skeleton
    Dir.mkdir("#{Rails.root}/tmp/#{@random}")
    Dir.chdir "tmp/#{@random}"
    stdout, stderr, status = Open3.capture3("inspec init profile #{@name}")
    stdout, stderr, status = Open3.capture3("rm #{Rails.root}/tmp/#{@random}/#{@name}/controls/example.rb")
    Dir.chdir "#{Rails.root}"
  end

  def create_json
    Dir.chdir "#{Rails.root}/tmp/#{@random}"
    stdout, stderr, status = Open3.capture3("inspec json #{@name} | jq . | tee #{@name}-overview.json")
    Dir.chdir "#{Rails.root}"
  end
  
  # Writes InSpec controls to file
  def write_controls
    @controls.each do |control, code|
      file_name = control.id.to_s
      myfile = File.new("#{Rails.root}/tmp/#{@random}/#{@name}/controls/#{file_name}.rb", 'w')
      width = 80

      content = control.to_ruby.gsub(/\nend/, "\n\n" + code + "\nend\n")
      myfile.puts wrap(content, width)
      
      myfile.close
    end
  end

  def destroy_project_controls
    self.project_controls.destroy_all
  end
  
  def destroy_local_git
    g = Git.open("#{Rails.root}", :log => Logger.new(STDOUT))
    if self.branch != 'master'
      cached_name = "#{Rails.root}/git/#{self.name}/#{self.branch}/#{self.name}"
      g.remove(cached_name, :cached => true)
      system("rm -rf #{Rails.root}/.git/modules/git/#{self.name}/#{self.branch}")
      system("rm -rf #{Rails.root}/git/#{self.name}/#{self.branch}")
    else
      self.children.each do |child_project|
        child_project.destroy
      end
      system("rm -rf #{Rails.root}/.git/modules/git/#{self.name}")
      system("rm -rf #{Rails.root}/git/#{self.name}")
    end
  end
end
