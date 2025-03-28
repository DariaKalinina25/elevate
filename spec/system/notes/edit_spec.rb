# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Notes edit' do
  let(:user) { create(:user) }
  let!(:note) { create(:note, title: 'My note', content: 'My content', user: user) }

  def login_and_visit_edit_note(note)
    login_as(user)
    visit edit_note_path(note)
  end

  def edit_note(title = note.title, content = note.content)
    login_and_visit_edit_note(note)

    fill_in 'note_title', with: title
    fill_in 'note_content', with: content

    click_link_or_button 'Edit'
  end

  context 'when the user is not logged in' do
    it_behaves_like 'denies access to unauthenticated user', edit_note_path(note)
  end

  context 'when a user wants to edit a non-existent note' do
    before do
      login_and_visit_edit_note(-1)
    end

    it 'redirects to index' do
      expect(page).to have_current_path(notes_path, ignore_query: true)
    end

    it 'shows a flash alert about non-existent note' do
      expect(page).to have_css('.custom-alert', text: 'The note does not exist')
    end
  end

  context 'when the user wants to edit another note' do
    let(:other_user) { create(:user) }
    let!(:other_note) { create(:note, title: 'Other note', user: other_user) }

    before do
      login_and_visit_edit_note(other_note)
    end

    it 'redirects to index' do
      expect(page).to have_current_path(notes_path, ignore_query: true)
    end

    it 'shows a flash alert about non-existent note' do
      expect(page).to have_css('.custom-alert', text: 'The note does not exist')
    end
  end

  context 'when the user submits edited data' do
    before { edit_note(' ', 'Edited content') }

    it 'redirects to show' do
      expect(page).to have_current_path(note_path(note), ignore_query: true)
    end

    it 'shows a flash notice about successful editing' do
      expect(page).to have_css('.custom-notice', text: 'Note was successfully updated.')
    end

    it 'displays a title with the update date' do
      expect(page).to have_css('h4', text: today_str)
    end

    it 'displays edited content' do
      expect(page).to have_css('p', text: 'Edited content')
    end
  end

  context 'when the user left the content blank' do
    before { edit_note(note.title, ' ') }

    it 'remains on the page' do
      expect(page).to have_current_path(edit_note_path(note), ignore_query: true)
    end

    # it 'shows content blank error' do
    #   expect(page).to have_content("Content can't be blank")
    # end
  end

  context 'when the user canceled the edit' do
    before do
      login_and_visit_edit_note(note)
      click_link_or_button 'Cancel'
    end

    it 'redirects to show' do
      expect(page).to have_current_path(note_path(note), ignore_query: true)
    end
  end
end
