require 'rails_helper'

RSpec.describe Task::Operation::Create do
  let(:user) { create :user }
  let(:name) { FFaker::DizzleIpsum.word }
  let(:project) { create(:project, user: user) }

  let(:params_name) { name }
  let(:res_params) {
    {
      name: params_name,
      deadline: Date.parse('3030-03-03'),
      position: 2,
      done: false,
    }
  }
  let(:params_user) { user }
  let(:params) {
    {
      params: { project_id: project.id },
      current_user: params_user,
      resource_params: res_params
    }
  }

  describe 'Success' do
    subject(:op) { described_class.call(params) }

    it 'create task' do
      expect { op }.to change(project.tasks, :count).from(0).to(1)
      expect(op).to be_success
    end
  end

  describe 'Failure' do
    let(:params_name) { '' }

    subject(:op) { described_class.call(params) }

    it 'validation error' do
      expect(op).to be_failure
      expect(op['contract.default'].errors.messages).to eq(name: ['must be filled'])
    end
  end
end
