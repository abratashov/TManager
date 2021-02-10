require 'rails_helper'

RSpec.describe Comment::Operation::Create do
  let(:user) { create :user }
  let(:name) { FFaker::DizzleIpsum.word }
  let(:project) { create(:project, user: user) }
  let(:task) { create(:task, project: project, name: name) }

  let(:body) { 'body body body' }
  let(:filename) { 'small.png' }
  let(:attachment) { fixture_file_uploader("files/#{filename}") }

  let(:params_body) { body }
  let(:res_params) {
    {
      body: params_body,
      attachment: attachment
    }
  }
  let(:params_user) { user }
  let(:params) {
    {
      params: { task_id: task.id },
      current_user: params_user,
      resource_params: res_params
    }
  }

  describe 'Success' do
    subject(:op) { described_class.call(params) }

    it 'create comment' do
      expect { op }.to change(project.tasks, :count).from(0).to(1)
      expect(op).to be_success
    end
  end

  describe 'Failure' do
    let(:params_body) { '' }

    subject(:op) { described_class.call(params) }

    it 'validation error' do
      expect(op).to be_failure
      expect(op['contract.default'].errors.messages).to include(body: ["must be filled",
                                                                       "size cannot be less than 10",
                                                                       "size cannot be greater than 256"])
    end
  end
end
