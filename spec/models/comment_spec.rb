require 'rails_helper'

RSpec.describe Comment, type: :model do
  context 'validation & association' do
    before { build(:comment) }

    it { is_expected.to belong_to(:task).counter_cache(true) }
    it { is_expected.to validate_length_of(:body).is_at_least(10).is_at_most(256) }

    context 'validation an attachment' do
      let(:comment) { create(:comment) }

      let(:attachment_small) { fixuter_file_uploader('files/small.png') }
      let(:attachment_big) { fixuter_file_uploader('files/big.jpg') }
      let(:attachment_invalid) { fixuter_file_uploader('files/invalid.gif') }

      it 'valid attachment' do
        comment.attachment = attachment_small
        expect(comment.save).to be_truthy
      end

      it 'invalid size attachment' do
        comment.attachment = attachment_big
        comment.save
        expect(comment.errors.messages[:attachment]).to include(include('size should be less than'))
      end

      it 'invalid type attachment' do
        comment.attachment = attachment_invalid
        comment.save
        expect(comment.errors.messages[:attachment]).to include(include('You are not allowed to upload'))
      end
    end
  end
end
