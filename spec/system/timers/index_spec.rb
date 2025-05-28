# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Timers index' do
  let(:user) { create(:user) }
  let(:title) { 'Timer' }

  def login_and_visit_timers
    login_as(user)
    visit timers_path
  end

  def start_timer(title)
    find_test('title-timer-field').fill_in(with: title)
    fill_input_by_testid('duration-timer-field', '00:00:03')
    find_test('start-timer-button').click
  end

  def stop_timer
    find_test('stop-timer-button').click
  end

  shared_examples 'default timer view state' do
    it 'shows the title input field' do
      expect(page).to have_test('title-timer-field')
    end

    it 'hides the timer title' do
      expect(page).not_to have_test('title-timer')
    end

    it 'shows a field for entering time' do
      expect(page).to have_test('duration-timer-field')
    end

    it 'hides the timer output' do
      expect(page).not_to have_test('timer-field')
    end

    it 'shows the start button' do
      expect(page).to have_test('start-timer-button')
    end

    it 'hides the stop button' do
      expect(page).not_to have_test('stop-timer-button')
    end
  end

  shared_examples 'empty story section' do
    it 'displays message about absence of timers' do
      expect(page).to have_text(t('time_tracker.no_story'))
    end

    it 'does not display story' do
      expect(page).to have_no_css('.timer-story')
    end
  end

  context 'when unauthenticated' do
    before { visit timers_path }

    it 'redirects to login page' do
      expect(page).to have_current_path(new_user_session_path, ignore_query: true)
    end

    it 'displays a flash alert' do
      expect(page).to have_css('.custom-alert', text: t('devise.failure.unauthenticated'))
    end
  end

  context 'when user opens the timers page' do
    before { login_and_visit_timers }

    it_behaves_like 'default timer view state'
    it_behaves_like 'empty story section'
  end

  context 'when user starts a new timer', :js do
    before do
      login_and_visit_timers
      start_timer(title)
    end

    it 'displays the entered timer title' do
      expect(find_test('title-timer')).to have_text(title)
    end

    it 'hides the title input field' do
      expect(page).not_to have_test('title-timer-field')
    end

    it 'shows a running timer' do
      expect(find_test('timer-field')).to have_text(t('time_tracker.elapsed', h: 0, m: 0, s: 3), wait: 2)
    end

    it 'hides the time input field' do
      expect(page).not_to have_test('duration-timer-field')
    end

    it 'shows the stop button' do
      expect(page).to have_test('stop-timer-button')
    end

    it 'hides the start button' do
      expect(page).not_to have_test('start-timer-button')
    end

    it 'displays message about absence of timers' do
      expect(page).to have_text(t('time_tracker.no_story'))
    end

    it 'does not display the running timer in story list' do
      expect(page).to have_no_css('.timer-story', text: title)
    end
  end

  context 'when user stops the running timer', :js do
    before do
      login_and_visit_timers
      start_timer(title)
      stop_timer
    end

    it_behaves_like 'default timer view state'

    it 'adds the stopped timer to the story' do
      expect(page).to have_css('.timer-story', text: title)
    end

    it 'hides the message about no timers' do
      expect(page).to have_no_text(t('time_tracker.no_story'))
    end

    context 'when user deletes the timer from the story' do
      before do
        within('.timer-story', text: title) do
          find_test('delete-timer-button').click
        end
      end

      it_behaves_like 'empty story section'
    end
  end

  # JS does not call finish — travel_to only changes server time, not browser time
  context 'when stop was not called by JS', :js do
    before do
      login_and_visit_timers
      start_timer('first')

      travel_to(5.seconds.from_now) do
        visit current_path

        start_timer('second')
      end
    end

    it 'adds previous expired timer to the story after creating new one' do
      expect(page).to have_css('.timer-story', text: 'first')
    end
  end
end
