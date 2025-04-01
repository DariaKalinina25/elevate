# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Notes index' do
  let(:user) { create(:user) }

  def login_and_visit_notes
    login_as(user)
    visit notes_path
  end

  context 'when unauthenticated' do
    before {  visit notes_path }

    it 'redirects to login page' do
      expect(page).to have_current_path(new_user_session_path, ignore_query: true)
    end

    it 'displays a flash alert' do
      expect(page).to have_css('.custom-alert', text: t('devise.failure.unauthenticated'))
    end
  end

  context 'when user has no notes' do
    before do
      login_and_visit_notes
    end

    it 'redirects to new note page after clicking the link' do
      find_test('new-note-link').click

      expect(page).to have_current_path(new_note_path, ignore_query: true)
    end

    it 'shows no note cards' do
      expect(page).to have_no_css('.note-card')
    end
  end

  context 'when user has notes' do
    let!(:note) { create(:note, title: 'My note', user: user) }

    before do
      create_list(:note, 3, user: user)
      login_and_visit_notes
    end

    it 'displays all notes' do
      expect(page).to have_css('.note-card', count: 4)
    end

    context 'when clicking links' do
      it 'redirects to new note page' do
        find_test('new-note-link').click

        expect(page).to have_current_path(new_note_path, ignore_query: true)
      end

      it 'redirects to note details' do
        find_test('show-note-link', text: note.title).click

        expect(page).to have_current_path(note_path(note), ignore_query: true)
      end
    end
  end
end
