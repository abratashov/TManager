require 'rails_helper'

RSpec.describe Task, type: :model do
  context 'validation & association' do
    before { FactoryGirl.build(:task) }

    it { is_expected.to belong_to(:project) }

    it { is_expected.to have_many(:comments).dependent(:destroy) }
  end

  context 'acts_as_list' do
    let(:task1) { FactoryGirl.create(:task) }
    let(:task2) { FactoryGirl.create(:task) }

    it 'move bottom' do
      task1.update_position(2)
      expect(task1.position).to eq 2
    end
  end

end
