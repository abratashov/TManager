require 'rails_helper'

RSpec.describe Project::Operation::Show do
  let(:user) { create :user }
  let(:name) { FFaker::DizzleIpsum.word }
  let(:project) { create(:project, user: user, name: name) }
  let(:params) { {} }

  before { project }

  describe 'Success' do
    subject(:op) {
      described_class.call(current_user: user, resource_params: params, params: {id: project.id})
    }

    it 'show project' do
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
