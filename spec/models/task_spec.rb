require 'rails_helper'

RSpec.describe Task, type: :model do
  context 'validation & association' do
    before { build(:task) }

    it { is_expected.to validate_presence_of(:name) }

    it { is_expected.to belong_to(:project) }

    it { is_expected.to have_many(:comments).dependent(:destroy) }
  end

  context 'acts_as_list' do
    let(:task1) { create(:task, position: 1) }
    let(:task2) { create(:task, project: task1.project, position: 2) }

    it 'move bottom' do
      expect(task1.position).to eq 1
      expect(task2.position).to eq 2
      task1.insert_at(2)
      task2.reload
      expect(task1.position).to eq 2
      expect(task2.position).to eq 1
    end
  end

end
