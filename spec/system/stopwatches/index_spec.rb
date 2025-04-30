# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Stopwatches index' do
  let(:user) { create(:user) }
  let(:title) { 'Stopwatch' }

  def login_and_visit_stopwatches
    login_as(user)
    visit stopwatches_path
  end

  def start_stopwatch
    find_test('title-stopwatch-field').fill_in(with: title)
    find_test('start-stopwatch-button').click
  end

  def stop_stopwatch
    find_test('stop-stopwatch-button').click
  end

  shared_examples 'default stopwatch view state' do
    it 'shows the title input field' do
      expect(page).to have_test('title-stopwatch-field')
    end

    it 'hides the stopwatch title' do
      expect(page).not_to have_test('title-stopwatch')
    end

    it 'shows stopwatch with initial value' do
      expect(find_test('stopwatch-field')).to have_text(t('time_tracker.elapsed', h: 0, m: 0, s: 0))
    end

    it 'shows the start button' do
      expect(page).to have_test('start-stopwatch-button')
    end

    it 'hides the stop button' do
      expect(page).not_to have_test('stop-stopwatch-button')
    end
  end

  shared_examples 'empty story section' do
    it 'displays message about absence of stopwatches' do
      expect(page).to have_text(t('time_tracker.no_story'))
    end

    it 'does not display story' do
      expect(page).to have_no_css('.stopwatch-story')
    end
  end

  context 'when unauthenticated' do
    before { visit stopwatches_path }

    it 'redirects to login page' do
      expect(page).to have_current_path(new_user_session_path, ignore_query: true)
    end

    it 'displays a flash alert' do
      expect(page).to have_css('.custom-alert', text: t('devise.failure.unauthenticated'))
    end
  end

  context 'when user opens the stopwatches page' do
    before { login_and_visit_stopwatches }

    include_examples 'default stopwatch view state'
    include_examples 'empty story section'
  end

  context 'when user starts a new stopwatch', :js do
    before do
      login_and_visit_stopwatches
      start_stopwatch
    end

    it 'displays the entered stopwatch title' do
      expect(find_test('title-stopwatch')).to have_text(title)
    end

    it 'hides the title input field' do
      expect(page).not_to have_test('title-stopwatch-field')
    end

    it 'updates the running stopwatch timer' do
      expect(find_test('stopwatch-field')).to have_text(t('time_tracker.elapsed', h: 0, m: 0, s: 1), wait: 3)
    end

    it 'shows the stop button' do
      expect(page).to have_test('stop-stopwatch-button')
    end

    it 'hides the start button' do
      expect(page).not_to have_test('start-stopwatch-button')
    end

    it 'displays message about absence of stopwatches' do
      expect(page).to have_text(t('time_tracker.no_story'))
    end

    it 'does not display the running stopwatch in story list' do
      expect(page).to have_no_css('.stopwatch-story', text: title)
    end
  end

  context 'when user stops the running stopwatch', :js do
    before do
      login_and_visit_stopwatches
      start_stopwatch
      stop_stopwatch
    end

    include_examples 'default stopwatch view state'

    it 'adds the stopped stopwatch to the story' do
      expect(page).to have_css('.stopwatch-story', text: title)
    end

    it 'hides the message about no stopwatches' do
      expect(page).to have_no_text(t('time_tracker.no_story'))
    end

    context 'when user deletes the stopwatch from the story' do
      before do
        within('.stopwatch-story', text: title) do
          find_test('delete-stopwatch-button').click
        end
      end

      include_examples 'empty story section'
    end
  end
end
