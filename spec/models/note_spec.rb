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
      it { is_expected.to validate_length_of(:content).is_at_most(700) }
    end
  end

  describe '#set_title_if_blank' do
    let(:user) { create(:user) }
    let(:note) { create(:note, title: 'My Title', user: user) }

    context 'when the title is present at creation' do
      it 'does not set title to current date' do
        expect(note.title).to eq('My Title')
      end
    end

    context 'when the title is present on update' do
      it 'does not set title to current date' do
        note.update(title: 'My changed title')
        expect(note.title).to eq('My changed title')
      end
    end

    context 'when title is blank on creation' do
      let(:note_blank) { create(:note, title: '', user: user) }
      let(:note_nil) { create(:note, title: nil, user: user) }

      it 'sets title to current date if title is empty' do
        expect(note_blank.title).to eq(current_date_str)
      end

      it 'sets title to current date if title is nil' do
        expect(note_nil.title).to eq(current_date_str)
      end
    end

    context 'when title is blank on update' do
      it 'sets title to current date if title is empty' do
        note.update(title: '')
        expect(note.title).to eq(current_date_str)
      end

      it 'sets title to current date if title is nil' do
        note.update(title: nil)
        expect(note.title).to eq(current_date_str)
      end
    end
  end
end
