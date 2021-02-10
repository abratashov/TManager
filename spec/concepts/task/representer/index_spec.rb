require 'rails_helper'

RSpec.describe Task::Representer::Index do
  let(:user) { create :user }
  let(:project) { create(:project, user: user, id: 1000, name: 'name-1000') }
  let(:task) {
    create(:task, project: project,
                  id: 1000,
                  name: 'name-1000',
                  deadline: Date.parse('3030-03-03'))
  }
  let(:task_json) {
    {
      "data" => [
        {
          "id" => "1000",
          "attributes" => {
            "name" => "name-1000",
            "deadline" => "3030-03-03T00:00:00.000Z",
            "position" => 1,
            "done" => false,
            "comments-count" => 0
          },
          "type" => "tasks",
          "links" => {
            "self" => "http://test.host/api/v1/tasks/1000"
          }
        }
      ]
    }
  }
  subject(:rep) { described_class.new([task]).to_json }

  before { task }

  it 'returns tasks' do
    expect(JSON.parse(rep.to_s)).to eq task_json
  end
end
