require 'rails_helper'

RSpec.describe Project::Operation::Create do
  let(:user) { create :user }

  describe 'Success' do
    let(:name) { FFaker::DizzleIpsum.word }
    let(:params) {
      {
        name: name
      }
    }

    subject(:op) { described_class.call(current_user: user, resource_params: params, params: {}) }

    it 'create project' do
      expect { op }.to change(user.projects, :count).from(0).to(1)
      expect(op).to be_success
    end
  end

  describe 'Failure' do
    let(:params) {
      {
        name: ''
      }
    }

    subject(:op) { described_class.call(current_user: user, resource_params: params, params: {}) }

    it 'validation error' do
      expect(op).to be_failure
      expect(op['contract.default'].errors.messages).to eq(name: ['must be filled'])
    end
  end
end
