# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Notes index' do
  let(:user) { create(:user) }

  def login_and_visit_notes
    login_as(user)
    visit notes_path
  end

  def icon_with_link(icon, link)
    "a[href='#{link}'] img[src*='#{icon}']"
  end

  context 'when the user is not logged in' do
    it_behaves_like 'denies access to unauthenticated user', notes_path
  end

  context 'when the user opens the notes page with no notes' do
    before do
      login_and_visit_notes
    end

    it 'shows a plus with a link to creation' do
      expect(page).to have_css(icon_with_link('plus.svg', new_note_path))
    end

    it 'does not show the title' do
      expect(page).to have_no_css('h4', text: 'All Notes')
    end

    it 'does not display notes' do
      expect(page).to have_no_css('.note')
    end
  end

  context 'when the user opens the page with his notes' do
    let!(:note) { create(:note, title: 'My note', user: user) }

    before do
      create_list(:note, 3, user: user)
      login_and_visit_notes
    end

    it 'displays notes' do
      expect(page).to have_css('.note', count: 4)
    end

    context 'when the user clicks on the icons' do
      it 'redirects to create after pressing plus' do
        find(icon_with_link('plus.svg', new_note_path)).click

        expect(page).to have_current_path(new_note_path, ignore_query: true)
      end

      it 'redirects to show after clicking icon' do
        find(icon_with_link('note.svg', note_path(note))).click

        expect(page).to have_current_path(note_path(note), ignore_query: true)
      end
    end
  end
end
