# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Notes index' do
  let(:user) { create(:user) }

  context 'when the user is not logged in' do
    before { visit notes_path }

    it 'redirects unauthenticated user to login' do
      expect(page).to have_current_path(new_user_session_path, ignore_query: true)
    end

    it 'shows unauthenticated message' do
      expect(page).to have_content I18n.t('devise.failure.unauthenticated')
    end
  end

  context 'when user logged in but no notes' do
    before do
      login_as(user)
      visit notes_path
    end

    it 'shows a plus icon linking to the new note form' do
      expect(page).to have_css("a[href='#{new_note_path}'] img[src*='plus.svg']")
    end

    it 'does not show the title' do
      expect(page).to have_no_css('h4', text: 'All Notes')
    end

    it 'does not display any notes' do
      expect(page).to have_no_css('.note')
    end
  end

  context 'when the user logged in' do
    let!(:note) { create(:note, title: 'My note', user: user) }

    before do
      create_list(:note, 3, user: user)
      login_as(user)
      visit notes_path
    end

    it 'shows a plus icon linking to the new note form' do
      expect(page).to have_css("a[href='#{new_note_path}'] img[src*='plus.svg']")
    end

    it 'shows a clickable icon linking to the note' do
      expect(page).to have_css("a[href='#{note_path(note)}'] img[src*='note.svg']")
    end

    it 'displays all user notes' do
      expect(page).to have_css('.note', count: 4)
    end
  end
end
