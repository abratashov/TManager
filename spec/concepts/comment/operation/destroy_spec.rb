require 'rails_helper'

RSpec.describe Comment::Operation::Destroy do
  let(:user) { create :user }
  let(:name) { FFaker::DizzleIpsum.word }
  let(:project) { create(:project, user: user, name: name) }
  let(:task) { create(:task, project: project, name: name) }

  let(:body) { 'body body body' }
  let(:filename) { 'small.png' }
  let(:attachment) { fixture_file_uploader("files/#{filename}") }
  let(:comment) { create(:comment, task: task, body: body, attachment: attachment) }

  let(:res_params) { {} }
  let(:params_user) { user }
  let(:params) {
    {
      params: { id: comment.id },
      current_user: params_user,
      resource_params: res_params
    }
  }

  before { comment }

  describe 'Success' do
    subject(:op) { described_class.call(params) }

    it 'destroy comment' do
      expect { op }.to change(task.comments, :count).from(1).to(0)
      expect(op).to be_success
      expect(op['model'].body).to eq body
    end
  end

  describe 'Failure' do
    subject(:op) {
      described_class.call(current_user: user, resource_params: params, params: {id: 1000000})
    }

    it 'invalid id' do
      expect { op }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
