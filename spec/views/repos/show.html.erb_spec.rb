require 'rails_helper'

RSpec.describe "repos/show", type: :view do
  before(:each) do
    @repo = assign(:repo, Repo.create!(
      :name => "Name",
      :repo_url => "Repo Url",
      :repo_type => "Repo Type"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Repo Url/)
    expect(rendered).to match(/Repo Type/)
  end
end
