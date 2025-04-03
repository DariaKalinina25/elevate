# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User Registration' do
  let(:user) { build(:user) }

  let(:email) { user.email }
  let(:password) { user.password }

  def register_as_user(email, password, password_confirmation)
    visit new_user_registration_path

    find_test('email_field').fill_in(with: email)
    find_test('password_field').fill_in(with: password)
    find_test('password_confirmation_field').fill_in(with: password_confirmation)

    find_test('sign_up-button').click
  end

  context 'when the user submits valid data' do
    before { register_as_user(email, password, password) }

    it 'redirects to home page' do
      expect(page).to have_current_path(root_path, ignore_query: true)
    end

    it 'displays a flash notice' do
      expect(page).to have_css('.custom-notice', text: t('devise.registrations.signed_up'))
    end
  end

  context 'when the user enters invalid data' do
    before { register_as_user(email, password, 'invalid_confirmation') }

    it 'stays on the sign_up page' do
      expect(page).to have_css('h4', text: t('devise.sign_up'))
    end

    it 'shows an error message' do
      expect(find_test('error')).to have_content(error_message(User, :password_confirmation, :confirmation,
                                                               attribute: :password))
    end
  end
end
