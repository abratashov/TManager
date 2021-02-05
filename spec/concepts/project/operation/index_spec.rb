require 'rails_helper'

RSpec.describe Project::Operation::Index do
  let(:user) { create :user }
  let(:project) { create(:project, user: user) }

  describe 'Success' do
    subject(:op) { described_class.call(params: {}, current_user: user) }

    before { project }

    it 'returns projects' do
      expect(op).to be_success
      expect(op[:model]).to eq [project]
    end
  end

  describe 'Failure' do
    context 'invalid params' do
      subject(:op) { described_class.call(params: {}, current_user: nil) }

      let(:error) { 'user not present' }

      it 'user is absent' do
        expect(op).to be_failure
        expect(op['result.notify']).to match error
      end
    end
  end
end
