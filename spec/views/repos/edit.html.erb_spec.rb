require 'rails_helper'

RSpec.describe "repos/edit", type: :view do
  before(:each) do
    @repo = assign(:repo, Repo.create!(
      :name => "MyString",
      :repo_url => "MyString",
      :repo_type => "MyString"
    ))
  end

  it "renders the edit repo form" do
    render

    assert_select "form[action=?][method=?]", repo_path(@repo), "post" do

      assert_select "input[name=?]", "repo[name]"

      assert_select "input[name=?]", "repo[repo_url]"

      assert_select "input[name=?]", "repo[repo_type]"
    end
  end
end
