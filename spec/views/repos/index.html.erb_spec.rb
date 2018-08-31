require 'rails_helper'

RSpec.describe "repos/index", type: :view do
  before(:each) do
    assign(:repos, [
      Repo.create!(
        :name => "Name",
        :repo_url => "Repo Url",
        :repo_type => "Repo Type"
      ),
      Repo.create!(
        :name => "Name",
        :repo_url => "Repo Url",
        :repo_type => "Repo Type"
      )
    ])
  end

  it "renders a list of repos" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Repo Url".to_s, :count => 2
    assert_select "tr>td", :text => "Repo Type".to_s, :count => 2
  end
end
