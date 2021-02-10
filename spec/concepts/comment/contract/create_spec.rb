require 'rails_helper'

RSpec.describe Comment::Contract::Create do
  let(:user) { build :user }
  let(:name) { FFaker::DizzleIpsum.word }
  let(:project) { build(:project, user: user, name: name) }
  let(:task) { build(:task, project: project, name: name) }

  let(:filename) { 'small.png' }
  let(:attachment) { fixture_file_uploader("files/#{filename}") }
  let(:comment) { build(:comment, task: task, body: 'body body body', attachment: attachment) }

  describe 'Success' do
    let(:form) { described_class.new(comment) }

    it { expect(form.valid?).to be_truthy }
  end

  describe 'Failure' do
    let(:invalid_comment) { build(:comment, task: task, body: 'body') }
    let(:invalid_form) { described_class.new(invalid_comment) }

    it 'name not present' do
      expect(invalid_form.valid?).to be_falsey
      expect(invalid_form.errors.messages).to eq(body: ['size cannot be less than 10',
                                                        'size cannot be greater than 256'])
    end
  end
end
