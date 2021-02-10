require 'rails_helper'

RSpec.describe Task::Operation::Destroy do
  let(:user) { create :user }
  let(:name) { FFaker::DizzleIpsum.word }
  let(:project) { create(:project, user: user, name: name) }
  let(:task) { create(:task, project: project, name: name) }

  let(:res_params) { {} }
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

    it 'destroy task' do
      expect { op }.to change(project.tasks, :count).from(1).to(0)
      expect(op).to be_success
      expect(op['model'].name).to eq name
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
