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

    it 'shows successful registration message' do
      expect(page).to have_content 'Welcome! You have signed up successfully.'
    end
  end

  context 'when email is empty' do
    before { register_as_user('', user.password, user.password) }

    include_examples 'user stays on sign-up form'

    it 'shows email blank error' do
      expect(page).to have_content "Email can't be blank"
    end
  end

  context 'when password is empty' do
    before { register_as_user(user.email, '', '') }

    include_examples 'user stays on sign-up form'

    it 'shows password blank error' do
      expect(page).to have_content "Password can't be blank"
    end
  end

  context 'when email is already taken' do
    before { register_as_user(existing_user.email, existing_user.password, existing_user.password) }

    include_examples 'user stays on sign-up form'

    it 'shows email already taken message' do
      expect(page).to have_content 'Email has already been taken'
    end
  end

  context 'when email is invalid' do
    before { register_as_user('invalid_email', user.password, user.password) }

    include_examples 'user stays on sign-up form'

    it 'shows email invalid error' do
      expect(page).to have_content 'Email is invalid'
    end
  end

  context 'when password confirmation does not match' do
    before { register_as_user(user.email, user.password, 'invalid_confirmation') }

    include_examples 'user stays on sign-up form'

    it 'shows password confirmation mismatch error' do
      expect(page).to have_content "Password confirmation doesn't match Password"
    end
  end

  context 'when password is too short' do
    before { register_as_user(user.email, 'short', 'short') }

    include_examples 'user stays on sign-up form'

    it 'shows password too short error' do
      expect(page).to have_content 'Password is too short (minimum is 6 characters)'
    end
  end
end
