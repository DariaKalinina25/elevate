# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Notes create' do
  let(:user) { create(:user) }
  let(:note) { build(:note, title: 'My note', content: 'My content', user: user) }

  def create_note(title, content)
    login_as(user)

    visit new_note_path

    fill_in 'note_title', with: title
    fill_in 'note_content', with: content

    click_link_or_button 'Save'
  end

  context 'when the user is not logged in' do
    it_behaves_like 'unauthenticated access', new_note_path
  end

  context 'when the user left the title blank' do
    before { create_note(' ', note.content) }

    it 'redirects to the note page' do
      expect(page).to have_current_path(note_path(Note.last), ignore_query: true)
    end

    it 'shows a flash notice about successful creation' do
      expect(page).to have_css('.custom-notice', text: 'Note was successfully created.')
    end

    it 'displays the created note title' do
      expect(page).to have_css('h4', text: Date.current.strftime('%d.%m.%Y'))
    end
  end

  context 'when the user left the content blank' do
    before { create_note(note.title,  ' ') }

    it 'remains on the creation page' do
      expect(page).to have_current_path(new_note_path, ignore_query: true)
    end

    # it 'shows content blank error' do
    #   expect(page).to have_content("Content can't be blank")
    # end
  end

  context 'when the user has entered valid data' do
    before { create_note(note.title, note.content) }

    it 'redirects to the note page' do
      expect(page).to have_current_path(note_path(Note.last), ignore_query: true)
    end

    it 'shows a flash notice about successful creation' do
      expect(page).to have_css('.custom-notice', text: 'Note was successfully created.')
    end

    it 'displays the created note title' do
      expect(page).to have_css('h4', text: note.title)
    end
  end

  context 'when the user wants to cancel the creation of a note' do
    before do
      login_as(user)
      visit new_note_path
      click_link_or_button 'Cancel'
    end

    it 'redirects to the notes page' do
      expect(page).to have_current_path(notes_path, ignore_query: true)
    end
  end
end
