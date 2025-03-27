# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User session' do
  let(:user) { create(:user) }

  def login_as_user(email, password)
    visit new_user_session_path

    fill_in 'Email', with: email
    fill_in 'Password', with: password

    click_button 'Login'
  end

  shared_examples 'remains on the login page' do
    it 'remains on the login page' do
      expect(page).to have_current_path(new_user_session_path, ignore_query: true)
    end
  end

  shared_examples 'invalid login or email error' do
    it 'shows flash alert for email and password error' do
      expect(page).to have_css('.custom-alert', text: 'Invalid Email or password.')
    end
  end

  context 'when user submits valid data' do
    before { login_as_user(user.email, user.password) }

    it 'redirects to the homepage' do
      expect(page).to have_current_path(root_path)
    end

    it 'shows a flash notice for successful login' do
      expect(page).to have_css('.custom-notice', text: 'Signed in successfully')
    end
  end

  context 'when email is empty' do
    before { login_as_user('', user.password) }

    include_examples 'remains on the login page'

    include_examples 'invalid login or email error'
  end

  context 'when password is empty' do
    before { login_as_user(user.email, '') }

    include_examples 'remains on the login page'

    include_examples 'invalid login or email error'
  end

  context 'when email does not exist in database' do
    before { login_as_user('invalid_email@example.com', user.password) }

    include_examples 'remains on the login page'

    include_examples 'invalid login or email error'
  end

  context 'when the password is not correct' do
    before { login_as_user(user.email, 'invalid_password') }

    include_examples 'remains on the login page'

    include_examples 'invalid login or email error'
  end

  context 'when user logs out after login' do
    before do
      login_as_user(user.email, user.password)
      click_button 'Sign out'
    end

    it 'redirects to the homepage' do
      expect(page).to have_current_path(root_path)
    end

    it 'shows a flash notice for successful logout' do
      expect(page).to have_css('.custom-notice', text: 'Signed out successfully')
    end
  end
end
