require 'rails_helper'

RSpec.describe Project::Operation::Update do
  let(:user) { create :user }
  let(:name) { FFaker::DizzleIpsum.word }
  let(:project) { create(:project, user: user) }

  before { project }

  describe 'Success' do
    let(:params) {
      {
        name: name
      }
    }

    subject(:op) {
      described_class.call(current_user: user, resource_params: params, params: {id: project.id})
    }

    it 'update project' do
      expect(project.name).not_to eq name
      expect(op).to be_success
      expect(project.reload.name).to eq name
    end
  end

  describe 'Failure' do
    let(:params) {
      {
        name: ''
      }
    }

    subject(:op) {
      described_class.call(current_user: user, resource_params: params, params: {id: project.id})
    }

    it 'validation error' do
      expect(op).to be_failure
      expect(op['contract.default'].errors.messages).to eq(name: ['must be filled'])
    end
  end
end
