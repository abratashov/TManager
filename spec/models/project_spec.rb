require 'rails_helper'

RSpec.describe Project, type: :model do
  context 'validation & association' do
    before { build(:project) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }

    it { is_expected.to belong_to(:user) }

    it { is_expected.to have_many(:tasks).dependent(:destroy) }
  end
end
