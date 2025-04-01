# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Notes show' do
  let(:user) { create(:user) }
  let(:note) { create(:note, title: 'My note', content: 'My content', user: user) }

  def login_and_visit_note(note)
    login_as(user)
    visit note_path(note)
  end

  context 'when the user wants to open another note' do
    let(:other_user) { create(:user) }
    let(:other_note) { create(:note, title: 'Other note', user: other_user) }

    before do
      login_and_visit_note(other_note)
    end

    it 'redirects to root route' do
      expect(page).to have_current_path(root_path, ignore_query: true)
    end

    it 'shows a flash alert about non-existent page' do
      expect(page).to have_css('.custom-alert', text: 'The page or resource does not exist.')
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

    context 'when the user clicks on links or buttons' do
      it 'redirects to index after clicking (To All Notes)' do
        click_link_or_button 'To All Notes'

        expect(page).to have_current_path(notes_path, ignore_query: true)
      end

      it 'redirects to edit after clicking (Edit)' do
        click_link_or_button 'Edit'

        expect(page).to have_current_path(edit_note_path(note), ignore_query: true)
      end
    end
  end

  context 'when the user deletes their note' do
    before do
      login_and_visit_note(note)
      click_link_or_button 'Delete'
    end

    it 'redirects to index' do
      expect(page).to have_current_path(notes_path, ignore_query: true)
    end

    it 'shows a flash notice after successful deletion' do
      expect(page).to have_css('.custom-notice', text: 'Note deleted')
    end

    it 'does not show deleted note' do
      expect(page).not_to have_css('.note-card', text: note.title)
    end
  end
end
