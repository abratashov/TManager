require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validation & association' do
    before { build(:user) }

    it { is_expected.to validate_length_of(:username).is_at_least(3).is_at_most(50) }
    it { is_expected.to have_many(:projects).dependent(:destroy) }

    it { is_expected.to allow_value('UserName01').for(:username) }
    it { is_expected.not_to allow_value('-zA-Z0-9*').for(:username) }

    it { is_expected.to allow_value('Pass0001').for(:password) }
    it { is_expected.not_to allow_value('Passw0001').for(:password) }
  end
end
