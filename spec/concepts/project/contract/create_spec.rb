require 'rails_helper'

RSpec.describe Project::Contract::Create do
  let(:user) { create :user }
  let(:name) { FFaker::DizzleIpsum.word }
  let(:project) { create(:project, user: user, name: name) }
  let(:project_dup) { build(:project, user: user, name: name) }

  describe 'Success' do
    let(:form) { described_class.new(project) }

    it { expect(form.valid?).to be_truthy }
  end

  describe 'Failure' do
    let(:form) { described_class.new(project_dup) }

    let(:project_without_name) { build(:project, user: user, name: nil) }
    let(:form_without_name) { described_class.new(project_without_name) }

    before { project }

    it 'name not uniq' do
      expect(form.valid?).to be_falsey
      expect(form.errors.messages).to eq(name: ['exists already, it should be unique'])
    end

    it 'name not present' do
      expect(form_without_name.valid?).to be_falsey
      expect(form_without_name.errors.messages).to eq(name: ['must be filled'])
    end
  end
end
