require 'rails_helper'

RSpec.describe Task::Contract::Create do
  let(:user) { build :user }
  let(:name) { FFaker::DizzleIpsum.word }
  let(:project) { build(:project, user: user, name: name) }
  let(:task) { build(:task, project: project, name: name) }

  describe 'Success' do
    let(:form) { described_class.new(task) }

    it { expect(form.valid?).to be_truthy }
  end

  describe 'Failure' do
    let(:form) { described_class.new(project_dup) }

    let(:task_without_name) { build(:task, project: project, name: nil) }
    let(:form_without_name) { described_class.new(task_without_name) }

    it 'name not present' do
      expect(form_without_name.valid?).to be_falsey
      expect(form_without_name.errors.messages).to eq(name: ['must be filled'])
    end
  end
end
