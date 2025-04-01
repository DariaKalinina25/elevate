# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Notes create' do
  let(:user) { create(:user) }
  
  let(:title) { 'My note' }
  let(:content) { 'My content' }

  def login_and_visit_new_note
    login_as(user)
    visit new_note_path
  end

  def create_note(title, content)
    login_and_visit_new_note

    find_test('title-field').fill_in(with: title)
    find_test('content-field').fill_in(with: content)
    
    find_test('save-note-button').click
  end

  context 'when the user leaves the title blank' do
    before { create_note(' ', content) }

    it 'redirects to note details' do
      expect(page).to have_current_path(note_path(Note.last), ignore_query: true)
    end

    it 'displays a flash notice' do
      expect(page).to have_css('.custom-notice', text: t('note.notice.create'))
    end

    it 'uses the creation date as the note title' do
      expect(page).to have_css('h4', text: current_date_str)
    end
  end

  context 'when the user leaves the content blank' do
    before { create_note(title, ' ') }

    it 'stays on the new note page' do
      expect(page).to have_css('h4', text: t('note.new.title'))
    end

    it 'shows a content blank error' do
      expect(find_test('error')).to have_content(error_message(Note, :content, :blank))
    end
  end

  context 'when the user submits valid data' do
    before { create_note(title, content) }

    it 'redirects to note details' do
      expect(page).to have_current_path(note_path(Note.last), ignore_query: true)
    end

    it 'displays a flash notice' do
      expect(page).to have_css('.custom-notice', text: t('note.notice.create'))
    end

    it 'displays the note title' do
      expect(page).to have_css('h4', text: title)
    end
  end

  context 'when the user cancels note creation' do
    it 'redirects to all notes page' do
      login_and_visit_new_note

      find_test('cancel-note-button').click

      expect(page).to have_current_path(notes_path, ignore_query: true)
    end
  end
end
