# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User Registration' do
  let(:user) { build(:user) }
  let(:existing_user) { create(:user) }

  def register_as_user(email, password, password_confirmation)
    visit new_user_registration_path

    fill_in 'Email', with: email
    fill_in 'Password', with: password
    fill_in 'Password confirmation', with: password_confirmation

    click_link_or_button 'Sign up'
  end

  shared_examples 'user stays on sign-up form' do
    it 'does not leave the sign-up form' do
      expect(page).to have_field('user[password_confirmation]')
    end
  end

  context 'when user submits valid data' do
    before { register_as_user(user.email, user.password, user.password) }

    it 'redirects to the homepage' do
      expect(page).to have_current_path(root_path)
    end

    it 'shows a flash notice for successful registration' do
      expect(page).to have_css('.custom-notice', text: 'Welcome! You have signed up successfully.')
    end
  end

  context 'when password confirmation does not match' do
    before { register_as_user(user.email, user.password, 'invalid_confirmation') }

    include_examples 'user stays on sign-up form'

    it 'shows password confirmation mismatch error' do
      expect(page).to have_css('.alert.alert-danger', text: "Password confirmation doesn't match Password")
    end
  end

  context 'when password is too short' do
    before { register_as_user(user.email, 'short', 'short') }

    include_examples 'user stays on sign-up form'

    it 'shows password too short error' do
      expect(page).to have_css('.alert.alert-danger', text: 'Password is too short (minimum is 6 characters)')
    end
  end
end
