require 'rails_helper'

RSpec.describe Comment::Representer::Show do
  let(:user) { create :user }
  let(:project) { create(:project, user: user, id: 1000, name: 'name-1000') }
  let(:task) {
    create(:task, project: project,
                  id: 1000,
                  name: 'name-1000',
                  deadline: Date.parse('3030-03-03'))
  }
  let(:body) { 'body body body' }
  let(:filename) { 'small.png' }
  let(:attachment) { fixture_file_uploader("files/#{filename}") }
  let(:comment) { build(:comment, task: task, body: body, attachment: attachment) }

  subject(:rep) { described_class.new(comment).to_json }

  before { comment }

  it 'returns comment' do
    res = JSON.parse(rep.to_s)
    expect(res['data']['type']).to eq 'comments'
    expect(res['data']['attributes']['body']).to eq body
    expect(res['data']['attributes']['attachment']['url']).to include(filename)
  end
end
