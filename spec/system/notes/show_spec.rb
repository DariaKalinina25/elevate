# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Note show' do
  let(:user) { create(:user) }
  let!(:note) { create(:note, title: 'My note', content: 'My content', user: user) }

  context 'when the user is not logged in' do
    before { visit note_path(note) }

    it 'redirects unauthenticated user to login' do
      expect(page).to have_current_path(new_user_session_path, ignore_query: true)
    end

    it 'shows unauthenticated message' do
      expect(page).to have_content I18n.t('devise.failure.unauthenticated')
    end
  end

  context 'when the user tries to view a non-existent note' do
    before do
      login_as(user)
      visit note_path(-1)
    end

    it 'redirects to index' do
      expect(page).to have_current_path(notes_path, ignore_query: true)
    end

    it 'shows message about non-existent note' do
      expect(page).to have_content 'The note does not exist'
    end
  end

  context 'when the user wants to view another note' do
    let(:other_user) { create(:user) }
    let(:other_note) { create(:note, title: 'Other note', user: other_user) }

    before do
      login_as(user)
      visit note_path(other_note)
    end

    it 'redirects to index' do
      expect(page).to have_current_path(notes_path, ignore_query: true)
    end
  end

  context 'when the user logged in' do
    before do
      login_as(user)
      visit note_path(note)
    end

    it 'shows the title' do
      expect(page).to have_css('h4', text: note.title)
    end

    it 'shows the content' do
      expect(page).to have_css('h4', text: note.content)
    end

    it 'shows link To All Notes' do
      expect(page).to have_link('To All Notes', href: notes_path)
    end

    it 'shows link Edit' do
      expect(page).to have_link('Edit', href: edit_note_path(note))
    end

    it 'shows link Delete' do
      expect(page).to have_link('Delete', href: note_path(note))
    end
  end
end
