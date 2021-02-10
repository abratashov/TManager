require 'rails_helper'

RSpec.describe Comment::Operation::Index do
  let(:user) { create :user }
  let(:project) { create(:project, user: user) }
  let(:task) { create(:task, project: project) }

  let(:filename) { 'small.png' }
  let(:attachment) { fixture_file_uploader("files/#{filename}") }
  let(:comment) { create(:comment, task: task, body: 'body body body', attachment: attachment) }

  let(:params_user) { user }
  let(:params) {
    {
      params: { project_id: project.id, task_id: task.id },
      current_user: params_user,
      resource_params: {}
    }
  }

  describe 'Success' do
    subject(:op) { described_class.call(params) }

    before { comment }

    it 'returns comments' do
      expect(op).to be_success
      expect(op[:model]).to eq [comment]
    end
  end

  describe 'Failure' do
    context 'invalid params' do
      let(:params_user) { nil }
      subject(:op) { described_class.call(params) }

      it 'user is absent' do
        expect{ op }.to raise_error(NoMethodError)
      end
    end
  end
end
