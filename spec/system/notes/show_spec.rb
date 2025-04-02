# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Notes show' do
  let(:user) { create(:user) }

  let(:note) { create(:note, title: 'My note', content: 'My content', user: user) }

  def login_and_visit_note(note)
    login_as(user)
    visit note_path(note)
  end

  context 'when opening a note owned by another user' do
    let(:other_user) { create(:user) }
    let(:other_note) { create(:note, title: 'Other note', user: other_user) }

    before do
      login_and_visit_note(other_note)
    end

    it 'redirects to home page' do
      expect(page).to have_current_path(root_path, ignore_query: true)
    end

    it 'displays a flash alert' do
      expect(page).to have_css('.custom-alert', text: t('errors.not_found'))
    end
  end

  context 'when the user opens their note' do
    before do
      login_and_visit_note(note)
    end

    it 'shows the title' do
      expect(page).to have_css('h4', text: note.title)
    end

    it 'shows the content' do
      expect(page).to have_css('p', text: note.content)
    end

    context 'when clicking buttons or links' do
      it 'redirects to all notes page' do
        find_test('all-notes-link').click

        expect(page).to have_current_path(notes_path, ignore_query: true)
      end

      it 'redirects to the edit page' do
        find_test('edit-note-link').click

        expect(page).to have_current_path(edit_note_path(note), ignore_query: true)
      end
    end
  end

  context 'when the user deletes their note' do
    before do
      login_and_visit_note(note)
      find_test('delete-note-button').click
    end

    it 'redirects to all notes page' do
      expect(page).to have_current_path(notes_path, ignore_query: true)
    end

    it 'displays a flash notice' do
      expect(page).to have_css('.custom-notice', text: t('note.notice.delete'))
    end
  end
end
