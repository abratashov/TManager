require 'rails_helper'

RSpec.describe Project::Representer::Show do
  let(:user) { create :user }
  let(:project) { create(:project, user: user, id: 1000, name: 'name-1000') }
  let(:project_json) {
    {
      "data" => {
        "id" => "1000",
        "attributes" => {
          "name" => "name-1000"
        },
        "type" => "projects",
        "links" => {
          "self" => "http://test.host/api/v1/projects/1000"
        }
      }
    }
  }
  subject(:rep) { described_class.new(project).to_json }

  before { project }

  it 'returns projects' do
    expect(JSON.parse(rep.to_s)).to eq project_json
  end
end
