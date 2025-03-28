# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Note do
  describe 'validations' do
    subject { build(:note) }

    context 'when validating title' do
      it { is_expected.to validate_length_of(:title).is_at_most(10) }
    end

    context 'when validating password' do
      it { is_expected.to validate_presence_of(:content) }
      it { is_expected.to validate_length_of(:content).is_at_most(700) }
    end
  end

  describe '#set_title_if_blank' do
    let(:user) { create(:user) }
    let(:note) { create(:note, user: user) }
    let(:note_blank) { build(:note, title: '', user: user) }
    let(:note_nil) { build(:note, title: nil, user: user) }

    context 'when title is blank on creation' do
      it 'sets title to current date if title is empty' do
        note_blank.save
        expect(note_blank.title).to eq(today_str)
      end

      it 'sets title to current date if title is nil' do
        note_nil.save
        expect(note_nil.title).to eq(today_str)
      end
    end

    context 'when title is blank on update' do
      it 'sets title to current date if title is empty' do
        note.update(title: '')
        expect(note.title).to eq(today_str)
      end

      it 'sets title to current date if title is nil' do
        note.update(title: nil)
        expect(note.title).to eq(today_str)
      end
    end
  end
end
