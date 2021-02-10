require 'rails_helper'

RSpec.describe Task::Operation::Update do
  let(:user) { create :user }
  let(:name) { FFaker::DizzleIpsum.word }
  let(:project) { create(:project, user: user) }
  let(:task) { create(:task, project: project) }

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
      params: { project_id: project.id, id: task.id },
      current_user: params_user,
      resource_params: res_params
    }
  }

  before { task }

  describe 'Success' do
    subject(:op) { described_class.call(params) }

    it 'update task' do
      expect(task.name).not_to eq name
      expect(op).to be_success
      expect(task.reload.attributes.symbolize_keys.slice(*res_params.keys)).to eq res_params.slice(*res_params.keys)
    end
  end

  describe 'Failure' do
    let(:params_name) { '' }

    subject(:op) {
      described_class.call(params)
    }

    it 'validation error' do
      expect(op).to be_failure
      expect(op['contract.default'].errors.messages).to eq(name: ['must be filled'])
    end
  end
end
