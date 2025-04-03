# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User session' do
  let(:user) { create(:user) }

  let(:email) { user.email }
  let(:password) { user.password }

  def login_as_user(email, password)
    visit new_user_session_path

    find_test('email_field').fill_in(with: email)
    find_test('password_field').fill_in(with: password)

    find_test('login-button').click
  end

  context 'when the user submits valid data' do
    before { login_as_user(email, password) }

    it 'redirects to home page' do
      expect(page).to have_current_path(root_path, ignore_query: true)
    end

    it 'displays a flash notice' do
      expect(page).to have_css('.custom-notice', text: t('devise.sessions.signed_in'))
    end
  end

  context 'when the user enters invalid data' do
    before { login_as_user('wrong@example.com', 'wrongpassword') }

    it 'stays on the login page' do
      expect(page).to have_current_path(new_user_session_path, ignore_query: true)
    end

    it 'displays a flash alert' do
      expect(page).to have_css('.custom-alert', text: t('devise.failure.invalid', authentication_keys: human_name(User, :email)))
    end
  end

  context 'when the user signs out' do
    before do
      login_as_user(email, password)
      find_test('sign_out-button').click
    end

    it 'redirects to home page' do
      expect(page).to have_current_path(root_path, ignore_query: true)
    end

    it 'displays a flash notice' do
      expect(page).to have_css('.custom-notice', text: t('devise.sessions.signed_out'))
    end
  end
end
