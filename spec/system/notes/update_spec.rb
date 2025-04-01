# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Notes update' do
  let(:user) { create(:user) }

  let!(:note) { create(:note, title: 'My note', content: 'My content', user: user) }

  let(:title) { 'Edited' }
  let(:content) { 'Edited' }

  def login_and_visit_edit_note(note)
    login_as(user)
    visit edit_note_path(note)
  end

  def edit_note(title = note.title, content = note.content)
    login_and_visit_edit_note(note)

    find_test('title-field').fill_in(with: title)
    find_test('content-field').fill_in(with: content)

    find_test('save-note-button').click
  end

  context 'when opening a note owned by another user' do
    let(:other_user) { create(:user) }
    let(:other_note) { create(:note, title: 'Other note', user: other_user) }

    before do
      login_and_visit_edit_note(other_note)
    end

    it 'redirects to home page' do
      expect(page).to have_current_path(root_path, ignore_query: true)
    end

    it 'displays a flash alert' do
      expect(page).to have_css('.custom-alert', text: t('errors.not_found'))
    end
  end

  context 'when the user leaves the title blank' do
    before { edit_note(' ', content) }

    it 'redirects to note details' do
      expect(page).to have_current_path(note_path(note), ignore_query: true)
    end

    it 'displays a flash notice' do
      expect(page).to have_css('.custom-notice', text: t('note.notice.update'))
    end

    it 'uses the current date as a title' do
      expect(page).to have_css('h4', text: current_date_str)
    end
  end

  context 'when the user leaves the content blank' do
    before { edit_note(title, ' ') }

    it 'stays on the edit note page' do
      expect(page).to have_css('h4', text: t('note.edit.title'))
    end

    it 'shows a content blank error' do
      expect(find_test('error')).to have_content(error_message(Note, :content, :blank))
    end
  end

  context 'when the user submits valid data' do
    before { edit_note(title, content) }

    it 'redirects to note details' do
      expect(page).to have_current_path(note_path(note), ignore_query: true)
    end

    it 'displays a flash notice' do
      expect(page).to have_css('.custom-notice', text: t('note.notice.update'))
    end

    it 'displays the note title' do
      expect(page).to have_css('h4', text: title)
    end
  end

  context 'when a user cancels editing a note' do
    it 'redirects to all notes page' do
      login_and_visit_edit_note(note)

      find_test('cancel-note-button').click

      expect(page).to have_current_path(notes_path, ignore_query: true)
    end
  end
end
