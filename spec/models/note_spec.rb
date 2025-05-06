# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Note do
  describe 'validations' do
    subject { build(:note) }

    context 'when validating title' do
      it { is_expected.to validate_length_of(:title).is_at_most(10) }
    end

    context 'when validating content' do
      it { is_expected.to validate_presence_of(:content) }
      it { is_expected.to validate_length_of(:content).is_at_most(2000) }
    end

    context 'when user already has 20 notes' do
      let_it_be(:user) { create(:user) }
      let(:note) { build(:note, user: user) }

      before do
        # rubocop:disable FactoryBot/ExcessiveCreateList
        create_list(:note, 20, user: user)
        # rubocop:enable FactoryBot/ExcessiveCreateList
      end

      it 'is not valid' do
        expect(note).not_to be_valid
      end

      it 'adds base error' do
        note.valid?
        expect(note.errors[:base]).to include(I18n.t('note.errors.notes_limit'))
      end
    end
  end
end
